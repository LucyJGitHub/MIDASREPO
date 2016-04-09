     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP store and forward tr. hand')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004503 - Midas Cashier TCP/IP Store and Forward Tr. Hand.  *
      *                                                               *
      *  This program is based on RE4403 and both version should be   *
      *  maintained at the same level.                                *
      *                                                               *
      *  Function:  This program will be evoked by Cashier to start   *
      *  (I/C)      at the AS/400 when store and forward transactions *
      *             need to be sent to the host from the remote branch*
      *             communications handlers.                          *
      *  Author: Alain Differdange                                    *
      *  Called By: REC4503 - Midas Cashier TCP/IP Store and Forward  *
      *                       Transaction                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      *                 CRT008             Date 18Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CRT005             Date 09Aug01               *
      *                 197289             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CRT006             Date 18Jul01               *
      *                 194002             Date 06Jul01               *
      *                 193193             Date 11May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004  *CREATE    Date 06JUN00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CRE019 - Cheque Processing and Maintenance (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CRT008 - Forward report enhancement                          *
      *  CRT005 - Cashier Enhancement for Cash In/Cash Out            *
      *  197289 - Cashier Reserve Transactions (update).              *
      *           Re-set key in KLIST before chaining.                *
      *           Avoids database error on sign-off  (196630).        *
      *  CRT006 - Cashier Reserve Transactions.                       *
      *  194002 - Check Interface started to avoid multiple jobs.     *
      *  193193 - Data truncated causing E0154 message for FX.        *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
      /EJECT
     F*REPLOGL9**IF***E****       K DISK                                                      197289
     F*********                            RENAME(REPLOGD0:REPLOGD9)                          197289
      ****CS*Communications Log keyed by Brch, Teller Id, Comms Seq No.                       197289
      *
     FREPLOGL0  UF A E           K DISK
      **  CS Communications Log keyed by CS Comms Seq No.
      *
     FTTRNM2L1  UF   E           K DISK
      **  Teller Controls File
      *
     F***REPDRIPDO***E                    DISK                            122060
     FREPDRIPD  O    E             DISK    USROPN                               122060
      **  CS Draft Issuance Incoming Message
      *
     FREPDRIL1  UF   E           K DISK    INFSR(*PSSR)                         122060
     F                                     USROPN
     F                                     RENAME(REPDRID0:REPDRILF)            122060
      **  Draft Issuance Incoming Message key Draft No                    122060
      *                                                                   122060
      *
     FRE4503P1  O    E             PRINTER OFLIND(*IN40)
     F                                     USROPN
     F                                     INFDS(SPOOL)
      **  CS Store and Forward Transaction Details
      *
     FRE4503AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      **  CS Store and Forward Transaction Audit
      *                                                                                      194002
     FREACJBL0  IF   E           K DISK                                                      194002
      **  List of active Transaction Handler jobs.                                           194002
      *
     FTTRANL1   UF   E           K DISK    INFSR(*PSSR)                                       197289
     F                                     USROPN                                             197289
      ** RE Teller Transactions                                                               197289
      *                                                                                       197289
     FTTRNTM3   IF   E           K DISK    INFSR(*PSSR)                                       197289
      **  Teller Totals                                                                       197289
      *                                                                                       197289
     FREFWDEPD  O    E           K DISK    INFSR(*PSSR)                                       CRT008
     F                                     USROPN                                             CRT008
      /EJECT
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                  ----------------------                       *
      *                                                               *
      *       30         'CHAIN' fail for LF/TTRNM2L1.                *
      *       35         'CHAIN' fail for LF/REPLOGL0.                *
      *       37         Forward Rept. Midas Auto Reversal            *                       CRT008
      *       38         Forward Rept. Transaction  posted to susp    *                       CRT008
      *       39         Forward Rept. Transaction not written        *                       CRT008
      *                                                               *
      *       40         Overflow indicator for detail report.        *
      *                                                               *
      *       60         LOKUP 'equal to' on Device Array (CDV)       *
      *       62         LOKUP 'equal to' on Teller Array (TLR)       *
      *       64         LOKUP 'equal to' on Transaction Type (TXP)   *
      *       65         LOKUP 'equal to' on Used Tellers (UTL)       *                       197289
      *       67         LOKUP 'equal to' on Msgs Require Ack(MTYP)   *
      *                                                               *
      *       70         Transaction Handler not active.              *                       194002
      *                                                               *
      *       80-89      Standard RTS subroutines                     *
      *                                                               *
      *       90-99      Standard MIDAS subroutines                   *
      *                                                               *
      *       U7+U8      Database error occurs                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  COMMSG - Comms Message Processing.                           *
      *  DBERR  - Database Error Handling.                            *
      *  DIMSG  - Draft Issuance Message Processing.                  *
      *  INIT   - Initialisation.                                     *
      *  MESG   - Message Processing.                                 *
      *  MSGVAL - Further Message Validation.                         *
      *  RCVDTQ - Receive Dataqueue Processing.                       *
      *  ROLLBK - Rollback Processing.                                *
      *  RTVMSG - Retrieve Program Message Details.                   *
      *  UPDLOG - Update Communications Log.                          *
      *  WRTLOG - Write to Communications Log.                        *
      *  WRTDRI - Write to PF/REPDRIPD.                               *
      *  *PSSR  - Program Error.                                      *
      *                                                               *
      *  Standard MIDAS Subroutines                                   *
      *                                                               *
      *  ZFWDT  -  Calculate Working Days Forward.                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      **  Array containing Copyright statement.
      *
     D DLY             S             13    DIM(1) CTDATA PERRCD(1)
      *
     D***********         MTYP    1  21  4   CONF    1                    CI01
     D***********         MTYP    1  23  4   CONF    1               CI01 164276
     D***MTYP***         S              4    DIM(24) CTDATA PERRCD(1)                     164 CRT005
     D***CONF***         S              1    DIMM(24) ALT(MTYP)                               CRT005
     D MTYP            S              4    DIM(28) CTDATA PERRCD(1)                           CRT005
     D CONF            S              1    DIM(28) ALT(MTYP)                                  CRT005
      **  Lookup Table to hold transactions that will receive ACK or NAK.
      *
     D @TXT            S             80    DIM(2) CTDATA PERRCD(1)                            197289
      **  Array containing Text Strings for Override of Files                                 197289
      *                                                                                       197289
      ** DEFINE FIELDS FOR ZDATE9
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A
      *
     D CDV             S             10    DIM(999) ASCEND
      **  Authorised Devices array.
      *
     D UTL             S              3    DIM(999)                                           197289
      **  Tellers accessed (for rollback process)                                             197289
      *                                                                                       197289
     D TLR             S              3    DIM(999) ASCEND
     D TST             S              3    DIM(999)
      **  Authorised Tellers array.
      *
     D TBR             S              3    DIM(999) ASCEND
      **  Teller's Branch Code array.
      *
     D TXP             S             10    DIM(999) ASCEND
     D DTL             S             36    DIM(999)
      **  Cashier Interface Transaction Types Array.
      *
      /EJECT
      **
      *
     D                 DS
     D*I************'CASHIER 8 '              1  10 W#ICDP                164273
     D  W#ICDP                 1     10    INZ('CASHIER   ')                    164273
      *
     D SPOOLU          DS
      **  File Information Data Structure for RE4503AU.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SPOOL           DS
      **  File Information Data Structure for RE4503P1.
      *
     D  OPEN                  82     82
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
      *
     D PSDS           SDS
      **  Program status data structure.
      *
     D  ZAPGM            *PROC
     D  WSID                 244    246
     D  WSID2                245    246
     D  WSJOB                244    253
     D  USRID                254    263
     D  JNUMBR               264    269  0
     D  JOBNUM               264    269
      *
     D MSGS            DS
      **  Data structure for message data sent to RBA Dataqueue.
      *
     D  MSGS01                 1    256
     D  MSGS02               257    512
     D  MSGS03               513    768
     D**MSGS04*******        769   1000                                         193193
     D  MSGS04               769   1003                                         193193
     D  MSGS05              1004   1004                                                       CRT006
     D  W#JBDQ                15     24
     D  W#SEQN                25     30
     D  W#FWST               113    113                                         120880
     D  R#TRN1               358    371
     D  R#TRN2               461    474
     D  R#TRN3               515    528
     D  R#TRN4               529    542
     D  FRAMTA               140    150                                                       CRT008
     D  FRCHAM               272    287                                                       CRT008
      *
     D MSGO            DS                                                                     197289
      **  Data structure for Auto-reversal sent to RBA Dataqueue.                             197289
      *                                                                                       197289
     D  MSGO01                 1    256                                                       197289
     D  MSGO02               257    512                                                       197289
     D  MSGO03               513    768                                                       197289
     D  MSGO04               769   1003                                                       197289
     D  MSGO05              1004   1004                                                       197289
     D  WOBRCA                 5      8                                                       197289
     D  WOUSID                 9     11                                                       197289
     D  WOJBDQ                15     24                                                       197289
     D  WOSEQN                25     30                                                       197289
     D  WOFWST               113    113                                                       197289
     D  WOCCY2               133    135                                                       CRT008
     D  WOAMT                136    150  0                                                    CRT008
     D  WOSPCD               317    319                                                       CRT005
     D  WOTBTN               361    365                                                       CRT008
     D  ROMAC1               904    920                                                       197289
     D  ROMAC2               925    941                                                       197289
     D**ROMNA1********       942    956                                                       197289
     D**ROMNA2********       957    971                                                       197289
      *                                                                                       CRT005
     D MSGC            DS                                                                     CRT005
      ** Data structure for generating opposite transaction for unacknowledged                CRT005
      ** cashier messages CSIV, CSOV, TLIN and TLOU.                                          CRT005
      *                                                                                       CRT005
     D  MSGC01                 1    256                                                       CRT005
     D  MSGC02               257    512                                                       CRT005
     D  MSGC03               513    768                                                       CRT005
     D  MSGC04               769   1003                                                       CRT005
     D  MSGC05              1004   1004                                                       CRT005
     D  WCMSTY                 1      4                                                       CRT005
     D  WCBRNM                 5      8                                                       CRT005
     D  WCUSID                 9     11                                                       CRT005
     D  WCJBDQ                15     24                                                       CRT005
     D  WCCMSQ                25     30                                                       CRT005
     D  WCFWST               113    113                                                       CRT005
     D  WCCCY1               114    116                                                       CRT005
     D  WCTRA1               117    127                                                       CRT005
     D  WCTOFR               128    143                                                       CRT005
     D  WCTRN1               144    157                                                       CRT005
     D  WCSPCD               317    319                                                       CRT005
     D  WCACKF              1004   1004                                                       CRT005
      *                                                                                       197289
     D MSGR            DS
      **  Data structure for message data returned on Dataqueue from RBA.
      *
     D  MSGR01                 1    256
     D  MSGR02               257    512
     D  MSGR03               513    768
     D  MSGR04               769   1024
     D  MSGR05              1025   1280
     D  MSGR06              1281   1536
     D  MSGR07              1537   1792
     D  MSGR08              1793   2048
     D  MSGR09              2049   2304
     D  MSGR10              2305   2560
     D  M#MSTY                 1      4                                         122060
     D  M#HMSS                29     29
     D  M#FWPE               113    113                                         122060
     D  M#TRN1               358    371
     D  M#FPSF               431    431                                         122060
     D  M#TRN2               461    474
     D  M#TRN3               515    528
     D  M#TRN4               529    542
      *
     D FIELDI          DS          1024
      **  Data structure for message data read from ICF File.
      *
     D  FLDI1                  1    256
     D  FLDI2                257    512
     D  FLDI3                513    768
     D  FLDI4                769   1024
     D  I#MSTY                 1      4
     D  I#BRNO                 5      8
     D  W#BRCA                 5      7
     D  I#USER                 9     24
     D  W#TELD                 9     11
     D  I#FLR                 25    113
     D  I#EQAC               114    126  0
     D  I#TCOD               127    129  0
     D  I#CUR1               130    132
     D  I#CUR2               133    135
     D  I#FILR               136    149
     D  I#TAMT               140    150  0
     D  I#VDAT               151    156
     D  I#REFL               157    174
     D  I#NLN1               175    209
     D  I#NLN2               210    244
     D  I#NLN3               245    279
     D  I#NLN4               280    314
     D  I#SP                 315    316
     D  I#SPCD               317    319
     D  W#TXP                315    319
     D  I#SP2                478    479
     D  I#SPC2               480    482
     D  W#TX2                478    482
     D  I#ACNO               901    913
     D  FREXRT               245    256                                                       CRT008
     D  FRCRTN               361    365                                                       CRT008
     D  FRACNO               904    913                                                       CRT008
     D  FRACN2               925    934                                                       CRT008
     D  FRAMTT               961    971                                                       CRT008
      *                                                                   122060
      ** Message Format for Drafts Issuance (also from FIELDI).           122060
      *                                                                   122060
     D  D#ACDE               114    116                                         122060
     D  D#NOST               130    135                                         122060
     D  D#DCCY               136    138                                         122060
     D  D#FCCY               139    141                                         122060
     D  D#TRC1               142    144                                         122060
     D  D#TRC2               145    147                                         122060
     D  D#TXP                148    150                                         122060
     D  D#TXP2               151    153                                         122060
     D  D#DRAM               158    168  0                                      122060
     D  D#FDAC               169    181                                         122060
     D  D#FDAM               186    196  0                                      122060
     D  D#DRNO               197    212                                         122060
     D  D#ODRN               213    228                                         122060
     D  D#DPOS               233    243  0                                      122060
     D  D#CPOS               248    258  0                                      122060
     D  D#BENF               259    293                                         122060
     D  D#VDAT               294    299                                         122060
     D  D#TDAT               300    305                                         122060
     D  D#TRF1               306    319                                         122060
     D  D#TRF2               320    333                                         122060
     D  D#TRF3               334    347                                         122060
     D  D#TRF4               348    361                                         122060
     D  D#SPAC               538    550                                         122060
     D  D#SPTC               551    552                                         122060
     D  D#AFAF               553    553                                         122060
     D  D#AFBR               554    573                                         122060
     D  D#AFAN               557    573                                         122060
     D  D#ANAF               574    574                                         122060
     D  D#ANAN               575    594                                         122060
     D  D#NOSA               578    587                                         122060
     D  D#CHCY               596    598                                         122060
     D  D#CHRG               599    629                                         122060
      *
     D FIELDO          DS
      **  Data structure for message data written to ICF File.
      *
     D  FLDO1                  1    256
     D  FLDO2                257    512
     D  FLDO3                513    768
     D  FLDO4                769   1024
     D  FLDO5               1025   1280
     D  FLDO6               1281   1536
     D  FLDO7               1537   1792
     D  FLDO8               1793   2048
     D  FLDO9               2049   2304
     D  FLDO10              2305   2560
     D  FREXCE                29     29                                                      CRT008
     D  FRMSGD                29    109                                                      CRT008
     D  FRTICCY              114    116                                                      CRT008
     D  FRTIAMT              117    127                                                      CRT008
     D  FRCCYA               130    132                                                      CRT008
     D  FRCCYT               133    135                                                      CRT008
     D  FRVLDT               151    156                                                      CRT008
     D  FRTRNO               361    365                                                      CRT008
      *
     D OSTATD          DS           111
      **  Data structure for common outgoing message status.
      *
     D  O#MSTY                 1      4
     D  O#BRCA                 5      7
     D  O#TELD                 9     11
     D  O#WKID                25     28
     D  O#HMSS                29     29
     D  O#HMSI                30     33
     D  O#HMSG                34    111
     D  O#ERR                 29    111                                                       194002
      *
     D RICMSG          DS
      **  Incoming Message (for output to LF/REPLOGL0).
      *
     D  LOG01                  1    256
     D  LOG02                257    512
     D  LOG03                513    768
     D  LOG04                769    900
     D  R#MSTY                 1      4
     D  R#WKID                25     28
     D  R#HMSS                29     29
     D  R#HMSI                30     33
     D  R#HMSG                34    111
      *
     D DTLDS           DS
      **  Break down of Transaction Type Details Array (DTL).
      *
     D  W#TTFC                 1      3
     D  W#DQNM                 4     13
     D  W#DQLN                14     18  0
     D  W#RVFN                19     21
     D  W#RVDQ                22     31
     D  W#RVDL                32     36  0
      *
     D RUNDT           DS
      **  Rundat data area.
      *
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      *
     D FTIME           DS             8
      **  Setup Time.
      *
     D  WFHR                   1      2
     D  WFILR1                 3      3    INZ(':')
     D  WFMN                   4      5
     D  WFILR2                 6      6    INZ(':')
     D  WFSS                   7      8
      *
     D TTIME           DS             6
      *
     D  WTHR                   1      2
     D  WTMN                   3      4
     D  WTSS                   5      6
      *
     D FDATE           DS             8
      **  Setup Date.
      *
     D  WFDD                   1      2
     D  WFILR3                 3      3    INZ('/')
     D  WFMM                   4      5
     D  WFILR4                 6      6    INZ('/')
     D  WFYY                   7      8
      *
     D TDATE           DS             6
      *
     D  WTDD                   1      2
     D  WTMM                   3      4
     D  WTYY                   5      6
      *
     D CISTAT          DS             6
      **  CS Status Dataarea.
      *
     D  WCSEQN                 1      6  0
      *
     D LDA             DS           256
      **  Local Data Area to identify database errors.
      *
     D  PBRCA                  1      3                                         CI001
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  DBLOT                134    183
      *
     D                 DS
      **  Data structure to hold key fields of LF/TTRNT for DBKEY in LDA.
      *
     D  @TTRNT                 1      5
     D  KTBRI                  1      1
     D  KTBID                  2      4
     D  KRCTP                  5      5
      *
      **  Data structure to hold string constants for QCMDEXC                                 197289
      *                                                                                       197289
     D @CMD            DS            80                                                       197289
     D  @BRI                  30     30                                                       197289
     D  @BID                  31     33                                                       197289
      *                                                                                       197289
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Bank Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRT005
      **  Switchable Features                                                                 CRT005
      *                                                                                       CRT005
     D SDBAII        E DS                  EXTNAME(SDBAIIPD)
      **  Cashier Interface ICD Details
      *
     D SDTELD        E DS                  EXTNAME(SDTELDPD)
      **  Teller id
      *
     D SDBAIT        E DS                  EXTNAME(SDBAITPD)
      **  Transaction types
      *
     D SDBAID        E DS                  EXTNAME(SDBAIDPD)
      **  Authorised devices
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHL1)
      **  Branch codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    122060
      **  Currency Details                                                122060
      *                                                                   122060
     D SDFNCD        E DS                  EXTNAME(SDFNCDPD)                                  CRT008
     D** Function Code  Details                                                               CRT008
                                                                                              CRT008
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Second DS for access programs, long data structure
      *
      **************************************************************************
      **  Socket Functions Prototype Definitions (Service Program SP670RE01)
      *
     D opn_tcp         pr            10i 0
 
     D bnd_tcp         pr            10i 0
     d                               10i 0 Const
     d                               10i 0 Const
     d                               10i 0 Const
 
     D con_tcp         pr            10i 0
     d                               10i 0 Const
     d                               30
     d                                2  0 Const
     d                                4  0 Const
     D sel_tcp         pr            10i 0
     d  socket                       10i 0
     d  time_sec                     10i 0
     d  wait_act                     10i 0
     d  rc                           10i 0
 
     D snd_tcp         pr            10i 0
     d                               10i 0 Const
     d                             9911
 
     D rcv_tcp         pr            10i 0
     d                               10i 0 Const
     d                             9911
 
     D cls_tcp         pr            10i 0
     d                               10i 0 Const
 
      **  Other variables
      *
     D ScktNum         S             10I 0
     D RetCode         S             10I 0
     D Header          S             11
     D Sbuffer         S           9911
     D Rbuffer         S           9911
     D MsgType         S              3
     D Risc            S             30
     d time_sec        S             10i 0
     d wait_act        S             10i 0
     d rc              S             10i 0
     d brca            S              3
     d usid            S             10
     d prfx            S              2
     D KACOD           S             10S 0                                                    CGL029
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MAIN   - Main Control Processing.                  *
      *                                                               *
      * CALLS      COMMSG - Comms Message Processing.                 *
      *            INIT   - Initial Processing.                       *
      *            RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      INIT
      *
     C     WACTIV        DOWEQ     'Y'
      *
      **  Read ICF File if Read Required Flag is set to yes.
      *
     C                   EXSR      COMMSG
      *
      **  Receive Data Queue if RCVDTAQ Required Flag is set to yes.
      *
     C     WRCVDQ        IFEQ      'Y'
     C                   EXSR      RCVDTQ
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     OPEN          IFEQ      'Y'
     C                   WRITE     TRAILP1
     C                   CLOSE     RE4503P1
     C                   ENDIF
      *
     C                   EXSR      AUDIT
      *
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *            COMMSG - Comms Message Processing.                 *
      *                                                               *
      * CALLS      *PSSR  - Progarm Error.                            *
      *            RTVMSG - Retrieve Program Message Details.         *
      *            WRTLOG - Write to Communications Log.              *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     COMMSG        BEGSR
      *
      **  Initialise the following workfields.
      *
      **         MSGS             input message data
      **         WTRID            RBA trat id
      **         WIDID            input device id
      *
      **  Reset the receive Data Queue Required Flag.
      *
     C                   MOVEL     'N'           WRCVDQ            1
      *
     C                   MOVE      *BLANKS       MSGS
     C                   MOVE      *BLANKS       WTRID            10
     C                   MOVE      *BLANKS       WIDID            10
     C                   MOVE      *BLANKS       WMDTA1
     C                   MOVE      *BLANKS       WMDTA2
      *
      **  Reset received comms file message field (incoming data).
      *
     C                   MOVE      *BLANKS       FIELDI
     C                   MOVE      'N'           WERROR            1
      *
      **  Read ICF file for incoming message data.
      * Receive next message and map it to DATAIN format
      *
     C                   Eval      Rbuffer = *Blank                                           CRT005
     C                   Eval      RetCode = Rcv_Tcp( ScktNum: Rbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   Else
     C                   eval      FIELDI= %subst(Rbuffer :12)
     C                   eval      MsgType= %subst(Rbuffer :9:3)
     C                   EndIf
      *
      ** Save Branch Code and Teller details.
      *
     C     W#BRCA        IFNE      *BLANKS
     C                   MOVEL     W#BRCA        @WBRCA            3
     C                   END
     C     W#TELD        IFNE      *BLANKS
     C                   MOVEL     W#TELD        @WTELD            3
     C                   END
      *
     C     MsgType       IFEQ      'DET'
      *
      **  Restore Branch Code and Teller details.
      *
     C                   MOVEL     @WBRCA        W#BRCA
     C                   MOVEL     @WTELD        W#TELD
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0060'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1           10
     C                   MOVEL     *BLANKS       WMDTA2           10
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'C'           O#HMSS
     C                   MOVE      *BLANKS       O#HMSI
      *
     C                   MOVE      'Y'           WCSTAT            1
     C                   MOVE      'CR'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
      **  Sign off teller from Teller Totals and Controls File.
      *
     C                   MOVEL     W#TELD        KTBID
     C                   MOVEL     '1'           KRCTP                                        197289
     C     KTTRNT        CHAIN     TTRNM2L1                           30
      *
     C     *IN30         IFEQ      *ON
     C     RECI          ORNE      'D'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0055'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVEL     *BLANKS       @WRK4             4
     C                   MOVEL     *BLANKS       @WRK5             5
     C     KTBRI         CAT       KTBID         @WRK4
     C     @WRK4         CAT       KRCTP         @WRK5
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C                   MOVEL     @WRK5         DBKEY
     C                   Z-ADD     20            DBASE
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       TWID
     C                   UPDATE    TTRNTM2F
      *
     C                   ENDIF
      *
      *
      **  End the program.
      *
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WRLBCK            1
      *
     C     WERROR        IFEQ      'N'
      *
      **  If the data format from the ICFF/RE4503CM has not been read or
      **  the mesage itself is blank.
      *
     C     FIELDI        IFEQ      *BLANKS
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0054'     @MSGID
     C                   MOVEL     'ICFREC'      WMDTA1
     C                   MOVEL     'RE4503CM'    WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      *BLANKS       P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ELSE
      *
      ****Check*Interface*ICD*to*see*if*product*is*'CASHIER*8'.***        164273
      **  Check Interface ICD to see if product is 'CASHIER  '.           164273
      *
     C     FUPROD        IFNE      W#ICDP
      *
      **  If message from invalid device.
      *
     C                   Z-ADD     WCPOS         C
     C     WIDID         LOOKUP    CDV(C)                                 60
      *
     C     *IN60         IFEQ      '0'
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0001'     @MSGID
     C                   MOVEL     WIDID         WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ****ie*the*product*is*'CASHIER*8'.***************************       164273
      **  ie the product is 'CASHIER  '.                                  164273
      *
     C                   Z-ADD     1             E                 3 0
     C     I#MSTY        LOOKUP    MTYP(E)                                67
      *
     C     *IN67         IFEQ      '0'
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0066'     @MSGID
     C                   MOVEL     I#MSTY        WMDTA1
     C                   MOVEL     FUPROD        WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ELSE
      *
      ** If a valid message type set the confirmation required flag.
      *
     C                   MOVEL     CONF(E)       CONFRQ            1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WERROR        IFEQ      'N'
     C     I#MSTY        ANDNE     'SFSO'                                                      12088
     C     I#MSTY        ANDNE     'SFWF'                                                      12088
     C     I#MSTY        ANDNE     'SFWA'                                                      12088
      *
      **  If message from invalid teller.
      *
     C                   Z-ADD     WAPOS         A
     C     W#TELD        LOOKUP    TLR(A)                                 62
      *
     C     *IN62         IFEQ      '0'
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0002'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      **  Teller Valid.
      *
     C                   ELSE
      *
      **  Ensure that the Branch matches the Teller's branch Code (SDTELDPD).
      *
     C     W#BRCA        IFNE      TBR(A)
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0012'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     W#BRCA        WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      **  If device and teller are valid, perform further message validation.
      *
     C     WERROR        IFEQ      'N'
      *                                                                   158642
     C     W#TXP         IFEQ      'SP101'                                                     15864
     C     W#TXP         OREQ      'SP250'                                                     15864
     C     W#TXP         OREQ      'SP251'                                                     15864
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C     W#TXP         OREQ      'SP252'                                                     15864
     C     I#MSTY        OREQ      'CSOV'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C     I#MSTY        OREQ      'CSIV'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C     I#MSTY        OREQ      'TLIN'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C     I#MSTY        OREQ      'TLOU'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C                   EXSR      CLOPOS                                                      15864
     C                   ELSE                                                                  15864
      *
      **  Process incoming message depending on message type.
      *
     C                   EXSR      MSGVAL
      *
     C                   ENDIF                                                                 15864
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     END#03        ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MSGVAL - Further Message Validation.               *
      *                                                               *
      * CALLS      DIMSG  - Draft Issuance Message Processing.        *
      *            MESG   - Message Processing.                       *
      *            RTVMSG - Retrieve Program Message Details.         *
      *            WRTLOG - Write to Communications Log.              *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  COMMSG - Comms message Processing.                 *
      *                                                               *
      *****************************************************************
     C     MSGVAL        BEGSR
      *
     C                   MOVEL     FLDI1         MSGS01
     C                   MOVEL     FLDI2         MSGS02
     C                   MOVEL     FLDI3         MSGS03
     C                   MOVEL     FLDI4         MSGS04
     C                   MOVEL     'Y'           MSGS05                                       CRT006
      *
     C                   MOVEL     WJOBID        W#JBDQ
     C                   MOVEL     'Y'           W#FWST                                        12088
      *
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *                                                                                       197289
      ** Perform reversal processing for any unacknowledged                                   197289
      ** transactions for this Teller, if not already dealt with.                             197289
     C                   SETOFF                                       65                      197289
     C     W#TELD        LOOKUP    UTL                                    65                  197289
     C     *IN65         IFEQ      *OFF                                                       197289
     C                   Z-ADD     1             UT                3 0                        197289
     C     *BLANKS       LOOKUP    UTL(UT)                                65                  197289
     C     *IN65         IFEQ      *ON                                                        197289
     C                   MOVEL     W#TELD        UTL(UT)                                      197289
     C                   ENDIF                                                                197289
     C                   EXSR      RBUNAK                                                     197289
     C                   ENDIF                                                                197289
      *
     C                   MOVEL     *BLANKS       @RTCD                                         12088
      *                                                                   120880
     C     I#MSTY        IFNE      'SFSO'                                                      12088
     C     I#MSTY        ANDNE     'SFWF'                                                      12088
     C     I#MSTY        ANDNE     'SFWA'                                                      12088
      *                                                                   120880
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      W#BRCA        @BRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  Branch not found.
      *
     C     @RTCD         IFNE      *BLANKS
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0003'     @MSGID
     C                   MOVEL     W#BRCA        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ELSE
      *
      ***********                                                         120880
      ****Branch*is*found*but*not*open.**                                 120880
      ***********                                                         120880
     C***********A8BRST    IFNE 'O'                                       120880
      ***********                                                         120880
      ****Retrieve*error*message*data*to*send*in*host*message.**          120880
      ***********                                                         120880
     C***********          MOVEL'USR0004' @MSGID                          120880
     C***********          MOVELW#BRCA    WMDTA1                          120880
     C***********          MOVEL*BLANKS   WMDTA2                          120880
     C***********WMDTA1    CAT  WMDTA2    @MSGDT                          120880
     C***********          EXSR RTVMSG                                    120880
     C***********          MOVEL@MSGTX    O#HMSG                          120880
     C***********          MOVE 'E'       O#HMSS                          120880
     C***********          MOVE @MSGID    O#HMSI                          120880
      ***********                                                         120880
      ****Report*error.**                                                 120880
      ***********                                                         120880
     C***********          CALL 'REC4411'                                 120880
     C***********          PARM 'RE4503'  PROG                            120880
     C***********          PARM           JOBNUM                          120880
     C***********          PARM '0000'    MMCODE                          120880
     C***********          PARM W#BRCA    P#BRCA                          120880
     C***********          PARM           @MSGID                          120880
     C***********          PARM           @MSGDT                          120880
      ***********                                                         120880
      ****Set*Off*Session*Active*Flag.**                                  120880
      ***********                                                         120880
     C***********          MOVEL'N'       WACTIV                          120880
      ***********                                                         120880
     C***********          MOVE 'N'       WCSTAT                          120880
     C***********          MOVE 'CS'      WMSTAT                          120880
     C***********          EXSR WRTLOG                                    120880
      ***********                                                         120880
     C***********          WRITESTATO                                     120880
      ***********                                                         120880
     C***********          ELSE                                           120880
      *
      **  Transaction processed requires an internal system parameter.
      *
     C                   SELECT
      *
     C     I#MSTY        WHENEQ    'CQRH'
     C                   MOVEL     'SP910'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CQDS'
     C                   MOVEL     'SP911'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSCD'
     C                   MOVEL     'SP920'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSAD'
     C                   MOVEL     'SP921'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSDM'
     C                   MOVEL     'SP922'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSCW'
     C                   MOVEL     'SP923'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSAW'
     C                   MOVEL     'SP924'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSDE'
     C                   MOVEL     'SP925'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CSRV'
     C                   MOVEL     'SP926'       W#TXP
      *
     C     I#MSTY        WHENEQ    'PBCV'
     C                   MOVEL     'SP930'       W#TXP
      *
     C     I#MSTY        WHENEQ    'PBLN'
     C                   MOVEL     'SP931'       W#TXP
      *
     C     I#MSTY        WHENEQ    'RACB'
     C                   MOVEL     'SP958'       W#TXP
      *
     C     I#MSTY        WHENEQ    'CBRQ'
     C                   MOVEL     'SP960'       W#TXP
      *
     C     I#MSTY        WHENEQ    'EQUI'
     C                   MOVEL     'SP961'       W#TXP
      *
     C                   ENDSL
      *
      ***********                                                         120880
      ****If*teller*status*flag*array*element*is*off.**                   120880
      ***********                                                         120880
     C***********TST,A     IFEQ 'OFF'                                     120880
      ***********                                                         120880
      ****Retrieve*error*message*data*to*send*in*host*message.**          120880
      ***********                                                         120880
     C***********          MOVEL'USR0007' @MSGID                          120880
     C***********          MOVELW#TELD    WMDTA1                          120880
     C***********          MOVEL*BLANKS   WMDTA2                          120880
     C***********WMDTA1    CAT  WMDTA2    @MSGDT                          120880
     C***********          EXSR RTVMSG                                    120880
     C***********          MOVEL@MSGTX    O#HMSG                          120880
     C***********          MOVE 'E'       O#HMSS                          120880
     C***********          MOVE @MSGID    O#HMSI                          120880
      ***********                                                         120880
     C***********          CALL 'REC4411'                                 120880
     C***********          PARM 'RE4503'  PROG                            120880
     C***********          PARM           JOBNUM                          120880
     C***********          PARM '0000'    MMCODE                          120880
     C***********          PARM W#BRCA    P#BRCA                          120880
     C***********          PARM           @MSGID                          120880
     C***********          PARM           @MSGDT                          120880
      ***********                                                         120880
     C***********          MOVE 'N'       WCSTAT                          120880
     C***********          MOVE 'CS'      WMSTAT                          120880
     C***********          EXSR WRTLOG                                    120880
      ***********                                                         120880
      ****Set*Off*Session*Active*Flag.**                                  120880
      ***********                                                         120880
     C***********          MOVEL'N'       WACTIV                          120880
      ***********                                                         120880
     C***********          WRITESTATO                                     120880
      ***********                                                         120880
      ****If*teller*status*flag*array*element*is*on.**                    120880
      ***********                                                         120880
     C***********          ELSE                                           120880
      *
      **  If the message received has an invalid transaction type.
      *
     C                   MOVEL     W#TXP         W#TX10           10
      *
      **  For DIRQ msg, use SP code 1 unless this is blank else use SP code 2.
      *
     C                   MOVEL     *BLANKS       W#WRK5            5                           12206
      *                                                                   122060
     C     I#MSTY        IFEQ      'DIRQ'
     C***********I#SPCD    ANDEQ*BLANK                                    122060
     C***********          MOVELW#TX2     W#TX10                          122060
     C                   MOVEL     'SP'          W#WRK5                                        12206
     C                   MOVE      D#TXP         W#WRK5                                        12206
     C                   MOVEL     W#WRK5        W#TX10                                        12206
     C                   ENDIF
      *
     C                   Z-ADD     WBPOS         B
      *                                                                                       CRT005
      ** Set On *IN64 if Message Type is 'CSOV', 'CSIV', 'TLIN', or 'TLOU';                   CRT005
      ** otherwise, look up on table TXP                                                      CRT005
      *                                                                                       CRT005
     C     I#MSTY        IFEQ      'CSOV'                                                     CRT005
     C     I#MSTY        OREQ      'CSIV'                                                     CRT005
     C     I#MSTY        OREQ      'TLIN'                                                     CRT005
     C     I#MSTY        OREQ      'TLOU'                                                     CRT005
     C                   MOVE      *ON           *IN64                                        CRT005
     C                   ELSE                                                                 CRT005
     C     W#TX10        LOOKUP    TXP(B)                                 64
     C                   ENDIF                                                                CRT005
      *                                                                                       194002
      ** Access the details and check that the transaction handler is active                  194002
     C                   SETOFF                                       70                      194002
     C     *IN64         IFEQ      '1'                                                        194002
      *                                                                                       CRT005
     C     I#MSTY        IFNE      'CSOV'                                                     CRT005
     C     I#MSTY        ANDNE     'CSIV'                                                     CRT005
     C     I#MSTY        ANDNE     'TLIN'                                                     CRT005
     C     I#MSTY        ANDNE     'TLOU'                                                     CRT005
     C     W#TX10        ANDNE     'SP251'                                                    CRT005
     C                   MOVEL     DTL(B)        DTLDS                                        194002
     C                   ENDIF                                                                CRT005
      *                                                                                       CRT005
      ** Populate data structure DTLDS when CRT005 is installed                               CRT005
      *                                                                                       CRT005
     C     I#MSTY        IFEQ      'CSOV'                                                     CRT005
     C     I#MSTY        OREQ      'CSIV'                                                     CRT005
     C     I#MSTY        OREQ      'TLIN'                                                     CRT005
     C     I#MSTY        OREQ      'TLOU'                                                     CRT005
     C     I#MSTY        OREQ      'OITM'                                                     CRT005
     C     W#TX10        ANDEQ     'SP251'                                                    CRT005
      *                                                                                       CRT005
     C                   CLEAR                   DTLDS                                        CRT005
     C                   MOVEL     'RE4122'      W#DQNM                                       CRT005
     C                   MOVEL     'RE4122'      W#RVDQ                                       CRT005
     C                   Z-ADD     1004          W#DQLN                                       CRT005
     C                   Z-ADD     1004          W#RVDL                                       CRT005
      *                                                                                       CRT005
     C                   SELECT                                                               CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'CSIV'                                                     CRT005
     C     I#MSTY        OREQ      'OITM'                                                     CRT005
     C     W#TX10        ANDEQ     'SP251'                                                    CRT005
     C     I#TCOD        ANDGE     500                                                        CRT005
     C     I#TCOD        ANDLE     999                                                        CRT005
     C                   MOVE      '0JE '        W#DQNM                                       CRT005
     C                   MOVE      '0JF '        W#RVDQ                                       CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'CSOV'                                                     CRT005
     C     I#MSTY        OREQ      'OITM'                                                     CRT005
     C     W#TX10        ANDEQ     'SP251'                                                    CRT005
     C     I#TCOD        ANDGE     0                                                          CRT005
     C     I#TCOD        ANDLE     499                                                        CRT005
     C                   MOVE      '0JF '        W#DQNM                                       CRT005
     C                   MOVE      '0JE '        W#RVDQ                                       CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'TLIN'                                                     CRT005
     C                   MOVE      '00E '        W#DQNM                                       CRT005
     C                   MOVE      '00F '        W#RVDQ                                       CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'TLOU'                                                     CRT005
     C                   MOVE      '00F '        W#DQNM                                       CRT005
     C                   MOVE      '00E '        W#RVDQ                                       CRT005
      *                                                                                       CRT005
     C                   ENDSL                                                                CRT005
      *                                                                                       CRT005
     C                   ENDIF                                                                CRT005
      *                                                                                       CRT005
     C     I#MSTY        IFEQ      'OITM'                                                     194002
     C     I#MSTY        OREQ      'RVSE'                                                     194002
     C     W#DQNM        CHAIN     REACJBL0                           70                      194002
     C                   ENDIF                                                                194002
     C                   ENDIF                                                                194002
      *                                                                                       194002
     C     *IN70         IFEQ      '1'                                                        194002
     C                   MOVEL     @MSGTX        O#HMSG                                       194002
     C                   eval      O#HMSG = ' Midas transaction inactive.'                    194002
     C                   movel     *BLANKS       @MSGDT                                       194002
     C                   movel     O#HMSG        @MSGDT                                       194002
     C                   MOVE      'E'           O#HMSS                                       194002
     C                   MOVE      RQJBNM        O#HMSI                                       194002
     C                   ENDIF                                                                194002
      *
     C     *IN64         IFEQ      '0'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0008'     @MSGID
     C                   MOVEL     W#TX10        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
     C                   ENDIF                                                                194002
      *
     C     *IN64         IFEQ      '0'                                                        194002
     C     *IN70         OREQ      '1'                                                        194002
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      **  Set up LDA DBERR.
      *
     C     *LOCK         IN        LDA
     C     *IN64         IFEQ      '0'                                                        194002
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C***********          MOVEL@TTRNT    DBKEY                           120880
     C                   MOVEL     W#TX10        DBKEY                                         12088
     C                   ELSE                                                                 194002
     C                   MOVEL     'INACTIVE'    DBFILE                                       194002
     C                   MOVEL     O#HMSI        DBKEY                                        194002
     C                   ENDIF                                                                194002
     C                   Z-ADD     21            DBASE
     C                   EXSR      DBERR
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      **  If the message received has a valid transaction type.
      *
     C                   ELSE
      *
      *
     C     I#MSTY        IFNE      'CSOV'                                                     CRT005
     C     I#MSTY        ANDNE     'CSIV'                                                     CRT005
     C     I#MSTY        ANDNE     'TLIN'                                                     CRT005
     C     I#MSTY        ANDNE     'TLOU'                                                     CRT005
     C     W#TX10        ANDNE     'SP251'                                                    CRT005
     C                   MOVEL     DTL(B)        DTLDS
     C                   ENDIF                                                                CRT005
      *
     C                   MOVE      'L'           WCSTAT
     C                   MOVE      'CR'          WMSTAT
      *
     C                   SELECT
      *
     C***********I#MSTY    WHEQ 'SFSO'                                    120880
     C***********          EXSR SOMSG                                     120880
      ***********                                                         120880
     C***********I#MSTY    WHEQ 'SFWF'                                    CI01
     C***********I#MSTY    WHEQ 'SWSF'                              CI01  120880
     C***********          EXSR WFMSG                                     120880
      *
     C     I#MSTY        WHENEQ    'DIRQ'
     C                   EXSR      DIMSG
      *
     C                   OTHER
     C                   EXSR      MESG
      *
     C                   ENDSL
      *
     C                   ENDIF
      ***********                                                         120880
     C***********          ENDIF                                          120880
      ***********                                                         120880
     C***********          ENDIF                                          120880
      *
     C                   ENDIF                                                                   -of
      *                                                                   120880
     C                   ELSE                                                                  12088
      *                                                                   120880
     C                   SELECT                                                                12088
      *                                                                   120880
     C     I#MSTY        WHENEQ    'SFSO'                                                      12088
     C                   EXSR      SOMSG                                                       12088
      *                                                                   120880
     C     I#MSTY        WHENEQ    'SFWF'                                                      12088
     C                   EXSR      WFMSG                                                       12088
      *                                                                   120880
     C                   ENDSL                                                                 12088
      *                                                                   120880
     C                   ENDIF                                                                 12088
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************   158642
      *                                                               *   158642
      *            CLOPOS - Postings Received At Branch Closure       *   158642
      *                                                               *   158642
      * CALLS      RTVMSG - Retrieve Program Message Details.         *   158642
      *            UPDLOG - Update Communications Log.                *   158642
      *                                                               *   158642
      * CALLED BY  COMMSG - Comms Message Processing.                 *   158642
      *                                                               *   158642
      *****************************************************************   158642
     C     CLOPOS        BEGSR                                                                 15864
      *                                                                   158642
      **  Ignore these messages as Midas has no use for these Equation    158642
      **  based messages. Midas has already received or will generate this158642
      **  information itself. Just answer the messages. As they are 'OITM'158642
      **  message types they require a confirmation to be used.           158642
      *
      ** Send SND message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send SND message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *                                                                   158642
     C                   ENDSR                                                                 15864
      *****************************************************************   158642
     C/EJECT                                                              158642
      *****************************************************************
      *                                                               *
      *            SOMSG  - SFSO Message Processing.                  *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MSGVAL - Further Message Validation.               *
      *                                                               *
      *****************************************************************
     C     SOMSG         BEGSR
      *
     C                   MOVEL     'SFSO'        O#MSTY                                        CI01
      *
     C                   MOVEL     *BLANKS       O#HMSG                                        CI01
     C                   MOVE      'C'           O#HMSS                                        CI01
     C                   MOVE      *BLANKS       O#HMSI                                        CI01
      *                                                                   CI01
      *
      ** Send SND message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send SND message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            WFMSG  - SWSF Message Processing.                  *   CI01
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MSGVAL - Further Message Validation.               *
      *                                                               *
      *****************************************************************
     C     WFMSG         BEGSR
      *
     C***********          MOVEL'SFWA'    R#MSTY                          CI01
     C                   MOVEL     'SFWA'        O#MSTY                                        CI01
      *
     C***********TABACK    IFEQ 'Y'                                       CI01
     C***********          WRITEOUTACK                 22                 CI01
     C***********          ELSE                                           CI01
     C***********          WRITEOUTNAK                 22                 CI01
     C***********          ENDIF                                          CI01
      *                                                                   CI01
     C                   MOVEL     *BLANKS       O#HMSG                                        CI01
     C                   MOVE      'C'           O#HMSS                                        CI01
     C                   MOVE      *BLANKS       O#HMSI                                        CI01
      *                                                                   CI01
      *
      ** Send SND message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send SND message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            DIMSG  - Draft Issuance Message Processing.        *
      *                                                               *
      * CALLS      WRTDRI - Write to PF/REPDRIPD.                     *
      *            WRTLOG - Write to Communications Log.              *
      *                                                               *
      * CALLED BY  MSGVAL - Further Message Validation.               *
      *                                                               *
      *****************************************************************
     C     DIMSG         BEGSR
      *
     C                   OPEN      REPDRIL1                                                    12206
      *                                                                   122060
     C                   Z-ADD     553           LENR                                          12206
      *                                                                   122060
     C                   MOVEL     D#DRNO        KDRNO                                         12206
     C                   MOVEL     *BLANKS       KODRN                                         12206
     C                   MOVEL     D#ACDE        KACDE                                         12206
     C     KLPDRI        CHAIN(N)  REPDRIL1                           24                       12206
      *                                                                   122060
     C     *IN24         IFEQ      '1'                                                         12206
      *                                                                   122060
     C                   CLOSE     REPDRIL1                                                    12206
      *                                                                   122060
     C                   MOVEL     'C'           O#HMSS                                        12206
     C                   MOVE      *BLANKS       O#HMSI                                        12206
     C                   MOVEL     FIELDI        O#HMSG                                        12206
      *                                                                   122060
     C                   EXSR      WRTLOG
     C                   EXSR      WRTDRI
      *
      ****Store*last*message*sent.**                                      122060
     C                   MOVEL     'Y'           WRCVDQ                                        12206
     C                   ENDIF                                                                 12206
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            MESG   - Message Processing.                       *
      *                                                               *
      * CALLS      WRTLOG - Write to Communications Log.              *
      *                                                               *
      * CALLED BY  MSGVAL - Further Message Validation.               *
      *                                                               *
      *****************************************************************
     C     MESG          BEGSR
      *
      **  Retrieve details from array DTL.
      *
     C     WRLBCK        IFEQ      'N'
      *
     C     I#MSTY        IFEQ      'RVSE'
      *
     C                   MOVE      W#RVDQ        WTRID
     C                   Z-ADD     W#RVDL        WDQLEN
      *
     C                   ELSE
      *
     C                   MOVE      W#DQNM        WTRID
     C                   Z-ADD     W#DQLN        WDQLEN            5 0
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      W#RVDQ        WTRID
     C                   Z-ADD     W#RVDL        WDQLEN
      *
     C                   ENDIF
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVE      *BLANKS       O#HMSI
     C                   MOVEL     FIELDI        O#HMSG
      *
     C                   EXSR      WRTLOG
      *
     C                   MOVE      'N'           WDQROL            1
      *
      **  Set appropriate values for data queue send.
      *
     C                   MOVEL     WTRID         DTAQS
     C                   MOVEL     '*LIBL'       LIBS
     C                   Z-ADD     WDQLEN        LENS
     C                   CALL      'QSNDDTAQ'    DTQSND
      *
      **  Set Receive Data Queue required Flag.
      *
     C                   MOVEL     'Y'           WRCVDQ
     C                   Z-ADD     2560          LENR                                          12206
     C                   MOVEL     WJOBID        DTAQR                                         12206
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            WRTLOG - Write to Communications Log.              *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  COMMSG - Comms Message Processing.                 *
      *            DIMSG  - Draft Issuance Message Processing.        *
      *            MESG   - Message Processing.                       *
      *            MSGVAL - Further Message Validation.               *
      *                                                               *
      *****************************************************************
     C     WRTLOG        BEGSR
      *
      **  Update DTAARA/CISTAT.
      *
     C     *LOCK         IN        CISTAT
     C                   ADD       1             WCSEQN
     C                   OUT       CISTAT
      *
     C                   TIME                    WTMDAT           12 0
     C                   MOVE      WTMDAT        TDATE
     C                   MOVEL     WTMDAT        TTIME
      *
     C                   MOVE      WTHR          WFHR
     C                   MOVE      WTMN          WFMN
     C                   MOVE      WTSS          WFSS
     C                   MOVE      WTDD          WFDD
     C                   MOVE      WTMM          WFMM
     C                   MOVE      WTYY          WFYY
      *
     C                   MOVEL     WCSEQN        RICMSQ
     C                   MOVEL     W#BRCA        RIBRCA
     C                   MOVEL     WTRID         RIDTQN
     C                   MOVEL     WIDID         RIRMDN
     C                   MOVEL     W#TELD        RITELD
     C     I#MSTY        IFNE      'DIRQ'                                                      12206
     C                   MOVEL     W#TXP         RITXTP
     C                   ELSE                                                                  12206
     C     'SP'          CAT       D#TXP         RITXTP                                        12206
     C                   ENDIF                                                                 12206
      *
      **  Load the Received Date & Time Stamps
      *
     C                   MOVE      FDATE         RIRCDT
     C                   MOVE      FTIME         RIRCTM
      *
      **  Load the Successful Completion flag
      *
     C                   MOVEL     WCSTAT        RISUCM
      *
      **  Load the Status & Status Time Stamp
      *
     C                   MOVEL     WMSTAT        RISTAT
     C                   MOVE      FTIME         RISTTM
      *
      **  Load RICMSG field.
      *
     C     WOAREV        IFNE      'Y'                                       CRT008
     C                   MOVEL     FLDI1         LOG01
     C                   MOVEL     FLDI2         LOG02
     C                   MOVEL     FLDI3         LOG03
     C                   MOVEL     FLDI4         LOG04
      *
     C                   MOVEL     I#MSTY        R#MSTY
     C                   MOVE      I#USER        R#WKID
     C                   MOVEL     O#HMSG        R#HMSG
     C                   MOVE      O#HMSS        R#HMSS
     C                   MOVE      O#HMSI        R#HMSI
      *
     C                   MOVEL     WCSEQN        W#SEQN
     C                   ENDIF                                                  CRT008
      *
      **  Write to the Comms Log File.
      *
     C                   WRITE     REPLOGD0
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            WRTDRI - Write to PF/REPDRIPD.                     *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  DIMSG  - Draft Issuance Message Processing.        *
      *                                                               *
      *****************************************************************
     C     WRTDRI        BEGSR
      *
     C                   OPEN      REPDRIPD                                                    12206
      *                                                                   122060
     C                   MOVE      *BLANKS       RNIMMR
     C                   MOVE      *BLANKS       RNSTAT
      *
      **  Map fields from Draft Issue Request Message to fields in PF/REPDRIPD.
      *
     C                   MOVEL     I#MSTY        RNMSTY
     C                   MOVEL     I#BRNO        RNBRNO
     C                   MOVEL     I#USER        RNUSID
     C***********          MOVELI#ACNO    RNNOSA                          122060
     C***********          MOVELI#CUR1    RNDCCY                          122060
     C***********          MOVELI#CUR2    RNFCCY                          122060
     C***********          MOVELI#SPCD    RNSPC1                          122060
     C***********          MOVELI#SPC2    RNSPC2                          122060
     C***********          Z-ADDI#TAMT    RNDRAM                          122060
     C***********          MOVELI#VDAT    RNVDAT                          122060
      *                                                                   122060
     C                   MOVEL     'Y'           RNACKF                                       CRT006
     C                   MOVEL     'D'           RNRECI                                        12206
     C                   MOVEL     W#FWST        RNFWST                                        12206
     C                   MOVEL     D#ACDE        RNACDE                                        12206
     C                   MOVEL     D#NOSA        RNNOSA                                        12206
     C                   MOVEL     D#NOST        RNNOST                                        12206
     C                   MOVEL     D#DCCY        RNDCCY                                        12206
     C                   MOVEL     D#FCCY        RNFCCY                                        12206
     C                   MOVEL     D#TRC1        RNTRC1                                        12206
     C                   MOVEL     D#TRC2        RNTRC2                                        12206
     C                   MOVEL     D#TXP         RNSPC1                                        12206
     C                   MOVEL     D#TXP2        RNSPC2                                        12206
     C                   Z-ADD     D#DRAM        RNDRAM                                        12206
     C                   MOVEL     D#AFAN        RNFDAC                                        12206
     C                   Z-ADD     D#FDAM        RNFDAM                                        12206
     C                   MOVEL     D#DRNO        RNDRNO                                        12206
     C                   MOVEL     D#ODRN        RNODRN                                        12206
     C                   Z-ADD     D#DPOS        RNDPOS                                        12206
     C                   Z-ADD     D#CPOS        RNCPOS                                        12206
     C                   MOVEL     D#BENF        RNBENF                                        12206
     C                   MOVEL     D#VDAT        RNVDAT                                        12206
     C                   MOVEL     D#TDAT        RNTDAT                                        12206
     C                   MOVEL     D#TRF1        RNTRF1                                        12206
     C                   MOVEL     D#TRF2        RNTRF2                                        12206
     C                   MOVEL     D#TRF3        RNTRF3                                        12206
     C                   MOVEL     D#TRF4        RNTRF4                                        12206
     C                   MOVEL     D#SPAC        RNSPAC                                        12206
     C                   MOVEL     D#SPTC        RNSPTC                                        12206
     C                   MOVEL     D#AFAF        RNAFAF                                        12206
     C                   MOVEL     D#AFAN        RNAFAN                                        12206
     C                   MOVEL     D#ANAF        RNANAF                                        12206
     C                   MOVEL     D#ANAN        RNANAN                                        12206
     C                   MOVEL     WJOBID        RNCJDQ                                        12206
     C                   MOVEL     D#CHCY        RNCHCY                                        12206
      *                                                                   122060
     C                   CALL      'AOCURRR0'                                                  12206
     C                   PARM      '*BLANK '     @RTCD             7                           12206
     C                   PARM      '*KEY   '     @OPTN             7                           12206
     C                   PARM                    D#CHCY                                        12206
     C     SDCURR        PARM      SDCURR        DSSDY                                         12206
      *                                                                   122060
     C     @RTCD         IFEQ      *BLANK                                                      12206
     C                   MOVEL     A6NBDP        ZADEC                                         12206
     C     15            SUB       ZADEC         ZADIG                                         12206
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   MOVEL     D#CHRG        ZFIELD                                        12206
     C                   CallB     'ZALIGN'
     C                   Parm                    ZALIGNOK          1
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   Parm                    ZADIG             2 0
      *                                                                   122060
     C     ZALIGNOK      IFEQ      *BLANKS                                                     12206
     C     ZFIELD        ANDNE     *ZERO                                                       12206
     C                   MOVE      ZFIELD        RNCHAM                                        12206
     C                   ENDIF                                                                 12206
      *
     C                   WRITE     REPDRID0
      *
     C                   CLOSE     REPDRIPD                                                    12206
      *                                                                   122060
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      * CALLS      ROLLBK - Rollback Processing.                      *
      *            RTVMSG - Retrieve Program Message Details.         *
      *            UPDLOG - Update Communications Log.                *
      *            SETPRT - Set up Forward report                     *                       CRT008
      *            WRTEXC - Write to Forward Exception file           *                       CRT008
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     RCVDTQ        BEGSR
      ***********                                                         122060
      ****Set*up*Data*Queue*Length*parm*for*receive*data*queue*(from*RBA).122060
      ***********                                                         122060
     C***********          Z-ADD2560      LENR                            122060
      *
     C                   CALL      'QRCVDTAQ'    DTQRCV
      *
      **  If dataqueue is not empty.
      *
     C     LENR          IFGT      0
      *
      **  Set ICF File Read required Flag.
      *
     C                   MOVEL     'Y'           WRDICF
      *
     C     M#MSTY        IFEQ      'DIRQ'                                                      12206
      *                                                                   122060
     C                   SELECT                                                                12206
      *                                                                   122060
     C     M#HMSS        WHENEQ    'C'                                                         12206
     C                   MOVEL     ' '           M#HMSS                                        12206
     C                   MOVEL     ' '           M#FWPE                                        12206
     C                   MOVEL     'Y'           M#FPSF                                        12206
      *                                                                   122060
     C     M#HMSS        WHENEQ    'W'                                                         12206
     C                   MOVEL     ' '           M#FWPE                                        12206
     C                   MOVEL     'S'           M#FPSF                                        12206
      *                                                                   122060
     C     M#HMSS        WHENEQ    'E'                                                         12206
     C                   MOVEL     'F'           M#FWPE                                        12206
     C                   MOVEL     'E'           M#FPSF                                        12206
      *                                                                   122060
     C                   ENDSL                                                                 12206
      *                                                                   122060
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   MOVEL     MSGR01        FLDO1
     C                   MOVEL     MSGR02        FLDO2
     C                   MOVEL     MSGR03        FLDO3
     C                   MOVEL     MSGR04        FLDO4
     C                   MOVEL     MSGR05        FLDO5
     C                   MOVEL     MSGR06        FLDO6
     C                   MOVEL     MSGR07        FLDO7
     C                   MOVEL     MSGR08        FLDO8
     C                   MOVEL     MSGR09        FLDO9
     C                   MOVEL     MSGR10        FLDO10
      *
      **  If dataqueue message is not due to rollback processing.
      *
     C***********WRLBCK    IFNE 'Y'
      *
      **  Determine if received message requires a confirmation.
      *
     C***********CONFRQ    IFEQ 'Y'
     C***********M#HMSS    ANDEQ'C'
     C***********CONFRQ    OREQ 'Y'
     C***********M#HMSS    ANDEQ'W'
     C***********          WRITEOUTACK                 22
      *
      **  If Confirm not received from the remote branch controller,
      **  retrieve error message data to send in host message.
      *
     C***********MAJMIN    IFNE '0001'
      *
     C***********          MOVEL'USR0058' @MSGID
     C***********          MOVEL*BLANKS   WMDTA1
     C***********          MOVEL*BLANKS   WMDTA2
     C***********          EXSR RTVMSG
     C***********          MOVEL@MSGTX    O#HMSG
     C***********          MOVE 'E'       O#HMSS
     C***********          MOVE @MSGID    O#HMSI
      *
      **  Report error.
      *
     C***********          CALL 'REC4411'
     C***********          PARM 'RE4503'  PROG
     C***********          PARM           JOBNUM
     C***********          PARM MAJMIN    MMCODE
     C***********          PARM W#BRCA    P#BRCA
     C***********          PARM           @MSGID
     C***********          PARM *BLANKS   @MSGDT
      *
     C***********          EXSR ROLLBK
      *
     C***********          ELSE
      *
      **  If PC application has sent a confirm.
      *
     C***********          MOVE 'CS'      WMSTAT
     C***********          EXSR UPDLOG
     C***********          END
      *
      ** If No acknowledgement required
     C***********          ELSE
      *
      ** Send SND message
      *
     C                   movel     '00002560'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FIELDO        Sbuffer
      * Send SND message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C     M#HMSS        IFEQ      'E'                                                         12206
     C     M#MSTY        ANDEQ     'DIRQ'                                                      12206
     C                   EXSR      ROLLBK                                                      12206
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C***********          ENDIF
      *
     C***********          ELSE
      *
     C***********          MOVE 'R'       WCSTAT
     C***********          MOVE 'CS'      WMSTAT
     C***********          EXSR UPDLOG
     C***********          END
      *
     C***********          ELSE
      *
      **  Set ICF File Read required Flag.
      *
     C                   MOVEL     'N'           WRDICF
      *
     C                   END
      *
      **  Generate detail report.
      *
     C***********R#HMSS    IFEQ 'W'                                       122060
     C***********R#HMSS    OREQ 'E'                                       122060
      *                                                                                       CRT008
      ** Get Information about the transaction written to TTRANPD                             CRT008
      *                                                                                       CRT008
     C                   MOVE      'T'           KBRI                                         CRT008
     C                   MOVE      W#BRCA        KITLB                                        CRT008
     C                   MOVEL     W#TELD        KBID                                         CRT008
     C                   MOVE      FRTRNO        KTBTN                                        CRT008
      *                                                                                       CRT008
     C                   OPEN      TTRANL1                                                    CRT008
      *                                                                                       CRT008
     C     KTRNL1        CHAIN     TTRANPDF                                                   CRT008
      *                                                                                       CRT008
     C                   CLOSE     TTRANL1                                                    CRT008
      *                                                                                       CRT008
      ** Set suspense flag, if transaction is to be posted to suspense                        CRT008
      *                                                                                       CRT008
     C                   MOVE      'N'           FWSUSP                                       CRT008
     C     M#HMSS        IFNE      'E'                                                        CRT008
     C     ACNO          ANDEQ     0                                                          CRT008
     C     CUS1          ANDNE     *BLANKS                                                    CRT008
     C     ACD1          ANDNE     0                                                          CRT008
     C                   MOVE      'Y'           FWSUSP                                       CRT008
     C                   ENDIF                                                                CRT008
      *                                                                                       CRT008
      ** If the transaction has a terminal error, a warning error or it                       CRT008
      ** has been posted to suspense then include it on the forward report                    CRT008
      *                                                                                       CRT008
     C     M#HMSS        IFEQ      'W'                                                         12206
     C     M#HMSS        OREQ      'E'                                                         12206
     C     FWSUSP        OREQ      'Y'                                                        CRT008
      *                                                                                       CRT008
      ** Remove old fields from previous forward report                                       CRT008
      *                                                                                       CRT008
     C***********        MOVEL     WCSEQN        PCMSQ                                        CRT008
     C***********        MOVEL     W#BRCA        PBRCA                                        CRT008
     C***********        MOVEL     W#TELD        PTELD                                        CRT008
     C**********         MOVEL     I#ACNO        PACNO                                        CRT008
      *                                                                                       CRT008
      ** Call subroutine to set up the fields for the report                                  CRT008
      *                                                                                       CRT008
     C                   EXSR      SETPRT                                                     CRT008
     C
     C***********          MOVELI#AMT1    PAMT1
     C***********          MOVELI#CCY1    PCCY1
     C***********          MOVELI#SPNO    PSPCD
     C***********          MOVEL     O#HMSS        PHMSS                                      CRT008
     C***********          MOVELO#HSMS    PHSMS                                                RBA01
     C***********          MOVEL     O#HMSG        PHSMS                                RBA01 CRT008
      *
     C     OPEN          IFEQ      'N'
     C                   OPEN      RE4503P1
     C                   EXSR      RCFP1
     C                   WRITE     HEADP1
     C                   WRITE     DTLHDR
     C                   MOVEL     'Y'           OPEN
     C                   ENDIF
      *
     C     OPEN          IFEQ      'Y'
     C     *IN40         ANDEQ     '1'
     C                   WRITE     HEADP1
     C                   WRITE     DTLHDR
     C                   MOVEL     '0'           *IN40
     C                   ENDIF
      *
     C                   WRITE     DETAIL
     C                   WRITE     DETLS2
      *                                                                                       CRT008
      ** Call Subroutine to write to Forwarding Exceptions file REFWDEPD                      CRT008
      *                                                                                       CRT008
     C     FREXCE        IFEQ      'W'                                                        CRT008
     C     FREXCE        OREQ      'E'                                                        CRT008
     C     FWSUSP        OREQ      'Y'                                                        CRT008
     C                   EXSR      WRTEXC                                                     CRT008
     C                   ENDIF                                                                CRT008
      *
     C                   ADD       1             WCNT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      *            RTVMSG - Retrieve Message from Message File        *
      *                                                               *
      * CALLS     REC4160 - Retrive Message from Message File         *
      *                                                               *
      * CALLED BY  MOVDET - Move Details to Send to Outgoing DataQ    *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
      *
     C     RTVMSG        BEGSR
      *
     C                   CALL      'REC4160'
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGF            10
     C                   PARM                    @MSGDT          256
     C                   PARM      *BLANKS       @MSGTX           80
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            ROLLBK - Rollback Processing.                      *
      *                                                               *
      * CALLS      UPDLOG - Update Communications Log.                *
      *                                                               *
      * CALLED BY  RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      *****************************************************************
     C     ROLLBK        BEGSR
      *                                                                   122060
     C     I#MSTY        IFNE      'DIRQ'                                                      12206
      *
      **  Access LF/REPLOGL9 to retrieve last record for this teller.
      *
     C                   MOVEL     W#BRCA        @BRCA
     C                   MOVEL     W#TELD        @TELD
     C                   MOVEL     *BLANKS       @RITELD           3                          197289
     C     *HIVAL        SETGT     REPLOGL0                           70                      197289
     C*****KLLOG9*****   SETGT     REPLOGL9                           70                      197289
      *
      **  Check that neither BRCA not TELD are different from those in the
      **  partial key. If so we have gone past our requiered teller.
      *
     C**********         READP     REPLOGL9                               70                  197289
     C                   SETOFF                                       70                      197289
     C*                                                                                       197289
     C     R#MSTY        DOUEQ     'OITM'                                                     197289
     C     @RITELD       ANDEQ     W#TELD                                                     197289
     C     R#MSTY        OREQ      'RVSE'                                                     197289
     C     @RITELD       ANDEQ     W#TELD                                                     197289
     C     R#MSTY        OREQ      'DIRQ'                                                     197289
     C     @RITELD       ANDEQ     W#TELD                                                     197289
     C     *IN70         OREQ      *ON                                                        197289
     C                   READP (N) REPLOGL0                               70                  197289
     C     *IN70         IFEQ      *OFF                                                       197289
     C                   MOVEL     RITELD        @RITELD                                      197289
     C                   ENDIF                                                                197289
     C                   ENDDO                                                                197289
      *
      **  Chain to REPLOGL0 to do the update to show that it has been rolled
      **  back (or perhaps write a new record in REPLOGPD).
      *
      **  Set message type.
      **
      **  THIS IS WRONG SORT IT OUT . NOT THIS TYPE OF SETTING TO LAST
      **  MESSAGE TYPE. NEED TO FIND LAST RECORD IN REPLOGL9 for this teller.
      **
      ** Set the ROLLBACK flag.
      *
     C                   MOVE      'Y'           WRLBCK
      *
     C                   MOVE      'Y'           WDQROL
      *
     C                   MOVE      'L'           WCSTAT
     C                   MOVE      'CR'          WMSTAT
      *
     C                   MOVE      W#RVDQ        WTRID
      *
      ** #### PERHAPS WE SHOULD WRITE A NEW LOG RECORD FOR THE ROLLBACK ####
      *
     C***********          EXSR UPDLOG                                    HUW
     C                   EXSR      WRTLOG                                                      HUW
      *
     C                   MOVE      W#RVDQ        DTAQS
     C                   Z-ADD     W#RVDL        LENS
      *
      **  Set transaction reference fields for Reversal
      *
     C                   MOVEL     M#TRN1        R#TRN1
     C                   MOVEL     M#TRN2        R#TRN2
     C                   MOVEL     M#TRN3        R#TRN3
     C                   MOVEL     M#TRN4        R#TRN4
      *
     C                   CALL      'QSNDDTAQ'    DTQSND
      *
      **  Set up Data Queue Length parm for receive data queue (from RBA).
      *
     C                   Z-ADD     2560          LENR
      *
     C                   CALL      'QRCVDTAQ'    DTQRCV
      *
     C                   ELSE                                                                  12206
      *                                                                   122060
     C                   OPEN      REPDRIL1                                                    12206
      *                                                                   122060
     C                   MOVEL     D#DRNO        KDRNO                                         12206
     C                   MOVEL     *BLANKS       KODRN                                         12206
     C                   MOVEL     D#ACDE        KACDE                                         12206
     C     KLPDRI        CHAIN     REPDRIL1                           24                       12206
      *                                                                   122060
     C     *IN24         IFEQ      '0'                                                         12206
     C                   MOVEL     '*'           RNRECI                                        12206
     C                   UPDATE    REPDRILF                                                    12206
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   CLOSE     REPDRIL1                                                    12206
      *                                                                   122060
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  197289
      *****************************************************************                       197289
      *                                                               *                       197289
      *            RBUNAK - Re-start rollback per Cashier.            *                       197289
      *                                                               *                       197289
      * CALLS      WRTLOG - Write Communications Log.                 *                       197289
      *                                                               *                       197289
      * CALLED BY  MSGVAL - Initial Processing.                       *                       197289
      *                                                               *                       197289
      *****************************************************************                       197289
     C     RBUNAK        BEGSR                                                                197289
      *                                                                                       197289
      **  Access LF/REPLOGL0 to retrieve last record for this teller.                         197289
      *                                                                                       197289
     C                   MOVEL     brca          @BRCA                                        197289
     C                   MOVEL     W#TELD        @TELD                                        197289
      *                                                                                       197289
     C                   MOVEL     *BLANKS       @RITELD           3                          197289
     C     *HIVAL        SETGT     REPLOGL0                           70                      197289
      *                                                                                       197289
      **  Look for the previous message for this Teller.                                      197289
      **  Must be an Ordinary Item or a Reversal, or a Draft.                                 197289
      *                                                                                       197289
     C                   SETOFF                                       70                      197289
     C*                                                                                       197289
     C     R#MSTY        DOUEQ     'OITM'                                                     197289
     C     @RITELD       ANDEQ     W#TELD                                                     197289
     C     R#MSTY        OREQ      'RVSE'                                                     197289
     C     @RITELD       ANDEQ     W#TELD                                                     197289
     C     R#MSTY        OREQ      'DIRQ'                                                     197289
     C     @RITELD       ANDEQ     W#TELD                                                     197289
     C     R#MSTY        OREQ      'CSIV'                                                     CRT005
     C     @RITELD       ANDEQ     W#TELD                                                     CRT005
     C     R#MSTY        OREQ      'CSOV'                                                     CRT005
     C     @RITELD       ANDEQ     W#TELD                                                     CRT005
     C     R#MSTY        OREQ      'TLIN'                                                     CRT005
     C     @RITELD       ANDEQ     W#TELD                                                     CRT005
     C     R#MSTY        OREQ      'TLOU'                                                     CRT005
     C     @RITELD       ANDEQ     W#TELD                                                     CRT005
     C     *IN70         OREQ      *ON                                                        197289
     C                   READP (N) REPLOGL0                               70                  197289
     C     *IN70         IFEQ      *OFF                                                       197289
     C                   MOVEL     RITELD        @RITELD           3                          197289
     C                   ENDIF                                                                197289
     C                   ENDDO                                                                197289
      *                                                                                       197289
     C     *IN70         IFEQ      *OFF                                                       197289
      *                                                                                       197289
     C     R#MSTY        IFEQ      'OITM'                                                     197289
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C     R#MSTY        OREQ      'OITM'                                                     CRT005
     C     CRT005        ANDEQ     'Y'                                                        CRT005
     C     RITXTP        ANDNE     'SP251'                                                    CRT005
     C     R#MSTY        OREQ      'RVSE'                                                     197289
     C                   MOVEL     *BLANKS       @CMD                                         197289
     C                   MOVEL     @TXT(1)       @CMD                                         197289
      *                                                                                       197289
     C                   CALL      'QCMDEXC'                            75                    197289
     C                   PARM                    @CMD                                         197289
     C                   PARM      80            @LEN             15 5                        197289
      *                                                                                       197289
      *                                                                                       197289
     C                   MOVEL     *BLANKS       @CMD                                         197289
     C                   MOVEL     @TXT(2)       @CMD                                         197289
     C                   MOVEL     'T'           @BRI                                         197289
     C                   MOVEL     @TELD         @BID                                         197289
      *                                                                                       197289
     C                   CALL      'QCMDEXC'                                                  197289
     C                   PARM                    @CMD                                         197289
     C                   PARM      80            @LEN                                         197289
      *                                                                                       197289
      ** Set up key list for TTRNTM3                                                          197289
     C                   MOVEL     'T'           KTBRI                                        197289
     C                   MOVEL     @TELD         KTBID                                        197289
     C                   MOVEL     '2'           KRCTP                                        197289
      *                                                                                       197289
      ** Retrieve Teller's transaction number of last update.                                 197289
     C     KTTRNT        CHAIN     TTRNTM3                            70                      197289
      *                                                                                       197289
      *                                                                                       197289
     C                   OPEN      TTRANL1                                                    197289
      *                                                                                       197289
     C                   MOVE      'T'           KBRI                                         197289
     C                   MOVE      @BRCA         KITLB                                        197289
     C                   MOVEL     @TELD         KBID                                         197289
     C                   Z-ADD     TTLU          KTBTN                                        197289
      *                                                                                       197289
      ** Access the Teller's last transaction record, to see if it is                         197289
      ** Acknowledged.                                                                        197289
     C     KTRNL1        CHAIN     TTRANPDF                           71                      197289
      *                                                                                       197289
     C                   CLOSE     TTRANL1                                                    197289
      *                                                                                       197289
     C     ACKF          IFNE      'Y'                                                        197289
      *                                                                                       197289
      ** Set the ROLLBACK flag.                                                               197289
      *                                                                                       197289
     C                   MOVE      'Y'           WRLBCK                                       197289
      *                                                                                       197289
     C                   MOVE      'Y'           WDQROL                                       197289
      *                                                                                       197289
     C                   MOVE      'L'           WCSTAT                                       197289
     C                   MOVE      'CR'          WMSTAT                                       197289
      *                                                                                       197289
     C                   SETOFF                                       64                      197289
     C                   Z-ADD     WBPOS         B                                            197289
     C     RITXTP        LOOKUP    TXP(B)                                 64                  197289
      *                                                                                       197289
     C     *IN64         IFEQ      '1'                                                        197289
     C                   MOVEL     DTL(B)        DTLDS                                        197289
     C                   SETOFF                                       64                      197289
      *                                                                                       197289
      ** Save WTRID to restore later.                                                         197289
     C                   MOVE      WTRID         W#TRID                                       197289
     C                   MOVE      W#RVDQ        WTRID                                        197289
      *                                                                                       197289
     C                   MOVE      'Y'           WOAREV            1                          CRT008
     C                   EXSR      WRTLOG                                                     197289
     C                   MOVE      'N'           WOAREV                                       CRT008
      *                                                                                       197289
     C                   MOVEL     ACNO          ROMAC1                                       197289
     C                   MOVEL     ACNO          ROMAC2                                       197289
     C                   MOVE      W#RVDQ        DTAQO                                        197289
     C                   MOVE      LIBR          LIBO                                         197289
     C                   Z-ADD     W#RVDL        LENO                                         197289
     C                   Z-ADD     WAITR         WAITO                                        197289
      *                                                                                       197289
      **  Set transaction reference fields for Reversal                                       197289
      *                                                                                       197289
     C                   MOVEL     RICMSG        MSGO                                         197289
     C                   MOVEL     'RVSE'        MSGO01                                       197289
     C                   MOVEL     @BRCA         WOBRCA                                       197289
     C                   MOVEL     @TELD         WOUSID                                       197289
     C                   MOVEL     WJOBID        WOJBDQ                                       197289
     C                   MOVEL     WCSEQN        WOSEQN                                       197289
     C                   MOVEL     'Y'           WOFWST                                       197289
     C                   MOVE      'Y'           MSGO05                                       197289
     C                   MOVE      AMT1          WOAMT                                        CRT008
      *                                                                                       197289
      ** Call Subroutine to print report                                                      CRT008
      *                                                                                       CRT008
     C                   EXSR      ARVRPT                                                     CRT008
      *                                                                                       CRT008
     C                   CALL      'QSNDDTAQ'    DTQSNO                                       197289
      *                                                                                       197289
     C                   EXSR      WRTLOG                                                     197289
      *                                                                                       197289
      **  Set up Data Queue Length parm for receive data queue (from RBA).                    197289
      *                                                                                       197289
     C                   Z-ADD     2560          LENR                                         197289
      *                                                                                       197289
     C                   MOVE      DTAQR         DTAQA                                        197289
     C                   MOVE      LIBR          LIBA                                         197289
     C                   MOVE      LENR          LENA                                         197289
     C                   MOVE      WAITR         WAITA                                        197289
     C                   CALL      'QRCVDTAQ'    DTQRCA                                       197289
      *                                                                                       197289
      ** Restore flags.                                                                       197289
      *                                                                                       197289
     C                   MOVE      'N'           WRLBCK                                       197289
      *                                                                                       197289
     C                   MOVE      'N'           WDQROL                                       197289
     C                   MOVE      WTRID         W#TRID                                       197289
      *                                                                                       197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   ELSE                                                                 197289
      *                                                                                       197289
     C     R#MSTY        IFEQ      'DIRQ'                                                     197289
      *                                                                                       197289
     C                   OPEN      REPDRIL1                                                   197289
      *                                                                                       197289
     C                   MOVEL     D#DRNO        KDRNO                                        197289
     C                   MOVEL     *BLANKS       KODRN                                        197289
     C                   MOVEL     D#ACDE        KACDE                                        197289
     C     KLPDRI        CHAIN(N)  REPDRIL1                           24                      197289
      *                                                                                       197289
     C     RNACKF        IFNE      'Y'                                                        197289
      *                                                                                       197289
     C     *IN24         IFEQ      '0'                                                        197289
     C                   MOVEL     '*'           RNRECI                                       197289
     C                   UPDATE    REPDRILF                                                   197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   CLOSE     REPDRIL1                                                   197289
      *                                                                                       CRT005
     C                   ELSE                                                                 CRT005
                                                                                              CRT005
      ** New messages (CSIV, CSOV, TLIN and TLOU and SP251)                                   CRT005
                                                                                              CRT005
     C     R#MSTY        IFEQ      'CSOV'                                                     CRT005
     C     R#MSTY        OREQ      'CSIV'                                                     CRT005
     C     R#MSTY        OREQ      'TLIN'                                                     CRT005
     C     R#MSTY        OREQ      'TLOU'                                                     CRT005
     C     R#MSTY        OREQ      'OITM'                                                     CRT005
     C     RITXTP        ANDEQ     'SP251'                                                    CRT005
     C                   MOVEL     *BLANKS       @CMD                                         CRT005
     C                   MOVEL     @TXT(1)       @CMD                                         CRT005
      *                                                                                       CRT005
     C                   CALL      'QCMDEXC'                            75                    CRT005
     C                   PARM                    @CMD                                         CRT005
     C                   PARM      80            @LEN                                         CRT005
      *                                                                                       CRT005
     C                   MOVEL     *BLANKS       @CMD                                         CRT005
     C                   MOVEL     @TXT(2)       @CMD                                         CRT005
     C                   MOVEL     'T'           @BRI                                         CRT005
     C                   MOVEL     @TELD         @BID                                         CRT005
      *                                                                                       CRT005
     C                   CALL      'QCMDEXC'                                                  CRT005
     C                   PARM                    @CMD                                         CRT005
     C                   PARM      80            @LEN                                         CRT005
                                                                                              CRT005
      ** Set up key list for TTRNTM3                                                          CRT005
                                                                                              CRT005
     C                   MOVEL     'T'           KTBRI                                        CRT005
     C                   MOVEL     @TELD         KTBID                                        CRT005
     C                   MOVEL     '2'           KRCTP                                        CRT005
                                                                                              CRT005
      ** Retrieve Teller's transaction number of last update.                                 CRT005
                                                                                              CRT005
     C     KTTRNT        CHAIN     TTRNTM3                            70                      CRT005
      *                                                                                       CRT005
     C                   OPEN      TTRANL1                                                    CRT005
      *                                                                                       CRT005
     C                   MOVE      'T'           KBRI                                         CRT005
     C                   MOVE      @BRCA         KITLB                                        CRT005
     C                   MOVEL     @TELD         KBID                                         CRT005
     C                   Z-ADD     TTLU          KTBTN                                        CRT005
                                                                                              CRT005
      ** Access the Teller's last transaction record, to see if it is                         CRT005
      ** Acknowledged.                                                                        CRT005
                                                                                              CRT005
     C     KTRNL1        CHAIN     TTRANPDF                           71                      CRT005
      *                                                                                       CRT005
     C                   CLOSE     TTRANL1                                                    CRT005
      *                                                                                       CRT005
     C     ACKF          IFNE      'Y'                                                        CRT005
                                                                                              CRT005
     C                   CLEAR                   DTLDS                                        CRT005
     C                   MOVEL     'RE4122'      W#DQNM                                       CRT005
     C                   MOVEL     'RE4122'      W#RVDQ                                       CRT005
     C                   Z-ADD     1004          W#DQLN                                       CRT005
     C                   Z-ADD     1004          W#RVDL                                       CRT005
      *                                                                                       CRT005
     C                   SELECT                                                               CRT005
                                                                                              CRT005
      ** Setup data queue                                                                     CRT005
                                                                                              CRT005
     C     R#MSTY        WHENEQ    'CSIV'                                                     CRT005
     C                   MOVE      '0JF '        W#DQNM                                       CRT005
     C                   MOVE      '0JE '        W#RVDQ                                       CRT005
     C                   MOVEL     'CSOV'        WCMSTY                                       CRT005
     C                   MOVEL     TBID          WCUSID                                       CRT005
     C                   MOVEL     *BLANK        WCTOFR                                       CRT005
      *                                                                                       CRT005
     C     R#MSTY        WHENEQ    'CSOV'                                                     CRT005
     C                   MOVE      '0JE '        W#DQNM                                       CRT005
     C                   MOVE      '0JF '        W#RVDQ                                       CRT005
     C                   MOVEL     'CSIV'        WCMSTY                                       CRT005
     C                   MOVEL     TBID          WCUSID                                       CRT005
     C                   MOVEL     *BLANK        WCTOFR                                       CRT005
      *                                                                                       CRT005
     C     R#MSTY        WHENEQ    'TLIN'                                                     CRT005
     C                   MOVE      '00F '        W#DQNM                                       CRT005
     C                   MOVE      '00E '        W#RVDQ                                       CRT005
     C                   MOVEL     'TLOU'        WCMSTY                                       CRT005
     C                   MOVEL     TBID          WCUSID                                       CRT005
     C                   MOVEL     RTLI          WCTOFR                                       CRT005
      *                                                                                       CRT005
     C     R#MSTY        WHENEQ    'TLOU'                                                     CRT005
     C                   MOVE      '00E '        W#DQNM                                       CRT005
     C                   MOVE      '00F '        W#RVDQ                                       CRT005
     C                   MOVEL     'TLIN'        WCMSTY                                       CRT005
     C                   MOVEL     TBID          WCUSID                                       CRT005
     C                   MOVEL     RTLI          WCTOFR                                       CRT005
      *                                                                                       CRT005
     C     R#MSTY        WHENEQ    'OITM'                                                     CRT005
     C     FNCD          ANDEQ     '0JE'                                                      CRT005
     C                   MOVE      '0JF '        W#DQNM                                       CRT005
     C                   MOVE      '0JE '        W#RVDQ                                       CRT005
      *                                                                                       CRT005
     C     R#MSTY        WHENEQ    'OITM'                                                     CRT005
     C     FNCD          ANDEQ     '0JF'                                                      CRT005
     C                   MOVE      '0JE '        W#DQNM                                       CRT005
     C                   MOVE      '0JF '        W#RVDQ                                       CRT005
      *                                                                                       CRT005
     C                   ENDSL                                                                CRT005
      *                                                                                       CRT005
     C     R#MSTY        IFEQ      'OITM'                                                     CRT005
     C                   MOVEL     RICMSG        MSGO                                         CRT005
     C                   MOVEL     MSGO01        I#MSTY                                       CRT005
     C                   MOVEL     ITLB          WOBRCA                                       CRT005
     C                   MOVEL     TBID          WOUSID                                       CRT005
     C                   MOVEL     WJOBID        WOJBDQ                                       CRT005
     C                   MOVEL     WCSEQN        WOSEQN                                       CRT005
     C                   MOVEL     RITXTP        W#TXP                                        CRT005
     C                   MOVE      W#TXP         WOSPCD                                       CRT005
     C                   MOVEL     'Y'           WOFWST                                       CRT005
     C                   MOVE      'Y'           MSGO05                                       CRT005
                                                                                              CRT005
      ** Save fields to restore later.                                                        CRT005
                                                                                              CRT005
     C                   MOVE      W#BRCA        W#BRCH                                       CRT005
     C                   MOVE      WOBRCA        W#BRCA                                       CRT005
     C                   MOVE      W#TELD        W#TELR                                       CRT005
     C                   MOVE      WOUSID        W#TELD                                       CRT005
     C                   ELSE                                                                 CRT005
     C                   MOVEL     WCMSTY        I#MSTY                                       CRT005
     C                   MOVEL     ITLB          WCBRNM                                       CRT005
     C                   MOVEL     WJOBID        WCJBDQ                                       CRT005
     C                   MOVEL     'Y'           WCFWST                                       CRT005
     C                   MOVEL     CCY1          WCCCY1                                       CRT005
     C                   MOVE      AMT1          WCTRA1                                       CRT005
     C                   MOVE      *BLANK        WCTRN1                                       CRT005
     C                   MOVEL     *BLANK        WCSPCD                                       CRT005
     C                   MOVE      'Y'           WCACKF                                       CRT005
                                                                                              CRT005
      ** Save fields to restore later.                                                        CRT005
                                                                                              CRT005
     C                   MOVE      W#BRCA        W#BRCH                                       CRT005
     C                   MOVE      WCBRNM        W#BRCA                                       CRT005
     C                   MOVE      W#TELD        W#TELR                                       CRT005
     C                   MOVE      WCUSID        W#TELD                                       CRT005
     C                   ENDIF                                                                CRT005
                                                                                              CRT005
      ** Save other fields to restore later.                                                  CRT005
                                                                                              CRT005
     C                   MOVE      WTRID         W#TRID                                       CRT005
     C                   MOVE      W#DQNM        WTRID                                        CRT005
      *                                                                                       CRT005
     C                   MOVE      'L'           WCSTAT                                       CRT005
     C                   MOVE      'CR'          WMSTAT                                       CRT005
      *                                                                                       CRT005
     C                   EXSR      WRTLOG                                                     CRT005
      *                                                                                       CRT005
     C     R#MSTY        IFEQ      'OITM'                                                     CRT005
      *                                                                                       CRT005
     C                   MOVE      WCSEQN        WOSEQN                                       CRT005
                                                                                              CRT005
      ** Send opposite of the unacknowledged transaction.                                     CRT005
                                                                                              CRT005
     C                   MOVEL     W#DQNM        DTAQO                                        CRT005
     C                   MOVEL     LIBR          LIBO                                         CRT005
     C                   MOVEL     W#DQLN        LENO                                         CRT005
      *                                                                                       CRT005
     C                   CALL      'QSNDDTAQ'    DTQSNO                                       CRT005
     C                   ELSE                                                                 CRT005
      *                                                                                       CRT005
     C                   MOVE      WCSEQN        WCCMSQ                                       CRT005
                                                                                              CRT005
      ** Send opposite of the unacknowledged transaction.                                     CRT005
                                                                                              CRT005
     C                   MOVEL     W#DQNM        DTAQC                                        CRT005
     C                   MOVEL     LIBR          LIBC                                         CRT005
     C                   MOVEL     W#DQLN        LENC                                         CRT005
      *                                                                                       CRT005
     C                   CALL      'QSNDDTAQ'    DTQSNC                                       CRT005
     C                   ENDIF                                                                CRT005
                                                                                              CRT005
      ** Receive opposite of the unacknowledged transaction.                                  CRT005
                                                                                              CRT005
     C                   MOVEL     DTAQR         DTAQI                                        CRT005
     C                   MOVEL     LIBR          LIBI                                         CRT005
     C                   MOVEL     LENR          LENI                                         CRT005
     C                   MOVEL     WAITR         WAITI                                        CRT005
      *                                                                                       CRT005
     C                   CALL      'QRCVDTAQ'    DTQRCI                                       CRT005
                                                                                              CRT005
      ** Restore flags.                                                                       CRT005
                                                                                              CRT005
     C                   MOVE      W#TRID        WTRID                                        CRT005
     C                   MOVE      W#BRCH        W#BRCA                                       CRT005
     C                   MOVE      W#TELR        W#TELD                                       CRT005
      *                                                                                       CRT005
     C                   ENDIF                                                                CRT005
     C                   ENDIF                                                                CRT005
      *                                                                                       197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   ENDIF                                                                197289
      *                                                                                       197289
     C                   ENDSR                                                                197289
      *****************************************************************                       197289
     C/EJECT
      *****************************************************************
      *                                                               *
      *            INIT   - Initial Processing.                       *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling.                  *
      *            ZDATE9 - Cvt day nbr to date format YYYYMMDD.      *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      **  Define Entry list
      *
     C     *entry        plist
     C                   parm                    ScktNum
     C                   parm                    brca
     C                   parm                    usid
     C                   parm                    prfx
      *
     C                   MOVEA     CPY@          BIS@             80
      *                                                                                       194002
      ** Check if the Interface Monitor is Active.                                            194002
      ** If *DTAARA REC4432 is NOT locked then the transaction handler                        194002
      ** jobs are unlikely to be available to process forwarded data.                         194002
      ** Return an error to the server.                                                       194002
      *                                                                                       194002
     C                   CALL      'REC4000'                                                  194002
     C                   PARM      'REC4432   '  wobnm            10                          194002
     C                   PARM      '*DTAARA   '  wobtp            10                          194002
     C                   PARM      *blanks       lockrtn           7                          194002
      *                                                                                       194002
     C     lockrtn       IFEQ      'FREE   '                                                  194002
     C     lockrtn       OREQ      'NOOBJ  '                                                  194002
      *                                                                                       194002
     C                   clear                   O#ERR                                        194002
     C                   movel     'E'           O#HMSS                                       194002
     C                   eval      O#HMSG = 'Midas interface inactive.'                       194002
     C                   movel     *BLANKS       @MSGDT                                       194002
     C                   movel     O#HMSG        @MSGDT                                       194002
     C                   CALL      'REC4411'                                                  194002
     C                   PARM      'RE004503'    PROG             10                          194002
     C                   PARM                    JOBNUM            6                          194002
     C                   PARM      '0000'        MMCODE            4                          194002
     C                   PARM      PBRCA         P#BRCA            3                          194002
     C                   PARM      *BLANKS       @MSGID            7                          194002
     C                   PARM                    @MSGDT                                       194002
     C                   movel     '00000087'    header                                       194002
     C                   move      'ERR'         header                                       194002
     C                   clear                   Sbuffer                                      194002
     C     Header        cat       O#ERR         Sbuffer                                      194002
      * Send ERR message                                                                      194002
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )                      194002
     C                   If        RetCode = -1                                               194002
     C                   exsr      tcperr                                                     194002
     C                   EndIf                                                                194002
      * Close Socket and exit                                                                 194002
     C                   eval      RetCode = Cls_Tcp( ScktNum )                               194002
     C     *LOCK         IN        LDA                                                        194002
     C                   MOVEL     'INACTIVE'    DBFILE                                       194002
     C                   MOVEL     'REC4432'     DBKEY                                        194002
     C                   Z-ADD     22            DBASE                                        194002
     C                   exsr      dberr                                                      194002
     C                   ENDIF                                                                194002
      *
      **  Define Keylist(s).
      **  Set up key list for LF/TTRNM2L1.
      *
     C     KTTRNT        KLIST
     C                   KFLD                    KTBRI             1
     C                   KFLD                    KTBID             3
     C                   KFLD                    KRCTP             1
      *
      **  Set up parameters for key list KTTRNT.
      *
     C                   MOVEL     'T'           KTBRI
     C                   MOVEL     *BLANKS       KTBID
     C                   MOVEL     '1'           KRCTP
      *
      **  Set up partial key list for Communications Log File LF/REPLOGL9.
      *
     C     KLLOG9        KLIST
     C                   KFLD                    @BRCA             3
     C                   KFLD                    @TELD            10
      *                                                                   122060
      **  Set up key list for accounts file ACCNTL0.                      122060
      *                                                                   122060
     C*****KACNT         KLIST                                                          12206 CSD027
     C*****              KFLD                    KCUST             6 0                  12206 CSD027
     C*****              KFLD                    KCCY              3                    12206 CSD027
     C**********         KFLD                    KACOD             4 0                  12206 CGL029
     C*****              KFLD                    KACOD                                 CGL029 CSD027
     C*****              KFLD                    KACSQ             2 0                  12206 CSD027
     C*****              KFLD                    KBRCD             3                    12206 CSD027
      *                                                                   122060
      **  Set up key list for Drafs Incoming Msg REPDRIL1.                122060
      *                                                                   122060
     C     KLPDRI        KLIST                                                                 12206
     C                   KFLD                    KDRNO            16                           12206
     C                   KFLD                    KODRN            16                           12206
     C                   KFLD                    KACDE             3                           12206
      *                                                                                       197289
      ** Set up key list for Teller Transaction Details                                       197289
      *                                                                                       197289
     C     KTRNL1        KLIST                                                                197289
     C                   KFLD                    KBRI              1                          197289
     C                   KFLD                    KITLB             3                          197289
     C                   KFLD                    KBID              3                          197289
     C                   KFLD                    KTBTN             5 0                        197289
      *
      **  Clear DB ERROR information in LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *
     C                   CALL      'SF0410'
     C                   PARM      *BLANKS       PGRP             50
     C                   PARM      USRID         PUSR             25
     C                   PARM      *ZEROS        PLVL              4 0
     C                   PARM      *ZEROS        PTIM              5 0
     C                   PARM      *ZEROS        PERR              1 0
     C                   PARM      *BLANKS       PMLT              2
      *
     C     PMLT          IFEQ      *BLANK
     C                   MOVEL     'GB'          PMLT
     C                   ENDIF
      *
     C     PMLT          CAT       'CIMSGF'      @MSGF
      *
     C                   Z-ADD     0             DBASE
      *
      **  Define DTAARA CISTAT.
      *
     C     *DTAARA       DEFINE                  CISTAT
      *
     C     'CASH'        CAT       JOBNUM        WJOBID           10
      *
      **  Set Session Active Flag.
      *
     C                   MOVEL     'Y'           WACTIV
      *
      **  Define Parmlist(s).
      **  Parameters for QRCVDTAQ (From RBA).
      *
     C     DTQRCV        PLIST
     C                   PARM                    DTAQR
     C                   PARM                    LIBR
     C                   PARM                    LENR
     C                   PARM                    MSGR
     C                   PARM                    WAITR
      *
      **  Parameters for QRCVDTAQ (Auto Reversal From RBA).                                   197289
     C     *LIKE         DEFINE    DTAQR         DTAQA                                        197289
     C     *LIKE         DEFINE    LIBR          LIBA                                         197289
     C     *LIKE         DEFINE    LENR          LENA                                         197289
     C     *LIKE         DEFINE    MSGR          MSGA                                         197289
     C     *LIKE         DEFINE    WAITR         WAITA                                        197289
     C     *LIKE         DEFINE    DTAQR         DTAQO                                        197289
     C     *LIKE         DEFINE    LIBR          LIBO                                         197289
     C     *LIKE         DEFINE    LENR          LENO                                         197289
     C     *LIKE         DEFINE    WAITR         WAITO                                        197289
     C     *LIKE         DEFINE    WTRID         W#TRID                                       197289
     C     *LIKE         DEFINE    W#BRCA        W#BRCH                                       CRT005
     C     *LIKE         DEFINE    W#TELD        W#TELR                                       CRT005
     C     *LIKE         DEFINE    DTAQR         DTAQI                                        CRT005
     C     *LIKE         DEFINE    LIBR          LIBI                                         CRT005
     C     *LIKE         DEFINE    LENR          LENI                                         CRT005
     C     *LIKE         DEFINE    MSGR          MSGI                                         CRT005
     C     *LIKE         DEFINE    WAITR         WAITI                                        CRT005
     C     *LIKE         DEFINE    DTAQR         DTAQC                                        CRT005
     C     *LIKE         DEFINE    LIBR          LIBC                                         CRT005
     C     *LIKE         DEFINE    LENR          LENC                                         CRT005
     C     *LIKE         DEFINE    WAITR         WAITC                                        CRT005
      *                                                                                       197289
     C     DTQRCA        PLIST                                                                197289
     C                   PARM                    DTAQA                                        197289
     C                   PARM                    LIBA                                         197289
     C                   PARM                    LENA                                         197289
     C                   PARM                    MSGA                                         197289
     C                   PARM                    WAITA                                        197289
      *                                                                                       CRT005
     C     DTQRCI        PLIST                                                                CRT005
     C                   PARM                    DTAQI                                        CRT005
     C                   PARM                    LIBI                                         CRT005
     C                   PARM                    LENI                                         CRT005
     C                   PARM                    MSGI                                         CRT005
     C                   PARM                    WAITI                                        CRT005
      *                                                                                       CRT005
      *                                                                                       197289
      **  Parameters for QSNDDTAQ (To RBA).
      *
     C     DTQSND        PLIST
     C                   PARM                    DTAQS
     C                   PARM                    LIBS
     C                   PARM                    LENS
     C                   PARM                    MSGS
      *                                                                                       CRT005
      **  Parameters for QSNDDTAQ for CSIV, CSOV, TLIN, and TLOU messages                     CRT005
      *                                                                                       CRT005
     C     DTQSNC        PLIST                                                                CRT005
     C                   PARM                    DTAQC                                        CRT005
     C                   PARM                    LIBC                                         CRT005
     C                   PARM                    LENC                                         CRT005
     C                   PARM                    MSGC                                         CRT005
      *
      **  Parameters for QSNDDTAQ for Auto Reversal.                                          197289
      *                                                                                       197289
     C     DTQSNO        PLIST                                                                197289
     C                   PARM                    DTAQO                                        197289
     C                   PARM                    LIBO                                         197289
     C                   PARM                    LENO                                         197289
     C                   PARM                    MSGO                                         197289
      *                                                                                       197289
      **  Set up parameters for receive data queue (from RBA).
      *
     C                   MOVEL     WJOBID        DTAQR            10
     C                   MOVEL     '*LIBL'       LIBR             10
     C***********          Z-ADD2273      LENR    50
     C***********          Z-ADD1714      LENR    50                      122060
     C                   Z-ADD     2560          LENR              5 0                         12206
     C                   Z-ADD     -1            WAITR             5 0                         SPLFI
      *
      **  Set up parameters for send data queue (to RBA).
      *
     C                   MOVEL     *BLANKS       DTAQS            10
     C                   MOVEL     '*LIBL'       LIBS             10
     C                   MOVEL     *BLANKS       LENS              5 0
      *
      **  Initialise detail records received from data queue counter to 0.
      *
     C                   Z-ADD     0             WCNT              5 0
     C                   MOVEL     'N'           OPEN
      *
      **  RCF Processing for Audit File.
      *
     C                   EXSR      RCFAU
      *
      **  Access Bank Details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  If error on access to Bank Details.
      *
     C     @RTCD         IFNE      *BLANKS
      *
      **  Report error.
      *
     C                   MOVEL     'USR0051'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
     C                   MOVE      'BANK'        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG             10
     C                   PARM                    JOBNUM            6
     C                   PARM      '0000'        MMCODE            4
     C                   PARM      *BLANKS       P#BRCA            3
     C                   PARM                    @MSGID            7
     C                   PARM      *BLANKS       @MSGDT
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CR'          WMSTAT
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      *
      **  Set up LDA DBERR.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   EXSR      DBERR
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV            1
      *
     C                   EXSR      *PSSR
      *
      **  Access to Bank Details OK.
      *
     C                   ELSE
      *
      **  Convert Date to 'YYYYMMDD' Format.
      *
     C                   Z-ADD     BJRDNB        @@DAYN            5 0
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN            5 0
     C                   PARM                    @@VDT             8 0
     C                   PARM                    @@RTN             1
     C                   END
      *                                                                                       CRT005
      ** Check if CRT005 is On                                                                CRT005
      *                                                                                       CRT005
     C                   CALL      'AOSARDR0'                                                 CRT005
     C                   PARM      *BLANKS       @RTCD                                        CRT005
     C                   PARM      '*VERIFY'     @OPTN                                        CRT005
     C                   PARM      'CRT005'      @SARD             6                          CRT005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRT005
      *                                                                                       CRT005
      ** Process Database Error                                                               CRT005
      *                                                                                       CRT005
     C     @RTCD         IFNE      *BLANKS                                                    CRT005
     C     @RTCD         ANDNE     '*NRF   '                                                  CRT005
      *                                                                                       CRT005
      ** Report Error                                                                         CRT005
      *                                                                                       CRT005
     C                   MOVEL     'USR0092'     @MSGID                                       CRT005
     C                   MOVEL     *BLANKS       WMDTA1                                       CRT005
     C                   MOVEL     *BLANKS       WMDTA2                                       CRT005
     C                   EXSR      RTVMSG                                                     CRT005
     C                   MOVEL     @MSGTX        O#HMSG                                       CRT005
     C                   MOVE      'E'           O#HMSS                                       CRT005
     C                   MOVE      @MSGID        O#HMSI                                       CRT005
     C                   MOVE      'SARD'        O#MSTY                                       CRT005
     C                   MOVEL     W#BRCA        O#BRCA                                       CRT005
     C                   MOVEL     W#TELD        O#TELD                                       CRT005
      *                                                                                       CRT005
     C                   CALL      'REC4411'                                                  CRT005
     C                   PARM      'RE004503'    PROG             10                          CRT005
     C                   PARM                    JOBNUM            6                          CRT005
     C                   PARM      '0000'        MMCODE            4                          CRT005
     C                   PARM      *BLANKS       P#BRCA            3                          CRT005
     C                   PARM                    @MSGID            7                          CRT005
     C                   PARM      *BLANKS       @MSGDT                                       CRT005
      *                                                                                       CRT005
     C                   MOVE      'N'           WCSTAT                                       CRT005
     C                   MOVE      'CR'          WMSTAT                                       CRT005
     C                   EXSR      WRTLOG                                                     CRT005
      *                                                                                       CRT005
      ** Send ERR message                                                                     CRT005
      *                                                                                       CRT005
     C                   MOVEL     '00000111'    header                                       CRT005
     C                   MOVE      'SND'         header                                       CRT005
     C                   CLEAR                   Sbuffer                                      CRT005
     C     Header        CAT       OSTATD        Sbuffer                                      CRT005
      *                                                                                       CRT005
      ** Send ERR message                                                                     CRT005
      *                                                                                       CRT005
     C                   EVAL      RetCode = Snd_Tcp( ScktNum: Sbuffer )                      CRT005
     C                   IF        RetCode = -1                                               CRT005
     C                   EXSR      tcperr                                                     CRT005
     C                   ENDIF                                                                CRT005
      *                                                                                       CRT005
      ** Set up LDA DBERR                                                                     CRT005
      *                                                                                       CRT005
     C     *LOCK         IN        LDA                                                        CRT005
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CRT005
     C                   MOVEL     @OPTN         DBKEY                                        CRT005
     C                   Z-ADD     22            DBASE                                        CRT005
     C                   EXSR      DBERR                                                      CRT005
      *                                                                                       CRT005
      ** Set Off Session Active Flag                                                          CRT005
      *                                                                                       CRT005
     C                   MOVEL     'N'           WACTIV            1                          CRT005
      *                                                                                       CRT005
     C                   EXSR      *PSSR                                                      CRT005
      *                                                                                       CRT005
     C                   ENDIF                                                                CRT005
      *                                                                                       CRT005
      ** Update Switch Flag                                                                   CRT005
      *                                                                                       CRT005
     C     @RTCD         IFNE      *BLANKS                                                    CRT005
     C                   MOVEL     'N'           CRT005            1                          CRT005
     C                   ELSE                                                                 CRT005
     C                   MOVEL     'Y'           CRT005                                       CRT005
     C                   ENDIF                                                                CRT005
      *
      **  Access Cashier Interface ICD Details.
      *
     C**********         CALL      'AOBAIIR0'                                                 CRT005
     C                   CALL      'AOBAIIR1'                                                 CRT005
     C                   PARM      '*BLANK '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDBAII        PARM      SDBAII        DSFDY                                        CRT005
     C     SDBAII        PARM      SDBAII        DSSDY                                        CRT005
      *
      **  If error on access to Cashier Interface ICD Details.
      *
     C     @RTCD         IFNE      *BLANK
      *
      **  Report error.
      *
     C                   MOVEL     'USR0052'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
     C                   MOVE      'BAII'        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      *BLANKS       P#BRCA
     C                   PARM                    @MSGID
     C                   PARM      *BLANKS       @MSGDT
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CR'          WMSTAT
     C                   EXSR      WRTLOG
      *
      ** Send ERR message
      *
     C                   movel     '00000111'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSTATD        Sbuffer
      * Send ERR message
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      **  Set up LDA DBERR.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBAIIPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      DBERR
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV            1
      *
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      **  Initiation of indices.
      *
     C                   Z-ADD     999           A                 3 0
     C                   Z-ADD     999           B                 3 0
     C                   Z-ADD     999           C                 3 0
      *
      **  Access Teller Id details.
      *
     C                   CALL      'AOTELDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM      *BLANKS       @TLR              3
     C     SDTELD        PARM      SDTELD        DSFDY
      *
      **  Load Valid Teller Arrays.
      *
     C     @RTCD         DOWEQ     *BLANKS
     C                   MOVEL     FRTLID        TLR(A)
     C                   MOVEL     FRTLBC        TBR(A)
      *
      **  Check Teller Status.
      *
     C                   MOVEL     FRTLID        KTBID
     C                   MOVEL     '1'           KRCTP                                        197289
     C***********KTTRNT    CHAINTTRNM2L1             30                   120880
     C     KTTRNT        CHAIN(N)  TTRNM2L1                           30                       12088
      *
     C     *IN30         IFEQ      *ON
     C     RECI          ORNE      'D'
      *
      **  Report error.
      *
     C                   MOVEL     'USR0055'     @MSGID
     C                   MOVEL     FRTLID        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      *BLANKS       P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVE      'N'           WCSTAT
     C                   MOVE      'CR'          WMSTAT
     C                   EXSR      WRTLOG
      *
      **  Set up LDA DBERR.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C                   MOVEL     @TTRNT        DBKEY
     C                   Z-ADD     3             DBASE
     C                   EXSR      DBERR
      *
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C     TWID          IFEQ      *BLANKS
     C                   MOVE      'OFF'         TST(A)
     C                   ELSE
     C                   MOVE      ' ON'         TST(A)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   SUB       1             A
      *
     C                   CALL      'AOTELDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*NEXT  '     @OPTN
     C                   PARM      *BLANKS       @TLR
     C     SDTELD        PARM      SDTELD        DSFDY
      *
     C                   ENDDO
      *
     C                   ADD       1             A
      *
      **  Save Lowest Index to use as a Position pointer to start 'LOKUP'.
      *
     C                   Z-ADD     A             WAPOS             3 0
      *
      **  Access transaction types details.
      *
     C                   CALL      'AOBAITR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM      *BLANKS       @BAIT            10
     C                   PARM      '*TTYP  '     @KYST             7
     C     SDBAIT        PARM      SDBAIT        DSFDY
      *
      **  Do while no errors found.
      *
     C     @RTCD         DOWEQ     *BLANKS
      *
      **  Load Transaction Type Details.
      *
     C                   MOVEL     FXBAIT        TXP(B)
     C                   MOVEL     FXTTFC        W#TTFC
     C                   MOVEL     FXDQNM        W#DQNM
     C                   MOVEL     FXDQLN        W#DQLN
     C                   MOVEL     FXRVFN        W#RVFN
     C                   MOVEL     FXRVDQ        W#RVDQ
     C                   MOVEL     FXRVDL        W#RVDL
     C                   MOVEL     DTLDS         DTL(B)
     C                   SUB       1             B
      *
     C                   CALL      'AOBAITR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*NEXT  '     @OPTN
     C                   PARM      *BLANKS       @BAIT
     C                   PARM      '*TTYP  '     @KYST
     C     SDBAIT        PARM      SDBAIT        DSFDY
      *
     C                   ENDDO
      *
     C                   ADD       1             B
      *
      **  Save Lowest Index to use as a Position pointer to start 'LOKUP'.
      *
     C                   Z-ADD     B             WBPOS             3 0
      *
      ****Check*Authorised*Devices*If*Product*In*Cashier*ICD*not*'CASHIER 8'.*                164273
      **  Check Authorised Devices If Product In Cashier ICD not 'CASHIER  '.                 164273
      *
     C     FUPROD        IFNE      W#ICDP
      *
      **  Access authorised devices.
      *
     C                   CALL      'AOBAIDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM      *BLANKS       P@BRCA            3                          222373
     C                   PARM      *BLANKS       @BAID            10
     C     SDBAID        PARM      SDBAID        DSFDY
      *
      **  If record not found.
      *
     C     @RTCD         DOWEQ     *BLANKS
     C                   MOVE      FWBAID        CDV(C)
     C                   SUB       1             C
      *
     C                   CALL      'AOBAIDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*NEXT  '     @OPTN
     C                   PARM      *BLANKS       P@BRCA                                       222373
     C                   PARM      *BLANKS       @BAID
     C     SDBAID        PARM      SDBAID        DSFDY
      *
     C                   ENDDO
      *
     C                   ADD       1             C
      *
      **  Save Lowest Index to use as a Position pointer to start 'LOKUP'.
      *
     C                   Z-ADD     C             WCPOS             3 0
      *
     C                   ENDIF
      *
      **  Set ICF File Read required Flag.
      *
     C                   MOVEL     'Y'           WRDICF            1
      *
      * Send FOK message (Reply to FOK received in listener)
     C                   movel     '00000000'    header
     C                   move      'FOK'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDSR
      *
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            UPDLOG - Update Communications Log.                *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  RCVDTQ - Receive Dataqueue Processing.             *
      *            ROLLBK - Rollback Processing.                      *
      *                                                               *
      *****************************************************************
     C     UPDLOG        BEGSR
      *
     C     RICMSQ        CHAIN     REPLOGL0                           35
      *
     C     *IN35         IFEQ      '0'
      *
     C                   TIME                    WTMDAT           12 0
     C                   MOVE      WTMDAT        TDATE
     C                   MOVEL     WTMDAT        TTIME
      *
     C                   MOVE      WTHR          WFHR
     C                   MOVE      WTMN          WFMN
     C                   MOVE      WTSS          WFSS
     C                   MOVE      WTDD          WFDD
     C                   MOVE      WTMM          WFMM
     C                   MOVE      WTYY          WFYY
      *
     C     FUPROD        IFNE      W#ICDP
     C                   MOVE      *BLANKS       RIRMDN
     C                   END
      *
      **  Update the Successful Completion flag
      *
     C                   MOVEL     WCSTAT        RISUCM
      *
      **  Update the Status & Status Time Stamp
      *
     C                   MOVEL     WMSTAT        RISTAT
     C                   MOVE      FTIME         RISTTM
      *
      **  Update the Comms Log File.
      *
     C                   UPDATE    REPLOGD0
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            AUDIT  - Audit Report Log.                         *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  MAIN   - Main Control Processing.                  *
      *                                                               *
      *****************************************************************
     C     AUDIT         BEGSR
      *
     C                   WRITE     HEADAU
      *
     C     WCNT          IFGT      0
     C                   WRITE     CONTROL
      *
     C                   ELSE
      *
      **  Or, if no records read, Output "No Details" message.
      *
     C     WCNT          IFEQ      0
     C     *INU7         ANDEQ     *OFF
     C                   WRITE     NODTLS
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            RCFP1  - RCF Processing for Detail Processing.     *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  RCVDTQ - Receive Data Queue Processing.            *
      *                                                               *
      *****************************************************************
     C     RCFP1         BEGSR                                                   *** RCFP1  ***
      *
      ***  Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            RCFAU  - RCF Processing for Audit Report.          *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  INIT   - Initial Processing.                       *
      *                                                               *
      *****************************************************************
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
      *
      ***  Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       SENTY             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANKS       ZSERR             1
      *
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      *            TCPERR - Report Communication error                *
      *                                                               *
      * CALLS     REC4411 - Midas RE CI Comms Program Error Report    *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     TCPERR        BEGSR
      *
     C                   MOVEL     'USR0090'     @MSGID
     C                   MOVEL     *BLANKS       @MSGDT                                       194002
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
      *
     C                   CALL      'REC4411'
     C**********         PARM      'RE4502'      PROG             10                          194002
     C                   PARM      'RE004503'    PROG             10                          194002
     C                   PARM                    JOBNUM            6
     C                   PARM      '0000'        MMCODE            4
     C                   PARM      PBRCA         P#BRCA            3
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGDT
      ** Socket closed by *PSSR                                                               194002
      **Close*Socket*****                                                                     194002
     C*******************Eval      RetCode = Cls_Tcp( ScktNum )                               194002
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TCP COMM'    DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   Z-ADD     99            DBASE
      *
     C                   EXSR      DBERR
     C                   EXSR      *PSSR
     C                   ENDSR
      *****************************************************************                       CRT008
      /EJECT                                                                                  CRT008
     C*****************************************************************                       CRT008
      *                                                               *                       CRT008
      *             SETPRT - Set up fields for report print           *                       CRT008
      *                                                               *                       CRT008
      * CALLED BY - RCVDTQ - Receive Dataqueue Processing.            *                       CRT008
      *           - ARVRPT - Report Auto Reversal Information         *                       CRT008
      *                                                               *                       CRT008
      *                                                               *                       CRT008
      *****************************************************************                       CRT008
      *                                                                                       CRT008
     C     SETPRT        BEGSR                                                                CRT008
      *                                                                                       CRT008
      ** Get function code for this particular transaction                                    CRT008
      *                                                                                       CRT008
     C                   MOVE      RIDTQN        W#FNCD            4                          CRT008
     C                   MOVEL     W#FNCD        FNCD                                         CRT008
      *                                                                                       CRT008
      ** Processing to initially setup fields for travellers cheques                          CRT008
      ** '00X', '00W','0JW', '0JX', '00S', '0JS', '00R', '0JR' function codes                 CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '00X'                                            B01       CRT008
     C     FNCD          OREQ      '00S'                                                      CRT008
     C                   MOVE      I#CUR1        FRCCYA                                       CRT008
     C                   MOVEL     I#VDAT        FRVLDT                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '00W'                                            B01       CRT008
     C     FNCD          OREQ      '00R'                                                      CRT008
     C                   MOVE      *BLANKS       FRCCYT                                       CRT008
     C                   MOVE      FRACN2        FRACNO                                       CRT008
     C                   MOVE      *BLANKS       FREXRT                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JW'                                            B01       CRT008
     C     FNCD          OREQ      '0JR'                                                      CRT008
     C                   MOVE      FRCCYA        CCYSWAPA          3                          CRT008
     C                   MOVE      FRCCYT        CCYSWAPT          3                          CRT008
     C                   MOVE      CCYSWAPA      FRCCYT                                       CRT008
     C                   MOVE      CCYSWAPT      FRCCYA                                       CRT008
     C                   MOVE      FRACN2        FRACNO                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JW'                                            B01       CRT008
     C     FNCD          OREQ      '0JR'                                                      CRT008
     C     FNCD          OREQ      '0JX'                                                      CRT008
     C     FNCD          OREQ      '0JS'                                                      CRT008
     C     M#HMSS        IFEQ      'E'                                              B02       CRT008
     C                   MOVE      *BLANKS       FREXRT                                       CRT008
     C                   ELSE                                                       X02       CRT008
     C                   MOVE      EXCR          ZFIELD                                       CRT008
     C                   Z-ADD     8             ZDEC                                         CRT008
      *                                                                                       CRT008
     C                   CALLB     'ZEDIT'                                                    CRT008
     C                   PARM                    ZFIELD           16                          CRT008
     C                   PARM                    ZDEC              1 0                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       FREXRT                                       CRT008
     C                   MOVE      ZFIELD        FREXRT                                       CRT008
     C                   ENDIF                                                      E02       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Processing to show reversal fields for travellers cheques                            CRT008
      ** '00X', '00W','0JW', '0JX', '00S', '0JS', '00R', '0JR' function codes                 CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JD'                                            B01       CRT008
      *                                                                                       CRT008
     C     PRTARV        IFNE      'Y'                                              B02       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '00S'                                            B03       CRT008
     C     W#TTFC        OREQ      '00X'                                                      CRT008
     C                   MOVE      *BLANKS       FRCCYT                                       CRT008
     C                   MOVE      *BLANKS       FRAMTT                                       CRT008
     C                   MOVE      *BLANKS       FREXRT                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JX'                                            B03       CRT008
     C                   MOVE      I#CUR2        FRCCYA                                       CRT008
     C                   MOVE      I#CUR1        FRCCYT                                       CRT008
     C                   MOVE      FRAMTA        TRAMT1                                       CRT008
     C                   MOVE      FRAMTT        CVAMT1                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JS'                                            B03       CRT008
     C                   MOVE      I#CUR2        FRCCYA                                       CRT008
     C                   MOVE      I#CUR1        FRCCYT                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '00R'                                            B03       CRT008
     C     W#TTFC        OREQ      '00W'                                                      CRT008
     C                   MOVE      *BLANKS       FRCCYT                                       CRT008
     C                   MOVE      FRACN2        FRACNO                                       CRT008
     C                   MOVE      *BLANKS       FREXRT                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JR'                                            B03       CRT008
     C     W#TTFC        OREQ      '0JW'                                                      CRT008
     C                   MOVE      FRCCYA        CCYSWAPA                                     CRT008
     C                   MOVE      FRCCYT        CCYSWAPT                                     CRT008
     C                   MOVE      CCYSWAPA      FRCCYT                                       CRT008
     C                   MOVE      CCYSWAPT      FRCCYA                                       CRT008
     C                   MOVE      FRACN2        FRACNO                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C                   ELSE                                                       X02       CRT008
      *                                                                                       CRT008
      ** Midas Auto Reversals of travellers cheques                                           CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JW'                                            B03       CRT008
     C     W#TTFC        OREQ      '0JR'                                                      CRT008
     C     W#TTFC        OREQ      '0JS'                                                      CRT008
      *                                                                                       CRT008
     C                   MOVE      AMT1          TRAMT1                                       CRT008
     C                   MOVE      CCY1          FRCCYT                                       CRT008
      *                                                                                       CRT008
     C                   SELECT                                                               CRT008
      *                                                                                       CRT008
     C     W#TTFC        WHENEQ    '0JR'                                                      CRT008
     C                   MOVE      AMT1          CVAMT1                                       CRT008
     C                   MOVE      WOCCY2        FRCCYA                                       CRT008
      *                                                                                       CRT008
     C     W#TTFC        WHENEQ    '0JW'                                                      CRT008
     C                   MOVE      WOCCY2        FRCCYA                                       CRT008
      *                                                                                       CRT008
     C     W#TTFC        WHENEQ    '0JS'                                                      CRT008
     C                   MOVE      CCY2          FRCCYA                                       CRT008
      *                                                                                       CRT008
     C                   ENDSL                                                                CRT008
      *                                                                                       CRT008
     C                   ELSE                                                       X03       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '00W'                                            B04       CRT008
     C     W#TTFC        OREQ      '00S'                                                      CRT008
     C     W#TTFC        OREQ      '00R'                                                      CRT008
     C                   MOVE      AMT1          TRAMT1                                       CRT008
      *                                                                                       CRT008
     C                   ELSE                                                       X04       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JX'                                            B05       CRT008
     C                   MOVE      AMT2          TRAMT1                                       CRT008
     C                   MOVE      AMT1          CVAMT1                                       CRT008
     C                   MOVE      CCY2          FRCCYT                                       CRT008
     C                   ENDIF                                                      E05       CRT008
     C                   ENDIF                                                      E04       CRT008
      *                                                                                       CRT008
     C                   MOVE      CCY1          FRCCYA                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Setup unformatted amounts from TTRANPD                                               CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JD'                                            B01       CRT008
     C     W#TTFC        ANDEQ     '0JX'                                                      CRT008
     C     PRTARV        ANDEQ     'Y'                                                        CRT008
     C                   ELSE                                                                 CRT008
      *                                                                                       CRT008
     C     M#HMSS        IFNE      'E'                                              B02       CRT008
     C                   MOVE      AMT1          TRAMT1           16                          CRT008
     C                   MOVE      CVAM          CVAMT1           16                          CRT008
     C                   ELSE                                                       X02       CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JE'                                                      CRT008
     C     FNCD          OREQ      '0JF'                                                      CRT008
     C     FNCD          OREQ      '00E'                                                      CRT008
     C     FNCD          OREQ      '00F'                                                      CRT008
     C                   MOVE      FRTICCY       FRCCYA                                       CRT008
     C                   MOVE      FRTIAMT       TRAMT1                                       CRT008
     C                   ELSE                                                                 CRT008
     C                   MOVE      FRAMTA        TRAMT1                                       CRT008
     C                   MOVE      FRAMTT        CVAMT1                                       CRT008
     C                   ENDIF                                                                CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Cash transaction processing                                                          CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JI'                                            B01       CRT008
     C     FNCD          OREQ      '0JX'                                                      CRT008
     C     FNCD          OREQ      '0JS'                                                      CRT008
     C                   MOVE      I#CUR2        FRCCYA                                       CRT008
     C                   MOVE      I#CUR1        FRCCYT                                       CRT008
     C                   MOVE      FRAMTA        TRAMT1                                       CRT008
     C                   MOVE      FRAMTT        CVAMT1                                       CRT008
     C                   MOVEL     I#VDAT        FRVLDT                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Get Function Code Details                                                            CRT008
      *                                                                                       CRT008
     C                   CALL      'AOFNCDR0'                                                 CRT008
     C                   PARM      '*BLANK '     @RTCD             7                          CRT008
     C                   PARM      '*KEY   '     @OPTN             7                          CRT008
     C                   PARM      FNCD          @FNCD             3                          CRT008
     C     SDFNCD        PARM      SDFNCD        DSFDY                                        CRT008
     C                   CALL      'AOCURRR0'                                                 CRT008
     C                   PARM      '*BLANK '     @RTCD             7                          CRT008
     C                   PARM      '*KEY   '     @OPTN             7                          CRT008
     C                   PARM                    FRCCYA                                       CRT008
     C     SDCURR        PARM      SDCURR        DSSDY                                        CRT008
      *                                                                                       CRT008
      ** Format converted amount if it's multi ccy transaction                                CRT008
      ** or a retail account transfer                                                         CRT008
      *                                                                                       CRT008
     C     FRCCYT        IFNE      *BLANKS                                          B01       CRT008
     C                   MOVE      *BLANKS       ZFIELD                                       CRT008
      *                                                                                       CRT008
      ** Use correct amount for account transfers                                             CRT008
      *                                                                                       CRT008
     C     FNCD          IFNE      '00A'                                            B02       CRT008
     C                   MOVE      CVAMT1        ZFIELD                                       CRT008
     C                   ELSE                                                       X02       CRT008
     C                   MOVE      TRAMT1        ZFIELD                                       CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   Z-ADD     A6NBDP        ZDEC                                         CRT008
      *                                                                                       CRT008
     C                   CALLB     'ZEDIT'                                                    CRT008
     C                   PARM                    ZFIELD           16                          CRT008
     C                   PARM                    ZDEC              1 0                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       W#CVAM           16                          CRT008
     C                   MOVE      ZFIELD        W#CVAM                                       CRT008
      *                                                                                       CRT008
      ** Format transaction amount                                                            CRT008
      *                                                                                       CRT008
     C                   CALL      'AOCURRR0'                                                 CRT008
     C                   PARM      '*BLANK '     @RTCD             7                          CRT008
     C                   PARM      '*KEY   '     @OPTN             7                          CRT008
     C                   PARM                    FRCCYT                                       CRT008
     C     SDCURR        PARM      SDCURR        DSSDY                                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       ZFIELD                                       CRT008
     C                   MOVE      TRAMT1        ZFIELD                                       CRT008
     C                   Z-ADD     A6NBDP        ZDEC                                         CRT008
      *                                                                                       CRT008
     C                   CALLB     'ZEDIT'                                                    CRT008
     C                   PARM                    ZFIELD           16                          CRT008
     C                   PARM                    ZDEC              1 0                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       W#TRAM           16                          CRT008
     C                   MOVE      ZFIELD        W#TRAM                                       CRT008
      *                                                                                       CRT008
     C                   ELSE                                                       X01       CRT008
      *                                                                                       CRT008
      ** If the transaction is not a multi-ccy transaction                                    CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       ZFIELD                                       CRT008
     C                   MOVE      TRAMT1        ZFIELD                                       CRT008
     C                   Z-ADD     A6NBDP        ZDEC                                         CRT008
      *                                                                                       CRT008
     C                   CALLB     'ZEDIT'                                                    CRT008
     C                   PARM                    ZFIELD           16                          CRT008
     C                   PARM                    ZDEC              1 0                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       W#TRAM           16                          CRT008
     C                   MOVE      ZFIELD        W#TRAM                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Reset printer fields                                                                 CRT008
      *                                                                                       CRT008
     C                   MOVEL     *BLANKS       PBRCA                                        CRT008
     C                   MOVEL     *BLANKS       PTELD                                        CRT008
     C                   MOVEL     *BLANKS       PTRNO                                        CRT008
     C                   MOVEL     *BLANKS       PDESC                                        CRT008
     C                   MOVEL     *BLANKS       PDSC2                                        CRT008
     C                   MOVEL     *BLANKS       PACNO                                        CRT008
     C                   MOVEL     *BLANKS       PACN2                                        CRT008
     C                   MOVEL     *BLANKS       PCCYA                                        CRT008
     C                   MOVEL     *BLANKS       PCCYT                                        CRT008
     C                   MOVEL     *BLANKS       PAMTT                                        CRT008
     C                   MOVEL     *BLANKS       PAMTA                                        CRT008
     C                   MOVEL     *BLANKS       PCHAM                                        CRT008
     C                   MOVEL     *BLANKS       PCHA2                                        CRT008
     C                   MOVEL     *BLANKS       PVLDT                                        CRT008
     C                   MOVEL     *BLANKS       PCRTN                                        CRT008
     C                   MOVEL     *BLANKS       PHSMS                                        CRT008
     C                   MOVEL     *BLANKS       PPRFC                                        CRT008
     C                   MOVEL     *BLANKS       PEXRT                                        CRT008
     C                   MOVE      *OFF          *IN39                                        CRT008
      *                                                                                       CRT008
      ** Set up basic print fields for all transactions                                       CRT008
      *                                                                                       CRT008
     C                   MOVEL     W#BRCA        PBRCA                                        CRT008
     C                   MOVEL     W#TELD        PTELD                                        CRT008
     C                   MOVEL     FRTRNO        PTRNO                                        CRT008
     C                   MOVEL     FQRNNR        PDESC                                        CRT008
     C                   MOVEL     FRVLDT        PVLDT                                        CRT008
     C                   MOVE      FRCRTN        PCRTN                                        CRT008
     C                   MOVEL     PRFC          PPRFC                                        CRT008
     C                   MOVEL     FRMSGD        PHSMS                                        CRT008
      *                                                                                       CRT008
      ** Now need to set up and format where necessary the fields                             CRT008
      ** for each specific transaction                                                        CRT008
      *                                                                                       CRT008
     C     FRCCYT        IFNE      *BLANKS                                          B01       CRT008
     C                   MOVEL     FRCCYT        PCCYT                                        CRT008
     C                   MOVEL     FRCCYA        PCCYA                                        CRT008
     C     PRTARV        IFNE      'Y'                                              B02       CRT008
     C                   MOVEL     FRACNO        PACN2                                        CRT008
     C                   ENDIF                                                      E02       CRT008
     C                   MOVEL     FRCHAM        PCHA2                                        CRT008
     C                   MOVEL     W#CVAM        PAMTA                                        CRT008
     C                   MOVEL     W#TRAM        PAMTT                                        CRT008
      *                                                                                       CRT008
      ** Do not move exchange rate field if house cheque deposit                              CRT008
      ** as it is not blanks, but contains number of items                                    CRT008
      *                                                                                       CRT008
     C     FNCD          IFNE      '00Q'                                            B02       CRT008
     C                   MOVE      FREXRT        PEXRT                                        CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   ELSE                                                       X01       CRT008
      *                                                                                       CRT008
     C                   MOVEL     FRACNO        PACNO                                        CRT008
     C                   MOVEL     FRCCYA        PCCYT                                        CRT008
     C                   MOVEL     W#TRAM        PAMTT                                        CRT008
     C                   MOVEL     FRCHAM        PCHAM                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Ensure Charge Amount is on the same line as the related ccy                          CRT008
      ** By finding out what ccy the charge is in                                             CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       CHGCCY            3                          CRT008
     C                   Eval      CHGCCY = %Triml(FRCHAM)                                    CRT008
      *                                                                                       CRT008
     C     CHGCCY        IFEQ      PCCYT                                            B01       CRT008
     C                   MOVE      FRCHAM        PCHAM                                        CRT008
     C                   MOVE      *BLANKS       PCHA2                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** If Transaction is an exchange cash transaction                                       CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JI'                                            B01       CRT008
     C     BJLCCY        ANDEQ     CCY2                                                       CRT008
     C                   MOVE      *BLANKS       PCHAM                                        CRT008
     C                   MOVE      FRCHAM        PCHA2                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** If transaction is an account transfer then                                           CRT008
      ** add DR/CR sign to the report                                                         CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '00A'                                            B01       CRT008
     C                   MOVE      FRACNO        PACNO                                        CRT008
     C                   MOVE      FRACN2        PACN2                                        CRT008
     C                   MOVE      'DR'          PDESC                                        CRT008
     C                   MOVE      'CR'          PDSC2                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** If transaction is a reversal of a transfer then                                      CRT008
      ** add the DR/CR sign to the report.                                                    CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JD'                                            B01       CRT008
     C     W#TTFC        ANDEQ     '00A'                                                      CRT008
     C     PRTARV        ANDNE     'Y'                                                        CRT008
     C                   MOVE      FRACNO        PACNO                                        CRT008
     C                   MOVE      FRACN2        PACN2                                        CRT008
     C                   MOVE      'CR'          PDESC                                        CRT008
     C                   MOVE      'DR'          PDSC2                                        CRT008
     C                   MOVEL     W#TRAM        PAMTA                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** If transaction is an auto reversal                                                   CRT008
      *                                                                                       CRT008
     C     PRTARV        IFEQ      'Y'                                              B01       CRT008
      *                                                                                       CRT008
      ** Clear out fields not used for Midas Auto Reversal                                    CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFNE      '00A'                                            B02       CRT008
     C     W#TTFC        ANDNE     '0JX'                                                      CRT008
     C     W#TTFC        ANDNE     '0JW'                                                      CRT008
     C     W#TTFC        ANDNE     '0JS'                                                      CRT008
     C     W#TTFC        ANDNE     '0JR'                                                      CRT008
     C                   MOVE      *BLANKS       PCHAM                                        CRT008
     C                   MOVE      *BLANKS       PAMTA                                        CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   MOVE      I#VDAT        PVLDT                                        CRT008
     C                   MOVE      '(Auto)  '    PDESC                                        CRT008
     C                   MOVE      W#TRNO        PTRNO                                        CRT008
     C                   MOVE      WOTBTN        PCRTN                                        CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFNE      '0JX'                                            B02       CRT008
     C     W#TTFC        ANDNE     '0JW'                                                      CRT008
     C     W#TTFC        ANDNE     '0JS'                                                      CRT008
     C                   MOVE      CCY1          PCCYT                                        CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C     M#HMSS        IFNE      'E'                                              B02       CRT008
     C                   MOVE      '1'           *IN37                                        CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JW'                                            B02       CRT008
     C     W#TTFC        OREQ      '0JR'                                                      CRT008
     C                   MOVE      ACNO          PACN2                                        CRT008
     C                   MOVE      *BLANKS       PACNO                                        CRT008
     C                   ELSE                                                       X02       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '00A'                                            B03       CRT008
     C                   MOVEL     ROMAC1        PACNO                                        CRT008
     C                   MOVE      TTAC          PACN2                                        CRT008
     C                   ELSE                                                       X03       CRT008
      *                                                                                       CRT008
     C                   MOVE      ACNO          PACNO                                        CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   ELSE                                                       X01       CRT008
      *                                                                                       CRT008
      ** If transaction is a reversal that has not failed                                     CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JD'                                            B02       CRT008
     C     M#HMSS        ANDNE     'E'                                                        CRT008
     C                   MOVE      CRTN          PCRTN                                        CRT008
     C                   ENDIF                                                      E02       CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** If an 'E' message, then inform user that the                                         CRT008
      ** transaction has not been written                                                     CRT008
      *                                                                                       CRT008
     C                   MOVE      *OFF          *IN39                                        CRT008
     C     M#HMSS        IFEQ      'E'                                              B01       CRT008
     C                   MOVE      *ON           *IN39                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** If transaction is to be posted to suspense then set                                  CRT008
      ** suspense indicator                                                                   CRT008
      ** And not a cash ccy based travellers cheques transaction                              CRT008
      *                                                                                       CRT008
     C                   MOVE      *OFF          *IN38                                        CRT008
     C     FWSUSP        IFEQ      'Y'                                              B01       CRT008
     C     FNCD          ANDNE     '00X'                                                      CRT008
     C     FNCD          ANDNE     '00S'                                                      CRT008
     C                   MOVE      *ON           *IN38                                        CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Auto Reversal of travellers cheques for cash that has failed                         CRT008
      *                                                                                       CRT008
     C     PRTARV        IFEQ      'Y'                                              B01       CRT008
     C     FNCD          ANDEQ     '0JD'                                                      CRT008
     C     W#TTFC        IFEQ      '0JX'                                            B02       CRT008
     C     W#TTFC        OREQ      '00S'                                                      CRT008
     C     W#TTFC        OREQ      '0JS'                                                      CRT008
     C                   MOVE      *BLANKS       PACNO                                        CRT008
     C                   MOVE      *BLANKS       PACN2                                        CRT008
     C                   ENDIF                                                      E02       CRT008
     C                   ENDIF                                                      E01       CRT008
     C                                                                                        CRT008
      *                                                                                       CRT008
      ** Get correct Converted Amount from TTRANPD if transaction                             CRT008
      ** is a reversal of a FX transaction take the converted                                 CRT008
      ** amount from the original transaction as CVAM or AMT2                                 CRT008
      ** is zero on the reversal record on TTRANPD                                            CRT008
      *                                                                                       CRT008
     C     FNCD          IFEQ      '0JD'                                            B01       CRT008
     C     W#TTFC        IFEQ      '0JH'                                            B02       CRT008
     C     W#TTFC        OREQ      '0JK'                                                      CRT008
     C     W#TTFC        OREQ      '0JL'                                                      CRT008
     C     W#TTFC        OREQ      '0JN'                                                      CRT008
     C     W#TTFC        OREQ      '0JO'                                                      CRT008
     C     W#TTFC        OREQ      '0JP'                                                      CRT008
     C     W#TTFC        OREQ      '0JQ'                                                      CRT008
     C     W#TTFC        OREQ      '0JS'                                                      CRT008
     C     W#TTFC        OREQ      '0JR'                                                      CRT008
     C     W#TTFC        OREQ      '0JX'                                                      CRT008
     C     W#TTFC        OREQ      '0JW'                                                      CRT008
      *                                                                                       CRT008
      ** Save original key on file                                                            CRT008
      *                                                                                       CRT008
     C                   MOVE      KBRI          KBRIX             1                          CRT008
     C                   MOVE      KITLB         KITLBX            3                          CRT008
     C                   MOVEL     KBID          KBIDX             3                          CRT008
     C                   MOVE      KTBTN         KTBTNX            5 0                        CRT008
      *                                                                                       CRT008
      ** Set up key to original transaction                                                   CRT008
      *                                                                                       CRT008
     C                   MOVE      'T'           KBRI                                         CRT008
     C                   MOVE      W#BRCA        KITLB                                        CRT008
     C                   MOVEL     W#TELD        KBID                                         CRT008
     C                   MOVE      PCRTN         KTBTN                                        CRT008
      *                                                                                       CRT008
     C                   OPEN      TTRANL1                                                    CRT008
      *                                                                                       CRT008
     C     KTRNL1        CHAIN     TTRANPDF                                                   CRT008
      *                                                                                       CRT008
      ** Format Converted Amount                                                              CRT008
      *                                                                                       CRT008
     C                   SELECT                                                               CRT008
      *                                                                                       CRT008
     C     W#TTFC        WHENEQ    '0JS'                                                      CRT008
     C                   MOVE      AMT2          CVAMT2                                       CRT008
      *                                                                                       CRT008
     C     W#TTFC        WHENEQ    '0JX'                                                      CRT008
     C                   MOVE      AMT1          CVAMT2                                       CRT008
      *                                                                                       CRT008
     C                   OTHER                                                                CRT008
     C                   MOVE      CVAM          CVAMT2           16                          CRT008
      *                                                                                       CRT008
     C                   ENDSL                                                                CRT008
      *                                                                                       CRT008
      ** For 0JX, 0JW, 0JS, 0JR take exchange rate from original transaction on TTRANPD       CRT008
      *                                                                                       CRT008
     C     W#TTFC        IFEQ      '0JX'                                            B03       CRT008
     C     W#TTFC        OREQ      '0JW'                                                      CRT008
     C     W#TTFC        OREQ      '0JS'                                                      CRT008
     C     W#TTFC        OREQ      '0JR'                                                      CRT008
     C                   MOVE      EXCR          ZFIELD                                       CRT008
     C                   Z-ADD     8             ZDEC                                         CRT008
     C                   CALLB     'ZEDIT'                                                    CRT008
     C                   PARM                    ZFIELD                                       CRT008
     C                   PARM                    ZDEC                                         CRT008
     C                   MOVE      *BLANKS       FREXRT                                       CRT008
     C                   MOVE      ZFIELD        FREXRT                                       CRT008
     C                   MOVE      *BLANKS       PEXRT                                        CRT008
     C                   MOVE      FREXRT        PEXRT                                        CRT008
     C                   ENDIF                                                      E03       CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       ZFIELD                                       CRT008
     C                   MOVE      CVAMT2        ZFIELD                                       CRT008
      *                                                                                       CRT008
     C                   Z-ADD     A6NBDP        ZDEC                                         CRT008
      *                                                                                       CRT008
     C                   CALLB     'ZEDIT'                                                    CRT008
     C                   PARM                    ZFIELD           16                          CRT008
     C                   PARM                    ZDEC              1 0                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       W#CVAM2          16                          CRT008
     C                   MOVE      ZFIELD        W#CVAM2                                      CRT008
     C                   MOVE      W#CVAM2       PAMTA                                        CRT008
      *                                                                                       CRT008
      ** Chain back to previous place in file                                                 CRT008
      *                                                                                       CRT008
     C                   MOVE      KBRIX         KBRI                                         CRT008
     C                   MOVE      KITLBX        KITLB                                        CRT008
     C                   MOVEL     KBIDX         KBID                                         CRT008
     C                   MOVE      KTBTNX        KTBTN                                        CRT008
     C     KTRNL1        CHAIN     TTRANPDF                                                   CRT008
     C                   MOVEL     W#FNCD        FNCD                                         CRT008
      *                                                                                       CRT008
     C                   CLOSE     TTRANL1                                                    CRT008
      *                                                                                       CRT008
     C                   ENDIF                                                      E02       CRT008
     C                   ENDIF                                                      E01       CRT008
      *                                                                                       CRT008
      ** Clear out fields not used for Midas Auto Reversal                                    CRT008
      *                                                                                       CRT008
     C     PRTARV        IFEQ      'Y'                                                        CRT008
     C     W#TTFC        ANDNE     '00A'                                                      CRT008
     C     W#TTFC        ANDNE     '0JX'                                                      CRT008
     C     W#TTFC        ANDNE     '0JW'                                                      CRT008
     C     W#TTFC        ANDNE     '0JS'                                                      CRT008
     C     W#TTFC        ANDNE     '0JR'                                                      CRT008
     C                   MOVE      *BLANKS       PCHAM                                        CRT008
     C                   MOVE      *BLANKS       PAMTA                                        CRT008
     C                   ENDIF                                                                CRT008
      *                                                                                       CRT008
     C                   ENDSR                                                                CRT008
      *****************************************************************                       CRT008
      /EJECT                                                                                  CRT008
     C*****************************************************************                       CRT008
      *                                                               *                       CRT008
      *             WRTEXC - Write to forwarding exception file       *                       CRT008
      *                                                               *                       CRT008
      * CALLED BY - RCVDTQ - Receive Dataqueue Processing.            *                       CRT008
      *           - ARVRPT - Report Auto Reversal Information         *                       CRT008
      *                                                               *                       CRT008
      *                                                               *                       CRT008
      *****************************************************************                       CRT008
      *                                                                                       CRT008
     C     WRTEXC        BEGSR                                                                CRT008
      *                                                                                       CRT008
      ** Reset fields on file REFWDEPD                                                        CRT008
      *                                                                                       CRT008
     C                   MOVE      *BLANKS       FWBRCA            3                          CRT008
     C                   MOVE      *BLANKS       FWTBID            3                          CRT008
     C                   MOVE      *BLANKS       FWTBTN                                       CRT008
     C                   MOVE      *BLANKS       FWDESC                                       CRT008
     C                   MOVE      *BLANKS       FWACNO                                       CRT008
     C                   MOVE      *BLANKS       FWCHAM           16                          CRT008
     C                   MOVE      *BLANKS       FWVLDT                                       CRT008
     C                   MOVE      *BLANKS       FWPRFC            4                          CRT008
     C                   MOVE      *BLANKS       FWMSGD                                       CRT008
     C                   MOVE      *BLANKS       FWCRTN                                       CRT008
     C                   MOVE      *BLANKS       FWEXRT                                       CRT008
     C                   MOVE      *BLANKS       FWCCY1            3                          CRT008
     C                   MOVE      *BLANKS       FWCCY2            3                          CRT008
     C                   MOVE      *BLANKS       FWAMT1                                       CRT008
     C                   MOVE      *BLANKS       FWCVAM                                       CRT008
     C                   MOVE      *BLANKS       FWACN2                                       CRT008
      *                                                                                       CRT008
      ** Set up output fields                                                                 CRT008
      *                                                                                       CRT008
     C                   MOVE      PBRCA         FWBRCA                                       CRT008
     C                   MOVE      PTELD         FWTBID                                       CRT008
     C                   MOVE      PTRNO         FWTBTN                                       CRT008
     C                   MOVE      PDESC         FWDESC                                       CRT008
     C                   MOVE      PACNO         FWACNO                                       CRT008
     C                   MOVE      PVLDT         FWVLDT                                       CRT008
     C                   MOVE      PPRFC         FWPRFC                                       CRT008
     C                   MOVE      PHSMS         FWMSGD                                       CRT008
     C                   MOVE      PCRTN         FWCRTN                                       CRT008
     C                   MOVE      PEXRT         FWEXRT                                       CRT008
     C                   MOVE      PCCYT         FWCCY1                                       CRT008
     C                   MOVE      PCCYA         FWCCY2                                       CRT008
     C                   MOVE      PAMTT         FWAMT1                                       CRT008
     C                   MOVE      PAMTA         FWCVAM                                       CRT008
     C                   MOVE      PACN2         FWACN2                                       CRT008
      *                                                                                       CRT008
     C     PCHAM         IFNE      *BLANKS                                                    CRT008
     C                   MOVE      PCHAM         FWCHAM                                       CRT008
     C                   ELSE                                                                 CRT008
     C     PCHA2         IFNE      *BLANKS                                                    CRT008
     C                   MOVE      PCHA2         FWCHAM                                       CRT008
     C                   ENDIF                                                                CRT008
     C                   ENDIF                                                                CRT008
      *                                                                                       CRT008
      ** Write To file                                                                        CRT008
      *                                                                                       CRT008
     C                   OPEN      REFWDEPD                                                   CRT008
     C                   WRITE     REFWDED0                                                   CRT008
     C                   CLOSE     REFWDEPD                                                   CRT008
      *                                                                                       CRT008
     C                   ENDSR                                                                CRT008
      *                                                                                       CRT008
      *****************************************************************                       CRT008
      /EJECT                                                                                  CRT008
      *****************************************************************                       CRT008
      *                                                               *                       CRT008
      *            ARVRPT - Report Auto Reversal Information          *                       CRT008
      *                                                               *                       CRT008
      * CALLS      SETPRT - Set up fields for report print            *                       CRT008
      *            WRTEXC - Write to forwarding exception file        *                       CRT008
      *                                                               *                       CRT008
      * CALLED BY  RBUNAK - Re-start rollback per Cashier             *                       CRT008
      *                                                               *                       CRT008
      *****************************************************************                       CRT008
     C     ARVRPT        BEGSR                                                                CRT008
      *                                                                                       CRT008
      ** Set up fields                                                                        CRT008
      *                                                                                       CRT008
     C                   MOVE      'Y'           PRTARV            1                          CRT008
     C                   MOVE      WOTBTN        W#TRNO            5 0                        CRT008
     C                   ADD       1             W#TRNO                                       CRT008
      *                                                                                       CRT008
      ** Get Information from TTRANL1                                                         CRT008
      *                                                                                       CRT008
     C                   MOVE      'T'           KBRI                                         CRT008
     C                   MOVE      W#BRCA        KITLB                                        CRT008
     C                   MOVEL     W#TELD        KBID                                         CRT008
     C                   MOVE      FRTRNO        KTBTN                                        CRT008
      *                                                                                       CRT008
     C                   OPEN      TTRANL1                                                    CRT008
     C     KTRNL1        CHAIN     TTRANPDF                                                   CRT008
     C                   CLOSE     TTRANL1                                                    CRT008
     C                   EXSR      SETPRT                                                     CRT008
      *                                                                                       CRT008
     C     OPEN          IFEQ      'N'                                                        CRT008
     C                   OPEN      RE4503P1                                                   CRT008
     C                   EXSR      RCFP1                                                      CRT008
     C                   WRITE     HEADP1                                                     CRT008
     C                   WRITE     DTLHDR                                                     CRT008
     C                   MOVEL     'Y'           OPEN                                         CRT008
     C                   ENDIF                                                                CRT008
      *                                                                                       CRT008
     C     OPEN          IFEQ      'Y'                                                        CRT008
     C     *IN40         ANDEQ     '1'                                                        CRT008
     C                   WRITE     HEADP1                                                     CRT008
     C                   WRITE     DTLHDR                                                     CRT008
     C                   MOVEL     '0'           *IN40                                        CRT008
     C                   ENDIF                                                                CRT008
      *                                                                                       CRT008
     C                   WRITE     DETAIL                                                     CRT008
     C                   WRITE     DETLS2                                                     CRT008
      *                                                                                       CRT008
     C                   EXSR      WRTEXC                                                     CRT008
      *                                                                                       CRT008
     C                   MOVE      ' '           PRTARV                                       CRT008
     C                   ADD       1             WCNT                                         CRT008
     C                   MOVE      '0'           *IN37                                        CRT008
      *                                                                                       CRT008
     C                   ENDSR                                                                CRT008
      *****************************************************************                       CRT008
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLS      *PSSR  - Program Error.                            *
      *                                                               *
      * CALLED BY  INIT   - Initial Processing.                       *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR
      *
     C                   MOVEL     PROG          DBPGM
     C                   OUT       LDA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            *PSSR  - Program Error.                            *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  COMMSG - Comms Message Processing.                 *
      *            DBERR  - Database Error Handling.                  *
      *            INIT   - Initial Processing.                       *
      *            MSGVAL - Further Message Validation.               *
      *            RCVDTQ - Receive Dataqueue Processing.             *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      **  Restore Branch Code and Teller details.
      *
     C                   MOVEL     @WBRCA        W#BRCA
     C                   MOVEL     @WTELD        W#TELD
      *
      **  Sign off teller from Teller Totals and Controls File.
      *
     C                   MOVEL     W#TELD        KTBID
      *                                                                                       194002
     C     KTBID         IFNE      *BLANKS                                                    194002
     C                   MOVEL     '1'           KRCTP                                        197289
     C     KTTRNT        CHAIN     TTRNM2L1                           30
      *
     C     *IN30         IFEQ      *ON
     C     RECI          ORNE      'D'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0055'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE4503'      PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVEL     *BLANKS       @WRK4             4
     C                   MOVEL     *BLANKS       @WRK5             5
     C     KTBRI         CAT       KTBID         @WRK4
     C     @WRK4         CAT       KRCTP         @WRK5
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C                   MOVEL     @WRK5         DBKEY
     C                   Z-ADD     19            DBASE
     C                   EXSR      DBERR
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       TWID
     C                   UPDATE    TTRNTM2F
      *
     C                   ENDIF
      *                                                                                       194002
     C                   ENDIF                                                                194002
      *
     C                   DUMP
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  DLY      - DELAY JOB
DLYJOB DLY(1)
** MTYP Valid Messages and required ACK/NAK.
BRCLN
BROPN
BSERN
CDATN
CDESN
CPRRN
CQDHY
CQDIY
DIRQY
EQUIN
EQUPN
KSOFN
KSONN
MIDBN
NOSTN
OITMY
PBCVN
PBLNN
RACBN
RVSEY
SFSON
SPDTN
SWSFN
SFWFN
CSOVY                                                                                         CRT005
CSIVY                                                                                         CRT005
TLINY                                                                                         CRT005
TLOUY                                                                                         CRT005
**   @TXT - TEXT STRINGS FOR OVERRIDE                                                         197289
DLTOVR     FILE(TTRANL1)                                                                      197289
OVRDBF     FILE(TTRANL1) MBR(XXXX) SECURE(*YES) SHARE(*YES) SEQONLY(*NO)                      197289
