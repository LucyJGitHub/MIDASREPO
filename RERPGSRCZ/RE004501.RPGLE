     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cashier TCP/IP communications program ctl')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE004501 - Midas Cashier TCP/IP Communications Program Ctrl  *
      *                                                               *
      *  This program is based on RE4401 and both version should be   *
      *  maintained at the same level.                                *
      *                                                               *
      *  Function:  This program will be evoked automatically during  *
      *  (I/C)      Input Cycle by each Cashier job starting at the   *
      *             AS/400.  It will provide the communications link  *
      *             between the Midas system on the AS/400 and        *
      *             remote branch comms controller session (i.e. the  *
      *             teller) by opening a conversation with the reques-*
      *             ter.  This function will receive incoming request *
      *             messages from the remote branch comms controller. *
      *             It will then update the status of the record in   *
      *             the interface's Log File (PF/REPLOGPD) and then   *
      *             ascertain, from the BAI Transaction Types File    *
      *             (PF/SDBAITPD), to which data queue it should send *
      *             the msg for processing by the banking function    *
      *             pgms and send the outgoing comms responses.       *
      *  Author: Alain Differdange                                    *
      *  Called By: REC4501 - Midas Cashier TCP/IP Communications     *
      *                        Program Ctrl                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27243           Date 18Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 24Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CRT005             Date 09Aug01               *
      *                 199373             Date 25Oct01               *
      *                 197289             Date 31Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CRT006             Date 18Jul01               *
      *                 194002             Date 06Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 176563             Date 06Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004  *CREATE    Date 06JUN00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompiled)                                        *
      *  BUG27243-Applied CPK029 fix - Customer field fix             *
      *  CPK029 - Customer fields should be 6A.                       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE019 - Cheque Processing and Maintenance (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CRT005 - Cashier Enhancement for Cash In/Cash Out            *
      *  199373 - Remove check on end of EMU transition.              *
      *  197289 - Cashier Reserve Transactions (update).              *
      *           Re-set key in KLIST before chaining.                *
      *           Avoids database error on sign-off (196630).         *
      *           Condition correction (196616).                      *
      *  CRT006 - Cashier Reserve Transactions.                       *
      *  194002 - Check Interface started to avoid multiple jobs.     *
      *    Also 1.Account Number is not being printed in the          *
      *           transaction journal report in Cashier (option 921)  *
      *         2.Midas should send a blank acknowledgement           *
      *           for Balance Cash.                                   *
      *         3.Turn on Enhanced Account Validation.                *
      *  176563 - Modify download to allow Account selection in       *
      *           Cashier. Workaround as Cashier fix not yet provided.*
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *                                                               *
      *****************************************************************
      /EJECT
     F*REPLOGL9**IF***E*****      K DISK                                                      197289
     F**********                           RENAME(REPLOGD0:REPLOGD9)                          197289
      ****CI*Communications Log keyed by Brch, Teller Id, Comms Seq No.                       197289
      *
     FREPLOGL0  UF A E           K DISK
      **  CI Communications Log keyed by CI Comms Seq No.
      *
     FTTRNM2L1  UF   E           K DISK
      **  Teller Controls File
      *
     F*REPDRIPDO***E                    DISK                              122060
     FREPDRIPD  O    E             DISK    USROPN                               122060
      **  CI Draft Issuance Incoming Message
      *
     FACCNTL0   IF   E           K DISK    INFSR(*PSSR)                         122060
      **  Account Details Full Account Number                             122060
      *                                                                   122060
     FREPDRIL1  UF   E           K DISK    INFSR(*PSSR)                         122060
     F                                     USROPN
     F                                     RENAME(REPDRID0:REPDRILF)            122060
      **  Draft Issuance Incoming Message key Draft No                    122060
      *                                                                   122060
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      **  SD Currency Codes
      *
     FSDNOSTL0  IF   E           K DISK    INFSR(*PSSR)
      **  SD Nostro Details
      *
     FSDBRCHL0  UF   E           K DISK    INFSR(*PSSR)
      **  SD Branch Details
      *
     FTTRNM2L2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TTRNTM2F:TTRNM2F2)
      **  RTS Tellers
      *
     FTTRNTM3   IF   E           K DISK    INFSR(*PSSR)                                       CRT006
      **  Teller Totals                                                                       CRT006
      *                                                                                       CRT006
     FACNUM     IF   E           K DISK    INFSR(*PSSR)                         118528
     F                                     RENAME(ACCNTABF:ACNUMF)              118528
      **  RE Account Numbers                                              118528
      *                                                                   118528
     FREBDCRPD  IF   E           K DISK    INFSR(*PSSR)
      **  RE Bureau de Change Rates Control
      *                                                                                       194002
     FREACJBL0  IF   E           K DISK                                                       194002
      **  List of active Transaction Handler jobs.                                            194002
      *
     FTTRANL1   UF   E           K DISK    INFSR(*PSSR)                                       CRT006
     F                                     USROPN                                             CRT006
      ** RE Teller Transactions                                                               CRT006
      *                                                                                       CRT006
      /EJECT
      *****************************************************************
      *                                                               *
      *                  FUNCTION OF INDICATORS                       *
      *                  ----------------------                       *
      *                                                               *
      *       20         End Of File for ICFF/RE4401CM.               *
      *       21         'READ' error on device ICFF/RE4401CM.        *
      *       22         'WRITE' error on device ICFF/RE4401CM.       *
      *       23         'ACQUIRE' error on device ICFF/RE4401CM.     *
      *       25         'RCVFAIL' on ICFF/RE4401CM.                  *
      *       26         'RCVCONFIRM' on ICFF/RE4401CM.               *
      *       27         'DETACH' on ICFF/RE4401CM.                   *
      *                                                               *
      *       30         'CHAIN' fail for LF/TTRNM2L1.                *
      *       31         'CHAIN' fail for LF/ACNUM.                   *   118528
      *       32         SCAN successful.                             *   118528
      *       35         'CHAIN' fail for LF/REPLOGL0.                *
      *                                                               *
      *       60         LOKUP 'equal to' on Device Array (CDV)       *
      *       62         LOKUP 'equal to' on Teller Array (TLR)       *
      *       64         LOKUP 'equal to' on Transaction Type (TXP)   *
      *       67         LOKUP 'equal to' on Msgs Require Ack(MTYP)   *
      *       67         LOKUP 'equal to' on commas in rates          *   119318
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
      *  CLOPOS - Postings Received At Branch Closure                 *   118528
      *  COMMSG - Comms Message Processing.                           *
      *  DBERR  - Database Error Handling.                            *
      *  DIMSG  - Draft Issuance Message Processing.                  *
      *  INIT   - Initialisation.                                     *
      *  MESG   - Message Processing.                                 *
      *  MSGVAL - Further Message Validation.                         *
      *  PAD    - Pad field with leading zeros.                       *   118528
      *  P06    - Retrieve System Control Data Routine.               *   118528
      *  P07    - Retrieve System Parameter Codes Routine.            *   118528
      *  P08    - Retrieve Exchange Rates Information.                *   118528
      *  P09    - Retrieve Nostro Account Details Routine.            *   118528
      *  P10    - Retrieve Branch Details Routine.                    *   118528
      *  P11    - Branch Open Routine.                                *   118528
      *  P12    - Branch Close Routine.                               *   118528
      *  P13    - Sign-Off Routine.                                   *   118528
      *  P14    - Sign-On Routine.                                    *   118528
      *  P15    - Retail Rates Routine.                               *   118528
      *  P16    - Alternative Currency Descriptions Routine.          *   118528
      *  P17    - Reversal of Account Balance Hold.                   *   118528
      *  RCVDTQ - Receive Dataqueue Processing.                       *
      *  ROLLBK - Rollback Processing.                                *
      *  RTVMSG - Retrieve Program Message Details.                   *
      *  RVFBDT - Calculate Working Days Backward.                    *   118528
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
     D********************MTYP    1  23  4   CONF    1                    CEU025
     D***MTYP***         S              4    DIM(24) CTDATA PERRCD(1)                  CEU025 CRT005
     D***CONF***         S              1    DIM(24) ALT(MTYP)                                CRT005
     D MTYP            S              4    DIM(28) CTDATA PERRCD(1)                           CRT005
     D CONF            S              1    DIM(28) ALT(MTYP)                                  CRT005
      **  Lookup Table to hold message type and required ACK or NAK.
      *
     D CDV             S             10    DIM(999) ASCEND
      **  Authorised Devices array.
      *
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
     D NAR             S             35    DIM(2) CTDATA PERRCD(1)
      **  Array containing Retail Rates Description
      *
     D RATE            S              1    DIM(16)
      **  Array containing field to be padded with leading zeros
      *
     D BDY             S              6    DIM(199)
      **  Array containing Business Days
      *
     D********************ACY        10189                                CEU025
     D AC1             S            244    DIM(10)                                               CEU
     D AC2             S             57    DIM(10)                                               CEU
      **  Array containing Outgoing Currency Blocks
      *
     D ASP             S              5    DIM(60)
      **  Array containing SP Codes
      *
     D AOS             S             23    DIM(60)
 
      *
     D AN1             S            235    DIM(4)
      **  Array containing Outgoing Nostro Block 1
      *
     D AN2             S            197    DIM(4)
      **  Array containing Outgoing Nostro Block 2
      *
     D ABR             S             39    DIM(50)
      **  Array containing Outgoing Branch Block
      *
     D AR1             S            231    DIM(10)
      **  Array containing Outgoing Retail Rates Block 1
      *
     D********************AR2        10 35                                CEU025
     D AR2             S             92    DIM(10)                                               CEU
      **  Array containing Outgoing Retail Rates Block 2
      *
     D ACD             S             76    DIM(16)
      **  Array containing Outgoing Alternate Currency Descriptions
      *
     D***********         AFR        21 21                                CEU025              164946
     D AFR             S             21    DIM(20)
      **  Array containing Fixed Rate Download                            CEU025
      *                                                                   CEU025
     D @TXT            S             80    DIM(2) CTDATA PERRCD(1)                            CRT006
      **  Array containing Text Strings for Override of Files                                 CRT006
      *                                                                                       CRT006
      /EJECT
      *
     D                 DS
     D*I************'CASHIER 8 '              1  10 W#ICDP                                    164273
     D  W#ICDP                 1     10    INZ('CASHIER   ')
      *
     D**  DATA STRUCTURE FOR SR. ZDATE9 - FIELD IS @@VDT
     D                 DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
     D                 DS
      **  Data structure to hold string constants for QCMDEXC
      *
     D  @CMD                   1     80
     D  @BRI                  30     30                                                       CRT006
     D  @BID                  31     33                                                       CRT006
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
     D  MSGS04               769   1003
     D  MSGS05              1004   1004                                                       CRT006
     D  W#JBDQ                15     24
     D  W#SEQN                25     30
     D  W#FWST               113    113                                         120880
     D  R#TRN1               358    371
     D  R#TRN2               461    474
     D  R#TRN3               515    528
     D  R#TRN4               529    542
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
     D  WOAMT                136    150  0                                                    197289
     D  WOSPCD               317    319                                                       CRT005
     D  ROMAC1               904    920                                                       197289
     D  ROMAC2               925    941                                                       197289
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
     D  M#TRN1               358    371
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
     D ICPRRD          DS
      **  Incoming CPRR Message
      *
     D  ICPRR                  1    116
     D**********                             74  76 IRRTYP                CEU025              164946
     D  IRRRTY               114    116
      *
     D OCPRRD          DS
      **  Outgoing CPRR Message
      *
     D  OCPRR                  1    111
     D  ORD01A               114    344
     D**************************************345 379 ORD01B                CEU025
     D**************************************380 610 ORD02A                CEU025
     D**************************************611 645 ORD02B                CEU025
     D**************************************646 876 ORD03A                CEU025
     D**************************************877 911 ORD03B                CEU025
     D**************************************9121142 ORD04A                CEU025
     D*************************************11431177 ORD04B                CEU025
     D*************************************11781408 ORD05A                CEU025
     D*************************************14091443 ORD05B                CEU025
     D*************************************14441674 ORD06A                CEU025
     D*************************************16751709 ORD06B                CEU025
     D*************************************17101940 ORD07A                CEU025
     D*************************************19411975 ORD07B                CEU025
     D*************************************19762206 ORD08A                CEU025
     D*************************************22072241 ORD08B                CEU025
     D*************************************22422472 ORD09A                CEU025
     D*************************************24732507 ORD09B                CEU025
     D*************************************25082738 ORD10A                CEU025
     D*************************************27392773 ORD10B                CEU025
     D  ORD01B               345    436                                         CEU025
     D  ORD02A               437    667                                         CEU025
     D  ORD02B               668    759                                         CEU025
     D  ORD03A               760    990                                         CEU025
     D  ORD03B               991   1082                                         CEU025
     D  ORD04A              1083   1313                                         CEU025
     D  ORD04B              1314   1405                                         CEU025
     D  ORD05A              1406   1636                                         CEU025
     D  ORD05B              1637   1728                                         CEU025
     D  ORD06A              1729   1959                                         CEU025
     D  ORD06B              1960   2051                                         CEU025
     D  ORD07A              2052   2282                                         CEU025
     D  ORD07B              2283   2374                                         CEU025
     D  ORD08A              2375   2605                                         CEU025
     D  ORD08B              2606   2697                                         CEU025
     D  ORD09A              2698   2928                                         CEU025
     D  ORD09B              2929   3020                                         CEU025
     D  ORD10A              3021   3251                                         CEU025
     D  ORD10B              3252   3343                                         CEU025
      *
     D OCPRRB          DS
      **  Outgoing RR Data Block.
      *
     D  ORORS1                 1    231
     D**************************************232 266 ORORS2                CEU025
     D  ORORS2               232    323                                         CEU025
     D  ORRRTY                 1      3
     D  ORRRDS                 4     38
     D  ORCCY                 39     41
     D  ORCCYN                42     44
     D  ORCCYD                45     79
     D  OREDCD                80     80
     D  ORRCFL                81     81
     D  ORBYRT                82     94
     D  ORBPRT                95    107
     D  ORBPAM               108    123
     D  ORBYCM               124    129
     D  ORBMDN               130    137
     D  ORSLRT               138    150
     D  ORSPRT               151    163
     D  ORSPAM               164    179
     D  ORSLCM               180    185
     D  ORSMDN               186    193
     D  ORARRD               194    228
     D  ORACCY               229    231
     D  ORACYD               232    266
     D  OREXBR               267    280                                         CEU025
     D  OREBPR               281    294                                         CEU025
     D  OREXSR               295    308                                         CEU025
     D  ORESPR               309    322                                         CEU025
     D  ORMBFL               323    323                                         CEU025
      *
     D ICDESD          DS
      **  Incoming CDES Message
      *
     D  ICDES                  1    116
     D  IDCCY                114    116
      *
     D OCDESD          DS
      **  Outgoing CDES message.
      *
     D  OCDES                  1    111
     D  ODD01                114    189
     D  ODD02                190    265
     D  ODD03                266    341
     D  ODD04                342    417
     D  ODD05                418    493
     D  ODD06                494    569
     D  ODD07                570    645
     D  ODD08                646    721
     D  ODD09                722    797
     D  ODD10                798    873
     D  ODD11                874    949
     D  ODD12                950   1025
     D  ODD13               1026   1101
     D  ODD14               1102   1177
     D  ODD15               1178   1253
     D  ODD16               1254   1329
      *
     D OCDESB          DS
      **  Outgoing CDES Data Block.
      *
     D  ODCCY                  1      3
     D  ODMJCD                 4     38
     D  ODFRFL                40     40
     D  ODNMWD                41     41
     D  ODMNCD                42     76
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
      **  CI Status Dataarea.
      *
     D  WCSEQN                 1      6  0
      *
     D CITFTS        E DS             2    EXTNAME(CITFTS)                      118528
      ** Data area for Unique Time Stamp                                  118528
      *                                                                   118528
     D  WNNSS                  1      2                                         118528
      *                                                                   118528
     D LDA             DS           256
      **  Local Data Area to identify database errors.
      *
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
     D ICDATD          DS
      **  Incoming CDAT Message
      *
     D  ICDAT                  1    119
     D  ICFBDT               114    116
     D  ICLBDT               117    119
      *
     D OCDATD          DS
      **  Outgoing CDAT Message
      *
     D  OCDAT                  1    111
     D  OCFBDT               114    116
     D  OCLBDT               117    119
     D  OCLCCY               120    122
     D  OCPBLN               123    124  0
     D  OCXRTL               125    126  0
     D  OCINSC               127    127
     D  OCDCSC               128    128
     D  OCDTFM               133    135
     D  OCBSD1               136    387
     D  OCBSD2               388    639
     D  OCBSD3               640    891
     D  OCBSD4               892   1143
     D  OCBSD5              1142   1329
     D  OCCQRF              1330   1330
     D  OCEANL              1331   1332                                                       194002
     D  OCEANE              1333   1357                                                       194002
     D  OCTMPF              1358   1358                                                       176563
     D  OCLCLY              1420   1420
     D  OCLCLN              1421   1421
     D  OCBRNM              1423   1457
     D  OCBRA1              1458   1492
     D  OCBRA2              1493   1527
     D  OCBRA3              1528   1562
     D  OCBRA4              1563   1597
     D  OCBRA5              1598   1632
     D  OCLDBF              1633   1633
     D  OCEACV              1844   1844
     D  OCBCCY              1845   1847
     D  OCHSID              1848   1848
     D  OCBRID              1849   1852
     D  OCRTOF              1853   1856                                         120072
     D  OCCYOF              1857   1860                                         120072
     D  OCLCEC              1861   1861                                         120072
     D  OCERSZ              1862   1862                                         CEU025
     D  OCAACN              1863   1863                                         CEU025
      *
     D ISPDTD          DS
      **  Incoming SPDT Message
      *
     D  ISPDT1                 1    256
     D  ISPDT2               257    419
     D  IPFBDT               114    116
     D  IPLBDT               117    119
     D  IPSPP1               120    374
     D  IPSPP2               375    419
      *
     D OSPDTD          DS
      **  Outgoing SPDT Message
      *
     D  OSPDT1                 1    111
     D  OSPDT2               114    366
     D  OSPDT3               367    619
     D  OSPDT4               620    872
     D  OSPDT5               873   1125
     D  OSPDT6              1126   1378
     D  OSPDT7              1379   1493
     D  OPDB01               114    136
     D  OPDB02               137    159
     D  OPDB03               160    182
     D  OPDB04               183    205
     D  OPDB05               206    228
     D  OPDB06               229    251
     D  OPDB07               252    274
     D  OPDB08               275    297
     D  OPDB09               298    320
     D  OPDB10               321    343
     D  OPDB11               344    366
     D  OPDB12               367    389
     D  OPDB13               390    412
     D  OPDB14               413    435
     D  OPDB15               436    458
     D  OPDB16               459    481
     D  OPDB17               482    504
     D  OPDB18               505    527
     D  OPDB19               528    550
     D  OPDB20               551    573
     D  OPDB21               574    596
     D  OPDB22               597    619
     D  OPDB23               620    642
     D  OPDB24               643    665
     D  OPDB25               666    688
     D  OPDB26               689    711
     D  OPDB27               712    734
     D  OPDB28               735    757
     D  OPDB29               758    780
     D  OPDB30               781    803
     D  OPDB31               804    826
     D  OPDB32               827    849
     D  OPDB33               850    872
     D  OPDB34               873    895
     D  OPDB35               896    918
     D  OPDB36               919    941
     D  OPDB37               942    964
     D  OPDB38               965    987
     D  OPDB39               988   1010
     D  OPDB40              1011   1033
     D  OPDB41              1034   1056
     D  OPDB42              1057   1079
     D  OPDB43              1080   1102
     D  OPDB44              1103   1125
     D  OPDB45              1126   1148
     D  OPDB46              1149   1171
     D  OPDB47              1172   1194
     D  OPDB48              1195   1217
     D  OPDB49              1218   1240
     D  OPDB50              1241   1263
     D  OPDB51              1264   1286
     D  OPDB52              1287   1309
     D  OPDB53              1310   1332
     D  OPDB54              1333   1355
     D  OPDB55              1356   1378
     D  OPDB56              1379   1401
     D  OPDB57              1402   1424
     D  OPDB58              1424   1447
     D  OPDB59              1448   1470
     D  OPDB60              1471   1493
      *
     D OSPDTB          DS
      **  Outgoing SP Data Block
      *
     D  OPSPPM                 1      5
     D  OPDRTC                 6      8
     D  OPOFDL                 9     11
     D  OPOFDF                12     14
     D  OPCRTC                15     17
     D  OPOFCL                18     20
     D  OPOFCF                21     23
      *
     D IBSERD          DS
      **  Incoming BSER Message
      *
     D  IBSER                  1    116
     D  IXCCY                114    116
      *
     D OBSERD          DS
      **  Outgoing BSER Message
      *
     D  OBSER                  1    111
     D**************************************114 329 OXCB01                CEU025
     D**************************************330 545 OXCB02                CEU025
     D**************************************546 761 OXCB03                CEU025
     D**************************************762 977 OXCB04                CEU025
     D**************************************9781193 OXCB05                CEU025
     D*************************************11941409 OXCB06                CEU025
     D*************************************14101625 OXCB07                CEU025
     D*************************************16261841 OXCB08                CEU025
     D*************************************18422057 OXCB09                CEU025
     D*************************************20582273 OXCB10                CEU025
     D  OXC01A               114    357                                         CEU025
     D  OXC01B               358    414                                         CEU025
     D  OXC02A               415    658                                         CEU025
     D  OXC02B               659    715                                         CEU025
     D  OXC03A               716    959                                         CEU025
     D  OXC03B               960   1016                                         CEU025
     D  OXC04A              1017   1260                                         CEU025
     D  OXC04B              1261   1317                                         CEU025
     D  OXC05A              1318   1561                                         CEU025
     D  OXC05B              1562   1618                                         CEU025
     D  OXC06A              1619   1862                                         CEU025
     D  OXC06B              1863   1919                                         CEU025
     D  OXC07A              1920   2163                                         CEU025
     D  OXC07B              2164   2220                                         CEU025
     D  OXC08A              2221   2464                                         CEU025
     D  OXC08B              2465   2521                                         CEU025
     D  OXC09A              2522   2765                                         CEU025
     D  OXC09B              2766   2822                                         CEU025
     D  OXC10A              2823   3066                                         CEU025
     D  OXC10B              3067   3123                                         CEU025
      *
     D OBSCYB          DS
      **  Outgoing CCY block
      *
     D  OXOXS1                 1    244                                         CEU025
     D  OXOXS2               245    301                                         CEU025
     D  OXCCY                  1      3
     D  OXCCYD                 4     38
     D  OXCCYE                39     39
     D  OXXRBC                40     52
     D  OXMNBC                53     60
     D  OXCMBC                61     66
     D  OXXRBT                67     79
     D  OXMNBT                80     87
     D  OXCMBT                88     93
     D  OXXRSC                94    106
     D  OXMNSC               107    114
     D  OXCMSC               115    120
     D  OXXRST               121    133
     D  OXMNST               134    141
     D  OXCMST               142    147
     D  OXRCRT               148    148
     D  OXCCYN               149    151
     D  OXARCY               152    154
     D  OXARCD               155    189
     D  OXSPRT               190    202
     D  OXSRRC               203    203
     D  OXUSRT               204    216
     D  OXEXBC               217    230                                         CEU025
     D  OXEXBT               231    244                                         CEU025
     D  OXEXSC               245    258                                         CEU025
     D  OXEXST               259    272                                         CEU025
     D  OXEXSR               273    286                                         CEU025
     D  OXEXUR               287    300                                         CEU025
     D  OXMBFL               301    301                                         CEU025
      *
     D INOSTD          DS
      **  Incoming NOST Message
      *
     D  INOST                  1    122
     D  INCCY                114    116
     D  INNSNM               117    122
      *
     D ONOSTD          DS
      **  Outgoing NOST Message
      *
     D  ONOST                  1    111
     D  ONNB1A               114    348
     D  ONNB1B               349    545
     D  ONNB2A               546    780
     D  ONNB2B               781    977
     D  ONNB3A               978   1212
     D  ONNB3B              1213   1409
     D  ONNB4A              1410   1644
     D  ONNB4B              1645   1841
      *
     D ONONSB          DS
      **  Outgoing Nostro Block
      *
     D  ONONS1                 1    235
     D  ONONS2               236    432
     D  ONCCY                  1      3
     D  ONNSNM                 4      9
     D  ONNSDC                10     44
     D  ONACBR                45     48
     D  ONACCN                49     54
     D  ONACSF                55     57
     D  ONRED1                58     92
     D  ONRED2                93    127
     D  ONRED3               128    162
     D  ONRED4               163    197
     D  ONNSA1               201    235
     D  ONNSA2               236    270
     D  ONNSA3               271    305
     D  ONNSA4               306    340
     D  ONNSA5               341    375
     D  ONARAB               376    410
     D  ONTRFM               411    412
     D  ONEXAC               413    432
      *
     D IMIDBD          DS
      **  Incoming MIDB Message
      *
     D  IMIDB                  1    116
     D  IBBRCH               114    116
      *
     D OMIDBD          DS
      **  Outgoing MIDB Message
      *
     D  OMIDB1                 1    111
     D  OMIDB2               114    347
     D  OMIDB3               348    581
     D  OMIDB4               582    815
     D  OMIDB5               816   1049
     D  OMIDB6              1050   1283
     D  OMIDB7              1284   1517
     D  OMIDB8              1518   1751
     D  OMIDB9              1752   1985
     D  OMID10              1986   2063
     D  OBBB01               114    152
     D  OBBB02               153    191
     D  OBBB03               192    230
     D  OBBB04               231    269
     D  OBBB05               270    292
     D  OBBB06               293    308
     D  OBBB07               309    347
     D  OBBB08               348    386
     D  OBBB09               387    425
     D  OBBB10               426    464
     D  OBBB11               465    503
     D  OBBB12               504    542
     D  OBBB13               542    581
     D  OBBB14               582    620
     D  OBBB15               621    659
     D  OBBB16               660    698
     D  OBBB17               699    737
     D  OBBB18               738    776
     D  OBBB19               777    815
     D  OBBB20               816    854
     D  OBBB21               855    893
     D  OBBB22               894    932
     D  OBBB23               933    971
     D  OBBB24               972   1010
     D  OBBB25              1049   1088
     D  OBBB26              1089   1127
     D  OBBB27              1128   1166
     D  OBBB28              1167   1205
     D  OBBB29              1206   1244
     D  OBBB30              1245   1283
     D  OBBB31              1284   1322
     D  OBBB32              1323   1361
     D  OBBB33              1362   1400
     D  OBBB34              1401   1439
     D  OBBB35              1440   1478
     D  OBBB36              1479   1517
     D  OBBB37              1518   1556
     D  OBBB38              1557   1595
     D  OBBB39              1596   1634
     D  OBBB40              1635   1673
     D  OBBB41              1674   1712
     D  OBBB42              1713   1751
     D  OBBB43              1752   1790
     D  OBBB44              1791   1829
     D  OBBB45              1830   1868
     D  OBBB46              1869   1907
     D  OBBB47              1908   1946
     D  OBBB48              1947   1985
     D  OBBB49              1986   2024
     D  OBBB50              2025   2063
      *
     D OBBRBK          DS
      **  Outgoing Branch Block
      *
     D  OBBRCH                 1      3
     D  OBBRNM                 4     33
     D  OBINCN                34     39
      *
     D IBROPD          DS
      **  Incoming BROP Message
      *
     D  IBROP                  1    116
      *
     D OBROPD          DS
      **  Outgoing BROP Message
      *
     D  OBROP                  1    113
      *
     D IBRCLD          DS
      **  Incoming BRCL Message
      *
     D  IBRCL                  1    116
      *
     D OBRCLD          DS
      **  Outgoing BRCL Message
      *
     D  OBRCL                  1    113
      *
     D IKSOFD          DS
      **  Incoming KSOF Message
      *
     D  IKSOF                  1    114
      *
     D OKSOFD          DS
      **  Outgoing KSOF Message
      *
     D  OKSOF                  1    113
      *
     D IKSOND          DS
      **  Incoming KSON Message
      *
     D  IKSON                  1    117
      *
     D OKSOND          DS
      **  Outgoing KSON Message
      *
     D  OKSON                  1    113
      *
     D IRACBD          DS                                                       118528
      **  Incoming RACB Message                                           118528
      *                                                                   118528
     D  IRACB                  1    155                                         118528
     D  IRFWST               113    113                                         118528
     D  IRBRCH               114    117                                         118528
     D  IRCUSN               118    123                                         118528
     D  IRASFX               124    126                                         118528
     D  IRAACN               127    146                                         118528
     D  IRAANF               147    147                                         118528
      *                                                                   118528
     D ORACBD          DS                                                       118528
      **  Outgoing RACB Message                                           118528
      *                                                                   118528
     D  ORACB                  1    162                                         118528
     D  ORAVBS               114    114                                         118528
     D  ORAVBL               115    130                                         118528
     D  ORFTBC               131    146                                         118528
     D  ORTMST               147    161                                         118528
     D  ORFBCF               162    162                                         118528
      *                                                                   118528
     D IFRATD          DS                                                       CEU025
      **  Incoming Fixed Rate Download                                    CEU025
      *                                                                   CEU025
     D  IFRAT                  1    116                                         CEU025
     D  IFEUCY               114    116                                         CEU025
      *                                                                   CEU025
     D OFRATD          DS                                                       CEU025
      **  Outgoing Fixed Rate Download                                    CEU025
      *                                                                   CEU025
     D  OFRAT                  1    111                                         CEU025
     D  OFDB01               114    134                                         CEU025
     D  OFDB02               135    155                                         CEU025
     D  OFDB03               156    176                                         CEU025
     D  OFDB04               177    197                                         CEU025
     D  OFDB05               198    218                                         CEU025
     D  OFDB06               219    239                                         CEU025
     D  OFDB07               240    260                                         CEU025
     D  OFDB08               261    281                                         CEU025
     D  OFDB09               282    302                                         CEU025
     D  OFDB10               303    323                                         CEU025
     D  OFDB11               324    344                                         CEU025
     D  OFDB12               345    365                                         CEU025
     D  OFDB13               366    386                                         CEU025
     D  OFDB14               387    407                                         CEU025
     D  OFDB15               408    428                                         CEU025
     D  OFDB16               429    449                                         CEU025
     D  OFDB17               450    470                                         CEU025
     D  OFDB18               471    491                                         CEU025
     D  OFDB19               492    512                                         CEU025
     D  OFDB20               513    533                                         CEU025
     D**********                            534 554 OFDB21                CEU025              164946
      *                                                                   CEU025
     D OFRATB          DS                                                       CEU025
     D  OFFRCY                 1      3                                         CEU025
     D  OFGRCY                 4      6                                         CEU025
     D  OFRCFL                 7      7                                         CEU025
     D  OFFRRT                 8     21                                         CEU025
      *
      ** Account Format Mask                                                                  194002
      *                                                                                       194002
     DX@MASK           C                   CONST('999-9999999999')                            194002
      *                                                                                       194002
     D OMSDT           DS          2273
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      **  Switchable Features
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Bank Details
      *
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
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Branch codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Currency Details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
      **  Customer Details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      **  Dealing ICD
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CEU025
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
      **  Teller id                                                       CEU025
      *                                                                   CEU025
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  Midas Modules
      *
     D DSMEMS        E DS                  EXTNAME(MEMOS)                       118528
      **  Shadow Balances                                                 118528
      *                                                                   118528
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
 
     d brcae           S              3
     d usid            S             10
     d prfx            S              2
     D wmdta1          S             10
     D wmdta2          S             10
     D KACOD           S             10S 0                                                    CGL029
     D W#ACDD          S             10S 0                                                    CGL029
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
      *                                                                                       164271
      **  Ensure the Teller is unlocked from TTRNTM2 when exiting.                            164271
      *                                                                                       164271
      **  Restore Branch Code and Teller details.                                             164271
      *                                                                                       164271
     C                   MOVEL     @WBRCA        W#BRCA
     C                   MOVEL     @WTELD        W#TELD
     C                   MOVEL     '1'           KRCTP                                        197289
      *                                                                                       164271
      **  Sign off teller from Teller Totals and Controls File.                               164271
      *                                                                                       164271
     C                   MOVEL     W#TELD        KTBID
     C     KTTRNT        CHAIN     TTRNM2L1                           30
      *                                                                                       164271
     C     *IN30         IFEQ      *ON
     C     RECI          ORNE      'D'
      *                                                                                       164271
     C                   MOVEL     *BLANKS       @WRK4
     C                   MOVEL     *BLANKS       @WRK5
     C     KTBRI         CAT       KTBID         @WRK4
     C     @WRK4         CAT       KRCTP         @WRK5
      *                                                                                       164271
     C     *LOCK         IN        LDA
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C                   MOVEL     @WRK5         DBKEY
     C                   Z-ADD     29            DBASE
     C                   EXSR      DBERR
      *                                                                                       164271
     C                   ELSE
      *                                                                                       164271
     C                   MOVE      *BLANKS       TWID
     C                   UPDATE    TTRNTM2F
     C                   ENDIF
      *
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   MOVE      '1'           *INLR
     C                   RETURN
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
     C                   MOVE      *BLANKS       FIELDO                                       194002
     C                   MOVE      'N'           WERROR            1
      *
      **  Read ICF file for incoming message data.
      *
     C**********         READ      DATAIN                               2120
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
      ** If the first message received in any SND/ACK/ACK or NAK/FIN                          197289
      ** group is a NAK, try to roll back any unacknowledged and                              197289
      ** send a FIN.                                                                          197289
     C     MsgType       IFEQ      'NAK'                                                      197289
     C                   EXSR      RBUNAK                                                     197289
     C                   MOVEL     'N'           WRCVDQ                                       197289
      * Send FIN  message                                                                     197289
     C                   movel     '00000000'    header                                       197289
     C                   move      'FIN'         header                                       197289
     C                   clear                   Sbuffer                                      197289
     C                   movel     header        Sbuffer                                      197289
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )                      197289
     C                   If        RetCode = -1                                               197289
     C                   exsr      tcperr                                                     197289
     C                   EndIf                                                                197289
      *                                                                                       197289
     C                   ELSE                                                                 197289
      *                                                                                       197289
     C******IN27         IFEQ      '1'
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
     C                   PARM      'RE004501'    PROG
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
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WRLBCK            1
      *
     C     WERROR        IFEQ      'N'
      *
      **  If the data format from the ICFF/RE4401CM has not been read or
      **  the mesage itself is blank.
      *
     C*****ICFREC        IFNE      'DATAIN'
     C     FIELDI        IFEQ      *BLANKS
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0054'     @MSGID
     C                   MOVEL     'ICFREC'      WMDTA1
     C                   MOVEL     'RE4401CM'    WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
      ****Check*Interface*ICD*to*see*if*product*is*'CASHIER*8'.******     164273
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
      ****ie*the*product*is*'CASHIER 8'.                                  164273
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
      *
      **  Process incoming message depending on message type.
      *
     C                   SELECT
      *
      **  System Control Data.
      *
     C     I#MSTY        WHENEQ    'CDAT'
     C                   EXSR      P06
      *
      **  System Parameter Code.
      *
     C     I#MSTY        WHENEQ    'SPDT'
     C                   EXSR      P07
      *
      **  Exchange Rates Information.
      *
     C     I#MSTY        WHENEQ    'BSER'
     C                   EXSR      P08
      *
      **  Nostro Account Details.
      *
     C     I#MSTY        WHENEQ    'NOST'
     C                   EXSR      P09
      *
      **  Branch Details.
      *
     C     I#MSTY        WHENEQ    'MIDB'
     C                   EXSR      P10
      *
      **  Branch Opening.
      *
     C     I#MSTY        WHENEQ    'BROP'
     C                   EXSR      P11
      *
      **  Branch Closure.
      *
     C     I#MSTY        WHENEQ    'BRCL'
     C                   EXSR      P12
      *
      **  Sign Off.
      *
     C     I#MSTY        WHENEQ    'KSOF'
     C                   EXSR      P13
      *
      **  Sign On.
      *
     C     I#MSTY        WHENEQ    'KSON'
     C                   EXSR      P14
      *
      **  Retail Rates.
      *
     C     I#MSTY        WHENEQ    'CPRR'
     C                   EXSR      P15
      *
      **  Alternative Currency Descriptions.
      *
     C     I#MSTY        WHENEQ    'CDES'
     C                   EXSR      P16
      *                                                                   118528
      **  Reversal of Account Balances Hold                               118528
      *                                                                   118528
     C     I#MSTY        WHENEQ    'RACB'                                                      11852
     C                   EXSR      P17                                                         11852
      *                                                                   CEU025
      ** Fixed Rate Download                                              CEU025
      *                                                                   CEU025
     C     I#MSTY        WHENEQ    'FRAT'                                                      CEU02
     C                   EXSR      P18                                                         CEU02
      *                                                                                       CRT005
      ** Ignore Cashier Transactions for Teller Treasury In, Teller Treasury Out,             CRT005
      ** Teller Cross In, and Teller Cross Out when CRT005 is not installed                   CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'CSOV'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C                   EXSR      CLOPOS                                                     CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'CSIV'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C                   EXSR      CLOPOS                                                     CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'TLIN'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C                   EXSR      CLOPOS                                                     CRT005
      *                                                                                       CRT005
     C     I#MSTY        WHENEQ    'TLOU'                                                     CRT005
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C                   EXSR      CLOPOS                                                     CRT005
      *
      **  Branch Closure Postings.
      *
     C     W#TXP         WHENEQ    'SP101'
     C                   EXSR      CLOPOS
      *
     C     W#TXP         WHENEQ    'SP250'
     C                   EXSR      CLOPOS
      *
     C     W#TXP         WHENEQ    'SP251'
     C     CRT005        ANDEQ     'N'                                                        CRT005
     C                   EXSR      CLOPOS
      *
     C     W#TXP         WHENEQ    'SP252'
     C                   EXSR      CLOPOS
      *
     C                   OTHER
     C                   EXSR      MSGVAL
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                       197289
     C                   ENDIF                                                                197289
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
     C                   MOVEL     *BLANK        MSGS05                                       CRT006
      *
     C                   MOVEL     WJOBID        W#JBDQ
     C                   MOVEL     'N'           W#FWST                                        12088
      *
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
      ***  Branch is found but not open.
      ***  Or Branch Open for Forwarding Purpose
      *
     C     A8BRST        IFEQ      'C'
     C*****A8BRST        IFNE      'O'
     C*****A8BRST        ANDNE     'I'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0004'     @MSGID
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
      **  If teller status flag array element is off.
      *
     C     TST(A)        IFEQ      'OFF'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0007'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
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
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C*********          WRITE     STATO
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
      **  If teller status flag array element is on.
      *
     C                   ELSE
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
     C***********I#SPCD    ANDEQ*BLANK
     C***********          MOVELW#TX2     W#TX10
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
     C                   PARM      'RE004501'    PROG
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
     C                   MOVEL     @TTRNT        DBKEY
     C                   ELSE                                                                 194002
     C                   MOVEL     'INACTIVE'    DBFILE                                       194002
     C                   MOVEL     O#HMSI        DBKEY                                        194002
     C                   ENDIF                                                                194002
     C                   Z-ADD     21            DBASE
     C                   EXSR      DBERR
      *
      **  Set Off Session Active Flag.
      *
     C     I#MSTY        IFNE      'EQUP'
     C                   MOVEL     'N'           WACTIV
     C                   ENDIF
      *
     C*********          WRITE     STATO
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
     C     I#MSTY        WHENEQ    'DIRQ'
     C                   EXSR      DIMSG
      *
     C                   OTHER
     C                   EXSR      MESG
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF                                                                   -of
      *
     C                   ENDIF                                                                   -of
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
     C                   MOVEL     'C'           O#HMSS
     C                   MOVE      *BLANKS       O#HMSI
     C                   MOVEL     FIELDI        O#HMSG
      *
     C                   EXSR      WRTLOG
     C                   EXSR      WRTDRI
      *
     C                   MOVEL     'Y'           WRCVDQ                                        12206
     C                   ENDIF                                                                 12206
      *                                                                   122060
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
      **  Load the 'RICMSG' field
      *
     C     WOAREV        IFNE      'Y'                                                        197289
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
     C                   ENDIF                                                                197289
      *
     C                   MOVEL     WCSEQN        W#SEQN
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
     C                   MOVEL     W#BRCA        RNBRNO
     C                   MOVEL     I#USER        RNUSID
     C***********          MOVELI#ACNO    RNNOSA                          122060
     C***********          MOVELI#CUR1    RNDCCY                          122060
     C***********          MOVELI#CUR2    RNFCCY                          122060
     C***********          MOVELI#SPCD    RNSPC1                          122060
     C***********          MOVELI#SPC2    RNSPC2                          122060
     C***********          Z-ADDI#TAMT    RNDRAM                          122060
     C***********          MOVELI#VDAT    RNVDAT                          122060
      *                                                                   122060
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
     C                   MOVEL     *BLANK        RNACKF                                       CRT006
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
     C     ZALIGNOK      IFNE      'N'                                                         12206
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
     C     WRLBCK        IFNE      'Y'
      *
      **  Determine if received message requires a confirmation.
      *
     C     CONFRQ        IFEQ      'Y'
     C     M#HMSS        ANDEQ     'C'
     C     CONFRQ        OREQ      'Y'
     C     M#HMSS        ANDEQ     'W'
     C************       WRITE     OUTACK                               22
      *
      * Send ACK  message
     C                   movel     '00002560'    header
     C                   move      'ACK'         header
     C                   clear                   Sbuffer
     C     Header        cat       FIELDO        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      * Receive next message and retrieve ACK/NAK
      *
     C                   Eval      Rbuffer = *Blank                                           CRT005
     C                   Eval      RetCode = Rcv_Tcp( ScktNum: Rbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   Else
     C                   eval      MsgType= %subst(Rbuffer :9:3)
     C                   EndIf
      *
      **  If Confirm not received from the remote branch controller,
      **  retrieve error message data to send in host message.
      *
     C*****MAJMIN        IFNE      '0001'
     C     MSGTYPE       IFNE      'ACK'
      *
     C                   MOVEL     'USR0058'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C************       PARM      MAJMIN        MMCODE
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM      *BLANKS       @MSGDT
      *
     C                   EXSR      ROLLBK
      *
     C                   ELSE
      *
      **  If PC application has sent a confirm.
      *
     C                   MOVE      'CS'          WMSTAT
      *                                                                                       CRT006
     C     I#MSTY        IFNE      'DIRQ'                                                     CRT006
      *                                                                                       CRT006
     C                   MOVEL     W#BRCA        @BRCA                                        CRT006
     C                   MOVEL     W#TELD        @TELD                                        CRT006
      *                                                                                       CRT006
     C*****KLLOG9*****   SETGT     REPLOGL9                           70               CRT006 197289
     C                   MOVEL     *BLANKS       @RITELD                                      197289
     C     *HIVAL        SETGT     REPLOGL0                           70                      197289
      *                                                                                       CRT006
     C**********         READPE    REPLOGL9                               70           CRT006 197289
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
      *                                                                                       CRT006
     C     WFIRST        IFNE      'Y'                                                        CRT006
      *                                                                                       CRT006
     C                   MOVEL     *BLANKS       @CMD                                         CRT006
     C                   MOVEL     @TXT(1)       @CMD                                         CRT006
      *                                                                                       CRT006
     C                   CALL      'QCMDEXC'                                                  CRT006
     C                   PARM                    @CMD                                         CRT006
     C                   PARM      80            @LEN             15 5                        CRT006
      *                                                                                       CRT006
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   MOVE      'N'           WFIRST            1                          CRT006
      *                                                                                       CRT006
     C                   MOVEL     *BLANKS       @CMD                                         CRT006
     C                   MOVEL     @TXT(2)       @CMD                                         CRT006
     C                   MOVEL     'T'           @BRI                                         CRT006
     C                   MOVEL     W#TELD        @BID                                         CRT006
      *                                                                                       CRT006
     C                   CALL      'QCMDEXC'                                                  CRT006
     C                   PARM                    @CMD                                         CRT006
     C                   PARM      80            @LEN                                         CRT006
      *                                                                                       CRT006
      ** Set up key list for TTRNTM3                                                          CRT006
     C                   MOVEL     'T'           KTBRI                                        CRT006
     C                   MOVEL     W#TELD        KTBID                                        CRT006
     C                   MOVEL     '2'           KRCTP                                        CRT006
      *                                                                                       CRT006
      ** Retrieve Teller's transaction number of last update.                                 CRT006
     C     KTTRNT        CHAIN     TTRNTM3                            70                      CRT006
      *                                                                                       CRT006
     C                   OPEN      TTRANL1                                                    CRT006
      *                                                                                       CRT006
     C                   MOVE      'T'           KBRI                                         CRT006
     C                   MOVE      W#BRCA        KITLB                                        CRT006
     C                   MOVE      W#TELD        KBID                                         CRT006
     C                   Z-ADD     TTLU          KTBTN                                        CRT006
      *                                                                                       CRT006
     C     KTRNL1        CHAIN     TTRANPDF                           71                      CRT006
      *                                                                                       CRT006
     C     *IN71         IFEQ      *OFF                                                       CRT006
     C                   MOVE      'Y'           ACKF                                         CRT006
     C                   UPDATE    TTRANPDF                                                   CRT006
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   CLOSE     TTRANL1                                                    CRT006
      *                                                                                       CRT006
     C                   ELSE                                                                 CRT006
      *                                                                                       CRT006
     C                   OPEN      REPDRIL1                                                   CRT006
      *                                                                                       CRT006
     C                   MOVEL     D#DRNO        KDRNO                                        CRT006
     C                   MOVEL     *BLANKS       KODRN                                        CRT006
     C                   MOVEL     D#ACDE        KACDE                                        CRT006
      *                                                                                       CRT006
     C     KLPDRI        CHAIN     REPDRIL1                           24                      CRT006
      *                                                                                       CRT006
     C     *IN24         IFEQ      *OFF                                                       CRT006
     C                   MOVE      'Y'           RNACKF                                       CRT006
     C                   UPDATE    REPDRILF                                                   CRT006
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   CLOSE     REPDRIL1                                                   CRT006
      *                                                                                       CRT006
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   EXSR      UPDLOG
     C                   END
      *
      * Send FIN  message
     C                   movel     '00000000'    header
     C                   move      'FIN'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      ** If No acknowledgement required
     C                   ELSE
     C**********         WRITE     OUTNAK                               22
      *
      * Send message
     C                   movel     '00002560'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       FIELDO        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      *********
      ****If*DEVICE ERROR or any other error encountered on the WRITE.
     C******IN22         IFEQ      *ON
      *********
      ****Retrieve error message data to send in host message.
      *********
     C*********          MOVEL     'USR0056'     @MSGID
     C*********          MOVEL     *BLANKS       WMDTA1
     C*********          MOVEL     *BLANKS       WMDTA2
     C*********          EXSR      RTVMSG
     C*********          MOVEL     @MSGTX        O#HMSG
     C*********          MOVE      'E'           O#HMSS
     C*********          MOVE      @MSGID        O#HMSI
      *********
      ****Report error.
      *********
     C*********          CALL      'REC4411'
     C*********          PARM      'RE4401'      PROG
     C*********          PARM                    JOBNUM
     C*********          PARM      MAJMIN        MMCODE
     C*********          PARM      W#BRCA        P#BRCA
     C*********          PARM                    @MSGID
     C*********          PARM                    @MSGDT
      *********
     C*********          MOVE      'N'           WCSTAT
     C*********          MOVE      'CS'          WMSTAT
     C*********          EXSR      UPDLOG
      *********
     C*********          WRITE     STATO
      *********
      ****Set*Off Session Active Flag.
      *********
     C*********          MOVEL     'N'           WACTIV
     C*********          ENDIF
      *
     C     M#HMSS        IFEQ      'E'                                                         12206
     C     M#MSTY        ANDEQ     'DIRQ'                                                      12206
     C                   EXSR      ROLLBK                                                      12206
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'R'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      UPDLOG
     C                   END
      *
     C                   ELSE
      *
      **  Set ICF File Read required Flag.
      *
     C                   MOVEL     'N'           WRDICF
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
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
      ****Access*LF/REPLOGL9*to*retrieve last record for this teller.                         197289
      **  Access LF/REPLOGL0 to retrieve last record for this teller.                         197289
      *
     C                   MOVEL     W#BRCA        @BRCA
     C                   MOVEL     W#TELD        @TELD
     C*****KLLOG9*****   SETGT     REPLOGL9                           70                      197289
     C                   MOVEL     *BLANKS       @RITELD                                      197289
     C     *HIVAL        SETGT     REPLOGL0                           70                      197289
      *
      **  Check that neither BRCA not TELD are different from those in the
      **  partial key. If so we have gone past our required teller.
      *
     C**********         READPE    REPLOGL9                               70                  197289
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
     C                   MOVEL     RITELD        @RITELD           3                          197289
     C                   ENDIF                                                                197289
     C                   ENDDO                                                                197289
      *                                                                                       CRT006
     C     WFIRST        IFNE      'Y'                                                        CRT006
      *                                                                                       CRT006
     C                   MOVEL     *BLANKS       @CMD                                         CRT006
     C                   MOVEL     @TXT(1)       @CMD                                         CRT006
      *                                                                                       CRT006
     C                   CALL      'QCMDEXC'                                                  CRT006
     C                   PARM                    @CMD                                         CRT006
     C                   PARM      80            @LEN                                         CRT006
      *                                                                                       CRT006
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   MOVE      'N'           WFIRST                                       CRT006
      *                                                                                       CRT006
     C                   MOVEL     *BLANKS       @CMD                                         CRT006
     C                   MOVEL     @TXT(2)       @CMD                                         CRT006
     C                   MOVEL     'T'           @BRI                                         CRT006
     C                   MOVEL     W#TELD        @BID                                         CRT006
      *                                                                                       CRT006
     C                   CALL      'QCMDEXC'                                                  CRT006
     C                   PARM                    @CMD                                         CRT006
     C                   PARM      80            @LEN                                         CRT006
      *                                                                                       CRT006
      ** Set up key list for TTRNTM3                                                          CRT006
     C                   MOVEL     'T'           KTBRI                                        CRT006
     C                   MOVEL     W#TELD        KTBID                                        CRT006
     C                   MOVEL     '2'           KRCTP                                        CRT006
      *                                                                                       CRT006
      ** Retrieve Teller's transaction number of last update.                                 CRT006
     C     KTTRNT        CHAIN     TTRNTM3                            70                      CRT006
      *                                                                                       CRT006
     C                   OPEN      TTRANL1                                                    CRT006
      *                                                                                       CRT006
     C                   MOVE      'T'           KBRI                                         CRT006
     C                   MOVE      W#BRCA        KITLB                                        CRT006
     C                   MOVE      W#TELD        KBID                                         CRT006
     C                   Z-ADD     TTLU          KTBTN                                        CRT006
      *                                                                                       CRT006
     C     KTRNL1        CHAIN     TTRANPDF                           71                      CRT006
      *                                                                                       CRT006
     C                   CLOSE     TTRANL1                                                    CRT006
      *                                                                                       CRT006
     C     MSGTYPE       IFNE      'NAK'                                                      CRT006
     C                   MOVE      *BLANK        WRLBCK                                       CRT006
     C                   ELSE                                                                 CRT006
      *
      **  Chain to REPLOGL0 to do the update to show that it has been rolled
      **  back (or perhaps write a new record in REPLOGPD).
      *
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
     C                   EXSR      WRTLOG
      *
     C                   MOVE      W#RVDQ        DTAQS
     C                   Z-ADD     W#RVDL        LENS
      *                                                                                       CRT006
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C     MSGTYPE       IFEQ      'NAK'                                                      CRT006
     C     ACKF          ANDEQ     *BLANK                                                     197289
     C*****ACKF*****     ANDEQ     'Y'                                                 CRT006 197289
      *
      **  Set transaction reference fields for Reversal
      *
     C                   MOVEL     M#TRN1        R#TRN1
     C                   MOVEL     M#TRN2        R#TRN2
     C                   MOVEL     M#TRN3        R#TRN3
     C                   MOVEL     M#TRN4        R#TRN4
     C                   MOVE      'Y'           MSGS05                                       CRT006
      *
     C                   CALL      'QSNDDTAQ'    DTQSND
      *
      **  Set up Data Queue Length parm for receive data queue (from RBA).
      *
     C                   Z-ADD     2560          LENR
      *
     C                   CALL      'QRCVDTAQ'    DTQRCV
      *
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   ELSE                                                                  12206
      *                                                                   122060
     C                   OPEN      REPDRIL1                                                    12206
      *                                                                   122060
     C                   MOVEL     D#DRNO        KDRNO                                         12206
     C                   MOVEL     *BLANKS       KODRN                                         12206
     C                   MOVEL     D#ACDE        KACDE                                         12206
     C     KLPDRI        CHAIN(N)  REPDRIL1                           24                       12206
      *                                                                   122060
     C     MSGTYPE       IFEQ      'NAK'                                                      CRT006
     C     RNACKF        OREQ      *BLANK                                                     CRT006
      *                                                                                       CRT006
     C     *IN24         IFEQ      '0'                                                         12206
     C                   MOVEL     '*'           RNRECI                                        12206
     C                   UPDATE    REPDRILF                                                    12206
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   ENDIF                                                                CRT006
      *                                                                                       CRT006
     C                   CLOSE     REPDRIL1                                                    12206
      *                                                                   122060
     C                   ENDIF                                                                 12206
      *                                                                   122060
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *            CLOPOS - Postings Received At Branch Closure       *
      *                                                               *
      * CALLS      RTVMSG - Retrieve Program Message Details.         *
      *            UPDLOG - Update Communications Log.                *
      *                                                               *
      * CALLED BY  COMMSG - Comms Message Processing.                 *
      *                                                               *
      *****************************************************************
     C     CLOPOS        BEGSR
      *
      **  Ignore these messages as Midas has no use for these Equation
      **  based messages. Midas has already received or will generate this
      **  information itself. Just answer the messages. As they are 'OITM'
      **  message types they require a confirmation to be used.
      *
     C************       WRITE     OUTACK                               22
      *
      * Send ACK  message
     C                   movel     '00002560'    header
     C                   move      'ACK'         header
     C                   clear                   Sbuffer
     C     Header        cat       FIELDO        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
      * Receive next message and retrieve ACK/NAK
      *
     C                   Eval      Rbuffer = *Blank                                           CRT005
     C                   Eval      RetCode = Rcv_Tcp( ScktNum: Rbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   Else
     C                   eval      MsgType= %subst(Rbuffer :9:3)
     C                   EndIf
      *
      **  If Confirm not received from the remote branch controller,
      **  retrieve error message data to send in host message.
      *
     C*****MAJMIN        IFNE      '0001'
     C     MSGTYPE       IFNE      'ACK'
      *
     C                   MOVEL     'USR0058'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C************       PARM      MAJMIN        MMCODE
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM      *BLANKS       @MSGDT
      *
     C                   END
      *
      * Send FIN  message
     C                   movel     '00000000'    header
     C                   move      'FIN'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
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
     C                   parm                    brcae
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
     C                   PARM      'RE004501'    PROG             10                          194002
     C                   PARM                    JOBNUM            6                          194002
     C                   PARM      '0000'        MMCODE            4                          194002
     C                   PARM      brcae         P#BRCA            3                          194002
     C                   PARM      *BLANKS       @MSGID            7                          194002
     C                   PARM                    @MSGDT                                       194002
     C                   movel     '00000083'    header                                       194002
     C                   move      'ERR'         header                                       194002
     C                   clear                   Sbuffer                                      194002
     C     Header        cat       O#ERR         Sbuffer                                      194002
      * Send ERR message                                                                      194002
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )                      194002
     C                   If        RetCode = -1                                               194002
     C                   exsr      tcperr                                                     194002
     C                   EndIf                                                                194002
     C                                                                                        194002
     C     *LOCK         IN        LDA                                                        194002
     C                   MOVEL     'INACTIVE'    DBFILE                                       194002
     C                   MOVEL     'REC4432'     DBKEY                                        194002
     C                   Z-ADD     22            DBASE                                        194002
     C                   exsr      dberr                                                      194002
     C                   exsr      *PSSR                                                      194002
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
      *
      **  Set up key list for nostro file SDNOSTL0.
      *
     C     KNOST         KLIST
     C                   KFLD                    WNSC              3
     C                   KFLD                    WNSN              2
      *                                                                   122060
      **  Set up key list for accounts file ACCNTL0.                      122060
      *                                                                   122060
     C     KACNT         KLIST                                                                 12206
     C**********         KFLD                    KCUST             6 0                  12206 CSD027
     C                   KFLD                    KCUST             6                          CSD027
     C                   KFLD                    KCCY              3                           12206
     C**********         KFLD                    KACOD             4 0                  12206 CGL029
     C                   KFLD                    KACOD                                        CGL029
     C                   KFLD                    KACSQ             2 0                         12206
     C                   KFLD                    KBRCD             3                           12206
      *                                                                   122060
      **  Set up key list for Drafs Incoming Msg REPDRIL1.                122060
      *                                                                   122060
     C     KLPDRI        KLIST                                                                 12206
     C                   KFLD                    KDRNO            16                           12206
     C                   KFLD                    KODRN            16                           12206
     C                   KFLD                    KACDE             3                           12206
      *                                                                                       CRT006
      ** Set up key list for Teller Transaction Details                                       CRT006
      *                                                                                       CRT006
     C     KTRNL1        KLIST                                                                CRT006
     C                   KFLD                    KBRI              1                          CRT006
     C                   KFLD                    KITLB             3                          CRT006
     C                   KFLD                    KBID              3                          CRT006
     C                   KFLD                    KTBTN             5 0                        CRT006
      *
      **  Clear DB ERROR information in LDA.
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANK        DBLOT
     C                   OUT       LDA
      *                                                                   118528
      **  Clear Trickle Feed Time Stamp.                                  118528
      *                                                                   118528
     C     *DTAARA       DEFINE                  CITFTS                                        11852
     C     *LOCK         IN        CITFTS                                                      11852
     C                   MOVEL     *BLANK        WNNSS                                         11852
     C                   OUT       CITFTS                                                      11852
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
      **  Define DTAARA/CISTAT.
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
      *                                                                                       197289
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
      *
      **  Parameters for QSNDDTAQ (To RBA).
      *
     C     DTQSND        PLIST
     C                   PARM                    DTAQS
     C                   PARM                    LIBS
     C                   PARM                    LENS
     C                   PARM                    MSGS
      *
      **  Parameters for QSNDDTAQ for Auto Reversal.                                          197289
      *                                                                                       197289
     C     DTQSNO        PLIST                                                                197289
     C                   PARM                    DTAQO                                        197289
     C                   PARM                    LIBO                                         197289
     C                   PARM                    LENO                                         197289
     C                   PARM                    MSGO                                         197289
      *                                                                                       CRT005
      **  Parameters for QSNDDTAQ for CSIV, CSOV, TLIN, and TLOU messages                     CRT005
      *                                                                                       CRT005
     C     DTQSNC        PLIST                                                                CRT005
     C                   PARM                    DTAQC                                        CRT005
     C                   PARM                    LIBC                                         CRT005
     C                   PARM                    LENC                                         CRT005
     C                   PARM                    MSGC                                         CRT005
      *                                                                                       197289
      **  Set up parameters for receive data queue (from RBA).
      *
     C                   MOVEL     WJOBID        DTAQR            10
     C                   MOVEL     '*LIBL'       LIBR             10
     C***********          Z-ADD1714      LENR    50                      122060
     C                   Z-ADD     2560          LENR              5 0                         12206
     C                   Z-ADD     -1            WAITR             5 0
      *
      **  Set up parameters for send data queue (to RBA).
      *
     C                   MOVEL     *BLANKS       DTAQS            10
     C                   MOVEL     '*LIBL'       LIBS             10
     C                   MOVEL     *BLANKS       LENS              5 0
      *
      **  Check if CRT104 if On.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CRT104'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CRT104            1
     C                   ELSE
     C                   MOVEL     'N'           CRT104
     C                   ENDIF
      *                                                                   CEU025
      ** Check if CEU025 is On.                                           CEU025
      *                                                                   CEU025
     C                   CALL      'AOSARDR0'                                                  CEU02
     C                   PARM      *BLANKS       @RTCD                                         CEU02
     C                   PARM      '*VERIFY'     @OPTN                                         CEU02
     C                   PARM      'CEU025'      @SARD                                         CEU02
     C     SCSARD        PARM      SCSARD        DSFDY                                         CEU02
      *                                                                   CEU025
      **  Report error.                                                   CEU025
     C     @RTCD         IFNE      *BLANKS                                                     CEU02
     C                   MOVEL     'N'           CEU025            1                           CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVEL     'Y'           CEU025                                        CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                                       CRT005
      ** Check if CRT005 is On                                                                CRT005
      *                                                                                       CRT005
     C                   CALL      'AOSARDR0'                                                 CRT005
     C                   PARM      *BLANKS       @RTCD                                        CRT005
     C                   PARM      '*VERIFY'     @OPTN                                        CRT005
     C                   PARM      'CRT005'      @SARD                                        CRT005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRT005
      *                                                                                       CRT005
      ** Process Database Error                                                               CRT005
      *                                                                                       CRT005
     C     @RTCD         IFNE      *BLANKS                                                    CRT005
     C     @RTCD         ANDNE     '*NRF   '                                                  CRT005
      *                                                                                       CRT005
      ** Report Error                                                                         CRT005
      *                                                                                       CRT005
     C                   MOVEL     'USR0091'     @MSGID                                       CRT005
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
     C                   PARM      'RE004501'    PROG             10                          CRT005
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
     C                   Z-ADD     30            DBASE                                        CRT005
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
     C                   PARM      'RE004501'    PROG             10
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
     C*********          WRITE     STATO
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
      *                                                                   175838
     C     CEU025        IFEQ      'Y'                                          B*1            17583
      *                                                                   175838
     C**********         CALL      'AOGELRR0'                                           17583 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*BLANK '     @RTCD             7                           17583
     C                   PARM      '*FIRST '     @OPTN             7                           17583
     C*****SDGELR        PARM      SDGELR        DSFDY                                  17583 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                   175838
      **  If error on access to General Ledger Details.                   175838
      *                                                                   175838
     C     @RTCD         IFNE      *BLANKS                                      B*2            17583
      *                                                                   175838
      **  Report error.                                                   175838
      *                                                                   175838
     C                   MOVEL     'USR0077'     @MSGID                                        17583
     C                   MOVEL     *BLANKS       WMDTA1                                        17583
     C                   MOVEL     *BLANKS       WMDTA2                                        17583
     C                   EXSR      RTVMSG                                                      17583
     C                   MOVEL     @MSGTX        O#HMSG                                        17583
     C                   MOVE      'E'           O#HMSS                                        17583
     C                   MOVE      @MSGID        O#HMSI                                        17583
      *                                                                   175838
     C                   CALL      'REC4411'                                                   17583
     C                   PARM      'RE004501'    PROG             10                           17583
     C                   PARM                    JOBNUM            6                           17583
     C                   PARM      '0000'        MMCODE            4                           17583
     C                   PARM      *BLANKS       P#BRCA            3                           17583
     C                   PARM                    @MSGID            7                           17583
     C                   PARM      *BLANKS       @MSGDT                                        17583
      *                                                                   175838
     C                   MOVE      'N'           WCSTAT                                        17583
     C                   MOVE      'CR'          WMSTAT                                        17583
     C                   EXSR      WRTLOG                                                      17583
      *                                                                   175838
     C*********          WRITE     STATO
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
      *                                                                   175838
      **  Set up LDA DBERR.                                               175838
      *                                                                   175838
     C     *LOCK         IN        LDA                                                         17583
     C                   MOVEL     'SDGELRPD'    DBFILE                                        17583
     C                   MOVEL     @OPTN         DBKEY                                         17583
     C                   Z-ADD     28            DBASE                                         17583
     C                   EXSR      DBERR                                                       17583
      *                                                                   175838
      **  Set Off Session Active Flag.                                    175838
      *                                                                   175838
     C                   MOVEL     'N'           WACTIV            1                           17583
      *                                                                   175838
     C                   EXSR      *PSSR                                                       17583
      *                                                                   175838
     C                   END                                                                   17583
      *                                                                   175838
     C                   END                                                                   17583
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
     C                   PARM      'RE004501'    PROG
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
     C*********          WRITE     STATO
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
     C*****KTTRNT********CHAIN     TTRNM2L1                           30                      194002
     C     KTTRNT        CHAIN (N) TTRNM2L1                           30                      194002
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
     C                   PARM      'RE004501'    PROG
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
      *                                                                                       CRT005
      ** Initialise TST array                                                                 CRT005
      *                                                                                       CRT005
     C                   CLEAR                   TST                                          CRT005
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
      ****Check*Authorised*Devices*If*Product*In*Cashier*ICD*not*'CASHIER*8'.*****            164273
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
      * Send COK message (Reply to COK received in listener)
     C                   movel     '00000000'    header
     C                   move      'COK'         header
     C                   clear                   Sbuffer
     C                   movel     header        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   EXSR      RBUNAK                                                     197289
      *                                                                                       197289
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  197289
      *****************************************************************                       197289
      *                                                               *                       197289
      *            RBUNAK - Re-start rollback.                        *                       197289
      *                                                               *                       197289
      * CALLS      WRTLOG - Write Communications Log.                 *                       197289
      *                                                               *                       197289
      * CALLED BY  INIT   - Initial Processing.                       *                       197289
      *                                                               *                       197289
      *****************************************************************                       197289
     C     RBUNAK        BEGSR                                                                197289
      *                                                                                       197289
      **  Access LF/REPLOGL0 to retrieve last record for this teller.                         197289
      *                                                                                       197289
     C                   MOVEL     brcae         @BRCA                                        197289
     C                   MOVEL     usid          @TELD                                        197289
     C                   MOVEL     usid          W#TELD                                       197289
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
     C                   MOVEL     RITELD        @RITELD                                      197289
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
     C                   MOVEL     'Y'           WOAREV            1                          197289
     C                   EXSR      WRTLOG                                                     197289
     C                   MOVEL     'N'           WOAREV                                       197289
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
     C                   Z-ADD     AMT1          WOAMT                                        197289
     C                   MOVE      'Y'           MSGO05                                       197289
      *                                                                                       197289
     C                   CALL      'QSNDDTAQ'    DTQSNO                                       197289
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
     C                   Z-ADD     AMT1          WOAMT                                        CRT005
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
      /EJECT
      *****************************************************************
      *                                                               *
      *            DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLS                                                         *
      *                                                               *
      * CALLED BY  INIT   - Initial Processing.                       *
      *                                                               *
      *****************************************************************
     C     DBERR         BEGSR
      *
     C                   MOVEL     PROG          DBPGM
     C                   OUT       LDA
     C                   DUMP
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
     C                   PARM      'RE4501'      PROG             10
     C                   PARM                    JOBNUM            6
     C                   PARM      '0000'        MMCODE            4
     C                   PARM      W#BRCA        P#BRCA            3
     C                   PARM                    @MSGID            7
     C                   PARM                    @MSGDT
      *                                                                                       194002
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
      *                                                                   CEU025
     C     @MSGID        IFNE      'USR0044'                                                   CEU02
     C     @MSGID        ANDNE     'USR0050'                                                   CEU02
     C     @MSGID        ANDNE     'USR0051'                                                   CEU02
     C     @MSGID        ANDNE     'USR0052'                                                   CEU02
      *
      **  Restore Branch Code and Teller details.
      *
     C                   MOVEL     @WBRCA        W#BRCA
     C                   MOVEL     @WTELD        W#TELD
      *
      **  Sign off teller from Teller Totals and Controls File.
      *
     C                   MOVEL     W#TELD        KTBID
     C                   MOVEL     '1'           KRCTP                                        197289
      *                                                                                       194002
     C     KTBID         IFNE      *BLANKS                                                    194002
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
     C                   PARM      'RE004501'    PROG
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
      *                                                                   CEU025
     C                   ENDIF                                                                 CEU02
      *                                                                                       194002
     C                   ENDIF                                                                194002
      *
      * Close Socket
     C                   eval      RetCode = Cls_Tcp( ScktNum )
     C                   DUMP
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P06    - Retrieve System Control Data Routine.     *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling.                  *
      *            RVFBDT - Retrieve First Business Dates.            *
      *            ZDATE2 - Convert day number to a date.             *
      *            ZFWDT  - Find nth working day from given date.     *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P06           BEGSR                                                  ** P06    **
      *
      **  Initialise fields.
      *
     C                   MOVEL     *BLANKS       ICDATD
     C                   MOVEL     *BLANKS       OCDATD
     C                   MOVEA     *BLANKS       BDY
     C                   MOVEL     FLDI1         ICDATD
      *
      **  Assign values.
      *
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
     C                   MOVEL     ICFBDT        OCFBDT
     C                   MOVEL     ICLBDT        OCLBDT
     C                   Z-ADD     24            OCPBLN
     C                   Z-ADD     10            OCXRTL
     C                   MOVEL     'Y'           OCLCLY
     C                   MOVEL     'N'           OCLCLN
     C**********         MOVEL     'N'           OCEACV                                       194002
     C                   MOVEL     'Y'           OCEACV                                       194002
     C                   MOVEL     'Y'           OCCQRF
     C                   MOVEL     'M'           OCHSID
     C                   MOVEL     *BLANKS       OCRTOF                                        12007
     C                   MOVEL     *BLANKS       OCCYOF                                        12007
     C*********************MOVEL*BLANKS   OCLCEC                    120072124248
     C                   MOVEL     *BLANKS       OCERSZ                                        CEU02
     C                   MOVEL     *BLANKS       OCAACN                                        CEU02
     C                   MOVEL     'N'           OCAACN                                        CEU02
     C                   MOVE      '13'          OCEANL                                       194002
     C                   MOVEL     X@MASK        OCEANE                                       194002
      *
     C                   MOVEL     BJLCCY        OCLCCY
      *                                                                   124248
     C** Find number of Decimal Places for Base Currency from Currency    124248
     C** File.                                                            124248
     C                   CALL      'AOCURRR0'                                                  12424
     C     RTNCDE        PARM      '*MSG  '      RTNCDE            7                           12424
     C                   PARM      '*KEY'        OPTION            7                           12424
     C                   PARM      BJLCCY        KEYF              3                           12424
     C     SDCURR        PARM      *BLANKS       DSSDY                                         12424
     C**                                                                  124248
     C     RTNCDE        IFNE      *BLANKS                                                     12424
      *                                                                   124248
      **  Report error.                                                   124248
      *                                                                   124248
     C                   MOVEL     'USR0047'     @MSGID                                        12424
     C                   MOVEL     *BLANKS       WMDTA1                                        12424
     C                   MOVEL     *BLANKS       WMDTA2                                        12424
     C                   EXSR      RTVMSG                                                      12424
     C                   MOVEL     @MSGTX        O#HMSG                                        12424
     C                   MOVE      'E'           O#HMSS                                        12424
     C                   MOVE      @MSGID        O#HMSI                                        12424
     C                   MOVE      'BANK'        O#MSTY                                        12424
     C                   MOVEL     W#BRCA        O#BRCA                                        12424
     C                   MOVEL     W#TELD        O#TELD                                        12424
      *                                                                   124248
     C                   CALL      'REC4411'                                                   12424
     C                   PARM      'RE004501'    PROG             10                           12424
     C                   PARM                    JOBNUM            6                           12424
     C                   PARM      '0000'        MMCODE            4                           12424
     C                   PARM      *BLANKS       P#BRCA            3                           12424
     C                   PARM                    @MSGID            7                           12424
     C                   PARM      *BLANKS       @MSGDT                                        12424
      *                                                                   124248
     C                   MOVE      'N'           WCSTAT                                        12424
     C                   MOVE      'CR'          WMSTAT                                        12424
     C                   EXSR      WRTLOG                                                      12424
      *                                                                   124248
     C*********          WRITE     STATO
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
      *                                                                   124248
      **  Set up LDA DBERR.                                               124248
      *                                                                   124248
     C     *LOCK         IN        LDA                                                         12424
     C                   MOVEL     'SDCURRPD'    DBFILE                                        12424
     C                   MOVEL     @OPTN         DBKEY                                         12424
     C                   Z-ADD     23            DBASE                                         12424
     C                   EXSR      DBERR                                                       12424
      *                                                                   124248
      **  Set Off Session Active Flag.                                    124248
      *                                                                   124248
     C                   MOVEL     'N'           WACTIV            1                           12424
      *                                                                   124248
     C                   EXSR      *PSSR                                                       12424
      *                                                                   124248
      **  Access to Currency File OK.                                     124248
      *                                                                   124248
     C                   ELSE                                                                  12424
     C                   MOVEL     A6NBDP        OCLCEC                                        12424
      *                                                                   124248
     C                   END                                                                   12424
      *
      **  Blank out base currency since this concerns Clean Payments in
      **  Equation.
      *
     C*                    MOVELBJCYCD    OCBCCY
     C                   MOVEL     *BLANKS       OCBCCY
     C                   MOVEL     *BLANKS       OCBRID
      *
      **  Assign date format.
      *
     C                   SELECT
      *
     C     BJDFIN        WHENEQ    'D'
     C                   MOVEL     'DMY'         OCDTFM
     C                   MOVEL     '0'           *IN98
     C                   MOVEL     'D'           ZDATFM
      *
     C     BJDFIN        WHENEQ    'M'
     C                   MOVEL     'MDY'         OCDTFM
     C                   MOVEL     '1'           *IN98
     C                   MOVEL     'M'           ZDATFM
      *
     C                   ENDSL
      *
      **  Check if Dealing Module is present.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0041'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      *BLANKS       P#BRCA
     C                   PARM                    @MSGID
     C                   PARM      *BLANKS       @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     4             DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
     C     WERROR        IFEQ      'N'
      *
     C     BGDLFX        IFEQ      'Y'
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*FIRST'      @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0042'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM      *BLANKS       @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     5             DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Assign separation characters.
      *
     C                   MOVEL     BNTHSP        OCINSC
     C                   MOVEL     BNDCSP        OCDCSC
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     ','           OCINSC
     C                   MOVEL     '.'           OCDCSC
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Calculate business dates backward.
      *
     C     WERROR        IFEQ      'N'
      *
     C                   MOVE      ICFBDT        NICFB             2 0
     C                   Z-ADD     NICFB         I
     C                   Z-ADD     BJRDNB        WDATE
     C                   MOVEL     OCLCCY        ZCCY
     C                   MOVEL     *BLANKS       ZLOC
      *
     C     I             DOWGE     1
      *
     C                   Z-ADD     1             ZNRDYS
     C                   Z-ADD     WDATE         ZDAYNO
     C                   Callb     'RVFBDT'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZNRDYS            2 0
     C                   Parm                    ZDYNBR            5 0
     C                   Parm                    ZCCY              3
     C                   Parm                    ZLOC              3
     C                   Z-ADD     ZDYNBR        WDATE
      *
     C                   Z-ADD     WDATE         ZDAYNO
     C                   Callb     'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZDATFM
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
     C     *IN98         IFEQ      '0'
     C                   MOVE      ZDATE         BDY(I)
     C                   ENDIF
      *
     C                   SUB       1             I
      *
     C                   ENDDO
      *
      **  Format rundate.
      *
     C     NICFB         ADD       1             I
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Callb     'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZDATFM            1
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
     C     *IN98         IFEQ      '0'
     C                   MOVE      ZDATE         BDY(I)
     C                   ENDIF
      *
      **  Calculate business dates forward.
      *
     C                   MOVE      ICLBDT        NICLB             2 0
     C     I             ADD       1             J                 2 0
     C                   Z-ADD     1             I                 2 0
     C                   Z-ADD     BJRDNB        WDATE             5 0
     C                   MOVEL     OCLCCY        ZCCY
     C                   MOVEL     *BLANKS       ZLOC
      *
     C     I             DOWLE     NICLB
      *
     C                   Z-ADD     1             ZNRDYS
     C                   Z-ADD     WDATE         ZDAYNO
     C                   Callb     'ZFWDT'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZNRDYS            2 0
     C                   Parm                    ZDYNBR            5 0
     C                   Parm                    ZCCY              3
     C                   Parm                    ZLOC              3
     C                   Z-ADD     ZDYNBR        WDATE
      *
     C                   Z-ADD     WDATE         ZDAYNO
     C                   Callb     'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    ZDATFM            1
     C                   Parm                    ZDATE             6 0
     C                   Parm                    ZADATE            7
     C     *IN98         IFEQ      '0'
     C                   MOVE      ZDATE         BDY(J)
     C                   ENDIF
      *
     C                   ADD       1             I
     C                   ADD       1             J
      *
     C                   ENDDO
      *
      **  Assign business dates to outgoing message.
      *
     C                   MOVEA     BDY(1)        OCBSD1
     C                   MOVEA     BDY(43)       OCBSD2
     C                   MOVEA     BDY(85)       OCBSD3
     C                   MOVEA     BDY(127)      OCBSD4
     C                   MOVEA     BDY(169)      OCBSD5
      *
      **  Retrieve branch name.
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*BLANK '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      W#BRCA        @KEY2             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
      *
     C                   MOVEL     'Y'           WERROR
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
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     6             DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
     C                   MOVEL     A8BRNM        OCBRNM
      *
      **  Retrieve customer addresses.
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A8BICN        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0043'     @MSGID
     C                   MOVEL     A8BICN        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     7             DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Customer addresses.
      *
     C                   MOVEL     BBCNA1        OCBRA1
     C                   MOVEL     BBCNA2        OCBRA2
     C                   MOVEL     BBCNA3        OCBRA3
     C                   MOVEL     BBCNA4        OCBRA4
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Check if CRT301 is On.  (Cashier has local database.)
      *
     C     WERROR        IFEQ      'N'
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CRT301'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           OCLDBF
     C                   ELSE
     C                   MOVEL     'Y'           OCLDBF
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Perform implicit sign on for CDAT.
      *
     C***********WERROR    IFEQ 'N'                                       164275
      *
     C***********          MOVELW#TELD    KTBID                           164275
     C***********KTTRNT    CHAINTTRNM2L1             30                   164275
      *
     C************IN30     IFEQ *ON                                       164275
     C***********RECI      ORNE 'D'                                       164275
      *
     C***********          MOVEL'Y'       WERROR                          164275
      *
      **  Retrieve error message data to send in host message.
      *
     C***********          MOVEL'USR0013' @MSGID                          164275
     C***********          MOVELW#TELD    WMDTA1                          164275
     C***********          MOVEL*BLANKS   WMDTA2                          164275
     C***********WMDTA1    CAT  WMDTA2    @MSGDT                          164275
     C***********          EXSR RTVMSG                                    164275
     C***********          MOVEL@MSGTX    O#HMSG                          164275
     C***********          MOVE 'E'       O#HMSS                          164275
     C***********          MOVE @MSGID    O#HMSI                          164275
      *
      **  Report error.
      *
     C***********          CALL 'REC4411'                                 164275
     C***********          PARM 'RE4401'  PROG                            164275
     C***********          PARM           JOBNUM                          164275
     C***********          PARM '0000'    MMCODE                          164275
     C***********          PARM W#BRCA    P#BRCA                          164275
     C***********          PARM           @MSGID                          164275
     C***********          PARM           @MSGDT                          164275
      *
     C***********          MOVEL*BLANKS   @WRK4                           164275
     C***********          MOVEL*BLANKS   @WRK5                           164275
     C***********KTBRI     CAT  KTBID     @WRK4                           164275
     C***********@WRK4     CAT  KRCTP     @WRK5                           164275
      *
     C************LOCK     IN   LDA                                       164275
     C***********          MOVEL'TTRNM2L1'DBFILE                          164275
     C***********          MOVEL@WRK5     DBKEY                           164275
     C***********          Z-ADD16        DBASE                           164275
     C***********          EXSR DBERR                                     164275
      *
     C***********          MOVE 'N'       WCSTAT  1                       164275
     C***********          MOVE 'CS'      WMSTAT  2                       164275
     C***********          EXSR WRTLOG                                    164275
      *
     C***********          WRITESTATO                  22                 164275
      *
      **  Set Off Session Active Flag.
      *
     C***********          MOVEL'N'       WACTIV                          164275
      *
     C***********          ELSE                                           164275
      *
     C***********TWID      IFNE *BLANKS                                   164275
      *
     C***********          MOVEL'Y'       WERROR                          164275
      *
      **  Retrieve error message data to send in host message.
      *
     C***********          MOVEL'USR0015' @MSGID                          164275
     C***********          MOVELW#TELD    WMDTA1                          164275
     C***********          MOVELTWID      WMDTA2                          164275
     C***********WMDTA1    CAT  WMDTA2    @MSGDT                          164275
     C***********          EXSR RTVMSG                                    164275
     C***********          MOVEL@MSGTX    O#HMSG                          164275
     C***********          MOVE 'E'       O#HMSS                          164275
     C***********          MOVE @MSGID    O#HMSI                          164275
      *
      **  Report error.
      *
     C***********          CALL 'REC4411'                                 164275
     C***********          PARM 'RE4401'  PROG                            164275
     C***********          PARM           JOBNUM                          164275
     C***********          PARM '0000'    MMCODE                          164275
     C***********          PARM W#BRCA    P#BRCA                          164275
     C***********          PARM           @MSGID                          164275
     C***********          PARM           @MSGDT                          164275
      *
     C***********          MOVEL*BLANKS   @WRK4                           164275
     C***********          MOVEL*BLANKS   @WRK5                           164275
     C***********KTBRI     CAT  KTBID     @WRK4                           164275
     C***********@WRK4     CAT  KRCTP     @WRK5                           164275
      *
     C************LOCK     IN   LDA                                       164275
     C***********          MOVEL'TTRNM2L1'DBFILE                          164275
     C***********          MOVEL@WRK5     DBKEY                           164275
     C***********          Z-ADD18        DBASE                           164275
     C***********          EXSR DBERR                                     164275
      *
     C***********          MOVE 'N'       WCSTAT  1                       164275
     C***********          MOVE 'CS'      WMSTAT  2                       164275
     C***********          EXSR WRTLOG                                    164275
      *
     C***********          WRITESTATO                  22                 164275
      *
      **  Set Off Session Active Flag.
      *
     C***********          MOVEL'N'       WACTIV                          164275
      *
     C***********          ELSE                                           164275
      *
     C***********TST,A     IFNE ' ON'                                     164275
      *
      **  Update workstation id.
      *
     C***********'CASH'    CAT  JOBNUM    TWID                            164275
     C***********          UPDATTTRNTM2F                                  164275
      *
      **  Set teller status flag on.
      *
     C***********          MOVEL' ON'     TST,A                           164275
      *
     C***********          ENDIF                                          164275
      *
     C***********          ENDIF                                          164275
      *
     C***********          ENDIF                                          164275
      *
     C***********          ENDIF                                          164275
      *                                                                                       176563
      ** Flag for retrieval of account                                                        176563
      *                                                                                       176563
     C                   MOVE      'Y'           OCTMPF            1                          176563
      *
      **  Write Data Comms File.
      *
     C     WERROR        IFEQ      'N'
      *
     C                   MOVEL     'USR0016'     @MSGID
     C                   MOVEL     *BLANKS       WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        OCDAT
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     CDATO                                22
      *
      * Send CDAT message
     C                   movel     '00001863'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OCDATD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P07    - Retrieve System Parameter Codes Routine.  *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P07           BEGSR                                                  ** P07    **
      *
      **  Assign initial values.
      *
     C                   MOVEL     *BLANKS       ISPDT1
     C                   MOVEL     *BLANKS       ISPDT2
     C                   MOVEL     *BLANKS       OSPDT1
     C                   MOVEL     *BLANKS       OSPDT2
     C                   MOVEL     *BLANKS       OSPDT3
     C                   MOVEL     *BLANKS       OSPDT4
     C                   MOVEL     *BLANKS       OSPDT5
     C                   MOVEL     *BLANKS       OSPDT6
     C                   MOVEL     *BLANKS       OSPDT7
     C                   MOVEA     *BLANKS       ASP
     C                   MOVEA     *BLANKS       AOS
      *
     C                   MOVEL     FLDI1         ISPDT1
     C                   MOVEL     FLDI2         ISPDT2
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
     C                   MOVEL     '+00'         OPOFDL
     C                   MOVEL     '+00'         OPOFDF
     C                   MOVEL     '+00'         OPOFCL
     C                   MOVEL     '+00'         OPOFCF
     C                   MOVEL     '401'         OPDRTC
     C                   MOVEL     '901'         OPCRTC
      *
     C                   MOVEA     IPSPP1        ASP(1)
     C                   MOVEA     IPSPP2        ASP(52)
      *
     C                   Z-ADD     1             I
     C                   Z-ADD     1             J                 2 0
      *
      **  While array of SP codes still has contents (up to 60 elements).
      *
     C     I             DOWLE     60
     C     ASP(I)        ANDNE     *BLANK
      *
     C                   CALL      'AOBAITR0'
     C                   PARM      '*BLANK'      @RTCD             7
     C                   PARM      '*KEY  '      @OPTN             7
     C                   PARM      ASP(I)        @KEY1            10
     C                   PARM      '*BLANKS'     @KEY3             7
     C     SDBAIT        PARM      SDBAIT        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0008'     @MSGID
     C                   MOVEL     ASP(I)        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C************       PARM      MAJMIN        MMCODE
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBAITPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     8             DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   MOVE      *BLANKS       W#TXP
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Transfer array contents to outgoing message.
      *
     C                   MOVEL     ASP(I)        OPSPPM
     C                   MOVEL     OSPDTB        AOS(J)
     C                   ADD       1             J
      *
     C                   ENDIF
      *
     C                   ADD       1             I
      *
     C                   ENDDO
      *
     C     WERROR        IFEQ      'N'
      *
     C                   MOVEA     AOS(1)        OSPDT2
     C                   MOVEA     AOS(12)       OSPDT3
     C                   MOVEA     AOS(23)       OSPDT4
     C                   MOVEA     AOS(34)       OSPDT5
     C                   MOVEA     AOS(45)       OSPDT6
     C                   MOVEA     AOS(56)       OSPDT7
      *
      **  Write Data Comms File.
      *
     C     I             IFGT      1
     C     I             SUB       1             K                 2 0
     C                   ELSE
     C                   Z-ADD     1             K
     C                   ENDIF
      *
     C                   MOVEL     'USR0017'     @MSGID
     C                   MOVEL     ASP(1)        WMDTA1
     C                   MOVEL     ASP(K)        WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVE      *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        OSPDT1
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     SPDTO                                22
      *
      * Send SPDT message
     C                   movel     '00001493'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OSPDTD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P08    - Retrieve Exchange Rates Information.      *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling.                  *
      *            ZEDIT  - Insert decimal point and 0s for numeric.  *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P08           BEGSR                                                  ** P08    **
      *
      **  Initialise fields.
      *
     C                   MOVEL     *BLANKS       IBSER
     C                   MOVEL     *BLANKS       OBSERD
     C***********          MOVEA*BLANKS   ACY                             CEU025
     C                   MOVEA     *BLANKS       AC1                                           CEU02
     C                   MOVEA     *BLANKS       AC2                                           CEU02
      *
     C                   Z-ADD     1             I
      *
     C                   MOVEL     FLDI1         IBSER
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
      **  At the start, no currencies have yet been loaded, set
      **  pointer to the beginning of the file.
      *
     C     IXCCY         IFEQ      '***'
     C     *LOVAL        SETLL     SDCURRL0
     C                   ELSE
      *
      **  Otherwise, some currencies have already been loaded, IXCCY
      **  contains the last CCY loaded, set pointer to that position,
      **  then read next record.
      *
     C     IXCCY         CHAIN     SDCURRL0                           42
     C*          FXCCY     CHAINSDCURRL0             42
     C                   ENDIF
      *
     C                   READ      SDCURRL0                               42
      *
      **  Assign values.
      *
     C     *IN42         DOWEQ     '0'
     C     I             ANDLE     10
      *
     C                   Z-ADD     A6SMLD        WSMLD             5 0
      *
      **  Smallest denomination to have decimal point.
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      WSMLD         ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   MOVE      ZFIELD        WMNDN             8
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     WMNDN         WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       WMNDN
     C                   MOVEA     RATE(1)       WMNDN
      *
      **  Assign appropriate values.
      *
     C***********          MOVEL*BLANKS   OBSCYB                          CEU025
     C                   MOVEL     *BLANKS       OXOXS1                                        CEU02
     C                   MOVEL     *BLANKS       OXOXS2                                        CEU02
     C                   MOVEL     A6CYCD        OXCCY
     C                   MOVEL     A6CYNM        OXCCYD
     C                   MOVEL     A6NBDP        OXCCYE
     C                   MOVE      WMNDN         OXMNBC
     C                   MOVE      WMNDN         OXMNBT
     C                   MOVE      WMNDN         OXMNSC
     C                   MOVE      WMNDN         OXMNST
     C     A6MDIN        IFEQ      'M'
     C                   MOVEL     'Y'           OXRCRT
     C                   ELSE
     C                   MOVEL     'N'           OXRCRT
     C                   END
     C     A6CYCD        IFEQ      BJCYCD
     C                   MOVEL     'N'           OXRCRT
     C                   END
     C                   MOVEL     A6ISON        OXCCYN
     C                   MOVE      '00.000'      OXCMBC
     C                   MOVE      '00.000'      OXCMBT
     C                   MOVE      '00.000'      OXCMSC
     C                   MOVE      '00.000'      OXCMST
      *
      **  If CRT104 is on, retrieve rates from PF/REBDCRPD.
      *
     C     CRT104        IFEQ      'Y'
      *
     C     A6CYCD        CHAIN     REBDCRPD                           43
      *
     C     *IN43         IFEQ      '1'
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0045'     @MSGID
     C                   MOVEL     A6CYCD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      *BLANKS       P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'REBDCRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     9             DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Edit rates to include decimal points before assigning to output msg.
      *
     C                   MOVEL     *ZEROS        OXXRBC
     C                   Z-ADD     *ZEROS        W#RT             13 8
     C                   MOVEL     *BLANKS       ZFIELD
     C     FEVNRT        DIV       FEAMNT        W#RT
     C                   MOVE      W#RT          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      OXXRBC
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     OXXRBC        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       OXXRBC
     C                   MOVEA     RATE(1)       OXXRBC
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OXEXBC                                        CEU02
     C                   MOVEA     RATE(1)       OXEXBC                                        CEU02
      *
     C                   MOVEL     *ZEROS        OXXRSC
     C                   Z-ADD     *ZEROS        W#RT
     C                   MOVEL     *BLANKS       ZFIELD
     C     FEVPRT        DIV       FEAMNT        W#RT
     C                   MOVE      W#RT          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      OXXRSC
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     OXXRSC        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       OXXRSC
     C                   MOVEA     RATE(1)       OXXRSC
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OXEXSC                                        CEU02
     C                   MOVEA     RATE(1)       OXEXSC                                        CEU02
      *
     C                   MOVEL     *ZEROS        OXXRBT
     C                   Z-ADD     *ZEROS        W#RT
     C                   MOVEL     *BLANKS       ZFIELD
     C     FEDNRT        DIV       FEAMNT        W#RT
     C                   MOVE      W#RT          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      OXXRBT
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     OXXRBT        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       OXXRBT
     C                   MOVEA     RATE(1)       OXXRBT
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OXEXBT                                        CEU02
     C                   MOVEA     RATE(1)       OXEXBT                                        CEU02
      *
     C                   MOVEL     *ZEROS        OXXRST
     C                   Z-ADD     *ZEROS        W#RT
     C                   MOVEL     *BLANKS       ZFIELD
     C     FEDPRT        DIV       FEAMNT        W#RT
     C                   MOVE      W#RT          ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      OXXRST
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     OXXRST        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       OXXRST
     C                   MOVEA     RATE(1)       OXXRST
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OXEXST                                        CEU02
     C                   MOVEA     RATE(1)       OXEXST                                        CEU02
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     *ZEROS        OXXRBC
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      A6SPRT        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      OXXRBC
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     OXXRBC        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       OXXRBC
     C                   MOVEA     RATE(1)       OXXRBC
     C                   MOVEL     OXXRBC        OXXRBT
     C                   MOVEL     OXXRBC        OXXRSC
     C                   MOVEL     OXXRBC        OXXRST
      *
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       OXEXSR                                        CEU02
     C                   MOVEL     *BLANKS       OXEXUR                                        CEU02
      *                                                                   CEU025
     C     CEU025        IFEQ      'Y'                                                         CEU02
      *                                                                   CEU025
     C     A6INCY        IFEQ      'Y'                                                         CEU02
     C     BJRDNB        ANDGE     A6TPSD                                                      17583
     C*****BJRDNB*****   ANDLE     A6TPED                                              175838 199373
     C                   MOVEL     'Y'           OXMBFL                                        CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVEL     'N'           OXMBFL                                        CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU025
     C                   ELSE                                                                  CEU02
     C                   MOVEL     'N'           OXMBFL                                        CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU025
     C***********          MOVELOBSCYB    ACY,I                           CEU025
     C                   MOVEL     OXOXS1        AC1(I)                                        CEU02
     C                   MOVEL     OXOXS2        AC2(I)                                        CEU02
      *
     C                   ADD       1             I
      *
     C                   READ      SDCURRL0                               42
      *
     C                   ENDDO
      *
      **  EOF encountered before 10 elements have been filled up.
      *
     C     WERROR        IFEQ      'N'
      *
     C     *IN42         IFEQ      '1'
     C     I             ANDLE     10
      *
      **  Move '***' to last CCY block when EOF reached.
      *
     C***********          MOVEL*BLANK    OBSCYB                          CEU025
     C                   MOVEL     *BLANKS       OXOXS1                                        CEU02
     C                   MOVEL     *BLANKS       OXOXS2                                        CEU02
     C                   MOVEL     '***'         OXCCY
     C***********          MOVELOBSCYB    ACY,I                           CEU025
     C                   MOVEL     OXOXS1        AC1(I)                                        CEU02
     C                   MOVEL     OXOXS2        AC2(I)                                        CEU02
      *
     C                   ENDIF
      *
      **  Move array contents to outgoing message.
      *
     C***********          MOVELACY,1     OXCB01                          CEU025
     C***********          MOVELACY,2     OXCB02                          CEU025
     C***********          MOVELACY,3     OXCB03                          CEU025
     C***********          MOVELACY,4     OXCB04                          CEU025
     C***********          MOVELACY,5     OXCB05                          CEU025
     C***********          MOVELACY,6     OXCB06                          CEU025
     C***********          MOVELACY,7     OXCB07                          CEU025
     C***********          MOVELACY,8     OXCB08                          CEU025
     C***********          MOVELACY,9     OXCB09                          CEU025
     C***********          MOVELACY,10    OXCB10                          CEU025
     C                   MOVEL     AC1(1)        OXC01A                                        CEU02
     C                   MOVEL     AC2(1)        OXC01B                                        CEU02
     C                   MOVEL     AC1(2)        OXC02A                                        CEU02
     C                   MOVEL     AC2(2)        OXC02B                                        CEU02
     C                   MOVEL     AC1(3)        OXC03A                                        CEU02
     C                   MOVEL     AC2(3)        OXC03B                                        CEU02
     C                   MOVEL     AC1(4)        OXC04A                                        CEU02
     C                   MOVEL     AC2(4)        OXC04B                                        CEU02
     C                   MOVEL     AC1(5)        OXC05A                                        CEU02
     C                   MOVEL     AC2(5)        OXC05B                                        CEU02
     C                   MOVEL     AC1(6)        OXC06A                                        CEU02
     C                   MOVEL     AC2(6)        OXC06B                                        CEU02
     C                   MOVEL     AC1(7)        OXC07A                                        CEU02
     C                   MOVEL     AC2(7)        OXC07B                                        CEU02
     C                   MOVEL     AC1(8)        OXC08A                                        CEU02
     C                   MOVEL     AC2(8)        OXC08B                                        CEU02
     C                   MOVEL     AC1(9)        OXC09A                                        CEU02
     C                   MOVEL     AC2(9)        OXC09B                                        CEU02
     C                   MOVEL     AC1(10)       OXC10A                                        CEU02
     C                   MOVEL     AC2(10)       OXC10B                                        CEU02
      *
      **  Write Data Comms File.
      *
     C     I             IFGT      1
     C     I             SUB       1             K
     C                   ELSE
     C                   Z-ADD     1             K
     C                   ENDIF
     C***********          MOVELACY,1     @CCY1   3                       CEU025
     C***********          MOVELACY,K     @CCY2   3                       CEU025
     C                   MOVEL     AC1(1)        @CCY1             3                           CEU02
     C                   MOVEL     AC1(K)        @CCY2             3                           CEU02
      *
     C                   MOVEL     'USR0018'     @MSGID
     C                   MOVEL     @CCY1         WMDTA1
     C                   MOVEL     @CCY2         WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        OBSER
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     BSERO                                22
      *
      * Send BSER message
     C                   movel     '00003123'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OBSERD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P09    - Retrieve Nostro Account Details Routine.  *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P09           BEGSR                                                  ** P09    **
      *
     C                   MOVEL     *BLANKS       INOST
     C                   MOVEL     *BLANKS       ONOSTD
     C                   MOVEA     *BLANKS       AN1
     C                   MOVEA     *BLANKS       AN2
      *
     C                   MOVEL     FLDI1         INOST
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
     C                   MOVEL     *BLANK        ONACSF
      *
      **  At the start, when no nostro details have been set up, set
      **  to the beginning of file.
      *
     C     INCCY         IFEQ      '***'
     C     *LOVAL        SETLL     SDNOSTL0
     C                   ELSE
      *
      **  Otherwise, INNSNM contains the last nostro loaded, so position
      **  the file pointer and read the record following.
      *
     C     3             SUBST     INNSNM:1      WNSC
     C     2             SUBST     INNSNM:4      WNSN
     C     KNOST         CHAIN     SDNOSTL0                           44
     C                   ENDIF
      *
     C                   READ      SDNOSTL0                               44
      *
     C                   Z-ADD     1             I
      *
      **  While not EOF and nostro details to be sent at a time has a max of 4.
      *
     C     *IN44         DOWEQ     '0'
     C     I             ANDLE     4
      *
     C                   MOVEL     A7CUST        KCUST                                         12206
     C                   MOVEL     A7CYCD        KCCY                                          12206
     C                   MOVEL     A7ACCD        KACOD                                         12206
     C                   Z-ADD     A7ACSN        KACSQ                                         12206
     C                   MOVEL     A7BRCD        KBRCD                                         12206
      *                                                                   122060
     C     KACNT         CHAIN     ACCNTL0                            31                       12206
      *                                                                   122060
     C     *IN31         IFEQ      '0'                                                         12206
     C     ATYP          ANDEQ     'R'                                                         12206
      *                                                                   122060
     C                   MOVEL     A7CYCD        ONCCY
     C*                    MOVELA7NOSN    ONNSNM
     C     A7CYCD        CAT       A7NONB        ONNSNM
     C                   MOVEL     A7BRCD        ONACBR
     C                   MOVEL     A7CUST        ONACCN
     C***********          MOVELA7ACSN    WACSN   2                       122060
     C***********A7CUST    CAT  A7CYCD    WORK9   9                       122060
     C***********A7ACCD    CAT  WACSN     WORK6   6                       122060
     C***********WORK9     CAT  WORK6     WORK15 15                       122060
     C***********A7BRCD    CAT  WORK15    ONEXAC                          122060
     C                   MOVEL     ACNO          WRK10            10                           12206
     C     A7BRCD        CAT       WRK10         ONEXAC                                        12206
      *
      **  Retrieve customer details.
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      A7CUST        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0043'     @MSGID
     C                   MOVEL     A7CUST        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     11            DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Assign nostro description and addresses.
      *
     C     BBCRNM        CAT       BBCRTN        ONNSDC
     C                   MOVEL     BBCNA1        ONNSA1
     C                   MOVEL     BBCNA2        ONNSA2
     C                   MOVEL     BBCNA3        ONNSA3
     C                   MOVEL     BBCNA4        ONNSA4
      *
     C                   ENDIF
      *
      **  Load details to array.
      *
     C                   MOVEL     ONONS1        AN1(I)
     C                   MOVEL     ONONS2        AN2(I)
      *
     C                   ADD       1             I
      *                                                                   122060
     C                   ENDIF                                                                 12206
      *
     C                   READ      SDNOSTL0                               44
      *
     C                   ENDDO
      *
      **  EOF encountered before 4 nostro details have been loaded.
      *
     C     WERROR        IFEQ      'N'
      *
     C     *IN44         IFEQ      '1'
     C     I             ANDLT     4
      *
     C                   MOVEL     *BLANKS       ONONSB
     C                   MOVEL     '***'         ONCCY
     C                   MOVEL     ONONS1        AN1(I)
     C                   MOVEL     ONONS2        AN2(I)
      *
     C                   ENDIF
      *
      **  Move nostro contents to outgoing message.
      *
     C                   MOVEA     AN1(1)        ONNB1A
     C                   MOVEA     AN2(1)        ONNB1B
     C                   MOVEA     AN1(2)        ONNB2A
     C                   MOVEA     AN2(2)        ONNB2B
     C                   MOVEA     AN1(3)        ONNB3A
     C                   MOVEA     AN2(3)        ONNB3B
     C                   MOVEA     AN1(4)        ONNB4A
     C                   MOVEA     AN2(4)        ONNB4B
      *
      **  Write Data Comms File.
      *
     C     I             IFGT      1
     C     I             SUB       1             K
     C     5             SUBST     AN1(1):4      @NOS1             5
     C     5             SUBST     AN1(K):4      @NOS2             5
     C                   ELSE
     C                   Z-ADD     1             K
     C                   MOVEL     AN1(1)        @NOS1
     C                   MOVEL     AN1(K)        @NOS2
     C                   ENDIF
      *
     C                   MOVEL     'USR0019'     @MSGID
     C                   MOVEL     @NOS1         WMDTA1
     C                   MOVEL     @NOS2         WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        ONOST
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     NOSTO                                22
      *
      * Send NOST message
     C                   movel     '00001841'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       ONOSTD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P10    - Retrieve Branch Details Routine.          *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P10           BEGSR                                                  ** P10    **
      *
      **  Initialise fields.
      *
     C                   MOVEL     *BLANKS       IMIDB
     C                   MOVEL     *BLANKS       OMIDB1
     C                   MOVEL     *BLANKS       OMIDB2
     C                   MOVEL     *BLANKS       OMIDB3
     C                   MOVEL     *BLANKS       OMIDB4
     C                   MOVEL     *BLANKS       OMIDB5
     C                   MOVEL     *BLANKS       OMIDB6
     C                   MOVEL     *BLANKS       OMIDB7
     C                   MOVEL     *BLANKS       OMIDB8
     C                   MOVEL     *BLANKS       OMIDB9
     C                   MOVEL     *BLANKS       OMID10
     C                   MOVEA     *BLANKS       ABR
      *
     C                   MOVEL     FLDI1         IMIDB
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
      **  At the start, when no branch details have been loaded, set
      **  pointer to beginning of file.
      *
     C     IBBRCH        IFEQ      '***'
     C     *LOVAL        SETLL     SDBRCHL0
     C                   ELSE
      *
      **  Otherwise, IBBRCH contains the branch loaded last, so set
      **  pointer then load next record.
      *
     C     IBBRCH        CHAIN     SDBRCHL0                           45
     C                   ENDIF
      *
     C                   READ      SDBRCHL0                               45
      *
     C                   Z-ADD     1             I
      *
      **  Load branch details. 50 is the max that can be sent at a time.
      *
     C     *IN45         DOWEQ     '0'
     C     I             ANDLE     50
      *
     C                   MOVEL     A8BRCD        OBBRCH
     C                   MOVEL     A8BRNM        OBBRNM
     C                   MOVEL     A8BICN        OBINCN
      *
     C                   MOVEL     OBBRBK        ABR(I)
      *
     C                   ADD       1             I
      *
     C                   READ      SDBRCHL0                               45
      *
     C                   ENDDO
      *
      **  EOF reached before 50 have been loaded.
      *
     C     *IN45         IFEQ      '1'
     C     I             ANDLT     50
      *
     C                   MOVEL     *BLANKS       OBBRBK
     C                   MOVEL     '***'         OBBRCH
      *
     C                   MOVEL     OBBRBK        ABR(I)
      *
     C                   ENDIF
      *
      **  Load array contents to outgoing message.
      *
     C                   MOVEA     ABR(1)        OMIDB2
     C                   MOVEA     ABR(7)        OMIDB3
     C                   MOVEA     ABR(13)       OMIDB4
     C                   MOVEA     ABR(19)       OMIDB5
     C                   MOVEA     ABR(25)       OMIDB6
     C                   MOVEA     ABR(31)       OMIDB7
     C                   MOVEA     ABR(37)       OMIDB8
     C                   MOVEA     ABR(43)       OMIDB9
     C                   MOVEA     ABR(49)       OMID10
      *
     C     I             IFGT      1
     C     I             SUB       1             K
     C                   ELSE
     C                   Z-ADD     1             K
     C                   ENDIF
     C                   MOVEL     ABR(1)        @BRC1             3
     C                   MOVEL     ABR(K)        @BRC2             3
      *
     C                   MOVEL     'USR0020'     @MSGID
     C                   MOVEL     @BRC1         WMDTA1
     C                   MOVEL     @BRC2         WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C                   MOVEL     OSTATD        OMIDB1
      *
      **  Write Data Comms File.
      *
     C*********          WRITE     MIDBO                                22
      *
      * Send MIDB message
     C                   movel     '00002063'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OMIDBD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P11    - Branch Open Routine.                      *
      *                                                               *
      * CALLS      DBERR  - Database Error Handling.                  *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P11           BEGSR                                                  ** P11    **
      *
     C                   MOVEL     *BLANKS       IBROP
     C                   MOVEL     *BLANKS       OBROP
      *
     C                   MOVEL     FLDI1         IBROP
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
      **  Update branch status to open.
      *
     C     W#BRCA        CHAIN     SDBRCHL0                           45
      *
      **  If no record found.
      *
     C     *IN45         IFEQ      '1'
      *
     C                   MOVEL     'Y'           WERROR
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
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     12            DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
     C     A8BRST        IFEQ      'O'
     C                   UNLOCK    SDBRCHL0
      *
     C                   MOVEL     'USR0046'     @MSGID
     C                   MOVEL     W#BRCA        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'W'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
     C                   MOVEL     OSTATD        OBROP
      *
     C                   ELSE
      *
     C                   MOVE      'O'           A8BRST
     C                   UPDATE    @A8REB1                              45
      *
     C                   MOVEL     'USR0061'     @MSGID
     C                   MOVEL     W#BRCA        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        OBROP
      *
     C                   END
      *
      **  Write Data Comms File.
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     BROPO                                22
      *
      * Send BROP message
     C                   movel     '00000113'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OBROPD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P12    - Branch Close Routine.                     *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P12           BEGSR                                                  ** P12    **
      *
     C                   MOVEL     *BLANKS       IBRCL
     C                   MOVEL     *BLANKS       OBRCL
      *
     C                   MOVEL     FLDI1         IBRCL
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
     C     W#BRCA        CHAIN     TTRNM2L2                           46
      *
      **  Tellers are still signed on to the system.
      *
     C     *IN46         IFEQ      '1'
      *
     C                   MOVEL     'Y'           WERROR
      *
     C                   MOVEL     'USR0011'     @MSGID
     C                   MOVEL     TBID          WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Update branch status to closed.
      *
     C     W#BRCA        CHAIN     SDBRCHL0                           45
      *
     C     *IN45         IFEQ      '1'
      *
     C                   MOVEL     'Y'           WERROR
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
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     13            DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
     C                   MOVE      'C'           A8BRST
     C                   UPDATE    @A8REB1
     C                   ENDIF
      *
     C                   MOVEL     'USR0062'     @MSGID
     C                   MOVEL     W#BRCA        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        OBRCL
      *
     C                   MOVEL     'Y'           WCSTAT
     C                   MOVEL     'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
      **  Write Data Comms File.
      *
     C*********          WRITE     BRCLO                                22
      *
      * Send BRCL message
     C                   movel     '00000113'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OBRCLD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P13    - Sign-Off Routine.                         *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P13           BEGSR                                                  ** P13    **
      *
     C                   MOVEL     *BLANKS       IKSOF
     C                   MOVEL     *BLANKS       OKSOF
      *
     C                   MOVEL     FLDI1         IKSOF
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
     C                   MOVEL     W#TELD        KTBID
     C                   MOVEL     '1'           KRCTP                                        197289
     C     KTTRNT        CHAIN     TTRNM2L1                           30
      *
     C     *IN30         IFEQ      *ON
     C     RECI          ORNE      'D'
      *
     C                   MOVEL     'Y'           WERROR
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
     C                   PARM      'RE004501'    PROG
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
     C                   Z-ADD     14            DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   ELSE
      *
     C     TST(A)        IFEQ      'OFF'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0006'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'W'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   ELSE
      *
      **  Update workstation id.
      *
     C                   MOVE      *BLANKS       TWID
     C                   UPDATE    TTRNTM2F
      *
      **  Set teller status flag off.
      *
     C                   MOVEL     'OFF'         TST(A)
      *
     C                   MOVEL     'USR0063'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     W#BRCA        WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
      *
     C                   ENDIF
      *
     C                   MOVE      'Y'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C                   MOVEL     OSTATD        OKSOF
     C*********          WRITE     KSOFO                                22
      *
      * Send KSOF message
     C                   movel     '00000113'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OKSOFD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P14    - Sign-On Routine.                          *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P14           BEGSR                                                  ** P14    **
      *
     C                   MOVEL     *BLANKS       IKSON
     C                   MOVEL     *BLANKS       OKSON
      *
     C                   MOVEL     FLDI1         IKSON
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
     C                   MOVEL     W#TELD        KTBID
     C                   MOVEL     '1'           KRCTP                                        197289
     C     KTTRNT        CHAIN     TTRNM2L1                           30
      *
     C     *IN30         IFEQ      *ON
     C     RECI          ORNE      'D'
      *
     C                   MOVEL     'Y'           WERROR
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
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVEL     *BLANKS       @WRK4
     C                   MOVEL     *BLANKS       @WRK5
     C     KTBRI         CAT       KTBID         @WRK4
     C     @WRK4         CAT       KRCTP         @WRK5
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C                   MOVEL     @WRK5         DBKEY
     C                   Z-ADD     15            DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   ELSE
      *
     C     TWID          IFNE      *BLANKS
      *
     C                   MOVEL     'Y'           WERROR
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0015'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     TWID          WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'E'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
      **  Report error.
      *
     C                   CALL      'REC4411'
     C                   PARM      'RE004501'    PROG
     C                   PARM                    JOBNUM
     C                   PARM      '0000'        MMCODE
     C                   PARM      W#BRCA        P#BRCA
     C                   PARM                    @MSGID
     C                   PARM                    @MSGDT
      *
     C                   MOVEL     *BLANKS       @WRK4
     C                   MOVEL     *BLANKS       @WRK5
     C     KTBRI         CAT       KTBID         @WRK4
     C     @WRK4         CAT       KRCTP         @WRK5
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TTRNM2L1'    DBFILE
     C                   MOVEL     @WRK5         DBKEY
     C                   Z-ADD     17            DBASE
     C                   EXSR      DBERR
      *
     C                   MOVE      'N'           WCSTAT            1
     C                   MOVE      'CS'          WMSTAT            2
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     STATO
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
      **  Set Off Session Active Flag.
      *
     C                   MOVEL     'N'           WACTIV
      *
     C                   ELSE
      *
     C     TST(A)        IFEQ      ' ON'
      *
      **  Retrieve error message data to send in host message.
      *
     C                   MOVEL     'USR0005'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     *BLANKS       WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVE      'W'           O#HMSS
     C                   MOVE      @MSGID        O#HMSI
      *
     C                   ELSE
      *
      **  Update workstation id.
      *
     C     'CASH'        CAT       JOBNUM        TWID
     C                   UPDATE    TTRNTM2F
      *
      **  Set teller status flag on.
      *
     C                   MOVEL     ' ON'         TST(A)
      *
     C                   MOVEL     'USR0064'     @MSGID
     C                   MOVEL     W#TELD        WMDTA1
     C                   MOVEL     W#BRCA        WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
      *
     C                   ENDIF
      *
     C                   MOVE      'Y'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C                   MOVEL     OSTATD        OKSON
     C*********          WRITE     KSONO                                22
      *
      * Send KSON message
     C                   movel     '00000113'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OKSOND        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P15    - Retail Rates Routine.                     *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P15           BEGSR                                                  ** P15    **
      *
     C                   MOVEL     *BLANKS       ICPRR
     C                   MOVEL     *BLANKS       OCPRRD
     C                   MOVEA     *BLANKS       AR1
     C                   MOVEA     *BLANKS       AR2
      *
     C                   Z-ADD     1             I
      *
     C                   MOVEL     FLDI1         ICPRR
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
      **  At the start, no retail rates have yet been loaded, set
      **  pointer to the beginning of the file.
      *
     C     IRRRTY        IFEQ      '***'
     C     *LOVAL        SETLL     SDCURRL0
     C                   MOVEL     'CSH'         WRRTY             3
     C                   MOVEL     NAR(1)        WRRDS            35
     C                   ELSE
      *
      **  Otherwise, some retail rates have already been loaded, WCCYSV
      **  contains the last rate loaded, set pointer to that position,
      **  then read next record.
      *
     C     WCCYSV        IFNE      *BLANKS
     C     WCCYSV        CHAIN     SDCURRL0                           42
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      SDCURRL0                               42
      *
      **  Assign values.
      *
     C     *IN42         DOWEQ     '0'
     C     I             ANDLE     10
      *
     C                   MOVEL     A6CYCD        WCCYSV            3
     C                   Z-ADD     A6SMLD        WSMLD             5 0
      *
      **  Smallest denomination to have decimal point.
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      WSMLD         ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   MOVE      ZFIELD        WMNDN             8
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     WMNDN         WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       WMNDN
     C                   MOVEA     RATE(1)       WMNDN
      *
      **  Assign appropriate values.
      *
     C                   MOVEL     *BLANKS       OCPRRB
     C                   MOVEL     WRRTY         ORRRTY
     C                   MOVEL     WRRDS         ORRRDS
     C                   MOVEL     A6CYCD        ORCCY
     C                   MOVEL     A6ISON        ORCCYN
     C                   MOVEL     A6CYNM        ORCCYD
     C                   MOVEL     A6NBDP        OREDCD
     C     A6MDIN        IFEQ      'M'
     C                   MOVEL     'Y'           ORRCFL
     C                   ELSE
     C                   MOVEL     'N'           ORRCFL
     C                   END
     C     A6CYCD        IFEQ      BJCYCD
     C                   MOVEL     'N'           ORRCFL
     C                   END
     C                   MOVE      '0000.000'    ORBYCM
     C                   MOVE      WMNDN         ORBMDN
     C                   MOVE      '0000.000'    ORSLCM
     C                   MOVE      WMNDN         ORSMDN
      *                                                                   141921
      **  If CRT104 is on, retrieve rates from PF/REBDCRPD.               141921
      *                                                                   141921
     C     CRT104        IFEQ      'Y'                                                         14192
      *                                                                   141921
     C     A6CYCD        CHAIN     REBDCRPD                           43                       14192
      *                                                                   141921
     C     *IN43         IFEQ      '1'                                                         14192
      *                                                                   141921
     C                   MOVEL     'Y'           WERROR                                        14192
      *                                                                   141921
     C                   MOVEL     'USR0045'     @MSGID                                        14192
     C                   MOVEL     A6CYCD        WMDTA1                                        14192
     C                   MOVEL     *BLANKS       WMDTA2                                        14192
     C     WMDTA1        CAT       WMDTA2        @MSGDT                                        14192
     C                   EXSR      RTVMSG                                                      14192
     C                   MOVEL     @MSGTX        O#HMSG                                        14192
     C                   MOVE      'E'           O#HMSS                                        14192
     C                   MOVE      @MSGID        O#HMSI                                        14192
      *                                                                   141921
     C                   CALL      'REC4411'                                                   14192
     C                   PARM      'RE004501'    PROG                                          14192
     C                   PARM                    JOBNUM                                        14192
     C                   PARM      '0000'        MMCODE                                        14192
     C                   PARM      *BLANKS       P#BRCA                                        14192
     C                   PARM                    @MSGID                                        14192
     C                   PARM                    @MSGDT                                        14192
      *                                                                   141921
     C     *LOCK         IN        LDA                                                         14192
     C                   MOVE      'REBDCRPD'    DBFILE                                        14192
     C                   MOVEL     @OPTN         DBKEY                                         14192
     C                   Z-ADD     9             DBASE                                         14192
     C                   EXSR      DBERR                                                       14192
      *                                                                   141921
     C                   MOVE      'N'           WCSTAT            1                           14192
     C                   MOVE      'CS'          WMSTAT            2                           14192
     C                   EXSR      WRTLOG                                                      14192
      *                                                                   141921
     C*********          WRITE     STATO
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
      *                                                                   141921
     C                   ELSE                                                                  14192
      *                                                                   141921
      **  Edit rates to include decimal points before assigning to output 141921
      *                                                                   141921
     C***********IRRRTY    IFEQ 'CSH'                              141921 CEU025
     C***********IRRTYP    IFEQ 'CSH'                                     CEU025              164946
     C     IRRRTY        IFEQ      'CSH'
      *                                                                   141921
     C                   MOVEL     *ZEROS        ORBYRT                                        14192
     C                   Z-ADD     *ZEROS        W#RT             13 8                         14192
     C                   MOVEL     *BLANKS       ZFIELD                                        14192
     C     FEDNRT        DIV       FEAMNT        W#RT                                          14192
     C                   MOVE      W#RT          ZFIELD                                        14192
     C                   Z-ADD     8             ZADEC                                         14192
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      ORBYRT                                        14192
     C                   MOVEL     *BLANKS       WFIELD           16                           14192
     C                   MOVEL     ORBYRT        WFIELD                                        14192
     C                   EXSR      PAD                                                         14192
     C                   MOVEL     *BLANKS       ORBYRT                                        14192
     C                   MOVEA     RATE(1)       ORBYRT                                        14192
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OREXBR                                        CEU02
     C                   MOVEA     RATE(1)       OREXBR                                        CEU02
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OREBPR                                        CEU02
     C                   MOVEA     RATE(1)       OREBPR                                        CEU02
      *                                                                   141921
     C                   MOVEL     *ZEROS        ORSLRT                                        14192
     C                   Z-ADD     *ZEROS        W#RT                                          14192
     C                   MOVEL     *BLANKS       ZFIELD                                        14192
     C     FEDPRT        DIV       FEAMNT        W#RT                                          14192
     C                   MOVE      W#RT          ZFIELD                                        14192
     C                   Z-ADD     8             ZADEC                                         14192
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      ORSLRT                                        14192
     C                   MOVEL     *BLANKS       WFIELD           16                           14192
     C                   MOVEL     ORSLRT        WFIELD                                        14192
     C                   EXSR      PAD                                                         14192
     C                   MOVEL     *BLANKS       ORSLRT                                        14192
     C                   MOVEA     RATE(1)       ORSLRT                                        14192
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       OREXSR                                        CEU02
     C                   MOVEA     RATE(1)       OREXSR                                        CEU02
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       ORESPR                                        CEU02
     C                   MOVEA     RATE(1)       ORESPR                                        CEU02
      *                                                                   141921
     C                   ELSE                                                                  14192
      *                                                                   141921
     C                   MOVEL     *ZEROS        ORBYRT                                        14192
     C                   Z-ADD     *ZEROS        W#RT             13 8                         14192
     C                   MOVEL     *BLANKS       ZFIELD                                        14192
     C     FEVNRT        DIV       FEAMNT        W#RT                                          14192
     C                   MOVE      W#RT          ZFIELD                                        14192
     C                   Z-ADD     8             ZADEC                                         14192
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      ORBYRT                                        14192
     C                   MOVEL     *BLANKS       WFIELD           16                           14192
     C                   MOVEL     ORBYRT        WFIELD                                        14192
     C                   EXSR      PAD                                                         14192
     C                   MOVEL     *BLANKS       ORBYRT                                        14192
     C                   MOVEA     RATE(1)       ORBYRT                                        14192
      *                                                                   141921
     C                   MOVEL     *ZEROS        ORSLRT                                        14192
     C                   Z-ADD     *ZEROS        W#RT                                          14192
     C                   MOVEL     *BLANKS       ZFIELD                                        14192
     C     FEVPRT        DIV       FEAMNT        W#RT                                          14192
     C                   MOVE      W#RT          ZFIELD                                        14192
     C                   Z-ADD     8             ZADEC                                         14192
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      ORSLRT                                        14192
     C                   MOVEL     *BLANKS       WFIELD           16                           14192
     C                   MOVEL     ORSLRT        WFIELD                                        14192
     C                   EXSR      PAD                                                         14192
     C                   MOVEL     *BLANKS       ORSLRT                                        14192
     C                   MOVEA     RATE(1)       ORSLRT                                        14192
      *                                                                   141921
     C                   ENDIF                                                                 14192
      *                                                                   141921
     C                   ENDIF                                                                 14192
      *                                                                   141921
     C                   ELSE                                                                  14192
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      A6SPRT        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      ORBYRT
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     ORBYRT        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       ORBYRT
     C                   MOVEA     RATE(1)       ORBYRT
     C                   MOVE      ORBYRT        ORSLRT                                        14192
      *                                                                   141921
     C                   ENDIF                                                                 14192
      *                                                                   141921
      *
     C                   MOVEL     *ZEROS        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      ORBPRT
     C                   MOVEL     *BLANKS       WFIELD           16
     C                   MOVEL     ORBPRT        WFIELD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       ORBPRT
     C                   MOVEA     RATE(1)       ORBPRT
      *
     C                   MOVEL     *ZEROS        ZFIELD
     C                   Z-ADD     8             ZADEC
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   MOVE      ZFIELD        ORBPAM
     C                   MOVEL     *BLANKS       WFLD             16
     C                   MOVEL     ORBPAM        WFLD
     C                   EXSR      PAD
     C                   MOVEL     *BLANKS       ORBPAM
     C                   MOVEA     RATE(1)       ORBPAM
      *
     C***********          MOVE ORBYRT    ORSLRT                          141921
     C                   MOVE      ORBPRT        ORSPRT
     C                   MOVE      ORBPAM        ORSPAM
      *
     C     CEU025        IFEQ      'Y'                                                         CEU02
      *                                                                   CEU025
     C     A6INCY        IFEQ      'Y'                                                         CEU02
     C     BJRDNB        ANDGE     A6TPSD                                                      17583
     C*****BJRDNB*****   ANDLE     A6TPED                                              175838 199373
     C                   MOVEL     'Y'           ORMBFL                                        CEU02
     C                   ELSE                                                                  CEU02
     C                   MOVEL     'N'           ORMBFL                                        CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU025
     C                   ELSE                                                                  CEU02
     C                   MOVEL     'N'           ORMBFL                                        CEU02
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU025
     C                   MOVEL     ORORS1        AR1(I)
     C                   MOVEL     ORORS2        AR2(I)
      *
     C                   ADD       1             I
      *
     C                   READ      SDCURRL0                               42
      *
     C     WERROR        IFEQ      'N'
     C     *IN42         ANDEQ     '1'
     C     I             ANDLE     10
     C***********IRRRTY    ANDNE'TCQ'                                     CEU025
     C***********IRRTYP    ANDNE'TCQ'                                     CEU025              164946
     C     IRRRTY        ANDNE     'TCQ'
      *
     C                   MOVEL     'TCQ'         WRRTY
     C                   MOVEL     NAR(2)        WRRDS
     C     *LOVAL        SETLL     SDCURRL0
     C                   READ      SDCURRL0                               42
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      **  EOF encountered before 10 elements have been filled up.
      *
     C     WERROR        IFEQ      'N'
      *
     C     *IN42         IFEQ      '1'
     C     I             ANDLE     10
     C***********IRRRTY    ANDEQ'TCQ'                                     CEU025
     C***********IRRTYP    ANDEQ'TCQ'                                     CEU025              164946
     C     IRRRTY        ANDEQ     'TCQ'
      *
      **  Move '***' to last CCY block when EOF reached.
      *
     C                   MOVEL     *BLANK        OCPRRB
     C                   MOVEL     '***'         ORRRTY
     C                   MOVEL     ORORS1        AR1(I)
     C                   MOVEL     ORORS2        AR2(I)
      *
     C                   ELSE
      *
     C     *IN42         IFEQ      '1'
     C     I             ANDGT     10
     C***********IRRRTY    ANDNE'TCQ'                                     CEU025
     C***********IRRTYP    ANDNE'TCQ'                                     CEU025              164946
     C     IRRRTY        ANDNE     'TCQ'
      *
     C                   MOVEL     'TCQ'         WRRTY
     C                   MOVEL     NAR(2)        WRRDS
     C     *LOVAL        SETLL     SDCURRL0
     C                   MOVEL     *BLANKS       WCCYSV
      *
     C                   ELSE
      *
     C     *IN42         IFEQ      '1'
     C     I             ANDGT     10
     C***********IRRRTY    ANDEQ'TCQ'                                     CEU025
     C***********IRRTYP    ANDEQ'TCQ'                                     CEU025              164946
     C     IRRRTY        ANDEQ     'TCQ'
     C     AR1(1)        ANDEQ     *BLANKS
      *
      **  Move '***' to last CCY block when EOF reached.
      *
     C                   MOVEL     *BLANK        OCPRRB
     C                   MOVEL     '***'         ORRRTY
     C                   MOVEL     ORORS1        AR1(1)
     C                   MOVEL     ORORS2        AR2(1)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **  Move array contents to outgoing message.
      *
     C                   MOVEL     AR1(1)        ORD01A
     C                   MOVEL     AR2(1)        ORD01B
     C                   MOVEL     AR1(2)        ORD02A
     C                   MOVEL     AR2(2)        ORD02B
     C                   MOVEL     AR1(3)        ORD03A
     C                   MOVEL     AR2(3)        ORD03B
     C                   MOVEL     AR1(4)        ORD04A
     C                   MOVEL     AR2(4)        ORD04B
     C                   MOVEL     AR1(5)        ORD05A
     C                   MOVEL     AR2(5)        ORD05B
     C                   MOVEL     AR1(6)        ORD06A
     C                   MOVEL     AR2(6)        ORD06B
     C                   MOVEL     AR1(7)        ORD07A
     C                   MOVEL     AR2(7)        ORD07B
     C                   MOVEL     AR1(8)        ORD08A
     C                   MOVEL     AR2(8)        ORD08B
     C                   MOVEL     AR1(9)        ORD09A
     C                   MOVEL     AR2(9)        ORD09B
     C                   MOVEL     AR1(10)       ORD10A
     C                   MOVEL     AR2(10)       ORD10B
      *
      **  Write Data Comms File.
      *
     C     I             IFGT      1
     C     I             SUB       1             K
     C                   ELSE
     C                   Z-ADD     1             K
     C                   ENDIF
     C                   MOVEL     AR1(1)        @RRT1             3
     C                   MOVEL     AR1(K)        @RRT2             3
     C     3             SUBST     AR1(1):39     @CCY1             3
     C     3             SUBST     AR1(K):39     @CCY2             3
      *
     C                   MOVEL     'USR0025'     @MSGID
     C     @RRT1         CAT       @CCY1         WMDTA1
     C     @RRT2         CAT       @CCY2         WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     @MSGTX        O#HMSG
     C                   MOVEL     OSTATD        OCPRR
      *
     C                   MOVE      'Y'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C*********          WRITE     CPRRO                                22
      *
      * Send CPRR message
     C                   movel     '00003343'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OCPRRD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *            P16    - Alternative Currency Descriptions Routine.*
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P05    - Retrieve Message Details Processing.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     P16           BEGSR                                                  ** P16    **
      *
     C                   MOVEL     *BLANKS       ICDES
     C                   MOVEL     *BLANKS       OCDES
     C                   MOVEA     *BLANKS       ACD
      *
     C                   Z-ADD     1             I
      *
     C                   MOVEL     FLDI1         ICDES
     C                   MOVEL     I#MSTY        O#MSTY
     C                   MOVEL     W#BRCA        O#BRCA
     C                   MOVEL     W#TELD        O#TELD
      *
      **  At the start, no currencies have yet been loaded, set
      **  pointer to the beginning of the file.
      *
     C     IDCCY         IFEQ      '***'
     C     *LOVAL        SETLL     SDCURRL0
     C                   ELSE
      *
      **  Otherwise, some currencies have already been loaded, IDCCY
      **  contains the last CCY loaded, set pointer to that position,
      **  then read next record.
      *
     C     IDCCY         CHAIN     SDCURRL0                           42
     C                   ENDIF
      *
     C                   READ      SDCURRL0                               42
      *
      **  Assign values.
      *
     C     *IN42         DOWEQ     '0'
     C     I             ANDLE     16
      *
     C                   MOVEL     *BLANKS       OCDESB
     C                   MOVEL     A6CYCD        ODCCY
     C                   MOVEL     A6MACD        ODMJCD
     C                   MOVEL     A6FRAC        ODFRFL
     C                   MOVEL     A6NUWD        ODNMWD
     C                   MOVEL     A6MICD        ODMNCD
      *
     C                   MOVEL     OCDESB        ACD(I)
      *
     C                   ADD       1             I
      *
     C                   READ      SDCURRL0                               42
      *
     C                   ENDDO
      *
      **  EOF encountered before 16 elements have been filled up.
      *
     C     WERROR        IFEQ      'N'
      *
     C     *IN42         IFEQ      '1'
     C     I             ANDLE     16
      *
      **  Move '***' to last CCY block when EOF reached.
      *
     C                   MOVEL     *BLANK        OCDESB
     C                   MOVEL     '***'         ODCCY
     C                   MOVEL     OCDESB        ACD(I)
      *
     C                   ENDIF
      *
      **  Move array contents to outgoing message.
      *
     C                   MOVEL     ACD(1)        ODD01
     C                   MOVEL     ACD(2)        ODD02
     C                   MOVEL     ACD(3)        ODD03
     C                   MOVEL     ACD(4)        ODD04
     C                   MOVEL     ACD(5)        ODD05
     C                   MOVEL     ACD(6)        ODD06
     C                   MOVEL     ACD(7)        ODD07
     C                   MOVEL     ACD(8)        ODD08
     C                   MOVEL     ACD(9)        ODD09
     C                   MOVEL     ACD(10)       ODD10
     C                   MOVEL     ACD(11)       ODD11
     C                   MOVEL     ACD(12)       ODD12
     C                   MOVEL     ACD(13)       ODD13
     C                   MOVEL     ACD(14)       ODD14
     C                   MOVEL     ACD(15)       ODD15
     C                   MOVEL     ACD(16)       ODD16
      *
      **  Write Data Comms File.
      *
     C     I             IFGT      1
     C     I             SUB       1             K
     C                   ELSE
     C                   Z-ADD     1             K
     C                   ENDIF
     C                   MOVEL     ACD(1)        @DCY1             3
     C                   MOVEL     ACD(K)        @DCY2             3
      *
     C                   MOVEL     'USR0026'     @MSGID
     C                   MOVEL     @DCY1         WMDTA1
     C                   MOVEL     @DCY2         WMDTA2
     C     WMDTA1        CAT       WMDTA2        @MSGDT
     C                   EXSR      RTVMSG
      *
     C                   MOVEL     'C'           O#HMSS
     C                   MOVEL     *BLANKS       O#HMSI
     C                   MOVEL     *BLANKS       O#HMSG
      *
     C                   MOVE      'Y'           WCSTAT
     C                   MOVE      'CS'          WMSTAT
     C                   EXSR      WRTLOG
      *
     C                   MOVEL     OSTATD        OCDES
     C*********          WRITE     CDESO                                22
      *
      * Send CDES message
     C                   movel     '00001329'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OCDESD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************   118528
      /EJECT                                                              118528
      *****************************************************************   118528
      *                                                               *   118528
      *            P17    - Reversal of Account Balance Hold.         *   118528
      *                                                               *   118528
      * CALLS      DBERR  - Database Error Handling.                  *   118528
      *            RTVMSG - Retrieve Program message details          *   118528
      *            WRTLOG - Write to Communications Log               *   118528
      *            PAD    - Pad field with leading zeros              *   118528
      *            ZDATE9 -                                           *   118528
      *                                                               *   118528
      * CALLED BY  COMMSG - Comms Message Processing                  *   118528
      *                                                               *   118528
      * FLDS USED         -                                           *   118528
      *                                                               *   118528
      *****************************************************************   118528
     C     P17           BEGSR                                                  ** P17    **   11852
      *                                                                   118528
      **  Initialise fields.                                              118528
      *                                                                   118528
     C                   MOVEL     *BLANKS       IRACBD                                        11852
     C                   MOVEL     *BLANKS       ORACBD                                        11852
      *                                                                   118528
      **  Assign values.                                                  118528
      *                                                                   118528
     C                   MOVEL     FLDI1         IRACBD                                        11852
     C                   MOVEL     I#MSTY        O#MSTY                                        11852
     C                   MOVEL     W#BRCA        O#BRCA                                        11852
     C                   MOVEL     W#TELD        O#TELD                                        11852
      *                                                                   118528
      **  Access LF/MEMOSL1                                               118528
      *                                                                   118528
     C                   MOVEL     IRAACN        WK13             13                           11852
     C                   MOVE      WK13          W#AACN           10 0                         11852
      *                                                                   118528
     C                   CALL      'AOMEMSR0'                                                  11852
     C                   PARM      *BLANKS       @RTCD                                         11852
     C                   PARM      '*KEY    '    @OPTN                                         11852
     C                   PARM      W#AACN        @RETL            10 0                         11852
     C**********         PARM      0             W#CNUM            6 0                  11852 CPK029
     C                   PARM      *BLANKS       W#CNUM            6                          CPK029
     C                   PARM      *BLANKS       W#CCY             3                           11852
     C**********         PARM      0             W#ACDD            4 0                  11852 CGL029
     C                   PARM      0             W#ACDD                                       CGL029
     C                   PARM      0             W#ACSQ            2 0                         11852
     C                   PARM      *BLANKS       W#BRCA            3                           11852
     C     DSMEMS        PARM      DSMEMS        DSFDY                                         11852
      *                                                                   118528
      **  Shadow Balance not found.                                       118528
      *                                                                   118528
     C     @RTCD         IFNE      *BLANK                                                      11852
      *                                                                   118528
     C                   MOVEL     'Y'           WERROR                                        11852
      *                                                                   118528
      **  Retrieve error message data to send in host message.            118528
      *                                                                   118528
     C                   MOVEL     'USR0073'     @MSGID                                        11852
     C                   MOVEL     W#BRCA        WMDTA1                                        11852
     C                   MOVEL     *BLANKS       WMDTA2                                        11852
     C     WMDTA1        CAT       WMDTA2        @MSGDT                                        11852
     C                   EXSR      RTVMSG                                                      11852
     C                   MOVEL     @MSGTX        O#HMSG                                        11852
     C                   MOVE      'E'           O#HMSS                                        11852
     C                   MOVE      @MSGID        O#HMSI                                        11852
      *                                                                   118528
      **  Report Error.                                                   118528
      *                                                                   118528
     C                   CALL      'REC4411'                                                   11852
     C                   PARM      'RE004501'    PROG                                          11852
     C                   PARM                    JOBNUM                                        11852
     C                   PARM      '0000'        MMCODE                                        11852
     C                   PARM      W#BRCA        P#BRCA                                        11852
     C                   PARM                    @MSGID                                        11852
     C                   PARM                    @MSGDT                                        11852
      *                                                                   118528
     C     *LOCK         IN        LDA                                                         11852
     C                   MOVEL     'MEMOS   '    DBFILE                                        11852
     C                   MOVEL     @OPTN         DBKEY                                         11852
     C                   Z-ADD     23            DBASE                                         11852
     C                   EXSR      DBERR                                                       11852
      *                                                                   118528
     C                   MOVE      'N'           WCSTAT            1                           11852
     C                   MOVE      'CS'          WMSTAT            2                           11852
     C                   EXSR      WRTLOG                                                      11852
      *                                                                   118528
     C*********          WRITE     STATO
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
      *                                                                   118528
      **  Shadow balance found                                            118528
      *                                                                   118528
     C                   ELSE                                                                  11852
      *                                                                   118528
      **  Retrieve overdraft, currency and held amounts.                  118528
      *                                                                   118528
     C     W#AACN        CHAIN     ACNUMF                             31                       11852
      *                                                                   118528
      **  Account Details not found                                       118528
      *                                                                   118528
     C     *IN31         IFEQ      '1'                                                         11852
      *                                                                   118528
     C                   MOVEL     'Y'           WERROR                                        11852
      *                                                                   118528
      **  Retrieve error message data to send in host message.            118528
      *                                                                   118528
     C                   MOVEL     'USR0074'     @MSGID                                        11852
     C                   MOVEL     W#BRCA        WMDTA1                                        11852
     C                   MOVEL     *BLANKS       WMDTA2                                        11852
     C     WMDTA1        CAT       WMDTA2        @MSGDT                                        11852
     C                   EXSR      RTVMSG                                                      11852
     C                   MOVEL     @MSGTX        O#HMSG                                        11852
     C                   MOVE      'E'           O#HMSS                                        11852
     C                   MOVE      @MSGID        O#HMSI                                        11852
      *                                                                   118528
      **  Report Error.                                                   118528
      *                                                                   118528
     C                   CALL      'REC4411'                                                   11852
     C                   PARM      'RE004501'    PROG                                          11852
     C                   PARM                    JOBNUM                                        11852
     C                   PARM      '0000'        MMCODE                                        11852
     C                   PARM      W#BRCA        P#BRCA                                        11852
     C                   PARM                    @MSGID                                        11852
     C                   PARM                    @MSGDT                                        11852
      *                                                                   118528
     C     *LOCK         IN        LDA                                                         11852
     C                   MOVEL     'ACNUM   '    DBFILE                                        11852
     C                   MOVEL     W#AACN        DBKEY                                         11852
     C                   Z-ADD     24            DBASE                                         11852
     C                   EXSR      DBERR                                                       11852
      *                                                                   118528
     C                   MOVE      'N'           WCSTAT            1                           11852
     C                   MOVE      'CS'          WMSTAT            2                           11852
     C                   EXSR      WRTLOG                                                      11852
      *                                                                   118528
     C*********          WRITE     STATO
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
      *                                                                   118528
      **  Account Details found                                           118528
      *                                                                   118528
     C                   ELSE                                                                  11852
      *                                                                   118528
     C     CCY           CHAIN     SDCURRL0                           42                       11852
      *                                                                   118528
      **  Currency not found                                              118528
      *                                                                   118528
     C     *IN42         IFEQ      '1'                                                         11852
      *                                                                   118528
     C                   MOVEL     'Y'           WERROR                                        11852
      *                                                                   118528
      **  Retrieve error message data to send in host message.            118528
      *                                                                   118528
     C                   MOVEL     'USR0047'     @MSGID                                        11852
     C                   MOVEL     W#BRCA        WMDTA1                                        11852
     C                   MOVEL     *BLANKS       WMDTA2                                        11852
     C     WMDTA1        CAT       WMDTA2        @MSGDT                                        11852
     C                   EXSR      RTVMSG                                                      11852
     C                   MOVEL     @MSGTX        O#HMSG                                        11852
     C                   MOVE      'E'           O#HMSS                                        11852
     C                   MOVE      @MSGID        O#HMSI                                        11852
      *                                                                   118528
      **  Report Error.                                                   118528
      *                                                                   118528
     C                   CALL      'REC4411'                                                   11852
     C                   PARM      'RE004501'    PROG                                          11852
     C                   PARM                    JOBNUM                                        11852
     C                   PARM      '0000'        MMCODE                                        11852
     C                   PARM      W#BRCA        P#BRCA                                        11852
     C                   PARM                    @MSGID                                        11852
     C                   PARM                    @MSGDT                                        11852
      *                                                                   118528
     C     *LOCK         IN        LDA                                                         11852
     C                   MOVEL     'SDCURRL0'    DBFILE                                        11852
     C                   MOVEL     CCY           DBKEY                                         11852
     C                   Z-ADD     25            DBASE                                         11852
     C                   EXSR      DBERR                                                       11852
      *                                                                   118528
     C                   MOVE      'N'           WCSTAT            1                           11852
     C                   MOVE      'CS'          WMSTAT            2                           11852
     C                   EXSR      WRTLOG                                                      11852
      *                                                                   118528
     C*********          WRITE     STATO
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
      *                                                                   118528
      **  Currency found                                                  118528
      *                                                                   118528
     C                   ELSE                                                                  11852
      *                                                                   118528
      **  Format Balance with correct decimal places                      118528
      *                                                                   118528
     C                   MOVEL     *BLANK        ORAVBL                                        11852
      *                                                                   118528
      **  Overdraft has expired.                                          118528
      *                                                                   118528
     C     ODED          IFLT      BJRDNB                                                      11852
     C                   Z-ADD     0             @ODLN            15 0                         11852
      *                                                                   118528
      **  Overdraft has not expired                                       118528
      *                                                                   118528
     C                   ELSE                                                                  11852
     C                   Z-ADD     ODLN          @ODLN                                         11852
     C                   ENDIF                                                                 11852
      *                                                                   118528
      ** Calculate available balance                                      118528
      *                                                                   118528
     C                   Z-ADD     CLBLN         W#AVBL           16 0                         11852
     C     W#AVBL        IFLT      0                                                           11852
     C                   Z-SUB     W#AVBL        W#AVBL                                        11852
     C                   ENDIF                                                                 11852
     C                   SUB       @ODLN         W#AVBL                                        11852
     C                   ADD       HELD          W#AVBL                                        11852
      *                                                                   118528
     C                   MOVE      W#AVBL        ZFIELD                                        11852
     C                   Z-ADD     A6NBDP        ZADEC                                         11852
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   MOVEL     *BLANKS       WFIELD           16                           11852
     C                   MOVE      ZFIELD        WFIELD                                        11852
     C                   EXSR      PAD                                                         11852
     C                   MOVEA     RATE(1)       ORAVBL                                        11852
      *                                                                   118528
      **  Assign appropriate Available Balance sign                       118528
      *                                                                   118528
     C     CLBLN         IFGE      0                                                           11852
     C                   MOVE      '+'           ORAVBS                                        11852
     C                   ELSE                                                                  11852
     C                   MOVE      '-'           ORAVBS                                        11852
     C                   ENDIF                                                                 11852
      *                                                                   118528
     C                   ENDIF                                                                 11852
      *                                                                   118528
     C                   ENDIF                                                                 11852
      *                                                                   118528
     C                   ENDIF                                                                 11852
      *                                                                   118528
      ** Assign Value to Funds to be Cleared field.                       118528
      *                                                                   118528
     C                   MOVEL     *BLANKS       ORFBCF                                        11852
      *                                                                   118528
     C                   MOVEL     *BLANKS       ORFTBC                                        11852
     C     CLBLN         SUB       LDBLN         WK16             16 0                         11852
     C                   MOVEL     WK16          ZFIELD                                        11852
     C                   Z-ADD     A6NBDP        ZADEC                                         11852
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C                   MOVEL     *BLANKS       WFIELD           16                           11852
     C                   MOVE      ZFIELD        WFIELD                                        11852
     C                   EXSR      PAD                                                         11852
     C                   MOVEA     RATE(1)       ORFTBC                                        11852
      *                                                                   118528
      ** Set date/time stamp                                              118528
      *                                                                   118528
     C     *LOCK         IN        CITFTS                                                      11852
     C                   Z-ADD     0             WNSNS             2 0                         11852
     C                   MOVE      WNNSS         WNSNS                                         11852
     C                   ADD       1             WNSNS                                         11852
      *                                                                   118528
     C                   MOVE      *BLANKS       WNNSS                                         11852
     C                   MOVE      WNSNS         WNNSS                                         11852
     C                   OUT       CITFTS                                                      11852
      *                                                                   118528
     C                   Z-ADD     BJRDNB        @@DAYN            5 0                         11852
     C                   CALLB     'ZDATE9'
     C                   PARM                    @@DAYN            5 0
     C                   PARM                    @@VDT             8 0
     C                   PARM                    @@RTN             1
     C     @@RTN         IFEQ      '0'                                                         11852
     C                   MOVE      @@VDT         WCDAT             7                           11852
     C                   ENDIF                                                                 11852
     C     @@YR          IFGE      2000                                                        11852
     C                   MOVEL     '1'           WCDAT                                         11852
     C                   ELSE                                                                  11852
     C                   MOVEL     '0'           WCDAT                                         11852
     C                   ENDIF                                                                 11852
      *                                                                   118528
     C                   TIME                    WTIME             6 0                         11852
     C                   MOVE      WTIME         WTIMEC            6                           11852
      *                                                                   118528
     C     WCDAT         CAT       WTIMEC        WDT13            13                           11852
     C     WDT13         CAT       WNNSS         ORTMST                                        11852
      *                                                                   118528
      **  Write Data Comms File.                                          118528
      *                                                                   118528
     C     WERROR        IFEQ      'N'                                                         11852
      *                                                                   118528
     C                   MOVEL     'USR0075'     @MSGID                                        11852
     C                   MOVEL     *BLANKS       WMDTA1                                        11852
     C                   MOVEL     *BLANKS       WMDTA2                                        11852
     C                   EXSR      RTVMSG                                                      11852
      *                                                                   118528
     C                   MOVEL     'C'           O#HMSS                                        11852
     C                   MOVEL     *BLANKS       O#HMSI                                        11852
     C                   MOVEL     @MSGTX        O#HMSG                                        11852
     C                   MOVEL     OSTATD        ORACB                                         11852
      *                                                                   118528
     C                   MOVEL     'Y'           WCSTAT                                        11852
     C                   MOVEL     'CS'          WMSTAT                                        11852
     C                   EXSR      WRTLOG                                                      11852
      *                                                                   118528
     C*********          WRITE     RACBO                                22                     11852
      *
      * Send RACB message
     C                   movel     '00000162'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       ORACBD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *                                                                   118528
     C                   ENDIF                                                                 11852
      *                                                                   118528
     C                   ENDSR                                                                 11852
      *****************************************************************
      /EJECT                                                              CEU025
      *****************************************************************   CEU025
      *                                                               *   CEU025
      *            P18    - Fixed Rates Download Routine              *   CEU025
      *                                                               *   CEU025
      * CALLS      ZEDIT  - Insert decimal point and 0s for numeric.  *   CEU025
      *            PAD    - Pad field with leading zeros              *   CEU025
      *            RTVMSG - Retrieve Program message details          *   CEU025
      *            WRTLOG - Write to Communications Log               *   CEU025
      *                                                               *   CEU025
      * CALLED BY  COMMSG - Comms Message Processing                  *   CEU025
      *                                                               *   CEU025
      * FLDS USED         -                                           *   CEU025
      *                                                               *   CEU025
      *****************************************************************   CEU025
     C     P18           BEGSR                                                                 CEU02
      *                                                                   CEU025
      **  Initialise fields.                                              CEU025
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       IFRAT                                         CEU02
     C                   MOVEL     *BLANKS       OFRATD                                        CEU02
     C                   MOVEL     *BLANKS       AFR                                           CEU02
      *                                                                   CEU025
     C                   Z-ADD     1             I                                             CEU02
     C***********          Z-ADD0         WRATE1 138                      CEU025              164948
     C***********          Z-ADD0         WRATE2 138                      CEU025              164948
     C***********          Z-ADD0         WRATE3 138                      CEU025              164948
     C                   Z-ADD     0             WRATE1           14 8
     C                   Z-ADD     0             WRATE2           14 8
     C                   Z-ADD     0             WRATE3           14 8
      *                                                                   CEU025
     C                   MOVEL     FLDI1         IFRAT                                         CEU02
     C                   MOVEL     I#MSTY        O#MSTY                                        CEU02
     C                   MOVEL     W#BRCA        O#BRCA                                        CEU02
     C                   MOVEL     W#TELD        O#TELD                                        CEU02
      *                                                                   CEU025
     C     CEU025        IFEQ      'Y'                                                         CEU02
      *                                                                   CEU025
     C***********CRT104    IFEQ 'Y'                        B*1            CEU025              164948
      ***********                                                         CEU025              164948
     C***********          CALL 'AOGELRR0'                                CEU025              164948
     C***********          PARM '*BLANK ' @RTCD   7                       CEU025              164948
     C***********          PARM '*FIRST ' @OPTN   7                       CEU025              164948
     C***********SDGELR    PARM SDGELR    DSFDY                           CEU025              164948
      ***********                                                         CEU025              164948
      ****If*error*on*access*to*General*Ledger*Details.                   CEU025              164948
      ***********                                                         CEU025              164948
     C***********@RTCD     IFNE *BLANKS                    B*2            CEU025              164948
      ***********                                                         CEU025              164948
      ****Report*error.                                                   CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVEL'USR0077' @MSGID                          CEU025              164948
     C***********          MOVEL*BLANKS   WMDTA1                          CEU025              164948
     C***********          MOVEL*BLANKS   WMDTA2                          CEU025              164948
     C***********          EXSR RTVMSG                                    CEU025              164948
     C***********          MOVEL@MSGTX    O#HMSG                          CEU025              164948
     C***********          MOVE 'E'       O#HMSS                          CEU025              164948
     C***********          MOVE @MSGID    O#HMSI                          CEU025              164948
      ***********                                                         CEU025              164948
     C***********          CALL 'REC4411'                                 CEU025              164948
     C***********          PARM 'RE4401'  PROG   10                       CEU025              164948
     C***********          PARM           JOBNUM  6                       CEU025              164948
     C***********          PARM '0000'    MMCODE  4                       CEU025              164948
     C***********          PARM *BLANKS   P#BRCA  3                       CEU025              164948
     C***********          PARM           @MSGID  7                       CEU025              164948
     C***********          PARM *BLANKS   @MSGDT                          CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVE 'N'       WCSTAT                          CEU025              164948
     C***********          MOVE 'CR'      WMSTAT                          CEU025              164948
     C***********          EXSR WRTLOG                                    CEU025              164948
      ***********                                                         CEU025              164948
     C***********          WRITESTATO                  22                 CEU025              164948
      ***********                                                         CEU025              164948
      ****Set*up*LDA*DBERR.                                               CEU025              164948
      ***********                                                         CEU025              164948
     C************LOCK     IN   LDA                                       CEU025              164948
     C***********          MOVEL'SDGELRPD'DBFILE                          CEU025              164948
     C***********          MOVEL@OPTN     DBKEY                           CEU025              164948
     C***********          Z-ADD28        DBASE                           CEU025              164948
     C***********          EXSR DBERR                                     CEU025              164948
      ***********                                                         CEU025              164948
      ****Set*Off*Session*Active*Flag.                                    CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVEL'N'       WACTIV  1                       CEU025              164948
      ***********                                                         CEU025              164948
     C***********          EXSR *PSSR                                     CEU025              164948
      ***********                                                         CEU025              164948
      ****Access*to Bank Details OK.                                      CEU025              164948
      ***********                                                         CEU025              164948
     C***********          ELSE                                           CEU025              164948
      ***********                                                         CEU025              164948
     C***********BKEURO    CHAINREBDCRPD             89                   CEU025              164948
      ***********                                                         CEU025              164948
     C************IN89     IFEQ *OFF                       B*3            CEU025              164948
      ***********                                                         CEU025              164948
     C***********FEVSRT    DIV  FEAMNT    WRATE2                          CEU025              164948
     C***********          ELSE                            X*3            CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVEL'USR0045' @MSGID                          CEU025              164948
     C***********          MOVELBKEURO    WMDTA1                          CEU025              164948
     C***********          MOVEL*BLANKS   WMDTA2                          CEU025              164948
     C***********WMDTA1    CAT  WMDTA2    @MSGDT                          CEU025              164948
     C***********          EXSR RTVMSG                                    CEU025              164948
     C***********          MOVEL@MSGTX    O#HMSG                          CEU025              164948
     C***********          MOVE 'E'       O#HMSS                          CEU025              164948
     C***********          MOVE @MSGID    O#HMSI                          CEU025              164948
      ***********                                                         CEU025              164948
     C***********          CALL 'REC4411'                                 CEU025              164948
     C***********          PARM 'RE4401'  PROG                            CEU025              164948
     C***********          PARM           JOBNUM                          CEU025              164948
     C***********          PARM '0000'    MMCODE                          CEU025              164948
     C***********          PARM *BLANKS   P#BRCA                          CEU025              164948
     C***********          PARM           @MSGID                          CEU025              164948
     C***********          PARM           @MSGDT                          CEU025              164948
      ***********                                                         CEU025              164948
     C************LOCK     IN   LDA                                       CEU025              164948
     C***********          MOVE 'REBDCRPD'DBFILE                          CEU025              164948
     C***********          MOVEL@OPTN     DBKEY                           CEU025              164948
     C***********          Z-ADD026       DBASE                           CEU025              164948
     C***********          EXSR DBERR                                     CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVE 'N'       WCSTAT  1                       CEU025              164948
     C***********          MOVE 'CS'      WMSTAT  2                       CEU025              164948
     C***********          EXSR WRTLOG                                    CEU025              164948
      ***********                                                         CEU025              164948
     C***********          WRITESTATO                  22                 CEU025              164948
     C***********          ENDIF                           E*3            CEU025              164948
      ***********                                                         CEU025              164948
     C***********          ENDIF                           E*2            CEU025              164948
      ***********                                                         CEU025              164948
     C***********          ENDIF                           E*1            CEU025              164948
      *                                                                   CEU025
      **  At the start, no currencies have yet been loaded, set           CEU025
      **  pointer to the beginning of the file.                           CEU025
      *                                                                   CEU025
     C     IFEUCY        IFEQ      '***'                                        B*1            CEU02
     C     *LOVAL        SETLL     SDCURRL0                                                    CEU02
     C                   ELSE                                                   X*1            CEU02
      *                                                                   CEU025
      **  Otherwise, some currencies have already been loaded, IFEUCY     CEU025
      **  contains the last CCY loaded, set pointer to that position,     CEU025
      **  then read next record.                                          CEU025
      *                                                                   CEU025
     C     IFEUCY        CHAIN     SDCURRL0                           42                       CEU02
     C                   ENDIF                                                  E*1            CEU02
      *                                                                   CEU025
     C                   READ      SDCURRL0                               42                   CEU02
      *                                                                   CEU025
      **  Assign values.                                                  CEU025
      *                                                                   CEU025
     C     *IN42         DOWEQ     '0'                                          B*1            CEU02
     C***********I         ANDLE21                                        CEU025              164946
     C     I             ANDLE     20
      *                                                                   CEU025
     C                   MOVEL     A6CYCD        OFFRCY                                        CEU02
     C                   MOVEL     BKEURO        OFGRCY                                        CEU02
      *                                                                   CEU025
     C***********CRT104    IFEQ 'Y'                                       CEU025              164948
      ***********                                                         CEU025              164948
     C***********A6CYCD    CHAINREBDCRPD             89                   CEU025              164948
      ***********                                                         CEU025              164948
     C************IN89     IFEQ *OFF                                      CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVEL'Y'       OFRCFL                   CEU025 163862
     C***********A6MDIN    IFEQ 'M'                                       163862              164948
     C***********          MOVEL'Y'       OFRCFL                          163862              164948
     C***********          ELSE                                           163862              164948
     C***********          MOVEL'N'       OFRCFL                          163862              164948
     C***********          ENDIF                                          163862              164948
     C***********FEVSRT    DIV  FEAMNT    WRATE1                          CEU025              164948
     C***********WRATE1    DIV  WRATE2    WRATE3                          CEU025              164948
     C***********          MOVEL*BLANKS   ZFIELD                          CEU025              164948
     C***********          MOVE WRATE3    ZFIELD                          CEU025              164948
      *                                                                   CEU025              164948
     C***********          ELSE                                           CEU025              164948
      *                                                                   CEU025              164948
     C***********          MOVEL'USR0045' @MSGID                          CEU025              164948
     C***********          MOVELA6CYCD    WMDTA1                          CEU025              164948
     C***********          MOVEL*BLANKS   WMDTA2                          CEU025              164948
     C***********WMDTA1    CAT  WMDTA2    @MSGDT                          CEU025              164948
     C***********          EXSR RTVMSG                                    CEU025              164948
     C***********          MOVEL@MSGTX    O#HMSG                          CEU025              164948
     C***********          MOVE 'E'       O#HMSS                          CEU025              164948
     C***********          MOVE @MSGID    O#HMSI                          CEU025              164948
      *                                                                   CEU025              164948
     C***********          CALL 'REC4411'                                 CEU025              164948
     C***********          PARM 'RE4401'  PROG                            CEU025              164948
     C***********          PARM           JOBNUM                          CEU025              164948
     C***********          PARM '0000'    MMCODE                          CEU025              164948
     C***********          PARM *BLANKS   P#BRCA                          CEU025              164948
     C***********          PARM           @MSGID                          CEU025              164948
     C***********          PARM           @MSGDT                          CEU025              164948
      ***********                                                         CEU025              164948
     C************LOCK     IN   LDA                                       CEU025              164948
     C***********          MOVE 'REBDCRPD'DBFILE                          CEU025              164948
     C***********          MOVEL@OPTN     DBKEY                           CEU025              164948
     C***********          Z-ADD027       DBASE                           CEU025              164948
     C***********          EXSR DBERR                                     CEU025              164948
      ***********                                                         CEU025              164948
     C***********          MOVE 'N'       WCSTAT  1                       CEU025              164948
     C***********          MOVE 'CS'      WMSTAT  2                       CEU025              164948
     C***********          EXSR WRTLOG                                    CEU025              164948
      ***********                                                         CEU025              164948
     C***********          WRITESTATO                  22                 CEU025              164948
     C***********          ENDIF                                          CEU025              164948
      ***********                                                         CEU025              164948
     C***********          ELSE                                           CEU025              164948
      *                                                                   CEU025
     C     A6INCY        IFEQ      'Y'
     C     BJRDNB        ANDGE     A6TPSD
     C*****BJRDNB*****   ANDLE     A6TPED                                                     194002
      *                                                                                       164948
     C***********A6MDIN    IFEQ 'M'                        B*3            CEU025              163862
     C     A6EUMD        IFEQ      'M'                                          B*3
     C                   MOVEL     'Y'           OFRCFL                                        CEU02
     C                   ELSE                                                   X*3            CEU02
     C                   MOVEL     'N'           OFRCFL                                        CEU02
     C                   ENDIF                                                  E*3            CEU02
      *                                                                   CEU025
     C                   MOVEL     *BLANKS       ZFIELD                                        CEU02
     C                   MOVE      A6EUER        ZFIELD                                        CEU02
     C***********          ENDIF                                          CEU025              164948
      *                                                                   CEU025
     C                   Z-ADD     8             ZADEC                                         CEU02
     C                   MOVEL     *ZEROS        OFFRRT                                        CEU02
     C                   CallB     'ZEDIT'
     C                   Parm                    ZFIELD           16
     C                   Parm                    ZADEC             1 0
     C     13            SUBST     ZFIELD:3      OFFRRT                                        CEU02
     C                   MOVEL     *BLANKS       WFIELD           16                           CEU02
     C                   MOVEL     OFFRRT        WFIELD                                        CEU02
     C                   EXSR      PAD                                                         CEU02
     C                   MOVEL     *BLANKS       OFFRRT                                        CEU02
     C                   MOVEA     RATE(1)       OFFRRT                                        CEU02
      *                                                                   CEU025
     C                   MOVEL     OFRATB        AFR(I)                                        CEU02
      *                                                                   CEU025
     C                   ADD       1             I                                             CEU02
      *                                                                   CEU025
     C                   ENDIF
      *                                                                                       164948
     C                   READ      SDCURRL0                               42                   CEU02
      *                                                                   CEU025
     C                   ENDDO                                                  E*1            CEU02
      *                                                                   CEU025
     C                   ENDIF                                                                 CEU02
      *                                                                   CEU025
     C     *IN42         IFEQ      *ON                                          B*1            CEU02
     C***********I         ANDLE21                                        CEU025              164946
     C     I             ANDLE     20
     C     CEU025        OREQ      'N'                                                         CEU02
     C                   MOVEL     *BLANKS       OFRATB                                        CEU02
     C                   MOVEL     '***'         OFFRCY                                        CEU02
     C                   MOVEL     OFRATB        AFR(I)                                        CEU02
     C                   ENDIF                                                  E*1            CEU02
      *                                                                   CEU025
      **  Move array contents to outgoing message.                        CEU025
      *                                                                   CEU025
     C                   MOVEL     AFR(1)        OFDB01                                        CEU02
     C                   MOVEL     AFR(2)        OFDB02                                        CEU02
     C                   MOVEL     AFR(3)        OFDB03                                        CEU02
     C                   MOVEL     AFR(4)        OFDB04                                        CEU02
     C                   MOVEL     AFR(5)        OFDB05                                        CEU02
     C                   MOVEL     AFR(6)        OFDB06                                        CEU02
     C                   MOVEL     AFR(7)        OFDB07                                        CEU02
     C                   MOVEL     AFR(8)        OFDB08                                        CEU02
     C                   MOVEL     AFR(9)        OFDB09                                        CEU02
     C                   MOVEL     AFR(10)       OFDB10                                        CEU02
     C                   MOVEL     AFR(11)       OFDB11                                        CEU02
     C                   MOVEL     AFR(12)       OFDB12                                        CEU02
     C                   MOVEL     AFR(13)       OFDB13                                        CEU02
     C                   MOVEL     AFR(14)       OFDB14                                        CEU02
     C                   MOVEL     AFR(15)       OFDB15                                        CEU02
     C                   MOVEL     AFR(16)       OFDB16                                        CEU02
     C                   MOVEL     AFR(17)       OFDB17                                        CEU02
     C                   MOVEL     AFR(18)       OFDB18                                        CEU02
     C                   MOVEL     AFR(19)       OFDB19                                        CEU02
     C                   MOVEL     AFR(20)       OFDB20                                        CEU02
     C**********           MOVELAFR,21    OFDB21                          CEU025              164946
      *                                                                   CEU025
      **  Write Data Comms File.                                          CEU025
      *                                                                   CEU025
     C     I             IFGT      1                                            B*1            CEU02
     C     I             SUB       1             K                                             CEU02
     C                   ELSE                                                   X*1            CEU02
     C                   Z-ADD     1             K                                             CEU02
     C                   ENDIF                                                  E*1            CEU02
      *                                                                   CEU025
     C                   MOVEL     AFR(1)        @CCY1                                         CEU02
     C                   MOVEL     AFR(K)        @CCY2                                         CEU02
      *                                                                   CEU025
     C                   MOVEL     'USR0076'     @MSGID                                        CEU02
     C                   MOVEL     @CCY1         WMDTA1                                        CEU02
     C                   MOVEL     @CCY2         WMDTA2                                        CEU02
     C     WMDTA1        CAT       WMDTA2        @MSGDT                                        CEU02
     C                   EXSR      RTVMSG                                                      CEU02
      *                                                                   CEU025
     C                   MOVEL     'C'           O#HMSS                                        CEU02
     C                   MOVEL     *BLANKS       O#HMSI                                        CEU02
     C                   MOVEL     @MSGTX        O#HMSG                                        CEU02
     C                   MOVEL     OSTATD        OFRAT                                         CEU02
      *                                                                   CEU025
     C                   MOVEL     'Y'           WCSTAT                                        CEU02
     C                   MOVEL     'CS'          WMSTAT                                        CEU02
     C                   EXSR      WRTLOG                                                      CEU02
      *                                                                   CEU025
     C*********          WRITE     FRATO                                22                     CEU02
      *
      * Send FRAT message
     C                   movel     '00000533'    header
     C                   move      'SND'         header
     C                   clear                   Sbuffer
     C     Header        cat       OFRATD        Sbuffer
     C                   Eval      RetCode = Snd_Tcp( ScktNum: Sbuffer )
     C                   If        RetCode = -1
     C                   exsr      tcperr
     C                   EndIf
      *                                                                   CEU025
     C                   ENDSR                                                                 CEU02
      *****************************************************************   CEU025
      /EJECT
      *****************************************************************
      *                                                               *
      *            PAD    - Pad field with leading zeros.             *
      *                                                               *
      * CALLS             -                                           *
      *                                                               *
      * CALLED BY  P08    - Retrieve Exchange Rates Information.      *
      *                                                               *
      * FLDS USED         -                                           *
      *                                                               *
      *****************************************************************
     C     PAD           BEGSR                                                  *** PAD    ***
      *
      **  Pad field with zeros to coincide with Cashier format.
      *
     C                   Z-ADD     1             L                 2 0
     C                   Z-ADD     0             WEND              2 0
     C     ' '           CHECK     WFIELD        WEND
     C                   MOVEA     *BLANKS       RATE(1)
     C                   MOVEA     WFIELD        RATE(1)
      *
     C     L             DOWLT     WEND
     C                   MOVEL     '0'           RATE(L)
     C                   ADD       1             L
     C                   ENDDO
      *                                                                   119318
      **  Replace any commas caused by County-specific character sets     119318
      **  by decimal points to ensure Cashier compatibility.              119318
      *                                                                   119318
     C                   Z-ADD     1             X                 2 0                         11931
     C                   MOVE      '0'           *IN68                                         11931
      *                                                                   119318
     C     ','           LOOKUP    RATE(X)                                68                   11931
     C     *IN68         IFEQ      *ON                                                         11931
     C                   MOVEL     '.'           RATE(X)                                       11931
     C                   ENDIF                                                                 11931
      *
     C                   ENDSR
      *
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
FRATN                                                                     CEU025
CSOVY                                                                                         CRT005
CSIVY                                                                                         CRT005
TLINY                                                                                         CRT005
TLOUY                                                                                         CRT005
**   NAR - NARRATIVE FOR RETAIL RATES DESCRIPTION
Cash
Travellers Cheques
**   @TXT - TEXT STRINGS FOR OVERRIDE                                                         CRT006
DLTOVR     FILE(*ALL)                                                                         CRT006
OVRDBF     FILE(TTRANL1) MBR(XXXX) SECURE(*YES) SHARE(*YES) SEQONLY(*NO)                      CRT006
