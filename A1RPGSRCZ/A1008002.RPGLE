000100210721     H DEBUG
000200210721      *****************************************************************
000300210721/*STD *  RPGBASEMOD                                                   *
000400210721/*EXI *  TEXT('Midas FN Extract TRADSD for consolidated branch')      *
000500210721      *****************************************************************
000600210721      *                                                               *
000700210721      *  Midas - Private Banking Module                               *
000800210721      *                                                               *
000900210721      *  A1008002 - Extract module for TRADSD Consolidated branch     *
001000210721      *                                                               *
001100210721      *  Function:    This module Calls the transaction for           *
001200210721      *               Consolidated Branch                             *
001300210721      *         - It need to retrieve the TRADE Entry queue for Midas *
001400210721      *         - The UDF field for decisions                         *
001500210721      *         - the Market customer and the Consolidated branch     *
001600210721      *         - Settlement qre Blank but Auto settled always Yes    *
001700210721      *         - Auto authorise is As per setup                      *
001800210721      *                                                               *
001900210721      *  Component of: A1008002 Extract program for TRADSD            *
002000210721      *                                                               *
002100210721      *  (c) Finastra International Limited 2021                      *
002200210721      *                                                               *
002300210721      *  Last Amend No. BA1008   *CREATE   Date 03Jun21               *
002400210721      *                                                               *
002500210721      *---------------------------------------------------------------*
002600210721      *                                                               *
002700210721      *  BA1008 - Replication of Trades to consolidated Branches      *
002800210721      *                                                               *
002900210721      *****************************************************************
003000210721      ** +--------------------------------------+
003100210721      ** ¦ F-specs                              ¦
003200210721      ** ¦ =======                              ¦
003300210721      ** +--------------------------------------+
003400210721      **  STANDARD SETTLEMENT
003500210721     FSTDSED    IF   E           K DISK    USROPN  Prefix(S_)
003600210721      **  Midas API ICD
003700210721     FSDAPIPD   IF   E             Disk    USROPN
003800210721      **  Midas Trade details
003900210721     FTRADS     IF   E           K Disk    USROPN
004000210721     FTRADSDY1  IF   E           K Disk    USROPN
004100210721      **  Midas SD API Customer Private Banking Details file.
004200210721     FSDPBDSL0  IF   E           K Disk
004300210721     F                                     Infsr(*Pssr)
004400210721
004500210721      * SE Trade Authorisation
004600210721     FTRAUT     IF   E           K DISK
004700210721     F                                     Infsr(*Pssr)
004800210721
004900210721      **  Midas GL Accounts Master
005000210721     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
005100210721     F                                     Infsr(*Pssr)
005200210721      *
005300210721      **  Midas FN Consolidated Branches
005400210721     FA1CONBL2  IF   E           K Disk    USROPN
005500210721     F                                     Infsr(*Pssr)
005600210721      *
005700210721      /Eject
005800210721      *****************************************************************
005900210721      *                                                               *
006000210721      *          F U N C T I O N   O F   I N D I C A T O R S          *
006100210721      *          -------------------------------------------          *
006200210721      *  55  -  Work Indicator used in array FNbrcaA                  *
006300210721      *  81  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
006400210721      *  82  -  Begin of file TRAUT after ReadPe.                     *
006500210721      *                                                               *
006600210721      *---------------------------------------------------------------*
006700210721      *                                                               *
006800210721      *                  *************************                    *
006900210721      *                  ** INDICATORS NOT USED **                    *
007000210721      *                  *************************                    *
007100210721      *                                                               *
007200210721      *       ***************************************************     *
007300210721      *       * 01   02   03   04   05   06   07   08   09   10 *     *
007400210721      *       * 11   12   13   14   15   16   17   18   19   20 *     *
007500210721      *       * 21   22   23   24   25   26   27   28   29   30 *     *
007600210721      *       * 31   32   33   34   35   36   37   38   39   40 *     *
007700210721      *       * 41   42   43   44   45   46   47   48   49   50 *     *
007800210721      *       * 51   52   53   54   XX   56   57   58   59   60 *     *
007900210721      *       * 61   62   63   64   65   66   67   68   69   70 *     *
008000210721      *       * 71   72   73   74   75   76   77   78   79   80 *     *
008100210721      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
008200210721      *       * 91   92   93   94   95   96   97   98   99      *     *
008300210721      *       ***************************************************     *
008400210721      *                                                               *
008500210721      *****************************************************************
008600210721      /Space 3
008700210721      *****************************************************************
008800210721      *                                                               *
008900210721      *                S U B R O U T I N E   I N D E X                *
009000210721      *                -------------------------------                *
009100210721      *                                                               *
009200210721      *  RtvPos   - retrieve position in Meridian message.            *
009300210721      *  Repair   - Repair process                                    *
009400210721      *  APDataI  - Prepare Insert message                            *
009500210721      *  APHeader = Prepare header message
009600210721      *  APDataD  - Prepare Delete message                            *
009700210721      *  APDataA  - Prepare Amend  message                            *
009800210721      *  APDataD2 - Prepare Delete message for conso Branch 2         *
009900210721      *  APDataA2 - Prepare Amend  message for conso Branch 2         *
010000210721      *  APDataD3 - Prepare Delete message for conso Branch 3         *
010100210721      *  APDataA3 - Prepare Amend  message for conso Branch 3         *
010200210721      *  *Pssr    - Program exception error routine                   *
010300210721      *  *Inzsr   - Program Initialization routine.                   *
010400210721      *                                                               *
010500210721      *****************************************************************
010600210721
010700210721      ** +--------------------------------------+
010800210721      ** ¦ Automatically included D-specs       ¦
010900210721      ** ¦ ==============================       ¦
011000210721      ** +--------------------------------------+
011100210721     D W_Currency      S              3
011200210721     D Traderef        S              6
011300210721     D TradeRTN        S              6
011400210721     D TradeFOI        S             20
011500210721     D TradeOri        S              6
011600210721     D ReturnCodex     S              7
011700210721     D RtnCons         S              1
011800210721     D RtnBook         S              2
011900210721     D WrSUBS          S            100
012000210721     D i               S              3S 0
012100210721     D Pos             S              2S 0
012200210721      *
012300210721     D WrkBook         S              2
012400210721     D RtnCons2        S              1
012500210721     D RtnBook2        S              2
012600210721     D RtnCons3        S              1
012700210721     D RtnBook3        S              2
012800210721     D TradeRTN2       S              6
012900210721     D ReturnCodex2    S              7
013000210721     D TradeRTN3       S              6
013100210721     D ReturnCodex3    S              7
013200210721     D TradeFOI2       S             20
013300210721     D TradeFOI3       S             20
013400210721      *
013500210721      **--------------------------------------------------------------------------------------------
013600210721      ** The following /COPY line includes all the defined fields in the
013700210721      ** Program Status Data Structures.  They have meaningful
013800210721      ** names, prefixed by 'PS'.
013900210721     D/COPY ZACPYSRC,PSDS
014000210721      **--------------------------------------------------------------------------------------------
014100210721
014200210721      ** The following /COPY contains various standard declares
014300210721     C/COPY RPCPYSRC,STD_DCL
014400210721
014500210721      ** The following /COPY contains the layout of the Meridian header as
014600210721      ** a data structure
014700210721     C/COPY RPCPYSRC,MDN_HD_DS
014800210721
014900210721      ** Following /COPY is the declares for fields passed to the formatting
015000210721      ** routines
015100210721     C/COPY RPCPYSRC,RPFMTDCL
015200210721
015300210721      ** Following /COPY is the procedure prototype for the Packed routine
015400210721     C/COPY RPCPYSRC,RPFMTPPP
015500210721
015600210721      ** Following /COPY is the procedure prototype for the Signed routine
015700210721     C/COPY RPCPYSRC,RPFMTPPS
015800210721
015900210721      ** +--------------------------------------+
016000210721      ** ¦ End of automatically included D-specs¦
016100210721      ** ¦ =====================================¦
016200210721      ** +--------------------------------------+
016300210721
016400210721      *****************************************************************
016500210721      /Eject
016600210721      *****************************************************************
016700210721
016800210721      ** +--------------------------------------+
016900210721      ** ¦ Manually included D-specs            ¦
017000210721      ** ¦ =========================            ¦
017100210721      ** +--------------------------------------+
017200210721
017300210721      ** +--------------------------------------+
017400210721      ** ¦ Arrays and Data Structures           ¦
017500210721      ** ¦ ==========================           ¦
017600210721      ** +--------------------------------------+
017700210721
017800210721      **  Array containing Copyright statement.
017900210721     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)
018000210721
018100210721      ** Midas Local Data Area for database error reporting; based on
018200210721      ** external file
018300210721     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
018400210721      ** The following fields are defined in the external file:
018500210721      **                                    134 141 DBFile
018600210721      **                                    142 170 DBKey
018700210721      **                                    171 180 DBPgm
018800210721      **                                    181 1830DBase
018900210721      **                                    184 193 DBMod
019000210721      **                                    194 203 DBProc
019100210721
019200210721      **  Arrays used to store Position and Length of each fields
019300210721     D ArrFld          S              6    Dim(100)
019400210721     D ArrPos          S              7  0 Dim(100)
019500210721     D ArrLen          S              4  0 Dim(100)
019600210721
019700210721     D Z               S              1S 0
019800210721     D FNsetup         S              1A
019900210721     D FNudfE1         S              9A   INZ('UDFTRAD07')
020000210721     D FNudfE2         S              9A   INZ('UDFTRAD12')
020100210721     D FNudfE3         S              9A   INZ('UDFTRAD15')
020200210721      ** Setup Array to store details of the 3 consolidated branches
020300210721     D FNbrcaA         S              3A   DIM(3) INZ(*Blanks)
020400210721     D FNfoirA         S             14A   DIM(3) INZ(*Blanks)
020500210721
020600210721      ** Replication Defaults Data Area; based on external file.
020700210721     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
020800210721
020900210721      ** API DUMP Information Data Area for database error reporting;
021000210721      ** based on external file
021100210721     D Apdump        E DS                  Extname(APDUMP) DTAARA(APDUMP)
021200210721
021300210721      **  Data structure used to group settlement account details.
021400210721     D W_NOML          DS            11
021500210721     D   W_N1                  1      1
021600210721     D   W_N2                  2      2
021700210721     D   W_N3                  3      3
021800210721     D   W_N4                  4      4
021900210721     D   W_N5                  5      5
022000210721     D   W_N6                  6      6
022100210721     D   W_N7                  7      7
022200210721     D   W_N8                  8      8
022300210721     D   W_N9                  9      9
022400210721     D   W_N10                10     10
022500210721     D   W_N11                11     11
022600210721     D   W_NOML0               1     11
022700210721     D   W_NOML1               1     10
022800210721     D   W_NOML2               1      9
022900210721     D   W_NOML3               1      8
023000210721     D   W_NOML4               1      7
023100210721     D   W_NDec1              11     11
023200210721     D   W_NDec2              10     11
023300210721     D   W_NDec3               9     11
023400210721     D   W_NDec4               8     11
023500210721      *
023600210721     D W_ChgL          DS            13
023700210721     D   W_ChgL0               1     13
023800210721     D   W_ChgL1               1     12
023900210721     D   W_ChgL2               1     11
024000210721     D   W_ChgL3               1     10
024100210721     D   W_CDec1              13     13
024200210721     D   W_CDec2              12     13
024300210721     D   W_CDec3              11     13
024400210721      *
024500210721     D W_1508          DS            15
024600210721     D   W_I1                  1      1
024700210721     D   W_I2                  2      2
024800210721     D   W_I3                  3      3
024900210721     D   W_I4                  4      4
025000210721     D   W_I5                  5      5
025100210721     D   W_I6                  6      6
025200210721     D   W_1308                3     15
025300210721     D   W_Int05               3      7
025400210721     D   W_Int07               1      7
025500210721     D   W_Dec08               8     15
025600210721      *
025700210721     D W_0905          DS             9
025800210721     D   W_RALLI               1      4
025900210721     D   W_RALLD               5      9
026000210721     D SettldO       E DS                  Extname(STDSED)  Prefix(S_)
026100210721      ** Data Structure for Original trade details
026200210721     D TradsdO       E DS                  Extname(TRADSD) Prefix(O_)
026300210721     D TradsdC       E DS                  Extname(TRADSD) Prefix(C_)
026400210721     D Tradsd        E DS                  Extname(TRADSD)
026500210721     D TradsdxO      E DS                  Extname(TRADSDX1) Prefix(O_)
026600210721     D TradsdxC      E DS                  Extname(TRADSDX1) Prefix(C_)
026700210721     D Tradsdx       E DS                  Extname(TRADSDX1)
026800210721      *
026900210721     D TradsdC2      E DS                  Extname(TRADSD) Prefix(C2)
027000210721     D TradsdxC2     E DS                  Extname(TRADSDX1) Prefix(C2)
027100210721     D TradsdC3      E DS                  Extname(TRADSD) Prefix(C3)
027200210721     D TradsdxC3     E DS                  Extname(TRADSDX1) Prefix(C3)
027300210721      *
027400210721      ** Data Structure for access to Customer Details.
027500210721     D Sdsecs        E DS                  Extname(SDSECSPD)
027600210721
027700210721      ** Data Structure for access to Currency Details.
027800210721     D Sdcurr        E DS                  Extname(SDCURRPD)
027900210721
028000210721      ** Data Structure for access to Securities I.C.D. details
028100210721     D Sdstrd        E DS                  Extname(SDSTRDPD)
028200210721
028300210721      ** Data Structure for access to Private Banking I.C.D. details
028400210721     D Sdtofd        E DS                  Extname(SDTOFPD)
028500210721
028600210721      ** Data Structure for access to switchable features
028700210721     D SCSARD        E DS                  EXTNAME(SCSARDPD)
028800210721     D LCDSC         E                     EXTFLD(LCD)
028900210721
029000210721      **  First Data Structure for Access Programs, short Data Structure.
029100210721     D Dsfdy         E DS                  Extname(DSFDY)
029200210721
029300210721      **  Second Data Structure foR Access Programs, long Data Structure.
029400210721     D Dssdy         E DS                  Extname(DSSDY)
029500210721
029600210721     D Dsldy         E DS                  Extname(DSLDY)
029700210721      ** DS for Access Programs, Extend Data Structure
029800210721
029900210721      ** +--------------------------------------+
030000210721      ** ¦ Declared variables                   ¦
030100210721      ** ¦ ==================                   ¦
030200210721      ** +--------------------------------------+
030300210721
030400210721      **-------------------- Start of Parameters --------------------**
030500210721      **  Output queue name.
030600210721     D OutQueue        S                   LIKE(MQSQueue)
030700210721     D OutQueueB       S                   LIKE(MQSQueue)
030800210721      **--------------------- End of Parameters ---------------------**
030900210721
031000210721      **-------------- Start of Parameters for RPC1305 --------------**
031100210721      **  Script Name.
031200210721     D ScriptName      S             10A
031300210721      **  Image Name.
031400210721     D ImageName       S             32A
031500210721      **  Field Name.
031600210721     D FieldName       S             10A
031700210721      **  Field Type.
031800210721     D FieldType       S              1A
031900210721      **  Field Value.
032000210721     D FieldValue      S           9999A
032100210721      **  Field Position.
032200210721     D FieldPosition   S              7S 0
032300210721      **  Field Length
032400210721     D FieldLength     S              4S 0
032500210721      **--------------- End of Parameters for RPC1305 ---------------**
032600210721      **---------------- start of Parameters for CPB010 --------------**
032700210721     D MessageInd      S              1A
032800210721
032900210721     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
033000210721
033100210721      **   Database Error Messsage Text
033200210721     D DBErrText       S            256A
033300210721
033400210721      **   Transaction Data of associated transaction
033500210721     D AssocData       S                   LIKE(TransData)
033600210721     D AssocDataB      S                   LIKE(TransData)
033700210721     D TransDataB      S                   LIKE(TransData)
033800210721     D AssocDataB2     S                   LIKE(TransData)
033900210721     D AssocDataB3     S                   LIKE(TransData)
034000210721
034100210721      **   Meridian header Layout of associated transaction
034200210721     D MdHdAssoc       S                   LIKE(MdnHeadDs)
034300210721     D MdHdAssocB      S                   LIKE(MdnHeadDs)
034400210721     D MdnHeadDsB      S                   LIKE(MdnHeadDs)
034500210721     D CommitCtlB      S                   LIKE(CommitCtl)
034600210721     D MdHdAssocB2     S                   LIKE(MdnHeadDs)
034700210721     D MdHdAssocB3     S                   LIKE(MdnHeadDs)
034800210721     D ApHdmsg         DS           200
034900210721     D   ApMSGT                1     32
035000210721     D   ApSRCS               33     40
035100210721     D   ApORIG               41     72
035200210721     D   ApTGTS               73     80
035300210721     D   ApUSER               81     90
035400210721     D   ApPASS               91    100
035500210721     D   ApFORM              101    108
035600210721     D   ApVERS              109    116
035700210721     D   ApRPYQ              117    136
035800210721     D   ApRESP              137    137
035900210721     D   ApMAPL              138    138
036000210721     D   ApFRNT              139    158
036100210721     D   ApASOC              159    178
036200210721     D   ApRESPN             179    179
036300210721     D   ApMAPLB             180    180
036400210721     D   APFIL               181    200
036500210721     D ApDtmsg         DS          8000
036600210721     D   A_DDACTN              1      1
036700210721     D   A_DDTDRF              2      7
036800210721     D   A_DDBLKR              8     13
036900210721     D   A_DDSESN             14     23
037000210721     D   A_DDCNUM             24     33
037100210721     D   A_DDCSSN             34     43
037200210721     D   A_DDCRNM             44     63
037300210721     D   A_DDCRTN             64     73
037400210721     D   A_DDINCS             74     74
037500210721     D   A_DDTDTP             75     76
037600210721     D   A_DDNOML             77     88
037700210721     D   A_DDTPDY             89    104
037800210721     D   A_DDTDVD            105    111
037900210721     D   A_DDBRCD            112    114
038000210721     D   A_DDBPBK            115    116
038100210721     D   A_DDCLTY            117    117
038200210721     D   A_DDSETC            118    120
038300210721     D   A_DDRALL            121    131
038400210721     D   A_DDMRKT            132    133
038500210721     D   A_DDCPCY            134    134
038600210721     D   A_DDPRIC            135    151
038700210721     D   A_DDEXDV            152    152
038800210721     D   A_DDFSPR            153    168
038900210721     D   A_DDBPRC            169    172
039000210721     D   A_DDTPRC            173    176
039100210721     D   A_DDTDID            177    179
039200210721     D   A_DDTDDT            180    186
039300210721     D   A_DDTSUB            187    188
039400210721     D   A_DDLKRF            189    194
039500210721     D   A_DDTDMI            195    195
039600210721     D   A_DDAIIP            196    196
039700210721     D   A_DDTDNR            197    231
039800210721     D   A_DDORDE            232    237
039900210721     D   A_DDACIN            238    238
040000210721     D   A_DDDADJ            239    243
040100210721     D   A_DDACTD            244    244
040200210721     D   A_DDITRA            245    259
040300210721     D   A_DDINOR            260    265
040400210721     D   A_DDMSGK            266    305
040500210721     D   A_DDNTMT            306    312
040600210721     D   A_DDNOM1            313    324
040700210721     D   A_DDTDV1            325    331
040800210721     D   A_DDACI1            332    332
040900210721     D   A_DDDAD1            333    337
041000210721     D   A_DDACT1            338    338
041100210721     D   A_DDITR1            339    353
041200210721     D   A_DDTDER            354    368
041300210721     D   A_DDSMDI            369    369
041400210721     D   A_DDFXMP            370    377
041500210721     D   A_DDBRTE            378    392
041600210721     D   A_DDSMTH            393    394
041700210721     D   A_DDORBR            395    397
041800210721     D   A_DDPYFM            398    415
041900210721     D   A_DDPFSN            416    425
042000210721     D   A_DDPFNM            426    445
042100210721     D   A_DDPFTN            446    455
042200210721     D   A_DDPFAN            456    475
042300210721     D   A_DDPFSW            476    487
042400210721     D   A_DDPYFB            488    490
042500210721     D   A_DDPAYT            491    508
042600210721     D   A_DDPTSN            509    518
042700210721     D   A_DDPTNM            519    538
042800210721     D   A_DDPTTN            539    548
042900210721     D   A_DDPTAN            549    568
043000210721     D   A_DDPTSI            569    580
043100210721     D   A_DDPYTB            581    583
043200210721     D   A_DDTDFA            584    593
043300210721     D   A_DDFASN            594    603
043400210721     D   A_DDFANM            604    623
043500210721     D   A_DDFATN            624    633
043600210721     D   A_DDFASW            634    645
043700210721     D   A_DDASNM            646    647
043800210721     D   A_DDDELF            648    657
043900210721     D   A_DDDFSN            658    667
044000210721     D   A_DDDFNM            668    687
044100210721     D   A_DDDFTN            688    697
044200210721     D   A_DDDFSI            698    709
044300210721     D   A_DDDELT            710    719
044400210721     D   A_DDDTSN            720    729
044500210721     D   A_DDDTNM            730    749
044600210721     D   A_DDDTTN            750    759
044700210721     D   A_DDDTSI            760    771
044800210721     D   A_DDDFFA            772    781
044900210721     D   A_DDD1SN            782    791
045000210721     D   A_DDD1NM            792    811
045100210721     D   A_DDD1TN            812    821
045200210721     D   A_DDD1SI            822    833
045300210721     D   A_DDDTFA            834    843
045400210721     D   A_DDD2SN            844    853
045500210721     D   A_DDD2NM            854    873
045600210721     D   A_DDD2TN            874    883
045700210721     D   A_DDD2SI            884    895
045800210721     D   A_DDTDSI            896    928
045900210721     D   A_DDCLTY2           929    929
046000210721     D   A_DDICCY            930    932
046100210721     D   A_DDPRFC            933    936
046200210721     D   A_DDPRYC            937    937
046300210721     D   A_DDPCOD            938    938
046400210721     D   A_DDAUTS            939    939
046500210721     D   A_DDTBCC            940    941
046600210721     D   A_DDTBCA            942    955
046700210721     D   A_DDTCCC            956    957
046800210721     D   A_DDTCCA            958    971
046900210721     D   A_DDTCC1            972    973
047000210721     D   A_DDTCA1            974    987
047100210721     D   A_DDTCC2            988    989
047200210721     D   A_DDTCA2            990   1003
047300210721     D   A_DDTCC3           1004   1005
047400210721     D   A_DDTCA3           1006   1019
047500210721     D   A_DDTCC4           1020   1021
047600210721     D   A_DDTCA4           1022   1035
047700210721     D   A_DDTCC5           1036   1037
047800210721     D   A_DDTCA5           1038   1051
047900210721     D   A_DDTCC6           1052   1053
048000210721     D   A_DDTCA6           1054   1067
048100210721     D   A_DDTCC7           1068   1069
048200210721     D   A_DDTCA7           1070   1083
048300210721     d   A_DDTAXA           1084   1097
048400210721     D   A_DDEUTX           1098   1113
048500210721     D   A_DDBCMR           1114   1127
048600210721     D   A_DDCCMR           1128   1141
048700210721     D   A_DDTXRB           1142   1155
048800210721     D   A_DDPTFR           1156   1159
048900210721     D   A_ADDGMES          1160   1160
049000210721     D   A_ADDTRTT          1161   1164
049100210721     D   A_ADDINST          1165   1167
049200210721     D   A_ADDINSS          1168   1172
049300210721     D   A_ADDEUCL          1173   1182
049400210721     D   A_ADDSAFA          1183   1188
049500210721     D   A_ADDRPTY          1189   1189
049600210721     D   A_ADDGDEL          1190   1190
049700210721     D   A_ADDSROL          1191   1194
049800210721     D   A_ADDFCOD          1195   1195
049900210721     D   A_ADDFTID          1196   1196
050000210721     D   A_ADDGMEC          1197   1197
050100210721     D   A_ADDCCID          1198   1198
050200210721     D   A_ADDFID1          1199   1206
050300210721     D   A_ADDIORA          1207   1207
050400210721     D   A_ADDSNEW          1208   1208
050500210721     D   A_ADDSTMP          1209   1212
050600210721     D   A_ADDCHID          1213   1242
050700210721     D   A_ADDTRRM          1243   1246
050800210721     D   A_BDDGMES          1247   1247
050900210721     D   A_BDDTRTT          1248   1251
051000210721     D   A_BDDINST          1252   1254
051100210721     D   A_BDDINSS          1255   1259
051200210721     D   A_BDDEUCL          1260   1269
051300210721     D   A_BDDSAFA          1270   1275
051400210721     D   A_BDDRPTY          1276   1276
051500210721     D   A_BDDGDEL          1277   1277
051600210721     D   A_BDDSROL          1278   1281
051700210721     D   A_BDDFCOD          1282   1282
051800210721     D   A_BDDFTID          1283   1283
051900210721     D   A_BDDGMEC          1284   1284
052000210721     D   A_BDDCCID          1285   1285
052100210721     D   A_BDDFID1          1286   1293
052200210721     D   A_BDDIORA          1294   1294
052300210721     D   A_BDDSNEW          1295   1295
052400210721     D   A_BDDSTMP          1296   1299
052500210721     D   A_BDDCHID          1300   1329
052600210721     D   A_BDDTRRM          1330   1333
052700210721     D   A_AESAP1N          1334   1343
052800210721     D   A_DDA1SN           1344   1353
052900210721     D   A_DDA1NM           1354   1373
053000210721     D   A_DDA1TN           1374   1383
053100210721     D   A_DDA1SI           1384   1395
053200210721     D   A_AESAP1L          1396   1430
053300210721     D   A_AESAP2N          1431   1440
053400210721     D   A_DDA2SN           1441   1450
053500210721     D   A_DDA2NM           1451   1470
053600210721     D   A_DDA2TN           1471   1480
053700210721     D   A_DDA2SI           1481   1492
053800210721     D   A_AESAP2L          1493   1527
053900210721     D   A_AESAWIN          1528   1537
054000210721     D   A_DDAISN           1538   1547
054100210721     D   A_DDAINM           1548   1567
054200210721     D   A_DDAITN           1568   1577
054300210721     D   A_DDAISI           1578   1589
054400210721     D   A_AESAWIL          1590   1624
054500210721     D   A_AESBOFN          1625   1634
054600210721     D   A_DDBMSN           1635   1644
054700210721     D   A_DDBMNM           1645   1664
054800210721     D   A_DDBMTN           1665   1674
054900210721     D   A_DDBMSI           1675   1686
055000210721     D   A_AESBOF1          1687   1721
055100210721     D   A_AESBOF2          1722   1756
055200210721     D   A_AESACL1          1757   1791
055300210721     D   A_AESACL2          1792   1826
055400210721     D   A_AESSRL1          1827   1861
055500210721     D   A_AESSRL2          1862   1896
055600210721     D   A_AESSRL3          1897   1931
055700210721     D   A_AESFIN1          1932   1966
055800210721     D   A_AESFIN2          1967   2001
055900210721     D   A_AESRED1          2002   2036
056000210721     D   A_AESRED2          2037   2071
056100210721     D   A_AESNAL1          2072   2106
056200210721     D   A_AESNAL2          2107   2141
056300210721     D   A_AESIPYN          2142   2151
056400210721     D   A_DDIPSN           2152   2161
056500210721     D   A_DDIPNM           2162   2181
056600210721     D   A_DDIPTN           2182   2191
056700210721     D   A_DDIPSI           2192   2203
056800210721     D   A_AESIPYL          2204   2238
056900210721     D   A_AESCTYN          2239   2248
057000210721     D   A_AESCTYL          2249   2283
057100210721     D   A_AESSA1N          2284   2293
057200210721     D   A_DDCZSN           2294   2303
057300210721     D   A_DDCSNM           2304   2323
057400210721     D   A_DDCSTN           2324   2333
057500210721     D   A_DDCSSI           2334   2345
057600210721     D   A_AESSA1L          2346   2380
057700210721     D   A_AESSKAN          2381   2390
057800210721     D   A_DDUSSN           2391   2400
057900210721     D   A_DDUSNM           2401   2420
058000210721     D   A_DDUSTN           2421   2430
058100210721     D   A_DDUSSI           2431   2442
058200210721     D   A_AESSKAL          2443   2477
058300210721     D   A_AESCCTN          2478   2489
058400210721     D   A_DDCCSN           2490   2499
058500210721     D   A_DDCCNM           2500   2519
058600210721     D   A_DDCCTN           2520   2529
058700210721     D   A_DDCCSI           2530   2541
058800210721     D   A_AESDCTL          2542   2547
058900210721     D   A_AESRSSN          2548   2557
059000210721     D   A_DDRSSN           2558   2567
059100210721     D   A_DDRSNM           2568   2587
059200210721     D   A_DDRSTN           2588   2597
059300210721     D   A_DDRSSI           2598   2609
059400210721     D   A_AESRSS1          2610   2644
059500210721     D   A_AESRSS2          2645   2679
059600210721     D   A_AESRSS3          2680   2714
059700210721     D   A_AESRSS4          2715   2749
059800210721     D   A_AESDSSN          2750   2759
059900210721     D   A_AESDSS1          2760   2794
060000210721     D   A_AESDSS2          2795   2829
060100210721     D   A_AESDSS3          2830   2864
060200210721     D   A_AESDSS4          2865   2899
060300210721     D   A_AESBSSN          2900   2909
060400210721     D   A_AESBSS1          2910   2944
060500210721     D   A_AESBSS2          2945   2979
060600210721     D   A_AESINVE          2980   2989
060700210721     D   A_DDIOSN           2990   2999
060800210721     D   A_DDIONM           3000   3019
060900210721     D   A_DDIOTN           3020   3029
061000210721     D   A_DDIOSI           3030   3041
061100210721     D   A_AESIMMD1         3042   3053
061200210721     D   A_DDI1SN           3054   3063
061300210721     D   A_DDI1NM           3064   3083
061400210721     D   A_DDI1TN           3084   3093
061500210721     D   A_DDI1SI           3094   3105
061600210721     D   A_AESIMSA1         3106   3125
061700210721     D   A_AESIMMD2         3126   3137
061800210721     D   A_DDI2SN           3138   3147
061900210721     D   A_DDI2NM           3148   3167
062000210721     D   A_DDI2TN           3168   3177
062100210721     D   A_DDI2SI           3178   3189
062200210721     D   A_AESIMSA2         3190   3209
062300210721     D   A_AESIMMD3         3210   3221
062400210721     D   A_AESIMSA3         3222   3241
062500210721     D   A_AESIMMD4         3242   3253
062600210721     D   A_AESIMSA4         3254   3273
062700210721     D   A_AESIMMD5         3274   3285
062800210721     D   A_AESIMSA5         3286   3305
062900210721     D   A_AESIMMD6         3306   3317
063000210721     D   A_AESIMSA6         3318   3337
063100210721     D   A_AESIMMD7         3338   3349
063200210721     D   A_AESIMSA7         3350   3369
063300210721     D   A_AESIMMD8         3370   3381
063400210721     D   A_AESIMSA8         3382   3401
063500210721     D   A_AESIMMD9         3402   3413
063600210721     D   A_AESIMSA9         3414   3433
063700210721     D   A_AESPSET          3434   3445
063800210721     D   A_DDPSSN           3446   3455
063900210721     D   A_DDPSNM           3456   3475
064000210721     D   A_DDPSTN           3476   3485
064100210721     D   A_DDPSSI           3486   3497
064200210721     D   A_AESNAC1          3498   3532
064300210721     D   A_AESNAC2          3533   3567
064400210721     D   A_AESDIDN          3568   3577
064500210721     D   A_AESDAD1          3578   3612
064600210721     D   A_AESDAD2          3613   3647
064700210721     D   A_AESDAD3          3648   3682
064800210721     D   A_AESDAD4          3683   3717
064900210721     D   A_AESDLIN          3718   3752
065000210721     D   A_AESQFIN          3753   3762
065100210721     D   A_AESPCLR          3763   3772
065200210721     D   A_BESAP1N          3773   3782
065300210721     D   A_BDA1SN           3783   3792
065400210721     D   A_BDA1NM           3793   3812
065500210721     D   A_BDA1TN           3813   3822
065600210721     D   A_BDA1SI           3823   3834
065700210721     D   A_BESAP1L          3835   3869
065800210721     D   A_BESAP2N          3870   3879
065900210721     D   A_BDA2SN           3880   3889
066000210721     D   A_BDA2NM           3890   3909
066100210721     D   A_BDA2TN           3910   3919
066200210721     D   A_BDA2SI           3920   3931
066300210721     D   A_BESAP2L          3932   3966
066400210721     D   A_BESAWIN          3967   3976
066500210721     D   A_BDAISN           3977   3986
066600210721     D   A_BDAINM           3987   4006
066700210721     D   A_BDAITN           4007   4016
066800210721     D   A_BDAISI           4017   4028
066900210721     D   A_BESAWIL          4029   4063
067000210721     D   A_BESBOFN          4064   4073
067100210721     D   A_BDBMSN           4074   4083
067200210721     D   A_BDBMNM           4084   4103
067300210721     D   A_BDBMTN           4104   4113
067400210721     D   A_BDBMSI           4114   4125
067500210721     D   A_BESBOF1          4126   4160
067600210721     D   A_BESBOF2          4161   4195
067700210721     D   A_BESACL1          4196   4230
067800210721     D   A_BESACL2          4231   4265
067900210721     D   A_BESSRL1          4266   4300
068000210721     D   A_BESSRL2          4301   4335
068100210721     D   A_BESSRL3          4336   4370
068200210721     D   A_BESFIN1          4371   4405
068300210721     D   A_BESFIN2          4406   4440
068400210721     D   A_BESRED1          4441   4475
068500210721     D   A_BESRED2          4476   4510
068600210721     D   A_BESNAL1          4511   4545
068700210721     D   A_BESNAL2          4546   4580
068800210721     D   A_BESIPYN          4590   4590
068900210721     D   A_BDIPSN           4600   4600
069000210721     D   A_BDIPNM           4620   4620
069100210721     D   A_BDIPTN           4630   4630
069200210721     D   A_BDIPSI           4642   4642
069300210721     D   A_BESIPYL          4677   4677
069400210721     D   A_BESCTYN          4687   4687
069500210721     D   A_BESCTYL          4722   4722
069600210721     D   A_BESSA1N          4732   4732
069700210721     D   A_BDCZSN           4742   4742
069800210721     D   A_BDCSNM           4762   4762
069900210721     D   A_BDCSTN           4772   4772
070000210721     D   A_BDCSSI           4784   4784
070100210721     D   A_BESSA1L          4819   4819
070200210721     D   A_BESSKAN          4829   4829
070300210721     D   A_BDUSSN           4839   4839
070400210721     D   A_BDUSNM           4859   4859
070500210721     D   A_BDUSTN           4869   4869
070600210721     D   A_BDUSSI           4881   4881
070700210721     D   A_BESSKAL          4916   4916
070800210721     D   A_BESCCTN          4928   4928
070900210721     D   A_BDCCSN           4938   4938
071000210721     D   A_BDCCNM           4958   4958
071100210721     D   A_BDCCTN           4959   4968
071200210721     D   A_BDCCSI           4969   4980
071300210721     D   A_BESDCTL          4981   4986
071400210721     D   A_BESRSSN          4987   4996
071500210721     D   A_BDRSSN           4997   5006
071600210721     D   A_BDRSNM           5007   5026
071700210721     D   A_BDRSTN           5027   5036
071800210721     D   A_BDRSSI           5037   5048
071900210721     D   A_BESRSS1          5049   5083
072000210721     D   A_BESRSS2          5084   5118
072100210721     D   A_BESRSS3          5119   5153
072200210721     D   A_BESRSS4          5154   5188
072300210721     D   A_BESDSSN          5189   5198
072400210721     D   A_BESDSS1          5199   5233
072500210721     D   A_BESDSS2          5234   5268
072600210721     D   A_BESDSS3          5269   5303
072700210721     D   A_BESDSS4          5304   5338
072800210721     D   A_BESBSSN          5339   5348
072900210721     D   A_BESBSS1          5349   5383
073000210721     D   A_BESBSS2          5384   5418
073100210721     D   A_BESINVE          5419   5428
073200210721     D   A_BDIOSN           5429   5438
073300210721     D   A_BDIONM           5439   5458
073400210721     D   A_BDIOTN           5459   5468
073500210721     D   A_BDIOSI           5469   5480
073600210721     D   A_BESIMMD1         5481   5492
073700210721     D   A_BDI1SN           5493   5502
073800210721     D   A_BDI1NM           5503   5522
073900210721     D   A_BDI1TN           5523   5532
074000210721     D   A_BDI1SI           5533   5544
074100210721     D   A_BESIMSA1         5545   5564
074200210721     D   A_BESIMMD2         5565   5576
074300210721     D   A_BDI2SN           5577   5586
074400210721     D   A_BDI2NM           5587   5606
074500210721     D   A_BDI2TN           5607   5616
074600210721     D   A_BDI2SI           5617   5628
074700210721     D   A_BESIMSA2         5629   5648
074800210721     D   A_BESIMMD3         5649   5660
074900210721     D   A_BESIMSA3         5661   5680
075000210721     D   A_BESIMMD4         5681   5692
075100210721     D   A_BESIMSA4         5693   5712
075200210721     D   A_BESIMMD5         5713   5724
075300210721     D   A_BESIMSA5         5725   5744
075400210721     D   A_BESIMMD6         5745   5756
075500210721     D   A_BESIMSA6         5757   5776
075600210721     D   A_BESIMMD7         5777   5788
075700210721     D   A_BESIMSA7         5789   5808
075800210721     D   A_BESIMMD8         5809   5820
075900210721     D   A_BESIMSA8         5821   5840
076000210721     D   A_BESIMMD9         5841   5852
076100210721     D   A_BESIMSA9         5853   5872
076200210721     D   A_BESPSET          5873   5884
076300210721     D   A_BDPSSN           5885   5894
076400210721     D   A_BDPSNM           5895   5914
076500210721     D   A_BDPSTN           5915   5924
076600210721     D   A_BDPSSI           5925   5936
076700210721     D   A_BESNAC1          5937   5971
076800210721     D   A_BESNAC2          5972   6006
076900210721     D   A_BESDIDN          6007   6016
077000210721     D   A_BESDAD1          6017   6051
077100210721     D   A_BESDAD2          6052   6086
077200210721     D   A_BESDAD3          6087   6121
077300210721     D   A_BESDAD4          6122   6156
077400210721     D   A_BESDLIN          6157   6191
077500210721     D   A_BESQFIN          6192   6201
077600210721     D   A_BESPCLR          6202   6211
077700210721     D   A_DDCRSK           6212   6228
077800210721     D   A_DDLQPR           6229   6245
077900210721     D   A_DDITRN           6246   6260
078000210721     D   A_TMSP             6261   6286
078100210721     D   A_BDSPBS           6287   6287
078200210721     D   A_STBS             6288   6288
078300210721     D   A_PROT             6289   6289
078400210721     D   A_NMCY             6290   6292
078500210721     D   A_C1DI             6293   6293
078600210721     D   A_BVAUTH           6294   6295
078700210721     D   A_DDCPNR           6296   6308
078800210721     D   A_DDTCTR           6309   6329
078900210721     D   A_DDCFCT           6330   6341
079000210721     D   A_ADDROUS          6342   6347
079100210721     D   A_ADDROTS          6348   6359
079200210721     D   A_ADDROUC          6360   6365
079300210721     D   A_ADDROTC          6366   6377
079400210721     D   A_BDDROUS          6378   6383
079500210721     D   A_BDDROTS          6384   6395
079600210721     D   A_BDDROUC          6396   6401
079700210721     D   A_BDDROTC          6402   6413
079800210721     D   A_DDSPXR           6414   6427
079900210721     D   A_DDSPMD           6428   6428
080000210721     D   A_DDWTAX           6429   6443
080100210721     D   A_BKEURO           6444   6446
080200210721     D   A_DDSTAT           6447   6455
080300210721     D   A_DDAUTH           6456   6469
080400210721     D   A_SITP             6470   6472
080500210721     D   A_DDPRICN          6473   6489
080600210721     D   A_DDHACR           6490   6502
080700210721     D   A_DDTCSR           6503   6517
080800210721     D   A_DDDAYS           6518   6520
080900210721     D   A_DDFOID           6521   6540
081000210721     D   A_TQTAX            6541   6541
081100210721     D   A_TQSTAF           6542   6554
081200210721     D   A_TQCDTE           6555   6560
081300210721     D   A_AUTH             6561   6561
081400210721     D   A_TOFfil           6562   6610
081500210721      **   Image Type - Amend Before, Amend After or Insert
081600210721     D ImageType       S             20A
081700210721     D ImageTypeB      S             20A
081800210721     D ImageTypeB2     S             20A
081900210721     D ImageTypeB3     S             20A
082000210721      **----------------  End of Parameters for CPB010  --------------**
082100210721
082200210721      **------------ Start of parameters for ZAGETSETAC -------------**
082300210721      **  -------
082400210721      **  Outputs
082500210721      **  -------
082600210721      **  Account code.
082700210721     D AccCode         S             10S 0
082800210721      **  Account sequence.
082900210721     D AccSeq          S              2S 0
083000210721      **  MEMOS update required.
083100210721     D MemosInd        S              1A
083200210721      **  PRONO update required.
083300210721     D PronoInd        S              1A
083400210721      **  ------------
083500210721      **  Input/output
083600210721      **  ------------
083700210721      **  Transaction branch.
083800210721     D Branch          S              3A
083900210721      **  Tansaction customer.
084000210721     D CustNo          S              6A
084100210721      **  Settlement currency.
084200210721     D Currency        S              3A
084300210721      **  ------
084400210721      **  Inputs
084500210721      **  ------
084600210721      **  Settlement type.
084700210721     D SettleType      S              2S 0
084800210721      **  Settlement account.
084900210721     D SettleAcc       DS            18
085000210721     D   WW_AccNum             1      6
085100210721     D   WW_AccCode            7     16
085200210721     D   WW_AccSeq            17     18
085300210721
085400210721      **------------- End of parameters for ZAGETSETAC --------------**
085500210721
085600210721      ** --------- Start of fields used by access programs ----------**
085700210721      **  Return code.
085800210721     D P_RtCd          S              7A
085900210721     D ReturnCodeB     S              7A
086000210721      **  Option.
086100210721     D P_Optn          S              7A
086200210721      **  Customer.
086300210721     D P_Cust          S              6A
086400210721      **  Key status.
086500210721     D P_Kyst          S              7A
086600210721      ** ---------- End of fields used by access programs -----------**
086700210721
086800210721      **  Work Field used as position for each numeric fields
086900210721     D W_PosDebut      S              2S 0
087000210721     D fmDpLen         S              1A
087100210721
087200210721      **  End Position.
087300210721     D EndPosition     S              7S 0
087400210721
087500210721      **  Work Field used as key to access to Customer PB Details.
087600210721     D K_CustNum       S              6A
087700210721
087800210721      **  Work field used to access to SE Trade Authorization.
087900210721     D K_TradeRef      S              6A
088000210721
088100210721      **  Work field used to access to SE Trade incomplete/complete indicator
088200210721     D K_Tinc          S              1A
088300210721
088400210721      **  Work field used to access to SE Trade RECI
088500210721     D K_Reci          S              1A
088600210721
088700210721      **  Work field used to store Incomplete Ind before update
088800210721     D B_Tinc          S              1A
088900210721      **  Work field used to store If 1st authorisation is done
089000210721     D W_OneAut        S              1A
089100210721      **  Work field used to store Private Banking Order Number.
089200210721     D W_OrderNumber   S              6S 0
089300210721
089400210721      **  Work field used to retrieve Trade type
089500210721     D W_Type          S              2A
089600210721
089700210721      **----------------  Start of additional fields ----------------**
089800210721     D W_NomCcyNbdp    S              1A
089900210721     D W_PayFrSettAcc  S             24A
090000210721     D W_PayFrSettPor  S              4A
090100210721     D W_PayToSettAcc  S             24A
090200210721     D W_PayToSettPor  S              4A
090300210721      **-----------------  End of additional fields -----------------**
090400210721
090500210721      **  Work Field used to condition Meridian message sending.
090600210721     D W_SendMsg       S              1A
090700210721
090800210721      **   Composite Data
090900210721     D CompData        S                   LIKE(TransData)
091000210721     D CompDataB       S                   LIKE(TransData)
091100210721
091200210721      ** True and False can be used for indicators being on or off.
091300210721     D True            C                   *On
091400210721     D False           C                   *Off
091500210721
091600210721      **  Work Field used to produce only one dump.
091700210721     D W_RunBefore     S              1A
091800210721
091900210721      **  Work field used to set up return code when no record found.
092000210721     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
092100210721
092200210721      **  Work field used for change message type
092300210721     D W_PosFin        S              3S 0
092400210721
092500210721      ** +--------------------------------------+
092600210721      ** ¦ End of D-specs                       ¦
092700210721      ** ¦ ==============                       ¦
092800210721      ** +--------------------------------------+
092900210721
093000210721      /Eject
093100210721      *****************************************************************
093200210721     C     Start         Tag
093300210721
093400210721      ** Note: the above tag is only there to force the first comments in
093500210721      ** the C-specs to appear after the D- or I-specs in compiled listings.
093600210721
093700210721      *****************************************************************
093800210721      *                                                               *
093900210721      *                  M A I N  P R O C E S S I N G                 *
094000210721      **   +------------------------------------------------------+   *
094100210721      **   ¦                                                      ¦   *
094200210721      **   ¦ Initial processing is performed automatically: the   ¦   *
094300210721      **   ¦ *inzsr is executed at program activation.            ¦   *
094400210721      **   ¦                                                      ¦   *
094500210721      **   +------------------------------------------------------+   *
094600210721      *                                                               *
094700210721      *****************************************************************
094800210721
094900210721      **  Extract Trade Reference.
095000210721     C                   Z-add     1             X
095100210721     C     'TDRF  '      Lookup    Arrfld(X)                              89
095200210721     C                   Eval      K_TradeRef = %Subst(TransData:+
095300210721     C                             ArrPos(X):ArrLen(X))
095400210721      * retrieve full format of TRADSD and ensure it is refreshed at every run.
095500210721     C                   Clear                   W_SendMsg
095600210721     C                   Clear                   TradsdO
095700210721     C                   Clear                   TradsdC
095800210721     C                   Clear                   TradsdxO
095900210721     C                   Clear                   TradsdxC
096000210721     C                   Clear                   SettldO
096100210721     C                   Clear                   TradsdC2
096200210721     C                   Clear                   TradsdxC2
096300210721     C                   Clear                   TradsdC3
096400210721     C                   Clear                   TradsdxC3
096500210721
096600210721     C                   OPEN      TRADS
096700210721     C     K_TradeRef    CHAIN     TRADS                              99
096800210721     C     *IN99         IFEQ      *OFF
096900210721     C                   Eval      TradsdO = Tradsd
097000210721     C                   END
097100210721     C                   CLOSE     TRADS
097200210721     C                   OPEN      TRADSDY1
097300210721     C     K_TradeRef    CHAIN     TRADSDY1                           99
097400210721     C     *IN99         IFEQ      *OFF
097500210721     C                   Eval      TradsdxO = Tradsdx
097600210721     C                   END
097700210721     C                   CLOSE     TRADSDY1
097800210721      * always call PB replication if FN is not setup or if Trade branch is not Consolidated branch.
097900210721      *
098000210721     C                   SETOFF                                       55
098100210721     C                   Z-Add     1             Z
098200210721     C     O_TDBA        LOOKUP    FNbrcaA(Z)                             55
098300210721      *
098400210721     C                   IF        FNSetup=  ' '    Or
098500210721     C                             *IN55 = *Off
098600210721
098700210721      *  Call Private banking trigger program drirectly
098800210721      *  Save input parameter
098900210721     C                   Eval      OutQueueB   = OutQueue
099000210721     C                   Eval      MdnheadDSB  = MdnHeadDS
099100210721     C                   Eval      TransDataB   = TransData
099200210721     C                   Eval      CommitCtlB   = CommitCtl
099300210721     C                   Eval      ReturnCodeB   = ReturnCode
099400210721     C                   CALLB     'RP1511'
099500210721     C                   Parm                    OutQueue
099600210721     C                   Parm                    MdnHeadDS
099700210721     C                   Parm                    TransData
099800210721      ** Commitment control flag
099900210721     C                   Parm                    CommitCtl
100000210721      ** Return Code
100100210721     C                   Parm                    ReturnCode
100200210721      *  After process of PB Use the saved image insetead of the image modified by RP1511
100300210721     C                   Endif
100400210721      *  Continue further only if FN is setup and not conolidated branch
100500210721     C                   SETOFF                                       55
100600210721     C                   Z-Add     1             Z
100700210721     C     O_TDBA        LOOKUP    FNbrcaA(Z)                             55
100800210721      *
100900210721      *
101000210721     C                   IF        FNSetup=  ' '    Or
101100210721     C                             *IN55 = *On
101200210721      * If Consolidated Branch,  Call procedure to Update UDF08 on the original trade with the
101300210721      * replicated trade reference
101400210721     C                   If        *IN55  =  *On
101500210721     C                   Eval      Pos      = %Scan(' ':O_FRNT)
101600210721     C                   If        Pos = 0
101700210721     C                   Eval      Pos = 21
101800210721     C                   Endif
101900210721     C                   If        Pos > 6
102000210721     C                   Eval      TradeOri = %Subst(O_FRNT:Pos - 6:6)
102100210721      * If conso branch1, ie Z = 1, update T_GZTRADEX/UDFTRAD08 with O_TDRF
102200210721     C                   IF        Z= 1
102300210721     C                   CALL      'A1008003'
102400210721     C                   PARM                    TradeOri
102500210721     C                   PARM                    O_TDRF
102600210721      * If conso branch2, ie Z = 2, update T_GZTRADEX/UDFTRAD13 with O_TDRF
102700210721     C                   ELSEIF    Z= 2
102800210721     C                   CALL      'A1008004'
102900210721     C                   PARM                    TradeOri
103000210721     C                   PARM                    O_TDRF
103100210721      * If Conso branch3, ie z= 3 update T_GZTRADEX/UDFTRAD16 with O_TDRF
103200210721     C                   ELSEIF    Z= 3
103300210721     C                   CALL      'A1008005'
103400210721     C                   PARM                    TradeOri
103500210721     C                   PARM                    O_TDRF
103600210721     C                   ENDIF
103700210721      *
103800210721     C                   Commit
103900210721     C                   endif
104000210721     C                   endif
104100210721     C                   Return
104200210721     C                   endif
104300210721      * After PB replication check if consolidated replication is required
104400210721      * retrieve if consolidated branch replication is required.  RtnCons = 'C'
104500210721     C                   MOVEL     K_TradeRef    Traderef
104600210721     C                   CALL      'A1008006'
104700210721     C                   PARM                    Traderef
104800210721     C                   PARM                    RtnCons
104900210721     C                   PARM                    RtnBook
105000210721     C                   PARM                    RtnCons2
105100210721     C                   PARM                    RtnBook2
105200210721     C                   PARM                    RtnCons3
105300210721     C                   PARM                    RtnBook3
105400210721     C                   PARM                    ReturnCodex
105500210721      **  Extract Reci indicator  do not process Matured record
105600210721     C                   Z-add     1             X
105700210721     C     'RECI  '      Lookup    Arrfld(X)                              89
105800210721     C                   Eval      K_Reci = %Subst(TransDataB:+
105900210721     C                             ArrPos(X):ArrLen(X))
106000210721      * do not process if Intragroup
106100210721     C                   If        RtnCons  <>  'C'
106200210721     C                             and  RtnCons2 <>  'C'
106300210721     C                             and  RtnCons3 <>  'C'
106400210721     C                   Eval      MessageInd = 'N'
106500210721     C                   Return
106600210721     C                   Endif
106700210721      *  stop here if matured  or history
106800210721     C                   If        K_Reci =  'M'  or K_Reci =  '*'
106900210721     C                   Eval      MessageInd = 'N'
107000210721     C                   Return
107100210721     C                   Endif
107200210721      *  stop here if still need auhorisation
107300210721     C                   If        K_Reci =  'L'   or K_Reci =  'P'
107400210721     C                   Eval      MessageInd = 'N'
107500210721     C                   Return
107600210721     C                   Endif
107700210721      * If reach this line Consolidation Branch process may be required
107800210721     C                   Eval      MessageInd = 'Y'
107900210721     C                   Eval      RAMSGOLD = RAMSGTYPE
108000210721
108100210721      **  Enter the processing to read the additional files and produce a
108200210721      **  composite message here.
108300210721
108400210721      **  Check image (Before or After) of the message
108500210721     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)
108600210721
108700210721      **  Before Image Type  These must not create replication
108800210721     C     W_PosFin      Ifne      0
108900210721      ** IF Conso ind   to Branch 1 present on Trade
109000210721     C                   If        RtnCons  =   'C'
109100210721     C                   Eval      ImageTypeB = 'Amend Before'
109200210721     C                   ENDIF
109300210721      ** IF Conso ind   to Branch 2 present on Trade
109400210721     C                   If        RtnCons2 =   'C'
109500210721     C                   Eval      ImageTypeB2 = 'Amend Before'
109600210721     C                   ENDIF
109700210721      ** IF Conso ind   to Branch 3 present on Trade
109800210721     C                   If        RtnCons3 =   'C'
109900210721     C                   Eval      ImageTypeB3 = 'Amend Before'
110000210721     C                   ENDIF
110100210721     C                   Eval      AssocDataB = TransDataB
110200210721     C                   Eval      MdHdAssocB = MdnHeadDsB
110300210721     C                   Eval      AssocDataB2 = TransDataB
110400210721     C                   Eval      MdHdAssocB2 = MdnHeadDsB
110500210721     C                   Eval      AssocDataB3 = TransDataB
110600210721     C                   Eval      MdHdAssocB3 = MdnHeadDsB
110700210721     C                   Eval      MessageInd = 'N'
110800210721
110900210721      **  Extract Incomplete/complete indicator Image Before
111000210721     C                   Z-add     1             X
111100210721     C     'TINC  '      Lookup    Arrfld(X)                              89
111200210721     C                   Eval      B_Tinc = %Subst(TransDataB:+
111300210721     C                             ArrPos(X):ArrLen(X))
111400210721      ** DO NOT CONTINUE PROCESS IF BEFORE IMAGE IS PROCESSED
111500210721     C                   Return
111600210721
111700210721     C                   Else
111800210721
111900210721     C                   If        RtnCons  =   'C'
112000210721     C                             and FNbrcaA(1) <> '   '
112100210721     C                   If        ImageTypeB  <> 'Amend Before'
112200210721     C                   Eval      ImageTypeB = 'Insert'
112300210721     C                   Eval      AssocDataB = *Blanks
112400210721     C                   Eval      MdHdAssocB = *Blanks
112500210721     C                   Else
112600210721
112700210721     C                   Eval      ImageTypeB = 'Amend After'
112800210721     C                   EndIf
112900210721     C                   EndIF
113000210721
113100210721     C                   If        RtnCons2 =   'C'
113200210721     C                             and FNbrcaA(2) <> '   '
113300210721     C                   If        ImageTypeB2 <> 'Amend Before'
113400210721     C                   Eval      ImageTypeB2 = 'Insert'
113500210721     C                   Eval      AssocDataB2= *Blanks
113600210721     C                   Eval      MdHdAssocB2= *Blanks
113700210721     C                   Else
113800210721
113900210721     C                   Eval      ImageTypeB2 = 'Amend After'
114000210721     C                   EndIf
114100210721     C                   EndIF
114200210721
114300210721     C                   If        RtnCons3 =   'C'
114400210721     C                             and FNbrcaA(3) <> '   '
114500210721     C                   If        ImageTypeB3 <> 'Amend Before'
114600210721     C                   Eval      ImageTypeB3 = 'Insert'
114700210721     C                   Eval      AssocDataB3= *Blanks
114800210721     C                   Eval      MdHdAssocB3= *Blanks
114900210721     C                   Else
115000210721
115100210721     C                   Eval      ImageTypeB3 = 'Amend After'
115200210721     C                   EndIf
115300210721     C                   EndIF
115400210721
115500210721      **  Extract Incomplete/complete indicator Image After
115600210721     C                   Z-add     1             X
115700210721     C     'TINC  '      Lookup    Arrfld(X)                              89
115800210721     C                   Eval      K_Tinc = %Subst(TransDataB:+
115900210721     C                             ArrPos(X):ArrLen(X))
116000210721      *
116100210721      *  If incomplete don't replicate yet. It will be done when status is change to complete.
116200210721      *
116300210721     C                   If        K_Tinc = 'I'
116400210721     C                   Eval      ImageTypeB = *Blanks
116500210721     C                   Eval      ImageTypeB2 = *Blanks
116600210721     C                   Eval      ImageTypeB3 = *Blanks
116700210721     C                   Eval      MessageInd = 'N'
116800210721     C                   Return
116900210721     C                   Endif
117000210721     C                   Endif
117100210721
117200210721      **  Extract Customer number from TRADSD message data.
117300210721     C                   Z-add     1             X
117400210721     C     'TCNR  '      Lookup    Arrfld(X)                              89
117500210721     C                   EVAL      P_Cust = %Subst(TransDataB:+
117600210721     C                             ArrPos(X):ArrLen(X))
117700210721
117800210721      **  Access Security Customer Details by using Access Object
117900210721      **  to retrieve Safe Custody
118000210721     C                   CALL      'AOSECSR0'
118100210721     C                   Parm      *blank        P_Rtcd                         B:Return code
118200210721     C                   Parm      '*KEY   '     P_Optn                         I:Option
118300210721     C                   Parm                    P_Cust                         I:Key field
118400210721     C     Sdsecs        Parm      Sdsecs        Dssdy                          O:Format
118500210721
118600210721      **  If Customer Details do not exist, handle Database Error.
118700210721     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
118800210721     C     *lock         In        Lda
118900210721     C                   Eval      DBpgm  = PSProcName
119000210721     C                   Eval      DBfile = 'SDSECSPD'                          ***************
119100210721     C                   Eval      DBase  = 01                                  * Db Error 01 *
119200210721     C                   Eval      DBkey  = P_Cust                              ***************
119300210721     C                   Out       Lda
119400210721     C                   Eval      ReturnCode =  P_Rtcd
119500210721     C                   Exsr      Repair
119600210721
119700210721     C                   Endif                                                  End P_Rtcd
119800210721      * Now check if the trade has already been replicated
119900210721      * for the 3 consolidated branches in A1CONBPD
120000210721      * It may not if trade was incomplete previously.
120100210721      *
120200210721      * Consolidate Branch 1
120300210721      *
120400210721     C                   If        RtnCons  =   'C'
120500210721     C                             and FNbrcaA(1) <> '   '
120600210721     C                   Eval      TradeFOI = %trim(FNfoirA(1)) + K_TradeRef
120700210721     C                   CALL      'A1008007'
120800210721     C                   PARM                    TradeFOI
120900210721     C                   PARM                    FNbrcaA(1)
121000210721     C                   PARM      *blank        TradeRTN
121100210721     C                   PARM      *blank        ReturnCodex
121200210721      *
121300210721      *  If No records  exist with FRNT = FNROIR + TDRF and It is an AMend RECI is do insert
121400210721     C                   If        ReturnCodex  = 'NRF    '
121500210721     C                   Eval      ImageTypeB = 'Insert              '
121600210721     C                   Eval      AssocDataB = *Blanks
121700210721     C                   Eval      MdHdAssocB = *Blanks
121800210721      *
121900210721     C                   ENDIF
122000210721     C                   ENDIF
122100210721      *
122200210721      * Consolidate Branch 2
122300210721      *
122400210721     C                   If        RtnCons2 =   'C'
122500210721     C                             and FNbrcaA(2) <> '   '
122600210721     C                   Eval      TradeFOI2 = %trim(FNfoirA(2)) + K_TradeRef
122700210721     C                   CALL      'A1008007'
122800210721     C                   PARM                    TradeFOI2
122900210721     C                   PARM                    FNbrcaA(2)
123000210721     C                   PARM      *blank        TradeRTN2
123100210721     C                   PARM      *blank        ReturnCodex2
123200210721      *
123300210721      *  If No records  exist with FRNT = FNROIR + TDRF and It is an AMend RECI is do insert
123400210721     C                   If        ReturnCodex2  = 'NRF    '
123500210721     C                   Eval      ImageTypeB2 = 'Insert              '
123600210721     C                   Eval      AssocDataB2 = *Blanks
123700210721     C                   Eval      MdHdAssocB2 = *Blanks
123800210721      *
123900210721     C                   ENDIF
124000210721     C                   ENDIF
124100210721      *
124200210721      * Consolidate Branch 3
124300210721      *
124400210721     C                   If        RtnCons3 =   'C'
124500210721     C                             and FNbrcaA(3) <> '   '
124600210721     C                   Eval      TradeFOI3 = %trim(FNfoirA(3)) + K_TradeRef
124700210721     C                   CALL      'A1008007'
124800210721     C                   PARM                    TradeFOI3
124900210721     C                   PARM                    FNbrcaA(3)
125000210721     C                   PARM      *blank        TradeRTN3
125100210721     C                   PARM      *blank        ReturnCodex3
125200210721      *
125300210721      *  If No records  exist with FRNT = FNROIR + TDRF and It is an AMend RECI is do insert
125400210721     C                   If        ReturnCodex3  = 'NRF    '
125500210721     C                   Eval      ImageTypeB3 = 'Insert              '
125600210721     C                   Eval      AssocDataB3 = *Blanks
125700210721     C                   Eval      MdHdAssocB3 = *Blanks
125800210721      *
125900210721     C                   ENDIF
126000210721     C                   ENDIF
126100210721      *
126200210721      *  If action is delete ReCI = C or R and NRF no action is required
126300210721     C                   If        K_Reci = 'C' or K_Reci = 'R'
126400210721      * Only return if all 3 consolidated branch  records are NRF
126500210721     C                   If        ImageTypeB  = 'Insert              '
126600210721     C                             and ImageTypeB2 = 'Insert              '
126700210721     C                             and ImageTypeB3 = 'Insert              '
126800210721     C                   Eval      MessageInd = 'N'
126900210721     C                   Return
127000210721     C                   Endif
127100210721     C                   Endif
127200210721      * retrieve full format of the Replicated trade
127300210721      * For conso Branch 1 : deal replicated already
127400210721     C                   If        ReturnCodex  <> 'NRF    '
127500210721     C                             and RtnCons  =   'C'
127600210721     C                   Eval      ImageTypeB = 'Amend              '
127700210721     C                   OPEN      TRADS
127800210721     C     TradeRTN      CHAIN     TRADS                              99
127900210721     C     *IN99         IFEQ      *OFF
128000210721     C                   Eval      TradsdC = Tradsd
128100210721     C                   Endif
128200210721     C                   CLOSE     TRADS
128300210721     C                   OPEN      TRADSDY1
128400210721
128500210721     C     TradeRTN      CHAIN     TRADSDY1                           99
128600210721     C     *IN99         IFEQ      *OFF
128700210721     C                   Eval      TradsdxC = Tradsdx
128800210721     C                   Endif
128900210721     C                   CLOSE     TRADSDY1
129000210721      * Decide if replication trade must be deleted
129100210721     C                   If        K_Reci = 'C' or K_Reci = 'R'
129200210721     C                   Eval      ImageTypeB = 'Delete             '
129300210721      *  If replicated trade does not exist or has been deleted stop process.
129400210721     C                   If        TradsdC = *blanks or
129500210721     C                             C_Reci = 'C' or C_Reci = 'R'
129600210721     C                   Eval      ImageTypeB = '                   '
129700210721     C                   Endif
129800210721     C                   Endif
129900210721      *
130000210721     C                   Endif
130100210721      *
130200210721      * For conso branch 2: deal replicated already
130300210721     C                   If        ReturnCodex2 <> 'NRF    '
130400210721     C                             and RtnCons2 =   'C'
130500210721     C                   Eval      ImageTypeB2 = 'Amend              '
130600210721     C                   OPEN      TRADS
130700210721     C     TradeRTN2     CHAIN     TRADS                              99
130800210721     C     *IN99         IFEQ      *OFF
130900210721     C                   Eval      TradsdC2 = Tradsd
131000210721     C                   Endif
131100210721     C                   CLOSE     TRADS
131200210721     C                   OPEN      TRADSDY1
131300210721
131400210721     C     TradeRTN2     CHAIN     TRADSDY1                           99
131500210721     C     *IN99         IFEQ      *OFF
131600210721     C                   Eval      TradsdxC2 = Tradsdx
131700210721     C                   Endif
131800210721     C                   CLOSE     TRADSDY1
131900210721      * Decide if replication trade must be deleted
132000210721     C                   If        K_Reci = 'C' or K_Reci = 'R'
132100210721     C                   Eval      ImageTypeB2 = 'Delete             '
132200210721      *  If replicated trade does not exist or has been deleted stop process.
132300210721     C                   If        TradsdC2 = *blanks or
132400210721     C                             C2Reci = 'C' or C2Reci = 'R'
132500210721     C                   Eval      ImageTypeB2 = '                   '
132600210721     C                   Endif
132700210721     C                   Endif
132800210721      *
132900210721     C                   Endif
133000210721      * For conso branch 3: deal replicated already
133100210721     C                   If        ReturnCodex3 <> 'NRF    '
133200210721     C                             and RtnCons3 =   'C'
133300210721     C                   Eval      ImageTypeB3 = 'Amend              '
133400210721     C                   OPEN      TRADS
133500210721     C     TradeRTN3     CHAIN     TRADS                              99
133600210721     C     *IN99         IFEQ      *OFF
133700210721     C                   Eval      TradsdC3 = Tradsd
133800210721     C                   Endif
133900210721     C                   CLOSE     TRADS
134000210721     C                   OPEN      TRADSDY1
134100210721
134200210721     C     TradeRTN3     CHAIN     TRADSDY1                           99
134300210721     C     *IN99         IFEQ      *OFF
134400210721     C                   Eval      TradsdxC3 = Tradsdx
134500210721     C                   Endif
134600210721     C                   CLOSE     TRADSDY1
134700210721      * Decide if replication trade must be deleted
134800210721     C                   If        K_Reci = 'C' or K_Reci = 'R'
134900210721     C                   Eval      ImageTypeB3 = 'Delete             '
135000210721      *  If replicated trade does not exist or has been deleted stop process.
135100210721     C                   If        TradsdC3 = *blanks or
135200210721     C                             C3Reci = 'C' or C3Reci = 'R'
135300210721     C                   Eval      ImageTypeB3 = '                   '
135400210721     C                   Endif
135500210721     C                   Endif
135600210721      *
135700210721     C                   Endif
135800210721      * If no action required for all conso branches, return:
135900210721     C                   If        ImageTypeB  = '                    '
136000210721     C                             and ImageTypeB2 = '                    '
136100210721     C                             and ImageTypeB3 = '                    '
136200210721     C                   Return
136300210721     C                   Endif
136400210721      *
136500210721      *
136600210721      **  Initialize work field used to condition Meridian message sending.
136700210721     C                   Clear                   W_SendMsg
136800210721      *
136900210721      *  Setup Api message header form SETRAD
137000210721      *
137100210721     C                   Exsr      APHeader
137200210721      * Retieve information needed to format Amounts
137300210721      **---------------- Start of Nominal Currency ---------------**
137400210721      **                   Number of Decimal Places                  **
137500210721
137600210721     C                   Z-add     1             X
137700210721     C     'TNMC  '      Lookup    Arrfld(X)                              89
137800210721     C                   Eval      W_Currency = %Subst(TransData:+
137900210721     C                             ArrPos(X):ArrLen(X))
138000210721
138100210721      **  Get Nominal Currency number of decimal places.
138200210721     C                   Eval      P_Curr = W_Currency
138300210721     C                   Exsr      GetDecPl
138400210721     C                   Move      A6NBDP        W_NomCcyNbdp
138500210721
138600210721      **                  End of Nominal Currency                 **
138700210721      **-----------------  Number of Decimal Places  ----------------**
138800210721      *
138900210721      *  Setup Api message details     SETRAD
139000210721      *
139100210721      *  Need to consider for 3 consolidated branches per trade
139200210721     C                   Z-add     1             Z
139300210721     C     Z             DOWLE     3
139400210721     C                   Clear                   W_SendMsg
139500210721     C                   Eval      WrkBook = '  '
139600210721     C                   Clear                   SettldO
139700210721      *
139800210721     C                   If        RtnCons  =   'C'
139900210721     C                             and Z = 1
140000210721      *
140100210721     C                   Eval      WrkBook = RtnBook
140200210721     C                   OPEN      A1CONBL2
140300210721     C     FNudfE1       CHAIN     A1CONBPF                           99
140400210721     C                   CLOSE     A1CONBL2
140500210721     C                   IF        *IN99 = *off
140600210721     C                             and ImageTypeB <> '                    '
140700210721     C                   Eval      W_SendMsg = 'Y'
140800210721     C                   Eval      ApUSER = FNUSER
140900210721     C                   Eval      ApFRNT = TradeFOI
141000210721     C                   If        ImageTypeB =  'Insert              '
141100210721     C                   Exsr      APDataI
141200210721     C                   Else
141300210721     C                   If        ImageTypeB =  'Delete              '
141400210721     C                   Exsr      APDataD
141500210721     C                   Else
141600210721     C                   Exsr      APDataA
141700210721     C                   Endif
141800210721     C                   Endif
141900210721     C                   Endif
142000210721     C                   Endif
142100210721
142200210721     C                   If        RtnCons2 =   'C'
142300210721     C                             and Z = 2
142400210721      *
142500210721     C                   Eval      WrkBook = RtnBooK2
142600210721     C                   OPEN      A1CONBL2
142700210721     C     FNudfE2       CHAIN     A1CONBPF                           99
142800210721     C                   CLOSE     A1CONBL2
142900210721     C                   IF        *IN99 = *off
143000210721     C                             and ImageTypeB2 <> '                    '
143100210721     C                   Eval      W_SendMsg = 'Y'
143200210721     C                   Eval      ApUSER = FNUSER
143300210721     C                   Eval      ApFRNT = TradeFOI2
143400210721     C                   If        ImageTypeB2 =  'Insert              '
143500210721     C                   Exsr      APDataI
143600210721     C                   Else
143700210721     C                   If        ImageTypeB2 =  'Delete              '
143800210721     C                   Exsr      APDataD2
143900210721     C                   Else
144000210721     C                   Exsr      APDataA2
144100210721     C                   Endif
144200210721     C                   Endif
144300210721     C                   Endif
144400210721     C                   Endif
144500210721
144600210721     C                   If        RtnCons3 =   'C'
144700210721     C                             and Z = 3
144800210721      *
144900210721     C                   Eval      WrkBook = RtnBook3
145000210721     C                   OPEN      A1CONBL2
145100210721     C     FNudfE3       CHAIN     A1CONBPF                           99
145200210721     C                   CLOSE     A1CONBL2
145300210721     C                   IF        *IN99 = *off
145400210721     C                             and ImageTypeB3 <> '                    '
145500210721     C                   Eval      W_SendMsg = 'Y'
145600210721     C                   Eval      ApUSER = FNUSER
145700210721     C                   Eval      ApFRNT = TradeFOI3
145800210721     C                   If        ImageTypeB3 =  'Insert              '
145900210721     C                   Exsr      APDataI
146000210721     C                   Else
146100210721     C                   If        ImageTypeB3 =  'Delete              '
146200210721     C                   Exsr      APDataD3
146300210721     C                   Else
146400210721     C                   Exsr      APDataA3
146500210721     C                   Endif
146600210721     C                   Endif
146700210721     C                   Endif
146800210721     C                   Endif
146900210721
147000210721      **  If Meridian message has to be sent.
147100210721     C     W_SendMsg     Ifeq      'Y'                                          Begin W_SendMsg
147200210721
147300210721      **----------------- Start of Additionnal fields ---------------**
147400210721
147500210721
147600210721      **  Extract Trade Type.
147700210721     C                   Z-add     1             X
147800210721     C     'TDTP  '      Lookup    Arrfld(X)                              89
147900210721     C                   Eval      W_Type = %Subst(TransData:+
148000210721     C                             ArrPos(X):ArrLen(X))
148100210721
148200210721      **  Change message Type from _After to _A
148300210721      **  Determine Image Type.
148400210721
148500210721      **  Place the result in field CompData.
148600210721
148700210721     C                   Movel     ApHdmsg       MdnHeadDSb
148800210721     C                   Movel     ApDtmsg       CompDatab
148900210721
149000210721      **  Call a standard routine to actually send the message.
149100210721     C                   Callb     'A1008009'
149200210721     C                   Parm                    FNQUEUE
149300210721     C                   Parm                    ApHdmsg         200
149400210721     C                   Parm                    ApDtmsg        8000
149500210721     C                   Parm                    CommitCtl
149600210721     C                   Parm      *BLANKS       ReturnCode
149700210721
149800210721      ** If error then perform any special processing and exit
149900210721     C                   If        ReturnCode   <> *blank                              iReturnCode
150000210721     C     *Lock         In        Lda
150100210721     C                   Move      'XX08009   '  DBpgm
150200210721     C                   Out       Lda
150300210721     C                   Exsr      Repair
150400210721
150500210721      **  If no error, commit the unit of work so that messages that have
150600210721      **  been got from a queue would be permanently deleted and put
150700210721      **  operations would be made permanent.
150800210721     C                   Else                                                   Else ReturnCod
150900210721
151000210721     C                   Commit
151100210721
151200210721     C                   Endif                                                  End ReturnCode
151300210721
151400210721     C                   Endif                                                  End W_SendMsg
151500210721      *
151600210721      *
151700210721     C                   EVAL      Z = Z + 1
151800210721      *
151900210721     C                   ENDDO
152000210721      *
152100210721
152200210721     C                   Return
152300210721
152400210721      /Eject
152500210721      *****************************************************************
152600210721      *                                                               *
152700210721      *  RtvPos   - retrieve position in Meridian message.            *
152800210721      *                                                               *
152900210721      *  Called by : Main processing.                                 *
153000210721      *                                                               *
153100210721      *  Calls     : None.                                            *
153200210721      *                                                               *
153300210721      *****************************************************************
153400210721
153500210721     C     RtvPos        Begsr
153600210721
153700210721     C                   Callb     'RPC1305'
153800210721     C                   Parm                    ScriptName
153900210721     C                   Parm      RAMSGTYPE     ImageName
154000210721     C                   Parm                    FieldName
154100210721     C                   Parm                    FieldType
154200210721     C                   Parm                    TransData
154300210721     C                   Parm      0             FieldPosition
154400210721     C                   Parm      0             FieldLength
154500210721     C                   Parm      *blank        FieldValue
154600210721     C                   Parm      *blank        ReturnCode
154700210721
154800210721      **  If any error occurred while retrieving position, handle it.
154900210721     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
155000210721     C     *Lock         In        Lda
155100210721     C                   Eval      DBpgm  = PSProcName
155200210721     C                   Eval      DBfile = 'Call    '                          ***************
155300210721     C                   Eval      DBase  = 06                                  * Db Error 06 *
155400210721     C                   Eval      DBkey  = 'RPC1305'                           **************
155500210721     C                   Out       Lda
155600210721
155700210721     C                   Eval      MessageInd = 'N'
155800210721     C                   Exsr      Repair
155900210721     C                   Eval      MessageInd = 'Y'
156000210721
156100210721     C                   Endif                                                  End ReturnCode
156200210721
156300210721     C                   Eval      X = X + 1
156400210721      **  If any error occurred while retrieving position, handle it.
156500210721     C                   If        X > 100
156600210721     C     *lock         In        Lda
156700210721     C                   Eval      DBpgm  = PSProcName
156800210721     C                   Eval      DBfile = 'Array   '                          ***************
156900210721     C                   Eval      DBase  = 07                                  * Db Error 07 *
157000210721     C                   Eval      DBkey  = 'Index  '                           **************
157100210721     C                   Out       LDA
157200210721     C                   Exsr      Repair
157300210721     C                   Endif                                                  End ReturnCode
157400210721
157500210721     C                   Eval      ArrFld(X) = FieldName
157600210721     C                   Eval      ArrPos(X) = FieldPosition
157700210721     C                   Eval      ArrLen(X) = FieldLength
157800210721
157900210721     C                   Endsr
158000210721      /Eject
158100210721      *****************************************************************
158200210721      *                                                               *
158300210721      *  Repair   - Write a Trace of outgoing messages to repair      *
158400210721      *                                                               *
158500210721      *  Called by : Main processing.                                 *
158600210721      *                                                               *
158700210721      *  Calls     : None.                                            *
158800210721      *                                                               *
158900210721      *****************************************************************
159000210721
159100210721     C     Repair        Begsr
159200210721
159300210721     C                   Move      Dbase         dbasea            3
159400210721
159500210721     C                   Eval      DBErrText = 'DBError' +
159600210721     C                             ' in : ' + DBpgm +
159700210721     C                             ' at: ' + DBasea +
159800210721     C                             ' file : ' + DBfile +
159900210721     C                             ' Key : ' + DBKey +
160000210721     C                             ' Return :' + ReturnCode
160100210721
160200210721     C                   Eval      RAMSGTYPE  = RAMSGOLD
160300210721
160400210721     C                   Callb     'RP1592'
160500210721     C                   Parm                    FNQUEUE
160600210721     C                   Parm                    MdnHeadDS
160700210721     C                   Parm                    TransData
160800210721     C                   Parm                    MdHdAssoc
160900210721     C                   Parm                    AssocData
161000210721     C                   Parm                    CommitCtl
161100210721     C                   Parm                    DBErrText
161200210721     C                   Parm                    MessageInd
161300210721     C                   Parm      *Blanks       ReturnCode
161400210721
161500210721      **  If any error occurred while retrieving position, handle it.
161600210721     C     ReturnCode    Ifne      *blanks                                      Begin ReturnC
161700210721     C     *Lock         In        Lda
161800210721     C                   Eval      DBpgm  = PSProcName
161900210721     C                   Eval      DBfile = 'Call    '                          *************
162000210721     C                   Eval      DBase  = 50                                  * Db Error 50
162100210721     C                   Eval      DBkey  = 'RP1592'                            *************
162200210721     C                   Out       Lda
162300210721
162400210721     C                   exsr      *pssr
162500210721     C                   Else
162600210721     C                   Return
162700210721     C                   Endif                                                  End ReturnCod
162800210721
162900210721     C                   Endsr
163000210721
163100210721      /Eject
163200210721      *****************************************************************
163300210721      *                                                               *
163400210721      *  GetDecPl - get number of decimal places.                     *
163500210721      *                                                               *
163600210721      *  Called by : Main processing.                                 *
163700210721      *                                                               *
163800210721      *  Calls     : None.                                            *
163900210721      *                                                               *
164000210721      *****************************************************************
164100210721
164200210721     C     GetDecPl      Begsr
164300210721
164400210721      **  Access to Currency Details, by using access object.
164500210721     C                   Callb     'AOCURRR0'
164600210721     C                   Parm      *blank        P_Rtcd                         B:Return code
164700210721     C                   Parm      '*KEY   '     P_Optn                         I:Option
164800210721     C                   Parm                    P_Curr            3            I:Key field
164900210721     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
165000210721
165100210721      **  If currency does not exist, handle database error.
165200210721     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
165300210721     C     *lock         In        Lda
165400210721     C                   Eval      Dbpgm  = PSProcName
165500210721     C                   Eval      Dbfile = 'SDCURRPD'                          *************
165600210721     C                   Eval      Dbase  = 09                                  * Db Error 09
165700210721     C                   Eval      Dbkey  = P_Curr                              *************
165800210721     C                   Out       LDA
165900210721     C                   Eval      ReturnCode  = P_RTCD
166000210721     C                   Exsr      Repair
166100210721
166200210721     C                   Endif                                                  End  P_Rtcd
166300210721
166400210721     C                   Endsr
166500210721
166600210721      /Eject
166700210721      *****************************************************************
166800210721      *                                                               *
166900210721      * *Pssr  - Program exception error routine                      *
167000210721      *          Called automatically if a program error occurs,      *
167100210721      *          or directly by the program code using EXSR.          *
167200210721      *          This subroutine DUMPs the program just once.         *
167300210721      *                                                               *
167400210721      * Called by: (**calling routines**)                             *
167500210721      *                                                               *
167600210721      * Calls: None                                                   *
167700210721      *                                                               *
167800210721      *                                                               *
167900210721      *****************************************************************
168000210721
168100210721     C     *Pssr         Begsr
168200210721
168300210721     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
168400210721
168500210721      **  If commitment control required, back out the unit of work so
168600210721      **  that current message could be available again.
168700210721     C                   If        CommitCtl = 'Y'                              Begin CommiCtl
168800210721     C                   Rolbk
168900210721
169000210721     C                   Endif                                                  End CommitCtl
169100210721
169200210721     C     *Lock         In        Lda
169300210721     C     DBpgm         Ifeq      *blanks                                      Begin DBpgm
169400210721     C                   Move      PSProcName    DBpgm
169500210721     C                   Out       Lda
169600210721
169700210721     C                   Endif                                                  End DBpgm
169800210721
169900210721     C                   Move      'Y'           W_RunBefore
170000210721     C                   Dump
170100210721
170200210721     C                   Endif                                                  End W_RunBefore
170300210721
170400210721     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
170500210721     C                   Eval      ReturnCode = '*PSSR'
170600210721     C                   Endif                                                  End ReturnCode
170700210721
170800210721     C                   Seton                                        U7U8LR
170900210721     C                   Return
171000210721
171100210721     C                   Endsr
171200210721      /Eject
171300210721      *****************************************************************
171400210721      *                                                               *
171500210721      * *Inzsr - Program Initialisation routine                       *
171600210721      *                                                               *
171700210721      * Called at : program initialization time.                      *
171800210721      *                                                               *
171900210721      *****************************************************************
172000210721
172100210721     C     *Inzsr        Begsr
172200210721
172300210721     C     *Entry        Plist
172400210721      ** MQSeries queue to write to - this parameter IS used in this module
172500210721     C                   Parm                    OutQueue
172600210721      ** Merdian header
172700210721     C                   Parm                    MdnHeadDS
172800210721      ** Transaction Data
172900210721     C                   Parm                    TransData
173000210721      ** Commitment control flag
173100210721     C                   Parm                    CommitCtl
173200210721      ** Return Code
173300210721     C                   Parm                    ReturnCode
173400210721
173500210721      *
173600210721      ** Check for switchable feature BA1008
173700210721     C                   Call      'AOSARDR0'
173800210721     C                   Parm      *Blanks       @RTCD             7
173900210721     C                   Parm      '*VERIFY'     @OPTN             7
174000210721     C                   Parm      'BA1008'      @SARD             6
174100210721     C     SCSARD        Parm      SCSARD        DSFDY
174200210721
174300210721     C                   If        @RTCD = *Blanks
174400210721     C                   Movel     'Y'           BA1008            1
174500210721     C                   Else
174600210721     C                   Movel     'N'           BA1008
174700210721     C                   EXSR      ZYEXPG
174800210721     C                   EndIf
174900210721      *
175000210721     C     KLSTD1        KLIST
175100210721     C                   KFLD                    FNBRCA
175200210721     C                   KFLD                    FNCUST
175300210721     C                   KFLD                    S_SIBK
175400210721     C                   KFLD                    O_TNMC
175500210721      *
175600210721     C                   Eval      MessageInd = 'Y'
175700210721
175800210721      **  Set up work fields for formatting that will not change if
175900210721      **  Replication formatting is required.
176000210721      **     - signs are not shown for Positive numbers.
176100210721      **     - get decimal separator from Replication data area RPDFTSDA.
176200210721     C                   In        RPDftsDa
176300210721     C                   Eval      fmDecSep   = RCDECSEP
176400210721     C                   Eval      fmDpLen  = %Subst(RCZEROFLD:2:1)
176500210721     C                   Move      fmDpLen       W_PosDebut
176600210721     C                   Eval      fmShwPsSgn = 'N'
176700210721
176800210721      **  Set up work fields that will not change if retrieve
176900210721      **  function is to be used.
177000210721     C                   Eval      ScriptName = 'RP' + RATGTSYS
177100210721
177200210721      **  Get Securities Trading Data by using Access Object.
177300210721     C                   Callb     'AOSTRDR0'
177400210721     C                   Parm      *Blanks       P_Rtcd
177500210721     C                   Parm      '*FIRST '     P_Optn
177600210721     C     Sdstrd        Parm      Sdstrd        Dssdy
177700210721
177800210721      **  If Securities Trading Details do not exist, handle Database Error.
177900210721     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
178000210721     C                   Eval      DBpgm  = PSProcName
178100210721     C                   Eval      DBfile = 'SDSTRDPD'                          ***************
178200210721     C                   Eval      DBase  = 10                                  * Db Error 10 *
178300210721     C                   Eval      DBkey  = '*FIRST'                            ***************
178400210721     C                   Out       Lda
178500210721     C                   Exsr      Repair
178600210721
178700210721     C                   Endif                                                  End P_Rtcd
178800210721
178900210721      **  Get Private Banking details by using Access Object.
179000210721     C                   Callb     'AOTOFR0'
179100210721     C                   Parm      *Blanks       P_Rtcd
179200210721     C                   Parm      '*FIRST '     P_Optn
179300210721     C     Sdtofd        Parm      Sdtofd        Dssdy
179400210721
179500210721      **  If Private Banking details do not exist, handle Database Error.
179600210721     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
179700210721     C                   Eval      DBpgm  = PSProcName
179800210721     C                   Eval      DBfile = 'SDTOFPD'                           ***************
179900210721     C                   Eval      DBase  = 11                                  * Db Error 11 *
180000210721     C                   Eval      DBkey  = '*FIRST'                            **************
180100210721     C                   Out       Lda
180200210721     C                   Exsr      Repair
180300210721
180400210721     C                   Endif                                                  End P_Rtcd
180500210721
180600210721     C                   Z-add     0             X                 3 0
180700210721
180800210721      **  Retrieve position and length of customer number from TRADSD message data.
180900210721     C                   Eval      FieldName   = 'TCNR'
181000210721     C                   Eval      FieldType   = 'A'
181100210721     C                   Exsr      RtvPos
181200210721
181300210721      **  Retrieve position and length of Order number from TRADSD message data.
181400210721     C                   Eval      FieldName   = 'ORDE'
181500210721     C                   Eval      FieldType   = 'N'
181600210721     C                   Exsr      RtvPos
181700210721
181800210721      **  Retrieve position and length of Trade Reference from TRADSD message data.
181900210721     C                   Eval      FieldName   = 'TDRF'
182000210721     C                   Eval      FieldType   = 'A'
182100210721     C                   Exsr      RtvPos
182200210721
182300210721      **  Retrieve position and length of Nomincal Currency from TRADSD message data.
182400210721     C                   Eval      FieldName   = 'TNMC'
182500210721     C                   Eval      FieldType   = 'A'
182600210721     C                   Exsr      RtvPos
182700210721
182800210721      **  Retrieve position and length of Pay From Branch from TRADSD message data.
182900210721     C                   Eval      FieldName   = 'PYFA'
183000210721     C                   Eval      FieldType   = 'A'
183100210721     C                   Exsr      RtvPos
183200210721
183300210721      **  Retrieve position and length of Pay From Branch from TRADSD message
183400210721     C                   Eval      FieldName   = 'SETC'
183500210721     C                   Eval      FieldType   = 'A'
183600210721     C                   Exsr      RtvPos
183700210721
183800210721      **  Retrieve position and length of in/complete ind from TRADSD message
183900210721     C                   Eval      FieldName   = 'TINC'
184000210721     C                   Eval      FieldType   = 'A'
184100210721     C                   Exsr      RtvPos
184200210721
184300210721      **  Retrieve position and length of RECI from TRADSD message
184400210721     C                   Eval      FieldName   = 'RECI'
184500210721     C                   Eval      FieldType   = 'A'
184600210721     C                   Exsr      RtvPos
184700210721
184800210721      **  Retrieve position and length of Settlement Methode from TRADSD message
184900210721     C                   Eval      FieldName   = 'SMTH'
185000210721     C                   Eval      FieldType   = 'N'
185100210721     C                   Exsr      RtvPos
185200210721
185300210721      **  Retrieve position and length of Pay From from TRADSD message data.
185400210721     C                   Eval      FieldName   = 'PYFM'
185500210721     C                   Eval      FieldType   = 'A'
185600210721     C                   Exsr      RtvPos
185700210721
185800210721      **  Retrieve position and length of Pay To Branch TRADSD message data.
185900210721     C                   Eval      FieldName   = 'PYTA'
186000210721     C                   Eval      FieldType   = 'A'
186100210721     C                   Exsr      RtvPos
186200210721
186300210721      **  Retrieve position and length of Pay To TRADSD message data.
186400210721     C                   Eval      FieldName   = 'PAYT'
186500210721     C                   Eval      FieldType   = 'A'
186600210721     C                   Exsr      RtvPos
186700210721
186800210721      **  Retrieve position and length of Trade type from TRADSD message data.
186900210721     C                   Eval      FieldName   = 'TDTP'
187000210721     C                   Eval      FieldType   = 'A'
187100210721     C                   Exsr      RtvPos
187200210721      *
187300210721      **  Retrieve position and length of Replication Flag from
187400210721      **  TRADSD message data.
187500210721      *
187600210721     C                   Eval      FieldName   = 'REPI'
187700210721     C                   Eval      FieldType   = 'A'
187800210721     C                   Exsr      RtvPos
187900210721
188000210721      **  Retrieve begin position of additionnal fields in Meridian message.
188100210721     C                   Eval      FieldName   = '*END_IMAGE'
188200210721     C                   Eval      FieldType   = *blank
188300210721     C                   Exsr      RtvPos
188400210721     C                   Eval      EndPosition = FieldPosition - 1
188500210721
188600210721      ** Introduce SubRoutine FNDataD
188700210721
188800210721     C                   Exsr      FNDataD
188900210721
189000210721      * retree substitution character
189100210721     C                   OPEN      SDAPIPD
189200210721     C                   READ      SDAPIPD
189300210721     C                   CLOSE     SDAPIPD
189400210721      * fill worSUBS withn substitution cahracter
189500210721     C                   Movel     GHSUBS        WrSUBS
189600210721     C                   FOR       i = 1 to 99
189700210721     C                   eval      WrSUBS   = %trim(WrSUBS) + GHSUBS
189800210721     C                   ENDFOR
189900210721     C                   Endsr
190000210721      /Eject
190100210721      *****************************************************************
190200210721     C     APHeader      Begsr
190300210721     C                   Eval      ApMSGT = 'SETRAD                          '
190400210721     C                   Eval      ApSRCS = 'Midas   '
190500210721     C                   Eval      ApORIG = *blank
190600210721     C                   Eval      ApTGTS = 'MIDAS   '
190700210721     C                   Eval      ApPASS = *Blank
190800210721     C                   Eval      ApFORM = 'Fixed   '
190900210721     C                   Eval      ApVERS = 'JMSMQ   '
191000210721     C                   Eval      ApRPYQ = 'REPLY               '
191100210721     C                   Eval      ApRESP = 'A'
191200210721     C                   Eval      ApMAPL = *blank
191300210721      ** - Front Office transaction ID
191400210721     C                   Eval      ApASOC = *blank
191500210721     C                   Eval      ApRESPN = 'N'
191600210721     C                   Eval      ApMAPLB = 'B'
191700210721     C                   Eval      APFIL = *blank
191800210721     C                   Endsr
191900210721      /Eject
192000210721      *****************************************************************
192100210721     C     APDataI       Begsr
192200210721     C                   Clear                   ApDtmsg
192300210721      *  Get Default fo settlement
192400210721     C                   IF        FNBRCA  <> *blank
192500210721     C                   OPEN      STDSED
192600210721     C     KLSTD1        CHAIN     STDSEDF                            99
192700210721     C                   CLOSE     STDSED
192800210721     C                   Endif
192900210721      ** - API action
193000210721     C                   Eval      A_DDACTN  = 'I'
193100210721      *
193200210721      ** - Trade reference
193300210721      *
193400210721     C                   Eval      A_DDTDRF  = *Blank
193500210721      *
193600210721      ** - Bulk reference
193700210721     C                   Eval      A_DDBLKR  = O_BLKR
193800210721      *
193900210721      ** - Security short name
194000210721     C                   Eval      A_DDSESN  = O_TDSS
194100210721      *
194200210721      ** - Client Number
194300210721      * if safe custody use FNCUST   else use Trade customer
194400210721     C                   If        BFCLAS = 'D' or BFCLAS = 'S'
194500210721     C                   Eval      A_DDCNUM  = FNCUST
194600210721     C                   Else
194700210721     C                   Eval      A_DDCNUM  = O_TCNR
194800210721     C                   Endif
194900210721      *
195000210721      ** - Customer shortname
195100210721     C                   Eval      A_DDCSSN  = *Blank
195200210721      *
195300210721      ** - Customer report name
195400210721     C                   Eval      A_DDCRNM  = *Blank
195500210721      *
195600210721      ** - Customer report town
195700210721     C                   Eval      A_DDCRTN  = *Blank
195800210721      *
195900210721      ** - Incomplete indicator
196000210721     C                   Eval      A_DDINCS  = O_TINC
196100210721      *
196200210721      ** - Trade type
196300210721     C                   Eval      A_DDTDTP  = O_TDTP
196400210721      *
196500210721      ** - Nominal
196600210721      * Format nominal amount based on Nominal decimal plases
196700210721     C                   Move      O_NOML        W_NOML
196800210721      *                  Remove leading Zero
196900210721     C                   If        W_N1 = '0' or W_N1 = ' '
197000210721     C                   Eval      W_N1 = *blank
197100210721     C                   If        W_N2 = '0' or W_N2 = ' '
197200210721     C                   Eval      W_N2 = *blank
197300210721     C                   If        W_N3 = '0' or W_N3 = ' '
197400210721     C                   Eval      W_N3 = *blank
197500210721     C                   If        W_N4 = '0' or W_N4 = ' '
197600210721     C                   Eval      W_N4 = *blank
197700210721     C                   If        W_N5 = '0' or W_N5 = ' '
197800210721     C                   Eval      W_N5 = *blank
197900210721     C                   If        W_N6 = '0' or W_N6 = ' '
198000210721     C                   Eval      W_N6 = *blank
198100210721     C                   If        W_N7 = '0' or W_N7 = ' '
198200210721     C                   Eval      W_N7 = *blank
198300210721     C                   If        W_N8 = '0' or W_N8 = ' '
198400210721     C                   Eval      W_N8 = *blank
198500210721     C                   If        W_N9 = '0' or W_N9 = ' '
198600210721     C                   Eval      W_N9 = *blank
198700210721     C                   If        W_N10 = '0' or W_N10 = ' '
198800210721     C                   Eval      W_N10 = *blank
198900210721     C                   If        W_N11 = '0' or W_N11 = ' '
199000210721     C                   Eval      W_N11 = *blank
199100210721     C                   Endif
199200210721     C                   Endif
199300210721     C                   Endif
199400210721     C                   Endif
199500210721     C                   Endif
199600210721     C                   Endif
199700210721     C                   Endif
199800210721     C                   Endif
199900210721     C                   Endif
200000210721     C                   Endif
200100210721     C                   Endif
200200210721     C                   If        TNMD = 0
200300210721     C                   If        W_N11 = ' '
200400210721     C                   Eval      W_N11 = *ZERO
200500210721     C                   Endif
200600210721     C                   Eval      A_DDNOML  = %trim(W_NOML0)
200700210721     C                   Endif
200800210721     C                   If        TNMD = 1
200900210721     C                   If        W_N11 = ' '
201000210721     C                   Eval      W_N11 = *ZERO
201100210721     C                   Endif
201200210721     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
201300210721     C                   Endif
201400210721     C                   If        TNMD = 2
201500210721     C                   If        W_N10 = ' '
201600210721     C                   Eval      W_N10 = *ZERO
201700210721     C                   Endif
201800210721     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
201900210721     C                   Endif
202000210721     C                   If        TNMD = 3
202100210721     C                   If        W_N9 = ' '
202200210721     C                   Eval      W_N9 = *ZERO
202300210721     C                   If        W_N10 = ' '
202400210721     C                   Eval      W_N10 = *ZERO
202500210721     C                   Endif
202600210721     C                   Endif
202700210721     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
202800210721     C                   Endif
202900210721     C                   If        TNMD = 4
203000210721     C                   If        W_N8 = ' '
203100210721     C                   Eval      W_N8 = *ZERO
203200210721     C                   If        W_N9  = ' '
203300210721     C                   Eval      W_N9  = *ZERO
203400210721     C                   If        W_N10 = ' '
203500210721     C                   Eval      W_N10 = *ZERO
203600210721     C                   Endif
203700210721     C                   Endif
203800210721     C                   Endif
203900210721     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
204000210721     C                   Endif
204100210721      *
204200210721      ** - Price/Disc/Yield
204300210721      * If not nil format with Price Decimal places  (15,8)
204400210721     C                   If        O_TPDY  > 0
204500210721     C                   Movel     O_TPDY        W_1508
204600210721      *                  Remove leading Zero
204700210721     C                   If        W_I1 = '0' or W_I1 = ' '
204800210721     C                   Eval      W_I1 = *blank
204900210721     C                   If        W_I2 = '0' or W_I2 = ' '
205000210721     C                   Eval      W_I2 = *blank
205100210721     C                   If        W_I3 = '0' or W_I3 = ' '
205200210721     C                   Eval      W_I3 = *blank
205300210721     C                   If        W_I4 = '0' or W_I4 = ' '
205400210721     C                   Eval      W_I4 = *blank
205500210721     C                   If        W_I5 = '0' or W_I5 = ' '
205600210721     C                   Eval      W_I5 = *blank
205700210721     C                   If        W_I6 = '0' or W_I6 = ' '
205800210721     C                   Eval      W_I6 = *blank
205900210721     C                   Endif
206000210721     C                   Endif
206100210721     C                   Endif
206200210721     C                   Endif
206300210721     C                   Endif
206400210721     C                   Endif
206500210721     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
206600210721     c                   Eval      W_1508  = *blank
206700210721     C                   Endif
206800210721      *
206900210721      ** - Value Date
207000210721      * Format Date as DDMMYY
207100210721     C                   Eval      ZDATFM = 'D'
207200210721     C                   CALLB     'ZDATE2'
207300210721     C                   PARM                    O_TDVD
207400210721     C                   PARM                    ZDATFM            1
207500210721     C                   PARM                    ZDATE             6 0
207600210721     C                   PARM                    ZADATE            7
207700210721     C                   Movel     ZDATE         A_DDTDVD
207800210721      *
207900210721      ** - Booking Branch
208000210721      * Overwrite branch to consolidated branch
208100210721     C                   Eval      A_DDBRCD  = FNBRCA
208200210721      *
208300210721      ** - Book
208400210721     C                   If        WrkBook = *Blank
208500210721     C                   Eval      A_DDBPBK  = O_TDBK
208600210721     C                   else
208700210721     C                   Eval      A_DDBPBK  = WrkBook
208800210721     C                   endif
208900210721      *
209000210721      ** - Clearance type
209100210721     C                   If        O_TDTP    = 'TS'
209200210721     C                   Eval      A_DDCLTY  = S_SCLS
209300210721     C                   Eval      A_DDCLTY2 = S_SCLS
209400210721     C                   Else
209500210721     C                   Eval      A_DDCLTY  = S_SCLP
209600210721     C                   Eval      A_DDCLTY2 = S_SCLP
209700210721     C                   endif
209800210721      *
209900210721      ** - Settlement Currency
210000210721     C                   Eval      A_DDSETC  = S_SCCY                                       O_SETC
210100210721      *
210200210721      ** - REALLOWANCE
210300210721      * If not nil format with Price Decimal places  (9,5)  ????
210400210721     C                   If        O_RALL  > 0
210500210721     C                   Movel     O_RALL        W_0905
210600210721     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
210700210721     c                   Eval      W_0905  = *blank
210800210721     C                   Endif
210900210721     c                   Eval      A_DDRALL = *blank                                          ???
211000210721      *
211100210721      ** - Market Center
211200210721     C                   Eval      A_DDMRKT  = O_TMKC
211300210721      *
211400210721      ** - Capacity
211500210721      * Capacity May not be required ????
211600210721     C                   Movel     O_TCAP        A_DDCPCY
211700210721     c                   Eval      A_DDCPCY = *blank                                          ???
211800210721      *
211900210721      ** - Price
212000210721      * If not nil format with Price Decimal places  (15,8) ???
212100210721     C                   If        O_PRIC > 0
212200210721     C                   Movel     O_PRIC        W_1508
212300210721     C                   If        W_I1 = '0' or W_I1 = ' '
212400210721     C                   Eval      W_I1 = *blank
212500210721     C                   If        W_I2 = '0' or W_I2 = ' '
212600210721     C                   Eval      W_I2 = *blank
212700210721     C                   If        W_I3 = '0' or W_I3 = ' '
212800210721     C                   Eval      W_I3 = *blank
212900210721     C                   If        W_I4 = '0' or W_I4 = ' '
213000210721     C                   Eval      W_I4 = *blank
213100210721     C                   If        W_I5 = '0' or W_I5 = ' '
213200210721     C                   Eval      W_I5 = *blank
213300210721     C                   If        W_I6 = '0' or W_I6 = ' '
213400210721     C                   Eval      W_I6 = *blank
213500210721     C                   Endif
213600210721     C                   Endif
213700210721     C                   Endif
213800210721     C                   Endif
213900210721     C                   Endif
214000210721     C                   Endif
214100210721     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
214200210721     c                   Eval      W_1508  = *blank
214300210721     C                   Endif
214400210721     c                   Eval      A_DDPRIC = *blank                                          ???
214500210721      *
214600210721      ** - Ex Dividend
214700210721     C                   Eval      A_DDEXDV = *Blank                                          O_EXDV
214800210721      *
214900210721      ** - Fiscal Price
215000210721      * If not nil format with Price Decimal places  (15,8)    ???
215100210721     C                   If        O_FSPR > 0
215200210721     C                   Movel     O_FSPR        W_1508
215300210721     C                   If        W_I1 = '0' or W_I1 = ' '
215400210721     C                   Eval      W_I1 = *blank
215500210721     C                   If        W_I2 = '0' or W_I2 = ' '
215600210721     C                   Eval      W_I2 = *blank
215700210721     C                   If        W_I3 = '0' or W_I3 = ' '
215800210721     C                   Eval      W_I3 = *blank
215900210721     C                   If        W_I4 = '0' or W_I4 = ' '
216000210721     C                   Eval      W_I4 = *blank
216100210721     C                   If        W_I5 = '0' or W_I5 = ' '
216200210721     C                   Eval      W_I5 = *blank
216300210721     C                   If        W_I6 = '0' or W_I6 = ' '
216400210721     C                   Eval      W_I6 = *blank
216500210721     C                   Endif
216600210721     C                   Endif
216700210721     C                   Endif
216800210721     C                   Endif
216900210721     C                   Endif
217000210721     C                   Endif
217100210721     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
217200210721     c                   Eval      W_1508  = *blank
217300210721     C                   Endif
217400210721     c                   Eval      A_DDFSPR = *blank                                            ???
217500210721      *
217600210721      ** - Book profit center
217700210721     C                   Eval      A_DDBPRC  = O_BPRC
217800210721      *
217900210721      ** - Trans profit center
218000210721     C                   Eval      A_DDTPRC  = O_TPRC
218100210721      *
218200210721      ** - Trader ID
218300210721     C                   Eval      A_DDTDID  = O_TDID
218400210721      *
218500210721      ** - Trade date
218600210721      * Format Date as DDMMYY
218700210721     C                   Eval      ZDATFM = 'D'
218800210721     C                   CALLB     'ZDATE2'
218900210721     C                   PARM                    O_TDDT
219000210721     C                   PARM                    ZDATFM            1
219100210721     C                   PARM                    ZDATE             6 0
219200210721     C                   PARM                    ZADATE            7
219300210721     C                   Movel     ZDATE         A_DDTDDT
219400210721      *
219500210721      ** - Trade Sub type
219600210721     C                   Eval      A_DDTSUB  = O_TSUB
219700210721      *
219800210721      ** - Link Ref  Never on duplication
219900210721     C                   Eval      A_DDLKRF = *blank                                          O_LKRF
220000210721      *
220100210721      ** - Market indicator  ????
220200210721     C                   Eval      A_DDTDMI = O_TDMI
220300210721      *
220400210721      ** - ISMA / IPMA
220500210721      *  Not sure AIIP must be taken ????
220600210721     C                   Eval      A_DDAIIP = O_AIIP
220700210721      *
220800210721      ** - Narrative
220900210721     C                   Eval      A_DDTDNR = O_TDNR
221000210721      *
221100210721      ** - P order number never on replication
221200210721      * Will never be from TOF
221300210721     C                   Eval      A_DDORDE  = *Blank
221400210721      *
221500210721      ** - Accrued indicator
221600210721     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
221700210721      *
221800210721      ** - Days Adj/sign
221900210721     C                   If        O_DADJ > 0
222000210721     C                   Movel     O_DADJ        A_DDDADJ
222100210721     C                   Endif
222200210721     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
222300210721      *
222400210721      ** - Act/Diff Ind
222500210721     C                   Eval      A_DDACTD  =  *Blank
222600210721      *
222700210721      ** - Int Amnr/Sign
222800210721      * If not nil format with Nominal currncy position ????
222900210721     C                   If        O_ITRA > 0
223000210721     C                   Move      O_ITRA        W_ChgL
223100210721     C                   If        A6NBDP = 0
223200210721     C                   Eval      A_DDITRA  = W_ChgL
223300210721     C                   Endif
223400210721     C                   If        A6NBDP = 1
223500210721     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
223600210721     C                   Endif
223700210721     C                   If        A6NBDP = 2
223800210721     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
223900210721     C                   Endif
224000210721     C                   If        A6NBDP = 3
224100210721     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
224200210721     C                   Endif
224300210721     C                   Endif
224400210721     C                   Eval      A_DDITRA  = *blank                                          ????
224500210721     C                   clear                   W_ChgL
224600210721      *
224700210721      ** - Origin
224800210721     C                   Eval      A_DDINOR  = *Blank
224900210721      *
225000210721      ** - Message Key
225100210721     C                   Eval      A_DDMSGK  = *Blank
225200210721      *
225300210721      ** - Notification method
225400210721     C                   Eval      A_DDNTMT  = *Blank
225500210721      *
225600210721      * Ignoring following block
225700210721     C                   Eval      A_DDNOM1  = *Blank
225800210721     C                   Eval      A_DDTDV1  = *Blank
225900210721     C                   Eval      A_DDACI1  = *Blank
226000210721     C                   Eval      A_DDDAD1  = *Blank
226100210721     C                   Eval      A_DDACT1  = *Blank
226200210721     C                   Eval      A_DDITR1  = *Blank
226300210721      *
226400210721      ** - Exchange rate
226500210721      * If not nil format with rate Decimal places  (13,8)
226600210721     C                   If        O_TDER > 0
226700210721     C                   Movel     O_TDER        W_1308
226800210721     C                   If        W_I1 = '0' or W_I1 = ' '
226900210721     C                   Eval      W_I1 = *blank
227000210721     C                   If        W_I2 = '0' or W_I2 = ' '
227100210721     C                   Eval      W_I2 = *blank
227200210721     C                   If        W_I3 = '0' or W_I3 = ' '
227300210721     C                   Eval      W_I3 = *blank
227400210721     C                   If        W_I4 = '0' or W_I4 = ' '
227500210721     C                   Eval      W_I4 = *blank
227600210721     C                   If        W_I5 = '0' or W_I5 = ' '
227700210721     C                   Eval      W_I5 = *blank
227800210721     C                   If        W_I6 = '0' or W_I6 = ' '
227900210721     C                   Eval      W_I6 = *blank
228000210721     C                   Endif
228100210721     C                   Endif
228200210721     C                   Endif
228300210721     C                   Endif
228400210721     C                   Endif
228500210721     C                   Endif
228600210721     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
228700210721     c                   Eval      W_1508  = *blank
228800210721     C                   Endif
228900210721     c                   Eval      A_DDTDER = *blank                                            ???
229000210721      *
229100210721      ** - Exchange rateM/D
229200210721     C                   Eval      A_DDSMDI  = *Blank
229300210721      *
229400210721      ** - Margin
229500210721     C                   Eval      A_DDFXMP  = *Blank
229600210721      *
229700210721      ** - Base currency rate
229800210721     C                   Eval      A_DDBRTE  = *Blank
229900210721      *
230000210721      *  Settlement field are left blank
230100210721     C                   If        O_TDTP    = 'TS'
230200210721     C                   Move      S_SRSM        A_DDSMTH
230300210721     C                   Else
230400210721     C                   Move      S_SPSM        A_DDSMTH
230500210721     C                   endif
230600210721     C                   Eval      A_DDORBR  = *Blank
230700210721     C                   If        O_TDTP    = 'TS'
230800210721     C                   Eval      A_DDPYFM  = *Blank
230900210721     C                   Else
231000210721     C                   Eval      A_DDPYFM  = S_SPAT
231100210721     C                   endif
231200210721     C                   Eval      A_DDPFSN  = *Blank
231300210721     C                   Eval      A_DDPFNM  = *Blank
231400210721     C                   Eval      A_DDPFTN  = *Blank
231500210721     C                   Eval      A_DDPFAN  = *Blank
231600210721     C                   Eval      A_DDPFSW  = *Blank
231700210721     C                   Eval      A_DDPYFB  = *Blank
231800210721     C                   If        O_TDTP    = 'TP'
231900210721     C                   Eval      A_DDPAYT  = *Blank
232000210721     C                   Else
232100210721     C                   Eval      A_DDPAYT  = S_SRAC
232200210721     C                   endif
232300210721     C                   Eval      A_DDPTSN  = *Blank
232400210721     C                   Eval      A_DDPTNM  = *Blank
232500210721     C                   Eval      A_DDPTTN  = *Blank
232600210721     C                   Eval      A_DDPTAN  = *Blank
232700210721     C                   Eval      A_DDPTSI  = *Blank
232800210721     C                   Eval      A_DDPYTB  = *Blank
232900210721     C                   Eval      A_DDTDFA  = *Blank
233000210721     C                   Eval      A_DDFASN  = *Blank
233100210721     C                   Eval      A_DDFANM  = *Blank
233200210721     C                   Eval      A_DDFATN  = *Blank
233300210721     C                   Eval      A_DDFASW  = *Blank
233400210721     C                   Eval      A_DDASNM  = *Blank
233500210721     C                   Eval      A_DDDELF  = S_SDFO
233600210721     C                   Eval      A_DDDFSN  = *Blank
233700210721     C                   Eval      A_DDDFNM  = *Blank
233800210721     C                   Eval      A_DDDFTN  = *Blank
233900210721     C                   Eval      A_DDDFSI  = *Blank
234000210721     C                   Eval      A_DDDELT  = S_SDTO
234100210721     C                   Eval      A_DDDTSN  = *Blank
234200210721     C                   Eval      A_DDDTNM  = *Blank
234300210721     C                   Eval      A_DDDTTN  = *Blank
234400210721     C                   Eval      A_DDDTSI  = *Blank
234500210721     C                   Eval      A_DDDFFA  = *Blank
234600210721     C                   Eval      A_DDD1SN  = *Blank
234700210721     C                   Eval      A_DDD1NM  = *Blank
234800210721     C                   Eval      A_DDD1TN  = *Blank
234900210721     C                   Eval      A_DDD1SI  = *Blank
235000210721     C                   Eval      A_DDDTFA  = *Blank
235100210721     C                   Eval      A_DDD2SN  = *Blank
235200210721     C                   Eval      A_DDD2NM  = *Blank
235300210721     C                   Eval      A_DDD2TN  = *Blank
235400210721     C                   Eval      A_DDD2SI  = *Blank
235500210721     C                   Eval      A_DDTDSI  = *Blank
235600210721      *
235700210721      *
235800210721      ** - In Currency in F72
235900210721     C                   Eval      A_DDICCY  = *blank
236000210721      *
236100210721      ** - Profit Center
236200210721     C                   Eval      A_DDPRFC  = *blank                                         O_PRFC
236300210721      *
236400210721      ** - Priority code
236500210721     C                   Eval      A_DDPRYC  = *blank                                         O_PRYC
236600210721      *
236700210721      ** - Pay Code
236800210721     C                   If        O_TDTP    = 'TS'
236900210721     C                   Eval      A_DDPCOD  = S_SPCS
237000210721     C                   Else
237100210721     C                   Eval      A_DDPCOD  = S_SPCP
237200210721     C                   endif
237300210721      *
237400210721      ** - Auto settle ind
237500210721     C                   Eval      A_DDAUTS  = S_SASI
237600210721      *
237700210721      ** - Brok Comm code
237800210721     C                   Eval      A_DDTBCC  =  O_TBCC
237900210721      *
238000210721      ** - Brok Com Amount
238100210721      * If not nil format with Nominal currncy position
238200210721     C                   If        O_TBCA > 0
238300210721     C                   Move      O_TBCA        W_ChgL
238400210721     C                   If        A6NBDP = 0
238500210721     C                   Eval      A_DDTBCA  = W_ChgL
238600210721     C                   Endif
238700210721     C                   If        A6NBDP = 1
238800210721     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
238900210721     C                   Endif
239000210721     C                   If        A6NBDP = 2
239100210721     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
239200210721     C                   Endif
239300210721     C                   If        A6NBDP = 3
239400210721     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
239500210721     C                   Endif
239600210721     C                   Endif
239700210721     C                   clear                   W_ChgL
239800210721      *
239900210721      ** - Cust com code
240000210721     C                   Eval      A_DDTCCC  = O_TCCC
240100210721      *
240200210721      ** - Cust Comm Amount
240300210721      * If not nil format with Nominal currncy position
240400210721     C                   If        O_TCCA > 0
240500210721     C                   Move      O_TCCA        W_ChgL
240600210721     C                   If        A6NBDP = 0
240700210721     C                   Eval      A_DDTCCA  = W_ChgL
240800210721     C                   Endif
240900210721     C                   If        A6NBDP = 1
241000210721     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
241100210721     C                   Endif
241200210721     C                   If        A6NBDP = 2
241300210721     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
241400210721     C                   Endif
241500210721     C                   If        A6NBDP = 3
241600210721     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
241700210721     C                   Endif
241800210721     C                   Endif
241900210721     C                   clear                   W_ChgL
242000210721      *
242100210721      ** - Chg code 1
242200210721     C                   Eval      A_DDTCC1  = O_TCC1
242300210721      *
242400210721      ** - Chg Amount 1
242500210721      * If not nil format with Nominal currncy position
242600210721     C                   If        O_TCA1 > 0
242700210721     C                   Move      O_TCA1        W_ChgL
242800210721     C                   If        A6NBDP = 0
242900210721     C                   Eval      A_DDTCA1  = W_ChgL
243000210721     C                   Endif
243100210721     C                   If        A6NBDP = 1
243200210721     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
243300210721     C                   Endif
243400210721     C                   If        A6NBDP = 2
243500210721     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
243600210721     C                   Endif
243700210721     C                   If        A6NBDP = 3
243800210721     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
243900210721     C                   Endif
244000210721     C                   Endif
244100210721     C                   clear                   W_ChgL
244200210721      *
244300210721      ** - Chg code 2
244400210721     C                   Eval      A_DDTCC2  = O_TCC2
244500210721      *
244600210721      ** - Chg Amount 2
244700210721      * If not nil format with Nominal currncy position
244800210721     C                   If        O_TCA2 > 0
244900210721     C                   Move      O_TCA2        W_ChgL
245000210721     C                   If        A6NBDP = 0
245100210721     C                   Eval      A_DDTCA2  = W_ChgL
245200210721     C                   Endif
245300210721     C                   If        A6NBDP = 1
245400210721     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
245500210721     C                   Endif
245600210721     C                   If        A6NBDP = 2
245700210721     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
245800210721     C                   Endif
245900210721     C                   If        A6NBDP = 3
246000210721     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
246100210721     C                   Endif
246200210721     C                   Endif
246300210721     C                   clear                   W_ChgL
246400210721      ** - Chg code 3
246500210721      *
246600210721     C                   Eval      A_DDTCC3  = O_TCC3
246700210721      *
246800210721      ** - Chg Amount 3
246900210721      * If not nil format with Nominal currncy position
247000210721     C                   If        O_TCA3 > 0
247100210721     C                   Move      O_TCA3        W_ChgL
247200210721     C                   If        A6NBDP = 0
247300210721     C                   Eval      A_DDTCA3  = W_ChgL
247400210721     C                   Endif
247500210721     C                   If        A6NBDP = 1
247600210721     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
247700210721     C                   Endif
247800210721     C                   If        A6NBDP = 2
247900210721     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
248000210721     C                   Endif
248100210721     C                   If        A6NBDP = 3
248200210721     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
248300210721     C                   Endif
248400210721     C                   Endif
248500210721     C                   clear                   W_ChgL
248600210721      ** - Chg code 4
248700210721      *
248800210721     C                   Eval      A_DDTCC4  = O_TCC4
248900210721      *
249000210721      ** - Chg Amount 4
249100210721      * If not nil format with Nominal currncy position
249200210721     C                   If        O_TCA4 > 0
249300210721     C                   Move      O_TCA4        W_ChgL
249400210721     C                   If        A6NBDP = 0
249500210721     C                   Eval      A_DDTCA4  = W_ChgL
249600210721     C                   Endif
249700210721     C                   If        A6NBDP = 1
249800210721     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
249900210721     C                   Endif
250000210721     C                   If        A6NBDP = 2
250100210721     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
250200210721     C                   Endif
250300210721     C                   If        A6NBDP = 3
250400210721     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
250500210721     C                   Endif
250600210721     C                   Endif
250700210721     C                   clear                   W_ChgL
250800210721      *
250900210721      ** - Chg code 5
251000210721     C                   Eval      A_DDTCC5  = O_TCC5
251100210721      *
251200210721      ** - Chg Amount 5
251300210721      * If not nil format with Nominal currncy position
251400210721     C                   If        O_TCA5 > 0
251500210721     C                   Move      O_TCA5        W_ChgL
251600210721     C                   If        A6NBDP = 0
251700210721     C                   Eval      A_DDTCA5  = W_ChgL
251800210721     C                   Endif
251900210721     C                   If        A6NBDP = 1
252000210721     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
252100210721     C                   Endif
252200210721     C                   If        A6NBDP = 2
252300210721     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
252400210721     C                   Endif
252500210721     C                   If        A6NBDP = 3
252600210721     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
252700210721     C                   Endif
252800210721     C                   Endif
252900210721     C                   clear                   W_ChgL
253000210721      *
253100210721      ** - Chg code 6
253200210721     C                   Eval      A_DDTCC6  = O_TCC6
253300210721      *
253400210721      ** - Chg Amount 6
253500210721      * If not nil format with Nominal currncy position
253600210721     C                   If        O_TCA6 > 0
253700210721     C                   Move      O_TCA6        W_ChgL
253800210721     C                   If        A6NBDP = 0
253900210721     C                   Eval      A_DDTCA6  = W_ChgL
254000210721     C                   Endif
254100210721     C                   If        A6NBDP = 1
254200210721     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
254300210721     C                   Endif
254400210721     C                   If        A6NBDP = 2
254500210721     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
254600210721     C                   Endif
254700210721     C                   If        A6NBDP = 3
254800210721     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
254900210721     C                   Endif
255000210721     C                   Endif
255100210721     C                   clear                   W_ChgL
255200210721      *
255300210721      ** - Chg code 7
255400210721     C                   Eval      A_DDTCC7  = O_TCC7
255500210721      *
255600210721      ** - Chg Amount 7
255700210721      * If not nil format with Nominal currncy position
255800210721     C                   If        O_TCA7 > 0
255900210721     C                   Move      O_TCA7        W_ChgL
256000210721     C                   If        A6NBDP = 0
256100210721     C                   Eval      A_DDTCA7  = W_ChgL
256200210721     C                   Endif
256300210721     C                   If        A6NBDP = 1
256400210721     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
256500210721     C                   Endif
256600210721     C                   If        A6NBDP = 2
256700210721     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
256800210721     C                   Endif
256900210721     C                   If        A6NBDP = 3
257000210721     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
257100210721     C                   Endif
257200210721     C                   Endif
257300210721     C                   clear                   W_ChgL
257400210721      *
257500210721      ** - Tax amount    always blank on replication
257600210721      * If not nil format with Nominal currncy position
257700210721     C                   If        O_TAXA > 0
257800210721     C                   Move      O_TAXA        W_ChgL
257900210721     C                   If        A6NBDP = 0
258000210721     C                   Eval      A_DDTAXA  = W_ChgL
258100210721     C                   Endif
258200210721     C                   If        A6NBDP = 1
258300210721     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
258400210721     C                   Endif
258500210721     C                   If        A6NBDP = 2
258600210721     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
258700210721     C                   Endif
258800210721     C                   If        A6NBDP = 3
258900210721     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
259000210721     C                   Endif
259100210721     C                   Endif
259200210721     C                   Eval      A_DDTAXA  = *blank                                            ???
259300210721     C                   clear                   W_ChgL
259400210721      *
259500210721      ** - EU tax amount in nominall currency always balnk on replication
259600210721      * If not nil format with Nominal currncy position
259700210721     C                   If        O_EUTX > 0
259800210721     C                   Move      O_EUTX        W_ChgL
259900210721     C                   If        A6NBDP = 0
260000210721     C                   Eval      A_DDEUTX  = W_ChgL
260100210721     C                   Endif
260200210721     C                   If        A6NBDP = 1
260300210721     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
260400210721     C                   Endif
260500210721     C                   If        A6NBDP = 2
260600210721     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
260700210721     C                   Endif
260800210721     C                   If        A6NBDP = 3
260900210721     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
261000210721     C                   Endif
261100210721     C                   Endif
261200210721     C                   Eval      A_DDEUTX  = *blank                                            ???
261300210721     C                   clear                   W_ChgL
261400210721      *
261500210721      ** - Brok Comm  Rebate
261600210721      * If not nil format with Nominal currency position
261700210721     C                   If        O_BCMR > 0
261800210721     C                   Move      O_BCMR        W_ChgL
261900210721     C                   If        A6NBDP = 0
262000210721     C                   Eval      A_DDBCMR  = W_ChgL
262100210721     C                   Endif
262200210721     C                   If        A6NBDP = 1
262300210721     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
262400210721     C                   Endif
262500210721     C                   If        A6NBDP = 2
262600210721     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
262700210721     C                   Endif
262800210721     C                   If        A6NBDP = 3
262900210721     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
263000210721     C                   Endif
263100210721     C                   Endif
263200210721     C                   clear                   W_ChgL
263300210721      *
263400210721      ** - Cust Comm rebate
263500210721      * If not nil format with Nominal currency position
263600210721     C                   If        O_CCMR > 0
263700210721     C                   Move      O_CCMR        W_ChgL
263800210721     C                   If        A6NBDP = 0
263900210721     C                   Eval      A_DDCCMR  = W_ChgL
264000210721     C                   Endif
264100210721     C                   If        A6NBDP = 1
264200210721     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
264300210721     C                   Endif
264400210721     C                   If        A6NBDP = 2
264500210721     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
264600210721     C                   Endif
264700210721     C                   If        A6NBDP = 3
264800210721     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
264900210721     C                   Endif
265000210721     C                   Endif
265100210721     C                   clear                   W_ChgL
265200210721      *
265300210721      ** - Tax rebate always blank on replication
265400210721      * If not nil format with Nominal currency position
265500210721     C                   If        O_TXRB > 0
265600210721     C                   Move      O_TXRB        W_ChgL
265700210721     C                   If        A6NBDP = 0
265800210721     C                   Eval      A_DDTXRB  = W_ChgL
265900210721     C                   Endif
266000210721     C                   If        A6NBDP = 1
266100210721     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
266200210721     C                   Endif
266300210721     C                   If        A6NBDP = 2
266400210721     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
266500210721     C                   Endif
266600210721     C                   If        A6NBDP = 3
266700210721     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
266800210721     C                   Endif
266900210721     C                   Endif
267000210721     C                   Eval      A_DDTXRB  = *blank                                            ???
267100210721     C                   clear                   W_ChgL
267200210721      *
267300210721      ** - Portfolio reference Always Blank on replication
267400210721     C                   Eval      A_DDPTFR   = *Blank
267500210721      *  Extension file TRADSDX1  Not sure it needs to be setup
267600210721      *
267700210721      *  Settlement Message Request
267800210721     C                   Eval      A_ADDGMES  = *Blank
267900210721      *
268000210721      *  Time of Trade
268100210721     C                   Eval      A_ADDTRTT  = *Blank
268200210721      *
268300210721      *  Instructions Type
268400210721     C                   Eval      A_ADDINST  = *Blank                                 O_T1INST
268500210721      *
268600210721      *   Instructions sub-type
268700210721     C                   Eval      A_ADDINSS  = *Blank                                O_T1INSS
268800210721      *
268900210721      *   Euroclear/Cedel code
269000210721     C                   Eval      A_ADDEUCL  = *Blank                                  O_T1EUCL
269100210721      *
269200210721      *  Safekeeping Account (MT580)
269300210721     C                   Eval      A_ADDSAFA  = *Blank                                  O_T1SAFA
269400210721      *
269500210721      *  Requested Priority
269600210721     C                   Eval      A_ADDRPTY  = *Blank                                  O_T1RPTY
269700210721      *
269800210721      *  Guaranteed Delivery
269900210721     C                   Eval      A_ADDGDEL  = *Blank
270000210721      *
270100210721      *  Sender's Role
270200210721     C                   Eval      A_ADDSROL  = *Blank
270300210721      *
270400210721      *  Fungibilty Code
270500210721     C                   Eval      A_ADDFCOD  = *Blank
270600210721      *
270700210721      *  Fungible Trade Indicator
270800210721     C                   Eval      A_ADDFTID  = *Blank
270900210721      *
271000210721      *  Confirmation Message Request
271100210721     C                   Eval      A_ADDGMEC  = *Blank
271200210721      *
271300210721      *  Customer/Counterparty Ind.
271400210721     C                   Eval      A_ADDCCID  = *Blank
271500210721      *
271600210721      *  Further Id.
271700210721     C                   Eval      A_ADDFID1  = *Blank
271800210721      *
271900210721      *  Standard Instructions' Overr  ?
272000210721     C                   Eval      A_ADDIORA  = *Blank
272100210721      *
272200210721      *  ISO15022 Messages Ind.
272300210721     C                   Eval      A_ADDSNEW  = *Blank
272400210721      *
272500210721      *  Stamp Status
272600210721     C                   Eval      A_ADDSTMP  = *Blank
272700210721      *
272800210721      *  Charity Identifier
272900210721     C                   Eval      A_ADDCHID  = *Blank
273000210721      *
273100210721      *  Transaction Report Marker
273200210721     C                   Eval      A_ADDTRRM  =  *Blank
273300210721      *
273400210721      * Ignore following block
273500210721     C                   Eval      A_BDDGMES  =  *Blank
273600210721     C                   Eval      A_BDDTRTT  =  *Blank
273700210721     C                   Eval      A_BDDINST   = *Blank
273800210721     C                   Eval      A_BDDINSS   = *Blank
273900210721     C                   Eval      A_BDDEUCL   = *Blank
274000210721     C                   Eval      A_BDDSAFA   = *Blank
274100210721     C                   Eval      A_BDDRPTY   = *Blank
274200210721     C                   Eval      A_BDDGDEL   = *Blank
274300210721     C                   Eval      A_BDDSROL   = *Blank
274400210721     C                   Eval      A_BDDFCOD   = *Blank
274500210721     C                   Eval      A_BDDFTID   = *Blank
274600210721     C                   Eval      A_BDDGMEC   = *Blank
274700210721     C                   Eval      A_BDDCCID   = *Blank
274800210721     C                   Eval      A_BDDFID1   = *Blank
274900210721     C                   Eval      A_BDDIORA   = *Blank
275000210721     C                   Eval      A_BDDSNEW   = *Blank
275100210721     C                   Eval      A_BDDSTMP   = *Blank
275200210721     C                   Eval      A_BDDCHID   = *Blank
275300210721     C                   Eval      A_BDDTRRM   = *Blank
275400210721      *
275500210721      * Ignore following block
275600210721     C                   Eval      A_AESAP1N   = *Blank
275700210721     C                   Eval      A_DDA1SN    = *Blank
275800210721     C                   Eval      A_DDA1NM    = *Blank
275900210721     C                   Eval      A_DDA1TN    = *Blank
276000210721     C                   Eval      A_DDA1SI    = *Blank
276100210721     C                   Eval      A_AESAP1L   = *Blank
276200210721     C                   Eval      A_AESAP2N   = *Blank
276300210721     C                   Eval      A_DDA2SN   =  *Blank
276400210721     C                   Eval      A_DDA2NM   =  *Blank
276500210721     C                   Eval      A_DDA2TN   =  *Blank
276600210721     C                   Eval      A_DDA2SI   =  *Blank
276700210721     C                   Eval      A_AESAP2L  =  *Blank
276800210721     C                   Eval      A_AESAWIN  =  *Blank
276900210721     C                   Eval      A_DDAISN   =  *Blank
277000210721     C                   Eval      A_DDAINM   =  *Blank
277100210721     C                   Eval      A_DDAITN   =  *Blank
277200210721     C                   Eval      A_DDAISI   =  *Blank
277300210721     C                   Eval      A_AESAWIL  =  *Blank
277400210721     C                   Eval      A_AESBOFN  =  *Blank
277500210721     C                   Eval      A_DDBMSN   =  *Blank
277600210721     C                   Eval      A_DDBMNM   =  *Blank
277700210721     C                   Eval      A_DDBMTN   =  *Blank
277800210721     C                   Eval      A_DDBMSI   =  *Blank
277900210721     C                   Eval      A_AESBOF1  =  *Blank
278000210721     C                   Eval      A_AESBOF2  =  *Blank
278100210721     C                   Eval      A_AESACL1  =  *Blank
278200210721     C                   Eval      A_AESACL2  =  *Blank
278300210721     C                   Eval      A_AESSRL1  =  *Blank
278400210721     C                   Eval      A_AESSRL2  =  *Blank
278500210721     C                   Eval      A_AESSRL3  =  *Blank
278600210721     C                   Eval      A_AESFIN1  =  *Blank
278700210721     C                   Eval      A_AESFIN2   = *Blank
278800210721     C                   Eval      A_AESRED1   = *Blank
278900210721     C                   Eval      A_AESRED2   = *Blank
279000210721     C                   Eval      A_AESNAL1   = *Blank
279100210721     C                   Eval      A_AESNAL2   = *Blank
279200210721     C                   Eval      A_AESIPYN   = *Blank
279300210721     C                   Eval      A_DDIPSN    = *Blank
279400210721     C                   Eval      A_DDIPNM    = *Blank
279500210721     C                   Eval      A_DDIPTN    = *Blank
279600210721     C                   Eval      A_DDIPSI    = *Blank
279700210721     C                   Eval      A_AESIPYL   = *Blank
279800210721     C                   Eval      A_AESCTYN   = *Blank
279900210721     C                   Eval      A_AESCTYL   = *Blank
280000210721     C                   Eval      A_AESSA1N   = *Blank
280100210721     C                   Eval      A_DDCZSN    = *Blank
280200210721     C                   Eval      A_DDCSNM    = *Blank
280300210721     C                   Eval      A_DDCSTN    = *Blank
280400210721     C                   Eval      A_DDCSSI    = *Blank
280500210721     C                   Eval      A_AESSA1L   = *Blank
280600210721     C                   Eval      A_AESSKAN   = *Blank
280700210721     C                   Eval      A_DDUSSN    = *Blank
280800210721     C                   Eval      A_DDUSNM    = *Blank
280900210721     C                   Eval      A_DDUSTN    = *Blank
281000210721     C                   Eval      A_DDUSSI    = *Blank
281100210721     C                   Eval      A_AESSKAL   = *Blank
281200210721     C                   Eval      A_AESCCTN   = *Blank
281300210721     C                   Eval      A_DDCCSN    = *Blank
281400210721     C                   Eval      A_DDCCNM    = *Blank
281500210721     C                   Eval      A_DDCCTN    = *Blank
281600210721     C                   Eval      A_DDCCSI    = *Blank
281700210721     C                   Eval      A_AESDCTL   = *Blank
281800210721     C                   Eval      A_AESRSSN   = *Blank
281900210721     C                   Eval      A_DDRSSN    = *Blank
282000210721     C                   Eval      A_DDRSNM    = *Blank
282100210721     C                   Eval      A_DDRSTN    = *Blank
282200210721     C                   Eval      A_DDRSSI    = *Blank
282300210721     C                   Eval      A_AESRSS1   = *Blank
282400210721     C                   Eval      A_AESRSS2   = *Blank
282500210721     C                   Eval      A_AESRSS3   = *Blank
282600210721     C                   Eval      A_AESRSS4   = *Blank
282700210721     C                   Eval      A_AESDSSN   = *Blank
282800210721     C                   Eval      A_AESDSS1   = *Blank
282900210721     C                   Eval      A_AESDSS2   = *Blank
283000210721     C                   Eval      A_AESDSS3   = *Blank
283100210721     C                   Eval      A_AESDSS4   = *Blank
283200210721     C                   Eval      A_AESBSSN   = *Blank
283300210721     C                   Eval      A_AESBSS1   = *Blank
283400210721     C                   Eval      A_AESBSS2   = *Blank
283500210721     C                   Eval      A_AESINVE   = *Blank
283600210721     C                   Eval      A_DDIOSN    = *Blank
283700210721     C                   Eval      A_DDIONM    = *Blank
283800210721     C                   Eval      A_DDIOTN    = *Blank
283900210721     C                   Eval      A_DDIOSI    = *Blank
284000210721     C                   Eval      A_AESIMMD1  = *Blank
284100210721     C                   Eval      A_DDI1SN    = *Blank
284200210721     C                   Eval      A_DDI1NM    = *Blank
284300210721     C                   Eval      A_DDI1TN    = *Blank
284400210721     C                   Eval      A_DDI1SI    = *Blank
284500210721     C                   Eval      A_AESIMSA1  = *Blank
284600210721     C                   Eval      A_AESIMMD2  = *Blank
284700210721     C                   Eval      A_DDI2SN    = *Blank
284800210721     C                   Eval      A_DDI2NM    = *Blank
284900210721     C                   Eval      A_DDI2TN    = *Blank
285000210721     C                   Eval      A_DDI2SI    = *Blank
285100210721     C                   Eval      A_AESIMSA2  = *Blank
285200210721     C                   Eval      A_AESIMMD3  = *Blank
285300210721     C                   Eval      A_AESIMSA3  = *Blank
285400210721     C                   Eval      A_AESIMMD4  = *Blank
285500210721     C                   Eval      A_AESIMSA4  = *Blank
285600210721     C                   Eval      A_AESIMMD5  = *Blank
285700210721     C                   Eval      A_AESIMSA5  = *Blank
285800210721     C                   Eval      A_AESIMMD6  = *Blank
285900210721     C                   Eval      A_AESIMSA6  = *Blank
286000210721     C                   Eval      A_AESIMMD7  = *Blank
286100210721     C                   Eval      A_AESIMSA7  = *Blank
286200210721     C                   Eval      A_AESIMMD8  = *Blank
286300210721     C                   Eval      A_AESIMSA8  = *Blank
286400210721     C                   Eval      A_AESIMMD9  = *Blank
286500210721     C                   Eval      A_AESIMSA9  = *Blank
286600210721     C                   Eval      A_AESPSET   = *Blank
286700210721     C                   Eval      A_DDPSSN    = *Blank
286800210721     C                   Eval      A_DDPSNM    = *Blank
286900210721     C                   Eval      A_DDPSTN    = *Blank
287000210721     C                   Eval      A_DDPSSI    = *Blank
287100210721     C                   Eval      A_AESNAC1   = *Blank
287200210721     C                   Eval      A_AESNAC2   = *Blank
287300210721     C                   Eval      A_AESDIDN   = *Blank
287400210721     C                   Eval      A_AESDAD1   = *Blank
287500210721     C                   Eval      A_AESDAD2   = *Blank
287600210721     C                   Eval      A_AESDAD3   = *Blank
287700210721     C                   Eval      A_AESDAD4   = *Blank
287800210721     C                   Eval      A_AESDLIN   = *Blank
287900210721     C                   Eval      A_AESQFIN   = *Blank
288000210721     C                   Eval      A_AESPCLR   = *Blank
288100210721     C                   Eval      A_BESAP1N   = *Blank
288200210721     C                   Eval      A_BDA1SN    = *Blank
288300210721     C                   Eval      A_BDA1NM   =  *Blank
288400210721     C                   Eval      A_BDA1TN   =  *Blank
288500210721     C                   Eval      A_BDA1SI   =  *Blank
288600210721     C                   Eval      A_BESAP1L  =  *Blank
288700210721     C                   Eval      A_BESAP2N  =  *Blank
288800210721     C                   Eval      A_BDA2SN   =  *Blank
288900210721     C                   Eval      A_BDA2NM   =  *Blank
289000210721     C                   Eval      A_BDA2TN   =  *Blank
289100210721     C                   Eval      A_BDA2SI   =  *Blank
289200210721     C                   Eval      A_BESAP2L  =  *Blank
289300210721     C                   Eval      A_BESAWIN  =  *Blank
289400210721     C                   Eval      A_BDAISN   =  *Blank
289500210721     C                   Eval      A_BDAINM   =  *Blank
289600210721     C                   Eval      A_BDAITN   =  *Blank
289700210721     C                   Eval      A_BDAISI   =  *Blank
289800210721     C                   Eval      A_BESAWIL  =  *Blank
289900210721     C                   Eval      A_BESBOFN  =  *Blank
290000210721     C                   Eval      A_BDBMSN   =  *Blank
290100210721     C                   Eval      A_BDBMNM   =  *Blank
290200210721     C                   Eval      A_BDBMTN   =  *Blank
290300210721     C                   Eval      A_BDBMSI   =  *Blank
290400210721     C                   Eval      A_BESBOF1  =  *Blank
290500210721     C                   Eval      A_BESBOF2  =  *Blank
290600210721     C                   Eval      A_BESACL1  =  *Blank
290700210721     C                   Eval      A_BESACL2   = *Blank
290800210721     C                   Eval      A_BESSRL1   = *Blank
290900210721     C                   Eval      A_BESSRL2   = *Blank
291000210721     C                   Eval      A_BESSRL3   = *Blank
291100210721     C                   Eval      A_BESFIN1   = *Blank
291200210721     C                   Eval      A_BESFIN2   = *Blank
291300210721     C                   Eval      A_BESRED1   = *Blank
291400210721     C                   Eval      A_BESRED2   = *Blank
291500210721     C                   Eval      A_BESNAL1   = *Blank
291600210721     C                   Eval      A_BESNAL2   = *Blank
291700210721     C                   Eval      A_BESIPYN   = *Blank
291800210721     C                   Eval      A_BDIPSN    = *Blank
291900210721     C                   Eval      A_BDIPNM    = *Blank
292000210721     C                   Eval      A_BDIPTN    = *Blank
292100210721     C                   Eval      A_BDIPSI    = *Blank
292200210721     C                   Eval      A_BESIPYL   = *Blank
292300210721     C                   Eval      A_BESCTYN   = *Blank
292400210721     C                   Eval      A_BESCTYL   = *Blank
292500210721     C                   Eval      A_BESSA1N   = *Blank
292600210721     C                   Eval      A_BDCZSN    = *Blank
292700210721     C                   Eval      A_BDCSNM    = *Blank
292800210721     C                   Eval      A_BDCSTN    = *Blank
292900210721     C                   Eval      A_BDCSSI    = *Blank
293000210721     C                   Eval      A_BESSA1L   = *Blank
293100210721     C                   Eval      A_BESSKAN   = *Blank
293200210721     C                   Eval      A_BDUSSN    = *Blank
293300210721     C                   Eval      A_BDUSNM    = *Blank
293400210721     C                   Eval      A_BDUSTN    = *Blank
293500210721     C                   Eval      A_BDUSSI    = *Blank
293600210721     C                   Eval      A_BESSKAL   = *Blank
293700210721     C                   Eval      A_BESCCTN   = *Blank
293800210721     C                   Eval      A_BDCCSN    = *Blank
293900210721     C                   Eval      A_BDCCNM    = *Blank
294000210721     C                   Eval      A_BDCCTN    = *Blank
294100210721     C                   Eval      A_BDCCSI    = *Blank
294200210721     C                   Eval      A_BESDCTL   = *Blank
294300210721     C                   Eval      A_BESRSSN   = *Blank
294400210721     C                   Eval      A_BDRSSN    = *Blank
294500210721     C                   Eval      A_BDRSNM    = *Blank
294600210721     C                   Eval      A_BDRSTN    = *Blank
294700210721     C                   Eval      A_BDRSSI    = *Blank
294800210721     C                   Eval      A_BESRSS1   = *Blank
294900210721     C                   Eval      A_BESRSS2   = *Blank
295000210721     C                   Eval      A_BESRSS3   = *Blank
295100210721     C                   Eval      A_BESRSS4   = *Blank
295200210721     C                   Eval      A_BESDSSN   = *Blank
295300210721     C                   Eval      A_BESDSS1   = *Blank
295400210721     C                   Eval      A_BESDSS2   = *Blank
295500210721     C                   Eval      A_BESDSS3   = *Blank
295600210721     C                   Eval      A_BESDSS4   = *Blank
295700210721     C                   Eval      A_BESBSSN   = *Blank
295800210721     C                   Eval      A_BESBSS1   = *Blank
295900210721     C                   Eval      A_BESBSS2   = *Blank
296000210721     C                   Eval      A_BESINVE   = *Blank
296100210721     C                   Eval      A_BDIOSN    = *Blank
296200210721     C                   Eval      A_BDIONM    = *Blank
296300210721     C                   Eval      A_BDIOTN    = *Blank
296400210721     C                   Eval      A_BDIOSI    = *Blank
296500210721     C                   Eval      A_BESIMMD1  = *Blank
296600210721     C                   Eval      A_BDI1SN    = *Blank
296700210721     C                   Eval      A_BDI1NM    = *Blank
296800210721     C                   Eval      A_BDI1TN    = *Blank
296900210721     C                   Eval      A_BDI1SI    = *Blank
297000210721     C                   Eval      A_BESIMSA1  = *Blank
297100210721     C                   Eval      A_BESIMMD2  = *Blank
297200210721     C                   Eval      A_BDI2SN    = *Blank
297300210721     C                   Eval      A_BDI2NM    = *Blank
297400210721     C                   Eval      A_BDI2TN    = *Blank
297500210721     C                   Eval      A_BDI2SI    = *Blank
297600210721     C                   Eval      A_BESIMSA2  =  *Blank
297700210721     C                   Eval      A_BESIMMD3  =  *Blank
297800210721     C                   Eval      A_BESIMSA3  =  *Blank
297900210721     C                   Eval      A_BESIMMD4   = *Blank
298000210721     C                   Eval      A_BESIMSA4   = *Blank
298100210721     C                   Eval      A_BESIMMD5   = *Blank
298200210721     C                   Eval      A_BESIMSA5   = *Blank
298300210721     C                   Eval      A_BESIMMD6   = *Blank
298400210721     C                   Eval      A_BESIMSA6   = *Blank
298500210721     C                   Eval      A_BESIMMD7   = *Blank
298600210721     C                   Eval      A_BESIMSA7   = *Blank
298700210721     C                   Eval      A_BESIMMD8   = *Blank
298800210721     C                   Eval      A_BESIMSA8   = *Blank
298900210721     C                   Eval      A_BESIMMD9   = *Blank
299000210721     C                   Eval      A_BESIMSA9   = *Blank
299100210721     C                   Eval      A_BESPSET    = *Blank
299200210721     C                   Eval      A_BDPSSN     = *Blank
299300210721     C                   Eval      A_BDPSNM     = *Blank
299400210721     C                   Eval      A_BDPSTN     = *Blank
299500210721     C                   Eval      A_BDPSSI     = *Blank
299600210721     C                   Eval      A_BESNAC1    = *Blank
299700210721     C                   Eval      A_BESNAC2    = *Blank
299800210721     C                   Eval      A_BESDIDN    = *Blank
299900210721     C                   Eval      A_BESDAD1    = *Blank
300000210721     C                   Eval      A_BESDAD2    = *Blank
300100210721     C                   Eval      A_BESDAD3    = *Blank
300200210721     C                   Eval      A_BESDAD4    = *Blank
300300210721     C                   Eval      A_BESDLIN   =  *Blank
300400210721     C                   Eval      A_BESQFIN   =  *Blank
300500210721     C                   Eval      A_BESPCLR   =  *Blank
300600210721     C                   Eval      A_DDCRSK    =  *Blank
300700210721     C                   Eval      A_DDLQPR    =  *Blank
300800210721     C                   Eval      A_DDITRN    =  *Blank
300900210721     C                   Eval      A_TMSP      =  *Blank
301000210721     C                   Eval      A_BDSPBS    =  *Blank
301100210721     C                   Eval      A_STBS      =  *Blank
301200210721     C                   Eval      A_PROT      =  *Blank
301300210721     C                   Eval      A_NMCY      =  *Blank
301400210721     C                   Eval      A_C1DI      =  *Blank
301500210721     C                   Eval      A_BVAUTH    =  *Blank
301600210721     C                   Eval      A_DDCPNR    = *Blank
301700210721     C                   Eval      A_DDTCTR    = *Blank
301800210721     C                   Eval      A_DDCFCT    = *Blank
301900210721     C                   Eval      A_ADDROUS   = *Blank
302000210721     C                   Eval      A_ADDROTS   = *Blank
302100210721     C                   Eval      A_ADDROUC   = *Blank
302200210721     C                   Eval      A_ADDROTC   = *Blank
302300210721     C                   Eval      A_BDDROUS   = *Blank
302400210721     C                   Eval      A_BDDROTS   = *Blank
302500210721     C                   Eval      A_BDDROUC   = *Blank
302600210721     C                   Eval      A_BDDROTC   = *Blank
302700210721     C                   Eval      A_DDSPXR   =  *Blank
302800210721     C                   Eval      A_DDSPMD   =  *Blank
302900210721     C                   Eval      A_DDWTAX   =  *Blank
303000210721     C                   Eval      A_BKEURO   =  *Blank
303100210721     C                   Eval      A_DDSTAT   =  *Blank
303200210721      *
303300210721      * Auto authorise indicator ???
303400210721     C                   Eval      A_DDAUTH   =  FNAUTH
303500210721     C                   Eval      A_SITP     =  *Blank
303600210721     C                   Eval      A_DDPRICN  =  *Blank
303700210721     C                   Eval      A_DDHACR   =  *Blank
303800210721     C                   Eval      A_DDTCSR   =  *Blank
303900210721     C                   Eval      A_DDDAYS   =  *Blank
304000210721     C                   Eval      A_DDFOID   =  *Blank
304100210721     C                   Eval      A_TQTAX    =  *Blank
304200210721     C                   Eval      A_TQSTAF   =  *Blank
304300210721     C                   Eval      A_TQCDTE   =  *Blank
304400210721      *
304500210721      * Auto authorise indicator
304600210721     C                   Eval      A_AUTH     =  FNAUTH
304700210721      *
304800210721      * Tof Fioller
304900210721     C                   Eval      A_TOFfil   =  *Blank
305000210721     C                   Endsr
305100210721      /Eject
305200210721      *****************************************************************
305300210721     C     APDataA       Begsr
305400210721     C                   Clear                   ApDtmsg
305500210721      ** - API action
305600210721     C                   Eval      A_DDACTN  = 'C'
305700210721      *
305800210721      ** - Trade reference
305900210721     C                   Eval      A_DDTDRF  = C_TDRF
306000210721      *
306100210721      ** - Bulk reference
306200210721     C                   Eval      A_DDBLKR  = C_BLKR
306300210721      *
306400210721      ** - Client Number
306500210721     C                   Eval      A_DDCNUM  = C_TCNR
306600210721      *
306700210721      ** - Security short name
306800210721     C                   Eval      A_DDSESN  = C_TDSS
306900210721      *
307000210721      ** - Customer shortname
307100210721     C                   Eval      A_DDCSSN  = *blank
307200210721      *
307300210721      ** - Customer report name
307400210721     C                   Eval      A_DDCRNM  = *blank
307500210721      *
307600210721      ** - Customer report town
307700210721     C                   Eval      A_DDCRTN  = *blank
307800210721      *
307900210721      ** - Incomplete indicator
308000210721     C                   Eval      A_DDINCS  = O_TINC
308100210721      *
308200210721      ** - Trade type
308300210721     C                   Eval      A_DDTDTP  = O_TDTP
308400210721      *
308500210721      ** - Nominal
308600210721      * Format nominal amount based on Nominal decimal plases
308700210721     C                   Move      O_NOML        W_NOML
308800210721      *                  Remove leading Zero
308900210721     C                   If        W_N1 = '0' or W_N1 = ' '
309000210721     C                   Eval      W_N1 = *blank
309100210721     C                   If        W_N2 = '0' or W_N2 = ' '
309200210721     C                   Eval      W_N2 = *blank
309300210721     C                   If        W_N3 = '0' or W_N3 = ' '
309400210721     C                   Eval      W_N3 = *blank
309500210721     C                   If        W_N4 = '0' or W_N4 = ' '
309600210721     C                   Eval      W_N4 = *blank
309700210721     C                   If        W_N5 = '0' or W_N5 = ' '
309800210721     C                   Eval      W_N5 = *blank
309900210721     C                   If        W_N6 = '0' or W_N6 = ' '
310000210721     C                   Eval      W_N6 = *blank
310100210721     C                   If        W_N7 = '0' or W_N7 = ' '
310200210721     C                   Eval      W_N7 = *blank
310300210721     C                   If        W_N8 = '0' or W_N8 = ' '
310400210721     C                   Eval      W_N8 = *blank
310500210721     C                   If        W_N9 = '0' or W_N9 = ' '
310600210721     C                   Eval      W_N9 = *blank
310700210721     C                   If        W_N10 = '0' or W_N10 = ' '
310800210721     C                   Eval      W_N10 = *blank
310900210721     C                   If        W_N11 = '0' or W_N11 = ' '
311000210721     C                   Eval      W_N11 = *blank
311100210721     C                   Endif
311200210721     C                   Endif
311300210721     C                   Endif
311400210721     C                   Endif
311500210721     C                   Endif
311600210721     C                   Endif
311700210721     C                   Endif
311800210721     C                   Endif
311900210721     C                   Endif
312000210721     C                   Endif
312100210721     C                   Endif
312200210721     C                   If        TNMD = 0
312300210721     C                   Eval      A_DDNOML  = %trim(W_NOML0)
312400210721     C                   Endif
312500210721     C                   If        TNMD = 1
312600210721     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
312700210721     C                   Endif
312800210721     C                   If        TNMD = 2
312900210721     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
313000210721     C                   Endif
313100210721     C                   If        TNMD = 3
313200210721     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
313300210721     C                   Endif
313400210721     C                   If        TNMD = 4
313500210721     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
313600210721     C                   Endif
313700210721
313800210721      *
313900210721      ** - Price/Disc/Yield
314000210721      * If not nil format with Price Decimal places  (15,8)
314100210721     C                   If        O_TPDY  > 0
314200210721     C                   Movel     O_TPDY        W_1508
314300210721      *                  Remove leading Zero
314400210721     C                   If        W_I1 = '0' or W_I1 = ' '
314500210721     C                   Eval      W_I1 = *blank
314600210721     C                   If        W_I2 = '0' or W_I2 = ' '
314700210721     C                   Eval      W_I2 = *blank
314800210721     C                   If        W_I3 = '0' or W_I3 = ' '
314900210721     C                   Eval      W_I3 = *blank
315000210721     C                   If        W_I4 = '0' or W_I4 = ' '
315100210721     C                   Eval      W_I4 = *blank
315200210721     C                   If        W_I5 = '0' or W_I5 = ' '
315300210721     C                   Eval      W_I5 = *blank
315400210721     C                   If        W_I6 = '0' or W_I6 = ' '
315500210721     C                   Eval      W_I6 = *blank
315600210721     C                   Endif
315700210721     C                   Endif
315800210721     C                   Endif
315900210721     C                   Endif
316000210721     C                   Endif
316100210721     C                   Endif
316200210721     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
316300210721     c                   Eval      W_1508  = *blank
316400210721     C                   Endif
316500210721      *
316600210721      ** - Value Date
316700210721      * Format Date as DDMMYY
316800210721     C                   Eval      ZDATFM = 'D'
316900210721     C                   CALLB     'ZDATE2'
317000210721     C                   PARM                    O_TDVD
317100210721     C                   PARM                    ZDATFM            1
317200210721     C                   PARM                    ZDATE             6 0
317300210721     C                   PARM                    ZADATE            7
317400210721     C                   Movel     ZDATE         A_DDTDVD
317500210721      *
317600210721      ** - Booking Branch
317700210721      * Overwrite branch to consolidated branch
317800210721     C                   Eval      A_DDBRCD  = FNBRCA
317900210721      *
318000210721      ** - Book
318100210721     C                   Eval      A_DDBPBK  = C_TDBK
318200210721      *
318300210721      ** - Clearance type
318400210721     C                   Eval      A_DDCLTY  = C_CLTY                                        O_CLTY
318500210721     C                   Eval      A_DDCLTY2 = C_CLTY                                        O_CLTY
318600210721      *
318700210721      ** - Settlement Currency
318800210721     C                   Eval      A_DDSETC  = C_SETC                                        O_SETC
318900210721      *
319000210721      ** - REALLOWANCE
319100210721      * If not nil format with Price Decimal places  (9,5)  ????
319200210721     C                   If        O_RALL  > 0
319300210721     C                   Movel     O_RALL        W_0905
319400210721     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
319500210721     c                   Eval      W_0905  = *blank
319600210721     C                   Endif
319700210721      *
319800210721      ** - Market Center
319900210721     C                   Eval      A_DDMRKT  = O_TMKC
320000210721      *
320100210721      ** - Capacity
320200210721      * Capacity May not be required ????
320300210721     C                   Movel     O_TCAP        A_DDCPCY
320400210721      *
320500210721      ** - Price
320600210721      * If not nil format with Price Decimal places  (15,8) ???
320700210721     C                   If        O_PRIC > 0
320800210721     C                   Movel     O_PRIC        W_1508
320900210721     C                   If        W_I1 = '0' or W_I1 = ' '
321000210721     C                   Eval      W_I1 = *blank
321100210721     C                   If        W_I2 = '0' or W_I2 = ' '
321200210721     C                   Eval      W_I2 = *blank
321300210721     C                   If        W_I3 = '0' or W_I3 = ' '
321400210721     C                   Eval      W_I3 = *blank
321500210721     C                   If        W_I4 = '0' or W_I4 = ' '
321600210721     C                   Eval      W_I4 = *blank
321700210721     C                   If        W_I5 = '0' or W_I5 = ' '
321800210721     C                   Eval      W_I5 = *blank
321900210721     C                   If        W_I6 = '0' or W_I6 = ' '
322000210721     C                   Eval      W_I6 = *blank
322100210721     C                   Endif
322200210721     C                   Endif
322300210721     C                   Endif
322400210721     C                   Endif
322500210721     C                   Endif
322600210721     C                   Endif
322700210721     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
322800210721     c                   Eval      W_1508  = *blank
322900210721     C                   Endif
323000210721     C                   Eval      A_DDPRIC   = GHSUBS
323100210721      *
323200210721      ** - Ex Dividend
323300210721     C                   Eval      A_DDEXDV = C_EXDV                                          O_EXDV
323400210721      *
323500210721      ** - Fiscal Price
323600210721      * If not nil format with Price Decimal places  (15,8)    ???
323700210721     C                   If        O_FSPR > 0
323800210721     C                   Movel     O_FSPR        W_1508
323900210721     C                   If        W_I1 = '0' or W_I1 = ' '
324000210721     C                   Eval      W_I1 = *blank
324100210721     C                   If        W_I2 = '0' or W_I2 = ' '
324200210721     C                   Eval      W_I2 = *blank
324300210721     C                   If        W_I3 = '0' or W_I3 = ' '
324400210721     C                   Eval      W_I3 = *blank
324500210721     C                   If        W_I4 = '0' or W_I4 = ' '
324600210721     C                   Eval      W_I4 = *blank
324700210721     C                   If        W_I5 = '0' or W_I5 = ' '
324800210721     C                   Eval      W_I5 = *blank
324900210721     C                   If        W_I6 = '0' or W_I6 = ' '
325000210721     C                   Eval      W_I6 = *blank
325100210721     C                   Endif
325200210721     C                   Endif
325300210721     C                   Endif
325400210721     C                   Endif
325500210721     C                   Endif
325600210721     C                   Endif
325700210721     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
325800210721     C                   Movel     WrSUBS        A_DDFSPR
325900210721     c                   Eval      W_1508  = *blank
326000210721     C                   Endif
326100210721      *
326200210721      ** - Book profit center
326300210721     C                   Eval      A_DDBPRC  = O_BPRC
326400210721      *
326500210721      ** - Trans profit center
326600210721     C                   Eval      A_DDTPRC  = O_TPRC
326700210721      *
326800210721      ** - Trader ID
326900210721     C                   Eval      A_DDTDID  = O_TDID
327000210721      *
327100210721      ** - Trade date
327200210721      * Format Date as DDMMYY
327300210721     C                   Eval      ZDATFM = 'D'
327400210721     C                   CALLB     'ZDATE2'
327500210721     C                   PARM                    O_TDDT
327600210721     C                   PARM                    ZDATFM            1
327700210721     C                   PARM                    ZDATE             6 0
327800210721     C                   PARM                    ZADATE            7
327900210721     C                   Movel     ZDATE         A_DDTDDT
328000210721      *
328100210721      ** - Trade Sub type
328200210721     C                   Eval      A_DDTSUB  = O_TSUB
328300210721      *
328400210721      ** - Link Ref  Never on duplication
328500210721     C                   Eval      A_DDLKRF = C_LKRF                                          O_LKRF
328600210721      *
328700210721      ** - Market indicator  ????
328800210721     C                   Eval      A_DDTDMI = C_TDMI                                          O_TDMI
328900210721      *
329000210721      ** - ISMA / IPMA
329100210721      *  Not sure AIIP must be taken ????
329200210721     C                   Eval      A_DDAIIP = C_AIIP                                          O_AIIP
329300210721      *
329400210721      ** - Narrative
329500210721     C                   Eval      A_DDTDNR = O_TDNR                                          O_TDNR
329600210721      *
329700210721      ** - P order number never on replication
329800210721      * Will never be from TOF
329900210721     C                   Eval      A_DDORDE  = *Blank
330000210721      *
330100210721      ** - Accrued indicator
330200210721     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
330300210721      *
330400210721      ** - Days Adj/sign
330500210721     C                   If        O_DADJ > 0
330600210721     C                   Movel     O_DADJ        A_DDDADJ
330700210721     C                   Endif
330800210721     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
330900210721      *
331000210721      ** - Act/Diff Ind
331100210721     C                   Eval      A_DDACTD  =  *Blank
331200210721      *
331300210721      ** - Int Amnr/Sign
331400210721      * If not nil format with Nominal currncy position ????
331500210721     C                   If        O_ITRA > 0
331600210721     C                   Move      O_ITRA        W_ChgL
331700210721     C                   If        A6NBDP = 0
331800210721     C                   Eval      A_DDITRA  = W_ChgL
331900210721     C                   Endif
332000210721     C                   If        A6NBDP = 1
332100210721     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
332200210721     C                   Endif
332300210721     C                   If        A6NBDP = 2
332400210721     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
332500210721     C                   Endif
332600210721     C                   If        A6NBDP = 3
332700210721     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
332800210721     C                   Endif
332900210721     C                   Endif
333000210721     C                   Movel     WrSUBS        A_DDITRA
333100210721     C                   clear                   W_ChgL
333200210721      *
333300210721      ** - Origin
333400210721      *
333500210721     C                   Eval      A_DDINOR  = *blank
333600210721      *
333700210721      ** - Message Key
333800210721     C                   Eval      A_DDMSGK  = *blank
333900210721      *
334000210721      ** - Notification method
334100210721     C                   Eval      A_DDNTMT  = *blank
334200210721      *
334300210721      * Ignoring following block
334400210721     C                   Eval      A_DDNOM1  = *blank
334500210721     C                   Eval      A_DDTDV1  = *blank
334600210721     C                   Eval      A_DDACI1  = *blank
334700210721     C                   Eval      A_DDDAD1  = *blank
334800210721     C                   Eval      A_DDACT1  = *blank
334900210721     C                   Eval      A_DDITR1  = *blank
335000210721      *
335100210721      ** - Exchange rate
335200210721      * If not nil format with rate Decimal places  (13,8)
335300210721     C                   If        O_TDER > 0
335400210721     C                   Movel     O_TDER        W_1308
335500210721     C                   If        W_I1 = '0' or W_I1 = ' '
335600210721     C                   Eval      W_I1 = *blank
335700210721     C                   If        W_I2 = '0' or W_I2 = ' '
335800210721     C                   Eval      W_I2 = *blank
335900210721     C                   If        W_I3 = '0' or W_I3 = ' '
336000210721     C                   Eval      W_I3 = *blank
336100210721     C                   If        W_I4 = '0' or W_I4 = ' '
336200210721     C                   Eval      W_I4 = *blank
336300210721     C                   If        W_I5 = '0' or W_I5 = ' '
336400210721     C                   Eval      W_I5 = *blank
336500210721     C                   If        W_I6 = '0' or W_I6 = ' '
336600210721     C                   Eval      W_I6 = *blank
336700210721     C                   Endif
336800210721     C                   Endif
336900210721     C                   Endif
337000210721     C                   Endif
337100210721     C                   Endif
337200210721     C                   Endif
337300210721     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
337400210721     c                   Eval      W_1508  = *blank
337500210721     C                   Endif
337600210721      *
337700210721      ** - Exchange rateM/D
337800210721     C                   Eval      A_DDSMDI  = *blank
337900210721      *
338000210721      ** - Margin
338100210721     C                   Eval      A_DDFXMP  = *blank
338200210721      *
338300210721      ** - Base currency rate
338400210721     C                   Eval      A_DDBRTE  = *blank
338500210721      *
338600210721      *  Settlement field are left unchanged
338700210721     C                   Movel     C_SMTH        A_DDSMTH
338800210721     C                   Eval      A_DDORBR  = C_ORBR
338900210721     C                   Eval      A_DDPYFM  = C_PYFM
339000210721     C                   Eval      A_DDPFSN  = *blank
339100210721     C                   Eval      A_DDPFNM  = *blank
339200210721     C                   Eval      A_DDPFTN  = *blank
339300210721     C                   Eval      A_DDPFAN  = *blank
339400210721     C                   Eval      A_DDPFSW  = *blank
339500210721     C                   Eval      A_DDPYFB  = *blank
339600210721     C                   Eval      A_DDPAYT  = C_PAYT
339700210721     C                   Eval      A_DDPTSN  = *blank
339800210721     C                   Eval      A_DDPTNM  = *blank
339900210721     C                   Eval      A_DDPTTN  = *blank
340000210721     C                   Eval      A_DDPTAN  = *blank
340100210721     C                   Eval      A_DDPTSI  = *blank
340200210721     C                   Eval      A_DDPYTB  = *blank
340300210721     C                   Eval      A_DDTDFA  = *blank
340400210721     C                   Eval      A_DDFASN  = *blank
340500210721     C                   Eval      A_DDFANM  = *blank
340600210721     C                   Eval      A_DDFATN  = *blank
340700210721     C                   Eval      A_DDFASW  = *blank
340800210721     C                   Eval      A_DDASNM  = *blank
340900210721     C                   Eval      A_DDDELF  = C_DELF
341000210721     C                   Eval      A_DDDFSN  = *blank
341100210721     C                   Eval      A_DDDFNM  = *blank
341200210721     C                   Eval      A_DDDFTN  = *blank
341300210721     C                   Eval      A_DDDFSI  = *blank
341400210721     C                   Eval      A_DDDELT  = C_DELT
341500210721     C                   Eval      A_DDDTSN  = *blank
341600210721     C                   Eval      A_DDDTNM  = *blank
341700210721     C                   Eval      A_DDDTTN  = *blank
341800210721     C                   Eval      A_DDDTSI  = *blank
341900210721     C                   Eval      A_DDDFFA  = *blank
342000210721     C                   Eval      A_DDD1SN  = *blank
342100210721     C                   Eval      A_DDD1NM  = *blank
342200210721     C                   Eval      A_DDD1TN  = *blank
342300210721     C                   Eval      A_DDD1SI  = *blank
342400210721     C                   Eval      A_DDDTFA  = *blank
342500210721     C                   Eval      A_DDD2SN  = *blank
342600210721     C                   Eval      A_DDD2NM  = *blank
342700210721     C                   Eval      A_DDD2TN  = *blank
342800210721     C                   Eval      A_DDD2SI  = *blank
342900210721     C                   Eval      A_DDTDSI  = *blank
343000210721      *
343100210721      ** - In Currency in F72
343200210721     C                   Eval      A_DDICCY  = C_ICCY                                         O_ICCY
343300210721      *
343400210721      ** - Profit Center
343500210721     C                   Eval      A_DDPRFC  = C_PRFC                                         O_PRFC
343600210721      *
343700210721      ** - Priority code
343800210721     C                   Movel     WrSUBS        A_DDPRYC
343900210721      *
344000210721      ** - Pay Code
344100210721     C                   Eval      A_DDPCOD  = C_PCOD                                         O_PCOD
344200210721      *
344300210721      ** - Auto settle ind
344400210721     C                   Eval      A_DDAUTS  = 'Y'
344500210721      *
344600210721      ** - Brok Comm code
344700210721     C                   Eval      A_DDTBCC  =  O_TBCC
344800210721      *
344900210721      ** - Brok Com Amount
345000210721      * If not nil format with Nominal currency position
345100210721     C                   If        O_TBCA > 0
345200210721     C                   Move      O_TBCA        W_ChgL
345300210721     C                   If        A6NBDP = 0
345400210721     C                   Eval      A_DDTBCA  = W_ChgL
345500210721     C                   Endif
345600210721     C                   If        A6NBDP = 1
345700210721     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
345800210721     C                   Endif
345900210721     C                   If        A6NBDP = 2
346000210721     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
346100210721     C                   Endif
346200210721     C                   If        A6NBDP = 3
346300210721     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
346400210721     C                   Endif
346500210721     C                   Endif
346600210721     C                   clear                   W_ChgL
346700210721      *
346800210721      ** - Cust com code
346900210721     C                   Eval      A_DDTCCC  = O_TCCC
347000210721      *
347100210721      ** - Cust Comm Amount
347200210721      * If not nil format with Nominal currency position
347300210721     C                   If        O_TCCA > 0
347400210721     C                   Move      O_TCCA        W_ChgL
347500210721     C                   If        A6NBDP = 0
347600210721     C                   Eval      A_DDTCCA  = W_ChgL
347700210721     C                   Endif
347800210721     C                   If        A6NBDP = 1
347900210721     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
348000210721     C                   Endif
348100210721     C                   If        A6NBDP = 2
348200210721     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
348300210721     C                   Endif
348400210721     C                   If        A6NBDP = 3
348500210721     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
348600210721     C                   Endif
348700210721     C                   Endif
348800210721     C                   clear                   W_ChgL
348900210721      *
349000210721      ** - Chg code 1
349100210721     C                   Eval      A_DDTCC1  = O_TCC1
349200210721      *
349300210721      ** - Chg Amount 1
349400210721      * If not nil format with Nominal currncy position
349500210721     C                   If        O_TCA1 > 0
349600210721     C                   Move      O_TCA1        W_ChgL
349700210721     C                   If        A6NBDP = 0
349800210721     C                   Eval      A_DDTCA1  = W_ChgL
349900210721     C                   Endif
350000210721     C                   If        A6NBDP = 1
350100210721     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
350200210721     C                   Endif
350300210721     C                   If        A6NBDP = 2
350400210721     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
350500210721     C                   Endif
350600210721     C                   If        A6NBDP = 3
350700210721     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
350800210721     C                   Endif
350900210721     C                   Endif
351000210721     C                   clear                   W_ChgL
351100210721      *
351200210721      ** - Chg code 2
351300210721     C                   Eval      A_DDTCC2  = O_TCC2
351400210721      *
351500210721      ** - Chg Amount 2
351600210721      * If not nil format with Nominal currncy position
351700210721     C                   If        O_TCA2 > 0
351800210721     C                   Move      O_TCA2        W_ChgL
351900210721     C                   If        A6NBDP = 0
352000210721     C                   Eval      A_DDTCA2  = W_ChgL
352100210721     C                   Endif
352200210721     C                   If        A6NBDP = 1
352300210721     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
352400210721     C                   Endif
352500210721     C                   If        A6NBDP = 2
352600210721     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
352700210721     C                   Endif
352800210721     C                   If        A6NBDP = 3
352900210721     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
353000210721     C                   Endif
353100210721     C                   Endif
353200210721     C                   clear                   W_ChgL
353300210721      *
353400210721      ** - Chg code 3
353500210721     C                   Eval      A_DDTCC3  = O_TCC3
353600210721      *
353700210721      ** - Chg Amount 3
353800210721      * If not nil format with Nominal currency position
353900210721     C                   If        O_TCA3 > 0
354000210721     C                   Move      O_TCA3        W_ChgL
354100210721     C                   If        A6NBDP = 0
354200210721     C                   Eval      A_DDTCA3  = W_ChgL
354300210721     C                   Endif
354400210721     C                   If        A6NBDP = 1
354500210721     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
354600210721     C                   Endif
354700210721     C                   If        A6NBDP = 2
354800210721     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
354900210721     C                   Endif
355000210721     C                   If        A6NBDP = 3
355100210721     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
355200210721     C                   Endif
355300210721     C                   Endif
355400210721     C                   clear                   W_ChgL
355500210721      *
355600210721      ** - Chg code 4
355700210721     C                   Eval      A_DDTCC4  = O_TCC4
355800210721      *
355900210721      ** - Chg Amount 4
356000210721      * If not nil format with Nominal currncy position
356100210721     C                   If        O_TCA4 > 0
356200210721     C                   Move      O_TCA4        W_ChgL
356300210721     C                   If        A6NBDP = 0
356400210721     C                   Eval      A_DDTCA4  = W_ChgL
356500210721     C                   Endif
356600210721     C                   If        A6NBDP = 1
356700210721     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
356800210721     C                   Endif
356900210721     C                   If        A6NBDP = 2
357000210721     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
357100210721     C                   Endif
357200210721     C                   If        A6NBDP = 3
357300210721     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
357400210721     C                   Endif
357500210721     C                   Endif
357600210721     C                   clear                   W_ChgL
357700210721      *
357800210721      ** - Chg code 5
357900210721     C                   Eval      A_DDTCC5  = O_TCC5
358000210721      *
358100210721      ** - Chg Amount 5
358200210721      * If not nil format with Nominal currncy position
358300210721     C                   If        O_TCA5 > 0
358400210721     C                   Move      O_TCA5        W_ChgL
358500210721     C                   If        A6NBDP = 0
358600210721     C                   Eval      A_DDTCA5  = W_ChgL
358700210721     C                   Endif
358800210721     C                   If        A6NBDP = 1
358900210721     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
359000210721     C                   Endif
359100210721     C                   If        A6NBDP = 2
359200210721     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
359300210721     C                   Endif
359400210721     C                   If        A6NBDP = 3
359500210721     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
359600210721     C                   Endif
359700210721     C                   Endif
359800210721     C                   clear                   W_ChgL
359900210721      *
360000210721      ** - Chg code 6
360100210721     C                   Eval      A_DDTCC6  = O_TCC6
360200210721      ** - Chg Amount 6
360300210721      * If not nil format with Nominal currncy position
360400210721      * If not nil format with Nominal currncy position
360500210721     C                   If        O_TCA6 > 0
360600210721     C                   Move      O_TCA6        W_ChgL
360700210721     C                   If        A6NBDP = 0
360800210721     C                   Eval      A_DDTCA6  = W_ChgL
360900210721     C                   Endif
361000210721     C                   If        A6NBDP = 1
361100210721     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
361200210721     C                   Endif
361300210721     C                   If        A6NBDP = 2
361400210721     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
361500210721     C                   Endif
361600210721     C                   If        A6NBDP = 3
361700210721     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
361800210721     C                   Endif
361900210721     C                   Endif
362000210721     C                   clear                   W_ChgL
362100210721      *
362200210721      ** - Chg code 7
362300210721     C                   Eval      A_DDTCC7  = O_TCC7
362400210721      *
362500210721      ** - Chg Amount 7
362600210721      * If not nil format with Nominal currncy position
362700210721     C                   If        O_TCA7 > 0
362800210721     C                   Move      O_TCA7        W_ChgL
362900210721     C                   If        A6NBDP = 0
363000210721     C                   Eval      A_DDTCA7  = W_ChgL
363100210721     C                   Endif
363200210721     C                   If        A6NBDP = 1
363300210721     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
363400210721     C                   Endif
363500210721     C                   If        A6NBDP = 2
363600210721     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
363700210721     C                   Endif
363800210721     C                   If        A6NBDP = 3
363900210721     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
364000210721     C                   Endif
364100210721     C                   Endif
364200210721     C                   clear                   W_ChgL
364300210721      *
364400210721      ** - Tax amount    always blank on replication
364500210721      * If not nil format with Nominal currncy position
364600210721     C                   If        O_TAXA > 0
364700210721     C                   Move      O_TAXA        W_ChgL
364800210721     C                   If        A6NBDP = 0
364900210721     C                   Eval      A_DDTAXA  = W_ChgL
365000210721     C                   Endif
365100210721     C                   If        A6NBDP = 1
365200210721     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
365300210721     C                   Endif
365400210721     C                   If        A6NBDP = 2
365500210721     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
365600210721     C                   Endif
365700210721     C                   If        A6NBDP = 3
365800210721     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
365900210721     C                   Endif
366000210721     C                   Endif
366100210721     C                   Eval      A_DDTAXA  = *blank                                            ???
366200210721     C                   clear                   W_ChgL
366300210721      *
366400210721      ** - EU tax amount in nominall currency always balnk on replication
366500210721      * If not nil format with Nominal currncy position
366600210721     C                   If        O_EUTX > 0
366700210721     C                   Move      O_EUTX        W_ChgL
366800210721     C                   If        A6NBDP = 0
366900210721     C                   Eval      A_DDEUTX  = W_ChgL
367000210721     C                   Endif
367100210721     C                   If        A6NBDP = 1
367200210721     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
367300210721     C                   Endif
367400210721     C                   If        A6NBDP = 2
367500210721     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
367600210721     C                   Endif
367700210721     C                   If        A6NBDP = 3
367800210721     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
367900210721     C                   Endif
368000210721     C                   Endif
368100210721     C                   Eval      A_DDEUTX  = *blank                                            ???
368200210721     C                   clear                   W_ChgL
368300210721      *
368400210721      ** - Brok Comm  Rebate
368500210721      * If not nil format with Nominal currency position
368600210721     C                   If        O_BCMR > 0
368700210721     C                   Move      O_BCMR        W_ChgL
368800210721     C                   If        A6NBDP = 0
368900210721     C                   Eval      A_DDBCMR  = W_ChgL
369000210721     C                   Endif
369100210721     C                   If        A6NBDP = 1
369200210721     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
369300210721     C                   Endif
369400210721     C                   If        A6NBDP = 2
369500210721     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
369600210721     C                   Endif
369700210721     C                   If        A6NBDP = 3
369800210721     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
369900210721     C                   Endif
370000210721     C                   Endif
370100210721     C                   clear                   W_ChgL
370200210721      *
370300210721      ** - Cust Comm rebate
370400210721      * If not nil format with Nominal currency position
370500210721     C                   If        O_CCMR > 0
370600210721     C                   Move      O_CCMR        W_ChgL
370700210721     C                   If        A6NBDP = 0
370800210721     C                   Eval      A_DDCCMR  = W_ChgL
370900210721     C                   Endif
371000210721     C                   If        A6NBDP = 1
371100210721     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
371200210721     C                   Endif
371300210721     C                   If        A6NBDP = 2
371400210721     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
371500210721     C                   Endif
371600210721     C                   If        A6NBDP = 3
371700210721     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
371800210721     C                   Endif
371900210721     C                   Endif
372000210721     C                   clear                   W_ChgL
372100210721      *
372200210721      ** - Tax rebate always blank on replication
372300210721      * If not nil format with Nominal currency position
372400210721     C                   If        O_TXRB > 0
372500210721     C                   Move      O_TXRB        W_ChgL
372600210721     C                   If        A6NBDP = 0
372700210721     C                   Eval      A_DDTXRB  = W_ChgL
372800210721     C                   Endif
372900210721     C                   If        A6NBDP = 1
373000210721     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
373100210721     C                   Endif
373200210721     C                   If        A6NBDP = 2
373300210721     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
373400210721     C                   Endif
373500210721     C                   If        A6NBDP = 3
373600210721     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
373700210721     C                   Endif
373800210721     C                   Endif
373900210721     C                   clear                   W_ChgL
374000210721      *
374100210721      ** - Portfolio reference Always Blank on replication
374200210721     C                   Eval      A_DDPTFR   = C_PTFR
374300210721      *  Extension file TRADSDX1  Not sure it needs to be setup
374400210721      *
374500210721      *  Settlement Message Request
374600210721     C                   Eval      A_ADDGMES  = *blank
374700210721      *
374800210721      *  Time of Trade
374900210721     C                   Eval      A_ADDTRTT  = *blank
375000210721      *
375100210721      *  Instructions Type
375200210721     C                   Eval      A_ADDINST  = C_T1INST
375300210721      *
375400210721      *   Instructions sub-type
375500210721     C                   Eval      A_ADDINSS  = C_T1INSS
375600210721      *
375700210721      *   Euroclear/Cedel code
375800210721     C                   Eval      A_ADDEUCL  = C_T1EUCL
375900210721      *
376000210721      *  Safekeeping Account (MT580)
376100210721     C                   Eval      A_ADDSAFA  = C_T1SAFA
376200210721      *
376300210721      *  Requested Priority
376400210721     C                   Eval      A_ADDRPTY  = C_T1RPTY
376500210721      *
376600210721      *  Guaranteed Delivery
376700210721     C                   Eval      A_ADDGDEL  = *blank
376800210721      *
376900210721      *  Sender's Role
377000210721     C                   Eval      A_ADDSROL  = *blank
377100210721      *
377200210721      *  Fungibilty Code
377300210721     C                   Eval      A_ADDFCOD  = *blank
377400210721      *
377500210721      *  Fungible Trade Indicator
377600210721     C                   Eval      A_ADDFTID  = *blank
377700210721      *
377800210721      *  Confirmation Message Request
377900210721     C                   Eval      A_ADDGMEC  = *blank
378000210721      *
378100210721      *  Customer/Counterparty Ind.
378200210721     C                   Eval      A_ADDCCID  = *blank
378300210721      *
378400210721      *  Further Id.
378500210721     C                   Eval      A_ADDFID1  = *blank
378600210721      *
378700210721      *  Standard Instructions' Overr  ?
378800210721     C                   Eval      A_ADDIORA  = *blank
378900210721      *
379000210721      *  ISO15022 Messages Ind.
379100210721     C                   Eval      A_ADDSNEW  = *blank
379200210721      *
379300210721      *  Stamp Status
379400210721     C                   Eval      A_ADDSTMP  = *blank
379500210721      *
379600210721      *  Charity Identifier
379700210721     C                   Eval      A_ADDCHID  = *blank
379800210721      *
379900210721      *  Transaction Report Marker
380000210721     C                   Eval      A_ADDTRRM  = *blank
380100210721      *
380200210721      * Ignore following block
380300210721     C                   Eval      A_BDDGMES  = *blank
380400210721     C                   Eval      A_BDDTRTT  = *blank
380500210721     C                   Eval      A_BDDINST   =*blank
380600210721     C                   Eval      A_BDDINSS   =*blank
380700210721     C                   Eval      A_BDDEUCL   =*blank
380800210721     C                   Eval      A_BDDSAFA   = *blank
380900210721     C                   Eval      A_BDDRPTY   = *blank
381000210721     C                   Eval      A_BDDGDEL   = *blank
381100210721     C                   Eval      A_BDDSROL   = *blank
381200210721     C                   Eval      A_BDDFCOD   = *blank
381300210721     C                   Eval      A_BDDFTID   = *blank
381400210721     C                   Eval      A_BDDGMEC   = *blank
381500210721     C                   Eval      A_BDDCCID   = *blank
381600210721     C                   Eval      A_BDDFID1   = *blank
381700210721     C                   Eval      A_BDDIORA   = *blank
381800210721     C                   Eval      A_BDDSNEW   = *blank
381900210721     C                   Eval      A_BDDSTMP   = *blank
382000210721     C                   Eval      A_BDDCHID   = *blank
382100210721     C                   Eval      A_BDDTRRM   = *blank
382200210721     C                   Eval      A_AESAP1N   = *blank
382300210721     C                   Eval      A_DDA1SN    = *blank
382400210721     C                   Eval      A_DDA1NM    = *blank
382500210721     C                   Eval      A_DDA1TN    = *blank
382600210721     C                   Eval      A_DDA1SI    = *blank
382700210721     C                   Eval      A_AESAP1L   = *blank
382800210721     C                   Eval      A_AESAP2N   = *blank
382900210721     C                   Eval      A_DDA2SN   =  *blank
383000210721     C                   Eval      A_DDA2NM   =  *blank
383100210721     C                   Eval      A_DDA2TN   =  *blank
383200210721     C                   Eval      A_DDA2SI   =  *blank
383300210721     C                   Eval      A_AESAP2L  =  *blank
383400210721     C                   Eval      A_AESAWIN  =  *blank
383500210721     C                   Eval      A_DDAISN   =  *blank
383600210721     C                   Eval      A_DDAINM   =  *blank
383700210721     C                   Eval      A_DDAITN   =  *blank
383800210721     C                   Eval      A_DDAISI   =  *blank
383900210721     C                   Eval      A_AESAWIL  =  *blank
384000210721     C                   Eval      A_AESBOFN  =  *blank
384100210721     C                   Eval      A_DDBMSN   =  *blank
384200210721     C                   Eval      A_DDBMNM   =  *blank
384300210721     C                   Eval      A_DDBMTN   =  *blank
384400210721     C                   Eval      A_DDBMSI   =  *blank
384500210721     C                   Eval      A_AESBOF1  =  *blank
384600210721     C                   Eval      A_AESBOF2  =  *blank
384700210721     C                   Eval      A_AESACL1  =  *blank
384800210721     C                   Eval      A_AESACL2  =  *blank
384900210721     C                   Eval      A_AESSRL1  =  *blank
385000210721     C                   Eval      A_AESSRL2  =  *blank
385100210721     C                   Eval      A_AESSRL3  =  *blank
385200210721     C                   Eval      A_AESFIN1  =  *blank
385300210721     C                   Eval      A_AESFIN2   = *blank
385400210721     C                   Eval      A_AESRED1   = *blank
385500210721     C                   Eval      A_AESRED2   = *blank
385600210721     C                   Eval      A_AESNAL1   = *blank
385700210721     C                   Eval      A_AESNAL2   = *blank
385800210721     C                   Eval      A_AESIPYN   = *blank
385900210721     C                   Eval      A_DDIPSN    = *blank
386000210721     C                   Eval      A_DDIPNM    = *blank
386100210721     C                   Eval      A_DDIPTN    = *blank
386200210721     C                   Eval      A_DDIPSI    = *blank
386300210721     C                   Eval      A_AESIPYL   = *blank
386400210721     C                   Eval      A_AESCTYN   = *blank
386500210721     C                   Eval      A_AESCTYL   = *blank
386600210721     C                   Eval      A_AESSA1N   = *blank
386700210721     C                   Eval      A_DDCZSN    = *blank
386800210721     C                   Eval      A_DDCSNM    = *blank
386900210721     C                   Eval      A_DDCSTN    = *blank
387000210721     C                   Eval      A_DDCSSI    = *blank
387100210721     C                   Eval      A_AESSA1L   = *blank
387200210721     C                   Eval      A_AESSKAN   = *blank
387300210721     C                   Eval      A_DDUSSN    = *blank
387400210721     C                   Eval      A_DDUSNM    = *blank
387500210721     C                   Eval      A_DDUSTN    = *blank
387600210721     C                   Eval      A_DDUSSI    = *blank
387700210721     C                   Eval      A_AESSKAL   = *blank
387800210721     C                   Eval      A_AESCCTN   = *blank
387900210721     C                   Eval      A_DDCCSN    = *blank
388000210721     C                   Eval      A_DDCCNM    = *blank
388100210721     C                   Eval      A_DDCCTN    = *blank
388200210721     C                   Eval      A_DDCCSI    = *blank
388300210721     C                   Eval      A_AESDCTL   = *blank
388400210721     C                   Eval      A_AESRSSN   = *blank
388500210721     C                   Eval      A_DDRSSN    = *blank
388600210721     C                   Eval      A_DDRSNM    = *blank
388700210721     C                   Eval      A_DDRSTN    = *blank
388800210721     C                   Eval      A_DDRSSI    = *blank
388900210721     C                   Eval      A_AESRSS1   = *blank
389000210721     C                   Eval      A_AESRSS2   = *blank
389100210721     C                   Eval      A_AESRSS3   = *blank
389200210721     C                   Eval      A_AESRSS4   = *blank
389300210721     C                   Eval      A_AESDSSN   = *blank
389400210721     C                   Eval      A_AESDSS1   = *blank
389500210721     C                   Eval      A_AESDSS2   = *blank
389600210721     C                   Eval      A_AESDSS3   = *blank
389700210721     C                   Eval      A_AESDSS4   = *blank
389800210721     C                   Eval      A_AESBSSN   = *blank
389900210721     C                   Eval      A_AESBSS1   = *blank
390000210721     C                   Eval      A_AESBSS2   = *blank
390100210721     C                   Eval      A_AESINVE   = *blank
390200210721     C                   Eval      A_DDIOSN    = *blank
390300210721     C                   Eval      A_DDIONM    = *blank
390400210721     C                   Eval      A_DDIOTN    = *blank
390500210721     C                   Eval      A_DDIOSI    = *blank
390600210721     C                   Eval      A_AESIMMD1  = *blank
390700210721     C                   Eval      A_DDI1SN    = *blank
390800210721     C                   Eval      A_DDI1NM    = *blank
390900210721     C                   Eval      A_DDI1TN    = *blank
391000210721     C                   Eval      A_DDI1SI    = *blank
391100210721     C                   Eval      A_AESIMSA1  = *blank
391200210721     C                   Eval      A_AESIMMD2  = *blank
391300210721     C                   Eval      A_DDI2SN    = *blank
391400210721     C                   Eval      A_DDI2NM    = *blank
391500210721     C                   Eval      A_DDI2TN    = *blank
391600210721     C                   Eval      A_DDI2SI    = *blank
391700210721     C                   Eval      A_AESIMSA2  = *blank
391800210721     C                   Eval      A_AESIMMD3  = *blank
391900210721     C                   Eval      A_AESIMSA3  = *blank
392000210721     C                   Eval      A_AESIMMD4  = *blank
392100210721     C                   Eval      A_AESIMSA4  = *blank
392200210721     C                   Eval      A_AESIMMD5  = *blank
392300210721     C                   Eval      A_AESIMSA5  = *blank
392400210721     C                   Eval      A_AESIMMD6  = *blank
392500210721     C                   Eval      A_AESIMSA6  = *blank
392600210721     C                   Eval      A_AESIMMD7  = *blank
392700210721     C                   Eval      A_AESIMSA7  = *blank
392800210721     C                   Eval      A_AESIMMD8  = *blank
392900210721     C                   Eval      A_AESIMSA8  = *blank
393000210721     C                   Eval      A_AESIMMD9  = *blank
393100210721     C                   Eval      A_AESIMSA9  = *blank
393200210721     C                   Eval      A_AESPSET   = *blank
393300210721     C                   Eval      A_DDPSSN    = *Blank
393400210721     C                   Eval      A_DDPSNM    = *Blank
393500210721     C                   Eval      A_DDPSTN    = *Blank
393600210721     C                   Eval      A_DDPSSI    = *Blank
393700210721     C                   Eval      A_AESNAC1   = *Blank
393800210721     C                   Eval      A_AESNAC2   = *Blank
393900210721     C                   Eval      A_AESDIDN   = *Blank
394000210721     C                   Eval      A_AESDAD1   = *Blank
394100210721     C                   Eval      A_AESDAD2   = *Blank
394200210721     C                   Eval      A_AESDAD3   = *Blank
394300210721     C                   Eval      A_AESDAD4   = *Blank
394400210721     C                   Eval      A_AESDLIN   = *Blank
394500210721     C                   Eval      A_AESQFIN   = *Blank
394600210721     C                   Eval      A_AESPCLR   = *Blank
394700210721     C                   Eval      A_BESAP1N   = *Blank
394800210721     C                   Eval      A_BDA1SN    = *Blank
394900210721     C                   Eval      A_BDA1NM   =  *Blank
395000210721     C                   Eval      A_BDA1TN   =  *Blank
395100210721     C                   Eval      A_BDA1SI   =  *Blank
395200210721     C                   Eval      A_BESAP1L  =  *Blank
395300210721     C                   Eval      A_BESAP2N  =  *Blank
395400210721     C                   Eval      A_BDA2SN   =  *Blank
395500210721     C                   Eval      A_BDA2NM   =  *blank
395600210721     C                   Eval      A_BDA2TN   =  *blank
395700210721     C                   Eval      A_BDA2SI   =  *blank
395800210721     C                   Eval      A_BESAP2L  =  *blank
395900210721     C                   Eval      A_BESAWIN  =  *blank
396000210721     C                   Eval      A_BDAISN   =  *blank
396100210721     C                   Eval      A_BDAINM   =  *blank
396200210721     C                   Eval      A_BDAITN   =  *blank
396300210721     C                   Eval      A_BDAISI   =  *blank
396400210721     C                   Eval      A_BESAWIL  =  *blank
396500210721     C                   Eval      A_BESBOFN  =  *blank
396600210721     C                   Eval      A_BDBMSN   =  *blank
396700210721     C                   Eval      A_BDBMNM   =  *blank
396800210721     C                   Eval      A_BDBMTN   =  *blank
396900210721     C                   Eval      A_BDBMSI   =  *blank
397000210721     C                   Eval      A_BESBOF1  =  *blank
397100210721     C                   Eval      A_BESBOF2  =  *blank
397200210721     C                   Eval      A_BESACL1  =  *blank
397300210721     C                   Eval      A_BESACL2   = *blank
397400210721     C                   Eval      A_BESSRL1   = *blank
397500210721     C                   Eval      A_BESSRL2   = *blank
397600210721     C                   Eval      A_BESSRL3   = *blank
397700210721     C                   Eval      A_BESFIN1   = *blank
397800210721     C                   Eval      A_BESFIN2   = *blank
397900210721     C                   Eval      A_BESRED1   = *blank
398000210721     C                   Eval      A_BESRED2   = *blank
398100210721     C                   Eval      A_BESNAL1   = *blank
398200210721     C                   Eval      A_BESNAL2   = *blank
398300210721     C                   Eval      A_BESIPYN   = *blank
398400210721     C                   Eval      A_BDIPSN    = *blank
398500210721     C                   Eval      A_BDIPNM    = *blank
398600210721     C                   Eval      A_BDIPTN    = *blank
398700210721     C                   Eval      A_BDIPSI    = *blank
398800210721     C                   Eval      A_BESIPYL   = *blank
398900210721     C                   Eval      A_BESCTYN   = *blank
399000210721     C                   Eval      A_BESCTYL   = *blank
399100210721     C                   Eval      A_BESSA1N   = *blank
399200210721     C                   Eval      A_BDCZSN    = *blank
399300210721     C                   Eval      A_BDCSNM    = *blank
399400210721     C                   Eval      A_BDCSTN    = *blank
399500210721     C                   Eval      A_BDCSSI    = *blank
399600210721     C                   Eval      A_BESSA1L   = *blank
399700210721     C                   Eval      A_BESSKAN   = *blank
399800210721     C                   Eval      A_BDUSSN    = *blank
399900210721     C                   Eval      A_BDUSNM    = *blank
400000210721     C                   Eval      A_BDUSTN    = *blank
400100210721     C                   Eval      A_BDUSSI    = *blank
400200210721     C                   Eval      A_BESSKAL   = *blank
400300210721     C                   Eval      A_BESCCTN   = *blank
400400210721     C                   Eval      A_BDCCSN    = *blank
400500210721     C                   Eval      A_BDCCNM    = *blank
400600210721     C                   Eval      A_BDCCTN    = *blank
400700210721     C                   Eval      A_BDCCSI    = *blank
400800210721     C                   Eval      A_BESDCTL   = *blank
400900210721     C                   Eval      A_BESRSSN   = *blank
401000210721     C                   Eval      A_BDRSSN    = *blank
401100210721     C                   Eval      A_BDRSNM    = *blank
401200210721     C                   Eval      A_BDRSTN    = *blank
401300210721     C                   Eval      A_BDRSSI    = *blank
401400210721     C                   Eval      A_BESRSS1   = *blank
401500210721     C                   Eval      A_BESRSS2   = *blank
401600210721     C                   Eval      A_BESRSS3   = *blank
401700210721     C                   Eval      A_BESRSS4   = *blank
401800210721     C                   Eval      A_BESDSSN   = *blank
401900210721     C                   Eval      A_BESDSS1   = *blank
402000210721     C                   Eval      A_BESDSS2   = *blank
402100210721     C                   Eval      A_BESDSS3   = *blank
402200210721     C                   Eval      A_BESDSS4   = *blank
402300210721     C                   Eval      A_BESBSSN   = *blank
402400210721     C                   Eval      A_BESBSS1   = *blank
402500210721     C                   Eval      A_BESBSS2   = *blank
402600210721     C                   Eval      A_BESINVE   = *blank
402700210721     C                   Eval      A_BDIOSN    = *blank
402800210721     C                   Eval      A_BDIONM    = *blank
402900210721     C                   Eval      A_BDIOTN    = *blank
403000210721     C                   Eval      A_BDIOSI    = *blank
403100210721     C                   Eval      A_BESIMMD1  = *blank
403200210721     C                   Eval      A_BDI1SN    = *blank
403300210721     C                   Eval      A_BDI1NM    = *blank
403400210721     C                   Eval      A_BDI1TN    = *blank
403500210721     C                   Eval      A_BDI1SI    = *blank
403600210721     C                   Eval      A_BESIMSA1  = *blank
403700210721     C                   Eval      A_BESIMMD2  = *blank
403800210721     C                   Eval      A_BDI2SN    = *blank
403900210721     C                   Eval      A_BDI2NM    = *blank
404000210721     C                   Eval      A_BDI2TN    = *blank
404100210721     C                   Eval      A_BDI2SI    = *blank
404200210721     C                   Eval      A_BESIMSA2  = *blank
404300210721     C                   Eval      A_BESIMMD3  = *blank
404400210721     C                   Eval      A_BESIMSA3  = *blank
404500210721     C                   Eval      A_BESIMMD4   =*blank
404600210721     C                   Eval      A_BESIMSA4   =*blank
404700210721     C                   Eval      A_BESIMMD5   =*blank
404800210721     C                   Eval      A_BESIMSA5   =*blank
404900210721     C                   Eval      A_BESIMMD6   =*blank
405000210721     C                   Eval      A_BESIMSA6   =*blank
405100210721     C                   Eval      A_BESIMMD7   = *blank
405200210721     C                   Eval      A_BESIMSA7   = *blank
405300210721     C                   Eval      A_BESIMMD8   = *blank
405400210721     C                   Eval      A_BESIMSA8   = *blank
405500210721     C                   Eval      A_BESIMMD9   = *blank
405600210721     C                   Eval      A_BESIMSA9   = *blank
405700210721     C                   Eval      A_BESPSET    = *blank
405800210721     C                   Eval      A_BDPSSN     = *blank
405900210721     C                   Eval      A_BDPSNM     = *blank
406000210721     C                   Eval      A_BDPSTN     = *blank
406100210721     C                   Eval      A_BDPSSI     = *blank
406200210721     C                   Eval      A_BESNAC1    = *blank
406300210721     C                   Eval      A_BESNAC2    = *blank
406400210721     C                   Eval      A_BESDIDN    = *blank
406500210721     C                   Eval      A_BESDAD1    = *blank
406600210721     C                   Eval      A_BESDAD2    = *blank
406700210721     C                   Eval      A_BESDAD3    = *blank
406800210721     C                   Eval      A_BESDAD4    = *blank
406900210721     C                   Eval      A_BESDLIN   =  *blank
407000210721     C                   Eval      A_BESQFIN   =  *blank
407100210721     C                   Eval      A_BESPCLR   =  *blank
407200210721     C                   Eval      A_DDCRSK    =  *blank
407300210721     C                   Eval      A_DDLQPR    =  *blank
407400210721     C                   Eval      A_DDITRN    = *blank
407500210721     C                   Eval      A_TMSP      = *blank
407600210721     C                   Eval      A_BDSPBS    = *blank
407700210721     C                   Eval      A_STBS      = *blank
407800210721     C                   Eval      A_PROT      = *blank
407900210721     C                   Eval      A_NMCY      = *blank
408000210721     C                   Eval      A_C1DI      = *blank
408100210721     C                   Eval      A_BVAUTH    = *blank
408200210721     C                   Eval      A_DDCPNR    = *blank
408300210721     C                   Eval      A_DDTCTR    = *blank
408400210721     C                   Eval      A_DDCFCT    = *blank
408500210721     C                   Eval      A_ADDROUS   = *blank
408600210721     C                   Eval      A_ADDROTS   = *blank
408700210721     C                   Eval      A_ADDROUC   = *blank
408800210721     C                   Eval      A_ADDROTC   = *blank
408900210721     C                   Eval      A_BDDROUS   = *blank
409000210721     C                   Eval      A_BDDROTS   = *blank
409100210721     C                   Eval      A_BDDROUC   = *blank
409200210721     C                   Eval      A_BDDROTC   = *blank
409300210721     C                   Eval      A_DDSPXR   =  *blank
409400210721     C                   Eval      A_DDSPMD   =  *blank
409500210721     C                   Eval      A_DDWTAX   =  *blank
409600210721     C                   Eval      A_BKEURO   =  *blank
409700210721     C                   Eval      A_DDSTAT   =  *blank
409800210721     C                   Eval      A_DDAUTH   =  FNAUTH
409900210721     C                   Eval      A_SITP     =  *blank
410000210721     C                   Eval      A_DDPRICN  =  *blank
410100210721     C                   Eval      A_DDHACR   =  *blank
410200210721     C                   Eval      A_DDTCSR   =  *blank
410300210721     C                   Eval      A_DDDAYS   =  *blank
410400210721     C                   Eval      A_DDFOID   =  *blank
410500210721     C                   Eval      A_TQTAX    =  *blank
410600210721     C                   Eval      A_TQSTAF   =  *blank
410700210721     C                   Eval      A_TQCDTE   =  *blank
410800210721     C                   Eval      A_AUTH     =  FNAUTH
410900210721     C                   Eval      A_TOFfil   =  *Blank
411000210721     C                   Endsr
411100210721      /Eject
411200210721      *****************************************************************
411300210721     C     APDataA2      Begsr
411400210721     C                   Clear                   ApDtmsg
411500210721      ** - API action
411600210721     C                   Eval      A_DDACTN  = 'C'
411700210721      *
411800210721      ** - Trade reference
411900210721     C                   Eval      A_DDTDRF  = C2TDRF
412000210721      *
412100210721      ** - Bulk reference
412200210721     C                   Eval      A_DDBLKR  = C2BLKR
412300210721      *
412400210721      ** - Client Number
412500210721     C                   Eval      A_DDCNUM  = C2TCNR
412600210721      *
412700210721      ** - Security short name
412800210721     C                   Eval      A_DDSESN  = C2TDSS
412900210721      *
413000210721      ** - Customer shortname
413100210721     C                   Eval      A_DDCSSN  = *blank
413200210721      *
413300210721      ** - Customer report name
413400210721     C                   Eval      A_DDCRNM  = *blank
413500210721      *
413600210721      ** - Customer report town
413700210721     C                   Eval      A_DDCRTN  = *blank
413800210721      *
413900210721      ** - Incomplete indicator
414000210721     C                   Eval      A_DDINCS  = O_TINC
414100210721      *
414200210721      ** - Trade type
414300210721     C                   Eval      A_DDTDTP  = O_TDTP
414400210721      *
414500210721      ** - Nominal
414600210721      * Format nominal amount based on Nominal decimal plases
414700210721     C                   Move      O_NOML        W_NOML
414800210721      *                  Remove leading Zero
414900210721     C                   If        W_N1 = '0' or W_N1 = ' '
415000210721     C                   Eval      W_N1 = *blank
415100210721     C                   If        W_N2 = '0' or W_N2 = ' '
415200210721     C                   Eval      W_N2 = *blank
415300210721     C                   If        W_N3 = '0' or W_N3 = ' '
415400210721     C                   Eval      W_N3 = *blank
415500210721     C                   If        W_N4 = '0' or W_N4 = ' '
415600210721     C                   Eval      W_N4 = *blank
415700210721     C                   If        W_N5 = '0' or W_N5 = ' '
415800210721     C                   Eval      W_N5 = *blank
415900210721     C                   If        W_N6 = '0' or W_N6 = ' '
416000210721     C                   Eval      W_N6 = *blank
416100210721     C                   If        W_N7 = '0' or W_N7 = ' '
416200210721     C                   Eval      W_N7 = *blank
416300210721     C                   If        W_N8 = '0' or W_N8 = ' '
416400210721     C                   Eval      W_N8 = *blank
416500210721     C                   If        W_N9 = '0' or W_N9 = ' '
416600210721     C                   Eval      W_N9 = *blank
416700210721     C                   If        W_N10 = '0' or W_N10 = ' '
416800210721     C                   Eval      W_N10 = *blank
416900210721     C                   If        W_N11 = '0' or W_N11 = ' '
417000210721     C                   Eval      W_N11 = *blank
417100210721     C                   Endif
417200210721     C                   Endif
417300210721     C                   Endif
417400210721     C                   Endif
417500210721     C                   Endif
417600210721     C                   Endif
417700210721     C                   Endif
417800210721     C                   Endif
417900210721     C                   Endif
418000210721     C                   Endif
418100210721     C                   Endif
418200210721     C                   If        TNMD = 0
418300210721     C                   Eval      A_DDNOML  = %trim(W_NOML0)
418400210721     C                   Endif
418500210721     C                   If        TNMD = 1
418600210721     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
418700210721     C                   Endif
418800210721     C                   If        TNMD = 2
418900210721     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
419000210721     C                   Endif
419100210721     C                   If        TNMD = 3
419200210721     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
419300210721     C                   Endif
419400210721     C                   If        TNMD = 4
419500210721     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
419600210721     C                   Endif
419700210721
419800210721      *
419900210721      ** - Price/Disc/Yield
420000210721      * If not nil format with Price Decimal places  (15,8)
420100210721     C                   If        O_TPDY  > 0
420200210721     C                   Movel     O_TPDY        W_1508
420300210721      *                  Remove leading Zero
420400210721     C                   If        W_I1 = '0' or W_I1 = ' '
420500210721     C                   Eval      W_I1 = *blank
420600210721     C                   If        W_I2 = '0' or W_I2 = ' '
420700210721     C                   Eval      W_I2 = *blank
420800210721     C                   If        W_I3 = '0' or W_I3 = ' '
420900210721     C                   Eval      W_I3 = *blank
421000210721     C                   If        W_I4 = '0' or W_I4 = ' '
421100210721     C                   Eval      W_I4 = *blank
421200210721     C                   If        W_I5 = '0' or W_I5 = ' '
421300210721     C                   Eval      W_I5 = *blank
421400210721     C                   If        W_I6 = '0' or W_I6 = ' '
421500210721     C                   Eval      W_I6 = *blank
421600210721     C                   Endif
421700210721     C                   Endif
421800210721     C                   Endif
421900210721     C                   Endif
422000210721     C                   Endif
422100210721     C                   Endif
422200210721     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
422300210721     c                   Eval      W_1508  = *blank
422400210721     C                   Endif
422500210721      *
422600210721      ** - Value Date
422700210721      * Format Date as DDMMYY
422800210721     C                   Eval      ZDATFM = 'D'
422900210721     C                   CALLB     'ZDATE2'
423000210721     C                   PARM                    O_TDVD
423100210721     C                   PARM                    ZDATFM            1
423200210721     C                   PARM                    ZDATE             6 0
423300210721     C                   PARM                    ZADATE            7
423400210721     C                   Movel     ZDATE         A_DDTDVD
423500210721      *
423600210721      ** - Booking Branch
423700210721      * Overwrite branch to consolidated branch
423800210721     C                   Eval      A_DDBRCD  = FNBRCA
423900210721      *
424000210721      ** - Book
424100210721     C                   Eval      A_DDBPBK  = C2TDBK
424200210721      *
424300210721      ** - Clearance type
424400210721     C                   Eval      A_DDCLTY  = C2CLTY                                        O_CLTY
424500210721     C                   Eval      A_DDCLTY2 = C2CLTY                                        O_CLTY
424600210721      *
424700210721      ** - Settlement Currency
424800210721     C                   Eval      A_DDSETC  = C2SETC                                        O_SETC
424900210721      *
425000210721      ** - REALLOWANCE
425100210721      * If not nil format with Price Decimal places  (9,5)  ????
425200210721     C                   If        O_RALL  > 0
425300210721     C                   Movel     O_RALL        W_0905
425400210721     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
425500210721     c                   Eval      W_0905  = *blank
425600210721     C                   Endif
425700210721      *
425800210721      ** - Market Center
425900210721     C                   Eval      A_DDMRKT  = O_TMKC
426000210721      *
426100210721      ** - Capacity
426200210721      * Capacity May not be required ????
426300210721     C                   Movel     O_TCAP        A_DDCPCY
426400210721      *
426500210721      ** - Price
426600210721      * If not nil format with Price Decimal places  (15,8) ???
426700210721     C                   If        O_PRIC > 0
426800210721     C                   Movel     O_PRIC        W_1508
426900210721     C                   If        W_I1 = '0' or W_I1 = ' '
427000210721     C                   Eval      W_I1 = *blank
427100210721     C                   If        W_I2 = '0' or W_I2 = ' '
427200210721     C                   Eval      W_I2 = *blank
427300210721     C                   If        W_I3 = '0' or W_I3 = ' '
427400210721     C                   Eval      W_I3 = *blank
427500210721     C                   If        W_I4 = '0' or W_I4 = ' '
427600210721     C                   Eval      W_I4 = *blank
427700210721     C                   If        W_I5 = '0' or W_I5 = ' '
427800210721     C                   Eval      W_I5 = *blank
427900210721     C                   If        W_I6 = '0' or W_I6 = ' '
428000210721     C                   Eval      W_I6 = *blank
428100210721     C                   Endif
428200210721     C                   Endif
428300210721     C                   Endif
428400210721     C                   Endif
428500210721     C                   Endif
428600210721     C                   Endif
428700210721     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
428800210721     c                   Eval      W_1508  = *blank
428900210721     C                   Endif
429000210721     C                   Eval      A_DDPRIC   = GHSUBS
429100210721      *
429200210721      ** - Ex Dividend
429300210721     C                   Eval      A_DDEXDV = C2EXDV                                          O_EXDV
429400210721      *
429500210721      ** - Fiscal Price
429600210721      * If not nil format with Price Decimal places  (15,8)    ???
429700210721     C                   If        O_FSPR > 0
429800210721     C                   Movel     O_FSPR        W_1508
429900210721     C                   If        W_I1 = '0' or W_I1 = ' '
430000210721     C                   Eval      W_I1 = *blank
430100210721     C                   If        W_I2 = '0' or W_I2 = ' '
430200210721     C                   Eval      W_I2 = *blank
430300210721     C                   If        W_I3 = '0' or W_I3 = ' '
430400210721     C                   Eval      W_I3 = *blank
430500210721     C                   If        W_I4 = '0' or W_I4 = ' '
430600210721     C                   Eval      W_I4 = *blank
430700210721     C                   If        W_I5 = '0' or W_I5 = ' '
430800210721     C                   Eval      W_I5 = *blank
430900210721     C                   If        W_I6 = '0' or W_I6 = ' '
431000210721     C                   Eval      W_I6 = *blank
431100210721     C                   Endif
431200210721     C                   Endif
431300210721     C                   Endif
431400210721     C                   Endif
431500210721     C                   Endif
431600210721     C                   Endif
431700210721     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
431800210721     C                   Movel     WrSUBS        A_DDFSPR
431900210721     c                   Eval      W_1508  = *blank
432000210721     C                   Endif
432100210721      *
432200210721      ** - Book profit center
432300210721     C                   Eval      A_DDBPRC  = O_BPRC
432400210721      *
432500210721      ** - Trans profit center
432600210721     C                   Eval      A_DDTPRC  = O_TPRC
432700210721      *
432800210721      ** - Trader ID
432900210721     C                   Eval      A_DDTDID  = O_TDID
433000210721      *
433100210721      ** - Trade date
433200210721      * Format Date as DDMMYY
433300210721     C                   Eval      ZDATFM = 'D'
433400210721     C                   CALLB     'ZDATE2'
433500210721     C                   PARM                    O_TDDT
433600210721     C                   PARM                    ZDATFM            1
433700210721     C                   PARM                    ZDATE             6 0
433800210721     C                   PARM                    ZADATE            7
433900210721     C                   Movel     ZDATE         A_DDTDDT
434000210721      *
434100210721      ** - Trade Sub type
434200210721     C                   Eval      A_DDTSUB  = O_TSUB
434300210721      *
434400210721      ** - Link Ref  Never on duplication
434500210721     C                   Eval      A_DDLKRF = C2LKRF                                          O_LKRF
434600210721      *
434700210721      ** - Market indicator  ????
434800210721     C                   Eval      A_DDTDMI = C2TDMI                                          O_TDMI
434900210721      *
435000210721      ** - ISMA / IPMA
435100210721      *  Not sure AIIP must be taken ????
435200210721     C                   Eval      A_DDAIIP = C2AIIP                                          O_AIIP
435300210721      *
435400210721      ** - Narrative
435500210721     C                   Eval      A_DDTDNR = O_TDNR                                          O_TDNR
435600210721      *
435700210721      ** - P order number never on replication
435800210721      * Will never be from TOF
435900210721     C                   Eval      A_DDORDE  = *Blank
436000210721      *
436100210721      ** - Accrued indicator
436200210721     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
436300210721      *
436400210721      ** - Days Adj/sign
436500210721     C                   If        O_DADJ > 0
436600210721     C                   Movel     O_DADJ        A_DDDADJ
436700210721     C                   Endif
436800210721     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
436900210721      *
437000210721      ** - Act/Diff Ind
437100210721     C                   Eval      A_DDACTD  =  *Blank
437200210721      *
437300210721      ** - Int Amnr/Sign
437400210721      * If not nil format with Nominal currncy position ????
437500210721     C                   If        O_ITRA > 0
437600210721     C                   Move      O_ITRA        W_ChgL
437700210721     C                   If        A6NBDP = 0
437800210721     C                   Eval      A_DDITRA  = W_ChgL
437900210721     C                   Endif
438000210721     C                   If        A6NBDP = 1
438100210721     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
438200210721     C                   Endif
438300210721     C                   If        A6NBDP = 2
438400210721     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
438500210721     C                   Endif
438600210721     C                   If        A6NBDP = 3
438700210721     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
438800210721     C                   Endif
438900210721     C                   Endif
439000210721     C                   Movel     WrSUBS        A_DDITRA
439100210721     C                   clear                   W_ChgL
439200210721      *
439300210721      ** - Origin
439400210721      *
439500210721     C                   Eval      A_DDINOR  = *blank
439600210721      *
439700210721      ** - Message Key
439800210721     C                   Eval      A_DDMSGK  = *blank
439900210721      *
440000210721      ** - Notification method
440100210721     C                   Eval      A_DDNTMT  = *blank
440200210721      *
440300210721      * Ignoring following block
440400210721     C                   Eval      A_DDNOM1  = *blank
440500210721     C                   Eval      A_DDTDV1  = *blank
440600210721     C                   Eval      A_DDACI1  = *blank
440700210721     C                   Eval      A_DDDAD1  = *blank
440800210721     C                   Eval      A_DDACT1  = *blank
440900210721     C                   Eval      A_DDITR1  = *blank
441000210721      *
441100210721      ** - Exchange rate
441200210721      * If not nil format with rate Decimal places  (13,8)
441300210721     C                   If        O_TDER > 0
441400210721     C                   Movel     O_TDER        W_1308
441500210721     C                   If        W_I1 = '0' or W_I1 = ' '
441600210721     C                   Eval      W_I1 = *blank
441700210721     C                   If        W_I2 = '0' or W_I2 = ' '
441800210721     C                   Eval      W_I2 = *blank
441900210721     C                   If        W_I3 = '0' or W_I3 = ' '
442000210721     C                   Eval      W_I3 = *blank
442100210721     C                   If        W_I4 = '0' or W_I4 = ' '
442200210721     C                   Eval      W_I4 = *blank
442300210721     C                   If        W_I5 = '0' or W_I5 = ' '
442400210721     C                   Eval      W_I5 = *blank
442500210721     C                   If        W_I6 = '0' or W_I6 = ' '
442600210721     C                   Eval      W_I6 = *blank
442700210721     C                   Endif
442800210721     C                   Endif
442900210721     C                   Endif
443000210721     C                   Endif
443100210721     C                   Endif
443200210721     C                   Endif
443300210721     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
443400210721     c                   Eval      W_1508  = *blank
443500210721     C                   Endif
443600210721      *
443700210721      ** - Exchange rateM/D
443800210721     C                   Eval      A_DDSMDI  = *blank
443900210721      *
444000210721      ** - Margin
444100210721     C                   Eval      A_DDFXMP  = *blank
444200210721      *
444300210721      ** - Base currency rate
444400210721     C                   Eval      A_DDBRTE  = *blank
444500210721      *
444600210721      *  Settlement field are left unchanged
444700210721     C                   Movel     C2SMTH        A_DDSMTH
444800210721     C                   Eval      A_DDORBR  = C2ORBR
444900210721     C                   Eval      A_DDPYFM  = C2PYFM
445000210721     C                   Eval      A_DDPFSN  = *blank
445100210721     C                   Eval      A_DDPFNM  = *blank
445200210721     C                   Eval      A_DDPFTN  = *blank
445300210721     C                   Eval      A_DDPFAN  = *blank
445400210721     C                   Eval      A_DDPFSW  = *blank
445500210721     C                   Eval      A_DDPYFB  = *blank
445600210721     C                   Eval      A_DDPAYT  = C2PAYT
445700210721     C                   Eval      A_DDPTSN  = *blank
445800210721     C                   Eval      A_DDPTNM  = *blank
445900210721     C                   Eval      A_DDPTTN  = *blank
446000210721     C                   Eval      A_DDPTAN  = *blank
446100210721     C                   Eval      A_DDPTSI  = *blank
446200210721     C                   Eval      A_DDPYTB  = *blank
446300210721     C                   Eval      A_DDTDFA  = *blank
446400210721     C                   Eval      A_DDFASN  = *blank
446500210721     C                   Eval      A_DDFANM  = *blank
446600210721     C                   Eval      A_DDFATN  = *blank
446700210721     C                   Eval      A_DDFASW  = *blank
446800210721     C                   Eval      A_DDASNM  = *blank
446900210721     C                   Eval      A_DDDELF  = C2DELF
447000210721     C                   Eval      A_DDDFSN  = *blank
447100210721     C                   Eval      A_DDDFNM  = *blank
447200210721     C                   Eval      A_DDDFTN  = *blank
447300210721     C                   Eval      A_DDDFSI  = *blank
447400210721     C                   Eval      A_DDDELT  = C2DELT
447500210721     C                   Eval      A_DDDTSN  = *blank
447600210721     C                   Eval      A_DDDTNM  = *blank
447700210721     C                   Eval      A_DDDTTN  = *blank
447800210721     C                   Eval      A_DDDTSI  = *blank
447900210721     C                   Eval      A_DDDFFA  = *blank
448000210721     C                   Eval      A_DDD1SN  = *blank
448100210721     C                   Eval      A_DDD1NM  = *blank
448200210721     C                   Eval      A_DDD1TN  = *blank
448300210721     C                   Eval      A_DDD1SI  = *blank
448400210721     C                   Eval      A_DDDTFA  = *blank
448500210721     C                   Eval      A_DDD2SN  = *blank
448600210721     C                   Eval      A_DDD2NM  = *blank
448700210721     C                   Eval      A_DDD2TN  = *blank
448800210721     C                   Eval      A_DDD2SI  = *blank
448900210721     C                   Eval      A_DDTDSI  = *blank
449000210721      *
449100210721      ** - In Currency in F72
449200210721     C                   Eval      A_DDICCY  = C2ICCY                                         O_ICCY
449300210721      *
449400210721      ** - Profit Center
449500210721     C                   Eval      A_DDPRFC  = C2PRFC                                         O_PRFC
449600210721      *
449700210721      ** - Priority code
449800210721     C                   Movel     WrSUBS        A_DDPRYC
449900210721      *
450000210721      ** - Pay Code
450100210721     C                   Eval      A_DDPCOD  = C2PCOD                                         O_PCOD
450200210721      *
450300210721      ** - Auto settle ind
450400210721     C                   Eval      A_DDAUTS  = 'Y'
450500210721      *
450600210721      ** - Brok Comm code
450700210721     C                   Eval      A_DDTBCC  =  O_TBCC
450800210721      *
450900210721      ** - Brok Com Amount
451000210721      * If not nil format with Nominal currency position
451100210721     C                   If        O_TBCA > 0
451200210721     C                   Move      O_TBCA        W_ChgL
451300210721     C                   If        A6NBDP = 0
451400210721     C                   Eval      A_DDTBCA  = W_ChgL
451500210721     C                   Endif
451600210721     C                   If        A6NBDP = 1
451700210721     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
451800210721     C                   Endif
451900210721     C                   If        A6NBDP = 2
452000210721     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
452100210721     C                   Endif
452200210721     C                   If        A6NBDP = 3
452300210721     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
452400210721     C                   Endif
452500210721     C                   Endif
452600210721     C                   clear                   W_ChgL
452700210721      *
452800210721      ** - Cust com code
452900210721     C                   Eval      A_DDTCCC  = O_TCCC
453000210721      *
453100210721      ** - Cust Comm Amount
453200210721      * If not nil format with Nominal currency position
453300210721     C                   If        O_TCCA > 0
453400210721     C                   Move      O_TCCA        W_ChgL
453500210721     C                   If        A6NBDP = 0
453600210721     C                   Eval      A_DDTCCA  = W_ChgL
453700210721     C                   Endif
453800210721     C                   If        A6NBDP = 1
453900210721     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
454000210721     C                   Endif
454100210721     C                   If        A6NBDP = 2
454200210721     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
454300210721     C                   Endif
454400210721     C                   If        A6NBDP = 3
454500210721     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
454600210721     C                   Endif
454700210721     C                   Endif
454800210721     C                   clear                   W_ChgL
454900210721      *
455000210721      ** - Chg code 1
455100210721     C                   Eval      A_DDTCC1  = O_TCC1
455200210721      *
455300210721      ** - Chg Amount 1
455400210721      * If not nil format with Nominal currncy position
455500210721     C                   If        O_TCA1 > 0
455600210721     C                   Move      O_TCA1        W_ChgL
455700210721     C                   If        A6NBDP = 0
455800210721     C                   Eval      A_DDTCA1  = W_ChgL
455900210721     C                   Endif
456000210721     C                   If        A6NBDP = 1
456100210721     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
456200210721     C                   Endif
456300210721     C                   If        A6NBDP = 2
456400210721     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
456500210721     C                   Endif
456600210721     C                   If        A6NBDP = 3
456700210721     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
456800210721     C                   Endif
456900210721     C                   Endif
457000210721     C                   clear                   W_ChgL
457100210721      *
457200210721      ** - Chg code 2
457300210721     C                   Eval      A_DDTCC2  = O_TCC2
457400210721      *
457500210721      ** - Chg Amount 2
457600210721      * If not nil format with Nominal currncy position
457700210721     C                   If        O_TCA2 > 0
457800210721     C                   Move      O_TCA2        W_ChgL
457900210721     C                   If        A6NBDP = 0
458000210721     C                   Eval      A_DDTCA2  = W_ChgL
458100210721     C                   Endif
458200210721     C                   If        A6NBDP = 1
458300210721     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
458400210721     C                   Endif
458500210721     C                   If        A6NBDP = 2
458600210721     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
458700210721     C                   Endif
458800210721     C                   If        A6NBDP = 3
458900210721     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
459000210721     C                   Endif
459100210721     C                   Endif
459200210721     C                   clear                   W_ChgL
459300210721      *
459400210721      ** - Chg code 3
459500210721     C                   Eval      A_DDTCC3  = O_TCC3
459600210721      *
459700210721      ** - Chg Amount 3
459800210721      * If not nil format with Nominal currency position
459900210721     C                   If        O_TCA3 > 0
460000210721     C                   Move      O_TCA3        W_ChgL
460100210721     C                   If        A6NBDP = 0
460200210721     C                   Eval      A_DDTCA3  = W_ChgL
460300210721     C                   Endif
460400210721     C                   If        A6NBDP = 1
460500210721     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
460600210721     C                   Endif
460700210721     C                   If        A6NBDP = 2
460800210721     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
460900210721     C                   Endif
461000210721     C                   If        A6NBDP = 3
461100210721     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
461200210721     C                   Endif
461300210721     C                   Endif
461400210721     C                   clear                   W_ChgL
461500210721      *
461600210721      ** - Chg code 4
461700210721     C                   Eval      A_DDTCC4  = O_TCC4
461800210721      *
461900210721      ** - Chg Amount 4
462000210721      * If not nil format with Nominal currncy position
462100210721     C                   If        O_TCA4 > 0
462200210721     C                   Move      O_TCA4        W_ChgL
462300210721     C                   If        A6NBDP = 0
462400210721     C                   Eval      A_DDTCA4  = W_ChgL
462500210721     C                   Endif
462600210721     C                   If        A6NBDP = 1
462700210721     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
462800210721     C                   Endif
462900210721     C                   If        A6NBDP = 2
463000210721     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
463100210721     C                   Endif
463200210721     C                   If        A6NBDP = 3
463300210721     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
463400210721     C                   Endif
463500210721     C                   Endif
463600210721     C                   clear                   W_ChgL
463700210721      *
463800210721      ** - Chg code 5
463900210721     C                   Eval      A_DDTCC5  = O_TCC5
464000210721      *
464100210721      ** - Chg Amount 5
464200210721      * If not nil format with Nominal currncy position
464300210721     C                   If        O_TCA5 > 0
464400210721     C                   Move      O_TCA5        W_ChgL
464500210721     C                   If        A6NBDP = 0
464600210721     C                   Eval      A_DDTCA5  = W_ChgL
464700210721     C                   Endif
464800210721     C                   If        A6NBDP = 1
464900210721     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
465000210721     C                   Endif
465100210721     C                   If        A6NBDP = 2
465200210721     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
465300210721     C                   Endif
465400210721     C                   If        A6NBDP = 3
465500210721     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
465600210721     C                   Endif
465700210721     C                   Endif
465800210721     C                   clear                   W_ChgL
465900210721      *
466000210721      ** - Chg code 6
466100210721     C                   Eval      A_DDTCC6  = O_TCC6
466200210721      ** - Chg Amount 6
466300210721      * If not nil format with Nominal currncy position
466400210721      * If not nil format with Nominal currncy position
466500210721     C                   If        O_TCA6 > 0
466600210721     C                   Move      O_TCA6        W_ChgL
466700210721     C                   If        A6NBDP = 0
466800210721     C                   Eval      A_DDTCA6  = W_ChgL
466900210721     C                   Endif
467000210721     C                   If        A6NBDP = 1
467100210721     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
467200210721     C                   Endif
467300210721     C                   If        A6NBDP = 2
467400210721     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
467500210721     C                   Endif
467600210721     C                   If        A6NBDP = 3
467700210721     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
467800210721     C                   Endif
467900210721     C                   Endif
468000210721     C                   clear                   W_ChgL
468100210721      *
468200210721      ** - Chg code 7
468300210721     C                   Eval      A_DDTCC7  = O_TCC7
468400210721      *
468500210721      ** - Chg Amount 7
468600210721      * If not nil format with Nominal currncy position
468700210721     C                   If        O_TCA7 > 0
468800210721     C                   Move      O_TCA7        W_ChgL
468900210721     C                   If        A6NBDP = 0
469000210721     C                   Eval      A_DDTCA7  = W_ChgL
469100210721     C                   Endif
469200210721     C                   If        A6NBDP = 1
469300210721     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
469400210721     C                   Endif
469500210721     C                   If        A6NBDP = 2
469600210721     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
469700210721     C                   Endif
469800210721     C                   If        A6NBDP = 3
469900210721     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
470000210721     C                   Endif
470100210721     C                   Endif
470200210721     C                   clear                   W_ChgL
470300210721      *
470400210721      ** - Tax amount    always blank on replication
470500210721      * If not nil format with Nominal currncy position
470600210721     C                   If        O_TAXA > 0
470700210721     C                   Move      O_TAXA        W_ChgL
470800210721     C                   If        A6NBDP = 0
470900210721     C                   Eval      A_DDTAXA  = W_ChgL
471000210721     C                   Endif
471100210721     C                   If        A6NBDP = 1
471200210721     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
471300210721     C                   Endif
471400210721     C                   If        A6NBDP = 2
471500210721     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
471600210721     C                   Endif
471700210721     C                   If        A6NBDP = 3
471800210721     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
471900210721     C                   Endif
472000210721     C                   Endif
472100210721     C                   Eval      A_DDTAXA  = *blank                                            ???
472200210721     C                   clear                   W_ChgL
472300210721      *
472400210721      ** - EU tax amount in nominall currency always balnk on replication
472500210721      * If not nil format with Nominal currncy position
472600210721     C                   If        O_EUTX > 0
472700210721     C                   Move      O_EUTX        W_ChgL
472800210721     C                   If        A6NBDP = 0
472900210721     C                   Eval      A_DDEUTX  = W_ChgL
473000210721     C                   Endif
473100210721     C                   If        A6NBDP = 1
473200210721     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
473300210721     C                   Endif
473400210721     C                   If        A6NBDP = 2
473500210721     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
473600210721     C                   Endif
473700210721     C                   If        A6NBDP = 3
473800210721     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
473900210721     C                   Endif
474000210721     C                   Endif
474100210721     C                   Eval      A_DDEUTX  = *blank                                            ???
474200210721     C                   clear                   W_ChgL
474300210721      *
474400210721      ** - Brok Comm  Rebate
474500210721      * If not nil format with Nominal currency position
474600210721     C                   If        O_BCMR > 0
474700210721     C                   Move      O_BCMR        W_ChgL
474800210721     C                   If        A6NBDP = 0
474900210721     C                   Eval      A_DDBCMR  = W_ChgL
475000210721     C                   Endif
475100210721     C                   If        A6NBDP = 1
475200210721     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
475300210721     C                   Endif
475400210721     C                   If        A6NBDP = 2
475500210721     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
475600210721     C                   Endif
475700210721     C                   If        A6NBDP = 3
475800210721     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
475900210721     C                   Endif
476000210721     C                   Endif
476100210721     C                   clear                   W_ChgL
476200210721      *
476300210721      ** - Cust Comm rebate
476400210721      * If not nil format with Nominal currency position
476500210721     C                   If        O_CCMR > 0
476600210721     C                   Move      O_CCMR        W_ChgL
476700210721     C                   If        A6NBDP = 0
476800210721     C                   Eval      A_DDCCMR  = W_ChgL
476900210721     C                   Endif
477000210721     C                   If        A6NBDP = 1
477100210721     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
477200210721     C                   Endif
477300210721     C                   If        A6NBDP = 2
477400210721     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
477500210721     C                   Endif
477600210721     C                   If        A6NBDP = 3
477700210721     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
477800210721     C                   Endif
477900210721     C                   Endif
478000210721     C                   clear                   W_ChgL
478100210721      *
478200210721      ** - Tax rebate always blank on replication
478300210721      * If not nil format with Nominal currency position
478400210721     C                   If        O_TXRB > 0
478500210721     C                   Move      O_TXRB        W_ChgL
478600210721     C                   If        A6NBDP = 0
478700210721     C                   Eval      A_DDTXRB  = W_ChgL
478800210721     C                   Endif
478900210721     C                   If        A6NBDP = 1
479000210721     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
479100210721     C                   Endif
479200210721     C                   If        A6NBDP = 2
479300210721     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
479400210721     C                   Endif
479500210721     C                   If        A6NBDP = 3
479600210721     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
479700210721     C                   Endif
479800210721     C                   Endif
479900210721     C                   clear                   W_ChgL
480000210721      *
480100210721      ** - Portfolio reference Always Blank on replication
480200210721     C                   Eval      A_DDPTFR   = C2PTFR
480300210721      *  Extension file TRADSDX1  Not sure it needs to be setup
480400210721      *
480500210721      *  Settlement Message Request
480600210721     C                   Eval      A_ADDGMES  = *blank
480700210721      *
480800210721      *  Time of Trade
480900210721     C                   Eval      A_ADDTRTT  = *blank
481000210721      *
481100210721      *  Instructions Type
481200210721     C                   Eval      A_ADDINST  = C2T1INST
481300210721      *
481400210721      *   Instructions sub-type
481500210721     C                   Eval      A_ADDINSS  = C2T1INSS
481600210721      *
481700210721      *   Euroclear/Cedel code
481800210721     C                   Eval      A_ADDEUCL  = C2T1EUCL
481900210721      *
482000210721      *  Safekeeping Account (MT580)
482100210721     C                   Eval      A_ADDSAFA  = C2T1SAFA
482200210721      *
482300210721      *  Requested Priority
482400210721     C                   Eval      A_ADDRPTY  = C2T1RPTY
482500210721      *
482600210721      *  Guaranteed Delivery
482700210721     C                   Eval      A_ADDGDEL  = *blank
482800210721      *
482900210721      *  Sender's Role
483000210721     C                   Eval      A_ADDSROL  = *blank
483100210721      *
483200210721      *  Fungibilty Code
483300210721     C                   Eval      A_ADDFCOD  = *blank
483400210721      *
483500210721      *  Fungible Trade Indicator
483600210721     C                   Eval      A_ADDFTID  = *blank
483700210721      *
483800210721      *  Confirmation Message Request
483900210721     C                   Eval      A_ADDGMEC  = *blank
484000210721      *
484100210721      *  Customer/Counterparty Ind.
484200210721     C                   Eval      A_ADDCCID  = *blank
484300210721      *
484400210721      *  Further Id.
484500210721     C                   Eval      A_ADDFID1  = *blank
484600210721      *
484700210721      *  Standard Instructions' Overr  ?
484800210721     C                   Eval      A_ADDIORA  = *blank
484900210721      *
485000210721      *  ISO15022 Messages Ind.
485100210721     C                   Eval      A_ADDSNEW  = *blank
485200210721      *
485300210721      *  Stamp Status
485400210721     C                   Eval      A_ADDSTMP  = *blank
485500210721      *
485600210721      *  Charity Identifier
485700210721     C                   Eval      A_ADDCHID  = *blank
485800210721      *
485900210721      *  Transaction Report Marker
486000210721     C                   Eval      A_ADDTRRM  = *blank
486100210721      *
486200210721      * Ignore following block
486300210721     C                   Eval      A_BDDGMES  = *blank
486400210721     C                   Eval      A_BDDTRTT  = *blank
486500210721     C                   Eval      A_BDDINST   =*blank
486600210721     C                   Eval      A_BDDINSS   =*blank
486700210721     C                   Eval      A_BDDEUCL   =*blank
486800210721     C                   Eval      A_BDDSAFA   = *blank
486900210721     C                   Eval      A_BDDRPTY   = *blank
487000210721     C                   Eval      A_BDDGDEL   = *blank
487100210721     C                   Eval      A_BDDSROL   = *blank
487200210721     C                   Eval      A_BDDFCOD   = *blank
487300210721     C                   Eval      A_BDDFTID   = *blank
487400210721     C                   Eval      A_BDDGMEC   = *blank
487500210721     C                   Eval      A_BDDCCID   = *blank
487600210721     C                   Eval      A_BDDFID1   = *blank
487700210721     C                   Eval      A_BDDIORA   = *blank
487800210721     C                   Eval      A_BDDSNEW   = *blank
487900210721     C                   Eval      A_BDDSTMP   = *blank
488000210721     C                   Eval      A_BDDCHID   = *blank
488100210721     C                   Eval      A_BDDTRRM   = *blank
488200210721     C                   Eval      A_AESAP1N   = *blank
488300210721     C                   Eval      A_DDA1SN    = *blank
488400210721     C                   Eval      A_DDA1NM    = *blank
488500210721     C                   Eval      A_DDA1TN    = *blank
488600210721     C                   Eval      A_DDA1SI    = *blank
488700210721     C                   Eval      A_AESAP1L   = *blank
488800210721     C                   Eval      A_AESAP2N   = *blank
488900210721     C                   Eval      A_DDA2SN   =  *blank
489000210721     C                   Eval      A_DDA2NM   =  *blank
489100210721     C                   Eval      A_DDA2TN   =  *blank
489200210721     C                   Eval      A_DDA2SI   =  *blank
489300210721     C                   Eval      A_AESAP2L  =  *blank
489400210721     C                   Eval      A_AESAWIN  =  *blank
489500210721     C                   Eval      A_DDAISN   =  *blank
489600210721     C                   Eval      A_DDAINM   =  *blank
489700210721     C                   Eval      A_DDAITN   =  *blank
489800210721     C                   Eval      A_DDAISI   =  *blank
489900210721     C                   Eval      A_AESAWIL  =  *blank
490000210721     C                   Eval      A_AESBOFN  =  *blank
490100210721     C                   Eval      A_DDBMSN   =  *blank
490200210721     C                   Eval      A_DDBMNM   =  *blank
490300210721     C                   Eval      A_DDBMTN   =  *blank
490400210721     C                   Eval      A_DDBMSI   =  *blank
490500210721     C                   Eval      A_AESBOF1  =  *blank
490600210721     C                   Eval      A_AESBOF2  =  *blank
490700210721     C                   Eval      A_AESACL1  =  *blank
490800210721     C                   Eval      A_AESACL2  =  *blank
490900210721     C                   Eval      A_AESSRL1  =  *blank
491000210721     C                   Eval      A_AESSRL2  =  *blank
491100210721     C                   Eval      A_AESSRL3  =  *blank
491200210721     C                   Eval      A_AESFIN1  =  *blank
491300210721     C                   Eval      A_AESFIN2   = *blank
491400210721     C                   Eval      A_AESRED1   = *blank
491500210721     C                   Eval      A_AESRED2   = *blank
491600210721     C                   Eval      A_AESNAL1   = *blank
491700210721     C                   Eval      A_AESNAL2   = *blank
491800210721     C                   Eval      A_AESIPYN   = *blank
491900210721     C                   Eval      A_DDIPSN    = *blank
492000210721     C                   Eval      A_DDIPNM    = *blank
492100210721     C                   Eval      A_DDIPTN    = *blank
492200210721     C                   Eval      A_DDIPSI    = *blank
492300210721     C                   Eval      A_AESIPYL   = *blank
492400210721     C                   Eval      A_AESCTYN   = *blank
492500210721     C                   Eval      A_AESCTYL   = *blank
492600210721     C                   Eval      A_AESSA1N   = *blank
492700210721     C                   Eval      A_DDCZSN    = *blank
492800210721     C                   Eval      A_DDCSNM    = *blank
492900210721     C                   Eval      A_DDCSTN    = *blank
493000210721     C                   Eval      A_DDCSSI    = *blank
493100210721     C                   Eval      A_AESSA1L   = *blank
493200210721     C                   Eval      A_AESSKAN   = *blank
493300210721     C                   Eval      A_DDUSSN    = *blank
493400210721     C                   Eval      A_DDUSNM    = *blank
493500210721     C                   Eval      A_DDUSTN    = *blank
493600210721     C                   Eval      A_DDUSSI    = *blank
493700210721     C                   Eval      A_AESSKAL   = *blank
493800210721     C                   Eval      A_AESCCTN   = *blank
493900210721     C                   Eval      A_DDCCSN    = *blank
494000210721     C                   Eval      A_DDCCNM    = *blank
494100210721     C                   Eval      A_DDCCTN    = *blank
494200210721     C                   Eval      A_DDCCSI    = *blank
494300210721     C                   Eval      A_AESDCTL   = *blank
494400210721     C                   Eval      A_AESRSSN   = *blank
494500210721     C                   Eval      A_DDRSSN    = *blank
494600210721     C                   Eval      A_DDRSNM    = *blank
494700210721     C                   Eval      A_DDRSTN    = *blank
494800210721     C                   Eval      A_DDRSSI    = *blank
494900210721     C                   Eval      A_AESRSS1   = *blank
495000210721     C                   Eval      A_AESRSS2   = *blank
495100210721     C                   Eval      A_AESRSS3   = *blank
495200210721     C                   Eval      A_AESRSS4   = *blank
495300210721     C                   Eval      A_AESDSSN   = *blank
495400210721     C                   Eval      A_AESDSS1   = *blank
495500210721     C                   Eval      A_AESDSS2   = *blank
495600210721     C                   Eval      A_AESDSS3   = *blank
495700210721     C                   Eval      A_AESDSS4   = *blank
495800210721     C                   Eval      A_AESBSSN   = *blank
495900210721     C                   Eval      A_AESBSS1   = *blank
496000210721     C                   Eval      A_AESBSS2   = *blank
496100210721     C                   Eval      A_AESINVE   = *blank
496200210721     C                   Eval      A_DDIOSN    = *blank
496300210721     C                   Eval      A_DDIONM    = *blank
496400210721     C                   Eval      A_DDIOTN    = *blank
496500210721     C                   Eval      A_DDIOSI    = *blank
496600210721     C                   Eval      A_AESIMMD1  = *blank
496700210721     C                   Eval      A_DDI1SN    = *blank
496800210721     C                   Eval      A_DDI1NM    = *blank
496900210721     C                   Eval      A_DDI1TN    = *blank
497000210721     C                   Eval      A_DDI1SI    = *blank
497100210721     C                   Eval      A_AESIMSA1  = *blank
497200210721     C                   Eval      A_AESIMMD2  = *blank
497300210721     C                   Eval      A_DDI2SN    = *blank
497400210721     C                   Eval      A_DDI2NM    = *blank
497500210721     C                   Eval      A_DDI2TN    = *blank
497600210721     C                   Eval      A_DDI2SI    = *blank
497700210721     C                   Eval      A_AESIMSA2  = *blank
497800210721     C                   Eval      A_AESIMMD3  = *blank
497900210721     C                   Eval      A_AESIMSA3  = *blank
498000210721     C                   Eval      A_AESIMMD4  = *blank
498100210721     C                   Eval      A_AESIMSA4  = *blank
498200210721     C                   Eval      A_AESIMMD5  = *blank
498300210721     C                   Eval      A_AESIMSA5  = *blank
498400210721     C                   Eval      A_AESIMMD6  = *blank
498500210721     C                   Eval      A_AESIMSA6  = *blank
498600210721     C                   Eval      A_AESIMMD7  = *blank
498700210721     C                   Eval      A_AESIMSA7  = *blank
498800210721     C                   Eval      A_AESIMMD8  = *blank
498900210721     C                   Eval      A_AESIMSA8  = *blank
499000210721     C                   Eval      A_AESIMMD9  = *blank
499100210721     C                   Eval      A_AESIMSA9  = *blank
499200210721     C                   Eval      A_AESPSET   = *blank
499300210721     C                   Eval      A_DDPSSN    = *Blank
499400210721     C                   Eval      A_DDPSNM    = *Blank
499500210721     C                   Eval      A_DDPSTN    = *Blank
499600210721     C                   Eval      A_DDPSSI    = *Blank
499700210721     C                   Eval      A_AESNAC1   = *Blank
499800210721     C                   Eval      A_AESNAC2   = *Blank
499900210721     C                   Eval      A_AESDIDN   = *Blank
500000210721     C                   Eval      A_AESDAD1   = *Blank
500100210721     C                   Eval      A_AESDAD2   = *Blank
500200210721     C                   Eval      A_AESDAD3   = *Blank
500300210721     C                   Eval      A_AESDAD4   = *Blank
500400210721     C                   Eval      A_AESDLIN   = *Blank
500500210721     C                   Eval      A_AESQFIN   = *Blank
500600210721     C                   Eval      A_AESPCLR   = *Blank
500700210721     C                   Eval      A_BESAP1N   = *Blank
500800210721     C                   Eval      A_BDA1SN    = *Blank
500900210721     C                   Eval      A_BDA1NM   =  *Blank
501000210721     C                   Eval      A_BDA1TN   =  *Blank
501100210721     C                   Eval      A_BDA1SI   =  *Blank
501200210721     C                   Eval      A_BESAP1L  =  *Blank
501300210721     C                   Eval      A_BESAP2N  =  *Blank
501400210721     C                   Eval      A_BDA2SN   =  *Blank
501500210721     C                   Eval      A_BDA2NM   =  *blank
501600210721     C                   Eval      A_BDA2TN   =  *blank
501700210721     C                   Eval      A_BDA2SI   =  *blank
501800210721     C                   Eval      A_BESAP2L  =  *blank
501900210721     C                   Eval      A_BESAWIN  =  *blank
502000210721     C                   Eval      A_BDAISN   =  *blank
502100210721     C                   Eval      A_BDAINM   =  *blank
502200210721     C                   Eval      A_BDAITN   =  *blank
502300210721     C                   Eval      A_BDAISI   =  *blank
502400210721     C                   Eval      A_BESAWIL  =  *blank
502500210721     C                   Eval      A_BESBOFN  =  *blank
502600210721     C                   Eval      A_BDBMSN   =  *blank
502700210721     C                   Eval      A_BDBMNM   =  *blank
502800210721     C                   Eval      A_BDBMTN   =  *blank
502900210721     C                   Eval      A_BDBMSI   =  *blank
503000210721     C                   Eval      A_BESBOF1  =  *blank
503100210721     C                   Eval      A_BESBOF2  =  *blank
503200210721     C                   Eval      A_BESACL1  =  *blank
503300210721     C                   Eval      A_BESACL2   = *blank
503400210721     C                   Eval      A_BESSRL1   = *blank
503500210721     C                   Eval      A_BESSRL2   = *blank
503600210721     C                   Eval      A_BESSRL3   = *blank
503700210721     C                   Eval      A_BESFIN1   = *blank
503800210721     C                   Eval      A_BESFIN2   = *blank
503900210721     C                   Eval      A_BESRED1   = *blank
504000210721     C                   Eval      A_BESRED2   = *blank
504100210721     C                   Eval      A_BESNAL1   = *blank
504200210721     C                   Eval      A_BESNAL2   = *blank
504300210721     C                   Eval      A_BESIPYN   = *blank
504400210721     C                   Eval      A_BDIPSN    = *blank
504500210721     C                   Eval      A_BDIPNM    = *blank
504600210721     C                   Eval      A_BDIPTN    = *blank
504700210721     C                   Eval      A_BDIPSI    = *blank
504800210721     C                   Eval      A_BESIPYL   = *blank
504900210721     C                   Eval      A_BESCTYN   = *blank
505000210721     C                   Eval      A_BESCTYL   = *blank
505100210721     C                   Eval      A_BESSA1N   = *blank
505200210721     C                   Eval      A_BDCZSN    = *blank
505300210721     C                   Eval      A_BDCSNM    = *blank
505400210721     C                   Eval      A_BDCSTN    = *blank
505500210721     C                   Eval      A_BDCSSI    = *blank
505600210721     C                   Eval      A_BESSA1L   = *blank
505700210721     C                   Eval      A_BESSKAN   = *blank
505800210721     C                   Eval      A_BDUSSN    = *blank
505900210721     C                   Eval      A_BDUSNM    = *blank
506000210721     C                   Eval      A_BDUSTN    = *blank
506100210721     C                   Eval      A_BDUSSI    = *blank
506200210721     C                   Eval      A_BESSKAL   = *blank
506300210721     C                   Eval      A_BESCCTN   = *blank
506400210721     C                   Eval      A_BDCCSN    = *blank
506500210721     C                   Eval      A_BDCCNM    = *blank
506600210721     C                   Eval      A_BDCCTN    = *blank
506700210721     C                   Eval      A_BDCCSI    = *blank
506800210721     C                   Eval      A_BESDCTL   = *blank
506900210721     C                   Eval      A_BESRSSN   = *blank
507000210721     C                   Eval      A_BDRSSN    = *blank
507100210721     C                   Eval      A_BDRSNM    = *blank
507200210721     C                   Eval      A_BDRSTN    = *blank
507300210721     C                   Eval      A_BDRSSI    = *blank
507400210721     C                   Eval      A_BESRSS1   = *blank
507500210721     C                   Eval      A_BESRSS2   = *blank
507600210721     C                   Eval      A_BESRSS3   = *blank
507700210721     C                   Eval      A_BESRSS4   = *blank
507800210721     C                   Eval      A_BESDSSN   = *blank
507900210721     C                   Eval      A_BESDSS1   = *blank
508000210721     C                   Eval      A_BESDSS2   = *blank
508100210721     C                   Eval      A_BESDSS3   = *blank
508200210721     C                   Eval      A_BESDSS4   = *blank
508300210721     C                   Eval      A_BESBSSN   = *blank
508400210721     C                   Eval      A_BESBSS1   = *blank
508500210721     C                   Eval      A_BESBSS2   = *blank
508600210721     C                   Eval      A_BESINVE   = *blank
508700210721     C                   Eval      A_BDIOSN    = *blank
508800210721     C                   Eval      A_BDIONM    = *blank
508900210721     C                   Eval      A_BDIOTN    = *blank
509000210721     C                   Eval      A_BDIOSI    = *blank
509100210721     C                   Eval      A_BESIMMD1  = *blank
509200210721     C                   Eval      A_BDI1SN    = *blank
509300210721     C                   Eval      A_BDI1NM    = *blank
509400210721     C                   Eval      A_BDI1TN    = *blank
509500210721     C                   Eval      A_BDI1SI    = *blank
509600210721     C                   Eval      A_BESIMSA1  = *blank
509700210721     C                   Eval      A_BESIMMD2  = *blank
509800210721     C                   Eval      A_BDI2SN    = *blank
509900210721     C                   Eval      A_BDI2NM    = *blank
510000210721     C                   Eval      A_BDI2TN    = *blank
510100210721     C                   Eval      A_BDI2SI    = *blank
510200210721     C                   Eval      A_BESIMSA2  = *blank
510300210721     C                   Eval      A_BESIMMD3  = *blank
510400210721     C                   Eval      A_BESIMSA3  = *blank
510500210721     C                   Eval      A_BESIMMD4   =*blank
510600210721     C                   Eval      A_BESIMSA4   =*blank
510700210721     C                   Eval      A_BESIMMD5   =*blank
510800210721     C                   Eval      A_BESIMSA5   =*blank
510900210721     C                   Eval      A_BESIMMD6   =*blank
511000210721     C                   Eval      A_BESIMSA6   =*blank
511100210721     C                   Eval      A_BESIMMD7   = *blank
511200210721     C                   Eval      A_BESIMSA7   = *blank
511300210721     C                   Eval      A_BESIMMD8   = *blank
511400210721     C                   Eval      A_BESIMSA8   = *blank
511500210721     C                   Eval      A_BESIMMD9   = *blank
511600210721     C                   Eval      A_BESIMSA9   = *blank
511700210721     C                   Eval      A_BESPSET    = *blank
511800210721     C                   Eval      A_BDPSSN     = *blank
511900210721     C                   Eval      A_BDPSNM     = *blank
512000210721     C                   Eval      A_BDPSTN     = *blank
512100210721     C                   Eval      A_BDPSSI     = *blank
512200210721     C                   Eval      A_BESNAC1    = *blank
512300210721     C                   Eval      A_BESNAC2    = *blank
512400210721     C                   Eval      A_BESDIDN    = *blank
512500210721     C                   Eval      A_BESDAD1    = *blank
512600210721     C                   Eval      A_BESDAD2    = *blank
512700210721     C                   Eval      A_BESDAD3    = *blank
512800210721     C                   Eval      A_BESDAD4    = *blank
512900210721     C                   Eval      A_BESDLIN   =  *blank
513000210721     C                   Eval      A_BESQFIN   =  *blank
513100210721     C                   Eval      A_BESPCLR   =  *blank
513200210721     C                   Eval      A_DDCRSK    =  *blank
513300210721     C                   Eval      A_DDLQPR    =  *blank
513400210721     C                   Eval      A_DDITRN    = *blank
513500210721     C                   Eval      A_TMSP      = *blank
513600210721     C                   Eval      A_BDSPBS    = *blank
513700210721     C                   Eval      A_STBS      = *blank
513800210721     C                   Eval      A_PROT      = *blank
513900210721     C                   Eval      A_NMCY      = *blank
514000210721     C                   Eval      A_C1DI      = *blank
514100210721     C                   Eval      A_BVAUTH    = *blank
514200210721     C                   Eval      A_DDCPNR    = *blank
514300210721     C                   Eval      A_DDTCTR    = *blank
514400210721     C                   Eval      A_DDCFCT    = *blank
514500210721     C                   Eval      A_ADDROUS   = *blank
514600210721     C                   Eval      A_ADDROTS   = *blank
514700210721     C                   Eval      A_ADDROUC   = *blank
514800210721     C                   Eval      A_ADDROTC   = *blank
514900210721     C                   Eval      A_BDDROUS   = *blank
515000210721     C                   Eval      A_BDDROTS   = *blank
515100210721     C                   Eval      A_BDDROUC   = *blank
515200210721     C                   Eval      A_BDDROTC   = *blank
515300210721     C                   Eval      A_DDSPXR   =  *blank
515400210721     C                   Eval      A_DDSPMD   =  *blank
515500210721     C                   Eval      A_DDWTAX   =  *blank
515600210721     C                   Eval      A_BKEURO   =  *blank
515700210721     C                   Eval      A_DDSTAT   =  *blank
515800210721     C                   Eval      A_DDAUTH   =  FNAUTH
515900210721     C                   Eval      A_SITP     =  *blank
516000210721     C                   Eval      A_DDPRICN  =  *blank
516100210721     C                   Eval      A_DDHACR   =  *blank
516200210721     C                   Eval      A_DDTCSR   =  *blank
516300210721     C                   Eval      A_DDDAYS   =  *blank
516400210721     C                   Eval      A_DDFOID   =  *blank
516500210721     C                   Eval      A_TQTAX    =  *blank
516600210721     C                   Eval      A_TQSTAF   =  *blank
516700210721     C                   Eval      A_TQCDTE   =  *blank
516800210721     C                   Eval      A_AUTH     =  FNAUTH
516900210721     C                   Eval      A_TOFfil   =  *Blank
517000210721     C                   Endsr
517100210721      /Eject
517200210721      *****************************************************************
517300210721     C     APDataA3      Begsr
517400210721     C                   Clear                   ApDtmsg
517500210721      ** - API action
517600210721     C                   Eval      A_DDACTN  = 'C'
517700210721      *
517800210721      ** - Trade reference
517900210721     C                   Eval      A_DDTDRF  = C3TDRF
518000210721      *
518100210721      ** - Bulk reference
518200210721     C                   Eval      A_DDBLKR  = C3BLKR
518300210721      *
518400210721      ** - Client Number
518500210721     C                   Eval      A_DDCNUM  = C3TCNR
518600210721      *
518700210721      ** - Security short name
518800210721     C                   Eval      A_DDSESN  = C3TDSS
518900210721      *
519000210721      ** - Customer shortname
519100210721     C                   Eval      A_DDCSSN  = *blank
519200210721      *
519300210721      ** - Customer report name
519400210721     C                   Eval      A_DDCRNM  = *blank
519500210721      *
519600210721      ** - Customer report town
519700210721     C                   Eval      A_DDCRTN  = *blank
519800210721      *
519900210721      ** - Incomplete indicator
520000210721     C                   Eval      A_DDINCS  = O_TINC
520100210721      *
520200210721      ** - Trade type
520300210721     C                   Eval      A_DDTDTP  = O_TDTP
520400210721      *
520500210721      ** - Nominal
520600210721      * Format nominal amount based on Nominal decimal plases
520700210721     C                   Move      O_NOML        W_NOML
520800210721      *                  Remove leading Zero
520900210721     C                   If        W_N1 = '0' or W_N1 = ' '
521000210721     C                   Eval      W_N1 = *blank
521100210721     C                   If        W_N2 = '0' or W_N2 = ' '
521200210721     C                   Eval      W_N2 = *blank
521300210721     C                   If        W_N3 = '0' or W_N3 = ' '
521400210721     C                   Eval      W_N3 = *blank
521500210721     C                   If        W_N4 = '0' or W_N4 = ' '
521600210721     C                   Eval      W_N4 = *blank
521700210721     C                   If        W_N5 = '0' or W_N5 = ' '
521800210721     C                   Eval      W_N5 = *blank
521900210721     C                   If        W_N6 = '0' or W_N6 = ' '
522000210721     C                   Eval      W_N6 = *blank
522100210721     C                   If        W_N7 = '0' or W_N7 = ' '
522200210721     C                   Eval      W_N7 = *blank
522300210721     C                   If        W_N8 = '0' or W_N8 = ' '
522400210721     C                   Eval      W_N8 = *blank
522500210721     C                   If        W_N9 = '0' or W_N9 = ' '
522600210721     C                   Eval      W_N9 = *blank
522700210721     C                   If        W_N10 = '0' or W_N10 = ' '
522800210721     C                   Eval      W_N10 = *blank
522900210721     C                   If        W_N11 = '0' or W_N11 = ' '
523000210721     C                   Eval      W_N11 = *blank
523100210721     C                   Endif
523200210721     C                   Endif
523300210721     C                   Endif
523400210721     C                   Endif
523500210721     C                   Endif
523600210721     C                   Endif
523700210721     C                   Endif
523800210721     C                   Endif
523900210721     C                   Endif
524000210721     C                   Endif
524100210721     C                   Endif
524200210721     C                   If        TNMD = 0
524300210721     C                   Eval      A_DDNOML  = %trim(W_NOML0)
524400210721     C                   Endif
524500210721     C                   If        TNMD = 1
524600210721     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
524700210721     C                   Endif
524800210721     C                   If        TNMD = 2
524900210721     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
525000210721     C                   Endif
525100210721     C                   If        TNMD = 3
525200210721     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
525300210721     C                   Endif
525400210721     C                   If        TNMD = 4
525500210721     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
525600210721     C                   Endif
525700210721
525800210721      *
525900210721      ** - Price/Disc/Yield
526000210721      * If not nil format with Price Decimal places  (15,8)
526100210721     C                   If        O_TPDY  > 0
526200210721     C                   Movel     O_TPDY        W_1508
526300210721      *                  Remove leading Zero
526400210721     C                   If        W_I1 = '0' or W_I1 = ' '
526500210721     C                   Eval      W_I1 = *blank
526600210721     C                   If        W_I2 = '0' or W_I2 = ' '
526700210721     C                   Eval      W_I2 = *blank
526800210721     C                   If        W_I3 = '0' or W_I3 = ' '
526900210721     C                   Eval      W_I3 = *blank
527000210721     C                   If        W_I4 = '0' or W_I4 = ' '
527100210721     C                   Eval      W_I4 = *blank
527200210721     C                   If        W_I5 = '0' or W_I5 = ' '
527300210721     C                   Eval      W_I5 = *blank
527400210721     C                   If        W_I6 = '0' or W_I6 = ' '
527500210721     C                   Eval      W_I6 = *blank
527600210721     C                   Endif
527700210721     C                   Endif
527800210721     C                   Endif
527900210721     C                   Endif
528000210721     C                   Endif
528100210721     C                   Endif
528200210721     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
528300210721     c                   Eval      W_1508  = *blank
528400210721     C                   Endif
528500210721      *
528600210721      ** - Value Date
528700210721      * Format Date as DDMMYY
528800210721     C                   Eval      ZDATFM = 'D'
528900210721     C                   CALLB     'ZDATE2'
529000210721     C                   PARM                    O_TDVD
529100210721     C                   PARM                    ZDATFM            1
529200210721     C                   PARM                    ZDATE             6 0
529300210721     C                   PARM                    ZADATE            7
529400210721     C                   Movel     ZDATE         A_DDTDVD
529500210721      *
529600210721      ** - Booking Branch
529700210721      * Overwrite branch to consolidated branch
529800210721     C                   Eval      A_DDBRCD  = FNBRCA
529900210721      *
530000210721      ** - Book
530100210721     C                   Eval      A_DDBPBK  = C3TDBK
530200210721      *
530300210721      ** - Clearance type
530400210721     C                   Eval      A_DDCLTY  = C3CLTY                                        O_CLTY
530500210721     C                   Eval      A_DDCLTY2 = C3CLTY                                        O_CLTY
530600210721      *
530700210721      ** - Settlement Currency
530800210721     C                   Eval      A_DDSETC  = C3SETC                                        O_SETC
530900210721      *
531000210721      ** - REALLOWANCE
531100210721      * If not nil format with Price Decimal places  (9,5)  ????
531200210721     C                   If        O_RALL  > 0
531300210721     C                   Movel     O_RALL        W_0905
531400210721     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
531500210721     c                   Eval      W_0905  = *blank
531600210721     C                   Endif
531700210721      *
531800210721      ** - Market Center
531900210721     C                   Eval      A_DDMRKT  = O_TMKC
532000210721      *
532100210721      ** - Capacity
532200210721      * Capacity May not be required ????
532300210721     C                   Movel     O_TCAP        A_DDCPCY
532400210721      *
532500210721      ** - Price
532600210721      * If not nil format with Price Decimal places  (15,8) ???
532700210721     C                   If        O_PRIC > 0
532800210721     C                   Movel     O_PRIC        W_1508
532900210721     C                   If        W_I1 = '0' or W_I1 = ' '
533000210721     C                   Eval      W_I1 = *blank
533100210721     C                   If        W_I2 = '0' or W_I2 = ' '
533200210721     C                   Eval      W_I2 = *blank
533300210721     C                   If        W_I3 = '0' or W_I3 = ' '
533400210721     C                   Eval      W_I3 = *blank
533500210721     C                   If        W_I4 = '0' or W_I4 = ' '
533600210721     C                   Eval      W_I4 = *blank
533700210721     C                   If        W_I5 = '0' or W_I5 = ' '
533800210721     C                   Eval      W_I5 = *blank
533900210721     C                   If        W_I6 = '0' or W_I6 = ' '
534000210721     C                   Eval      W_I6 = *blank
534100210721     C                   Endif
534200210721     C                   Endif
534300210721     C                   Endif
534400210721     C                   Endif
534500210721     C                   Endif
534600210721     C                   Endif
534700210721     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
534800210721     c                   Eval      W_1508  = *blank
534900210721     C                   Endif
535000210721     C                   Eval      A_DDPRIC   = GHSUBS
535100210721      *
535200210721      ** - Ex Dividend
535300210721     C                   Eval      A_DDEXDV = C3EXDV                                          O_EXDV
535400210721      *
535500210721      ** - Fiscal Price
535600210721      * If not nil format with Price Decimal places  (15,8)    ???
535700210721     C                   If        O_FSPR > 0
535800210721     C                   Movel     O_FSPR        W_1508
535900210721     C                   If        W_I1 = '0' or W_I1 = ' '
536000210721     C                   Eval      W_I1 = *blank
536100210721     C                   If        W_I2 = '0' or W_I2 = ' '
536200210721     C                   Eval      W_I2 = *blank
536300210721     C                   If        W_I3 = '0' or W_I3 = ' '
536400210721     C                   Eval      W_I3 = *blank
536500210721     C                   If        W_I4 = '0' or W_I4 = ' '
536600210721     C                   Eval      W_I4 = *blank
536700210721     C                   If        W_I5 = '0' or W_I5 = ' '
536800210721     C                   Eval      W_I5 = *blank
536900210721     C                   If        W_I6 = '0' or W_I6 = ' '
537000210721     C                   Eval      W_I6 = *blank
537100210721     C                   Endif
537200210721     C                   Endif
537300210721     C                   Endif
537400210721     C                   Endif
537500210721     C                   Endif
537600210721     C                   Endif
537700210721     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
537800210721     C                   Movel     WrSUBS        A_DDFSPR
537900210721     c                   Eval      W_1508  = *blank
538000210721     C                   Endif
538100210721      *
538200210721      ** - Book profit center
538300210721     C                   Eval      A_DDBPRC  = O_BPRC
538400210721      *
538500210721      ** - Trans profit center
538600210721     C                   Eval      A_DDTPRC  = O_TPRC
538700210721      *
538800210721      ** - Trader ID
538900210721     C                   Eval      A_DDTDID  = O_TDID
539000210721      *
539100210721      ** - Trade date
539200210721      * Format Date as DDMMYY
539300210721     C                   Eval      ZDATFM = 'D'
539400210721     C                   CALLB     'ZDATE2'
539500210721     C                   PARM                    O_TDDT
539600210721     C                   PARM                    ZDATFM            1
539700210721     C                   PARM                    ZDATE             6 0
539800210721     C                   PARM                    ZADATE            7
539900210721     C                   Movel     ZDATE         A_DDTDDT
540000210721      *
540100210721      ** - Trade Sub type
540200210721     C                   Eval      A_DDTSUB  = O_TSUB
540300210721      *
540400210721      ** - Link Ref  Never on duplication
540500210721     C                   Eval      A_DDLKRF = C3LKRF                                          O_LKRF
540600210721      *
540700210721      ** - Market indicator  ????
540800210721     C                   Eval      A_DDTDMI = C3TDMI                                          O_TDMI
540900210721      *
541000210721      ** - ISMA / IPMA
541100210721      *  Not sure AIIP must be taken ????
541200210721     C                   Eval      A_DDAIIP = C3AIIP                                          O_AIIP
541300210721      *
541400210721      ** - Narrative
541500210721     C                   Eval      A_DDTDNR = O_TDNR                                          O_TDNR
541600210721      *
541700210721      ** - P order number never on replication
541800210721      * Will never be from TOF
541900210721     C                   Eval      A_DDORDE  = *Blank
542000210721      *
542100210721      ** - Accrued indicator
542200210721     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
542300210721      *
542400210721      ** - Days Adj/sign
542500210721     C                   If        O_DADJ > 0
542600210721     C                   Movel     O_DADJ        A_DDDADJ
542700210721     C                   Endif
542800210721     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
542900210721      *
543000210721      ** - Act/Diff Ind
543100210721     C                   Eval      A_DDACTD  =  *Blank
543200210721      *
543300210721      ** - Int Amnr/Sign
543400210721      * If not nil format with Nominal currncy position ????
543500210721     C                   If        O_ITRA > 0
543600210721     C                   Move      O_ITRA        W_ChgL
543700210721     C                   If        A6NBDP = 0
543800210721     C                   Eval      A_DDITRA  = W_ChgL
543900210721     C                   Endif
544000210721     C                   If        A6NBDP = 1
544100210721     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
544200210721     C                   Endif
544300210721     C                   If        A6NBDP = 2
544400210721     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
544500210721     C                   Endif
544600210721     C                   If        A6NBDP = 3
544700210721     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
544800210721     C                   Endif
544900210721     C                   Endif
545000210721     C                   Movel     WrSUBS        A_DDITRA
545100210721     C                   clear                   W_ChgL
545200210721      *
545300210721      ** - Origin
545400210721      *
545500210721     C                   Eval      A_DDINOR  = *blank
545600210721      *
545700210721      ** - Message Key
545800210721     C                   Eval      A_DDMSGK  = *blank
545900210721      *
546000210721      ** - Notification method
546100210721     C                   Eval      A_DDNTMT  = *blank
546200210721      *
546300210721      * Ignoring following block
546400210721     C                   Eval      A_DDNOM1  = *blank
546500210721     C                   Eval      A_DDTDV1  = *blank
546600210721     C                   Eval      A_DDACI1  = *blank
546700210721     C                   Eval      A_DDDAD1  = *blank
546800210721     C                   Eval      A_DDACT1  = *blank
546900210721     C                   Eval      A_DDITR1  = *blank
547000210721      *
547100210721      ** - Exchange rate
547200210721      * If not nil format with rate Decimal places  (13,8)
547300210721     C                   If        O_TDER > 0
547400210721     C                   Movel     O_TDER        W_1308
547500210721     C                   If        W_I1 = '0' or W_I1 = ' '
547600210721     C                   Eval      W_I1 = *blank
547700210721     C                   If        W_I2 = '0' or W_I2 = ' '
547800210721     C                   Eval      W_I2 = *blank
547900210721     C                   If        W_I3 = '0' or W_I3 = ' '
548000210721     C                   Eval      W_I3 = *blank
548100210721     C                   If        W_I4 = '0' or W_I4 = ' '
548200210721     C                   Eval      W_I4 = *blank
548300210721     C                   If        W_I5 = '0' or W_I5 = ' '
548400210721     C                   Eval      W_I5 = *blank
548500210721     C                   If        W_I6 = '0' or W_I6 = ' '
548600210721     C                   Eval      W_I6 = *blank
548700210721     C                   Endif
548800210721     C                   Endif
548900210721     C                   Endif
549000210721     C                   Endif
549100210721     C                   Endif
549200210721     C                   Endif
549300210721     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
549400210721     c                   Eval      W_1508  = *blank
549500210721     C                   Endif
549600210721      *
549700210721      ** - Exchange rateM/D
549800210721     C                   Eval      A_DDSMDI  = *blank
549900210721      *
550000210721      ** - Margin
550100210721     C                   Eval      A_DDFXMP  = *blank
550200210721      *
550300210721      ** - Base currency rate
550400210721     C                   Eval      A_DDBRTE  = *blank
550500210721      *
550600210721      *  Settlement field are left unchanged
550700210721     C                   Movel     C3SMTH        A_DDSMTH
550800210721     C                   Eval      A_DDORBR  = C3ORBR
550900210721     C                   Eval      A_DDPYFM  = C3PYFM
551000210721     C                   Eval      A_DDPFSN  = *blank
551100210721     C                   Eval      A_DDPFNM  = *blank
551200210721     C                   Eval      A_DDPFTN  = *blank
551300210721     C                   Eval      A_DDPFAN  = *blank
551400210721     C                   Eval      A_DDPFSW  = *blank
551500210721     C                   Eval      A_DDPYFB  = *blank
551600210721     C                   Eval      A_DDPAYT  = C3PAYT
551700210721     C                   Eval      A_DDPTSN  = *blank
551800210721     C                   Eval      A_DDPTNM  = *blank
551900210721     C                   Eval      A_DDPTTN  = *blank
552000210721     C                   Eval      A_DDPTAN  = *blank
552100210721     C                   Eval      A_DDPTSI  = *blank
552200210721     C                   Eval      A_DDPYTB  = *blank
552300210721     C                   Eval      A_DDTDFA  = *blank
552400210721     C                   Eval      A_DDFASN  = *blank
552500210721     C                   Eval      A_DDFANM  = *blank
552600210721     C                   Eval      A_DDFATN  = *blank
552700210721     C                   Eval      A_DDFASW  = *blank
552800210721     C                   Eval      A_DDASNM  = *blank
552900210721     C                   Eval      A_DDDELF  = C3DELF
553000210721     C                   Eval      A_DDDFSN  = *blank
553100210721     C                   Eval      A_DDDFNM  = *blank
553200210721     C                   Eval      A_DDDFTN  = *blank
553300210721     C                   Eval      A_DDDFSI  = *blank
553400210721     C                   Eval      A_DDDELT  = C3DELT
553500210721     C                   Eval      A_DDDTSN  = *blank
553600210721     C                   Eval      A_DDDTNM  = *blank
553700210721     C                   Eval      A_DDDTTN  = *blank
553800210721     C                   Eval      A_DDDTSI  = *blank
553900210721     C                   Eval      A_DDDFFA  = *blank
554000210721     C                   Eval      A_DDD1SN  = *blank
554100210721     C                   Eval      A_DDD1NM  = *blank
554200210721     C                   Eval      A_DDD1TN  = *blank
554300210721     C                   Eval      A_DDD1SI  = *blank
554400210721     C                   Eval      A_DDDTFA  = *blank
554500210721     C                   Eval      A_DDD2SN  = *blank
554600210721     C                   Eval      A_DDD2NM  = *blank
554700210721     C                   Eval      A_DDD2TN  = *blank
554800210721     C                   Eval      A_DDD2SI  = *blank
554900210721     C                   Eval      A_DDTDSI  = *blank
555000210721      *
555100210721      ** - In Currency in F72
555200210721     C                   Eval      A_DDICCY  = C3ICCY                                         O_ICCY
555300210721      *
555400210721      ** - Profit Center
555500210721     C                   Eval      A_DDPRFC  = C3PRFC                                         O_PRFC
555600210721      *
555700210721      ** - Priority code
555800210721     C                   Movel     WrSUBS        A_DDPRYC
555900210721      *
556000210721      ** - Pay Code
556100210721     C                   Eval      A_DDPCOD  = C3PCOD                                         O_PCOD
556200210721      *
556300210721      ** - Auto settle ind
556400210721     C                   Eval      A_DDAUTS  = 'Y'
556500210721      *
556600210721      ** - Brok Comm code
556700210721     C                   Eval      A_DDTBCC  =  O_TBCC
556800210721      *
556900210721      ** - Brok Com Amount
557000210721      * If not nil format with Nominal currency position
557100210721     C                   If        O_TBCA > 0
557200210721     C                   Move      O_TBCA        W_ChgL
557300210721     C                   If        A6NBDP = 0
557400210721     C                   Eval      A_DDTBCA  = W_ChgL
557500210721     C                   Endif
557600210721     C                   If        A6NBDP = 1
557700210721     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
557800210721     C                   Endif
557900210721     C                   If        A6NBDP = 2
558000210721     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
558100210721     C                   Endif
558200210721     C                   If        A6NBDP = 3
558300210721     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
558400210721     C                   Endif
558500210721     C                   Endif
558600210721     C                   clear                   W_ChgL
558700210721      *
558800210721      ** - Cust com code
558900210721     C                   Eval      A_DDTCCC  = O_TCCC
559000210721      *
559100210721      ** - Cust Comm Amount
559200210721      * If not nil format with Nominal currency position
559300210721     C                   If        O_TCCA > 0
559400210721     C                   Move      O_TCCA        W_ChgL
559500210721     C                   If        A6NBDP = 0
559600210721     C                   Eval      A_DDTCCA  = W_ChgL
559700210721     C                   Endif
559800210721     C                   If        A6NBDP = 1
559900210721     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
560000210721     C                   Endif
560100210721     C                   If        A6NBDP = 2
560200210721     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
560300210721     C                   Endif
560400210721     C                   If        A6NBDP = 3
560500210721     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
560600210721     C                   Endif
560700210721     C                   Endif
560800210721     C                   clear                   W_ChgL
560900210721      *
561000210721      ** - Chg code 1
561100210721     C                   Eval      A_DDTCC1  = O_TCC1
561200210721      *
561300210721      ** - Chg Amount 1
561400210721      * If not nil format with Nominal currncy position
561500210721     C                   If        O_TCA1 > 0
561600210721     C                   Move      O_TCA1        W_ChgL
561700210721     C                   If        A6NBDP = 0
561800210721     C                   Eval      A_DDTCA1  = W_ChgL
561900210721     C                   Endif
562000210721     C                   If        A6NBDP = 1
562100210721     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
562200210721     C                   Endif
562300210721     C                   If        A6NBDP = 2
562400210721     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
562500210721     C                   Endif
562600210721     C                   If        A6NBDP = 3
562700210721     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
562800210721     C                   Endif
562900210721     C                   Endif
563000210721     C                   clear                   W_ChgL
563100210721      *
563200210721      ** - Chg code 2
563300210721     C                   Eval      A_DDTCC2  = O_TCC2
563400210721      *
563500210721      ** - Chg Amount 2
563600210721      * If not nil format with Nominal currncy position
563700210721     C                   If        O_TCA2 > 0
563800210721     C                   Move      O_TCA2        W_ChgL
563900210721     C                   If        A6NBDP = 0
564000210721     C                   Eval      A_DDTCA2  = W_ChgL
564100210721     C                   Endif
564200210721     C                   If        A6NBDP = 1
564300210721     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
564400210721     C                   Endif
564500210721     C                   If        A6NBDP = 2
564600210721     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
564700210721     C                   Endif
564800210721     C                   If        A6NBDP = 3
564900210721     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
565000210721     C                   Endif
565100210721     C                   Endif
565200210721     C                   clear                   W_ChgL
565300210721      *
565400210721      ** - Chg code 3
565500210721     C                   Eval      A_DDTCC3  = O_TCC3
565600210721      *
565700210721      ** - Chg Amount 3
565800210721      * If not nil format with Nominal currency position
565900210721     C                   If        O_TCA3 > 0
566000210721     C                   Move      O_TCA3        W_ChgL
566100210721     C                   If        A6NBDP = 0
566200210721     C                   Eval      A_DDTCA3  = W_ChgL
566300210721     C                   Endif
566400210721     C                   If        A6NBDP = 1
566500210721     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
566600210721     C                   Endif
566700210721     C                   If        A6NBDP = 2
566800210721     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
566900210721     C                   Endif
567000210721     C                   If        A6NBDP = 3
567100210721     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
567200210721     C                   Endif
567300210721     C                   Endif
567400210721     C                   clear                   W_ChgL
567500210721      *
567600210721      ** - Chg code 4
567700210721     C                   Eval      A_DDTCC4  = O_TCC4
567800210721      *
567900210721      ** - Chg Amount 4
568000210721      * If not nil format with Nominal currncy position
568100210721     C                   If        O_TCA4 > 0
568200210721     C                   Move      O_TCA4        W_ChgL
568300210721     C                   If        A6NBDP = 0
568400210721     C                   Eval      A_DDTCA4  = W_ChgL
568500210721     C                   Endif
568600210721     C                   If        A6NBDP = 1
568700210721     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
568800210721     C                   Endif
568900210721     C                   If        A6NBDP = 2
569000210721     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
569100210721     C                   Endif
569200210721     C                   If        A6NBDP = 3
569300210721     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
569400210721     C                   Endif
569500210721     C                   Endif
569600210721     C                   clear                   W_ChgL
569700210721      *
569800210721      ** - Chg code 5
569900210721     C                   Eval      A_DDTCC5  = O_TCC5
570000210721      *
570100210721      ** - Chg Amount 5
570200210721      * If not nil format with Nominal currncy position
570300210721     C                   If        O_TCA5 > 0
570400210721     C                   Move      O_TCA5        W_ChgL
570500210721     C                   If        A6NBDP = 0
570600210721     C                   Eval      A_DDTCA5  = W_ChgL
570700210721     C                   Endif
570800210721     C                   If        A6NBDP = 1
570900210721     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
571000210721     C                   Endif
571100210721     C                   If        A6NBDP = 2
571200210721     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
571300210721     C                   Endif
571400210721     C                   If        A6NBDP = 3
571500210721     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
571600210721     C                   Endif
571700210721     C                   Endif
571800210721     C                   clear                   W_ChgL
571900210721      *
572000210721      ** - Chg code 6
572100210721     C                   Eval      A_DDTCC6  = O_TCC6
572200210721      ** - Chg Amount 6
572300210721      * If not nil format with Nominal currncy position
572400210721      * If not nil format with Nominal currncy position
572500210721     C                   If        O_TCA6 > 0
572600210721     C                   Move      O_TCA6        W_ChgL
572700210721     C                   If        A6NBDP = 0
572800210721     C                   Eval      A_DDTCA6  = W_ChgL
572900210721     C                   Endif
573000210721     C                   If        A6NBDP = 1
573100210721     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
573200210721     C                   Endif
573300210721     C                   If        A6NBDP = 2
573400210721     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
573500210721     C                   Endif
573600210721     C                   If        A6NBDP = 3
573700210721     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
573800210721     C                   Endif
573900210721     C                   Endif
574000210721     C                   clear                   W_ChgL
574100210721      *
574200210721      ** - Chg code 7
574300210721     C                   Eval      A_DDTCC7  = O_TCC7
574400210721      *
574500210721      ** - Chg Amount 7
574600210721      * If not nil format with Nominal currncy position
574700210721     C                   If        O_TCA7 > 0
574800210721     C                   Move      O_TCA7        W_ChgL
574900210721     C                   If        A6NBDP = 0
575000210721     C                   Eval      A_DDTCA7  = W_ChgL
575100210721     C                   Endif
575200210721     C                   If        A6NBDP = 1
575300210721     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
575400210721     C                   Endif
575500210721     C                   If        A6NBDP = 2
575600210721     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
575700210721     C                   Endif
575800210721     C                   If        A6NBDP = 3
575900210721     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
576000210721     C                   Endif
576100210721     C                   Endif
576200210721     C                   clear                   W_ChgL
576300210721      *
576400210721      ** - Tax amount    always blank on replication
576500210721      * If not nil format with Nominal currncy position
576600210721     C                   If        O_TAXA > 0
576700210721     C                   Move      O_TAXA        W_ChgL
576800210721     C                   If        A6NBDP = 0
576900210721     C                   Eval      A_DDTAXA  = W_ChgL
577000210721     C                   Endif
577100210721     C                   If        A6NBDP = 1
577200210721     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
577300210721     C                   Endif
577400210721     C                   If        A6NBDP = 2
577500210721     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
577600210721     C                   Endif
577700210721     C                   If        A6NBDP = 3
577800210721     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
577900210721     C                   Endif
578000210721     C                   Endif
578100210721     C                   Eval      A_DDTAXA  = *blank                                            ???
578200210721     C                   clear                   W_ChgL
578300210721      *
578400210721      ** - EU tax amount in nominall currency always balnk on replication
578500210721      * If not nil format with Nominal currncy position
578600210721     C                   If        O_EUTX > 0
578700210721     C                   Move      O_EUTX        W_ChgL
578800210721     C                   If        A6NBDP = 0
578900210721     C                   Eval      A_DDEUTX  = W_ChgL
579000210721     C                   Endif
579100210721     C                   If        A6NBDP = 1
579200210721     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
579300210721     C                   Endif
579400210721     C                   If        A6NBDP = 2
579500210721     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
579600210721     C                   Endif
579700210721     C                   If        A6NBDP = 3
579800210721     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
579900210721     C                   Endif
580000210721     C                   Endif
580100210721     C                   Eval      A_DDEUTX  = *blank                                            ???
580200210721     C                   clear                   W_ChgL
580300210721      *
580400210721      ** - Brok Comm  Rebate
580500210721      * If not nil format with Nominal currency position
580600210721     C                   If        O_BCMR > 0
580700210721     C                   Move      O_BCMR        W_ChgL
580800210721     C                   If        A6NBDP = 0
580900210721     C                   Eval      A_DDBCMR  = W_ChgL
581000210721     C                   Endif
581100210721     C                   If        A6NBDP = 1
581200210721     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
581300210721     C                   Endif
581400210721     C                   If        A6NBDP = 2
581500210721     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
581600210721     C                   Endif
581700210721     C                   If        A6NBDP = 3
581800210721     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
581900210721     C                   Endif
582000210721     C                   Endif
582100210721     C                   clear                   W_ChgL
582200210721      *
582300210721      ** - Cust Comm rebate
582400210721      * If not nil format with Nominal currency position
582500210721     C                   If        O_CCMR > 0
582600210721     C                   Move      O_CCMR        W_ChgL
582700210721     C                   If        A6NBDP = 0
582800210721     C                   Eval      A_DDCCMR  = W_ChgL
582900210721     C                   Endif
583000210721     C                   If        A6NBDP = 1
583100210721     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
583200210721     C                   Endif
583300210721     C                   If        A6NBDP = 2
583400210721     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
583500210721     C                   Endif
583600210721     C                   If        A6NBDP = 3
583700210721     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
583800210721     C                   Endif
583900210721     C                   Endif
584000210721     C                   clear                   W_ChgL
584100210721      *
584200210721      ** - Tax rebate always blank on replication
584300210721      * If not nil format with Nominal currency position
584400210721     C                   If        O_TXRB > 0
584500210721     C                   Move      O_TXRB        W_ChgL
584600210721     C                   If        A6NBDP = 0
584700210721     C                   Eval      A_DDTXRB  = W_ChgL
584800210721     C                   Endif
584900210721     C                   If        A6NBDP = 1
585000210721     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
585100210721     C                   Endif
585200210721     C                   If        A6NBDP = 2
585300210721     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
585400210721     C                   Endif
585500210721     C                   If        A6NBDP = 3
585600210721     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
585700210721     C                   Endif
585800210721     C                   Endif
585900210721     C                   clear                   W_ChgL
586000210721      *
586100210721      ** - Portfolio reference Always Blank on replication
586200210721     C                   Eval      A_DDPTFR   = C3PTFR
586300210721      *  Extension file TRADSDX1  Not sure it needs to be setup
586400210721      *
586500210721      *  Settlement Message Request
586600210721     C                   Eval      A_ADDGMES  = *blank
586700210721      *
586800210721      *  Time of Trade
586900210721     C                   Eval      A_ADDTRTT  = *blank
587000210721      *
587100210721      *  Instructions Type
587200210721     C                   Eval      A_ADDINST  = C3T1INST
587300210721      *
587400210721      *   Instructions sub-type
587500210721     C                   Eval      A_ADDINSS  = C3T1INSS
587600210721      *
587700210721      *   Euroclear/Cedel code
587800210721     C                   Eval      A_ADDEUCL  = C3T1EUCL
587900210721      *
588000210721      *  Safekeeping Account (MT580)
588100210721     C                   Eval      A_ADDSAFA  = C3T1SAFA
588200210721      *
588300210721      *  Requested Priority
588400210721     C                   Eval      A_ADDRPTY  = C3T1RPTY
588500210721      *
588600210721      *  Guaranteed Delivery
588700210721     C                   Eval      A_ADDGDEL  = *blank
588800210721      *
588900210721      *  Sender's Role
589000210721     C                   Eval      A_ADDSROL  = *blank
589100210721      *
589200210721      *  Fungibilty Code
589300210721     C                   Eval      A_ADDFCOD  = *blank
589400210721      *
589500210721      *  Fungible Trade Indicator
589600210721     C                   Eval      A_ADDFTID  = *blank
589700210721      *
589800210721      *  Confirmation Message Request
589900210721     C                   Eval      A_ADDGMEC  = *blank
590000210721      *
590100210721      *  Customer/Counterparty Ind.
590200210721     C                   Eval      A_ADDCCID  = *blank
590300210721      *
590400210721      *  Further Id.
590500210721     C                   Eval      A_ADDFID1  = *blank
590600210721      *
590700210721      *  Standard Instructions' Overr  ?
590800210721     C                   Eval      A_ADDIORA  = *blank
590900210721      *
591000210721      *  ISO15022 Messages Ind.
591100210721     C                   Eval      A_ADDSNEW  = *blank
591200210721      *
591300210721      *  Stamp Status
591400210721     C                   Eval      A_ADDSTMP  = *blank
591500210721      *
591600210721      *  Charity Identifier
591700210721     C                   Eval      A_ADDCHID  = *blank
591800210721      *
591900210721      *  Transaction Report Marker
592000210721     C                   Eval      A_ADDTRRM  = *blank
592100210721      *
592200210721      * Ignore following block
592300210721     C                   Eval      A_BDDGMES  = *blank
592400210721     C                   Eval      A_BDDTRTT  = *blank
592500210721     C                   Eval      A_BDDINST   =*blank
592600210721     C                   Eval      A_BDDINSS   =*blank
592700210721     C                   Eval      A_BDDEUCL   =*blank
592800210721     C                   Eval      A_BDDSAFA   = *blank
592900210721     C                   Eval      A_BDDRPTY   = *blank
593000210721     C                   Eval      A_BDDGDEL   = *blank
593100210721     C                   Eval      A_BDDSROL   = *blank
593200210721     C                   Eval      A_BDDFCOD   = *blank
593300210721     C                   Eval      A_BDDFTID   = *blank
593400210721     C                   Eval      A_BDDGMEC   = *blank
593500210721     C                   Eval      A_BDDCCID   = *blank
593600210721     C                   Eval      A_BDDFID1   = *blank
593700210721     C                   Eval      A_BDDIORA   = *blank
593800210721     C                   Eval      A_BDDSNEW   = *blank
593900210721     C                   Eval      A_BDDSTMP   = *blank
594000210721     C                   Eval      A_BDDCHID   = *blank
594100210721     C                   Eval      A_BDDTRRM   = *blank
594200210721     C                   Eval      A_AESAP1N   = *blank
594300210721     C                   Eval      A_DDA1SN    = *blank
594400210721     C                   Eval      A_DDA1NM    = *blank
594500210721     C                   Eval      A_DDA1TN    = *blank
594600210721     C                   Eval      A_DDA1SI    = *blank
594700210721     C                   Eval      A_AESAP1L   = *blank
594800210721     C                   Eval      A_AESAP2N   = *blank
594900210721     C                   Eval      A_DDA2SN   =  *blank
595000210721     C                   Eval      A_DDA2NM   =  *blank
595100210721     C                   Eval      A_DDA2TN   =  *blank
595200210721     C                   Eval      A_DDA2SI   =  *blank
595300210721     C                   Eval      A_AESAP2L  =  *blank
595400210721     C                   Eval      A_AESAWIN  =  *blank
595500210721     C                   Eval      A_DDAISN   =  *blank
595600210721     C                   Eval      A_DDAINM   =  *blank
595700210721     C                   Eval      A_DDAITN   =  *blank
595800210721     C                   Eval      A_DDAISI   =  *blank
595900210721     C                   Eval      A_AESAWIL  =  *blank
596000210721     C                   Eval      A_AESBOFN  =  *blank
596100210721     C                   Eval      A_DDBMSN   =  *blank
596200210721     C                   Eval      A_DDBMNM   =  *blank
596300210721     C                   Eval      A_DDBMTN   =  *blank
596400210721     C                   Eval      A_DDBMSI   =  *blank
596500210721     C                   Eval      A_AESBOF1  =  *blank
596600210721     C                   Eval      A_AESBOF2  =  *blank
596700210721     C                   Eval      A_AESACL1  =  *blank
596800210721     C                   Eval      A_AESACL2  =  *blank
596900210721     C                   Eval      A_AESSRL1  =  *blank
597000210721     C                   Eval      A_AESSRL2  =  *blank
597100210721     C                   Eval      A_AESSRL3  =  *blank
597200210721     C                   Eval      A_AESFIN1  =  *blank
597300210721     C                   Eval      A_AESFIN2   = *blank
597400210721     C                   Eval      A_AESRED1   = *blank
597500210721     C                   Eval      A_AESRED2   = *blank
597600210721     C                   Eval      A_AESNAL1   = *blank
597700210721     C                   Eval      A_AESNAL2   = *blank
597800210721     C                   Eval      A_AESIPYN   = *blank
597900210721     C                   Eval      A_DDIPSN    = *blank
598000210721     C                   Eval      A_DDIPNM    = *blank
598100210721     C                   Eval      A_DDIPTN    = *blank
598200210721     C                   Eval      A_DDIPSI    = *blank
598300210721     C                   Eval      A_AESIPYL   = *blank
598400210721     C                   Eval      A_AESCTYN   = *blank
598500210721     C                   Eval      A_AESCTYL   = *blank
598600210721     C                   Eval      A_AESSA1N   = *blank
598700210721     C                   Eval      A_DDCZSN    = *blank
598800210721     C                   Eval      A_DDCSNM    = *blank
598900210721     C                   Eval      A_DDCSTN    = *blank
599000210721     C                   Eval      A_DDCSSI    = *blank
599100210721     C                   Eval      A_AESSA1L   = *blank
599200210721     C                   Eval      A_AESSKAN   = *blank
599300210721     C                   Eval      A_DDUSSN    = *blank
599400210721     C                   Eval      A_DDUSNM    = *blank
599500210721     C                   Eval      A_DDUSTN    = *blank
599600210721     C                   Eval      A_DDUSSI    = *blank
599700210721     C                   Eval      A_AESSKAL   = *blank
599800210721     C                   Eval      A_AESCCTN   = *blank
599900210721     C                   Eval      A_DDCCSN    = *blank
600000210721     C                   Eval      A_DDCCNM    = *blank
600100210721     C                   Eval      A_DDCCTN    = *blank
600200210721     C                   Eval      A_DDCCSI    = *blank
600300210721     C                   Eval      A_AESDCTL   = *blank
600400210721     C                   Eval      A_AESRSSN   = *blank
600500210721     C                   Eval      A_DDRSSN    = *blank
600600210721     C                   Eval      A_DDRSNM    = *blank
600700210721     C                   Eval      A_DDRSTN    = *blank
600800210721     C                   Eval      A_DDRSSI    = *blank
600900210721     C                   Eval      A_AESRSS1   = *blank
601000210721     C                   Eval      A_AESRSS2   = *blank
601100210721     C                   Eval      A_AESRSS3   = *blank
601200210721     C                   Eval      A_AESRSS4   = *blank
601300210721     C                   Eval      A_AESDSSN   = *blank
601400210721     C                   Eval      A_AESDSS1   = *blank
601500210721     C                   Eval      A_AESDSS2   = *blank
601600210721     C                   Eval      A_AESDSS3   = *blank
601700210721     C                   Eval      A_AESDSS4   = *blank
601800210721     C                   Eval      A_AESBSSN   = *blank
601900210721     C                   Eval      A_AESBSS1   = *blank
602000210721     C                   Eval      A_AESBSS2   = *blank
602100210721     C                   Eval      A_AESINVE   = *blank
602200210721     C                   Eval      A_DDIOSN    = *blank
602300210721     C                   Eval      A_DDIONM    = *blank
602400210721     C                   Eval      A_DDIOTN    = *blank
602500210721     C                   Eval      A_DDIOSI    = *blank
602600210721     C                   Eval      A_AESIMMD1  = *blank
602700210721     C                   Eval      A_DDI1SN    = *blank
602800210721     C                   Eval      A_DDI1NM    = *blank
602900210721     C                   Eval      A_DDI1TN    = *blank
603000210721     C                   Eval      A_DDI1SI    = *blank
603100210721     C                   Eval      A_AESIMSA1  = *blank
603200210721     C                   Eval      A_AESIMMD2  = *blank
603300210721     C                   Eval      A_DDI2SN    = *blank
603400210721     C                   Eval      A_DDI2NM    = *blank
603500210721     C                   Eval      A_DDI2TN    = *blank
603600210721     C                   Eval      A_DDI2SI    = *blank
603700210721     C                   Eval      A_AESIMSA2  = *blank
603800210721     C                   Eval      A_AESIMMD3  = *blank
603900210721     C                   Eval      A_AESIMSA3  = *blank
604000210721     C                   Eval      A_AESIMMD4  = *blank
604100210721     C                   Eval      A_AESIMSA4  = *blank
604200210721     C                   Eval      A_AESIMMD5  = *blank
604300210721     C                   Eval      A_AESIMSA5  = *blank
604400210721     C                   Eval      A_AESIMMD6  = *blank
604500210721     C                   Eval      A_AESIMSA6  = *blank
604600210721     C                   Eval      A_AESIMMD7  = *blank
604700210721     C                   Eval      A_AESIMSA7  = *blank
604800210721     C                   Eval      A_AESIMMD8  = *blank
604900210721     C                   Eval      A_AESIMSA8  = *blank
605000210721     C                   Eval      A_AESIMMD9  = *blank
605100210721     C                   Eval      A_AESIMSA9  = *blank
605200210721     C                   Eval      A_AESPSET   = *blank
605300210721     C                   Eval      A_DDPSSN    = *Blank
605400210721     C                   Eval      A_DDPSNM    = *Blank
605500210721     C                   Eval      A_DDPSTN    = *Blank
605600210721     C                   Eval      A_DDPSSI    = *Blank
605700210721     C                   Eval      A_AESNAC1   = *Blank
605800210721     C                   Eval      A_AESNAC2   = *Blank
605900210721     C                   Eval      A_AESDIDN   = *Blank
606000210721     C                   Eval      A_AESDAD1   = *Blank
606100210721     C                   Eval      A_AESDAD2   = *Blank
606200210721     C                   Eval      A_AESDAD3   = *Blank
606300210721     C                   Eval      A_AESDAD4   = *Blank
606400210721     C                   Eval      A_AESDLIN   = *Blank
606500210721     C                   Eval      A_AESQFIN   = *Blank
606600210721     C                   Eval      A_AESPCLR   = *Blank
606700210721     C                   Eval      A_BESAP1N   = *Blank
606800210721     C                   Eval      A_BDA1SN    = *Blank
606900210721     C                   Eval      A_BDA1NM   =  *Blank
607000210721     C                   Eval      A_BDA1TN   =  *Blank
607100210721     C                   Eval      A_BDA1SI   =  *Blank
607200210721     C                   Eval      A_BESAP1L  =  *Blank
607300210721     C                   Eval      A_BESAP2N  =  *Blank
607400210721     C                   Eval      A_BDA2SN   =  *Blank
607500210721     C                   Eval      A_BDA2NM   =  *blank
607600210721     C                   Eval      A_BDA2TN   =  *blank
607700210721     C                   Eval      A_BDA2SI   =  *blank
607800210721     C                   Eval      A_BESAP2L  =  *blank
607900210721     C                   Eval      A_BESAWIN  =  *blank
608000210721     C                   Eval      A_BDAISN   =  *blank
608100210721     C                   Eval      A_BDAINM   =  *blank
608200210721     C                   Eval      A_BDAITN   =  *blank
608300210721     C                   Eval      A_BDAISI   =  *blank
608400210721     C                   Eval      A_BESAWIL  =  *blank
608500210721     C                   Eval      A_BESBOFN  =  *blank
608600210721     C                   Eval      A_BDBMSN   =  *blank
608700210721     C                   Eval      A_BDBMNM   =  *blank
608800210721     C                   Eval      A_BDBMTN   =  *blank
608900210721     C                   Eval      A_BDBMSI   =  *blank
609000210721     C                   Eval      A_BESBOF1  =  *blank
609100210721     C                   Eval      A_BESBOF2  =  *blank
609200210721     C                   Eval      A_BESACL1  =  *blank
609300210721     C                   Eval      A_BESACL2   = *blank
609400210721     C                   Eval      A_BESSRL1   = *blank
609500210721     C                   Eval      A_BESSRL2   = *blank
609600210721     C                   Eval      A_BESSRL3   = *blank
609700210721     C                   Eval      A_BESFIN1   = *blank
609800210721     C                   Eval      A_BESFIN2   = *blank
609900210721     C                   Eval      A_BESRED1   = *blank
610000210721     C                   Eval      A_BESRED2   = *blank
610100210721     C                   Eval      A_BESNAL1   = *blank
610200210721     C                   Eval      A_BESNAL2   = *blank
610300210721     C                   Eval      A_BESIPYN   = *blank
610400210721     C                   Eval      A_BDIPSN    = *blank
610500210721     C                   Eval      A_BDIPNM    = *blank
610600210721     C                   Eval      A_BDIPTN    = *blank
610700210721     C                   Eval      A_BDIPSI    = *blank
610800210721     C                   Eval      A_BESIPYL   = *blank
610900210721     C                   Eval      A_BESCTYN   = *blank
611000210721     C                   Eval      A_BESCTYL   = *blank
611100210721     C                   Eval      A_BESSA1N   = *blank
611200210721     C                   Eval      A_BDCZSN    = *blank
611300210721     C                   Eval      A_BDCSNM    = *blank
611400210721     C                   Eval      A_BDCSTN    = *blank
611500210721     C                   Eval      A_BDCSSI    = *blank
611600210721     C                   Eval      A_BESSA1L   = *blank
611700210721     C                   Eval      A_BESSKAN   = *blank
611800210721     C                   Eval      A_BDUSSN    = *blank
611900210721     C                   Eval      A_BDUSNM    = *blank
612000210721     C                   Eval      A_BDUSTN    = *blank
612100210721     C                   Eval      A_BDUSSI    = *blank
612200210721     C                   Eval      A_BESSKAL   = *blank
612300210721     C                   Eval      A_BESCCTN   = *blank
612400210721     C                   Eval      A_BDCCSN    = *blank
612500210721     C                   Eval      A_BDCCNM    = *blank
612600210721     C                   Eval      A_BDCCTN    = *blank
612700210721     C                   Eval      A_BDCCSI    = *blank
612800210721     C                   Eval      A_BESDCTL   = *blank
612900210721     C                   Eval      A_BESRSSN   = *blank
613000210721     C                   Eval      A_BDRSSN    = *blank
613100210721     C                   Eval      A_BDRSNM    = *blank
613200210721     C                   Eval      A_BDRSTN    = *blank
613300210721     C                   Eval      A_BDRSSI    = *blank
613400210721     C                   Eval      A_BESRSS1   = *blank
613500210721     C                   Eval      A_BESRSS2   = *blank
613600210721     C                   Eval      A_BESRSS3   = *blank
613700210721     C                   Eval      A_BESRSS4   = *blank
613800210721     C                   Eval      A_BESDSSN   = *blank
613900210721     C                   Eval      A_BESDSS1   = *blank
614000210721     C                   Eval      A_BESDSS2   = *blank
614100210721     C                   Eval      A_BESDSS3   = *blank
614200210721     C                   Eval      A_BESDSS4   = *blank
614300210721     C                   Eval      A_BESBSSN   = *blank
614400210721     C                   Eval      A_BESBSS1   = *blank
614500210721     C                   Eval      A_BESBSS2   = *blank
614600210721     C                   Eval      A_BESINVE   = *blank
614700210721     C                   Eval      A_BDIOSN    = *blank
614800210721     C                   Eval      A_BDIONM    = *blank
614900210721     C                   Eval      A_BDIOTN    = *blank
615000210721     C                   Eval      A_BDIOSI    = *blank
615100210721     C                   Eval      A_BESIMMD1  = *blank
615200210721     C                   Eval      A_BDI1SN    = *blank
615300210721     C                   Eval      A_BDI1NM    = *blank
615400210721     C                   Eval      A_BDI1TN    = *blank
615500210721     C                   Eval      A_BDI1SI    = *blank
615600210721     C                   Eval      A_BESIMSA1  = *blank
615700210721     C                   Eval      A_BESIMMD2  = *blank
615800210721     C                   Eval      A_BDI2SN    = *blank
615900210721     C                   Eval      A_BDI2NM    = *blank
616000210721     C                   Eval      A_BDI2TN    = *blank
616100210721     C                   Eval      A_BDI2SI    = *blank
616200210721     C                   Eval      A_BESIMSA2  = *blank
616300210721     C                   Eval      A_BESIMMD3  = *blank
616400210721     C                   Eval      A_BESIMSA3  = *blank
616500210721     C                   Eval      A_BESIMMD4   =*blank
616600210721     C                   Eval      A_BESIMSA4   =*blank
616700210721     C                   Eval      A_BESIMMD5   =*blank
616800210721     C                   Eval      A_BESIMSA5   =*blank
616900210721     C                   Eval      A_BESIMMD6   =*blank
617000210721     C                   Eval      A_BESIMSA6   =*blank
617100210721     C                   Eval      A_BESIMMD7   = *blank
617200210721     C                   Eval      A_BESIMSA7   = *blank
617300210721     C                   Eval      A_BESIMMD8   = *blank
617400210721     C                   Eval      A_BESIMSA8   = *blank
617500210721     C                   Eval      A_BESIMMD9   = *blank
617600210721     C                   Eval      A_BESIMSA9   = *blank
617700210721     C                   Eval      A_BESPSET    = *blank
617800210721     C                   Eval      A_BDPSSN     = *blank
617900210721     C                   Eval      A_BDPSNM     = *blank
618000210721     C                   Eval      A_BDPSTN     = *blank
618100210721     C                   Eval      A_BDPSSI     = *blank
618200210721     C                   Eval      A_BESNAC1    = *blank
618300210721     C                   Eval      A_BESNAC2    = *blank
618400210721     C                   Eval      A_BESDIDN    = *blank
618500210721     C                   Eval      A_BESDAD1    = *blank
618600210721     C                   Eval      A_BESDAD2    = *blank
618700210721     C                   Eval      A_BESDAD3    = *blank
618800210721     C                   Eval      A_BESDAD4    = *blank
618900210721     C                   Eval      A_BESDLIN   =  *blank
619000210721     C                   Eval      A_BESQFIN   =  *blank
619100210721     C                   Eval      A_BESPCLR   =  *blank
619200210721     C                   Eval      A_DDCRSK    =  *blank
619300210721     C                   Eval      A_DDLQPR    =  *blank
619400210721     C                   Eval      A_DDITRN    = *blank
619500210721     C                   Eval      A_TMSP      = *blank
619600210721     C                   Eval      A_BDSPBS    = *blank
619700210721     C                   Eval      A_STBS      = *blank
619800210721     C                   Eval      A_PROT      = *blank
619900210721     C                   Eval      A_NMCY      = *blank
620000210721     C                   Eval      A_C1DI      = *blank
620100210721     C                   Eval      A_BVAUTH    = *blank
620200210721     C                   Eval      A_DDCPNR    = *blank
620300210721     C                   Eval      A_DDTCTR    = *blank
620400210721     C                   Eval      A_DDCFCT    = *blank
620500210721     C                   Eval      A_ADDROUS   = *blank
620600210721     C                   Eval      A_ADDROTS   = *blank
620700210721     C                   Eval      A_ADDROUC   = *blank
620800210721     C                   Eval      A_ADDROTC   = *blank
620900210721     C                   Eval      A_BDDROUS   = *blank
621000210721     C                   Eval      A_BDDROTS   = *blank
621100210721     C                   Eval      A_BDDROUC   = *blank
621200210721     C                   Eval      A_BDDROTC   = *blank
621300210721     C                   Eval      A_DDSPXR   =  *blank
621400210721     C                   Eval      A_DDSPMD   =  *blank
621500210721     C                   Eval      A_DDWTAX   =  *blank
621600210721     C                   Eval      A_BKEURO   =  *blank
621700210721     C                   Eval      A_DDSTAT   =  *blank
621800210721     C                   Eval      A_DDAUTH   =  FNAUTH
621900210721     C                   Eval      A_SITP     =  *blank
622000210721     C                   Eval      A_DDPRICN  =  *blank
622100210721     C                   Eval      A_DDHACR   =  *blank
622200210721     C                   Eval      A_DDTCSR   =  *blank
622300210721     C                   Eval      A_DDDAYS   =  *blank
622400210721     C                   Eval      A_DDFOID   =  *blank
622500210721     C                   Eval      A_TQTAX    =  *blank
622600210721     C                   Eval      A_TQSTAF   =  *blank
622700210721     C                   Eval      A_TQCDTE   =  *blank
622800210721     C                   Eval      A_AUTH     =  FNAUTH
622900210721     C                   Eval      A_TOFfil   =  *Blank
623000210721     C                   Endsr
623100210721      /Eject
623200210721      *****************************************************************
623300210721     C     APDataD       Begsr
623400210721     C                   Clear                   ApDtmsg
623500210721     C                   Eval      A_DDACTN  = 'D'
623600210721     C                   Eval      A_DDTDRF  = C_TDRF
623700210721     C                   Eval      A_DDBLKR  = C_BLKR
623800210721     C                   Eval      A_DDSESN  = C_TDSS
623900210721     C                   Eval      A_DDCNUM  = C_TCNR
624000210721     C                   Eval      A_DDCSSN  = C_TDSS
624100210721     C                   Eval      A_DDCRNM  = *Blank
624200210721     C                   Eval      A_DDCRTN  = *Blank
624300210721     C                   Eval      A_DDINCS  = C_TINC
624400210721     C                   Eval      A_DDTDTP  = C_TDTP
624500210721     C                   Eval      A_AUTH     =  FNAUTH
624600210721     C                   Endsr
624700210721      /Eject
624800210721      *****************************************************************
624900210721     C     APDataD2      Begsr
625000210721     C                   Clear                   ApDtmsg
625100210721     C                   Eval      A_DDACTN  = 'D'
625200210721     C                   Eval      A_DDTDRF  = C2TDRF
625300210721     C                   Eval      A_DDBLKR  = C2BLKR
625400210721     C                   Eval      A_DDSESN  = C2TDSS
625500210721     C                   Eval      A_DDCNUM  = C2TCNR
625600210721     C                   Eval      A_DDCSSN  = C2TDSS
625700210721     C                   Eval      A_DDCRNM  = *Blank
625800210721     C                   Eval      A_DDCRTN  = *Blank
625900210721     C                   Eval      A_DDINCS  = C2TINC
626000210721     C                   Eval      A_DDTDTP  = C2TDTP
626100210721     C                   Eval      A_AUTH     =  FNAUTH
626200210721     C                   Endsr
626300210721      /Eject
626400210721      *****************************************************************
626500210721     C     APDataD3      Begsr
626600210721     C                   Clear                   ApDtmsg
626700210721     C                   Eval      A_DDACTN  = 'D'
626800210721     C                   Eval      A_DDTDRF  = C3TDRF
626900210721     C                   Eval      A_DDBLKR  = C3BLKR
627000210721     C                   Eval      A_DDSESN  = C3TDSS
627100210721     C                   Eval      A_DDCNUM  = C3TCNR
627200210721     C                   Eval      A_DDCSSN  = C3TDSS
627300210721     C                   Eval      A_DDCRNM  = *Blank
627400210721     C                   Eval      A_DDCRTN  = *Blank
627500210721     C                   Eval      A_DDINCS  = C3TINC
627600210721     C                   Eval      A_DDTDTP  = C3TDTP
627700210721     C                   Eval      A_AUTH     =  FNAUTH
627800210721     C                   Endsr
627900210721      /Eject
628000210721      *****************************************************************
628100210721     C     FNDataD       Begsr
628200210721      *
628300210721     C                   Eval      FNsetup = ' '
628400210721      * ELement 1 for key 'UDFTRAD07'
628500210721      * ELement 2 for key 'UDFTRAD12'
628600210721      * ELement 3 for key 'UDFTRAD15'
628700210721     C                   OPEN      A1CONBL2
628800210721     C     FNudfE1       CHAIN     A1CONBPF                           99
628900210721     C     *IN99         IFEQ      *OFF
629000210721     C                   Eval      FNbrcaA(1) = FNBRCA
629100210721     C                   Eval      FNfoirA(1) = FNFOIR
629200210721     C                   Eval      FNsetup = 'Y'
629300210721     C                   END
629400210721     C     FNudfE2       CHAIN     A1CONBPF                           99
629500210721     C     *IN99         IFEQ      *OFF
629600210721     C                   Eval      FNbrcaA(2) = FNBRCA
629700210721     C                   Eval      FNfoirA(2) = FNFOIR
629800210721     C                   Eval      FNsetup = 'Y'
629900210721     C                   END
630000210721     C     FNudfE3       CHAIN     A1CONBPF                           99
630100210721     C     *IN99         IFEQ      *OFF
630200210721     C                   Eval      FNbrcaA(3) = FNBRCA
630300210721     C                   Eval      FNfoirA(3) = FNFOIR
630400210721     C                   Eval      FNsetup = 'Y'
630500210721     C                   END
630600210721     C                   CLOSE     A1CONBL2
630700210721     C                   Endsr
630800210721      /Eject
630900210721      *****************************************************************
631000210721      ** Exit program: Direct
631100210721      *****************************************************************
631200210721     C     ZYEXPG        Begsr
631300210721
631400210721      ** Exit program
631500210721     C                   SETON                                        LR
631600210721     C                   RETURN
631700210721      *
631800210721     C                   Endsr
631900210721      *****************************************************************
632000210721
632100210721**  CPY@
632200210721(c) Finastra International Limited 2021
