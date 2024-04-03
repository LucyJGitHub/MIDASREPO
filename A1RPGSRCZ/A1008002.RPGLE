     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FN Extract TRADSD for consolidated branch')      *
      *****************************************************************
      *                                                               *
      *  Midas - Private Banking Module                               *
      *                                                               *
      *  A1008002 - Extract module for TRADSD Consolidated branch     *
      *                                                               *
      *  Function:    This module Calls the transaction for           *
      *               Consolidated Branch                             *
      *         - It need to retrieve the TRADE Entry queue for Midas *
      *         - The UDF field for decisions                         *
      *         - the Market customer and the Consolidated branch     *
      *         - Settlement qre Blank but Auto settled always Yes    *
      *         - Auto authorise is As per setup                      *
      *                                                               *
      *  Component of: A1008002 Extract program for TRADSD            *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. MD062029           Date 20Mar24               *
      *  Prev Amend No. MD058656           Date 23Aug21               *
      *                 BA1008   *CREATE   Date 03Jun21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD062029 - Trades replication does not work since password   *
      *             change to 12 charaters.                           *
      *             Alter password field length to accept 128-char    *
      *             passwords.                                        *
      *  MD058656 - Compilation Issue                                 *
      *           - Add REPBASE in *LIBL during compilation           *
      *  BA1008 - Replication of Trades to consolidated Branches      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Standard Settlement
      *
     FSTDSED    IF   E           K DISK    USROPN  Prefix(S_)
      *
      ** Midas API ICD
      *
     FSDAPIPD   IF   E             Disk    USROPN
      *
      ** Midas Trade details
      *
     FTRADS     IF   E           K Disk    USROPN
     FTRADSDY1  IF   E           K Disk    USROPN
      *
      ** Midas SD API Customer Private Banking Details file.
      *
     FSDPBDSL0  IF   E           K Disk
     F                                     Infsr(*Pssr)
      *
      ** SE Trade Authorisation
      *
     FTRAUT     IF   E           K DISK
     F                                     Infsr(*Pssr)
      *
      ** Midas GL Accounts Master
      *
     FACCNT     IF   E           K Disk    Ignore(ACCNTAAF:ACCNTACF) Prefix(A_)
     F                                     Infsr(*Pssr)
      *
      ** Midas FN Consolidated Branches
      *
     FA1CONBL2  IF   E           K Disk    USROPN
     F                                     Infsr(*Pssr)
      *
      /Eject
      *****************************************************************
      *                                                               *
      *          F U N C T I O N   O F   I N D I C A T O R S          *
      *          -------------------------------------------          *
      *  55  -  Work Indicator used in array FNbrcaA                  *
      *  81  -  CHAIN access to SDPBDSL0/ACCNT failed.                *
      *  82  -  Begin of file TRAUT after ReadPe.                     *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *                  *************************                    *
      *                  ** INDICATORS NOT USED **                    *
      *                  *************************                    *
      *                                                               *
      *       ***************************************************     *
      *       * 01   02   03   04   05   06   07   08   09   10 *     *
      *       * 11   12   13   14   15   16   17   18   19   20 *     *
      *       * 21   22   23   24   25   26   27   28   29   30 *     *
      *       * 31   32   33   34   35   36   37   38   39   40 *     *
      *       * 41   42   43   44   45   46   47   48   49   50 *     *
      *       * 51   52   53   54   XX   56   57   58   59   60 *     *
      *       * 61   62   63   64   65   66   67   68   69   70 *     *
      *       * 71   72   73   74   75   76   77   78   79   80 *     *
      *       * xx   xx   83   84   85   86   87   88   89   90 *     *
      *       * 91   92   93   94   95   96   97   98   99      *     *
      *       ***************************************************     *
      *                                                               *
      *****************************************************************
      /Space 3
      *****************************************************************
      *                                                               *
      *                S U B R O U T I N E   I N D E X                *
      *                -------------------------------                *
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *  Repair   - Repair process                                    *
      *  APDataI  - Prepare Insert message                            *
      *  APHeader = Prepare header message
      *  APDataD  - Prepare Delete message                            *
      *  APDataA  - Prepare Amend  message                            *
      *  APDataD2 - Prepare Delete message for conso Branch 2         *
      *  APDataA2 - Prepare Amend  message for conso Branch 2         *
      *  APDataD3 - Prepare Delete message for conso Branch 3         *
      *  APDataA3 - Prepare Amend  message for conso Branch 3         *
      *  *Pssr    - Program exception error routine                   *
      *  *Inzsr   - Program Initialization routine.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
     D W_Currency      S              3
     D Traderef        S              6
     D TradeRTN        S              6
     D TradeFOI        S             20
     D TradeOri        S              6
     D ReturnCodex     S              7
     D RtnCons         S              1
     D RtnBook         S              2
     D WrSUBS          S            100
     D i               S              3S 0
     D Pos             S              2S 0
      *
     D WrkBook         S              2
     D RtnCons2        S              1
     D RtnBook2        S              2
     D RtnCons3        S              1
     D RtnBook3        S              2
     D TradeRTN2       S              6
     D ReturnCodex2    S              7
     D TradeRTN3       S              6
     D ReturnCodex3    S              7
     D TradeFOI2       S             20
     D TradeFOI3       S             20
      *
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------

      ** The following /COPY contains various standard declares
     C/COPY RPCPYSRC,STD_DCL

      ** The following /COPY contains the layout of the Meridian header as
      ** a data structure
     C/COPY RPCPYSRC,MDN_HD_DS

      ** Following /COPY is the declares for fields passed to the formatting
      ** routines
     C/COPY RPCPYSRC,RPFMTDCL

      ** Following /COPY is the procedure prototype for the Packed routine
     C/COPY RPCPYSRC,RPFMTPPP

      ** Following /COPY is the procedure prototype for the Signed routine
     C/COPY RPCPYSRC,RPFMTPPS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************
      /Eject
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      *
      ** Array containing Copyright statement.
      *
     D Cpy@            S             80    Dim(1) Ctdata Perrcd(1)

      *
      ** Midas Local Data Area for database error reporting; based on
      ** external file
      *
     D Lda           E DS           256    Extname(LDA) DTAARA(LDA)
      *
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
      *
      ** Arrays used to store Position and Length of each fields
      *
     D ArrFld          S              6    Dim(100)
     D ArrPos          S              7  0 Dim(100)
     D ArrLen          S              4  0 Dim(100)

     D Z               S              1S 0
     D FNsetup         S              1A
     D FNudfE1         S              9A   INZ('UDFTRAD07')
     D FNudfE2         S              9A   INZ('UDFTRAD12')
     D FNudfE3         S              9A   INZ('UDFTRAD15')
      *
      ** Setup Array to store details of the 3 consolidated branches
      *
     D FNbrcaA         S              3A   DIM(3) INZ(*Blanks)
     D FNfoirA         S             14A   DIM(3) INZ(*Blanks)
      *
      ** Replication Defaults Data Area; based on external file.
      *
     D RPDftsDa      E DS           256    Extname(RPDFTSDA) DTAARA(RPDFTSDA)
      *
      ** API DUMP Information Data Area for database error reporting;
      ** based on external file
      *
     D Apdump        E DS                  Extname(APDUMP) DTAARA(APDUMP)
      *
      ** Data structure used to group settlement account details.
      *
     D W_NOML          DS            11
     D   W_N1                  1      1
     D   W_N2                  2      2
     D   W_N3                  3      3
     D   W_N4                  4      4
     D   W_N5                  5      5
     D   W_N6                  6      6
     D   W_N7                  7      7
     D   W_N8                  8      8
     D   W_N9                  9      9
     D   W_N10                10     10
     D   W_N11                11     11
     D   W_NOML0               1     11
     D   W_NOML1               1     10
     D   W_NOML2               1      9
     D   W_NOML3               1      8
     D   W_NOML4               1      7
     D   W_NDec1              11     11
     D   W_NDec2              10     11
     D   W_NDec3               9     11
     D   W_NDec4               8     11
      *
     D W_ChgL          DS            13
     D   W_ChgL0               1     13
     D   W_ChgL1               1     12
     D   W_ChgL2               1     11
     D   W_ChgL3               1     10
     D   W_CDec1              13     13
     D   W_CDec2              12     13
     D   W_CDec3              11     13
      *
     D W_1508          DS            15
     D   W_I1                  1      1
     D   W_I2                  2      2
     D   W_I3                  3      3
     D   W_I4                  4      4
     D   W_I5                  5      5
     D   W_I6                  6      6
     D   W_1308                3     15
     D   W_Int05               3      7
     D   W_Int07               1      7
     D   W_Dec08               8     15
      *
     D W_0905          DS             9
     D   W_RALLI               1      4
     D   W_RALLD               5      9
     D SettldO       E DS                  Extname(STDSED)  Prefix(S_)
      *
      ** Data Structure for Original trade details
      *
     D TradsdO       E DS                  Extname(TRADSD) Prefix(O_)
     D TradsdC       E DS                  Extname(TRADSD) Prefix(C_)
     D Tradsd        E DS                  Extname(TRADSD)
     D TradsdxO      E DS                  Extname(TRADSDX1) Prefix(O_)
     D TradsdxC      E DS                  Extname(TRADSDX1) Prefix(C_)
     D Tradsdx       E DS                  Extname(TRADSDX1)
      *
     D TradsdC2      E DS                  Extname(TRADSD) Prefix(C2)
     D TradsdxC2     E DS                  Extname(TRADSDX1) Prefix(C2)
     D TradsdC3      E DS                  Extname(TRADSD) Prefix(C3)
     D TradsdxC3     E DS                  Extname(TRADSDX1) Prefix(C3)
      *
      ** Data Structure for access to Customer Details.
      *
     D Sdsecs        E DS                  Extname(SDSECSPD)
      *
      ** Data Structure for access to Currency Details.
      *
     D Sdcurr        E DS                  Extname(SDCURRPD)
      *
      ** Data Structure for access to Securities I.C.D. details
      *
     D Sdstrd        E DS                  Extname(SDSTRDPD)
      *
      ** Data Structure for access to Private Banking I.C.D. details
      *
     D Sdtofd        E DS                  Extname(SDTOFPD)
      *
      ** Data Structure for access to switchable features
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D LCDSC         E                     EXTFLD(LCD)
      *
      ** First Data Structure for Access Programs, short Data Structure
      *
     D Dsfdy         E DS                  Extname(DSFDY)
      *
      ** Second Data Structure foR Access Programs, long Data Structure
      *
     D Dssdy         E DS                  Extname(DSSDY)

     D Dsldy         E DS                  Extname(DSLDY)
      *
      ** DS for Access Programs, Extend Data Structure
      *

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      *
      **-------------------- Start of Parameters --------------------**
      *
      ** Output queue name.
      *
     D OutQueue        S                   LIKE(MQSQueue)
     D OutQueueB       S                   LIKE(MQSQueue)
      *
      **--------------------- End of Parameters ---------------------**
      *
      *
      **-------------- Start of Parameters for RPC1305 --------------**
      ** Script Name.
      *
     D ScriptName      S             10A
      ** Image Name.
     D ImageName       S             32A
      ** Field Name.
     D FieldName       S             10A
      ** Field Type.
     D FieldType       S              1A
      ** Field Value.
     D FieldValue      S           9999A
      ** Field Position.
     D FieldPosition   S              7S 0
      ** Field Length
     D FieldLength     S              4S 0
      **--------------- End of Parameters for RPC1305 ---------------**
      *
      **---------------- start of Parameters for CPB010 -------------**
      *
     D MessageInd      S              1A

     D RAMSGOLD        S                   LIKE(RAMSGTYPE)
      *
      ** Database Error Messsage Text
      *
     D DBErrText       S            256A
      *
      ** Transaction Data of associated transaction
      *
     D AssocData       S                   LIKE(TransData)
     D AssocDataB      S                   LIKE(TransData)
     D TransDataB      S                   LIKE(TransData)
     D AssocDataB2     S                   LIKE(TransData)
     D AssocDataB3     S                   LIKE(TransData)
      *
      ** Meridian header Layout of associated transaction
      *
     D MdHdAssoc       S                   LIKE(MdnHeadDs)
     D MdHdAssocB      S                   LIKE(MdnHeadDs)
     D MdnHeadDsB      S                   LIKE(MdnHeadDs)
     D CommitCtlB      S                   LIKE(CommitCtl)
     D MdHdAssocB2     S                   LIKE(MdnHeadDs)
     D MdHdAssocB3     S                   LIKE(MdnHeadDs)
     D*ApHdmsg**       DS           200                                                     MD062029
     D ApHdmsg         DS           318                                                     MD062029
     D   ApMSGT                1     32
     D   ApSRCS               33     40
     D   ApORIG               41     72
     D   ApTGTS               73     80
     D   ApUSER               81     90
     D***ApPASS*              91    100                                                     MD062029
     D***ApFORM*             101    108                                                     MD062029
     D***ApVERS*             109    116                                                     MD062029
     D***ApRPYQ*             117    136                                                     MD062029
     D***ApRESP*             137    137                                                     MD062029
     D***ApMAPL*             138    138                                                     MD062029
     D***ApFRNT*             139    158                                                     MD062029
     D***ApASOC*             159    178                                                     MD062029
     D***ApRESPN             179    179                                                     MD062029
     D***ApMAPLB             180    180                                                     MD062029
     D***APFIL**             181    200                                                     MD062029
     D   ApPASS               91    218                                                     MD062029
     D   ApFORM              219    226                                                     MD062029
     D   ApVERS              227    234                                                     MD062029
     D   ApRPYQ              235    254                                                     MD062029
     D   ApRESP              255    255                                                     MD062029
     D   ApMAPL              256    256                                                     MD062029
     D   ApFRNT              257    276                                                     MD062029
     D   ApASOC              277    296                                                     MD062029
     D   ApRESPN             297    297                                                     MD062029
     D   ApMAPLB             298    298                                                     MD062029
     D   APFIL               299    318                                                     MD062029
     D ApDtmsg         DS          8000
     D   A_DDACTN              1      1
     D   A_DDTDRF              2      7
     D   A_DDBLKR              8     13
     D   A_DDSESN             14     23
     D   A_DDCNUM             24     33
     D   A_DDCSSN             34     43
     D   A_DDCRNM             44     63
     D   A_DDCRTN             64     73
     D   A_DDINCS             74     74
     D   A_DDTDTP             75     76
     D   A_DDNOML             77     88
     D   A_DDTPDY             89    104
     D   A_DDTDVD            105    111
     D   A_DDBRCD            112    114
     D   A_DDBPBK            115    116
     D   A_DDCLTY            117    117
     D   A_DDSETC            118    120
     D   A_DDRALL            121    131
     D   A_DDMRKT            132    133
     D   A_DDCPCY            134    134
     D   A_DDPRIC            135    151
     D   A_DDEXDV            152    152
     D   A_DDFSPR            153    168
     D   A_DDBPRC            169    172
     D   A_DDTPRC            173    176
     D   A_DDTDID            177    179
     D   A_DDTDDT            180    186
     D   A_DDTSUB            187    188
     D   A_DDLKRF            189    194
     D   A_DDTDMI            195    195
     D   A_DDAIIP            196    196
     D   A_DDTDNR            197    231
     D   A_DDORDE            232    237
     D   A_DDACIN            238    238
     D   A_DDDADJ            239    243
     D   A_DDACTD            244    244
     D   A_DDITRA            245    259
     D   A_DDINOR            260    265
     D   A_DDMSGK            266    305
     D   A_DDNTMT            306    312
     D   A_DDNOM1            313    324
     D   A_DDTDV1            325    331
     D   A_DDACI1            332    332
     D   A_DDDAD1            333    337
     D   A_DDACT1            338    338
     D   A_DDITR1            339    353
     D   A_DDTDER            354    368
     D   A_DDSMDI            369    369
     D   A_DDFXMP            370    377
     D   A_DDBRTE            378    392
     D   A_DDSMTH            393    394
     D   A_DDORBR            395    397
     D   A_DDPYFM            398    415
     D   A_DDPFSN            416    425
     D   A_DDPFNM            426    445
     D   A_DDPFTN            446    455
     D   A_DDPFAN            456    475
     D   A_DDPFSW            476    487
     D   A_DDPYFB            488    490
     D   A_DDPAYT            491    508
     D   A_DDPTSN            509    518
     D   A_DDPTNM            519    538
     D   A_DDPTTN            539    548
     D   A_DDPTAN            549    568
     D   A_DDPTSI            569    580
     D   A_DDPYTB            581    583
     D   A_DDTDFA            584    593
     D   A_DDFASN            594    603
     D   A_DDFANM            604    623
     D   A_DDFATN            624    633
     D   A_DDFASW            634    645
     D   A_DDASNM            646    647
     D   A_DDDELF            648    657
     D   A_DDDFSN            658    667
     D   A_DDDFNM            668    687
     D   A_DDDFTN            688    697
     D   A_DDDFSI            698    709
     D   A_DDDELT            710    719
     D   A_DDDTSN            720    729
     D   A_DDDTNM            730    749
     D   A_DDDTTN            750    759
     D   A_DDDTSI            760    771
     D   A_DDDFFA            772    781
     D   A_DDD1SN            782    791
     D   A_DDD1NM            792    811
     D   A_DDD1TN            812    821
     D   A_DDD1SI            822    833
     D   A_DDDTFA            834    843
     D   A_DDD2SN            844    853
     D   A_DDD2NM            854    873
     D   A_DDD2TN            874    883
     D   A_DDD2SI            884    895
     D   A_DDTDSI            896    928
     D   A_DDCLTY2           929    929
     D   A_DDICCY            930    932
     D   A_DDPRFC            933    936
     D   A_DDPRYC            937    937
     D   A_DDPCOD            938    938
     D   A_DDAUTS            939    939
     D   A_DDTBCC            940    941
     D   A_DDTBCA            942    955
     D   A_DDTCCC            956    957
     D   A_DDTCCA            958    971
     D   A_DDTCC1            972    973
     D   A_DDTCA1            974    987
     D   A_DDTCC2            988    989
     D   A_DDTCA2            990   1003
     D   A_DDTCC3           1004   1005
     D   A_DDTCA3           1006   1019
     D   A_DDTCC4           1020   1021
     D   A_DDTCA4           1022   1035
     D   A_DDTCC5           1036   1037
     D   A_DDTCA5           1038   1051
     D   A_DDTCC6           1052   1053
     D   A_DDTCA6           1054   1067
     D   A_DDTCC7           1068   1069
     D   A_DDTCA7           1070   1083
     d   A_DDTAXA           1084   1097
     D   A_DDEUTX           1098   1113
     D   A_DDBCMR           1114   1127
     D   A_DDCCMR           1128   1141
     D   A_DDTXRB           1142   1155
     D   A_DDPTFR           1156   1159
     D   A_ADDGMES          1160   1160
     D   A_ADDTRTT          1161   1164
     D   A_ADDINST          1165   1167
     D   A_ADDINSS          1168   1172
     D   A_ADDEUCL          1173   1182
     D   A_ADDSAFA          1183   1188
     D   A_ADDRPTY          1189   1189
     D   A_ADDGDEL          1190   1190
     D   A_ADDSROL          1191   1194
     D   A_ADDFCOD          1195   1195
     D   A_ADDFTID          1196   1196
     D   A_ADDGMEC          1197   1197
     D   A_ADDCCID          1198   1198
     D   A_ADDFID1          1199   1206
     D   A_ADDIORA          1207   1207
     D   A_ADDSNEW          1208   1208
     D   A_ADDSTMP          1209   1212
     D   A_ADDCHID          1213   1242
     D   A_ADDTRRM          1243   1246
     D   A_BDDGMES          1247   1247
     D   A_BDDTRTT          1248   1251
     D   A_BDDINST          1252   1254
     D   A_BDDINSS          1255   1259
     D   A_BDDEUCL          1260   1269
     D   A_BDDSAFA          1270   1275
     D   A_BDDRPTY          1276   1276
     D   A_BDDGDEL          1277   1277
     D   A_BDDSROL          1278   1281
     D   A_BDDFCOD          1282   1282
     D   A_BDDFTID          1283   1283
     D   A_BDDGMEC          1284   1284
     D   A_BDDCCID          1285   1285
     D   A_BDDFID1          1286   1293
     D   A_BDDIORA          1294   1294
     D   A_BDDSNEW          1295   1295
     D   A_BDDSTMP          1296   1299
     D   A_BDDCHID          1300   1329
     D   A_BDDTRRM          1330   1333
     D   A_AESAP1N          1334   1343
     D   A_DDA1SN           1344   1353
     D   A_DDA1NM           1354   1373
     D   A_DDA1TN           1374   1383
     D   A_DDA1SI           1384   1395
     D   A_AESAP1L          1396   1430
     D   A_AESAP2N          1431   1440
     D   A_DDA2SN           1441   1450
     D   A_DDA2NM           1451   1470
     D   A_DDA2TN           1471   1480
     D   A_DDA2SI           1481   1492
     D   A_AESAP2L          1493   1527
     D   A_AESAWIN          1528   1537
     D   A_DDAISN           1538   1547
     D   A_DDAINM           1548   1567
     D   A_DDAITN           1568   1577
     D   A_DDAISI           1578   1589
     D   A_AESAWIL          1590   1624
     D   A_AESBOFN          1625   1634
     D   A_DDBMSN           1635   1644
     D   A_DDBMNM           1645   1664
     D   A_DDBMTN           1665   1674
     D   A_DDBMSI           1675   1686
     D   A_AESBOF1          1687   1721
     D   A_AESBOF2          1722   1756
     D   A_AESACL1          1757   1791
     D   A_AESACL2          1792   1826
     D   A_AESSRL1          1827   1861
     D   A_AESSRL2          1862   1896
     D   A_AESSRL3          1897   1931
     D   A_AESFIN1          1932   1966
     D   A_AESFIN2          1967   2001
     D   A_AESRED1          2002   2036
     D   A_AESRED2          2037   2071
     D   A_AESNAL1          2072   2106
     D   A_AESNAL2          2107   2141
     D   A_AESIPYN          2142   2151
     D   A_DDIPSN           2152   2161
     D   A_DDIPNM           2162   2181
     D   A_DDIPTN           2182   2191
     D   A_DDIPSI           2192   2203
     D   A_AESIPYL          2204   2238
     D   A_AESCTYN          2239   2248
     D   A_AESCTYL          2249   2283
     D   A_AESSA1N          2284   2293
     D   A_DDCZSN           2294   2303
     D   A_DDCSNM           2304   2323
     D   A_DDCSTN           2324   2333
     D   A_DDCSSI           2334   2345
     D   A_AESSA1L          2346   2380
     D   A_AESSKAN          2381   2390
     D   A_DDUSSN           2391   2400
     D   A_DDUSNM           2401   2420
     D   A_DDUSTN           2421   2430
     D   A_DDUSSI           2431   2442
     D   A_AESSKAL          2443   2477
     D   A_AESCCTN          2478   2489
     D   A_DDCCSN           2490   2499
     D   A_DDCCNM           2500   2519
     D   A_DDCCTN           2520   2529
     D   A_DDCCSI           2530   2541
     D   A_AESDCTL          2542   2547
     D   A_AESRSSN          2548   2557
     D   A_DDRSSN           2558   2567
     D   A_DDRSNM           2568   2587
     D   A_DDRSTN           2588   2597
     D   A_DDRSSI           2598   2609
     D   A_AESRSS1          2610   2644
     D   A_AESRSS2          2645   2679
     D   A_AESRSS3          2680   2714
     D   A_AESRSS4          2715   2749
     D   A_AESDSSN          2750   2759
     D   A_AESDSS1          2760   2794
     D   A_AESDSS2          2795   2829
     D   A_AESDSS3          2830   2864
     D   A_AESDSS4          2865   2899
     D   A_AESBSSN          2900   2909
     D   A_AESBSS1          2910   2944
     D   A_AESBSS2          2945   2979
     D   A_AESINVE          2980   2989
     D   A_DDIOSN           2990   2999
     D   A_DDIONM           3000   3019
     D   A_DDIOTN           3020   3029
     D   A_DDIOSI           3030   3041
     D   A_AESIMMD1         3042   3053
     D   A_DDI1SN           3054   3063
     D   A_DDI1NM           3064   3083
     D   A_DDI1TN           3084   3093
     D   A_DDI1SI           3094   3105
     D   A_AESIMSA1         3106   3125
     D   A_AESIMMD2         3126   3137
     D   A_DDI2SN           3138   3147
     D   A_DDI2NM           3148   3167
     D   A_DDI2TN           3168   3177
     D   A_DDI2SI           3178   3189
     D   A_AESIMSA2         3190   3209
     D   A_AESIMMD3         3210   3221
     D   A_AESIMSA3         3222   3241
     D   A_AESIMMD4         3242   3253
     D   A_AESIMSA4         3254   3273
     D   A_AESIMMD5         3274   3285
     D   A_AESIMSA5         3286   3305
     D   A_AESIMMD6         3306   3317
     D   A_AESIMSA6         3318   3337
     D   A_AESIMMD7         3338   3349
     D   A_AESIMSA7         3350   3369
     D   A_AESIMMD8         3370   3381
     D   A_AESIMSA8         3382   3401
     D   A_AESIMMD9         3402   3413
     D   A_AESIMSA9         3414   3433
     D   A_AESPSET          3434   3445
     D   A_DDPSSN           3446   3455
     D   A_DDPSNM           3456   3475
     D   A_DDPSTN           3476   3485
     D   A_DDPSSI           3486   3497
     D   A_AESNAC1          3498   3532
     D   A_AESNAC2          3533   3567
     D   A_AESDIDN          3568   3577
     D   A_AESDAD1          3578   3612
     D   A_AESDAD2          3613   3647
     D   A_AESDAD3          3648   3682
     D   A_AESDAD4          3683   3717
     D   A_AESDLIN          3718   3752
     D   A_AESQFIN          3753   3762
     D   A_AESPCLR          3763   3772
     D   A_BESAP1N          3773   3782
     D   A_BDA1SN           3783   3792
     D   A_BDA1NM           3793   3812
     D   A_BDA1TN           3813   3822
     D   A_BDA1SI           3823   3834
     D   A_BESAP1L          3835   3869
     D   A_BESAP2N          3870   3879
     D   A_BDA2SN           3880   3889
     D   A_BDA2NM           3890   3909
     D   A_BDA2TN           3910   3919
     D   A_BDA2SI           3920   3931
     D   A_BESAP2L          3932   3966
     D   A_BESAWIN          3967   3976
     D   A_BDAISN           3977   3986
     D   A_BDAINM           3987   4006
     D   A_BDAITN           4007   4016
     D   A_BDAISI           4017   4028
     D   A_BESAWIL          4029   4063
     D   A_BESBOFN          4064   4073
     D   A_BDBMSN           4074   4083
     D   A_BDBMNM           4084   4103
     D   A_BDBMTN           4104   4113
     D   A_BDBMSI           4114   4125
     D   A_BESBOF1          4126   4160
     D   A_BESBOF2          4161   4195
     D   A_BESACL1          4196   4230
     D   A_BESACL2          4231   4265
     D   A_BESSRL1          4266   4300
     D   A_BESSRL2          4301   4335
     D   A_BESSRL3          4336   4370
     D   A_BESFIN1          4371   4405
     D   A_BESFIN2          4406   4440
     D   A_BESRED1          4441   4475
     D   A_BESRED2          4476   4510
     D   A_BESNAL1          4511   4545
     D   A_BESNAL2          4546   4580
     D   A_BESIPYN          4590   4590
     D   A_BDIPSN           4600   4600
     D   A_BDIPNM           4620   4620
     D   A_BDIPTN           4630   4630
     D   A_BDIPSI           4642   4642
     D   A_BESIPYL          4677   4677
     D   A_BESCTYN          4687   4687
     D   A_BESCTYL          4722   4722
     D   A_BESSA1N          4732   4732
     D   A_BDCZSN           4742   4742
     D   A_BDCSNM           4762   4762
     D   A_BDCSTN           4772   4772
     D   A_BDCSSI           4784   4784
     D   A_BESSA1L          4819   4819
     D   A_BESSKAN          4829   4829
     D   A_BDUSSN           4839   4839
     D   A_BDUSNM           4859   4859
     D   A_BDUSTN           4869   4869
     D   A_BDUSSI           4881   4881
     D   A_BESSKAL          4916   4916
     D   A_BESCCTN          4928   4928
     D   A_BDCCSN           4938   4938
     D   A_BDCCNM           4958   4958
     D   A_BDCCTN           4959   4968
     D   A_BDCCSI           4969   4980
     D   A_BESDCTL          4981   4986
     D   A_BESRSSN          4987   4996
     D   A_BDRSSN           4997   5006
     D   A_BDRSNM           5007   5026
     D   A_BDRSTN           5027   5036
     D   A_BDRSSI           5037   5048
     D   A_BESRSS1          5049   5083
     D   A_BESRSS2          5084   5118
     D   A_BESRSS3          5119   5153
     D   A_BESRSS4          5154   5188
     D   A_BESDSSN          5189   5198
     D   A_BESDSS1          5199   5233
     D   A_BESDSS2          5234   5268
     D   A_BESDSS3          5269   5303
     D   A_BESDSS4          5304   5338
     D   A_BESBSSN          5339   5348
     D   A_BESBSS1          5349   5383
     D   A_BESBSS2          5384   5418
     D   A_BESINVE          5419   5428
     D   A_BDIOSN           5429   5438
     D   A_BDIONM           5439   5458
     D   A_BDIOTN           5459   5468
     D   A_BDIOSI           5469   5480
     D   A_BESIMMD1         5481   5492
     D   A_BDI1SN           5493   5502
     D   A_BDI1NM           5503   5522
     D   A_BDI1TN           5523   5532
     D   A_BDI1SI           5533   5544
     D   A_BESIMSA1         5545   5564
     D   A_BESIMMD2         5565   5576
     D   A_BDI2SN           5577   5586
     D   A_BDI2NM           5587   5606
     D   A_BDI2TN           5607   5616
     D   A_BDI2SI           5617   5628
     D   A_BESIMSA2         5629   5648
     D   A_BESIMMD3         5649   5660
     D   A_BESIMSA3         5661   5680
     D   A_BESIMMD4         5681   5692
     D   A_BESIMSA4         5693   5712
     D   A_BESIMMD5         5713   5724
     D   A_BESIMSA5         5725   5744
     D   A_BESIMMD6         5745   5756
     D   A_BESIMSA6         5757   5776
     D   A_BESIMMD7         5777   5788
     D   A_BESIMSA7         5789   5808
     D   A_BESIMMD8         5809   5820
     D   A_BESIMSA8         5821   5840
     D   A_BESIMMD9         5841   5852
     D   A_BESIMSA9         5853   5872
     D   A_BESPSET          5873   5884
     D   A_BDPSSN           5885   5894
     D   A_BDPSNM           5895   5914
     D   A_BDPSTN           5915   5924
     D   A_BDPSSI           5925   5936
     D   A_BESNAC1          5937   5971
     D   A_BESNAC2          5972   6006
     D   A_BESDIDN          6007   6016
     D   A_BESDAD1          6017   6051
     D   A_BESDAD2          6052   6086
     D   A_BESDAD3          6087   6121
     D   A_BESDAD4          6122   6156
     D   A_BESDLIN          6157   6191
     D   A_BESQFIN          6192   6201
     D   A_BESPCLR          6202   6211
     D   A_DDCRSK           6212   6228
     D   A_DDLQPR           6229   6245
     D   A_DDITRN           6246   6260
     D   A_TMSP             6261   6286
     D   A_BDSPBS           6287   6287
     D   A_STBS             6288   6288
     D   A_PROT             6289   6289
     D   A_NMCY             6290   6292
     D   A_C1DI             6293   6293
     D   A_BVAUTH           6294   6295
     D   A_DDCPNR           6296   6308
     D   A_DDTCTR           6309   6329
     D   A_DDCFCT           6330   6341
     D   A_ADDROUS          6342   6347
     D   A_ADDROTS          6348   6359
     D   A_ADDROUC          6360   6365
     D   A_ADDROTC          6366   6377
     D   A_BDDROUS          6378   6383
     D   A_BDDROTS          6384   6395
     D   A_BDDROUC          6396   6401
     D   A_BDDROTC          6402   6413
     D   A_DDSPXR           6414   6427
     D   A_DDSPMD           6428   6428
     D   A_DDWTAX           6429   6443
     D   A_BKEURO           6444   6446
     D   A_DDSTAT           6447   6455
     D   A_DDAUTH           6456   6469
     D   A_SITP             6470   6472
     D   A_DDPRICN          6473   6489
     D   A_DDHACR           6490   6502
     D   A_DDTCSR           6503   6517
     D   A_DDDAYS           6518   6520
     D   A_DDFOID           6521   6540
     D   A_TQTAX            6541   6541
     D   A_TQSTAF           6542   6554
     D   A_TQCDTE           6555   6560
     D   A_AUTH             6561   6561
     D   A_TOFfil           6562   6610
      *
      ** Image Type - Amend Before, Amend After or Insert
      *
     D ImageType       S             20A
     D ImageTypeB      S             20A
     D ImageTypeB2     S             20A
     D ImageTypeB3     S             20A
      *
      **----------------  End of Parameters for CPB010  -------------**
      *
      *
      **------------ Start of parameters for ZAGETSETAC -------------**
      **  -------
      **  Outputs
      **  -------
      *
      ** Account code.
      *
     D AccCode         S             10S 0
      ** Account sequence.
     D AccSeq          S              2S 0
      ** MEMOS update required.
     D MemosInd        S              1A
      ** PRONO update required.
     D PronoInd        S              1A
      *
      **  ------------
      **  Input/output
      **  ------------
      *
      ** Transaction branch.
     D Branch          S              3A
      ** Tansaction customer.
     D CustNo          S              6A
      ** Settlement currency.
     D Currency        S              3A
      *
      **  ------
      **  Inputs
      **  ------
      *
      ** Settlement type.
     D SettleType      S              2S 0
      ** Settlement account.
     D SettleAcc       DS            18
     D   WW_AccNum             1      6
     D   WW_AccCode            7     16
     D   WW_AccSeq            17     18

      *
      **------------- End of parameters for ZAGETSETAC --------------**
      *
      *
      ** --------- Start of fields used by access programs ----------**
      *
      ** Return code.
     D P_RtCd          S              7A
     D ReturnCodeB     S              7A
      ** Option.
     D P_Optn          S              7A
      ** Customer.
     D P_Cust          S              6A
      ** Key status.
     D P_Kyst          S              7A
      *
      ** ---------- End of fields used by access programs -----------**
      *
      *
      ** Work Field used as position for each numeric fields
      *
     D W_PosDebut      S              2S 0
     D fmDpLen         S              1A
      *
      ** End Position.
      *
     D EndPosition     S              7S 0
      *
      ** Work Field used as key to access to Customer PB Details.
      *
     D K_CustNum       S              6A
      *
      ** Work field used to access to SE Trade Authorization.
      *
     D K_TradeRef      S              6A
      *
      ** Work field used to access to SE Trade incomplete/complete
      ** indicator
      *
     D K_Tinc          S              1A
      *
      ** Work field used to access to SE Trade RECI
      *
     D K_Reci          S              1A
      *
      ** Work field used to store Incomplete Ind before update
      *
     D B_Tinc          S              1A
      *
      ** Work field used to store If 1st authorisation is done
      *
     D W_OneAut        S              1A
      *
      ** Work field used to store Private Banking Order Number.
      *
     D W_OrderNumber   S              6S 0
      *
      ** Work field used to retrieve Trade type
      *
     D W_Type          S              2A
      *
      **----------------  Start of additional fields ----------------**
      *
     D W_NomCcyNbdp    S              1A
     D W_PayFrSettAcc  S             24A
     D W_PayFrSettPor  S              4A
     D W_PayToSettAcc  S             24A
     D W_PayToSettPor  S              4A
      *
      **-----------------  End of additional fields -----------------**
      *
      *
      ** Work Field used to condition Meridian message sending.
      *
     D W_SendMsg       S              1A
      *
      ** Composite Data
      *
     D CompData        S                   LIKE(TransData)
     D CompDataB       S                   LIKE(TransData)
      *
      ** True and False can be used for indicators being on or off.
      *
     D True            C                   *On
     D False           C                   *Off
      *
      ** Work Field used to produce only one dump.
      *
     D W_RunBefore     S              1A
      *
      ** Work field used to set up return code when no record found.
      *
     D W_NoRcdFnd      C                   CONST('*NoRcdFnd')
      *
      ** Work field used for change message type
      *
     D W_PosFin        S              3S 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      /Eject
      *****************************************************************
     C     Start         Tag

      *
      ** Note: the above tag is only there to force the first comments
      ** in the C-specs to appear after the D- or I-specs in compiled
      ** listings.
      *

      *****************************************************************
      *                                                               *
      *                  M A I N  P R O C E S S I N G                 *
      **   +------------------------------------------------------+   *
      **   ¦                                                      ¦   *
      **   ¦ Initial processing is performed automatically: the   ¦   *
      **   ¦ *inzsr is executed at program activation.            ¦   *
      **   ¦                                                      ¦   *
      **   +------------------------------------------------------+   *
      *                                                               *
      *****************************************************************

      *
      ** Extract Trade Reference.
      *
     C                   Z-add     1             X
     C     'TDRF  '      Lookup    Arrfld(X)                              89
     C                   Eval      K_TradeRef = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** Retrieve full format of TRADSD and ensure it is refreshed at
      ** every run.
      *
     C                   Clear                   W_SendMsg
     C                   Clear                   TradsdO
     C                   Clear                   TradsdC
     C                   Clear                   TradsdxO
     C                   Clear                   TradsdxC
     C                   Clear                   SettldO
     C                   Clear                   TradsdC2
     C                   Clear                   TradsdxC2
     C                   Clear                   TradsdC3
     C                   Clear                   TradsdxC3

     C                   OPEN      TRADS
     C     K_TradeRef    CHAIN     TRADS                              99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdO = Tradsd
     C                   END
     C                   CLOSE     TRADS
     C                   OPEN      TRADSDY1
     C     K_TradeRef    CHAIN     TRADSDY1                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdxO = Tradsdx
     C                   END
     C                   CLOSE     TRADSDY1
      *
      ** Always call PB replication if FN is not setup or if Trade
      ** branch is not Consolidated branch.
      *
     C                   SETOFF                                       55
     C                   Z-Add     1             Z
     C     O_TDBA        LOOKUP    FNbrcaA(Z)                             55
      *
     C                   IF        FNSetup=  ' '    Or
     C                             *IN55 = *Off
      *
      ** Call Private banking trigger program drirectly
      ** Save input parameter
      *
     C                   Eval      OutQueueB   = OutQueue
     C                   Eval      MdnheadDSB  = MdnHeadDS
     C                   Eval      TransDataB   = TransData
     C                   Eval      CommitCtlB   = CommitCtl
     C                   Eval      ReturnCodeB   = ReturnCode
     C                   CALLB     'RP1511'
     C                   Parm                    OutQueue
     C                   Parm                    MdnHeadDS
     C                   Parm                    TransData
      *
      ** Commitment control flag
      *
     C                   Parm                    CommitCtl
      *
      ** Return Code
      *
     C                   Parm                    ReturnCode
      *
      ** After process of PB Use the saved image insetead of the image
      ** modified by RP1511
      *
     C                   Endif
      *
      ** Continue further only if FN is setup and not conolidated branch
      *
     C                   SETOFF                                       55
     C                   Z-Add     1             Z
     C     O_TDBA        LOOKUP    FNbrcaA(Z)                             55
      *
      *
     C                   IF        FNSetup=  ' '    Or
     C                             *IN55 = *On
      *
      ** If Consolidated Branch,  Call procedure to Update UDF08 on
      ** the original trade with the replicated trade reference
      *
     C                   If        *IN55  =  *On
     C                   Eval      Pos      = %Scan(' ':O_FRNT)
     C                   If        Pos = 0
     C                   Eval      Pos = 21
     C                   Endif
     C                   If        Pos > 6
     C                   Eval      TradeOri = %Subst(O_FRNT:Pos - 6:6)
      *
      ** If conso branch1, ie Z = 1, update T_GZTRADEX/UDFTRAD08 with
      ** O_TDRF
      *
     C                   IF        Z= 1
     C                   CALL      'A1008003'
     C                   PARM                    TradeOri
     C                   PARM                    O_TDRF
      *
      ** If conso branch2, ie Z = 2, update T_GZTRADEX/UDFTRAD13 with
      ** O_TDRF
      *
     C                   ELSEIF    Z= 2
     C                   CALL      'A1008004'
     C                   PARM                    TradeOri
     C                   PARM                    O_TDRF
      *
      ** If Conso branch3, ie z= 3 update T_GZTRADEX/UDFTRAD16 with
      ** O_TDRF
      *
     C                   ELSEIF    Z= 3
     C                   CALL      'A1008005'
     C                   PARM                    TradeOri
     C                   PARM                    O_TDRF
     C                   ENDIF
      *
     C                   Commit
     C                   endif
     C                   endif
     C                   Return
     C                   endif
      *
      ** After PB replication check if consolidated replication is
      ** required, retrieve if consolidated branch replication is
      ** required.  RtnCons = 'C'
      *
     C                   MOVEL     K_TradeRef    Traderef
     C                   CALL      'A1008006'
     C                   PARM                    Traderef
     C                   PARM                    RtnCons
     C                   PARM                    RtnBook
     C                   PARM                    RtnCons2
     C                   PARM                    RtnBook2
     C                   PARM                    RtnCons3
     C                   PARM                    RtnBook3
     C                   PARM                    ReturnCodex
      *
      ** Extract Reci indicator  do not process Matured record
      *
     C                   Z-add     1             X
     C     'RECI  '      Lookup    Arrfld(X)                              89
     C                   Eval      K_Reci = %Subst(TransDataB:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** Do not process if Intragroup
      *
     C                   If        RtnCons  <>  'C'
     C                             and  RtnCons2 <>  'C'
     C                             and  RtnCons3 <>  'C'
     C                   Eval      MessageInd = 'N'
     C                   Return
     C                   Endif
      *
      ** Stop here if matured  or history
      *
     C                   If        K_Reci =  'M'  or K_Reci =  '*'
     C                   Eval      MessageInd = 'N'
     C                   Return
     C                   Endif
      *
      ** Stop here if still need auhorisation
      *
     C                   If        K_Reci =  'L'   or K_Reci =  'P'
     C                   Eval      MessageInd = 'N'
     C                   Return
     C                   Endif
      *
      ** If reach this line Consolidation Branch process may be required
      *
     C                   Eval      MessageInd = 'Y'
     C                   Eval      RAMSGOLD = RAMSGTYPE
      *
      ** Enter the processing to read the additional files and produce a
      ** composite message here.
      *
      *
      ** Check image (Before or After) of the message
      *
     C                   Eval      W_PosFin    = %Scan('_B':RAMSGTYPE)
      *
      ** Before Image Type  These must not create replication
      *
     C     W_PosFin      Ifne      0
      *
      ** IF Conso ind   to Branch 1 present on Trade
      *
     C                   If        RtnCons  =   'C'
     C                   Eval      ImageTypeB = 'Amend Before'
     C                   ENDIF
      *
      ** IF Conso ind   to Branch 2 present on Trade
      *
     C                   If        RtnCons2 =   'C'
     C                   Eval      ImageTypeB2 = 'Amend Before'
     C                   ENDIF
      *
      ** IF Conso ind   to Branch 3 present on Trade
      *
     C                   If        RtnCons3 =   'C'
     C                   Eval      ImageTypeB3 = 'Amend Before'
     C                   ENDIF
     C                   Eval      AssocDataB = TransDataB
     C                   Eval      MdHdAssocB = MdnHeadDsB
     C                   Eval      AssocDataB2 = TransDataB
     C                   Eval      MdHdAssocB2 = MdnHeadDsB
     C                   Eval      AssocDataB3 = TransDataB
     C                   Eval      MdHdAssocB3 = MdnHeadDsB
     C                   Eval      MessageInd = 'N'
      *
      ** Extract Incomplete/complete indicator Image Before
      *
     C                   Z-add     1             X
     C     'TINC  '      Lookup    Arrfld(X)                              89
     C                   Eval      B_Tinc = %Subst(TransDataB:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** Do not continue process if before image is processed
      *
     C                   Return

     C                   Else

     C                   If        RtnCons  =   'C'
     C                             and FNbrcaA(1) <> '   '
     C                   If        ImageTypeB  <> 'Amend Before'
     C                   Eval      ImageTypeB = 'Insert'
     C                   Eval      AssocDataB = *Blanks
     C                   Eval      MdHdAssocB = *Blanks
     C                   Else

     C                   Eval      ImageTypeB = 'Amend After'
     C                   EndIf
     C                   EndIF

     C                   If        RtnCons2 =   'C'
     C                             and FNbrcaA(2) <> '   '
     C                   If        ImageTypeB2 <> 'Amend Before'
     C                   Eval      ImageTypeB2 = 'Insert'
     C                   Eval      AssocDataB2= *Blanks
     C                   Eval      MdHdAssocB2= *Blanks
     C                   Else

     C                   Eval      ImageTypeB2 = 'Amend After'
     C                   EndIf
     C                   EndIF

     C                   If        RtnCons3 =   'C'
     C                             and FNbrcaA(3) <> '   '
     C                   If        ImageTypeB3 <> 'Amend Before'
     C                   Eval      ImageTypeB3 = 'Insert'
     C                   Eval      AssocDataB3= *Blanks
     C                   Eval      MdHdAssocB3= *Blanks
     C                   Else

     C                   Eval      ImageTypeB3 = 'Amend After'
     C                   EndIf
     C                   EndIF
      *
      ** Extract Incomplete/complete indicator Image After
      *
     C                   Z-add     1             X
     C     'TINC  '      Lookup    Arrfld(X)                              89
     C                   Eval      K_Tinc = %Subst(TransDataB:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** If incomplete don't replicate yet. It will be done when status
      ** is change to complete.
      *
     C                   If        K_Tinc = 'I'
     C                   Eval      ImageTypeB = *Blanks
     C                   Eval      ImageTypeB2 = *Blanks
     C                   Eval      ImageTypeB3 = *Blanks
     C                   Eval      MessageInd = 'N'
     C                   Return
     C                   Endif
     C                   Endif
      *
      ** Extract Customer number from TRADSD message data.
      *
     C                   Z-add     1             X
     C     'TCNR  '      Lookup    Arrfld(X)                              89
     C                   EVAL      P_Cust = %Subst(TransDataB:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** Access Security Customer Details by using Access Object
      ** to retrieve Safe Custody
      *
     C                   CALL      'AOSECSR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Cust                         I:Key field
     C     Sdsecs        Parm      Sdsecs        Dssdy                          O:Format
      *
      ** If Customer Details do not exist, handle Database Error.
      *
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDSECSPD'                          ***************
     C                   Eval      DBase  = 01                                  * Db Error 01 *
     C                   Eval      DBkey  = P_Cust                              ***************
     C                   Out       Lda
     C                   Eval      ReturnCode =  P_Rtcd
     C                   Exsr      Repair

     C                   Endif                                                  End P_Rtcd
      *
      ** Now check if the trade has already been replicated
      ** for the 3 consolidated branches in A1CONBPD
      ** It may not if trade was incomplete previously.
      *
      ** Consolidate Branch 1
      *
     C                   If        RtnCons  =   'C'
     C                             and FNbrcaA(1) <> '   '
     C                   Eval      TradeFOI = %trim(FNfoirA(1)) + K_TradeRef
     C                   CALL      'A1008007'
     C                   PARM                    TradeFOI
     C                   PARM                    FNbrcaA(1)
     C                   PARM      *blank        TradeRTN
     C                   PARM      *blank        ReturnCodex
      *
      **  If No records  exist with FRNT = FNROIR + TDRF and It is an
      **  AMend RECI is do insert
      *
     C                   If        ReturnCodex  = 'NRF    '
     C                   Eval      ImageTypeB = 'Insert              '
     C                   Eval      AssocDataB = *Blanks
     C                   Eval      MdHdAssocB = *Blanks
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Consolidate Branch 2
      *
     C                   If        RtnCons2 =   'C'
     C                             and FNbrcaA(2) <> '   '
     C                   Eval      TradeFOI2 = %trim(FNfoirA(2)) + K_TradeRef
     C                   CALL      'A1008007'
     C                   PARM                    TradeFOI2
     C                   PARM                    FNbrcaA(2)
     C                   PARM      *blank        TradeRTN2
     C                   PARM      *blank        ReturnCodex2
      *
      ** If No records  exist with FRNT = FNROIR + TDRF and It is an
      ** AMend RECI is do insert
      *
     C                   If        ReturnCodex2  = 'NRF    '
     C                   Eval      ImageTypeB2 = 'Insert              '
     C                   Eval      AssocDataB2 = *Blanks
     C                   Eval      MdHdAssocB2 = *Blanks
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Consolidate Branch 3
      *
     C                   If        RtnCons3 =   'C'
     C                             and FNbrcaA(3) <> '   '
     C                   Eval      TradeFOI3 = %trim(FNfoirA(3)) + K_TradeRef
     C                   CALL      'A1008007'
     C                   PARM                    TradeFOI3
     C                   PARM                    FNbrcaA(3)
     C                   PARM      *blank        TradeRTN3
     C                   PARM      *blank        ReturnCodex3
      *
      ** If No records  exist with FRNT = FNROIR + TDRF and It is an
      ** AMend RECI is do insert
      *
     C                   If        ReturnCodex3  = 'NRF    '
     C                   Eval      ImageTypeB3 = 'Insert              '
     C                   Eval      AssocDataB3 = *Blanks
     C                   Eval      MdHdAssocB3 = *Blanks
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If action is delete ReCI = C or R and NRF no action is required
      *
     C                   If        K_Reci = 'C' or K_Reci = 'R'
      *
      ** Only return if all 3 consolidated branch  records are NRF
      *
     C                   If        ImageTypeB  = 'Insert              '
     C                             and ImageTypeB2 = 'Insert              '
     C                             and ImageTypeB3 = 'Insert              '
     C                   Eval      MessageInd = 'N'
     C                   Return
     C                   Endif
     C                   Endif
      *
      ** Retrieve full format of the Replicated trade
      ** For conso Branch 1 : deal replicated already
      *
     C                   If        ReturnCodex  <> 'NRF    '
     C                             and RtnCons  =   'C'
     C                   Eval      ImageTypeB = 'Amend              '
     C                   OPEN      TRADS
     C     TradeRTN      CHAIN     TRADS                              99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdC = Tradsd
     C                   Endif
     C                   CLOSE     TRADS
     C                   OPEN      TRADSDY1

     C     TradeRTN      CHAIN     TRADSDY1                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdxC = Tradsdx
     C                   Endif
     C                   CLOSE     TRADSDY1
      *
      ** Decide if replication trade must be deleted
      *
     C                   If        K_Reci = 'C' or K_Reci = 'R'
     C                   Eval      ImageTypeB = 'Delete             '
      *
      ** If replicated trade does not exist or has been deleted stop
      ** process.
      *
     C                   If        TradsdC = *blanks or
     C                             C_Reci = 'C' or C_Reci = 'R'
     C                   Eval      ImageTypeB = '                   '
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** For conso branch 2: deal replicated already
      *
     C                   If        ReturnCodex2 <> 'NRF    '
     C                             and RtnCons2 =   'C'
     C                   Eval      ImageTypeB2 = 'Amend              '
     C                   OPEN      TRADS
     C     TradeRTN2     CHAIN     TRADS                              99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdC2 = Tradsd
     C                   Endif
     C                   CLOSE     TRADS
     C                   OPEN      TRADSDY1

     C     TradeRTN2     CHAIN     TRADSDY1                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdxC2 = Tradsdx
     C                   Endif
     C                   CLOSE     TRADSDY1
      *
      ** Decide if replication trade must be deleted
      *
     C                   If        K_Reci = 'C' or K_Reci = 'R'
     C                   Eval      ImageTypeB2 = 'Delete             '
      *
      ** If replicated trade does not exist or has been deleted stop
      ** process.
      *
     C                   If        TradsdC2 = *blanks or
     C                             C2Reci = 'C' or C2Reci = 'R'
     C                   Eval      ImageTypeB2 = '                   '
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** For conso branch 3: deal replicated already
      *
     C                   If        ReturnCodex3 <> 'NRF    '
     C                             and RtnCons3 =   'C'
     C                   Eval      ImageTypeB3 = 'Amend              '
     C                   OPEN      TRADS
     C     TradeRTN3     CHAIN     TRADS                              99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdC3 = Tradsd
     C                   Endif
     C                   CLOSE     TRADS
     C                   OPEN      TRADSDY1

     C     TradeRTN3     CHAIN     TRADSDY1                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      TradsdxC3 = Tradsdx
     C                   Endif
     C                   CLOSE     TRADSDY1
      *
      ** Decide if replication trade must be deleted
      *
     C                   If        K_Reci = 'C' or K_Reci = 'R'
     C                   Eval      ImageTypeB3 = 'Delete             '
      *
      ** If replicated trade does not exist or has been deleted stop
      ** process.
      *
     C                   If        TradsdC3 = *blanks or
     C                             C3Reci = 'C' or C3Reci = 'R'
     C                   Eval      ImageTypeB3 = '                   '
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** If no action required for all conso branches, return:
      *
     C                   If        ImageTypeB  = '                    '
     C                             and ImageTypeB2 = '                    '
     C                             and ImageTypeB3 = '                    '
     C                   Return
     C                   Endif
      *
      ** Initialize work field used to condition Meridian message
      ** sending.
      *
     C                   Clear                   W_SendMsg
      *
      ** Setup Api message header form SETRAD
      *
     C                   Exsr      APHeader
      *
      ** Retrieve information needed to format Amounts
      *
      **----------------- Start of Nominal Currency -----------------**
      **                   Number of Decimal Places                  **
      *
     C                   Z-add     1             X
     C     'TNMC  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Currency = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** Get Nominal Currency number of decimal places.
      *
     C                   Eval      P_Curr = W_Currency
     C                   Exsr      GetDecPl
     C                   Move      A6NBDP        W_NomCcyNbdp
      *
      **                    End of Nominal Currency                  **
      **-----------------  Number of Decimal Places  ----------------**
      *
      ** Setup Api message details     SETRAD
      *
      ** Need to consider for 3 consolidated branches per trade
      *
     C                   Z-add     1             Z
     C     Z             DOWLE     3
     C                   Clear                   W_SendMsg
     C                   Eval      WrkBook = '  '
     C                   Clear                   SettldO
      *
     C                   If        RtnCons  =   'C'
     C                             and Z = 1
      *
     C                   Eval      WrkBook = RtnBook
     C                   OPEN      A1CONBL2
     C     FNudfE1       CHAIN     A1CONBPF                           99
     C                   CLOSE     A1CONBL2
     C                   IF        *IN99 = *off
     C                             and ImageTypeB <> '                    '
     C                   Eval      W_SendMsg = 'Y'
     C                   Eval      ApUSER = FNUSER
     C                   Eval      ApFRNT = TradeFOI
     C                   If        ImageTypeB =  'Insert              '
     C                   Exsr      APDataI
     C                   Else
     C                   If        ImageTypeB =  'Delete              '
     C                   Exsr      APDataD
     C                   Else
     C                   Exsr      APDataA
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif

     C                   If        RtnCons2 =   'C'
     C                             and Z = 2
      *
     C                   Eval      WrkBook = RtnBooK2
     C                   OPEN      A1CONBL2
     C     FNudfE2       CHAIN     A1CONBPF                           99
     C                   CLOSE     A1CONBL2
     C                   IF        *IN99 = *off
     C                             and ImageTypeB2 <> '                    '
     C                   Eval      W_SendMsg = 'Y'
     C                   Eval      ApUSER = FNUSER
     C                   Eval      ApFRNT = TradeFOI2
     C                   If        ImageTypeB2 =  'Insert              '
     C                   Exsr      APDataI
     C                   Else
     C                   If        ImageTypeB2 =  'Delete              '
     C                   Exsr      APDataD2
     C                   Else
     C                   Exsr      APDataA2
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif

     C                   If        RtnCons3 =   'C'
     C                             and Z = 3
      *
     C                   Eval      WrkBook = RtnBook3
     C                   OPEN      A1CONBL2
     C     FNudfE3       CHAIN     A1CONBPF                           99
     C                   CLOSE     A1CONBL2
     C                   IF        *IN99 = *off
     C                             and ImageTypeB3 <> '                    '
     C                   Eval      W_SendMsg = 'Y'
     C                   Eval      ApUSER = FNUSER
     C                   Eval      ApFRNT = TradeFOI3
     C                   If        ImageTypeB3 =  'Insert              '
     C                   Exsr      APDataI
     C                   Else
     C                   If        ImageTypeB3 =  'Delete              '
     C                   Exsr      APDataD3
     C                   Else
     C                   Exsr      APDataA3
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      *
      ** If Meridian message has to be sent.
      *
     C     W_SendMsg     Ifeq      'Y'                                          Begin W_SendMsg
      *
      **----------------- Start of Additionnal fields ---------------**
      *
      *
      ** Extract Trade Type.
      *
     C                   Z-add     1             X
     C     'TDTP  '      Lookup    Arrfld(X)                              89
     C                   Eval      W_Type = %Subst(TransData:+
     C                             ArrPos(X):ArrLen(X))
      *
      ** Change message Type from _After to _A
      ** Determine Image Type.
      *
      *
      ** Place the result in field CompData.
      *
     C                   Movel     ApHdmsg       MdnHeadDSb
     C                   Movel     ApDtmsg       CompDatab
      *
      ** Call a standard routine to actually send the message.
      *
     C                   Callb     'A1008009'
     C                   Parm                    FNQUEUE
     C**********         Parm                    ApHdmsg         200                        MD062029
     C                   Parm                    ApHdmsg         318                        MD062029
     C                   Parm                    ApDtmsg        8000
     C                   Parm                    CommitCtl
     C                   Parm      *BLANKS       ReturnCode
      *
      ** If error then perform any special processing and exit
      *
     C                   If        ReturnCode   <> *blank                              iReturnCode
     C     *Lock         In        Lda
     C                   Move      'XX08009   '  DBpgm
     C                   Out       Lda
     C                   Exsr      Repair
      *
      ** If no error, commit the unit of work so that messages that have
      ** been got from a queue would be permanently deleted and put
      ** operations would be made permanent.
      *
     C                   Else                                                   Else ReturnCod

     C                   Commit

     C                   Endif                                                  End ReturnCode

     C                   Endif                                                  End W_SendMsg
      *
      *
     C                   EVAL      Z = Z + 1
      *
     C                   ENDDO
      *

     C                   Return

      /Eject
      *****************************************************************
      *                                                               *
      *  RtvPos   - retrieve position in Meridian message.            *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************

     C     RtvPos        Begsr

     C                   Callb     'RPC1305'
     C                   Parm                    ScriptName
     C                   Parm      RAMSGTYPE     ImageName
     C                   Parm                    FieldName
     C                   Parm                    FieldType
     C                   Parm                    TransData
     C                   Parm      0             FieldPosition
     C                   Parm      0             FieldLength
     C                   Parm      *blank        FieldValue
     C                   Parm      *blank        ReturnCode
      *
      ** If any error occurred while retrieving position, handle it.
      *
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnCode
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          ***************
     C                   Eval      DBase  = 06                                  * Db Error 06 *
     C                   Eval      DBkey  = 'RPC1305'                           ***************
     C                   Out       Lda

     C                   Eval      MessageInd = 'N'
     C                   Exsr      Repair
     C                   Eval      MessageInd = 'Y'

     C                   Endif                                                  End ReturnCode

     C                   Eval      X = X + 1
      *
      ** If any error occurred while retrieving position, handle it.
      *
     C                   If        X > 100
     C     *lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Array   '                          ***************
     C                   Eval      DBase  = 07                                  * Db Error 07 *
     C                   Eval      DBkey  = 'Index  '                           **************
     C                   Out       LDA
     C                   Exsr      Repair
     C                   Endif                                                  End ReturnCode

     C                   Eval      ArrFld(X) = FieldName
     C                   Eval      ArrPos(X) = FieldPosition
     C                   Eval      ArrLen(X) = FieldLength

     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      *  Repair   - Write a Trace of outgoing messages to repair      *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************

     C     Repair        Begsr

     C                   Move      Dbase         dbasea            3

     C                   Eval      DBErrText = 'DBError' +
     C                             ' in : ' + DBpgm +
     C                             ' at: ' + DBasea +
     C                             ' file : ' + DBfile +
     C                             ' Key : ' + DBKey +
     C                             ' Return :' + ReturnCode

     C                   Eval      RAMSGTYPE  = RAMSGOLD

     C                   Callb     'RP1592'
     C                   Parm                    FNQUEUE
     C                   Parm                    MdnHeadDS
     C                   Parm                    TransData
     C                   Parm                    MdHdAssoc
     C                   Parm                    AssocData
     C                   Parm                    CommitCtl
     C                   Parm                    DBErrText
     C                   Parm                    MessageInd
     C                   Parm      *Blanks       ReturnCode
      *
      ** If any error occurred while retrieving position, handle it.
      *
     C     ReturnCode    Ifne      *blanks                                      Begin ReturnC
     C     *Lock         In        Lda
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'Call    '                          *************
     C                   Eval      DBase  = 50                                  * Db Error 50
     C                   Eval      DBkey  = 'RP1592'                            *************
     C                   Out       Lda

     C                   exsr      *pssr
     C                   Else
     C                   Return
     C                   Endif                                                  End ReturnCod

     C                   Endsr

      /Eject
      *****************************************************************
      *                                                               *
      *  GetDecPl - get number of decimal places.                     *
      *                                                               *
      *  Called by : Main processing.                                 *
      *                                                               *
      *  Calls     : None.                                            *
      *                                                               *
      *****************************************************************

     C     GetDecPl      Begsr
      *
      ** Access to Currency Details, by using access object.
      *
     C                   Callb     'AOCURRR0'
     C                   Parm      *blank        P_Rtcd                         B:Return code
     C                   Parm      '*KEY   '     P_Optn                         I:Option
     C                   Parm                    P_Curr            3            I:Key field
     C     Sdcurr        Parm      Sdcurr        Dssdy                          O:Format
      *
      ** If currency does not exist, handle database error.
      *
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C     *lock         In        Lda
     C                   Eval      Dbpgm  = PSProcName
     C                   Eval      Dbfile = 'SDCURRPD'                          *************
     C                   Eval      Dbase  = 09                                  * Db Error 09
     C                   Eval      Dbkey  = P_Curr                              *************
     C                   Out       LDA
     C                   Eval      ReturnCode  = P_RTCD
     C                   Exsr      Repair

     C                   Endif                                                  End  P_Rtcd

     C                   Endsr

      /Eject
      *****************************************************************
      *                                                               *
      * *Pssr  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************

     C     *Pssr         Begsr

     C     W_RunBefore   Ifeq      *blank                                       Begin W_RunBefore
      *
      ** If commitment control required, back out the unit of work so
      ** that current message could be available again.
      *
     C                   If        CommitCtl = 'Y'                              Begin CommiCtl
     C                   Rolbk

     C                   Endif                                                  End CommitCtl

     C     *Lock         In        Lda
     C     DBpgm         Ifeq      *blanks                                      Begin DBpgm
     C                   Move      PSProcName    DBpgm
     C                   Out       Lda

     C                   Endif                                                  End DBpgm

     C                   Move      'Y'           W_RunBefore
     C                   Dump

     C                   Endif                                                  End W_RunBefore

     C     ReturnCode    Ifeq      *blank                                       Begin ReturnCode
     C                   Eval      ReturnCode = '*PSSR'
     C                   Endif                                                  End ReturnCode

     C                   Seton                                        U7U8LR
     C                   Return

     C                   Endsr
      /Eject
      *****************************************************************
      *                                                               *
      * *Inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called at : program initialization time.                      *
      *                                                               *
      *****************************************************************

     C     *Inzsr        Begsr

     C     *Entry        Plist
      *
      ** MQSeries queue to write to - this parameter IS used in this
      ** module
      *
     C                   Parm                    OutQueue
      *
      ** Merdian header
      *
     C                   Parm                    MdnHeadDS
      *
      ** Transaction Data
      *
     C                   Parm                    TransData
      *
      ** Commitment control flag
      *
     C                   Parm                    CommitCtl
      *
      ** Return Code
      *
     C                   Parm                    ReturnCode
      *
      ** Check for switchable feature BA1008
      *
     C                   Call      'AOSARDR0'
     C                   Parm      *Blanks       @RTCD             7
     C                   Parm      '*VERIFY'     @OPTN             7
     C                   Parm      'BA1008'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           BA1008            1
     C                   Else
     C                   Movel     'N'           BA1008
     C                   EXSR      ZYEXPG
     C                   EndIf
      *
     C     KLSTD1        KLIST
     C                   KFLD                    FNBRCA
     C                   KFLD                    FNCUST
     C                   KFLD                    S_SIBK
     C                   KFLD                    O_TNMC
      *
     C                   Eval      MessageInd = 'Y'

      *
      ** Set up work fields for formatting that will not change if
      ** Replication formatting is required.
      **    - signs are not shown for Positive numbers.
      **    - get decimal separator from Replication data area RPDFTSDA
      *
     C                   In        RPDftsDa
     C                   Eval      fmDecSep   = RCDECSEP
     C                   Eval      fmDpLen  = %Subst(RCZEROFLD:2:1)
     C                   Move      fmDpLen       W_PosDebut
     C                   Eval      fmShwPsSgn = 'N'
      *
      ** Set up work fields that will not change if retrieve
      ** function is to be used.
      *
     C                   Eval      ScriptName = 'RP' + RATGTSYS
      *
      ** Get Securities Trading Data by using Access Object.
      *
     C                   Callb     'AOSTRDR0'
     C                   Parm      *Blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdstrd        Parm      Sdstrd        Dssdy
      *
      ** If Securities Trading Details do not exist, handle Database Error.
      *
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDSTRDPD'                          ***************
     C                   Eval      DBase  = 10                                  * Db Error 10 *
     C                   Eval      DBkey  = '*FIRST'                            ***************
     C                   Out       Lda
     C                   Exsr      Repair

     C                   Endif                                                  End P_Rtcd
      *
      ** Get Private Banking details by using Access Object.
      *
     C                   Callb     'AOTOFR0'
     C                   Parm      *Blanks       P_Rtcd
     C                   Parm      '*FIRST '     P_Optn
     C     Sdtofd        Parm      Sdtofd        Dssdy
      *
      ** If Private Banking details do not exist, handle Database Error
      *
     C     P_Rtcd        Ifne      *blanks                                      Begin P_Rtcd
     C                   Eval      DBpgm  = PSProcName
     C                   Eval      DBfile = 'SDTOFPD'                           ***************
     C                   Eval      DBase  = 11                                  * Db Error 11 *
     C                   Eval      DBkey  = '*FIRST'                            **************
     C                   Out       Lda
     C                   Exsr      Repair

     C                   Endif                                                  End P_Rtcd

     C                   Z-add     0             X                 3 0
      *
      ** Retrieve position and length of customer number from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'TCNR'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Order number from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'ORDE'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Trade Reference from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'TDRF'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Nomincal Currency from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'TNMC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Pay From Branch from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'PYFA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Pay From Branch from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'SETC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of in/complete ind from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'TINC'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of RECI from TRADSD message data.
      *
     C                   Eval      FieldName   = 'RECI'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Settlement Methode from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'SMTH'
     C                   Eval      FieldType   = 'N'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Pay From from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'PYFM'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Pay To Branch TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'PYTA'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Pay To TRADSD message data.
      *
     C                   Eval      FieldName   = 'PAYT'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Trade type from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'TDTP'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve position and length of Replication Flag from TRADSD
      ** message data.
      *
     C                   Eval      FieldName   = 'REPI'
     C                   Eval      FieldType   = 'A'
     C                   Exsr      RtvPos
      *
      ** Retrieve begin position of additionnal fields in Meridian
      ** message.
      *
     C                   Eval      FieldName   = '*END_IMAGE'
     C                   Eval      FieldType   = *blank
     C                   Exsr      RtvPos
     C                   Eval      EndPosition = FieldPosition - 1
      *
      ** Introduce SubRoutine FNDataD
      *
     C                   Exsr      FNDataD
      *
      ** Retrieve substitution character
      *
     C                   OPEN      SDAPIPD
     C                   READ      SDAPIPD
     C                   CLOSE     SDAPIPD
      *
      ** Fill worSUBS withn substitution cahracter
      *
     C                   Movel     GHSUBS        WrSUBS
     C                   FOR       i = 1 to 99
     C                   eval      WrSUBS   = %trim(WrSUBS) + GHSUBS
     C                   ENDFOR
     C                   Endsr
      /Eject
      *****************************************************************
     C     APHeader      Begsr
     C                   Eval      ApMSGT = 'SETRAD                          '
     C                   Eval      ApSRCS = 'Midas   '
     C                   Eval      ApORIG = *blank
     C                   Eval      ApTGTS = 'MIDAS   '
     C                   Eval      ApPASS = *Blank
     C                   Eval      ApFORM = 'Fixed   '
     C                   Eval      ApVERS = 'JMSMQ   '
     C                   Eval      ApRPYQ = 'REPLY               '
     C                   Eval      ApRESP = 'A'
     C                   Eval      ApMAPL = *blank
      *
      ** Front Office transaction ID
      *
     C                   Eval      ApASOC = *blank
     C                   Eval      ApRESPN = 'N'
     C                   Eval      ApMAPLB = 'B'
     C                   Eval      APFIL = *blank
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataI       Begsr
     C                   Clear                   ApDtmsg
      *
      ** Get Default fo settlement
      *
     C                   IF        FNBRCA  <> *blank
     C                   OPEN      STDSED
     C     KLSTD1        CHAIN     STDSEDF                            99
     C                   CLOSE     STDSED
     C                   Endif
      *
      ** - API action
      *
     C                   Eval      A_DDACTN  = 'I'
      *
      ** - Trade reference
      *
     C                   Eval      A_DDTDRF  = *Blank
      *
      ** - Bulk reference
      *
     C                   Eval      A_DDBLKR  = O_BLKR
      *
      ** - Security short name
      *
     C                   Eval      A_DDSESN  = O_TDSS
      *
      ** - Client Number
      ** if safe custody use FNCUST   else use Trade customer
      *
     C                   If        BFCLAS = 'D' or BFCLAS = 'S'
     C                   Eval      A_DDCNUM  = FNCUST
     C                   Else
     C                   Eval      A_DDCNUM  = O_TCNR
     C                   Endif
      *
      ** - Customer shortname
      *
     C                   Eval      A_DDCSSN  = *Blank
      *
      ** - Customer report name
      *
     C                   Eval      A_DDCRNM  = *Blank
      *
      ** - Customer report town
      *
     C                   Eval      A_DDCRTN  = *Blank
      *
      ** - Incomplete indicator
      *
     C                   Eval      A_DDINCS  = O_TINC
      *
      ** - Trade type
      *
     C                   Eval      A_DDTDTP  = O_TDTP
      *
      ** - Nominal
      ** Format nominal amount based on Nominal decimal plases
      *
     C                   Move      O_NOML        W_NOML
      *                  Remove leading Zero
     C                   If        W_N1 = '0' or W_N1 = ' '
     C                   Eval      W_N1 = *blank
     C                   If        W_N2 = '0' or W_N2 = ' '
     C                   Eval      W_N2 = *blank
     C                   If        W_N3 = '0' or W_N3 = ' '
     C                   Eval      W_N3 = *blank
     C                   If        W_N4 = '0' or W_N4 = ' '
     C                   Eval      W_N4 = *blank
     C                   If        W_N5 = '0' or W_N5 = ' '
     C                   Eval      W_N5 = *blank
     C                   If        W_N6 = '0' or W_N6 = ' '
     C                   Eval      W_N6 = *blank
     C                   If        W_N7 = '0' or W_N7 = ' '
     C                   Eval      W_N7 = *blank
     C                   If        W_N8 = '0' or W_N8 = ' '
     C                   Eval      W_N8 = *blank
     C                   If        W_N9 = '0' or W_N9 = ' '
     C                   Eval      W_N9 = *blank
     C                   If        W_N10 = '0' or W_N10 = ' '
     C                   Eval      W_N10 = *blank
     C                   If        W_N11 = '0' or W_N11 = ' '
     C                   Eval      W_N11 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        TNMD = 0
     C                   If        W_N11 = ' '
     C                   Eval      W_N11 = *ZERO
     C                   Endif
     C                   Eval      A_DDNOML  = %trim(W_NOML0)
     C                   Endif
     C                   If        TNMD = 1
     C                   If        W_N11 = ' '
     C                   Eval      W_N11 = *ZERO
     C                   Endif
     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
     C                   Endif
     C                   If        TNMD = 2
     C                   If        W_N10 = ' '
     C                   Eval      W_N10 = *ZERO
     C                   Endif
     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
     C                   Endif
     C                   If        TNMD = 3
     C                   If        W_N9 = ' '
     C                   Eval      W_N9 = *ZERO
     C                   If        W_N10 = ' '
     C                   Eval      W_N10 = *ZERO
     C                   Endif
     C                   Endif
     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
     C                   Endif
     C                   If        TNMD = 4
     C                   If        W_N8 = ' '
     C                   Eval      W_N8 = *ZERO
     C                   If        W_N9  = ' '
     C                   Eval      W_N9  = *ZERO
     C                   If        W_N10 = ' '
     C                   Eval      W_N10 = *ZERO
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
     C                   Endif
      *
      ** - Price/Disc/Yield
      ** If not nil format with Price Decimal places  (15,8)
      *
     C                   If        O_TPDY  > 0
     C                   Movel     O_TPDY        W_1508
      *
      ** Remove leading Zero
      *
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Value Date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDVD
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDVD
      *
      ** - Booking Branch
      ** Overwrite branch to consolidated branch
      *
     C                   Eval      A_DDBRCD  = FNBRCA
      *
      ** - Book
      *
     C                   If        WrkBook = *Blank
     C                   Eval      A_DDBPBK  = O_TDBK
     C                   else
     C                   Eval      A_DDBPBK  = WrkBook
     C                   endif
      *
      ** - Clearance type
      *
     C                   If        O_TDTP    = 'TS'
     C                   Eval      A_DDCLTY  = S_SCLS
     C                   Eval      A_DDCLTY2 = S_SCLS
     C                   Else
     C                   Eval      A_DDCLTY  = S_SCLP
     C                   Eval      A_DDCLTY2 = S_SCLP
     C                   endif
      *
      ** - Settlement Currency
      *
     C                   Eval      A_DDSETC  = S_SCCY                                       O_SETC
      *
      ** - REALLOWANCE
      ** If not nil format with Price Decimal places  (9,5)  ????
      *
     C                   If        O_RALL  > 0
     C                   Movel     O_RALL        W_0905
     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
     c                   Eval      W_0905  = *blank
     C                   Endif
     c                   Eval      A_DDRALL = *blank                                          ???
      *
      ** - Market Center
      *
     C                   Eval      A_DDMRKT  = O_TMKC
      *
      ** - Capacity
      ** Capacity May not be required ????
      *
     C                   Movel     O_TCAP        A_DDCPCY
     c                   Eval      A_DDCPCY = *blank                                          ???
      *
      ** - Price
      ** If not nil format with Price Decimal places  (15,8) ???
      *
     C                   If        O_PRIC > 0
     C                   Movel     O_PRIC        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
     c                   Eval      A_DDPRIC = *blank                                          ???
      *
      ** - Ex Dividend
      *
     C                   Eval      A_DDEXDV = *Blank                                          O_EXDV
      *
      ** - Fiscal Price
      ** If not nil format with Price Decimal places  (15,8)    ???
      *
     C                   If        O_FSPR > 0
     C                   Movel     O_FSPR        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
     c                   Eval      A_DDFSPR = *blank                                            ???
      *
      ** - Book profit center
      *
     C                   Eval      A_DDBPRC  = O_BPRC
      *
      ** - Trans profit center
      *
     C                   Eval      A_DDTPRC  = O_TPRC
      *
      ** - Trader ID
      *
     C                   Eval      A_DDTDID  = O_TDID
      *
      ** - Trade date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDDT
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDDT
      *
      ** - Trade Sub type
      *
     C                   Eval      A_DDTSUB  = O_TSUB
      *
      ** - Link Ref  Never on duplication
      *
     C                   Eval      A_DDLKRF = *blank                                          O_LKRF
      *
      ** - Market indicator  ????
      *
     C                   Eval      A_DDTDMI = O_TDMI
      *
      ** - ISMA / IPMA
      **  Not sure AIIP must be taken ????
      *
     C                   Eval      A_DDAIIP = O_AIIP
      *
      ** - Narrative
      *
     C                   Eval      A_DDTDNR = O_TDNR
      *
      ** - P order number never on replication
      ** Will never be from TOF
      *
     C                   Eval      A_DDORDE  = *Blank
      *
      ** - Accrued indicator
      *
     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
      *
      ** - Days Adj/sign
      *
     C                   If        O_DADJ > 0
     C                   Movel     O_DADJ        A_DDDADJ
     C                   Endif
     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
      *
      ** - Act/Diff Ind
      *
     C                   Eval      A_DDACTD  =  *Blank
      *
      ** - Int Amnr/Sign
      ** If not nil format with Nominal currncy position ????
      *
     C                   If        O_ITRA > 0
     C                   Move      O_ITRA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDITRA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDITRA  = *blank                                          ????
     C                   clear                   W_ChgL
      *
      ** - Origin
      *
     C                   Eval      A_DDINOR  = *Blank
      *
      ** - Message Key
      *
     C                   Eval      A_DDMSGK  = *Blank
      *
      ** - Notification method
      *
     C                   Eval      A_DDNTMT  = *Blank
      *
      ** Ignoring following block
      *
     C                   Eval      A_DDNOM1  = *Blank
     C                   Eval      A_DDTDV1  = *Blank
     C                   Eval      A_DDACI1  = *Blank
     C                   Eval      A_DDDAD1  = *Blank
     C                   Eval      A_DDACT1  = *Blank
     C                   Eval      A_DDITR1  = *Blank
      *
      ** - Exchange rate
      ** If not nil format with rate Decimal places  (13,8)
      *
     C                   If        O_TDER > 0
     C                   Movel     O_TDER        W_1308
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
     c                   Eval      A_DDTDER = *blank                                            ???
      *
      ** - Exchange rateM/D
      *
     C                   Eval      A_DDSMDI  = *Blank
      *
      ** - Margin
      *
     C                   Eval      A_DDFXMP  = *Blank
      *
      ** - Base currency rate
      *
     C                   Eval      A_DDBRTE  = *Blank
      *
      ** Settlement field are left blank
      *
     C                   If        O_TDTP    = 'TS'
     C                   Move      S_SRSM        A_DDSMTH
     C                   Else
     C                   Move      S_SPSM        A_DDSMTH
     C                   endif
     C                   Eval      A_DDORBR  = *Blank
     C                   If        O_TDTP    = 'TS'
     C                   Eval      A_DDPYFM  = *Blank
     C                   Else
     C                   Eval      A_DDPYFM  = S_SPAT
     C                   endif
     C                   Eval      A_DDPFSN  = *Blank
     C                   Eval      A_DDPFNM  = *Blank
     C                   Eval      A_DDPFTN  = *Blank
     C                   Eval      A_DDPFAN  = *Blank
     C                   Eval      A_DDPFSW  = *Blank
     C                   Eval      A_DDPYFB  = *Blank
     C                   If        O_TDTP    = 'TP'
     C                   Eval      A_DDPAYT  = *Blank
     C                   Else
     C                   Eval      A_DDPAYT  = S_SRAC
     C                   endif
     C                   Eval      A_DDPTSN  = *Blank
     C                   Eval      A_DDPTNM  = *Blank
     C                   Eval      A_DDPTTN  = *Blank
     C                   Eval      A_DDPTAN  = *Blank
     C                   Eval      A_DDPTSI  = *Blank
     C                   Eval      A_DDPYTB  = *Blank
     C                   Eval      A_DDTDFA  = *Blank
     C                   Eval      A_DDFASN  = *Blank
     C                   Eval      A_DDFANM  = *Blank
     C                   Eval      A_DDFATN  = *Blank
     C                   Eval      A_DDFASW  = *Blank
     C                   Eval      A_DDASNM  = *Blank
     C                   Eval      A_DDDELF  = S_SDFO
     C                   Eval      A_DDDFSN  = *Blank
     C                   Eval      A_DDDFNM  = *Blank
     C                   Eval      A_DDDFTN  = *Blank
     C                   Eval      A_DDDFSI  = *Blank
     C                   Eval      A_DDDELT  = S_SDTO
     C                   Eval      A_DDDTSN  = *Blank
     C                   Eval      A_DDDTNM  = *Blank
     C                   Eval      A_DDDTTN  = *Blank
     C                   Eval      A_DDDTSI  = *Blank
     C                   Eval      A_DDDFFA  = *Blank
     C                   Eval      A_DDD1SN  = *Blank
     C                   Eval      A_DDD1NM  = *Blank
     C                   Eval      A_DDD1TN  = *Blank
     C                   Eval      A_DDD1SI  = *Blank
     C                   Eval      A_DDDTFA  = *Blank
     C                   Eval      A_DDD2SN  = *Blank
     C                   Eval      A_DDD2NM  = *Blank
     C                   Eval      A_DDD2TN  = *Blank
     C                   Eval      A_DDD2SI  = *Blank
     C                   Eval      A_DDTDSI  = *Blank
      *
      ** - In Currency in F72
      *
     C                   Eval      A_DDICCY  = *blank
      *
      ** - Profit Center
      *
     C                   Eval      A_DDPRFC  = *blank                                         O_PRFC
      *
      ** - Priority code
      *
     C                   Eval      A_DDPRYC  = *blank                                         O_PRYC
      *
      ** - Pay Code
      *
     C                   If        O_TDTP    = 'TS'
     C                   Eval      A_DDPCOD  = S_SPCS
     C                   Else
     C                   Eval      A_DDPCOD  = S_SPCP
     C                   endif
      *
      ** - Auto settle ind
      *
     C                   Eval      A_DDAUTS  = S_SASI
      *
      ** - Brok Comm code
      *
     C                   Eval      A_DDTBCC  =  O_TBCC
      *
      ** - Brok Com Amount
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TBCA > 0
     C                   Move      O_TBCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTBCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust com code
      *
     C                   Eval      A_DDTCCC  = O_TCCC
      *
      ** - Cust Comm Amount
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCCA > 0
     C                   Move      O_TCCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 1
      *
     C                   Eval      A_DDTCC1  = O_TCC1
      *
      ** - Chg Amount 1
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA1 > 0
     C                   Move      O_TCA1        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA1  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 2
      *
     C                   Eval      A_DDTCC2  = O_TCC2
      *
      ** - Chg Amount 2
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA2 > 0
     C                   Move      O_TCA2        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA2  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 3
      *
     C                   Eval      A_DDTCC3  = O_TCC3
      *
      ** - Chg Amount 3
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA3 > 0
     C                   Move      O_TCA3        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA3  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 4
      *
     C                   Eval      A_DDTCC4  = O_TCC4
      *
      ** - Chg Amount 4
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA4 > 0
     C                   Move      O_TCA4        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA4  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 5
      *
     C                   Eval      A_DDTCC5  = O_TCC5
      *
      ** - Chg Amount 5
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA5 > 0
     C                   Move      O_TCA5        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA5  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 6
      *
     C                   Eval      A_DDTCC6  = O_TCC6
      *
      ** - Chg Amount 6
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA6 > 0
     C                   Move      O_TCA6        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA6  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 7
      *
     C                   Eval      A_DDTCC7  = O_TCC7
      *
      ** - Chg Amount 7
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA7 > 0
     C                   Move      O_TCA7        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA7  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax amount    always blank on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TAXA > 0
     C                   Move      O_TAXA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTAXA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTAXA  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** EU tax amount in nominall currency always balnk on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_EUTX > 0
     C                   Move      O_EUTX        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDEUTX  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDEUTX  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** - Brok Comm  Rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_BCMR > 0
     C                   Move      O_BCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDBCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust Comm rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_CCMR > 0
     C                   Move      O_CCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDCCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax rebate always blank on replication
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TXRB > 0
     C                   Move      O_TXRB        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTXRB  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTXRB  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** - Portfolio reference Always Blank on replication
      *
     C                   Eval      A_DDPTFR   = *Blank
      *
      ** Extension file TRADSDX1  Not sure it needs to be setup
      *
      ** Settlement Message Request
      *
     C                   Eval      A_ADDGMES  = *Blank
      *
      ** Time of Trade
      *
     C                   Eval      A_ADDTRTT  = *Blank
      *
      ** Instructions Type
      *
     C                   Eval      A_ADDINST  = *Blank                                 O_T1INST
      *
      ** Instructions sub-type
      *
     C                   Eval      A_ADDINSS  = *Blank                                O_T1INSS
      *
      ** Euroclear/Cedel code
      *
     C                   Eval      A_ADDEUCL  = *Blank                                  O_T1EUCL
      *
      ** Safekeeping Account (MT580)
      *
     C                   Eval      A_ADDSAFA  = *Blank                                  O_T1SAFA
      *
      ** Requested Priority
      *
     C                   Eval      A_ADDRPTY  = *Blank                                  O_T1RPTY
      *
      ** Guaranteed Delivery
      *
     C                   Eval      A_ADDGDEL  = *Blank
      *
      ** Sender's Role
      *
     C                   Eval      A_ADDSROL  = *Blank
      *
      ** Fungibilty Code
      *
     C                   Eval      A_ADDFCOD  = *Blank
      *
      ** Fungible Trade Indicator
      *
     C                   Eval      A_ADDFTID  = *Blank
      *
      ** Confirmation Message Request
      *
     C                   Eval      A_ADDGMEC  = *Blank
      *
      ** Customer/Counterparty Ind.
      *
     C                   Eval      A_ADDCCID  = *Blank
      *
      ** Further Id.
      *
     C                   Eval      A_ADDFID1  = *Blank
      *
      ** Standard Instructions' Overr  ?
      *
     C                   Eval      A_ADDIORA  = *Blank
      *
      ** ISO15022 Messages Ind.
      *
     C                   Eval      A_ADDSNEW  = *Blank
      *
      ** Stamp Status
      *
     C                   Eval      A_ADDSTMP  = *Blank
      *
      ** Charity Identifier
      *
     C                   Eval      A_ADDCHID  = *Blank
      *
      ** Transaction Report Marker
      *
     C                   Eval      A_ADDTRRM  =  *Blank
      *
      ** Ignore following block
      *
     C                   Eval      A_BDDGMES  =  *Blank
     C                   Eval      A_BDDTRTT  =  *Blank
     C                   Eval      A_BDDINST   = *Blank
     C                   Eval      A_BDDINSS   = *Blank
     C                   Eval      A_BDDEUCL   = *Blank
     C                   Eval      A_BDDSAFA   = *Blank
     C                   Eval      A_BDDRPTY   = *Blank
     C                   Eval      A_BDDGDEL   = *Blank
     C                   Eval      A_BDDSROL   = *Blank
     C                   Eval      A_BDDFCOD   = *Blank
     C                   Eval      A_BDDFTID   = *Blank
     C                   Eval      A_BDDGMEC   = *Blank
     C                   Eval      A_BDDCCID   = *Blank
     C                   Eval      A_BDDFID1   = *Blank
     C                   Eval      A_BDDIORA   = *Blank
     C                   Eval      A_BDDSNEW   = *Blank
     C                   Eval      A_BDDSTMP   = *Blank
     C                   Eval      A_BDDCHID   = *Blank
     C                   Eval      A_BDDTRRM   = *Blank
      *
      ** Ignore following block
      *
     C                   Eval      A_AESAP1N   = *Blank
     C                   Eval      A_DDA1SN    = *Blank
     C                   Eval      A_DDA1NM    = *Blank
     C                   Eval      A_DDA1TN    = *Blank
     C                   Eval      A_DDA1SI    = *Blank
     C                   Eval      A_AESAP1L   = *Blank
     C                   Eval      A_AESAP2N   = *Blank
     C                   Eval      A_DDA2SN   =  *Blank
     C                   Eval      A_DDA2NM   =  *Blank
     C                   Eval      A_DDA2TN   =  *Blank
     C                   Eval      A_DDA2SI   =  *Blank
     C                   Eval      A_AESAP2L  =  *Blank
     C                   Eval      A_AESAWIN  =  *Blank
     C                   Eval      A_DDAISN   =  *Blank
     C                   Eval      A_DDAINM   =  *Blank
     C                   Eval      A_DDAITN   =  *Blank
     C                   Eval      A_DDAISI   =  *Blank
     C                   Eval      A_AESAWIL  =  *Blank
     C                   Eval      A_AESBOFN  =  *Blank
     C                   Eval      A_DDBMSN   =  *Blank
     C                   Eval      A_DDBMNM   =  *Blank
     C                   Eval      A_DDBMTN   =  *Blank
     C                   Eval      A_DDBMSI   =  *Blank
     C                   Eval      A_AESBOF1  =  *Blank
     C                   Eval      A_AESBOF2  =  *Blank
     C                   Eval      A_AESACL1  =  *Blank
     C                   Eval      A_AESACL2  =  *Blank
     C                   Eval      A_AESSRL1  =  *Blank
     C                   Eval      A_AESSRL2  =  *Blank
     C                   Eval      A_AESSRL3  =  *Blank
     C                   Eval      A_AESFIN1  =  *Blank
     C                   Eval      A_AESFIN2   = *Blank
     C                   Eval      A_AESRED1   = *Blank
     C                   Eval      A_AESRED2   = *Blank
     C                   Eval      A_AESNAL1   = *Blank
     C                   Eval      A_AESNAL2   = *Blank
     C                   Eval      A_AESIPYN   = *Blank
     C                   Eval      A_DDIPSN    = *Blank
     C                   Eval      A_DDIPNM    = *Blank
     C                   Eval      A_DDIPTN    = *Blank
     C                   Eval      A_DDIPSI    = *Blank
     C                   Eval      A_AESIPYL   = *Blank
     C                   Eval      A_AESCTYN   = *Blank
     C                   Eval      A_AESCTYL   = *Blank
     C                   Eval      A_AESSA1N   = *Blank
     C                   Eval      A_DDCZSN    = *Blank
     C                   Eval      A_DDCSNM    = *Blank
     C                   Eval      A_DDCSTN    = *Blank
     C                   Eval      A_DDCSSI    = *Blank
     C                   Eval      A_AESSA1L   = *Blank
     C                   Eval      A_AESSKAN   = *Blank
     C                   Eval      A_DDUSSN    = *Blank
     C                   Eval      A_DDUSNM    = *Blank
     C                   Eval      A_DDUSTN    = *Blank
     C                   Eval      A_DDUSSI    = *Blank
     C                   Eval      A_AESSKAL   = *Blank
     C                   Eval      A_AESCCTN   = *Blank
     C                   Eval      A_DDCCSN    = *Blank
     C                   Eval      A_DDCCNM    = *Blank
     C                   Eval      A_DDCCTN    = *Blank
     C                   Eval      A_DDCCSI    = *Blank
     C                   Eval      A_AESDCTL   = *Blank
     C                   Eval      A_AESRSSN   = *Blank
     C                   Eval      A_DDRSSN    = *Blank
     C                   Eval      A_DDRSNM    = *Blank
     C                   Eval      A_DDRSTN    = *Blank
     C                   Eval      A_DDRSSI    = *Blank
     C                   Eval      A_AESRSS1   = *Blank
     C                   Eval      A_AESRSS2   = *Blank
     C                   Eval      A_AESRSS3   = *Blank
     C                   Eval      A_AESRSS4   = *Blank
     C                   Eval      A_AESDSSN   = *Blank
     C                   Eval      A_AESDSS1   = *Blank
     C                   Eval      A_AESDSS2   = *Blank
     C                   Eval      A_AESDSS3   = *Blank
     C                   Eval      A_AESDSS4   = *Blank
     C                   Eval      A_AESBSSN   = *Blank
     C                   Eval      A_AESBSS1   = *Blank
     C                   Eval      A_AESBSS2   = *Blank
     C                   Eval      A_AESINVE   = *Blank
     C                   Eval      A_DDIOSN    = *Blank
     C                   Eval      A_DDIONM    = *Blank
     C                   Eval      A_DDIOTN    = *Blank
     C                   Eval      A_DDIOSI    = *Blank
     C                   Eval      A_AESIMMD1  = *Blank
     C                   Eval      A_DDI1SN    = *Blank
     C                   Eval      A_DDI1NM    = *Blank
     C                   Eval      A_DDI1TN    = *Blank
     C                   Eval      A_DDI1SI    = *Blank
     C                   Eval      A_AESIMSA1  = *Blank
     C                   Eval      A_AESIMMD2  = *Blank
     C                   Eval      A_DDI2SN    = *Blank
     C                   Eval      A_DDI2NM    = *Blank
     C                   Eval      A_DDI2TN    = *Blank
     C                   Eval      A_DDI2SI    = *Blank
     C                   Eval      A_AESIMSA2  = *Blank
     C                   Eval      A_AESIMMD3  = *Blank
     C                   Eval      A_AESIMSA3  = *Blank
     C                   Eval      A_AESIMMD4  = *Blank
     C                   Eval      A_AESIMSA4  = *Blank
     C                   Eval      A_AESIMMD5  = *Blank
     C                   Eval      A_AESIMSA5  = *Blank
     C                   Eval      A_AESIMMD6  = *Blank
     C                   Eval      A_AESIMSA6  = *Blank
     C                   Eval      A_AESIMMD7  = *Blank
     C                   Eval      A_AESIMSA7  = *Blank
     C                   Eval      A_AESIMMD8  = *Blank
     C                   Eval      A_AESIMSA8  = *Blank
     C                   Eval      A_AESIMMD9  = *Blank
     C                   Eval      A_AESIMSA9  = *Blank
     C                   Eval      A_AESPSET   = *Blank
     C                   Eval      A_DDPSSN    = *Blank
     C                   Eval      A_DDPSNM    = *Blank
     C                   Eval      A_DDPSTN    = *Blank
     C                   Eval      A_DDPSSI    = *Blank
     C                   Eval      A_AESNAC1   = *Blank
     C                   Eval      A_AESNAC2   = *Blank
     C                   Eval      A_AESDIDN   = *Blank
     C                   Eval      A_AESDAD1   = *Blank
     C                   Eval      A_AESDAD2   = *Blank
     C                   Eval      A_AESDAD3   = *Blank
     C                   Eval      A_AESDAD4   = *Blank
     C                   Eval      A_AESDLIN   = *Blank
     C                   Eval      A_AESQFIN   = *Blank
     C                   Eval      A_AESPCLR   = *Blank
     C                   Eval      A_BESAP1N   = *Blank
     C                   Eval      A_BDA1SN    = *Blank
     C                   Eval      A_BDA1NM   =  *Blank
     C                   Eval      A_BDA1TN   =  *Blank
     C                   Eval      A_BDA1SI   =  *Blank
     C                   Eval      A_BESAP1L  =  *Blank
     C                   Eval      A_BESAP2N  =  *Blank
     C                   Eval      A_BDA2SN   =  *Blank
     C                   Eval      A_BDA2NM   =  *Blank
     C                   Eval      A_BDA2TN   =  *Blank
     C                   Eval      A_BDA2SI   =  *Blank
     C                   Eval      A_BESAP2L  =  *Blank
     C                   Eval      A_BESAWIN  =  *Blank
     C                   Eval      A_BDAISN   =  *Blank
     C                   Eval      A_BDAINM   =  *Blank
     C                   Eval      A_BDAITN   =  *Blank
     C                   Eval      A_BDAISI   =  *Blank
     C                   Eval      A_BESAWIL  =  *Blank
     C                   Eval      A_BESBOFN  =  *Blank
     C                   Eval      A_BDBMSN   =  *Blank
     C                   Eval      A_BDBMNM   =  *Blank
     C                   Eval      A_BDBMTN   =  *Blank
     C                   Eval      A_BDBMSI   =  *Blank
     C                   Eval      A_BESBOF1  =  *Blank
     C                   Eval      A_BESBOF2  =  *Blank
     C                   Eval      A_BESACL1  =  *Blank
     C                   Eval      A_BESACL2   = *Blank
     C                   Eval      A_BESSRL1   = *Blank
     C                   Eval      A_BESSRL2   = *Blank
     C                   Eval      A_BESSRL3   = *Blank
     C                   Eval      A_BESFIN1   = *Blank
     C                   Eval      A_BESFIN2   = *Blank
     C                   Eval      A_BESRED1   = *Blank
     C                   Eval      A_BESRED2   = *Blank
     C                   Eval      A_BESNAL1   = *Blank
     C                   Eval      A_BESNAL2   = *Blank
     C                   Eval      A_BESIPYN   = *Blank
     C                   Eval      A_BDIPSN    = *Blank
     C                   Eval      A_BDIPNM    = *Blank
     C                   Eval      A_BDIPTN    = *Blank
     C                   Eval      A_BDIPSI    = *Blank
     C                   Eval      A_BESIPYL   = *Blank
     C                   Eval      A_BESCTYN   = *Blank
     C                   Eval      A_BESCTYL   = *Blank
     C                   Eval      A_BESSA1N   = *Blank
     C                   Eval      A_BDCZSN    = *Blank
     C                   Eval      A_BDCSNM    = *Blank
     C                   Eval      A_BDCSTN    = *Blank
     C                   Eval      A_BDCSSI    = *Blank
     C                   Eval      A_BESSA1L   = *Blank
     C                   Eval      A_BESSKAN   = *Blank
     C                   Eval      A_BDUSSN    = *Blank
     C                   Eval      A_BDUSNM    = *Blank
     C                   Eval      A_BDUSTN    = *Blank
     C                   Eval      A_BDUSSI    = *Blank
     C                   Eval      A_BESSKAL   = *Blank
     C                   Eval      A_BESCCTN   = *Blank
     C                   Eval      A_BDCCSN    = *Blank
     C                   Eval      A_BDCCNM    = *Blank
     C                   Eval      A_BDCCTN    = *Blank
     C                   Eval      A_BDCCSI    = *Blank
     C                   Eval      A_BESDCTL   = *Blank
     C                   Eval      A_BESRSSN   = *Blank
     C                   Eval      A_BDRSSN    = *Blank
     C                   Eval      A_BDRSNM    = *Blank
     C                   Eval      A_BDRSTN    = *Blank
     C                   Eval      A_BDRSSI    = *Blank
     C                   Eval      A_BESRSS1   = *Blank
     C                   Eval      A_BESRSS2   = *Blank
     C                   Eval      A_BESRSS3   = *Blank
     C                   Eval      A_BESRSS4   = *Blank
     C                   Eval      A_BESDSSN   = *Blank
     C                   Eval      A_BESDSS1   = *Blank
     C                   Eval      A_BESDSS2   = *Blank
     C                   Eval      A_BESDSS3   = *Blank
     C                   Eval      A_BESDSS4   = *Blank
     C                   Eval      A_BESBSSN   = *Blank
     C                   Eval      A_BESBSS1   = *Blank
     C                   Eval      A_BESBSS2   = *Blank
     C                   Eval      A_BESINVE   = *Blank
     C                   Eval      A_BDIOSN    = *Blank
     C                   Eval      A_BDIONM    = *Blank
     C                   Eval      A_BDIOTN    = *Blank
     C                   Eval      A_BDIOSI    = *Blank
     C                   Eval      A_BESIMMD1  = *Blank
     C                   Eval      A_BDI1SN    = *Blank
     C                   Eval      A_BDI1NM    = *Blank
     C                   Eval      A_BDI1TN    = *Blank
     C                   Eval      A_BDI1SI    = *Blank
     C                   Eval      A_BESIMSA1  = *Blank
     C                   Eval      A_BESIMMD2  = *Blank
     C                   Eval      A_BDI2SN    = *Blank
     C                   Eval      A_BDI2NM    = *Blank
     C                   Eval      A_BDI2TN    = *Blank
     C                   Eval      A_BDI2SI    = *Blank
     C                   Eval      A_BESIMSA2  =  *Blank
     C                   Eval      A_BESIMMD3  =  *Blank
     C                   Eval      A_BESIMSA3  =  *Blank
     C                   Eval      A_BESIMMD4   = *Blank
     C                   Eval      A_BESIMSA4   = *Blank
     C                   Eval      A_BESIMMD5   = *Blank
     C                   Eval      A_BESIMSA5   = *Blank
     C                   Eval      A_BESIMMD6   = *Blank
     C                   Eval      A_BESIMSA6   = *Blank
     C                   Eval      A_BESIMMD7   = *Blank
     C                   Eval      A_BESIMSA7   = *Blank
     C                   Eval      A_BESIMMD8   = *Blank
     C                   Eval      A_BESIMSA8   = *Blank
     C                   Eval      A_BESIMMD9   = *Blank
     C                   Eval      A_BESIMSA9   = *Blank
     C                   Eval      A_BESPSET    = *Blank
     C                   Eval      A_BDPSSN     = *Blank
     C                   Eval      A_BDPSNM     = *Blank
     C                   Eval      A_BDPSTN     = *Blank
     C                   Eval      A_BDPSSI     = *Blank
     C                   Eval      A_BESNAC1    = *Blank
     C                   Eval      A_BESNAC2    = *Blank
     C                   Eval      A_BESDIDN    = *Blank
     C                   Eval      A_BESDAD1    = *Blank
     C                   Eval      A_BESDAD2    = *Blank
     C                   Eval      A_BESDAD3    = *Blank
     C                   Eval      A_BESDAD4    = *Blank
     C                   Eval      A_BESDLIN   =  *Blank
     C                   Eval      A_BESQFIN   =  *Blank
     C                   Eval      A_BESPCLR   =  *Blank
     C                   Eval      A_DDCRSK    =  *Blank
     C                   Eval      A_DDLQPR    =  *Blank
     C                   Eval      A_DDITRN    =  *Blank
     C                   Eval      A_TMSP      =  *Blank
     C                   Eval      A_BDSPBS    =  *Blank
     C                   Eval      A_STBS      =  *Blank
     C                   Eval      A_PROT      =  *Blank
     C                   Eval      A_NMCY      =  *Blank
     C                   Eval      A_C1DI      =  *Blank
     C                   Eval      A_BVAUTH    =  *Blank
     C                   Eval      A_DDCPNR    = *Blank
     C                   Eval      A_DDTCTR    = *Blank
     C                   Eval      A_DDCFCT    = *Blank
     C                   Eval      A_ADDROUS   = *Blank
     C                   Eval      A_ADDROTS   = *Blank
     C                   Eval      A_ADDROUC   = *Blank
     C                   Eval      A_ADDROTC   = *Blank
     C                   Eval      A_BDDROUS   = *Blank
     C                   Eval      A_BDDROTS   = *Blank
     C                   Eval      A_BDDROUC   = *Blank
     C                   Eval      A_BDDROTC   = *Blank
     C                   Eval      A_DDSPXR   =  *Blank
     C                   Eval      A_DDSPMD   =  *Blank
     C                   Eval      A_DDWTAX   =  *Blank
     C                   Eval      A_BKEURO   =  *Blank
     C                   Eval      A_DDSTAT   =  *Blank
      *
      ** Auto authorise indicator ???
      *
     C                   Eval      A_DDAUTH   =  FNAUTH
     C                   Eval      A_SITP     =  *Blank
     C                   Eval      A_DDPRICN  =  *Blank
     C                   Eval      A_DDHACR   =  *Blank
     C                   Eval      A_DDTCSR   =  *Blank
     C                   Eval      A_DDDAYS   =  *Blank
     C                   Eval      A_DDFOID   =  *Blank
     C                   Eval      A_TQTAX    =  *Blank
     C                   Eval      A_TQSTAF   =  *Blank
     C                   Eval      A_TQCDTE   =  *Blank
      *
      ** Auto authorise indicator
      *
     C                   Eval      A_AUTH     =  FNAUTH
      *
      ** Tof Fioller
      *
     C                   Eval      A_TOFfil   =  *Blank
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataA       Begsr
     C                   Clear                   ApDtmsg
      *
      ** - API action
      *
     C                   Eval      A_DDACTN  = 'C'
      *
      ** - Trade reference
      *
     C                   Eval      A_DDTDRF  = C_TDRF
      *
      ** - Bulk reference
      *
     C                   Eval      A_DDBLKR  = C_BLKR
      *
      ** - Client Number
      *
     C                   Eval      A_DDCNUM  = C_TCNR
      *
      ** - Security short name
      *
     C                   Eval      A_DDSESN  = C_TDSS
      *
      ** - Customer shortname
      *
     C                   Eval      A_DDCSSN  = *blank
      *
      ** - Customer report name
      *
     C                   Eval      A_DDCRNM  = *blank
      *
      ** - Customer report town
      *
     C                   Eval      A_DDCRTN  = *blank
      *
      ** - Incomplete indicator
      *
     C                   Eval      A_DDINCS  = O_TINC
      *
      ** - Trade type
      *
     C                   Eval      A_DDTDTP  = O_TDTP
      *
      ** - Nominal
      ** Format nominal amount based on Nominal decimal plases
      *
     C                   Move      O_NOML        W_NOML
      *
      ** Remove leading Zero
      *
     C                   If        W_N1 = '0' or W_N1 = ' '
     C                   Eval      W_N1 = *blank
     C                   If        W_N2 = '0' or W_N2 = ' '
     C                   Eval      W_N2 = *blank
     C                   If        W_N3 = '0' or W_N3 = ' '
     C                   Eval      W_N3 = *blank
     C                   If        W_N4 = '0' or W_N4 = ' '
     C                   Eval      W_N4 = *blank
     C                   If        W_N5 = '0' or W_N5 = ' '
     C                   Eval      W_N5 = *blank
     C                   If        W_N6 = '0' or W_N6 = ' '
     C                   Eval      W_N6 = *blank
     C                   If        W_N7 = '0' or W_N7 = ' '
     C                   Eval      W_N7 = *blank
     C                   If        W_N8 = '0' or W_N8 = ' '
     C                   Eval      W_N8 = *blank
     C                   If        W_N9 = '0' or W_N9 = ' '
     C                   Eval      W_N9 = *blank
     C                   If        W_N10 = '0' or W_N10 = ' '
     C                   Eval      W_N10 = *blank
     C                   If        W_N11 = '0' or W_N11 = ' '
     C                   Eval      W_N11 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        TNMD = 0
     C                   Eval      A_DDNOML  = %trim(W_NOML0)
     C                   Endif
     C                   If        TNMD = 1
     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
     C                   Endif
     C                   If        TNMD = 2
     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
     C                   Endif
     C                   If        TNMD = 3
     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
     C                   Endif
     C                   If        TNMD = 4
     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
     C                   Endif
      *
      ** - Price/Disc/Yield
      ** If not nil format with Price Decimal places  (15,8)
      *
     C                   If        O_TPDY  > 0
     C                   Movel     O_TPDY        W_1508
      *
      ** Remove leading Zero
      *
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Value Date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDVD
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDVD
      *
      ** - Booking Branch
      ** Overwrite branch to consolidated branch
      *
     C                   Eval      A_DDBRCD  = FNBRCA
      *
      ** - Book
      *
     C                   Eval      A_DDBPBK  = C_TDBK
      *
      ** - Clearance type
      *
     C                   Eval      A_DDCLTY  = C_CLTY                                        O_CLTY
     C                   Eval      A_DDCLTY2 = C_CLTY                                        O_CLTY
      *
      ** - Settlement Currency
      *
     C                   Eval      A_DDSETC  = C_SETC                                        O_SETC
      *
      ** - REALLOWANCE
      ** If not nil format with Price Decimal places  (9,5)  ????
      *
     C                   If        O_RALL  > 0
     C                   Movel     O_RALL        W_0905
     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
     c                   Eval      W_0905  = *blank
     C                   Endif
      *
      ** - Market Center
      *
     C                   Eval      A_DDMRKT  = O_TMKC
      *
      ** - Capacity
      ** Capacity May not be required ????
      *
     C                   Movel     O_TCAP        A_DDCPCY
      *
      ** - Price
      ** If not nil format with Price Decimal places  (15,8) ???
      *
     C                   If        O_PRIC > 0
     C                   Movel     O_PRIC        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
     C                   Eval      A_DDPRIC   = GHSUBS
      *
      ** - Ex Dividend
      *
     C                   Eval      A_DDEXDV = C_EXDV                                          O_EXDV
      *
      ** - Fiscal Price
      ** If not nil format with Price Decimal places  (15,8)    ???
      *
     C                   If        O_FSPR > 0
     C                   Movel     O_FSPR        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
     C                   Movel     WrSUBS        A_DDFSPR
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Book profit center
      *
     C                   Eval      A_DDBPRC  = O_BPRC
      *
      ** - Trans profit center
      *
     C                   Eval      A_DDTPRC  = O_TPRC
      *
      ** - Trader ID
      *
     C                   Eval      A_DDTDID  = O_TDID
      *
      ** - Trade date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDDT
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDDT
      *
      ** - Trade Sub type
      *
     C                   Eval      A_DDTSUB  = O_TSUB
      *
      ** - Link Ref  Never on duplication
      *
     C                   Eval      A_DDLKRF = C_LKRF                                          O_LKRF
      *
      ** - Market indicator  ????
      *
     C                   Eval      A_DDTDMI = C_TDMI                                          O_TDMI
      *
      ** - ISMA / IPMA
      **  Not sure AIIP must be taken ????
      *
     C                   Eval      A_DDAIIP = C_AIIP                                          O_AIIP
      *
      ** - Narrative
      *
     C                   Eval      A_DDTDNR = O_TDNR                                          O_TDNR
      *
      ** - P order number never on replication
      ** Will never be from TOF
      *
     C                   Eval      A_DDORDE  = *Blank
      *
      ** - Accrued indicator
      *
     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
      *
      ** - Days Adj/sign
      *
     C                   If        O_DADJ > 0
     C                   Movel     O_DADJ        A_DDDADJ
     C                   Endif
     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
      *
      ** - Act/Diff Ind
      *
     C                   Eval      A_DDACTD  =  *Blank
      *
      ** - Int Amnr/Sign
      ** If not nil format with Nominal currncy position ????
      *
     C                   If        O_ITRA > 0
     C                   Move      O_ITRA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDITRA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Movel     WrSUBS        A_DDITRA
     C                   clear                   W_ChgL
      *
      ** - Origin
      *
     C                   Eval      A_DDINOR  = *blank
      *
      ** - Message Key
      *
     C                   Eval      A_DDMSGK  = *blank
      *
      ** - Notification method
      *
     C                   Eval      A_DDNTMT  = *blank
      *
      ** Ignoring following block
      *
     C                   Eval      A_DDNOM1  = *blank
     C                   Eval      A_DDTDV1  = *blank
     C                   Eval      A_DDACI1  = *blank
     C                   Eval      A_DDDAD1  = *blank
     C                   Eval      A_DDACT1  = *blank
     C                   Eval      A_DDITR1  = *blank
      *
      ** - Exchange rate
      ** If not nil format with rate Decimal places  (13,8)
      *
     C                   If        O_TDER > 0
     C                   Movel     O_TDER        W_1308
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Exchange rateM/D
      *
     C                   Eval      A_DDSMDI  = *blank
      *
      ** - Margin
      *
     C                   Eval      A_DDFXMP  = *blank
      *
      ** - Base currency rate
      *
     C                   Eval      A_DDBRTE  = *blank
      *
      ** Settlement field are left unchanged
      *
     C                   Movel     C_SMTH        A_DDSMTH
     C                   Eval      A_DDORBR  = C_ORBR
     C                   Eval      A_DDPYFM  = C_PYFM
     C                   Eval      A_DDPFSN  = *blank
     C                   Eval      A_DDPFNM  = *blank
     C                   Eval      A_DDPFTN  = *blank
     C                   Eval      A_DDPFAN  = *blank
     C                   Eval      A_DDPFSW  = *blank
     C                   Eval      A_DDPYFB  = *blank
     C                   Eval      A_DDPAYT  = C_PAYT
     C                   Eval      A_DDPTSN  = *blank
     C                   Eval      A_DDPTNM  = *blank
     C                   Eval      A_DDPTTN  = *blank
     C                   Eval      A_DDPTAN  = *blank
     C                   Eval      A_DDPTSI  = *blank
     C                   Eval      A_DDPYTB  = *blank
     C                   Eval      A_DDTDFA  = *blank
     C                   Eval      A_DDFASN  = *blank
     C                   Eval      A_DDFANM  = *blank
     C                   Eval      A_DDFATN  = *blank
     C                   Eval      A_DDFASW  = *blank
     C                   Eval      A_DDASNM  = *blank
     C                   Eval      A_DDDELF  = C_DELF
     C                   Eval      A_DDDFSN  = *blank
     C                   Eval      A_DDDFNM  = *blank
     C                   Eval      A_DDDFTN  = *blank
     C                   Eval      A_DDDFSI  = *blank
     C                   Eval      A_DDDELT  = C_DELT
     C                   Eval      A_DDDTSN  = *blank
     C                   Eval      A_DDDTNM  = *blank
     C                   Eval      A_DDDTTN  = *blank
     C                   Eval      A_DDDTSI  = *blank
     C                   Eval      A_DDDFFA  = *blank
     C                   Eval      A_DDD1SN  = *blank
     C                   Eval      A_DDD1NM  = *blank
     C                   Eval      A_DDD1TN  = *blank
     C                   Eval      A_DDD1SI  = *blank
     C                   Eval      A_DDDTFA  = *blank
     C                   Eval      A_DDD2SN  = *blank
     C                   Eval      A_DDD2NM  = *blank
     C                   Eval      A_DDD2TN  = *blank
     C                   Eval      A_DDD2SI  = *blank
     C                   Eval      A_DDTDSI  = *blank
      *
      ** - In Currency in F72
      *
     C                   Eval      A_DDICCY  = C_ICCY                                         O_ICCY
      *
      ** - Profit Center
      *
     C                   Eval      A_DDPRFC  = C_PRFC                                         O_PRFC
      *
      ** - Priority code
      *
     C                   Movel     WrSUBS        A_DDPRYC
      *
      ** - Pay Code
      *
     C                   Eval      A_DDPCOD  = C_PCOD                                         O_PCOD
      *
      ** - Auto settle ind
      *
     C                   Eval      A_DDAUTS  = 'Y'
      *
      ** - Brok Comm code
      *
     C                   Eval      A_DDTBCC  =  O_TBCC
      *
      ** - Brok Com Amount
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TBCA > 0
     C                   Move      O_TBCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTBCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust com code
      *
     C                   Eval      A_DDTCCC  = O_TCCC
      *
      ** - Cust Comm Amount
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TCCA > 0
     C                   Move      O_TCCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 1
      *
     C                   Eval      A_DDTCC1  = O_TCC1
      *
      ** - Chg Amount 1
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA1 > 0
     C                   Move      O_TCA1        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA1  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 2
      *
     C                   Eval      A_DDTCC2  = O_TCC2
      *
      ** - Chg Amount 2
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA2 > 0
     C                   Move      O_TCA2        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA2  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 3
      *
     C                   Eval      A_DDTCC3  = O_TCC3
      *
      ** - Chg Amount 3
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TCA3 > 0
     C                   Move      O_TCA3        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA3  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 4
      *
     C                   Eval      A_DDTCC4  = O_TCC4
      *
      ** - Chg Amount 4
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA4 > 0
     C                   Move      O_TCA4        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA4  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 5
      *
     C                   Eval      A_DDTCC5  = O_TCC5
      *
      ** - Chg Amount 5
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA5 > 0
     C                   Move      O_TCA5        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA5  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 6
      *
     C                   Eval      A_DDTCC6  = O_TCC6
      *
      ** - Chg Amount 6
      ** If not nil format with Nominal currncy position
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA6 > 0
     C                   Move      O_TCA6        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA6  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 7
      *
     C                   Eval      A_DDTCC7  = O_TCC7
      *
      ** - Chg Amount 7
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA7 > 0
     C                   Move      O_TCA7        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA7  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax amount    always blank on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TAXA > 0
     C                   Move      O_TAXA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTAXA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTAXA  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** EU tax amount in nominall currency always balnk on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_EUTX > 0
     C                   Move      O_EUTX        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDEUTX  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDEUTX  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** - Brok Comm  Rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_BCMR > 0
     C                   Move      O_BCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDBCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust Comm rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_CCMR > 0
     C                   Move      O_CCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDCCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax rebate always blank on replication
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TXRB > 0
     C                   Move      O_TXRB        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTXRB  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Portfolio reference Always Blank on replication
      *
     C                   Eval      A_DDPTFR   = C_PTFR
      *
      ** Extension file TRADSDX1  Not sure it needs to be setup
      *
      ** Settlement Message Request
      *
     C                   Eval      A_ADDGMES  = *blank
      *
      ** Time of Trade
      *
     C                   Eval      A_ADDTRTT  = *blank
      *
      ** Instructions Type
      *
     C                   Eval      A_ADDINST  = C_T1INST
      *
      ** Instructions sub-type
      *
     C                   Eval      A_ADDINSS  = C_T1INSS
      *
      ** Euroclear/Cedel code
      *
     C                   Eval      A_ADDEUCL  = C_T1EUCL
      *
      ** Safekeeping Account (MT580)
      *
     C                   Eval      A_ADDSAFA  = C_T1SAFA
      *
      ** Requested Priority
      *
     C                   Eval      A_ADDRPTY  = C_T1RPTY
      *
      ** Guaranteed Delivery
      *
     C                   Eval      A_ADDGDEL  = *blank
      *
      ** Sender's Role
      *
     C                   Eval      A_ADDSROL  = *blank
      *
      ** Fungibilty Code
      *
     C                   Eval      A_ADDFCOD  = *blank
      *
      ** Fungible Trade Indicator
      *
     C                   Eval      A_ADDFTID  = *blank
      *
      ** Confirmation Message Request
      *
     C                   Eval      A_ADDGMEC  = *blank
      *
      ** Customer/Counterparty Ind.
      *
     C                   Eval      A_ADDCCID  = *blank
      *
      ** Further Id.
      *
     C                   Eval      A_ADDFID1  = *blank
      *
      ** Standard Instructions' Overr  ?
      *
     C                   Eval      A_ADDIORA  = *blank
      *
      ** ISO15022 Messages Ind.
      *
     C                   Eval      A_ADDSNEW  = *blank
      *
      ** Stamp Status
      *
     C                   Eval      A_ADDSTMP  = *blank
      *
      ** Charity Identifier
      *
     C                   Eval      A_ADDCHID  = *blank
      *
      ** Transaction Report Marker
      *
     C                   Eval      A_ADDTRRM  = *blank
      *
      ** Ignore following block
      *
     C                   Eval      A_BDDGMES  = *blank
     C                   Eval      A_BDDTRTT  = *blank
     C                   Eval      A_BDDINST   =*blank
     C                   Eval      A_BDDINSS   =*blank
     C                   Eval      A_BDDEUCL   =*blank
     C                   Eval      A_BDDSAFA   = *blank
     C                   Eval      A_BDDRPTY   = *blank
     C                   Eval      A_BDDGDEL   = *blank
     C                   Eval      A_BDDSROL   = *blank
     C                   Eval      A_BDDFCOD   = *blank
     C                   Eval      A_BDDFTID   = *blank
     C                   Eval      A_BDDGMEC   = *blank
     C                   Eval      A_BDDCCID   = *blank
     C                   Eval      A_BDDFID1   = *blank
     C                   Eval      A_BDDIORA   = *blank
     C                   Eval      A_BDDSNEW   = *blank
     C                   Eval      A_BDDSTMP   = *blank
     C                   Eval      A_BDDCHID   = *blank
     C                   Eval      A_BDDTRRM   = *blank
     C                   Eval      A_AESAP1N   = *blank
     C                   Eval      A_DDA1SN    = *blank
     C                   Eval      A_DDA1NM    = *blank
     C                   Eval      A_DDA1TN    = *blank
     C                   Eval      A_DDA1SI    = *blank
     C                   Eval      A_AESAP1L   = *blank
     C                   Eval      A_AESAP2N   = *blank
     C                   Eval      A_DDA2SN   =  *blank
     C                   Eval      A_DDA2NM   =  *blank
     C                   Eval      A_DDA2TN   =  *blank
     C                   Eval      A_DDA2SI   =  *blank
     C                   Eval      A_AESAP2L  =  *blank
     C                   Eval      A_AESAWIN  =  *blank
     C                   Eval      A_DDAISN   =  *blank
     C                   Eval      A_DDAINM   =  *blank
     C                   Eval      A_DDAITN   =  *blank
     C                   Eval      A_DDAISI   =  *blank
     C                   Eval      A_AESAWIL  =  *blank
     C                   Eval      A_AESBOFN  =  *blank
     C                   Eval      A_DDBMSN   =  *blank
     C                   Eval      A_DDBMNM   =  *blank
     C                   Eval      A_DDBMTN   =  *blank
     C                   Eval      A_DDBMSI   =  *blank
     C                   Eval      A_AESBOF1  =  *blank
     C                   Eval      A_AESBOF2  =  *blank
     C                   Eval      A_AESACL1  =  *blank
     C                   Eval      A_AESACL2  =  *blank
     C                   Eval      A_AESSRL1  =  *blank
     C                   Eval      A_AESSRL2  =  *blank
     C                   Eval      A_AESSRL3  =  *blank
     C                   Eval      A_AESFIN1  =  *blank
     C                   Eval      A_AESFIN2   = *blank
     C                   Eval      A_AESRED1   = *blank
     C                   Eval      A_AESRED2   = *blank
     C                   Eval      A_AESNAL1   = *blank
     C                   Eval      A_AESNAL2   = *blank
     C                   Eval      A_AESIPYN   = *blank
     C                   Eval      A_DDIPSN    = *blank
     C                   Eval      A_DDIPNM    = *blank
     C                   Eval      A_DDIPTN    = *blank
     C                   Eval      A_DDIPSI    = *blank
     C                   Eval      A_AESIPYL   = *blank
     C                   Eval      A_AESCTYN   = *blank
     C                   Eval      A_AESCTYL   = *blank
     C                   Eval      A_AESSA1N   = *blank
     C                   Eval      A_DDCZSN    = *blank
     C                   Eval      A_DDCSNM    = *blank
     C                   Eval      A_DDCSTN    = *blank
     C                   Eval      A_DDCSSI    = *blank
     C                   Eval      A_AESSA1L   = *blank
     C                   Eval      A_AESSKAN   = *blank
     C                   Eval      A_DDUSSN    = *blank
     C                   Eval      A_DDUSNM    = *blank
     C                   Eval      A_DDUSTN    = *blank
     C                   Eval      A_DDUSSI    = *blank
     C                   Eval      A_AESSKAL   = *blank
     C                   Eval      A_AESCCTN   = *blank
     C                   Eval      A_DDCCSN    = *blank
     C                   Eval      A_DDCCNM    = *blank
     C                   Eval      A_DDCCTN    = *blank
     C                   Eval      A_DDCCSI    = *blank
     C                   Eval      A_AESDCTL   = *blank
     C                   Eval      A_AESRSSN   = *blank
     C                   Eval      A_DDRSSN    = *blank
     C                   Eval      A_DDRSNM    = *blank
     C                   Eval      A_DDRSTN    = *blank
     C                   Eval      A_DDRSSI    = *blank
     C                   Eval      A_AESRSS1   = *blank
     C                   Eval      A_AESRSS2   = *blank
     C                   Eval      A_AESRSS3   = *blank
     C                   Eval      A_AESRSS4   = *blank
     C                   Eval      A_AESDSSN   = *blank
     C                   Eval      A_AESDSS1   = *blank
     C                   Eval      A_AESDSS2   = *blank
     C                   Eval      A_AESDSS3   = *blank
     C                   Eval      A_AESDSS4   = *blank
     C                   Eval      A_AESBSSN   = *blank
     C                   Eval      A_AESBSS1   = *blank
     C                   Eval      A_AESBSS2   = *blank
     C                   Eval      A_AESINVE   = *blank
     C                   Eval      A_DDIOSN    = *blank
     C                   Eval      A_DDIONM    = *blank
     C                   Eval      A_DDIOTN    = *blank
     C                   Eval      A_DDIOSI    = *blank
     C                   Eval      A_AESIMMD1  = *blank
     C                   Eval      A_DDI1SN    = *blank
     C                   Eval      A_DDI1NM    = *blank
     C                   Eval      A_DDI1TN    = *blank
     C                   Eval      A_DDI1SI    = *blank
     C                   Eval      A_AESIMSA1  = *blank
     C                   Eval      A_AESIMMD2  = *blank
     C                   Eval      A_DDI2SN    = *blank
     C                   Eval      A_DDI2NM    = *blank
     C                   Eval      A_DDI2TN    = *blank
     C                   Eval      A_DDI2SI    = *blank
     C                   Eval      A_AESIMSA2  = *blank
     C                   Eval      A_AESIMMD3  = *blank
     C                   Eval      A_AESIMSA3  = *blank
     C                   Eval      A_AESIMMD4  = *blank
     C                   Eval      A_AESIMSA4  = *blank
     C                   Eval      A_AESIMMD5  = *blank
     C                   Eval      A_AESIMSA5  = *blank
     C                   Eval      A_AESIMMD6  = *blank
     C                   Eval      A_AESIMSA6  = *blank
     C                   Eval      A_AESIMMD7  = *blank
     C                   Eval      A_AESIMSA7  = *blank
     C                   Eval      A_AESIMMD8  = *blank
     C                   Eval      A_AESIMSA8  = *blank
     C                   Eval      A_AESIMMD9  = *blank
     C                   Eval      A_AESIMSA9  = *blank
     C                   Eval      A_AESPSET   = *blank
     C                   Eval      A_DDPSSN    = *Blank
     C                   Eval      A_DDPSNM    = *Blank
     C                   Eval      A_DDPSTN    = *Blank
     C                   Eval      A_DDPSSI    = *Blank
     C                   Eval      A_AESNAC1   = *Blank
     C                   Eval      A_AESNAC2   = *Blank
     C                   Eval      A_AESDIDN   = *Blank
     C                   Eval      A_AESDAD1   = *Blank
     C                   Eval      A_AESDAD2   = *Blank
     C                   Eval      A_AESDAD3   = *Blank
     C                   Eval      A_AESDAD4   = *Blank
     C                   Eval      A_AESDLIN   = *Blank
     C                   Eval      A_AESQFIN   = *Blank
     C                   Eval      A_AESPCLR   = *Blank
     C                   Eval      A_BESAP1N   = *Blank
     C                   Eval      A_BDA1SN    = *Blank
     C                   Eval      A_BDA1NM   =  *Blank
     C                   Eval      A_BDA1TN   =  *Blank
     C                   Eval      A_BDA1SI   =  *Blank
     C                   Eval      A_BESAP1L  =  *Blank
     C                   Eval      A_BESAP2N  =  *Blank
     C                   Eval      A_BDA2SN   =  *Blank
     C                   Eval      A_BDA2NM   =  *blank
     C                   Eval      A_BDA2TN   =  *blank
     C                   Eval      A_BDA2SI   =  *blank
     C                   Eval      A_BESAP2L  =  *blank
     C                   Eval      A_BESAWIN  =  *blank
     C                   Eval      A_BDAISN   =  *blank
     C                   Eval      A_BDAINM   =  *blank
     C                   Eval      A_BDAITN   =  *blank
     C                   Eval      A_BDAISI   =  *blank
     C                   Eval      A_BESAWIL  =  *blank
     C                   Eval      A_BESBOFN  =  *blank
     C                   Eval      A_BDBMSN   =  *blank
     C                   Eval      A_BDBMNM   =  *blank
     C                   Eval      A_BDBMTN   =  *blank
     C                   Eval      A_BDBMSI   =  *blank
     C                   Eval      A_BESBOF1  =  *blank
     C                   Eval      A_BESBOF2  =  *blank
     C                   Eval      A_BESACL1  =  *blank
     C                   Eval      A_BESACL2   = *blank
     C                   Eval      A_BESSRL1   = *blank
     C                   Eval      A_BESSRL2   = *blank
     C                   Eval      A_BESSRL3   = *blank
     C                   Eval      A_BESFIN1   = *blank
     C                   Eval      A_BESFIN2   = *blank
     C                   Eval      A_BESRED1   = *blank
     C                   Eval      A_BESRED2   = *blank
     C                   Eval      A_BESNAL1   = *blank
     C                   Eval      A_BESNAL2   = *blank
     C                   Eval      A_BESIPYN   = *blank
     C                   Eval      A_BDIPSN    = *blank
     C                   Eval      A_BDIPNM    = *blank
     C                   Eval      A_BDIPTN    = *blank
     C                   Eval      A_BDIPSI    = *blank
     C                   Eval      A_BESIPYL   = *blank
     C                   Eval      A_BESCTYN   = *blank
     C                   Eval      A_BESCTYL   = *blank
     C                   Eval      A_BESSA1N   = *blank
     C                   Eval      A_BDCZSN    = *blank
     C                   Eval      A_BDCSNM    = *blank
     C                   Eval      A_BDCSTN    = *blank
     C                   Eval      A_BDCSSI    = *blank
     C                   Eval      A_BESSA1L   = *blank
     C                   Eval      A_BESSKAN   = *blank
     C                   Eval      A_BDUSSN    = *blank
     C                   Eval      A_BDUSNM    = *blank
     C                   Eval      A_BDUSTN    = *blank
     C                   Eval      A_BDUSSI    = *blank
     C                   Eval      A_BESSKAL   = *blank
     C                   Eval      A_BESCCTN   = *blank
     C                   Eval      A_BDCCSN    = *blank
     C                   Eval      A_BDCCNM    = *blank
     C                   Eval      A_BDCCTN    = *blank
     C                   Eval      A_BDCCSI    = *blank
     C                   Eval      A_BESDCTL   = *blank
     C                   Eval      A_BESRSSN   = *blank
     C                   Eval      A_BDRSSN    = *blank
     C                   Eval      A_BDRSNM    = *blank
     C                   Eval      A_BDRSTN    = *blank
     C                   Eval      A_BDRSSI    = *blank
     C                   Eval      A_BESRSS1   = *blank
     C                   Eval      A_BESRSS2   = *blank
     C                   Eval      A_BESRSS3   = *blank
     C                   Eval      A_BESRSS4   = *blank
     C                   Eval      A_BESDSSN   = *blank
     C                   Eval      A_BESDSS1   = *blank
     C                   Eval      A_BESDSS2   = *blank
     C                   Eval      A_BESDSS3   = *blank
     C                   Eval      A_BESDSS4   = *blank
     C                   Eval      A_BESBSSN   = *blank
     C                   Eval      A_BESBSS1   = *blank
     C                   Eval      A_BESBSS2   = *blank
     C                   Eval      A_BESINVE   = *blank
     C                   Eval      A_BDIOSN    = *blank
     C                   Eval      A_BDIONM    = *blank
     C                   Eval      A_BDIOTN    = *blank
     C                   Eval      A_BDIOSI    = *blank
     C                   Eval      A_BESIMMD1  = *blank
     C                   Eval      A_BDI1SN    = *blank
     C                   Eval      A_BDI1NM    = *blank
     C                   Eval      A_BDI1TN    = *blank
     C                   Eval      A_BDI1SI    = *blank
     C                   Eval      A_BESIMSA1  = *blank
     C                   Eval      A_BESIMMD2  = *blank
     C                   Eval      A_BDI2SN    = *blank
     C                   Eval      A_BDI2NM    = *blank
     C                   Eval      A_BDI2TN    = *blank
     C                   Eval      A_BDI2SI    = *blank
     C                   Eval      A_BESIMSA2  = *blank
     C                   Eval      A_BESIMMD3  = *blank
     C                   Eval      A_BESIMSA3  = *blank
     C                   Eval      A_BESIMMD4   =*blank
     C                   Eval      A_BESIMSA4   =*blank
     C                   Eval      A_BESIMMD5   =*blank
     C                   Eval      A_BESIMSA5   =*blank
     C                   Eval      A_BESIMMD6   =*blank
     C                   Eval      A_BESIMSA6   =*blank
     C                   Eval      A_BESIMMD7   = *blank
     C                   Eval      A_BESIMSA7   = *blank
     C                   Eval      A_BESIMMD8   = *blank
     C                   Eval      A_BESIMSA8   = *blank
     C                   Eval      A_BESIMMD9   = *blank
     C                   Eval      A_BESIMSA9   = *blank
     C                   Eval      A_BESPSET    = *blank
     C                   Eval      A_BDPSSN     = *blank
     C                   Eval      A_BDPSNM     = *blank
     C                   Eval      A_BDPSTN     = *blank
     C                   Eval      A_BDPSSI     = *blank
     C                   Eval      A_BESNAC1    = *blank
     C                   Eval      A_BESNAC2    = *blank
     C                   Eval      A_BESDIDN    = *blank
     C                   Eval      A_BESDAD1    = *blank
     C                   Eval      A_BESDAD2    = *blank
     C                   Eval      A_BESDAD3    = *blank
     C                   Eval      A_BESDAD4    = *blank
     C                   Eval      A_BESDLIN   =  *blank
     C                   Eval      A_BESQFIN   =  *blank
     C                   Eval      A_BESPCLR   =  *blank
     C                   Eval      A_DDCRSK    =  *blank
     C                   Eval      A_DDLQPR    =  *blank
     C                   Eval      A_DDITRN    = *blank
     C                   Eval      A_TMSP      = *blank
     C                   Eval      A_BDSPBS    = *blank
     C                   Eval      A_STBS      = *blank
     C                   Eval      A_PROT      = *blank
     C                   Eval      A_NMCY      = *blank
     C                   Eval      A_C1DI      = *blank
     C                   Eval      A_BVAUTH    = *blank
     C                   Eval      A_DDCPNR    = *blank
     C                   Eval      A_DDTCTR    = *blank
     C                   Eval      A_DDCFCT    = *blank
     C                   Eval      A_ADDROUS   = *blank
     C                   Eval      A_ADDROTS   = *blank
     C                   Eval      A_ADDROUC   = *blank
     C                   Eval      A_ADDROTC   = *blank
     C                   Eval      A_BDDROUS   = *blank
     C                   Eval      A_BDDROTS   = *blank
     C                   Eval      A_BDDROUC   = *blank
     C                   Eval      A_BDDROTC   = *blank
     C                   Eval      A_DDSPXR   =  *blank
     C                   Eval      A_DDSPMD   =  *blank
     C                   Eval      A_DDWTAX   =  *blank
     C                   Eval      A_BKEURO   =  *blank
     C                   Eval      A_DDSTAT   =  *blank
     C                   Eval      A_DDAUTH   =  FNAUTH
     C                   Eval      A_SITP     =  *blank
     C                   Eval      A_DDPRICN  =  *blank
     C                   Eval      A_DDHACR   =  *blank
     C                   Eval      A_DDTCSR   =  *blank
     C                   Eval      A_DDDAYS   =  *blank
     C                   Eval      A_DDFOID   =  *blank
     C                   Eval      A_TQTAX    =  *blank
     C                   Eval      A_TQSTAF   =  *blank
     C                   Eval      A_TQCDTE   =  *blank
     C                   Eval      A_AUTH     =  FNAUTH
     C                   Eval      A_TOFfil   =  *Blank
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataA2      Begsr
     C                   Clear                   ApDtmsg
      *
      ** - API action
      *
     C                   Eval      A_DDACTN  = 'C'
      *
      ** - Trade reference
      *
     C                   Eval      A_DDTDRF  = C2TDRF
      *
      ** - Bulk reference
      *
     C                   Eval      A_DDBLKR  = C2BLKR
      *
      ** - Client Number
      *
     C                   Eval      A_DDCNUM  = C2TCNR
      *
      ** - Security short name
      *
     C                   Eval      A_DDSESN  = C2TDSS
      *
      ** - Customer shortname
      *
     C                   Eval      A_DDCSSN  = *blank
      *
      ** - Customer report name
      *
     C                   Eval      A_DDCRNM  = *blank
      *
      ** - Customer report town
      *
     C                   Eval      A_DDCRTN  = *blank
      *
      ** - Incomplete indicator
      *
     C                   Eval      A_DDINCS  = O_TINC
      *
      ** - Trade type
      *
     C                   Eval      A_DDTDTP  = O_TDTP
      *
      ** - Nominal
      ** Format nominal amount based on Nominal decimal plases
      *
     C                   Move      O_NOML        W_NOML
      *
      ** Remove leading Zero
      *
     C                   If        W_N1 = '0' or W_N1 = ' '
     C                   Eval      W_N1 = *blank
     C                   If        W_N2 = '0' or W_N2 = ' '
     C                   Eval      W_N2 = *blank
     C                   If        W_N3 = '0' or W_N3 = ' '
     C                   Eval      W_N3 = *blank
     C                   If        W_N4 = '0' or W_N4 = ' '
     C                   Eval      W_N4 = *blank
     C                   If        W_N5 = '0' or W_N5 = ' '
     C                   Eval      W_N5 = *blank
     C                   If        W_N6 = '0' or W_N6 = ' '
     C                   Eval      W_N6 = *blank
     C                   If        W_N7 = '0' or W_N7 = ' '
     C                   Eval      W_N7 = *blank
     C                   If        W_N8 = '0' or W_N8 = ' '
     C                   Eval      W_N8 = *blank
     C                   If        W_N9 = '0' or W_N9 = ' '
     C                   Eval      W_N9 = *blank
     C                   If        W_N10 = '0' or W_N10 = ' '
     C                   Eval      W_N10 = *blank
     C                   If        W_N11 = '0' or W_N11 = ' '
     C                   Eval      W_N11 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        TNMD = 0
     C                   Eval      A_DDNOML  = %trim(W_NOML0)
     C                   Endif
     C                   If        TNMD = 1
     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
     C                   Endif
     C                   If        TNMD = 2
     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
     C                   Endif
     C                   If        TNMD = 3
     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
     C                   Endif
     C                   If        TNMD = 4
     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
     C                   Endif
      *
      ** - Price/Disc/Yield
      ** If not nil format with Price Decimal places  (15,8)
      *
     C                   If        O_TPDY  > 0
     C                   Movel     O_TPDY        W_1508
      *
      ** Remove leading Zero
      *
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Value Date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDVD
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDVD
      *
      ** - Booking Branch
      ** Overwrite branch to consolidated branch
      *
     C                   Eval      A_DDBRCD  = FNBRCA
      *
      ** - Book
      *
     C                   Eval      A_DDBPBK  = C2TDBK
      *
      ** - Clearance type
      *
     C                   Eval      A_DDCLTY  = C2CLTY                                        O_CLTY
     C                   Eval      A_DDCLTY2 = C2CLTY                                        O_CLTY
      *
      ** - Settlement Currency
      *
     C                   Eval      A_DDSETC  = C2SETC                                        O_SETC
      *
      ** - REALLOWANCE
      ** If not nil format with Price Decimal places  (9,5)  ????
      *
     C                   If        O_RALL  > 0
     C                   Movel     O_RALL        W_0905
     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
     c                   Eval      W_0905  = *blank
     C                   Endif
      *
      ** - Market Center
      *
     C                   Eval      A_DDMRKT  = O_TMKC
      *
      ** - Capacity
      ** Capacity May not be required ????
      *
     C                   Movel     O_TCAP        A_DDCPCY
      *
      ** - Price
      ** If not nil format with Price Decimal places  (15,8) ???
      *
     C                   If        O_PRIC > 0
     C                   Movel     O_PRIC        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
     C                   Eval      A_DDPRIC   = GHSUBS
      *
      ** - Ex Dividend
      *
     C                   Eval      A_DDEXDV = C2EXDV                                          O_EXDV
      *
      ** - Fiscal Price
      ** If not nil format with Price Decimal places  (15,8)    ???
      *
     C                   If        O_FSPR > 0
     C                   Movel     O_FSPR        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
     C                   Movel     WrSUBS        A_DDFSPR
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Book profit center
      *
     C                   Eval      A_DDBPRC  = O_BPRC
      *
      ** - Trans profit center
      *
     C                   Eval      A_DDTPRC  = O_TPRC
      *
      ** - Trader ID
      *
     C                   Eval      A_DDTDID  = O_TDID
      *
      ** - Trade date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDDT
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDDT
      *
      ** - Trade Sub type
      *
     C                   Eval      A_DDTSUB  = O_TSUB
      *
      ** - Link Ref  Never on duplication
      *
     C                   Eval      A_DDLKRF = C2LKRF                                          O_LKRF
      *
      ** - Market indicator  ????
      *
     C                   Eval      A_DDTDMI = C2TDMI                                          O_TDMI
      *
      ** - ISMA / IPMA
      **  Not sure AIIP must be taken ????
      *
     C                   Eval      A_DDAIIP = C2AIIP                                          O_AIIP
      *
      ** - Narrative
      *
     C                   Eval      A_DDTDNR = O_TDNR                                          O_TDNR
      *
      ** - P order number never on replication
      ** Will never be from TOF
      *
     C                   Eval      A_DDORDE  = *Blank
      *
      ** - Accrued indicator
      *
     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
      *
      ** - Days Adj/sign
      *
     C                   If        O_DADJ > 0
     C                   Movel     O_DADJ        A_DDDADJ
     C                   Endif
     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
      *
      ** - Act/Diff Ind
      *
     C                   Eval      A_DDACTD  =  *Blank
      *
      ** - Int Amnr/Sign
      ** If not nil format with Nominal currncy position ????
      *
     C                   If        O_ITRA > 0
     C                   Move      O_ITRA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDITRA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Movel     WrSUBS        A_DDITRA
     C                   clear                   W_ChgL
      *
      ** - Origin
      *
     C                   Eval      A_DDINOR  = *blank
      *
      ** - Message Key
      *
     C                   Eval      A_DDMSGK  = *blank
      *
      ** - Notification method
      *
     C                   Eval      A_DDNTMT  = *blank
      *
      ** Ignoring following block
      *
     C                   Eval      A_DDNOM1  = *blank
     C                   Eval      A_DDTDV1  = *blank
     C                   Eval      A_DDACI1  = *blank
     C                   Eval      A_DDDAD1  = *blank
     C                   Eval      A_DDACT1  = *blank
     C                   Eval      A_DDITR1  = *blank
      *
      ** - Exchange rate
      ** If not nil format with rate Decimal places  (13,8)
      *
     C                   If        O_TDER > 0
     C                   Movel     O_TDER        W_1308
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Exchange rateM/D
      *
     C                   Eval      A_DDSMDI  = *blank
      *
      ** - Margin
      *
     C                   Eval      A_DDFXMP  = *blank
      *
      ** - Base currency rate
      *
     C                   Eval      A_DDBRTE  = *blank
      *
      ** Settlement field are left unchanged
      *
     C                   Movel     C2SMTH        A_DDSMTH
     C                   Eval      A_DDORBR  = C2ORBR
     C                   Eval      A_DDPYFM  = C2PYFM
     C                   Eval      A_DDPFSN  = *blank
     C                   Eval      A_DDPFNM  = *blank
     C                   Eval      A_DDPFTN  = *blank
     C                   Eval      A_DDPFAN  = *blank
     C                   Eval      A_DDPFSW  = *blank
     C                   Eval      A_DDPYFB  = *blank
     C                   Eval      A_DDPAYT  = C2PAYT
     C                   Eval      A_DDPTSN  = *blank
     C                   Eval      A_DDPTNM  = *blank
     C                   Eval      A_DDPTTN  = *blank
     C                   Eval      A_DDPTAN  = *blank
     C                   Eval      A_DDPTSI  = *blank
     C                   Eval      A_DDPYTB  = *blank
     C                   Eval      A_DDTDFA  = *blank
     C                   Eval      A_DDFASN  = *blank
     C                   Eval      A_DDFANM  = *blank
     C                   Eval      A_DDFATN  = *blank
     C                   Eval      A_DDFASW  = *blank
     C                   Eval      A_DDASNM  = *blank
     C                   Eval      A_DDDELF  = C2DELF
     C                   Eval      A_DDDFSN  = *blank
     C                   Eval      A_DDDFNM  = *blank
     C                   Eval      A_DDDFTN  = *blank
     C                   Eval      A_DDDFSI  = *blank
     C                   Eval      A_DDDELT  = C2DELT
     C                   Eval      A_DDDTSN  = *blank
     C                   Eval      A_DDDTNM  = *blank
     C                   Eval      A_DDDTTN  = *blank
     C                   Eval      A_DDDTSI  = *blank
     C                   Eval      A_DDDFFA  = *blank
     C                   Eval      A_DDD1SN  = *blank
     C                   Eval      A_DDD1NM  = *blank
     C                   Eval      A_DDD1TN  = *blank
     C                   Eval      A_DDD1SI  = *blank
     C                   Eval      A_DDDTFA  = *blank
     C                   Eval      A_DDD2SN  = *blank
     C                   Eval      A_DDD2NM  = *blank
     C                   Eval      A_DDD2TN  = *blank
     C                   Eval      A_DDD2SI  = *blank
     C                   Eval      A_DDTDSI  = *blank
      *
      ** - In Currency in F72
      *
     C                   Eval      A_DDICCY  = C2ICCY                                         O_ICCY
      *
      ** - Profit Center
      *
     C                   Eval      A_DDPRFC  = C2PRFC                                         O_PRFC
      *
      ** - Priority code
      *
     C                   Movel     WrSUBS        A_DDPRYC
      *
      ** - Pay Code
      *
     C                   Eval      A_DDPCOD  = C2PCOD                                         O_PCOD
      *
      ** - Auto settle ind
      *
     C                   Eval      A_DDAUTS  = 'Y'
      *
      ** - Brok Comm code
      *
     C                   Eval      A_DDTBCC  =  O_TBCC
      *
      ** - Brok Com Amount
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TBCA > 0
     C                   Move      O_TBCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTBCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust com code
      *
     C                   Eval      A_DDTCCC  = O_TCCC
      *
      ** - Cust Comm Amount
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TCCA > 0
     C                   Move      O_TCCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 1
      *
     C                   Eval      A_DDTCC1  = O_TCC1
      *
      ** - Chg Amount 1
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA1 > 0
     C                   Move      O_TCA1        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA1  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 2
      *
     C                   Eval      A_DDTCC2  = O_TCC2
      *
      ** - Chg Amount 2
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA2 > 0
     C                   Move      O_TCA2        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA2  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 3
      *
     C                   Eval      A_DDTCC3  = O_TCC3
      *
      ** - Chg Amount 3
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TCA3 > 0
     C                   Move      O_TCA3        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA3  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 4
      *
     C                   Eval      A_DDTCC4  = O_TCC4
      *
      ** - Chg Amount 4
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA4 > 0
     C                   Move      O_TCA4        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA4  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 5
      *
     C                   Eval      A_DDTCC5  = O_TCC5
      *
      ** - Chg Amount 5
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA5 > 0
     C                   Move      O_TCA5        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA5  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 6
      *
     C                   Eval      A_DDTCC6  = O_TCC6
      *
      ** - Chg Amount 6
      ** If not nil format with Nominal currncy position
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA6 > 0
     C                   Move      O_TCA6        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA6  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 7
      *
     C                   Eval      A_DDTCC7  = O_TCC7
      *
      ** - Chg Amount 7
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA7 > 0
     C                   Move      O_TCA7        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA7  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax amount    always blank on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TAXA > 0
     C                   Move      O_TAXA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTAXA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTAXA  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** EU tax amount in nominall currency always balnk on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_EUTX > 0
     C                   Move      O_EUTX        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDEUTX  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDEUTX  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** - Brok Comm  Rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_BCMR > 0
     C                   Move      O_BCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDBCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust Comm rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_CCMR > 0
     C                   Move      O_CCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDCCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax rebate always blank on replication
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TXRB > 0
     C                   Move      O_TXRB        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTXRB  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Portfolio reference Always Blank on replication
      *
     C                   Eval      A_DDPTFR   = C2PTFR
      *
      ** Extension file TRADSDX1  Not sure it needs to be setup
      *
      ** Settlement Message Request
      *
     C                   Eval      A_ADDGMES  = *blank
      *
      ** Time of Trade
      *
     C                   Eval      A_ADDTRTT  = *blank
      *
      ** Instructions Type
      *
     C                   Eval      A_ADDINST  = C2T1INST
      *
      ** Instructions sub-type
      *
     C                   Eval      A_ADDINSS  = C2T1INSS
      *
      ** Euroclear/Cedel code
      *
     C                   Eval      A_ADDEUCL  = C2T1EUCL
      *
      ** Safekeeping Account (MT580)
      *
     C                   Eval      A_ADDSAFA  = C2T1SAFA
      *
      ** Requested Priority
      *
     C                   Eval      A_ADDRPTY  = C2T1RPTY
      *
      ** Guaranteed Delivery
      *
     C                   Eval      A_ADDGDEL  = *blank
      *
      ** Sender's Role
      *
     C                   Eval      A_ADDSROL  = *blank
      *
      ** Fungibilty Code
      *
     C                   Eval      A_ADDFCOD  = *blank
      *
      ** Fungible Trade Indicator
      *
     C                   Eval      A_ADDFTID  = *blank
      *
      ** Confirmation Message Request
      *
     C                   Eval      A_ADDGMEC  = *blank
      *
      ** Customer/Counterparty Ind.
      *
     C                   Eval      A_ADDCCID  = *blank
      *
      ** Further Id.
      *
     C                   Eval      A_ADDFID1  = *blank
      *
      ** Standard Instructions' Overr  ?
      *
     C                   Eval      A_ADDIORA  = *blank
      *
      ** ISO15022 Messages Ind.
      *
     C                   Eval      A_ADDSNEW  = *blank
      *
      ** Stamp Status
      *
     C                   Eval      A_ADDSTMP  = *blank
      *
      ** Charity Identifier
      *
     C                   Eval      A_ADDCHID  = *blank
      *
      ** Transaction Report Marker
      *
     C                   Eval      A_ADDTRRM  = *blank
      *
      ** Ignore following block
      *
     C                   Eval      A_BDDGMES  = *blank
     C                   Eval      A_BDDTRTT  = *blank
     C                   Eval      A_BDDINST   =*blank
     C                   Eval      A_BDDINSS   =*blank
     C                   Eval      A_BDDEUCL   =*blank
     C                   Eval      A_BDDSAFA   = *blank
     C                   Eval      A_BDDRPTY   = *blank
     C                   Eval      A_BDDGDEL   = *blank
     C                   Eval      A_BDDSROL   = *blank
     C                   Eval      A_BDDFCOD   = *blank
     C                   Eval      A_BDDFTID   = *blank
     C                   Eval      A_BDDGMEC   = *blank
     C                   Eval      A_BDDCCID   = *blank
     C                   Eval      A_BDDFID1   = *blank
     C                   Eval      A_BDDIORA   = *blank
     C                   Eval      A_BDDSNEW   = *blank
     C                   Eval      A_BDDSTMP   = *blank
     C                   Eval      A_BDDCHID   = *blank
     C                   Eval      A_BDDTRRM   = *blank
     C                   Eval      A_AESAP1N   = *blank
     C                   Eval      A_DDA1SN    = *blank
     C                   Eval      A_DDA1NM    = *blank
     C                   Eval      A_DDA1TN    = *blank
     C                   Eval      A_DDA1SI    = *blank
     C                   Eval      A_AESAP1L   = *blank
     C                   Eval      A_AESAP2N   = *blank
     C                   Eval      A_DDA2SN   =  *blank
     C                   Eval      A_DDA2NM   =  *blank
     C                   Eval      A_DDA2TN   =  *blank
     C                   Eval      A_DDA2SI   =  *blank
     C                   Eval      A_AESAP2L  =  *blank
     C                   Eval      A_AESAWIN  =  *blank
     C                   Eval      A_DDAISN   =  *blank
     C                   Eval      A_DDAINM   =  *blank
     C                   Eval      A_DDAITN   =  *blank
     C                   Eval      A_DDAISI   =  *blank
     C                   Eval      A_AESAWIL  =  *blank
     C                   Eval      A_AESBOFN  =  *blank
     C                   Eval      A_DDBMSN   =  *blank
     C                   Eval      A_DDBMNM   =  *blank
     C                   Eval      A_DDBMTN   =  *blank
     C                   Eval      A_DDBMSI   =  *blank
     C                   Eval      A_AESBOF1  =  *blank
     C                   Eval      A_AESBOF2  =  *blank
     C                   Eval      A_AESACL1  =  *blank
     C                   Eval      A_AESACL2  =  *blank
     C                   Eval      A_AESSRL1  =  *blank
     C                   Eval      A_AESSRL2  =  *blank
     C                   Eval      A_AESSRL3  =  *blank
     C                   Eval      A_AESFIN1  =  *blank
     C                   Eval      A_AESFIN2   = *blank
     C                   Eval      A_AESRED1   = *blank
     C                   Eval      A_AESRED2   = *blank
     C                   Eval      A_AESNAL1   = *blank
     C                   Eval      A_AESNAL2   = *blank
     C                   Eval      A_AESIPYN   = *blank
     C                   Eval      A_DDIPSN    = *blank
     C                   Eval      A_DDIPNM    = *blank
     C                   Eval      A_DDIPTN    = *blank
     C                   Eval      A_DDIPSI    = *blank
     C                   Eval      A_AESIPYL   = *blank
     C                   Eval      A_AESCTYN   = *blank
     C                   Eval      A_AESCTYL   = *blank
     C                   Eval      A_AESSA1N   = *blank
     C                   Eval      A_DDCZSN    = *blank
     C                   Eval      A_DDCSNM    = *blank
     C                   Eval      A_DDCSTN    = *blank
     C                   Eval      A_DDCSSI    = *blank
     C                   Eval      A_AESSA1L   = *blank
     C                   Eval      A_AESSKAN   = *blank
     C                   Eval      A_DDUSSN    = *blank
     C                   Eval      A_DDUSNM    = *blank
     C                   Eval      A_DDUSTN    = *blank
     C                   Eval      A_DDUSSI    = *blank
     C                   Eval      A_AESSKAL   = *blank
     C                   Eval      A_AESCCTN   = *blank
     C                   Eval      A_DDCCSN    = *blank
     C                   Eval      A_DDCCNM    = *blank
     C                   Eval      A_DDCCTN    = *blank
     C                   Eval      A_DDCCSI    = *blank
     C                   Eval      A_AESDCTL   = *blank
     C                   Eval      A_AESRSSN   = *blank
     C                   Eval      A_DDRSSN    = *blank
     C                   Eval      A_DDRSNM    = *blank
     C                   Eval      A_DDRSTN    = *blank
     C                   Eval      A_DDRSSI    = *blank
     C                   Eval      A_AESRSS1   = *blank
     C                   Eval      A_AESRSS2   = *blank
     C                   Eval      A_AESRSS3   = *blank
     C                   Eval      A_AESRSS4   = *blank
     C                   Eval      A_AESDSSN   = *blank
     C                   Eval      A_AESDSS1   = *blank
     C                   Eval      A_AESDSS2   = *blank
     C                   Eval      A_AESDSS3   = *blank
     C                   Eval      A_AESDSS4   = *blank
     C                   Eval      A_AESBSSN   = *blank
     C                   Eval      A_AESBSS1   = *blank
     C                   Eval      A_AESBSS2   = *blank
     C                   Eval      A_AESINVE   = *blank
     C                   Eval      A_DDIOSN    = *blank
     C                   Eval      A_DDIONM    = *blank
     C                   Eval      A_DDIOTN    = *blank
     C                   Eval      A_DDIOSI    = *blank
     C                   Eval      A_AESIMMD1  = *blank
     C                   Eval      A_DDI1SN    = *blank
     C                   Eval      A_DDI1NM    = *blank
     C                   Eval      A_DDI1TN    = *blank
     C                   Eval      A_DDI1SI    = *blank
     C                   Eval      A_AESIMSA1  = *blank
     C                   Eval      A_AESIMMD2  = *blank
     C                   Eval      A_DDI2SN    = *blank
     C                   Eval      A_DDI2NM    = *blank
     C                   Eval      A_DDI2TN    = *blank
     C                   Eval      A_DDI2SI    = *blank
     C                   Eval      A_AESIMSA2  = *blank
     C                   Eval      A_AESIMMD3  = *blank
     C                   Eval      A_AESIMSA3  = *blank
     C                   Eval      A_AESIMMD4  = *blank
     C                   Eval      A_AESIMSA4  = *blank
     C                   Eval      A_AESIMMD5  = *blank
     C                   Eval      A_AESIMSA5  = *blank
     C                   Eval      A_AESIMMD6  = *blank
     C                   Eval      A_AESIMSA6  = *blank
     C                   Eval      A_AESIMMD7  = *blank
     C                   Eval      A_AESIMSA7  = *blank
     C                   Eval      A_AESIMMD8  = *blank
     C                   Eval      A_AESIMSA8  = *blank
     C                   Eval      A_AESIMMD9  = *blank
     C                   Eval      A_AESIMSA9  = *blank
     C                   Eval      A_AESPSET   = *blank
     C                   Eval      A_DDPSSN    = *Blank
     C                   Eval      A_DDPSNM    = *Blank
     C                   Eval      A_DDPSTN    = *Blank
     C                   Eval      A_DDPSSI    = *Blank
     C                   Eval      A_AESNAC1   = *Blank
     C                   Eval      A_AESNAC2   = *Blank
     C                   Eval      A_AESDIDN   = *Blank
     C                   Eval      A_AESDAD1   = *Blank
     C                   Eval      A_AESDAD2   = *Blank
     C                   Eval      A_AESDAD3   = *Blank
     C                   Eval      A_AESDAD4   = *Blank
     C                   Eval      A_AESDLIN   = *Blank
     C                   Eval      A_AESQFIN   = *Blank
     C                   Eval      A_AESPCLR   = *Blank
     C                   Eval      A_BESAP1N   = *Blank
     C                   Eval      A_BDA1SN    = *Blank
     C                   Eval      A_BDA1NM   =  *Blank
     C                   Eval      A_BDA1TN   =  *Blank
     C                   Eval      A_BDA1SI   =  *Blank
     C                   Eval      A_BESAP1L  =  *Blank
     C                   Eval      A_BESAP2N  =  *Blank
     C                   Eval      A_BDA2SN   =  *Blank
     C                   Eval      A_BDA2NM   =  *blank
     C                   Eval      A_BDA2TN   =  *blank
     C                   Eval      A_BDA2SI   =  *blank
     C                   Eval      A_BESAP2L  =  *blank
     C                   Eval      A_BESAWIN  =  *blank
     C                   Eval      A_BDAISN   =  *blank
     C                   Eval      A_BDAINM   =  *blank
     C                   Eval      A_BDAITN   =  *blank
     C                   Eval      A_BDAISI   =  *blank
     C                   Eval      A_BESAWIL  =  *blank
     C                   Eval      A_BESBOFN  =  *blank
     C                   Eval      A_BDBMSN   =  *blank
     C                   Eval      A_BDBMNM   =  *blank
     C                   Eval      A_BDBMTN   =  *blank
     C                   Eval      A_BDBMSI   =  *blank
     C                   Eval      A_BESBOF1  =  *blank
     C                   Eval      A_BESBOF2  =  *blank
     C                   Eval      A_BESACL1  =  *blank
     C                   Eval      A_BESACL2   = *blank
     C                   Eval      A_BESSRL1   = *blank
     C                   Eval      A_BESSRL2   = *blank
     C                   Eval      A_BESSRL3   = *blank
     C                   Eval      A_BESFIN1   = *blank
     C                   Eval      A_BESFIN2   = *blank
     C                   Eval      A_BESRED1   = *blank
     C                   Eval      A_BESRED2   = *blank
     C                   Eval      A_BESNAL1   = *blank
     C                   Eval      A_BESNAL2   = *blank
     C                   Eval      A_BESIPYN   = *blank
     C                   Eval      A_BDIPSN    = *blank
     C                   Eval      A_BDIPNM    = *blank
     C                   Eval      A_BDIPTN    = *blank
     C                   Eval      A_BDIPSI    = *blank
     C                   Eval      A_BESIPYL   = *blank
     C                   Eval      A_BESCTYN   = *blank
     C                   Eval      A_BESCTYL   = *blank
     C                   Eval      A_BESSA1N   = *blank
     C                   Eval      A_BDCZSN    = *blank
     C                   Eval      A_BDCSNM    = *blank
     C                   Eval      A_BDCSTN    = *blank
     C                   Eval      A_BDCSSI    = *blank
     C                   Eval      A_BESSA1L   = *blank
     C                   Eval      A_BESSKAN   = *blank
     C                   Eval      A_BDUSSN    = *blank
     C                   Eval      A_BDUSNM    = *blank
     C                   Eval      A_BDUSTN    = *blank
     C                   Eval      A_BDUSSI    = *blank
     C                   Eval      A_BESSKAL   = *blank
     C                   Eval      A_BESCCTN   = *blank
     C                   Eval      A_BDCCSN    = *blank
     C                   Eval      A_BDCCNM    = *blank
     C                   Eval      A_BDCCTN    = *blank
     C                   Eval      A_BDCCSI    = *blank
     C                   Eval      A_BESDCTL   = *blank
     C                   Eval      A_BESRSSN   = *blank
     C                   Eval      A_BDRSSN    = *blank
     C                   Eval      A_BDRSNM    = *blank
     C                   Eval      A_BDRSTN    = *blank
     C                   Eval      A_BDRSSI    = *blank
     C                   Eval      A_BESRSS1   = *blank
     C                   Eval      A_BESRSS2   = *blank
     C                   Eval      A_BESRSS3   = *blank
     C                   Eval      A_BESRSS4   = *blank
     C                   Eval      A_BESDSSN   = *blank
     C                   Eval      A_BESDSS1   = *blank
     C                   Eval      A_BESDSS2   = *blank
     C                   Eval      A_BESDSS3   = *blank
     C                   Eval      A_BESDSS4   = *blank
     C                   Eval      A_BESBSSN   = *blank
     C                   Eval      A_BESBSS1   = *blank
     C                   Eval      A_BESBSS2   = *blank
     C                   Eval      A_BESINVE   = *blank
     C                   Eval      A_BDIOSN    = *blank
     C                   Eval      A_BDIONM    = *blank
     C                   Eval      A_BDIOTN    = *blank
     C                   Eval      A_BDIOSI    = *blank
     C                   Eval      A_BESIMMD1  = *blank
     C                   Eval      A_BDI1SN    = *blank
     C                   Eval      A_BDI1NM    = *blank
     C                   Eval      A_BDI1TN    = *blank
     C                   Eval      A_BDI1SI    = *blank
     C                   Eval      A_BESIMSA1  = *blank
     C                   Eval      A_BESIMMD2  = *blank
     C                   Eval      A_BDI2SN    = *blank
     C                   Eval      A_BDI2NM    = *blank
     C                   Eval      A_BDI2TN    = *blank
     C                   Eval      A_BDI2SI    = *blank
     C                   Eval      A_BESIMSA2  = *blank
     C                   Eval      A_BESIMMD3  = *blank
     C                   Eval      A_BESIMSA3  = *blank
     C                   Eval      A_BESIMMD4   =*blank
     C                   Eval      A_BESIMSA4   =*blank
     C                   Eval      A_BESIMMD5   =*blank
     C                   Eval      A_BESIMSA5   =*blank
     C                   Eval      A_BESIMMD6   =*blank
     C                   Eval      A_BESIMSA6   =*blank
     C                   Eval      A_BESIMMD7   = *blank
     C                   Eval      A_BESIMSA7   = *blank
     C                   Eval      A_BESIMMD8   = *blank
     C                   Eval      A_BESIMSA8   = *blank
     C                   Eval      A_BESIMMD9   = *blank
     C                   Eval      A_BESIMSA9   = *blank
     C                   Eval      A_BESPSET    = *blank
     C                   Eval      A_BDPSSN     = *blank
     C                   Eval      A_BDPSNM     = *blank
     C                   Eval      A_BDPSTN     = *blank
     C                   Eval      A_BDPSSI     = *blank
     C                   Eval      A_BESNAC1    = *blank
     C                   Eval      A_BESNAC2    = *blank
     C                   Eval      A_BESDIDN    = *blank
     C                   Eval      A_BESDAD1    = *blank
     C                   Eval      A_BESDAD2    = *blank
     C                   Eval      A_BESDAD3    = *blank
     C                   Eval      A_BESDAD4    = *blank
     C                   Eval      A_BESDLIN   =  *blank
     C                   Eval      A_BESQFIN   =  *blank
     C                   Eval      A_BESPCLR   =  *blank
     C                   Eval      A_DDCRSK    =  *blank
     C                   Eval      A_DDLQPR    =  *blank
     C                   Eval      A_DDITRN    = *blank
     C                   Eval      A_TMSP      = *blank
     C                   Eval      A_BDSPBS    = *blank
     C                   Eval      A_STBS      = *blank
     C                   Eval      A_PROT      = *blank
     C                   Eval      A_NMCY      = *blank
     C                   Eval      A_C1DI      = *blank
     C                   Eval      A_BVAUTH    = *blank
     C                   Eval      A_DDCPNR    = *blank
     C                   Eval      A_DDTCTR    = *blank
     C                   Eval      A_DDCFCT    = *blank
     C                   Eval      A_ADDROUS   = *blank
     C                   Eval      A_ADDROTS   = *blank
     C                   Eval      A_ADDROUC   = *blank
     C                   Eval      A_ADDROTC   = *blank
     C                   Eval      A_BDDROUS   = *blank
     C                   Eval      A_BDDROTS   = *blank
     C                   Eval      A_BDDROUC   = *blank
     C                   Eval      A_BDDROTC   = *blank
     C                   Eval      A_DDSPXR   =  *blank
     C                   Eval      A_DDSPMD   =  *blank
     C                   Eval      A_DDWTAX   =  *blank
     C                   Eval      A_BKEURO   =  *blank
     C                   Eval      A_DDSTAT   =  *blank
     C                   Eval      A_DDAUTH   =  FNAUTH
     C                   Eval      A_SITP     =  *blank
     C                   Eval      A_DDPRICN  =  *blank
     C                   Eval      A_DDHACR   =  *blank
     C                   Eval      A_DDTCSR   =  *blank
     C                   Eval      A_DDDAYS   =  *blank
     C                   Eval      A_DDFOID   =  *blank
     C                   Eval      A_TQTAX    =  *blank
     C                   Eval      A_TQSTAF   =  *blank
     C                   Eval      A_TQCDTE   =  *blank
     C                   Eval      A_AUTH     =  FNAUTH
     C                   Eval      A_TOFfil   =  *Blank
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataA3      Begsr
     C                   Clear                   ApDtmsg
      *
      ** - API action
      *
     C                   Eval      A_DDACTN  = 'C'
      *
      ** - Trade reference
      *
     C                   Eval      A_DDTDRF  = C3TDRF
      *
      ** - Bulk reference
      *
     C                   Eval      A_DDBLKR  = C3BLKR
      *
      ** - Client Number
      *
     C                   Eval      A_DDCNUM  = C3TCNR
      *
      ** - Security short name
      *
     C                   Eval      A_DDSESN  = C3TDSS
      *
      ** - Customer shortname
      *
     C                   Eval      A_DDCSSN  = *blank
      *
      ** - Customer report name
      *
     C                   Eval      A_DDCRNM  = *blank
      *
      ** - Customer report town
      *
     C                   Eval      A_DDCRTN  = *blank
      *
      ** - Incomplete indicator
      *
     C                   Eval      A_DDINCS  = O_TINC
      *
      ** - Trade type
      *
     C                   Eval      A_DDTDTP  = O_TDTP
      *
      ** - Nominal
      ** Format nominal amount based on Nominal decimal plases
      *
     C                   Move      O_NOML        W_NOML
      *
      ** Remove leading Zero
      *
     C                   If        W_N1 = '0' or W_N1 = ' '
     C                   Eval      W_N1 = *blank
     C                   If        W_N2 = '0' or W_N2 = ' '
     C                   Eval      W_N2 = *blank
     C                   If        W_N3 = '0' or W_N3 = ' '
     C                   Eval      W_N3 = *blank
     C                   If        W_N4 = '0' or W_N4 = ' '
     C                   Eval      W_N4 = *blank
     C                   If        W_N5 = '0' or W_N5 = ' '
     C                   Eval      W_N5 = *blank
     C                   If        W_N6 = '0' or W_N6 = ' '
     C                   Eval      W_N6 = *blank
     C                   If        W_N7 = '0' or W_N7 = ' '
     C                   Eval      W_N7 = *blank
     C                   If        W_N8 = '0' or W_N8 = ' '
     C                   Eval      W_N8 = *blank
     C                   If        W_N9 = '0' or W_N9 = ' '
     C                   Eval      W_N9 = *blank
     C                   If        W_N10 = '0' or W_N10 = ' '
     C                   Eval      W_N10 = *blank
     C                   If        W_N11 = '0' or W_N11 = ' '
     C                   Eval      W_N11 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   If        TNMD = 0
     C                   Eval      A_DDNOML  = %trim(W_NOML0)
     C                   Endif
     C                   If        TNMD = 1
     C                   Eval      A_DDNOML =  %trim(W_NOML1) + '.' + W_NDec1
     C                   Endif
     C                   If        TNMD = 2
     C                   Eval      A_DDNOML = %trim(W_NOML2) + '.' + W_NDec2
     C                   Endif
     C                   If        TNMD = 3
     C                   Eval      A_DDNOML = %trim(W_NOML3) + '.' + W_NDec3
     C                   Endif
     C                   If        TNMD = 4
     C                   Eval      A_DDNOML = %trim(W_NOML4) + '.' + W_NDec4
     C                   Endif
      *
      ** - Price/Disc/Yield
      ** If not nil format with Price Decimal places  (15,8)
      *
     C                   If        O_TPDY  > 0
     C                   Movel     O_TPDY        W_1508
      *
      ** Remove leading Zero
      *
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTPDY  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Value Date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDVD
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDVD
      *
      ** - Booking Branch
      ** Overwrite branch to consolidated branch
      *
     C                   Eval      A_DDBRCD  = FNBRCA
      *
      ** - Book
      *
     C                   Eval      A_DDBPBK  = C3TDBK
      *
      ** - Clearance type
      *
     C                   Eval      A_DDCLTY  = C3CLTY                                        O_CLTY
     C                   Eval      A_DDCLTY2 = C3CLTY                                        O_CLTY
      *
      ** - Settlement Currency
      *
     C                   Eval      A_DDSETC  = C3SETC                                        O_SETC
      *
      ** - REALLOWANCE
      ** If not nil format with Price Decimal places  (9,5)  ????
      *
     C                   If        O_RALL  > 0
     C                   Movel     O_RALL        W_0905
     C                   Eval      A_DDRALL  = W_RALLI + '.' +  W_RALLD
     c                   Eval      W_0905  = *blank
     C                   Endif
      *
      ** - Market Center
      *
     C                   Eval      A_DDMRKT  = O_TMKC
      *
      ** - Capacity
      ** Capacity May not be required ????
      *
     C                   Movel     O_TCAP        A_DDCPCY
      *
      ** - Price
      ** If not nil format with Price Decimal places  (15,8) ???
      *
     C                   If        O_PRIC > 0
     C                   Movel     O_PRIC        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDPRIC  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
     C                   Eval      A_DDPRIC   = GHSUBS
      *
      ** - Ex Dividend
      *
     C                   Eval      A_DDEXDV = C3EXDV                                          O_EXDV
      *
      ** - Fiscal Price
      ** If not nil format with Price Decimal places  (15,8)    ???
      *
     C                   If        O_FSPR > 0
     C                   Movel     O_FSPR        W_1508
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDFSPR  = %trim(W_Int07) + '.' +  W_Dec08
     C                   Movel     WrSUBS        A_DDFSPR
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Book profit center
      *
     C                   Eval      A_DDBPRC  = O_BPRC
      *
      ** - Trans profit center
      *
     C                   Eval      A_DDTPRC  = O_TPRC
      *
      ** - Trader ID
      *
     C                   Eval      A_DDTDID  = O_TDID
      *
      ** - Trade date
      ** Format Date as DDMMYY
      *
     C                   Eval      ZDATFM = 'D'
     C                   CALLB     'ZDATE2'
     C                   PARM                    O_TDDT
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   Movel     ZDATE         A_DDTDDT
      *
      ** - Trade Sub type
      *
     C                   Eval      A_DDTSUB  = O_TSUB
      *
      ** - Link Ref  Never on duplication
      *
     C                   Eval      A_DDLKRF = C3LKRF                                          O_LKRF
      *
      ** - Market indicator  ????
      *
     C                   Eval      A_DDTDMI = C3TDMI                                          O_TDMI
      *
      ** - ISMA / IPMA
      **  Not sure AIIP must be taken ????
      *
     C                   Eval      A_DDAIIP = C3AIIP                                          O_AIIP
      *
      ** - Narrative
      *
     C                   Eval      A_DDTDNR = O_TDNR                                          O_TDNR
      *
      ** - P order number never on replication
      ** Will never be from TOF
      *
     C                   Eval      A_DDORDE  = *Blank
      *
      ** - Accrued indicator
      *
     C                   Eval      A_DDACIN  = *blank                                         O_ACIN
      *
      ** - Days Adj/sign
      *
     C                   If        O_DADJ > 0
     C                   Movel     O_DADJ        A_DDDADJ
     C                   Endif
     C                   Eval      A_DDDADJ  = *blank                                         O_DADJ
      *
      ** - Act/Diff Ind
      *
     C                   Eval      A_DDACTD  =  *Blank
      *
      ** - Int Amnr/Sign
      ** If not nil format with Nominal currncy position ????
      *
     C                   If        O_ITRA > 0
     C                   Move      O_ITRA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDITRA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDITRA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDITRA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDITRA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Movel     WrSUBS        A_DDITRA
     C                   clear                   W_ChgL
      *
      ** - Origin
      *
     C                   Eval      A_DDINOR  = *blank
      *
      ** - Message Key
      *
     C                   Eval      A_DDMSGK  = *blank
      *
      ** - Notification method
      *
     C                   Eval      A_DDNTMT  = *blank
      *
      ** Ignoring following block
      *
     C                   Eval      A_DDNOM1  = *blank
     C                   Eval      A_DDTDV1  = *blank
     C                   Eval      A_DDACI1  = *blank
     C                   Eval      A_DDDAD1  = *blank
     C                   Eval      A_DDACT1  = *blank
     C                   Eval      A_DDITR1  = *blank
      *
      ** - Exchange rate
      ** If not nil format with rate Decimal places  (13,8)
      *
     C                   If        O_TDER > 0
     C                   Movel     O_TDER        W_1308
     C                   If        W_I1 = '0' or W_I1 = ' '
     C                   Eval      W_I1 = *blank
     C                   If        W_I2 = '0' or W_I2 = ' '
     C                   Eval      W_I2 = *blank
     C                   If        W_I3 = '0' or W_I3 = ' '
     C                   Eval      W_I3 = *blank
     C                   If        W_I4 = '0' or W_I4 = ' '
     C                   Eval      W_I4 = *blank
     C                   If        W_I5 = '0' or W_I5 = ' '
     C                   Eval      W_I5 = *blank
     C                   If        W_I6 = '0' or W_I6 = ' '
     C                   Eval      W_I6 = *blank
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTDER  = %trim(W_Int07) + '.' +  W_Dec08
     c                   Eval      W_1508  = *blank
     C                   Endif
      *
      ** - Exchange rateM/D
      *
     C                   Eval      A_DDSMDI  = *blank
      *
      ** - Margin
      *
     C                   Eval      A_DDFXMP  = *blank
      *
      ** - Base currency rate
      *
     C                   Eval      A_DDBRTE  = *blank
      *
      ** Settlement field are left unchanged
      *
     C                   Movel     C3SMTH        A_DDSMTH
     C                   Eval      A_DDORBR  = C3ORBR
     C                   Eval      A_DDPYFM  = C3PYFM
     C                   Eval      A_DDPFSN  = *blank
     C                   Eval      A_DDPFNM  = *blank
     C                   Eval      A_DDPFTN  = *blank
     C                   Eval      A_DDPFAN  = *blank
     C                   Eval      A_DDPFSW  = *blank
     C                   Eval      A_DDPYFB  = *blank
     C                   Eval      A_DDPAYT  = C3PAYT
     C                   Eval      A_DDPTSN  = *blank
     C                   Eval      A_DDPTNM  = *blank
     C                   Eval      A_DDPTTN  = *blank
     C                   Eval      A_DDPTAN  = *blank
     C                   Eval      A_DDPTSI  = *blank
     C                   Eval      A_DDPYTB  = *blank
     C                   Eval      A_DDTDFA  = *blank
     C                   Eval      A_DDFASN  = *blank
     C                   Eval      A_DDFANM  = *blank
     C                   Eval      A_DDFATN  = *blank
     C                   Eval      A_DDFASW  = *blank
     C                   Eval      A_DDASNM  = *blank
     C                   Eval      A_DDDELF  = C3DELF
     C                   Eval      A_DDDFSN  = *blank
     C                   Eval      A_DDDFNM  = *blank
     C                   Eval      A_DDDFTN  = *blank
     C                   Eval      A_DDDFSI  = *blank
     C                   Eval      A_DDDELT  = C3DELT
     C                   Eval      A_DDDTSN  = *blank
     C                   Eval      A_DDDTNM  = *blank
     C                   Eval      A_DDDTTN  = *blank
     C                   Eval      A_DDDTSI  = *blank
     C                   Eval      A_DDDFFA  = *blank
     C                   Eval      A_DDD1SN  = *blank
     C                   Eval      A_DDD1NM  = *blank
     C                   Eval      A_DDD1TN  = *blank
     C                   Eval      A_DDD1SI  = *blank
     C                   Eval      A_DDDTFA  = *blank
     C                   Eval      A_DDD2SN  = *blank
     C                   Eval      A_DDD2NM  = *blank
     C                   Eval      A_DDD2TN  = *blank
     C                   Eval      A_DDD2SI  = *blank
     C                   Eval      A_DDTDSI  = *blank
      *
      ** - In Currency in F72
      *
     C                   Eval      A_DDICCY  = C3ICCY                                         O_ICCY
      *
      ** - Profit Center
      *
     C                   Eval      A_DDPRFC  = C3PRFC                                         O_PRFC
      *
      ** - Priority code
      *
     C                   Movel     WrSUBS        A_DDPRYC
      *
      ** - Pay Code
      *
     C                   Eval      A_DDPCOD  = C3PCOD                                         O_PCOD
      *
      ** - Auto settle ind
      *
     C                   Eval      A_DDAUTS  = 'Y'
      *
      ** - Brok Comm code
      *
     C                   Eval      A_DDTBCC  =  O_TBCC
      *
      ** - Brok Com Amount
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TBCA > 0
     C                   Move      O_TBCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTBCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTBCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTBCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTBCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust com code
      *
     C                   Eval      A_DDTCCC  = O_TCCC
      *
      ** - Cust Comm Amount
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TCCA > 0
     C                   Move      O_TCCA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCCA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCCA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCCA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCCA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 1
      *
     C                   Eval      A_DDTCC1  = O_TCC1
      *
      ** - Chg Amount 1
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA1 > 0
     C                   Move      O_TCA1        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA1  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA1  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA1  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA1  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 2
      *
     C                   Eval      A_DDTCC2  = O_TCC2
      *
      ** - Chg Amount 2
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA2 > 0
     C                   Move      O_TCA2        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA2  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA2  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA2  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA2  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 3
      *
     C                   Eval      A_DDTCC3  = O_TCC3
      *
      ** - Chg Amount 3
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TCA3 > 0
     C                   Move      O_TCA3        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA3  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA3  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA3  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA3  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 4
      *
     C                   Eval      A_DDTCC4  = O_TCC4
      *
      ** - Chg Amount 4
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA4 > 0
     C                   Move      O_TCA4        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA4  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA4  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA4  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA4  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 5
      *
     C                   Eval      A_DDTCC5  = O_TCC5
      *
      ** - Chg Amount 5
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA5 > 0
     C                   Move      O_TCA5        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA5  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA5  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA5  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA5  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 6
      *
     C                   Eval      A_DDTCC6  = O_TCC6
      *
      ** - Chg Amount 6
      ** If not nil format with Nominal currncy position
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA6 > 0
     C                   Move      O_TCA6        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA6  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA6  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA6  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA6  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Chg code 7
      *
     C                   Eval      A_DDTCC7  = O_TCC7
      *
      ** - Chg Amount 7
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TCA7 > 0
     C                   Move      O_TCA7        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTCA7  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTCA7  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTCA7  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTCA7  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax amount    always blank on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_TAXA > 0
     C                   Move      O_TAXA        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTAXA  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTAXA  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTAXA  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTAXA  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDTAXA  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** EU tax amount in nominall currency always balnk on replication
      ** If not nil format with Nominal currncy position
      *
     C                   If        O_EUTX > 0
     C                   Move      O_EUTX        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDEUTX  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDEUTX  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDEUTX  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDEUTX  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   Eval      A_DDEUTX  = *blank                                            ???
     C                   clear                   W_ChgL
      *
      ** - Brok Comm  Rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_BCMR > 0
     C                   Move      O_BCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDBCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDBCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDBCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDBCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Cust Comm rebate
      ** If not nil format with Nominal currency position
      *
     C                   If        O_CCMR > 0
     C                   Move      O_CCMR        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDCCMR  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDCCMR  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDCCMR  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDCCMR  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Tax rebate always blank on replication
      ** If not nil format with Nominal currency position
      *
     C                   If        O_TXRB > 0
     C                   Move      O_TXRB        W_ChgL
     C                   If        A6NBDP = 0
     C                   Eval      A_DDTXRB  = W_ChgL
     C                   Endif
     C                   If        A6NBDP = 1
     C                   Eval      A_DDTXRB  = W_ChgL1 + '.' + W_CDec1
     C                   Endif
     C                   If        A6NBDP = 2
     C                   Eval      A_DDTXRB  = W_ChgL2 + '.' + W_CDec2
     C                   Endif
     C                   If        A6NBDP = 3
     C                   Eval      A_DDTXRB  = W_ChgL3 + '.' + W_CDec3
     C                   Endif
     C                   Endif
     C                   clear                   W_ChgL
      *
      ** - Portfolio reference Always Blank on replication
      *
     C                   Eval      A_DDPTFR   = C3PTFR
      *
      ** Extension file TRADSDX1  Not sure it needs to be setup
      *
      ** Settlement Message Request
      *
     C                   Eval      A_ADDGMES  = *blank
      *
      ** Time of Trade
      *
     C                   Eval      A_ADDTRTT  = *blank
      *
      ** Instructions Type
      *
     C                   Eval      A_ADDINST  = C3T1INST
      *
      ** Instructions sub-type
      *
     C                   Eval      A_ADDINSS  = C3T1INSS
      *
      ** Euroclear/Cedel code
      *
     C                   Eval      A_ADDEUCL  = C3T1EUCL
      *
      ** Safekeeping Account (MT580)
      *
     C                   Eval      A_ADDSAFA  = C3T1SAFA
      *
      ** Requested Priority
      *
     C                   Eval      A_ADDRPTY  = C3T1RPTY
      *
      ** Guaranteed Delivery
      *
     C                   Eval      A_ADDGDEL  = *blank
      *
      ** Sender's Role
      *
     C                   Eval      A_ADDSROL  = *blank
      *
      ** Fungibilty Code
      *
     C                   Eval      A_ADDFCOD  = *blank
      *
      ** Fungible Trade Indicator
      *
     C                   Eval      A_ADDFTID  = *blank
      *
      ** Confirmation Message Request
      *
     C                   Eval      A_ADDGMEC  = *blank
      *
      ** Customer/Counterparty Ind.
      *
     C                   Eval      A_ADDCCID  = *blank
      *
      ** Further Id.
      *
     C                   Eval      A_ADDFID1  = *blank
      *
      ** Standard Instructions' Overr  ?
      *
     C                   Eval      A_ADDIORA  = *blank
      *
      ** ISO15022 Messages Ind.
      *
     C                   Eval      A_ADDSNEW  = *blank
      *
      ** Stamp Status
      *
     C                   Eval      A_ADDSTMP  = *blank
      *
      ** Charity Identifier
      *
     C                   Eval      A_ADDCHID  = *blank
      *
      ** Transaction Report Marker
      *
     C                   Eval      A_ADDTRRM  = *blank
      *
      ** Ignore following block
      *
     C                   Eval      A_BDDGMES  = *blank
     C                   Eval      A_BDDTRTT  = *blank
     C                   Eval      A_BDDINST   =*blank
     C                   Eval      A_BDDINSS   =*blank
     C                   Eval      A_BDDEUCL   =*blank
     C                   Eval      A_BDDSAFA   = *blank
     C                   Eval      A_BDDRPTY   = *blank
     C                   Eval      A_BDDGDEL   = *blank
     C                   Eval      A_BDDSROL   = *blank
     C                   Eval      A_BDDFCOD   = *blank
     C                   Eval      A_BDDFTID   = *blank
     C                   Eval      A_BDDGMEC   = *blank
     C                   Eval      A_BDDCCID   = *blank
     C                   Eval      A_BDDFID1   = *blank
     C                   Eval      A_BDDIORA   = *blank
     C                   Eval      A_BDDSNEW   = *blank
     C                   Eval      A_BDDSTMP   = *blank
     C                   Eval      A_BDDCHID   = *blank
     C                   Eval      A_BDDTRRM   = *blank
     C                   Eval      A_AESAP1N   = *blank
     C                   Eval      A_DDA1SN    = *blank
     C                   Eval      A_DDA1NM    = *blank
     C                   Eval      A_DDA1TN    = *blank
     C                   Eval      A_DDA1SI    = *blank
     C                   Eval      A_AESAP1L   = *blank
     C                   Eval      A_AESAP2N   = *blank
     C                   Eval      A_DDA2SN   =  *blank
     C                   Eval      A_DDA2NM   =  *blank
     C                   Eval      A_DDA2TN   =  *blank
     C                   Eval      A_DDA2SI   =  *blank
     C                   Eval      A_AESAP2L  =  *blank
     C                   Eval      A_AESAWIN  =  *blank
     C                   Eval      A_DDAISN   =  *blank
     C                   Eval      A_DDAINM   =  *blank
     C                   Eval      A_DDAITN   =  *blank
     C                   Eval      A_DDAISI   =  *blank
     C                   Eval      A_AESAWIL  =  *blank
     C                   Eval      A_AESBOFN  =  *blank
     C                   Eval      A_DDBMSN   =  *blank
     C                   Eval      A_DDBMNM   =  *blank
     C                   Eval      A_DDBMTN   =  *blank
     C                   Eval      A_DDBMSI   =  *blank
     C                   Eval      A_AESBOF1  =  *blank
     C                   Eval      A_AESBOF2  =  *blank
     C                   Eval      A_AESACL1  =  *blank
     C                   Eval      A_AESACL2  =  *blank
     C                   Eval      A_AESSRL1  =  *blank
     C                   Eval      A_AESSRL2  =  *blank
     C                   Eval      A_AESSRL3  =  *blank
     C                   Eval      A_AESFIN1  =  *blank
     C                   Eval      A_AESFIN2   = *blank
     C                   Eval      A_AESRED1   = *blank
     C                   Eval      A_AESRED2   = *blank
     C                   Eval      A_AESNAL1   = *blank
     C                   Eval      A_AESNAL2   = *blank
     C                   Eval      A_AESIPYN   = *blank
     C                   Eval      A_DDIPSN    = *blank
     C                   Eval      A_DDIPNM    = *blank
     C                   Eval      A_DDIPTN    = *blank
     C                   Eval      A_DDIPSI    = *blank
     C                   Eval      A_AESIPYL   = *blank
     C                   Eval      A_AESCTYN   = *blank
     C                   Eval      A_AESCTYL   = *blank
     C                   Eval      A_AESSA1N   = *blank
     C                   Eval      A_DDCZSN    = *blank
     C                   Eval      A_DDCSNM    = *blank
     C                   Eval      A_DDCSTN    = *blank
     C                   Eval      A_DDCSSI    = *blank
     C                   Eval      A_AESSA1L   = *blank
     C                   Eval      A_AESSKAN   = *blank
     C                   Eval      A_DDUSSN    = *blank
     C                   Eval      A_DDUSNM    = *blank
     C                   Eval      A_DDUSTN    = *blank
     C                   Eval      A_DDUSSI    = *blank
     C                   Eval      A_AESSKAL   = *blank
     C                   Eval      A_AESCCTN   = *blank
     C                   Eval      A_DDCCSN    = *blank
     C                   Eval      A_DDCCNM    = *blank
     C                   Eval      A_DDCCTN    = *blank
     C                   Eval      A_DDCCSI    = *blank
     C                   Eval      A_AESDCTL   = *blank
     C                   Eval      A_AESRSSN   = *blank
     C                   Eval      A_DDRSSN    = *blank
     C                   Eval      A_DDRSNM    = *blank
     C                   Eval      A_DDRSTN    = *blank
     C                   Eval      A_DDRSSI    = *blank
     C                   Eval      A_AESRSS1   = *blank
     C                   Eval      A_AESRSS2   = *blank
     C                   Eval      A_AESRSS3   = *blank
     C                   Eval      A_AESRSS4   = *blank
     C                   Eval      A_AESDSSN   = *blank
     C                   Eval      A_AESDSS1   = *blank
     C                   Eval      A_AESDSS2   = *blank
     C                   Eval      A_AESDSS3   = *blank
     C                   Eval      A_AESDSS4   = *blank
     C                   Eval      A_AESBSSN   = *blank
     C                   Eval      A_AESBSS1   = *blank
     C                   Eval      A_AESBSS2   = *blank
     C                   Eval      A_AESINVE   = *blank
     C                   Eval      A_DDIOSN    = *blank
     C                   Eval      A_DDIONM    = *blank
     C                   Eval      A_DDIOTN    = *blank
     C                   Eval      A_DDIOSI    = *blank
     C                   Eval      A_AESIMMD1  = *blank
     C                   Eval      A_DDI1SN    = *blank
     C                   Eval      A_DDI1NM    = *blank
     C                   Eval      A_DDI1TN    = *blank
     C                   Eval      A_DDI1SI    = *blank
     C                   Eval      A_AESIMSA1  = *blank
     C                   Eval      A_AESIMMD2  = *blank
     C                   Eval      A_DDI2SN    = *blank
     C                   Eval      A_DDI2NM    = *blank
     C                   Eval      A_DDI2TN    = *blank
     C                   Eval      A_DDI2SI    = *blank
     C                   Eval      A_AESIMSA2  = *blank
     C                   Eval      A_AESIMMD3  = *blank
     C                   Eval      A_AESIMSA3  = *blank
     C                   Eval      A_AESIMMD4  = *blank
     C                   Eval      A_AESIMSA4  = *blank
     C                   Eval      A_AESIMMD5  = *blank
     C                   Eval      A_AESIMSA5  = *blank
     C                   Eval      A_AESIMMD6  = *blank
     C                   Eval      A_AESIMSA6  = *blank
     C                   Eval      A_AESIMMD7  = *blank
     C                   Eval      A_AESIMSA7  = *blank
     C                   Eval      A_AESIMMD8  = *blank
     C                   Eval      A_AESIMSA8  = *blank
     C                   Eval      A_AESIMMD9  = *blank
     C                   Eval      A_AESIMSA9  = *blank
     C                   Eval      A_AESPSET   = *blank
     C                   Eval      A_DDPSSN    = *Blank
     C                   Eval      A_DDPSNM    = *Blank
     C                   Eval      A_DDPSTN    = *Blank
     C                   Eval      A_DDPSSI    = *Blank
     C                   Eval      A_AESNAC1   = *Blank
     C                   Eval      A_AESNAC2   = *Blank
     C                   Eval      A_AESDIDN   = *Blank
     C                   Eval      A_AESDAD1   = *Blank
     C                   Eval      A_AESDAD2   = *Blank
     C                   Eval      A_AESDAD3   = *Blank
     C                   Eval      A_AESDAD4   = *Blank
     C                   Eval      A_AESDLIN   = *Blank
     C                   Eval      A_AESQFIN   = *Blank
     C                   Eval      A_AESPCLR   = *Blank
     C                   Eval      A_BESAP1N   = *Blank
     C                   Eval      A_BDA1SN    = *Blank
     C                   Eval      A_BDA1NM   =  *Blank
     C                   Eval      A_BDA1TN   =  *Blank
     C                   Eval      A_BDA1SI   =  *Blank
     C                   Eval      A_BESAP1L  =  *Blank
     C                   Eval      A_BESAP2N  =  *Blank
     C                   Eval      A_BDA2SN   =  *Blank
     C                   Eval      A_BDA2NM   =  *blank
     C                   Eval      A_BDA2TN   =  *blank
     C                   Eval      A_BDA2SI   =  *blank
     C                   Eval      A_BESAP2L  =  *blank
     C                   Eval      A_BESAWIN  =  *blank
     C                   Eval      A_BDAISN   =  *blank
     C                   Eval      A_BDAINM   =  *blank
     C                   Eval      A_BDAITN   =  *blank
     C                   Eval      A_BDAISI   =  *blank
     C                   Eval      A_BESAWIL  =  *blank
     C                   Eval      A_BESBOFN  =  *blank
     C                   Eval      A_BDBMSN   =  *blank
     C                   Eval      A_BDBMNM   =  *blank
     C                   Eval      A_BDBMTN   =  *blank
     C                   Eval      A_BDBMSI   =  *blank
     C                   Eval      A_BESBOF1  =  *blank
     C                   Eval      A_BESBOF2  =  *blank
     C                   Eval      A_BESACL1  =  *blank
     C                   Eval      A_BESACL2   = *blank
     C                   Eval      A_BESSRL1   = *blank
     C                   Eval      A_BESSRL2   = *blank
     C                   Eval      A_BESSRL3   = *blank
     C                   Eval      A_BESFIN1   = *blank
     C                   Eval      A_BESFIN2   = *blank
     C                   Eval      A_BESRED1   = *blank
     C                   Eval      A_BESRED2   = *blank
     C                   Eval      A_BESNAL1   = *blank
     C                   Eval      A_BESNAL2   = *blank
     C                   Eval      A_BESIPYN   = *blank
     C                   Eval      A_BDIPSN    = *blank
     C                   Eval      A_BDIPNM    = *blank
     C                   Eval      A_BDIPTN    = *blank
     C                   Eval      A_BDIPSI    = *blank
     C                   Eval      A_BESIPYL   = *blank
     C                   Eval      A_BESCTYN   = *blank
     C                   Eval      A_BESCTYL   = *blank
     C                   Eval      A_BESSA1N   = *blank
     C                   Eval      A_BDCZSN    = *blank
     C                   Eval      A_BDCSNM    = *blank
     C                   Eval      A_BDCSTN    = *blank
     C                   Eval      A_BDCSSI    = *blank
     C                   Eval      A_BESSA1L   = *blank
     C                   Eval      A_BESSKAN   = *blank
     C                   Eval      A_BDUSSN    = *blank
     C                   Eval      A_BDUSNM    = *blank
     C                   Eval      A_BDUSTN    = *blank
     C                   Eval      A_BDUSSI    = *blank
     C                   Eval      A_BESSKAL   = *blank
     C                   Eval      A_BESCCTN   = *blank
     C                   Eval      A_BDCCSN    = *blank
     C                   Eval      A_BDCCNM    = *blank
     C                   Eval      A_BDCCTN    = *blank
     C                   Eval      A_BDCCSI    = *blank
     C                   Eval      A_BESDCTL   = *blank
     C                   Eval      A_BESRSSN   = *blank
     C                   Eval      A_BDRSSN    = *blank
     C                   Eval      A_BDRSNM    = *blank
     C                   Eval      A_BDRSTN    = *blank
     C                   Eval      A_BDRSSI    = *blank
     C                   Eval      A_BESRSS1   = *blank
     C                   Eval      A_BESRSS2   = *blank
     C                   Eval      A_BESRSS3   = *blank
     C                   Eval      A_BESRSS4   = *blank
     C                   Eval      A_BESDSSN   = *blank
     C                   Eval      A_BESDSS1   = *blank
     C                   Eval      A_BESDSS2   = *blank
     C                   Eval      A_BESDSS3   = *blank
     C                   Eval      A_BESDSS4   = *blank
     C                   Eval      A_BESBSSN   = *blank
     C                   Eval      A_BESBSS1   = *blank
     C                   Eval      A_BESBSS2   = *blank
     C                   Eval      A_BESINVE   = *blank
     C                   Eval      A_BDIOSN    = *blank
     C                   Eval      A_BDIONM    = *blank
     C                   Eval      A_BDIOTN    = *blank
     C                   Eval      A_BDIOSI    = *blank
     C                   Eval      A_BESIMMD1  = *blank
     C                   Eval      A_BDI1SN    = *blank
     C                   Eval      A_BDI1NM    = *blank
     C                   Eval      A_BDI1TN    = *blank
     C                   Eval      A_BDI1SI    = *blank
     C                   Eval      A_BESIMSA1  = *blank
     C                   Eval      A_BESIMMD2  = *blank
     C                   Eval      A_BDI2SN    = *blank
     C                   Eval      A_BDI2NM    = *blank
     C                   Eval      A_BDI2TN    = *blank
     C                   Eval      A_BDI2SI    = *blank
     C                   Eval      A_BESIMSA2  = *blank
     C                   Eval      A_BESIMMD3  = *blank
     C                   Eval      A_BESIMSA3  = *blank
     C                   Eval      A_BESIMMD4   =*blank
     C                   Eval      A_BESIMSA4   =*blank
     C                   Eval      A_BESIMMD5   =*blank
     C                   Eval      A_BESIMSA5   =*blank
     C                   Eval      A_BESIMMD6   =*blank
     C                   Eval      A_BESIMSA6   =*blank
     C                   Eval      A_BESIMMD7   = *blank
     C                   Eval      A_BESIMSA7   = *blank
     C                   Eval      A_BESIMMD8   = *blank
     C                   Eval      A_BESIMSA8   = *blank
     C                   Eval      A_BESIMMD9   = *blank
     C                   Eval      A_BESIMSA9   = *blank
     C                   Eval      A_BESPSET    = *blank
     C                   Eval      A_BDPSSN     = *blank
     C                   Eval      A_BDPSNM     = *blank
     C                   Eval      A_BDPSTN     = *blank
     C                   Eval      A_BDPSSI     = *blank
     C                   Eval      A_BESNAC1    = *blank
     C                   Eval      A_BESNAC2    = *blank
     C                   Eval      A_BESDIDN    = *blank
     C                   Eval      A_BESDAD1    = *blank
     C                   Eval      A_BESDAD2    = *blank
     C                   Eval      A_BESDAD3    = *blank
     C                   Eval      A_BESDAD4    = *blank
     C                   Eval      A_BESDLIN   =  *blank
     C                   Eval      A_BESQFIN   =  *blank
     C                   Eval      A_BESPCLR   =  *blank
     C                   Eval      A_DDCRSK    =  *blank
     C                   Eval      A_DDLQPR    =  *blank
     C                   Eval      A_DDITRN    = *blank
     C                   Eval      A_TMSP      = *blank
     C                   Eval      A_BDSPBS    = *blank
     C                   Eval      A_STBS      = *blank
     C                   Eval      A_PROT      = *blank
     C                   Eval      A_NMCY      = *blank
     C                   Eval      A_C1DI      = *blank
     C                   Eval      A_BVAUTH    = *blank
     C                   Eval      A_DDCPNR    = *blank
     C                   Eval      A_DDTCTR    = *blank
     C                   Eval      A_DDCFCT    = *blank
     C                   Eval      A_ADDROUS   = *blank
     C                   Eval      A_ADDROTS   = *blank
     C                   Eval      A_ADDROUC   = *blank
     C                   Eval      A_ADDROTC   = *blank
     C                   Eval      A_BDDROUS   = *blank
     C                   Eval      A_BDDROTS   = *blank
     C                   Eval      A_BDDROUC   = *blank
     C                   Eval      A_BDDROTC   = *blank
     C                   Eval      A_DDSPXR   =  *blank
     C                   Eval      A_DDSPMD   =  *blank
     C                   Eval      A_DDWTAX   =  *blank
     C                   Eval      A_BKEURO   =  *blank
     C                   Eval      A_DDSTAT   =  *blank
     C                   Eval      A_DDAUTH   =  FNAUTH
     C                   Eval      A_SITP     =  *blank
     C                   Eval      A_DDPRICN  =  *blank
     C                   Eval      A_DDHACR   =  *blank
     C                   Eval      A_DDTCSR   =  *blank
     C                   Eval      A_DDDAYS   =  *blank
     C                   Eval      A_DDFOID   =  *blank
     C                   Eval      A_TQTAX    =  *blank
     C                   Eval      A_TQSTAF   =  *blank
     C                   Eval      A_TQCDTE   =  *blank
     C                   Eval      A_AUTH     =  FNAUTH
     C                   Eval      A_TOFfil   =  *Blank
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataD       Begsr
     C                   Clear                   ApDtmsg
     C                   Eval      A_DDACTN  = 'D'
     C                   Eval      A_DDTDRF  = C_TDRF
     C                   Eval      A_DDBLKR  = C_BLKR
     C                   Eval      A_DDSESN  = C_TDSS
     C                   Eval      A_DDCNUM  = C_TCNR
     C                   Eval      A_DDCSSN  = C_TDSS
     C                   Eval      A_DDCRNM  = *Blank
     C                   Eval      A_DDCRTN  = *Blank
     C                   Eval      A_DDINCS  = C_TINC
     C                   Eval      A_DDTDTP  = C_TDTP
     C                   Eval      A_AUTH     =  FNAUTH
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataD2      Begsr
     C                   Clear                   ApDtmsg
     C                   Eval      A_DDACTN  = 'D'
     C                   Eval      A_DDTDRF  = C2TDRF
     C                   Eval      A_DDBLKR  = C2BLKR
     C                   Eval      A_DDSESN  = C2TDSS
     C                   Eval      A_DDCNUM  = C2TCNR
     C                   Eval      A_DDCSSN  = C2TDSS
     C                   Eval      A_DDCRNM  = *Blank
     C                   Eval      A_DDCRTN  = *Blank
     C                   Eval      A_DDINCS  = C2TINC
     C                   Eval      A_DDTDTP  = C2TDTP
     C                   Eval      A_AUTH     =  FNAUTH
     C                   Endsr
      /Eject
      *****************************************************************
     C     APDataD3      Begsr
     C                   Clear                   ApDtmsg
     C                   Eval      A_DDACTN  = 'D'
     C                   Eval      A_DDTDRF  = C3TDRF
     C                   Eval      A_DDBLKR  = C3BLKR
     C                   Eval      A_DDSESN  = C3TDSS
     C                   Eval      A_DDCNUM  = C3TCNR
     C                   Eval      A_DDCSSN  = C3TDSS
     C                   Eval      A_DDCRNM  = *Blank
     C                   Eval      A_DDCRTN  = *Blank
     C                   Eval      A_DDINCS  = C3TINC
     C                   Eval      A_DDTDTP  = C3TDTP
     C                   Eval      A_AUTH     =  FNAUTH
     C                   Endsr
      /Eject
      *****************************************************************
     C     FNDataD       Begsr
      *
     C                   Eval      FNsetup = ' '
      *
      ** ELement 1 for key 'UDFTRAD07'
      ** ELement 2 for key 'UDFTRAD12'
      ** ELement 3 for key 'UDFTRAD15'
      *
     C                   OPEN      A1CONBL2
     C     FNudfE1       CHAIN     A1CONBPF                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      FNbrcaA(1) = FNBRCA
     C                   Eval      FNfoirA(1) = FNFOIR
     C                   Eval      FNsetup = 'Y'
     C                   END
     C     FNudfE2       CHAIN     A1CONBPF                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      FNbrcaA(2) = FNBRCA
     C                   Eval      FNfoirA(2) = FNFOIR
     C                   Eval      FNsetup = 'Y'
     C                   END
     C     FNudfE3       CHAIN     A1CONBPF                           99
     C     *IN99         IFEQ      *OFF
     C                   Eval      FNbrcaA(3) = FNBRCA
     C                   Eval      FNfoirA(3) = FNFOIR
     C                   Eval      FNsetup = 'Y'
     C                   END
     C                   CLOSE     A1CONBL2
     C                   Endsr
      /Eject
      *****************************************************************
      ** Exit program: Direct                                         *
      *****************************************************************
     C     ZYEXPG        Begsr
      *
      ** Exit program
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   Endsr
      *****************************************************************

**  CPY@
(c) Finastra International Limited 2021
