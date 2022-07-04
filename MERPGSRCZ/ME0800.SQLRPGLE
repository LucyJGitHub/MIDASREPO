     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Format message for printing')                 *
      *****************************************************************
      *                                                               *
      *  Midas - MESSAGE MANAGEMENT MODULE                            *
      *                                                               *
      *  ME0800 - OUTGOING MESSAGE DETAILS - PRINT FORMAT             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. 256996             Date 19Jan09               *
      *  Prev Amend No. MD056560           Date 31Aug20               *
      *                 MD057490           Date 22Feb21               *
      *                 MD052485           Date 02Apr19               *
      *                 MD051910           Date 02Apr19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD022050           Date 11Sep13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14915           Date 25Sep07               *
      *                 204225             Date 05Aug07               *
      *                 CSW207             Date 14Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 121288             Date 15Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 223076             Date 18Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 204225             Date 02May06               *
      *                 206803             Date 10Jul02               *
      *                 CME001             Date 07Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 210868             Date 19Dec02               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212173             Date 18Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 158656             Date 11Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 196833             Date 16Aug01               *
      *                 183583             Date 08Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186181             Date 10Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 141572             Date 21Sep98               *
      *                 CMT001             DATE 02NOV98               *
      *                 140629             DATE 18SEP98               *
      *                 CSW098             DATE 24MAR98               *
      *                 113352             DATE 13FEB97               *
      *                 107503             DATE 11APR97               *
      *                 CSW097             DATE 26MAY97               *
      *                 S01408             DATE 14NOV96               *
      *                 099234             DATE 09JUL96               *
      *                 S01408             DATE 02AUG95               *
      *                 081561             DATE 12JAN95               *
      *                 081505             DATE 06DEC94               *
      *                 066991             DATE 12OCT94               *
      *                 S01435             DATE 10NOV93               *
      *                 043888             DATE 15SEP93               *
      *                 E43198             DATE 24OCT92               *
      *                 E42972             DATE 10JUL92               *
      *                 E32647             DATE 30APR92               *
      *                 E29588             DATE 31OCT91               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  256996 - Include end date of 30G in MT350                    *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD057490 - MT202 Incorrect Bank Name in 57 field.            *
      *           - Use the correct message sequence in file MGOEXTPD *
      *             for Tag 57A.                                      *
      *  MD052485 - MT202 F52A + F57A incorrect field data in SpA Ldn *
      *             printed report vs. MPM.                           *
      *  MD051910 - Incorrect 57a tag extended details.               *
      *           - Applied for MD052485.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD022050 - Various errors in MT360 for counterparty          *
      *  BUG14915 - Error in using Corporate BEI field                *
      *  204225 - Field tag :50: is incorrect on SWIFT MT103.         *
      *           CROSSMAR customers must be checked first before tag *
      *           :50A: or tag :50K: is written/shown on MT103.       *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  121288 - Print 'Deliverer of Securities' as text if second   *
      *           occurrence of field tag 87. (1st occurrence in an   *
      *           MT512 is always 'Receiver of Securities').          *
      *  223076 - Ensure that the correct record is accessed in       *
      *           MGOEXTPD for fields 5Na and 8Na for MT103s with     *
      *           field :119:. Applied fix 206803.                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  204225 - Field tag :50: is incorrect on SWIFT MT103.         *
      *           CROSSMAR customers must be checked first before tag *
      *           :50A: or tag :50K: is written/shown on MT103.       *
      *  206803 - Ensure that the correct record is accessed in       *
      *           MGOEXTPD for fields 5Na and 8Na for MT103s with     *
      *           field :119:.                                        *
      *  CME001 - Upgrade LBV042/LBV049 to Midas Plus.                *
      *           Amend so that reports ME0810P1, ME0820P1, ME0830P1, *
      *           ME0845P1, ME0880P1 and ME0890P1 do not show         *
      *           <NOT VERIFIED>.                                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  210868 - In MT202, data replicated in field 57A:.            *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  212173 - Process validation fields for MT103s                *
      *  158656 - Fix 183583 made it mandatory to have a record in    *
      *           PF/MGOEXTPD to display the report name and town     *
      *           of the Swift Address of field tag :5nA:. Replace    *
      *           BIC customer parameter only if a record exists.     *
      *  196833 - Additional SWIFT Address for CLS Nostros            *
      *  183583 - Add extension file MGOEXTPD to store customer no.   *
      *           of field with SWIFT address.                        *
      *  141572 - Recompile over changes in MGOREFPD                  *
      *  CMT001 - Orion Telex 3.3 Implementation.                     *
      *           Addition of new Telex status codes.                 *
      *  140629 - Convert field 72 amount (, to .)                    *
      *  CSW098 - SWIFT 1998 changes.                                 *
      *           This program is changed to recognise MT515/518      *
      *           tags :98a: date/time format suffixed with a         *
      *           qualifier and/or type (:qual//type/yyymmddhhmmss).  *
      *           A new tag format 'DT' is introduced to format time  *
      *           to hh:mm:ss.  Also, :95P: (:qual//swiftid) should   *
      *           also be output with name and address as with :5nA:  *
      *           and :8nA: tags.                                     *
      *  113352 - Recompile over changes in MGOREFPD                  *
      *  107503 - If destination is from SWIFT BIC file, output name  *
      *           and city from this file                             *
      *  CSW097 - Swift changes 1997:                                 *
      *           The program was amended to recognise dates          *
      *           in CCYYMMDD format.                                 *
     F*           Also, display name and town for :8nA: fields        *
      *  S01408 - Addition of core hook ME0800EEP2                    *
      *         - Addition of core hook ME0800X001                    *
      *         - Addition of core hook ME0800CCP7                    *
      *         - Addition of core hook ME0800CCP6                    *
      *  099234 - Wrong field being checked for blanks in report      *
      *           town from counterparty nostro file (SDCNSTPD).      *
      *  S01408 - Addition of core hook ME0800EEP1                    *
      *                                 ME0800IIP1                    *
      *                                 ME0800IIP2                    *
      *                                 ME0800CCP1                    *
      *                                 ME0800CCP2                    *
      *                                 ME0800CCP3                    *
      *                                 ME0800CCP4                    *
      *                                 ME0800CCP5                    *
      *  081561 - Additional message status for supervisors added.    *
      *  081505 - Message status text changed (at end of pgm).        *
      *  066991 - Orion not passing Telex status back to Midas        *
      *  S01435 - Incoming Message Management                         *
      *  043888 - Report name and town not printed if a/c number      *
      *           in first line of address                            *
      *  E43198 - Always show TRNO for MT210'S                        *
      *  E42972 - Add report town to name and address fields.         *
      *  E32647 - Non-standard abbreviation for JULY.  Should be      *
      *           "JUL" instead of "JLY".  Amended element 7 of       *
      *           the array used to convert month numbers to text.    *
      *  E29588 - POST-COLLECTION SWIFT RATIONALISATION AMENDMENTS    *
      *           o Do not output SWIFT error line if it contains     *
      *             non-numeric data                                  *
      *           o Check that released-by-user is available before   *
      *             outputting it                                     *
      *           o Add text for Module MX or ME                      *
      *           o Text incorrect for TXT31                          *
      *                                                               *
      *****************************************************************
     FMGOREFL0  IF   E           K DISK
     FMGOMSGPD  IF   E           K DISK
     FMGOEXTLF  IF   E           K DISK                                         183583
     FSDMTPYL0  IF   E           K DISK
     F*SDMTAGL0* IF   E           K DISK                                                    MD056560
      * Customer and C/Party nostro files by network address
     FSDCUSTL7  IF   E           K DISK
     F                                     RENAME(@CUSTGE:SDCUSTSW)
     FSDCNSTL2  IF   E           K DISK
     F                                     RENAME(@CNSTLD:SDCNSTSW)
     FSDCUSTL9  IF   E           K DISK
     F                                     RENAME(@CUSTLG:SDCUSTST)
     FSDCNSTL3  IF   E           K DISK
     F                                     RENAME(@CNSTLE:SDCNSTST)
     FSDCUSTLA  IF   E           K DISK
     F                                     RENAME(@CUSTLH:SDCUSTTX)
     F/COPY WNCPYSRC,ME0800F001
     FSDCNSTL4  IF   E           K DISK
     F                                     RENAME(@CNSTLF:SDCNSTTX)
      *
     FSDCUSTLI  IF   E           K DISK
     F                                     RENAME(SDCUSTD0:SDCUSTBE)
      *
      *****************************************************************
      * ID C  F  H  L    Function of indicators                       *
      *    10            Check for multiple TRN tag. & check for      *
      *                  verification message type/field.             *
      *    81            USED IN SCAN FOR /OCMT/ AND /CHGS/           *   140629
      *    96            Chain to SDMTPYL1 fails                      *
      *    97            Chain to MGOREFL0 fails                      *
      *    98            Chain to SDMTAGL1 fails                      *
      *    99            Chain to MGOMSGPD fails                      *
      *   U7U8LR         DB error                                     *
      *****************************************************************
      *
      *                                                                   S01408
     D/COPY WNCPYSRC,ME0800EEP2                                           S01408
      *                                                                   S01408
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D TABMM           S              2    DIM(12) CTDATA PERRCD(1)
     D TABMON          S              3    DIM(12) ALT(TABMM)
      ** Months MM v Months MMM
      *
     D TG              S              1    DIM(5)
      **  Message field tag
      *
     D********************TXT     1  40 32                                E29588
     D/COPY WNCPYSRC,ME0800E003
     D********************TXT     1  41 32                         E29588 121288
     D TXT             S             32    DIM(42) CTDATA PERRCD(1)                              121
      **  Text to be printed on report
      *
     D/COPY WNCPYSRC,ME0800E001
     D************        VERFY   1   5  6                                                    212173
     D VERFY           S              6    DIM(6) CTDATA PERRCD(1)
      **  Message types/fields requiring verification
      *
     D TRNTG           S              7    DIM(2) CTDATA PERRCD(1)
      **  Message tag format
     D/COPY WNCPYSRC,ME0800E002
      *
     D******************* TABCD   1  22  4   TABNAR 35                    066991
     D******************* TABCD   1  41  4   TABNAR 35             066991 081561
     D******************* TABCD   1  42  4   TABNAR 35   status cod081561 CMT001
     D TABCD           S              4    DIM(49) CTDATA PERRCD(1)             status codes     CMT
     D TABNAR          S             35    DIM(49) ALT(TABCD)
     D/COPY WNCPYSRC,ME0800E004
      **  Status code against narrative
      *
     D TAB1            S              2  0 DIM(10) CTDATA PERRCD(1)
     D TAB2            S             15    DIM(10) ALT(TAB1)
      **  Match status narrative
      *
     D AMAR            S              1    DIM(20)
      **  Array for formatting amounts
      *
     D DTE             S              1    DIM(8)
      **  Array for formatting dates
      *
     D FLD             S              1    DIM(50)
      **  Array for formatting fields
      *
     D*                                                                   S01408
     D/COPY WNCPYSRC,ME0800EEP1                                           S01408
     D*                                                                   S01408
     D                 DS
     D  SDTAQ                  1    125
      ** Data structure to hold data queue contents
      *
     D  TEXT1                  4     12
     D  SMODI                 14     15
     D  TEXT2                 34     54
     D  STRNM                 56     70
     D  TEXT3                 74     89
     D  STNTY                 91     92
     D  TEXT4                 96    103
     D  SSBTP                106    107
      ** Module id <X>   Midas transaction no. <X> ...
      **... Transaction type <X>  Sub-type <X>
      *
     D  TEXT5                 34     48
     D  SXSYS                 56     61
      ** Module id <X>    External system <X>
      *
     D  TXT35                 34     44
     D**********                             47  64 SACCN                                     CGL029
     D  SACCN                 47     70
      ** Module id <X>    Account No. <X>
      *
     D  TXT41                 34     61                                         E29588
      ** Module id <X>    Input Via Message Management                    E29588
      *
     D  TEXT6                  4      9
     D  SSADR                 11     30
     D  TEXT7                 34     45
     D  SMTPY                 47     49
     D  SMTPD                 51     85
      ** Sender <Network address>  Message type <X> <Msg descrip>
      *
     D  TEXT8                  4     14
     D  SNWDS                 16     35
     D  SREPN                 37     72
     D  STOWN                 73     92
      ** Destination <Network address> <Report name> <Town>
      *
     D  TEXT9                  4     16
     D  SNWRK                 18     32
     D  TXT10                 34     41
     D  SMPRY                 43     48
     D  TXT11                 51     63
     D  SMGDE                 65     71
     D  TXT12                 74     94
     D  SDELC                 96     96
     D  TXT13                100    119
     D  SDELW                121    121
      ** Network/paper <SWIFT> Priority <URGENT> Creation date <ddmmyy >..
      ** .. Delivery notification <Y> Non-delivery warning <Y>
      *
     D  TXT14                 74     87
     D  STSKS                 89     94
      ** Network/paper <TELEX> Priority <NORMAL> Creation date <ddmmyy>..
      ** ... Testkey status <TESTED>
      *
     D  TXT15                106    117
     D  TXT16                106    117
      ** Network/paper PAPER                    Creation date <ddmmmyy> ..
      ** ...                      *** COPY ***
      *
     D  TXT17                  4     17
     D  SMGST                 19     53
     D  TXT18                 55     70
     D  SLADT                 72     78
     D  TXT19                 81     84
     D  SLATM                 86     93
     D  TXT20                102    106
     D  SMSE1                109    111
     D************************************* 112 114 SELIN                 E29588
     D  SELIN                113    115                                         E29588
      ** Message status <eg.NAK'ED BY SWIFT> Last action date <ddmmmyy>...
      ** ... time <hh:mm:ss>  Error <T95 003>
      *
     D  TXT21                  4     21
     D  SRUSR                 23     32
     D  TXT22                 35     45
     D  SRWSN                 47     56
     D  TXT23                 80    105
      ** Released by - user <X>  workstation <X> *** POSSIBLE DUPLICATE ***
      *
     D/COPY WNCPYSRC,ME0800I002
     D  TXT24                  4     14
     D  TXT25                 66     68
     D  TXT26                 72     75
      ** Description            Tag   Data
      *
     D  TXT27                  4     14
     D  TXT28                 66     68
     D  TXT29                 72     75
      ** -----------            ---   ----
      *
     D  TXT30                  4     35
     D  SCFCP                 37     51
     D  TXT31                 61     86
     D  SCFBR                 88    102
      ** Counterparty confirmation status <XX> ...
      ** ... Broker confirmation status <XX>
      *
     D  SSWFD                  4     63
     D  SMTAG                 65     69
     D  SMFLD                 71    123
      ** <narrative> <tag> <data>
      *
     D  SPTST                  4     16
     D  TXT32                 19     34
     D  SMTRN                 36     50
     D  TXT3A                 54     69
     D  STNTP                 71     72
     D  TXT4A                 76     83
     D  SSTYP                 85     86
     D  TXT33                 90    101
     D  SCFCY                103    104
     D  TXT34                108    118
     D  SCFBK                120    121
      ** <** DELETED **>  Midas trans. no. <X>  Transaction type <X> ..
      ** ... Sub-type <X>  C/party conf <X>  Broker conf <X>
      *
     D/COPY WNCPYSRC,ME0800I001
     D                 DS
     D  DAT                    1      6
     D  YY                     1      2
     D  MM                     3      4
     D  DD                     5      6
      *
     D                 DS
     D  DAT2                   1      7
     D  DD2                    1      2
     D  MM2                    3      5
     D  YY2                    6      7
     D*                                                                   S01408
     D/COPY WNCPYSRC,ME0800IIP1                                           S01408
     D*                                                                   S01408
      ** DS for splitting up date
      *
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      ** Data structure for DB error reporting
      *
     D DSRUN           DS            13
     D  RUNA                   1      7
     D  DATF                  12     12
     D  MBIN                  13     13
      **  RUNDAT data area
      *
     D                 DS
     D  WRKDAT                 1      8
     D  WRKDD                  1      2
     D  WRKMM                  4      5
     D  WRKYY                  7      8
      *
      **  Data structure for rearranging date
      *
     D                 DS
     D  CHGDAT                 1      8
     D  @CHG5                  1      5
     D  @1                     3      3    INZ('/')
     D  @@2                    6      6    INZ('/')
     D  CHGYY                  7      8
      *                                                                   121288
      **                                                                  121288
     D                 DS                                                       121288
     D  MTAG                   1      5                                         121288
     D  #TAG23                 2      3                                         121288
      *                                                                   CSW097
      ** Data structure to accomodate dates in CCYYMMDD format.           CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  WKDAT                  1     10                                         CSW097
     D  WKDD                   1      2                                         CSW097
     D  WKMM                   4      5                                         CSW097
     D  WKYY                   7     10                                         CSW097
      *                                                                   CSW097
      ** Data structure to hold date in CCYYMMDD format.                  CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  CHDAT                  1     10                                         CSW097
     D  @CH5                   1      5                                         CSW097
     D  @3                     3      3    INZ('/')                             CSW097
     D  @@4                    6      6    INZ('/')                             CSW097
     D  CHYY                   7     10                                         CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  DAT3                   1      8                                         CSW097
     D  YY3                    1      4                                         CSW097
     D  MM3                    5      6                                         CSW097
     D  DD3                    7      8                                         CSW097
      *                                                                                       256996
     D                 DS                                                                     256996
     D  DAT4                   1     17                                                       256996
     D  DAT5                  10     17                                                       256996
      *                                                                   CSW097
      ** Data structure to hold defined constants.                        CSW097
      *                                                                   CSW097
     D DIGITS          C                   CONST('0123456789')                  CSW097
      *                                                                   CSW097
      ** Data structure MFLD2 to hold the first seven character of MFLD   CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  MFLD2                  1      7                                         CSW097
     D  CHAR7                  7      7                                         CSW097
     D  CHAR44                 4      4                                         186181
     D  CHAR24                 2      4                                         186181
     D*                                                                   S01408
     D/COPY WNCPYSRC,ME0800IIP2                                           S01408
     D*                                                                   S01408
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                   107503
      **  Data structure to split BIC address                             107503
      *                                                                   107503
     D                 DS                                                       107503
     D  W01BIC                 1     12                                         107503
     D  W01ICC                 1      8                                         107503
     D  W01ICB                 9     11                                         107503
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
     D** Message Management details.
     D*
     D/COPY WNCPYSRC,ME0800I003
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    S01435
      *                                                                   S01435
      *  Calling parameter data structure for AOCUSTR0                    S01435
      *                                                                   S01435
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                    S01435
      *                                                                   S01435
      *  Calling parameter data structure for ME1400                      S01435
      *                                                                   S01435
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                    S01435
      *                                                                   S01435
      *  Calling parameter data structure for ME1400                      S01435
      *                                                                   S01435
      *                                                                   S01435
      * Layout for BIC directory processing                               S01435
      *                                                                   S01435
     D BICLAY          DS           125                                         S01435
      * Format for Report                                                 S01435
     D  #RPT1                 71    105                                         S01435
     D  #RPT2                106    123                                         S01435
      /EJECT                                                              S01435
     D/COPY WNCPYSRC,ME0800I004
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Access object DS
      *
      **  Data structure for rearranging date
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Long data structure for access objects                                               196833
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
      *                                                                                       196833
      *****************************************************************
      *               Index to subroutines                            *
      *               ~~~~~~~~~~~~~~~~~~~~                            *
      *  main process                                                 *
      *  REF     - Process message reference file                     *
      *  DETL    - Process message detail file                        *
      *  FLDPRC  - Process field                                      *
      *  MLTTRN  - Process multiple TRN field                         *
      *  HEADR   - Format message header                              *
      *  MIDHDR  - Output MIDAS details in message header             *
      *  EXTHDR  - Output external system details in message header   *
      *  DESTAD  - Format Msg tytpe/Destination/Sender                *
      *  NETSW   - SWIFT/STTX message details                         *
      *  NETTL   - Telex message details                              *
      *  NETUR   - 'UNable to ROUTe' details                          *
      *  MESST   - Output message status                              *
      *  CONFST  - Output confirmation status                         *
      *  HDDET   - Output header details                              *
      *  SWADDR  - Access Name/Town for SWIFT address                 *
      *  STADDR  - Access Name/Town for STTX address                  *
      *  TXADDR  - Access Name/Town for Telex address                 *
      *  PAPER   - Clear Name/Town fields for paper messages          *
      *  CASR    - Format CCY/AMOUNT subfield                         *
      *  ASR     - Format AMOUNT subfield                             *
      *  DSR     - Format DATE subfield                               *
      *  CATCH   - Catchall format for non-blank but unrecognised     *
      *            format code                                        *
      *  DCASR   - Format DATE/CCY/AMOUNT subfield                    *
      *  *PSSR   - error handling                                     *
      *****************************************************************
      *
     C/EJECT
      *****************************************************************
      *   main processs                                               *
      *   Calls - REF & DETL                                          *
      *****************************************************************
      *                                                                                       CSW207
      **  Declaring program variables                                                         CSW207
      *                                                                                       CSW207
     C                   MOVEL     *BLANKS       @RTCD             7            Return Code
     C                   MOVEL     *BLANKS       @OPTN             7            Option
     C                   MOVEL     *BLANKS       @SARD             6            Switchable feature
     C                   MOVEL     *BLANKS       CSW024            1
     C                   MOVEL     *BLANKS       CSW207            1
     C                   MOVEL     *BLANKS       TINO             25
     C                   MOVEL     *BLANKS       IDNO             15
      *
      **  Access RUNDAT to find run date format
      *
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C     *LOCK         IN        DSRUN
     C                   OUT       DSRUN
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTRN             16
     C                   PARM                    PMBI              1
     C                   PARM                    PBGCFM            1
     C                   PARM                    PERR              1
      *
      ** Set up copyright statement
     C                   MOVEA     CPY@          BIS@             80
      *
      ** Set up LDA for database errors
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'ME0800'      DBPGM
     C                   OUT       LDA
      *
      ** Set up key to MTAG file
     C     MGTAGK        KLIST
     C                   KFLD                    MTAGK             5
     C                   KFLD                    MTPYK             3
      *                                                                   CSW098
     C     KMTAG         KLIST                                                                 CSW09
     C                   KFLD                    MTAGK                                         CSW09
     C                   KFLD                    MTPYK                                         CSW09
     C                   KFLD                    MSEQN             3                           CSW09
      *                                                                   183583
      ** Set up key for extension file.                                   183583
      *                                                                   183583
     C     KEXTN         KLIST                                                                 18358
     C                   KFLD                    TRNO                                          18358
     C                   KFLD                    MTPY                                          18358
     C                   KFLD                    @V                2 0                         18358
      *
      ** Set up PLIST for ZM0100 Confirmation Matching program
     C     PCFM          PLIST
     C                   PARM                    CFTRN            16
     C                   PARM      *ZEROS        CFCPY             2 0
     C                   PARM      *ZEROS        CFBRK             2 0
     C                   PARM      *BLANKS       CFERR             1
      *
      ** Set up parameters for data queue
     C                   MOVEL     'MEDTQPRT'    DTAQ             10
     C                   MOVEL     'QTEMP'       LIB              10
     C                   Z-ADD     125           LEN               5 0
     C     DATA          PLIST
     C                   PARM                    DTAQ
     C                   PARM                    LIB
     C                   PARM                    LEN
     C                   PARM                    SDTAQ
      *
      ** Access SDMGMEPD for verification flag via the access program.
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      '01'          DBASE                           ***********
     C                   MOVEL     'SDMGMEPD'    DBFILE                          * DBERR 1 *
     C                   MOVEL     @OPTN         DBKEY                           ***********
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *                                                                   CSW098
      ** Check if (CSW098) SWIFT 1998 changes is on                       CSW098
      *                                                                   CSW098
     C                   CALL      'SWIFT98'                            7676                   CSW09
     C                   PARM      *BLANKS       CSW098            7                           CSW09
      *                                                                   CSW098
     C     *IN76         IFEQ      '1'                                                         CSW09
     C     *LOCK         IN        LDA                                                         CSW09
     C                   MOVE      '006'         DBASE                                         CSW09
     C                   MOVEL     'SWIFT98 '    KEY16                                         CSW09
     C                   MOVE      'ERROR   '    KEY16            16            * * * * * * * *CSW09
     C                   MOVEL     KEY16         DBKEY                          *  DBERR 006  *CSW09
     C                   MOVEL     *BLANKS       DBFILE                         * * * * * * * *CSW09
     C                   MOVE      '1'           PERR                                          CSW09
     C                   OUT       LDA                                                         CSW09
     C                   EXSR      *PSSR                                                       CSW09
     C                   END                                                                   CSW09
     C*                                                                   S01408
      ** Check if (CSW207) SWIFT 2007 changes is on                                           CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'
     C                   PARM      *BLANKS       @RTCD
      *                                                                                       CSW207
     C     @RTCD         IFEQ      'CSW2007'
     C                   MOVEL     'Y'           CSW207
     C                   ELSE
     C                   MOVEL     'N'           CSW207
     C                   ENDIF
      **********                                                                     CSW207 BUG14915
      ****Check*if*CSW024*is*switched**ON                                            CSW207 BUG14915
      **********                                                                     CSW207 BUG14915
     C**********           CALL 'AOSARDR0'                                           CSW207 BUG14915
     C**********           PARM *BLANKS   @RTCD                                      CSW207 BUG14915
     C**********           PARM '*VERIFY' @OPTN                                      CSW207 BUG14915
     C**********           PARM 'CSW024'  @SARD                                      CSW207 BUG14915
      **********                                                                     CSW207 BUG14915
     C********** @RTCD     IFNE *BLANK                                               CSW207 BUG14915
     C********** @RTCD     ANDNE'*NRF'                                               CSW207 BUG14915
     C********** *LOCK     IN   LDA                                                  CSW207 BUG14915
     C**********           MOVE '008'     DBASE             ***********              CSW207 BUG14915
     C**********           MOVEL'SCSARDPD'DBFILE            * DBERR 8 *              CSW207 BUG14915
     C**********           MOVEL'CSW024'  DBKEY             ***********              CSW207 BUG14915
     C**********           MOVE '1'       PERR                                       CSW207 BUG14915
     C**********           OUT  LDA                                                  CSW207 BUG14915
     C**********           EXSR *PSSR                                                CSW207 BUG14915
     C**********           END                                                       CSW207 BUG14915
      **********                                                                     CSW207 BUG14915
     C********** @RTCD     IFEQ *BLANKS                                              CSW207 BUG14915
     C**********           MOVE 'Y'       CSW024                                     CSW207 BUG14915
     C**********           ELSE                                                      CSW207 BUG14915
     C**********           MOVE 'N'       CSW024                                     CSW207 BUG14915
     C**********           ENDIF                                                     CSW207 BUG14915
      **********                                                                     CSW207 BUG14915
     C/COPY WNCPYSRC,ME0800CCP1                                           S01408
     C*                                                                   S01408
      **  Access Switchable features file for CME001                                          CME001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       ULRTCD            7
     C                   PARM      '*VERIFY'     ULOPTN            7
     C                   PARM      'CME001'      ULSARD            6
      *                                                                                       CME001
     C     ULRTCD        IFEQ      *BLANK
     C                   MOVE      'Y'           CME001            1
     C                   ELSE
     C                   MOVE      'N'           CME001
     C                   END
      *
      ** Process message reference
     C                   EXSR      REF
      *
      ** Process message detail
     C                   EXSR      DETL
      *
      ** End
     C/COPY WNCPYSRC,ME0800C020
     C                   SETON                                        LR
      *
     C/EJECT
      *****************************************************************
      *   REF - Process Message reference file                        *
      *   Called by - Main processing                                 *
      *   Calls - *PSSR & HEADR                                       *
      *****************************************************************
      *
     C     REF           BEGSR
      *
      ** Access message reference file for TRN passed in as parameter
     C     PTRN          CHAIN     MGOREFL0                           97
      *
     C     *IN97         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '02'          DBASE                           ***********
     C                   MOVE      'MGOREF'      DBFILE                          * DBERR 2 *
     C                   MOVE      PTRN          DBKEY                           ***********
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      ** If multiple message go to first part
     C     TRNF          IFNE      *BLANKS
      *
     C     TRNF          CHAIN     MGOREFL0                           97
      *
     C     *IN97         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '03'          DBASE                           ***********
     C                   MOVE      'MGOREF'      DBFILE                          * DBERR 3 *
     C                   MOVE      TRNF          DBKEY                           ***********
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
      *
      ** Save status information for header
     C                   MOVEL     MGST          SAVSTS            4
     C                   MOVEL     MGSG          SAVGRP            1
      *
      ** Establish whether message is a multiple
     C     TRNM          IFNE      *BLANKS
     C                   MOVEL     'Y'           MULT              1
     C                   END
     C/COPY WNCPYSRC,ME0800C015
      *
      ** Format the message heading and output to DATAQ/MEDTQPRT
     C                   EXSR      HEADR
      *
      ** Print a blank line
     C                   MOVE      *BLANKS       SDTAQ
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C/COPY WNCPYSRC,ME0800C022
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *   DETL - Process message detail file                          *
      *   Called by - Main process                                    *
      *   Calls - *PSSR & FLDPRC                                      *
      *****************************************************************
      *
     C     DETL          BEGSR
      *
     C     TRNO          CHAIN     MGOMSGPD                           99
      *
      ** DBASE error if no matching record or EOF
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '04'          DBASE                           ***********
     C                   MOVE      'MGOMSG'      DBFILE                          * DBERR 4 *
     C                   MOVE      TRNO          DBKEY                           ***********
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
      ** Save TRN this message
     C                   ELSE
     C                   MOVEL     TRNO          TRNSAV           16
     C** Initialise field 87 flag.                                        121288
     C                   MOVE      'N'           WTAG87            1                           12128
     C/COPY WNCPYSRC,ME0800C002
      *
      ** Read remaining records
      *                                                                                       206803
     C     MTPY          IFEQ      '103'
     C     MTAG          ANDEQ     ':119:'
     C     MTPY          OREQ      '202'
     C     MTAG          ANDEQ     ':119:'
     C     MTPY          OREQ      '103'
     C     MTAG          ANDEQ     ':121:'
     C     MODI          ANDNE     'FT'                                                     MD057490
     C     MTPY          OREQ      '202'
     C     MTAG          ANDEQ     ':121:'
     C     MODI          ANDNE     'FT'                                                     MD057490
     C                   MOVE      'Y'           W#RSET            1
     C                   ELSE
     C                   MOVE      'N'           W#RSET
     C                   ENDIF
      *                                                                                       206803
     C                   MOVE      'N'           @MARK             1
     C     MTPY          IFEQ      '202'
     C     MTAG          ANDEQ     ':119:'
     C     MFLD          ANDEQ     'COV'
     C                   MOVE      'Y'           @MARK
     C                   ENDIF
      *                                                                                     MD052485
     C                   Z-ADD     1             @V                                            18358
     C     *IN99         DOWEQ     '0'
      *
      ** Perform detail processing
     C                   EXSR      FLDPRC
     C     TRNSAV        READE     MGOMSGPD                               99
      *                                                                                       206803
     C     W#RSET        IFEQ      'Y'
     C                   Z-ADD     1             @V
     C                   MOVE      'N'           W#RSET
     C                   ELSE
     C                   ADD       1             @V                                            18358
     C                   ENDIF
      *
     C     @MARK         IFEQ      'Y'
     C                   MOVE      'Y'           W#RSET
     C                   MOVE      'N'           @MARK
     C                   ENDIF
      *                                                                                     MD052485
     C                   END
     C                   END
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   FLDPRC - Process Field                                      *
      *   Called by - DETL                                            *
      *   Calls - MLTTRN & QSNDDTAQ                                   *
      *****************************************************************
      *
     C     FLDPRC        BEGSR
      *
      ** Clear dataqueue DS
     C                   MOVE      *BLANKS       SDTAQ
      *
      ** Initialise tag format field
     C                   MOVE      *BLANKS       EFTAGF
     C***********          MOVE *BLANKS   SAVTAG                          043888
     C                   MOVE      *BLANKS       SSWFD
     C                   MOVE      *BLANKS       SMTAG
     C                   MOVE      *BLANKS       SMFLD
      *
      ** If message tag is not blank
     C     MTAG          IFNE      *BLANKS
      *
      ** Save MTAG
     C                   MOVEL     MTAG          SAVTAG            5
      *
      ** If multiple message and tag is TRN of part
     C     MULT          IFEQ      'Y'
      *
     C                   MOVEL     MTPY          TRNTGK            7
     C                   MOVEL     MTAG          CHAR4             4
     C                   MOVE      CHAR4         TRNTGK
     C     TRNTGK        LOOKUP    TRNTG                                  10
      *
     C     *IN10         IFEQ      '1'
     C/COPY WNCPYSRC,ME0800C003
      *
      ** Process multiple TRN field tag
     C                   EXSR      MLTTRN
     C/COPY WNCPYSRC,ME0800C004
     C                   END
      *
     C                   END
      *
      ** Clear dataqueue DS
     C                   MOVE      *BLANKS       SDTAQ
      *
      ** Use message tag and message type to access field tag
      ** reference file
     C                   MOVEL     MTAG          MTAGK
     C                   MOVEL     MTPY          MTPYK
     C*                                                                   CSW098
     C** If SWIFT 1998 changes is installed, consider message sequence    CSW098
     C** as well                                                          CSW098
     C*                                                                   CSW098
     C     CSW098        IFEQ      'CSW098 '                                                   CSW09
     C     MSEQ          ANDNE     *BLANKS                                                     CSW09
     C*  Search 1: type specific, sequence specific                       CSW098
     C                   MOVEL     MSEQ          MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           98              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C*  Search 2: type specific, sequence generic (blank)                CSW098
     C******IN98         IFEQ      '1'                                                CSW09 MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     *BLANKS       MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           98              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*  Search 3: type generic ('ALL'), sequence specific                CSW098
     C******IN98         IFEQ      '1'                                                CSW09 MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         MTPYK                                         CSW09
     C                   MOVEL     MSEQ          MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           98              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*  Search 4: type generic ('ALL'), sequence generic (blank)         CSW098
     C******IN98         IFEQ      '1'                                                CSW09 MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     *BLANKS       MSEQN                                         CSW09
     C*****KMTAG         CHAIN     SDMTAGL0                           98              CSW09 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK and EFMSEQ = :MSEQN                       MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*                                                                   CSW098
     C                   ELSE                                                                  CSW09
     C*                                                                   CSW098
     C*****MGTAGK        CHAIN     SDMTAGL0                           98                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK                                           MD056560
     C/END-EXEC                                                                             MD056560
      *
      ** If no record found just use message tag to access field tag
      ** reference file
     C******IN98         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVE      'ALL'         MTPYK
     C*****MTAGK         CHAIN     SDMTAGL0                           98                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK                                                               MD056560
     C/END-EXEC                                                                             MD056560
     C                   ENDIF                                                                 CSW09
     C*                                                                   CSW098
     C                   ENDIF                                                                 CSW09
      *
      ** If no record found put <TAG DESCRIPTION NOT FOUND> into
      ** Message Tag Description part of data queue
     C******IN98         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     TXT(36)       SSWFD
     C                   END
     C***********          END                                            CSW098
      *
      ** If record tag found move description into corresponding part
      ** of data queue
     C******IN98         IFEQ      '0'                                                      MD056560
     C     SQLCODE       IFEQ      0                                                        MD056560
     C                   MOVEL     EFRPFD        SSWFD
      ** If the second occurrence of field 87 in an MT512 then overide    121288
      ** the description to read 'Deliverer of Securities'.               121288
     C     MTPY          IFEQ      '512'                                                       12128
     C     #TAG23        IFEQ      '87'                                                        12128
     C     WTAG87        IFEQ      'Y'                                                         12128
     C                   MOVE      *BLANKS       SSWFD                                         12128
     C                   MOVEL     TXT(42)       SSWFD                                         12128
     C                   ELSE                                                                  12128
     C                   MOVE      'Y'           WTAG87                                        12128
     C                   END                                                                   12128
     C                   END                                                                   12128
     C                   END                                                                   12128
     C                   END
      *
      **  Move MTAG into corresponding part of data queue
     C                   MOVEL     MTAG          SMTAG
      *
     C                   END
      *                                                                   140629
      ** If /OCMT/ or /CHGS/ then change comma in amount to decimal       140629
      ** point.                                                           140629
      *                                                                   140629
     C     '/OCMT/'      SCAN      MFLD:1                                 81                   14062
      *                                                                   140629
     C     *IN81         IFEQ      *OFF                                                        14062
     C     '/CHGS/'      SCAN      MFLD:1                                 81                   14062
     C                   ENDIF                                                                 14062
      *                                                                   140629
     C     *IN81         IFEQ      *ON                                                         14062
      *                                                                   140629
      ** If ',' in amount change to '.'                                   140629
      *                                                                   140629
     C     ',':'.'       XLATE     MFLD          MFLD                                          14062
     C                   ENDIF                                                                 14062
      *                                                                   140629
      *
      ** Check for verification field
     C/COPY WNCPYSRC,ME0800C005
     C                   MOVEL     MTPY          VERFYK            6
     C                   MOVEL     SAVTAG        CHAR3             3
     C                   MOVE      CHAR3         VERFYK
     C/COPY WNCPYSRC,ME0800C006
     C     VERFYK        LOOKUP    VERFY                                  10
     C/COPY WNCPYSRC,ME0800C009
      * Always set off verification field indicator if CME001 is on.                          CME001
     C     CME001        IFEQ      'Y'
     C                   SETOFF                                       10
     C                   ENDIF
      *
      ** If verification is on AND field is verification field AND
      ** messsage is not released
     C     ENVPM         IFEQ      'Y'
     C     *IN10         ANDEQ     '1'
     C     SAVGRP        ANDEQ     '1'
      *
      ** Move <NOT VERIFIED> into message data field part of data queue
     C/COPY WNCPYSRC,ME0800C013
     C                   MOVEL     TXT(37)       SMFLD
     C/COPY WNCPYSRC,ME0800C014
      *
      ** Otherwise print message data
     C                   ELSE
     C/COPY WNCPYSRC,ME0800C010
      *
     C     EFTAGF        IFNE      *BLANKS
      *
      ** Call appropriate formatting subroutine if required
     C     EFTAGF        CASEQ     'CA '         CASR
     C     EFTAGF        CASEQ     'DCA'         DCASR
     C     EFTAGF        CASEQ     'DT'          DTSR                                          CSW09
     C     EFTAGF        CASEQ     'A'           ASR
     C     EFTAGF        CASEQ     'D'           DSR
     C                   CAS                     CATCH
     C                   END
      *
     C                   ELSE
      *
      **  If saved field tag is an address and the first character
      **  is not a '/'
     C                   MOVEA     SAVTAG        TG
     C                   MOVEL     MFLD          CHAR1             1
     C     TG(2)         IFEQ      '5'
     C     TG(4)         ANDEQ     'A'
     C***********CHAR1     ANDNE'/'                                       183583
     C     CHAR1         ANDNE     '/'
     C********** TG,2      OREQ '5'                                                  CSW207 BUG14915
     C********** TG,4      ANDEQ'F'                                                  CSW207 BUG14915
     C********** CHAR1     ANDNE'/'                                                  CSW207 BUG14915
     C     SAVTAG        OREQ      ':50F:'
     C     TG(2)         OREQ      '8'                                                         CSW09
     C     TG(4)         ANDEQ     'A'                                                         CSW09
     C     TG(2)         OREQ      '9'                                                         CSW09
     C     TG(4)         ANDEQ     'P'                                                         CSW09
     C     TG(2)         OREQ      '9'
     C     TG(4)         ANDEQ     'A'
     C     CHAR1         ANDNE     '/'
      *                                                                                       204225
     C********** CSW207    IFEQ 'Y'                                                  CSW207 BUG14915
     C                   MOVE      CHAR3         CHR3              1
     C                   MOVE      '1'           *IN05
     C     TG(2)         IFEQ      '5'
     C     CHR3          ANDEQ     '0'
     C     TG(4)         ANDEQ     'A'
     C********** TG,4      ANDEQ'F'                                                  CSW207 BUG14915
     C     TG(4)         ANDEQ     'A'
     C********** CSW024    IFEQ 'Y'                                                  CSW207 BUG14915
     C     TG(2)         OREQ      '9'
     C     TG(4)         ANDEQ     'A'
     C                   MOVEL     MFLD          WBEI             11
     C     WBEI          CHAIN     SDCUSTBE                           05
     C                   MOVE      *BLANKS       ZCUST
     C**********           ENDIF                                                     CSW207 BUG14915
     C**********           ENDIF                                                     CSW207 BUG14915
     C                   ENDIF
      *
      ** Execute S/R SWADDR to pick up name/town for this SWIFT address
      *                                                                   S01435
      *  Format as SWIFT device print remove SWADDR processing            S01435
      *                                                                   S01435
     C***************      MOVELMFLD      ZADDR                           S01435
     C***************      EXSR SWADDR                                    S01435
     C***************      MOVELMFLD      F5NA   50                       S01435
     C***************      MOVE ZNAME     F5NA                            S01435
     C***************      MOVELZTOWN     @WK10  10                 E42972S01435
     C***************      MOVE @WK10     F5NA                      E42972S01435
     C***************      MOVELF5NA      SMFLD                           S01435
      *                                                                   S01435
      *  Information now displayed on lines after BIC as per SWIFT        S01435
      *  Standard                                                         S01435
      *                                                                   S01435
     C                   MOVEL     MFLD          SMFLD                                         S0143
     C     *IN05         IFEQ      '1'
     C                   EXSR      SEXTNR                                                      18358
     C                   ENDIF
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
      *                                                                   S01435
      *  Call Access object to validate identifier                        S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
     C     TG(4)         IFEQ      'P'                                                         CSW09
     C     8             SUBST     MFLD:8        W9BICC                                        CSW09
     C     3             SUBST     MFLD:16       W9BICB                                        CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEL     MFLD          W9BICC                                        S0143
     C     3             SUBST     MFLD:9        W9BICB                                        S0143
     C                   ENDIF                                                                 CSW09
      *                                                                   S01435
     C     TG(2)         IFEQ      '5'                                                         18358
     C     TG(4)         ANDEQ     'A'                                                         18358
     C********** TG,2      OREQ '5'                                                  CSW207 BUG14915
     C********** TG,4      ANDEQ'F'                                                  CSW207 BUG14915
     C********** CSW207    ANDEQ'Y'                                                  CSW207 BUG14915
     C     SAVTAG        OREQ      ':50F:'
     C     TG(2)         OREQ      '8'                                                         18358
     C     TG(4)         ANDEQ     'A'                                                         18358
     C     ZCUST         IFNE      *BLANKS                                                     15865
     C                   MOVE      *BLANKS       W9BICC                                        18358
     C                   MOVEL     ZCUST         W9BICC                                        18358
     C                   ENDIF                                                                 15865
     C                   ENDIF                                                                 18358
     C                   CALL      'ME1400'                                                    S0143
     C                   PARM      *BLANKS       W9RTN             7                           S0143
     C                   PARM                    W9BICC            8                           S0143
     C                   PARM                    W9BICB            3                           S0143
     C                   PARM                    SDCUST                                        S0143
     C                   PARM                    SDCNST                                        S0143
     C                   PARM                    MEBICD                                        S0143
     C                   PARM      *BLANKS       W9CUST            1                           S0143
     C                   PARM      *BLANKS       W9CNST            1                           S0143
     C                   PARM      *BLANKS       W9BICD            1                           S0143
      *                                                                   S01435
     C                   SELECT                                                                S0143
      *                                                                   S01435
      *  Record not found - S.W.I.F.T does not exist                      S01435
      *                                                                   S01435
     C     W9RTN         WHENEQ    'Y2U0005'                                                   S0143
      * No action                                                         S01435
      *                                                                   S01435
     C                   GOTO      FLEXIT                                                      S0143
      *                                                                   S01435
      *  Use data depending on file that the data exists on               S01435
      *                                                                   S01435
     C     W9BICD        WHENEQ    'Y'                                                         S0143
      *                                                                   S01435
      * Format First Line for screen                                      S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C                   MOVEL     BDINS1        #RPT1                                         S0143
      *                                                                   S01435
      *  Check fields not concatenated                                    S01435
      *                                                                   S01435
     C     1             SUBST     BDINS2:1      ##001             1                           S0143
     C     ##001         IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BDINS2        #RPT2                                         S0143
     C                   ELSE                                                                  S0143
     C     18            SUBST     BDINS2:2      #RPT2                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
      *                                                                   S01435
      * Format Second Line for screen                                     S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C                   MOVEL     BDCITY        #RPT1                                         S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
      *                                                                   S01435
      * Format Third Line for screen                                      S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BDBRC1        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BDBRC1        #RPT1                                         S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
     C                   GOTO      FLEXIT                                                      S0143
      *                                                                   S01435
     C     W9CUST        WHENEQ    'Y'                                                         S0143
      *                                                                   S01435
      * Format Customer Name and Town                                     S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BBCRNM        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BBCRNM        #RPT1                                         S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
     C                   END                                                                   S0143
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BBCRTN        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BBCRTN        #RPT1                                         S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
     C                   GOTO      FLEXIT                                                      S0143
      *                                                                   S01435
     C     W9CNST        WHENEQ    'Y'                                                         S0143
      *                                                                   S01435
      * Format Counterparty Name and Town                                 S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     AWCPNM        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     AWCPNM        #RPT1                                         S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
     C                   END                                                                   S0143
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C***********BBCRNM    IFNE *BLANKS                            S01435 099234
     C     AWCNTN        IFNE      *BLANKS                                                     09923
     C                   MOVEL     AWCNTN        #RPT1                                         S0143
      *                                                                   S01435
      *  Send report line to Data queue                                   S01435
      *                                                                   S01435
     C                   MOVEL     BICLAY        SDTAQ                                         S0143
     C                   CALL      'QSNDDTAQ'    DATA                                          S0143
     C                   MOVEL     *BLANKS       SDTAQ                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
     C                   GOTO      FLEXIT                                                      S0143
      *                                                                   S01435
     C                   ENDSL                                                                 S0143
      *
     C                   ELSE
      *
      ** If no formatting code and not an address move data to display
      ** field without further processing
     C                   MOVEL     MFLD          SMFLD
      *
     C                   END
      *
     C                   END
     C/COPY WNCPYSRC,ME0800C011
      *
     C                   END
     C/COPY WNCPYSRC,ME0800C012
      *
      ** Send report line to Data queue
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C     FLEXIT        TAG                                                                   S0143
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   MLTTRN - Process multiple TRN field                         *
      *   Called by - FLDPRC                                          *
      *   Calls - QSNDDTAQ, *PSSR                                     *
      *****************************************************************
      *
     C     MLTTRN        BEGSR
      *
      **  Access message reference file using transaction reference
      **  of next part (210) or contents of :20: (203)
     C     MTPY          IFEQ      '210'
     C                   MOVEL     TRNM          MTKEY            16
     C                   ELSE
     C                   MOVEL     MFLD          MTKEY
     C                   END
     C/COPY WNCPYSRC,ME0800C007
     C     MTKEY         CHAIN     MGOREFL0                           97
      *
     C     *IN97         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '05'          DBASE                           ***********
     C                   MOVE      'MGOREF'      DBFILE                          * DBERR 5 *
     C                   MOVE      MTKEY         DBKEY                           ***********
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,ME0800C008
      *
      ** Initialise Dataqueue
     C                   MOVEL     *BLANKS       SDTAQ
      *
      ** Send one blank line
     C                   CALL      'QSNDDTAQ'    DATA
      *
      ** Check if part mult message is deleted
     C     PTST          IFEQ      'D'
     C                   MOVEL     TXT(38)       SPTST
     C                   END
      *
      ** If Midas message output Midas transaction number
     C     SYTM          IFEQ      *BLANKS
     C     SYTM          OREQ      'MIDAS'
     C                   MOVEL     TXT(32)       TXT32
     C*                                                                   E43198
     C**  For MT210, output TRN, instead of Midas transaction number      E43198
     C*                                                                   E43198
     C     MTPY          IFEQ      '210'                                                       E4319
     C                   MOVEL     TRNO          SMTRN                                         E4319
     C                   ELSE                                                                  E4319
     C                   MOVEL     MTRN          SMTRN
     C                   END                                                                   E4319
      *
      ** and Transaction type
     C                   MOVEL     TXT(3)        TXT3A
     C                   MOVEL     TNTP          STNTP
      *
      ** and Sub-type
     C                   MOVEL     TXT(4)        TXT4A
     C                   MOVEL     SBTP          SSTYP
     C                   END
      *
      ** If confirmation matching is on ...
     C     PBGCFM        IFEQ      'Y'
      *
      ** Call standard program ZM0100 with param of tag-data to obtain
      ** confirmation matching status for this part
     C                   MOVEL     MTKEY         CFTRN
     C                   CALL      'ZM0100'      PCFM
      *
     C     CFERR         IFEQ      *BLANKS
     C                   MOVEL     TXT(33)       TXT33
     C     CFCPY         IFEQ      *ZEROS
     C                   MOVEL     '?'           SCFCY
     C                   ELSE
     C                   MOVEL     CFCPY         SCFCY
     C                   END
     C                   MOVEL     TXT(34)       TXT34
     C     CFBRK         IFEQ      *ZEROS
     C                   MOVEL     '?'           SCFBK
     C                   ELSE
     C                   MOVEL     CFBRK         SCFBK
     C                   END
     C                   END
      *
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   HEADR - Format  Message header                              *
      *   Called by - REF                                             *
      *   Calls - MIDHDR, EXTHDR, DESTAD, NETSW, NETTL, NETPP, NETUR  *
      *           MESST,CONFST, HDDET.                                *
      *****************************************************************
      *
     C     HEADR         BEGSR
     C/COPY WNCPYSRC,ME0800C016
      *
      ** If system field from MGOREF is blank output MIDAS message
      ** header
     C     SYTM          IFEQ      *BLANKS
     C     SYTM          OREQ      'MIDAS'
     C                   EXSR      MIDHDR
      *
      ** Else external system message
     C                   ELSE
     C                   EXSR      EXTHDR
     C                   END
      *
      ** Execute DESTAD to format message type/Sender's address/
      ** Destination address
     C                   EXSR      DESTAD
      *
      ** If network is SWIFT
     C     NWRK          IFEQ      'SWIFT'
     C     NWRK          OREQ      'STTX'
     C/COPY WNCPYSRC,ME0800C001
     C                   EXSR      NETSW
     C                   END
      *
      ** If network is TELEX
     C     NWRK          IFEQ      'TELEX'
     C                   EXSR      NETTL
     C                   END
      *
      ** If network is PAPER
     C     NWRK          IFEQ      'PAPER'
     C/COPY WNCPYSRC,ME0800C021
     C                   EXSR      NETPP
     C                   END
      *
      ** If network is UNROUT (ie. UNable to ROUTe)
     C     NWRK          IFEQ      'UNROUT'
     C                   EXSR      NETUR
     C                   END
      *
      ** Write message status
     C                   EXSR      MESST
      *
      ** If confirmation matching present & not multiple message
     C     PBGCFM        IFEQ      'Y'
     C     MULT          ANDNE     'Y'
      *
      ** Call standard program ZM0100 with TRNO to establish the
      ** confirmation status
     C                   MOVEL     PTRN          CFTRN
     C                   CALL      'ZM0100'      PCFM
      *
      ** Check for no errors
     C     CFERR         IFEQ      *BLANKS
      *
      ** Write confirmation status
     C                   EXSR      CONFST
     C                   END
      *
     C                   END
     C/COPY WNCPYSRC,ME0800C017
      *
      ** Print a blank line
     C                   MOVE      *BLANKS       SDTAQ
     C                   CALL      'QSNDDTAQ'    DATA
      *
      ** Write header for detail
     C                   EXSR      HDDET
      *
     C                   ENDSR
      *
     C/EJECT
      *****************************************************************
      *   MIDHDR - Output MIDAS details in message header             *
      *   Called by - HEADR SR                                        *
      *   Calls -   QSNDDTAQ                                          *
      *****************************************************************
      *
     C     MIDHDR        BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(1)        TEXT1
     C                   MOVEL     MODI          SMODI
      *
      ** If message generated by Midas (ie. not input via Message
      ** Management) output transaction details
     C     MODI          IFNE      'ME'
     C     MODI          ANDNE     'MX'                                                        E2958
      *
      ** If message is GL statement
     C     MODI          IFEQ      'GL'
     C                   MOVEL     TXT(40)       TXT35
     C                   MOVEL     SACN          SACCN
     C                   ELSE
      *
      ** If not multiple message
     C     MULT          IFNE      'Y'
     C                   MOVEL     TXT(2)        TEXT2
     C                   MOVEL     MTRN          STRNM
     C                   MOVEL     TXT(3)        TEXT3
     C                   MOVEL     TNTP          STNTY
     C                   MOVEL     TXT(4)        TEXT4
     C                   MOVEL     SBTP          SSBTP
     C                   END
      *
     C                   END
      *
     C                   ELSE                                                                  E2958
     C                   MOVEL     TXT(41)       TXT41                                         E2958
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   EXTHDR Process Message reference file                       *
      *   Called by - HEADR SR                                        *
      *   Calls -   QSNDDTAQ                                          *
      *****************************************************************
      *
     C     EXTHDR        BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(1)        TEXT1
     C                   MOVEL     MODI          SMODI
     C                   MOVEL     TXT(5)        TEXT5
     C                   MOVEL     SYTM          SXSYS
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   DESTAD Format Msg type/Sender/Destination                   *
      *   Called by - HEADR SR                                        *
      *   Calls -  SWADDR, STADDR, TXADDR, PAPER, QSNDDTAQ            *
      *****************************************************************
      *
     C     DESTAD        BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(6)        TEXT6
     C                   MOVEL     NWSN          SSADR
     C                   MOVEL     TXT(7)        TEXT7
     C                   MOVEL     MTPY          SMTPY
      *
      ** Access message type description
     C     MTPY          CHAIN     SDMTPYL0                           96
     C     *IN96         IFEQ      '1'
      *
      ** If not found move <MSG DESC NOT FOUND> INTO DATA QUEUE
     C                   MOVEL     TXT(39)       SMTPD
     C                   ELSE
     C                   MOVEL     EEMTPD        SMTPD
     C                   END
     C                   CALL      'QSNDDTAQ'    DATA
      *
      ** Format destination address
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(8)        TEXT8
     C                   MOVEL     NWDS          SNWDS
      *
      * Access appropriate subroutine, according to network
     C                   MOVEL     NWDS          ZADDR
     C                   MOVEL     DECN          ZCUST             8                           18358
     C                   EXSR      SRDEST
     C/COPY WNCPYSRC,ME0800C018
     C     NWRK          CASEQ     'SWIFT'       SWADDR
     C     NWRK          CASEQ     'STTX'        STADDR
     C     NWRK          CASEQ     'TELEX'       TXADDR
     C                   CAS                     PAPER
     C                   END
     C                   MOVEL     ZNAME         SREPN
     C                   MOVEL     ZTOWN         STOWN
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   NETSW - SWIFT/STTX message details                          *
      *   Called by - HEADR SR                                        *
      *   Calls - QSNDDTAQ                                            *
      *****************************************************************
      *
     C     NETSW         BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(9)        TEXT9
     C                   MOVEL     NWRK          SNWRK
     C                   MOVEL     TXT(10)       TXT10
     C     MPRY          IFEQ      'U'
     C                   MOVEL     'URGENT'      SMPRY
     C                   END
     C     MPRY          IFEQ      'N'
     C                   MOVEL     'NORMAL'      SMPRY
     C                   END
     C                   MOVEL     TXT(11)       TXT11
      *
      ** Change date from YYMMDD to DDMMMYY
     C                   MOVEL     MGDE          DAT
     C                   MOVEL     DD            DD2
     C     MM            LOOKUP    TABMM         TABMON                   50
     C                   MOVE      TABMON        MM2
     C                   MOVEL     YY            YY2
     C                   MOVEL     DAT2          SMGDE
     C                   MOVEL     TXT(12)       TXT12
     C                   MOVEL     TXT(13)       TXT13
      *
      **  Check delivery notification
     C     DELC          IFEQ      '2'
     C     DELC          OREQ      '3'
     C                   MOVEL     'Y'           SDELC
     C                   ELSE
     C                   MOVEL     'N'           SDELC
     C                   END
      *
      **  Check non-delivery warning
     C     DELC          IFEQ      '1'
     C     DELC          OREQ      '3'
     C                   MOVEL     'Y'           SDELW
     C                   ELSE
     C                   MOVEL     'N'           SDELW
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   NETTL - Telex message details                               *
      *   Called by - HEADR SR                                        *
      *   Calls -     QSNDDTAQ                                        *
      *****************************************************************
      *
     C     NETTL         BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(9)        TEXT9
     C                   MOVEL     NWRK          SNWRK
     C                   MOVEL     TXT(10)       TXT10
     C     MPRY          IFEQ      'U'
     C                   MOVEL     'URGENT'      SMPRY
     C                   END
     C     MPRY          IFEQ      'N'
     C                   MOVEL     'NORMAL'      SMPRY
     C                   END
     C                   MOVEL     TXT(11)       TXT11
      *
      ** Change date from YYMMDD to DDMMMYY
     C                   MOVEL     MGDE          DAT
     C                   MOVEL     DD            DD2
     C     MM            LOOKUP    TABMM         TABMON                   50
     C                   MOVE      TABMON        MM2
     C                   MOVEL     YY            YY2
     C                   MOVEL     DAT2          SMGDE
      *
      ** If message is unreleased print testkey required, yes or no.
     C                   MOVE      *BLANKS       STSKS
     C                   MOVE      *BLANKS       TXT14
     C     MGSG          IFEQ      '1'
     C                   MOVEL     TXT(14)       TXT14
     C     TSKS          IFEQ      'Y'
     C                   MOVEL     'Yes'         STSKS
     C                   ELSE
     C                   MOVEL     'No '         STSKS
     C                   END
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   NETPP - Paper message details                               *
      *   Called by - HEADR SR                                        *
      *   Calls - QSNDDTAQ                                            *
      *****************************************************************
      *
     C     NETPP         BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(9)        TEXT9
     C                   MOVEL     NWRK          SNWRK
     C                   MOVEL     TXT(11)       TXT11
      *
      ** Change date from YYMMDD to DDMMMYY
     C                   MOVEL     MGDE          DAT
     C                   MOVEL     DD            DD2
     C     MM            LOOKUP    TABMM         TABMON                   50
     C                   MOVE      TABMON        MM2
     C                   MOVEL     YY            YY2
     C                   MOVEL     DAT2          SMGDE
      *
      ** Paper info - identify all messages as copies (*** COPY ***)
     C                   MOVEL     TXT(16)       TXT16
      *
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   NETUR - 'Unable to route' message details                   *
      *   Called by - HEADR SR                                        *
      *   Calls - QSNDDTAQ                                            *
      *****************************************************************
      *
     C     NETUR         BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(9)        TEXT9
     C                   MOVEL     NWRK          SNWRK
     C                   MOVEL     TXT(11)       TXT11
      *
      ** Change date from YYMMDD to DDMMMYY
     C                   MOVEL     MGDE          DAT
     C                   MOVEL     DD            DD2
     C     MM            LOOKUP    TABMM         TABMON                   50
     C                   MOVE      TABMON        MM2
     C                   MOVEL     YY            YY2
     C                   MOVEL     DAT2          SMGDE
     C                   MOVEL     TXT(16)       TXT16
      *
     C                   CALL      'QSNDDTAQ'    DATA
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   MESST - Output message status                               *
      *   Called by - HEADR SR                                        *
      *   Calls -  QSNDDTAQ                                           *
      *****************************************************************
      *
     C     MESST         BEGSR
      *
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(17)       TXT17
      *
      ** Use status code to look-up narrative. If entry found move
      ** narrative to report field, otherwise just report code.
     C     SAVSTS        LOOKUP    TABCD         TABNAR                   50
     C     *IN50         IFEQ      '1'
     C                   MOVEL     TABNAR        SMGST
     C                   ELSE
      *                                                                   S01408
     C/COPY WNCPYSRC,ME0800CCP6                                           S01408
      *                                                                   S01408
     C                   MOVEL     SAVSTS        SMGST
     C                   END
      *                                                                   S01408
     C/COPY WNCPYSRC,ME0800CCP7                                           S01408
      *                                                                   S01408
      *
     C                   MOVEL     TXT(18)       TXT18
     C                   MOVEL     LADT          SLADT
     C                   MOVEL     TXT(19)       TXT19
     C                   MOVEL     LATM          SLATM
      *
      **  If message negatively acknowledged print error code and line
     C     SAVGRP        IFEQ      '4'
     C     SAVSTS        ANDNE     'DLTD'
     C     MSE1          ANDNE     *BLANKS                                                     E2958
      *                                                                   E29588
      ** If ELIN does not contain numeric data it probably contains       E29588
      ** rubbish (ie. error is probably not in message text, so line      E29588
      ** number is not applicable). Output '---' instead.                 E29588
     C     ELIN          IFNE      *BLANKS                                                     E2958
     C                   TESTN                   ELIN                 75                       E2958
     C     *IN75         IFEQ      '0'                                                         E2958
     C                   MOVE      '---'         ELIN                                          E2958
     C                   END                                                                   E2958
     C                   END                                                                   E2958
      *
     C                   MOVEL     TXT(20)       TXT20
     C                   MOVEL     MSE1          SMSE1
     C                   MOVEL     ELIN          SELIN
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
      *
      ** If message released print user/workstation responsible
     C     SAVGRP        IFNE      '1'
     C     RUSR          ANDNE     *BLANKS                                                     E2958
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(21)       TXT21
     C                   MOVEL     RUSR          SRUSR
     C                   MOVEL     TXT(22)       TXT22
     C                   MOVEL     RWSN          SRWSN
      *
      ** If PDE on at time of release enable POSSIBLE DUPLICATE message
     C     MPDE          IFEQ      'Y'
     C                   MOVEL     TXT(23)       TXT23
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
     C                   END
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   CONFST - Output confirmation status                         *
      *   Called by - HEADR SR                                        *
      *   Calls - QSNDDTAQ                                            *
      *****************************************************************
      *
     C     CONFST        BEGSR
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(30)       TXT30
     C******************** MOVELTXT,30    TXT31                           E29588
     C                   MOVEL     TXT(31)       TXT31                                         E2958
      *
      **  Obtain narrative for CF match status - if status not found
      **  output code only
     C     CFCPY         LOOKUP    TAB1          TAB2                     65
     C     *IN65         IFEQ      '1'
     C                   MOVEL     TAB2          SCFCP
     C                   ELSE
     C                   MOVE      *BLANKS       SCFCP
     C                   MOVEL     CFCPY         SCFCP
     C                   END
     C     CFBRK         LOOKUP    TAB1          TAB2                     65
     C     *IN65         IFEQ      '1'
     C                   MOVEL     TAB2          SCFBR
     C                   ELSE
     C                   MOVE      *BLANKS       SCFBR
     C                   MOVEL     CFBRK         SCFBR
     C                   END
      *
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   HDDET - Output Header Details                               *
      *   Called by - HEADR SR                                        *
      *   Calls -  QSNDDTAQ                                           *
      *****************************************************************
      *
     C     HDDET         BEGSR
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(24)       TXT24
     C                   MOVEL     TXT(25)       TXT25
     C                   MOVEL     TXT(26)       TXT26
     C                   CALL      'QSNDDTAQ'    DATA
     C                   MOVEL     *BLANKS       SDTAQ
     C                   MOVEL     TXT(27)       TXT27
     C                   MOVEL     TXT(28)       TXT28
     C                   MOVEL     TXT(29)       TXT29
     C                   CALL      'QSNDDTAQ'    DATA
     C                   ENDSR
      /EJECT                                                              183583
      *****************************************************************   183583
      *                                                               *   183583
      *   SEXTNR - Reads MGOEXTPD to get the SWIFT ID's cust. no.     *   183583
      *                                                               *   183583
      *   Called by: FLDPRC                                           *   183583
      *   Calls    : None                                             *   183583
      *                                                               *   183583
      *****************************************************************   183583
      *                                                                   183583
     C     SEXTNR        BEGSR                                                                 18358
      *                                                                   183583
     C                   MOVE      *BLANKS       ZCUST                                         18358
     C     KEXTN         CHAIN     MGOEXTLF                           1616                     18358
     C     *IN16         IFEQ      '0'                                                         18358
     C                   MOVEL     MCSI          ZCUST                                         18358
     C                   ENDIF                                                                 18358
      *                                                                   183583
     C     SEXTN9        ENDSR                                                                 18358
     C/EJECT
     C/COPY WNCPYSRC,ME0800C019
      *****************************************************************
      *   SWADDR - Format Name/Town from SWIFT address                *
      *   Called by - FLDPRC, DESTAD                                  *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN, Customer/Counterparty town, 35A    *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     SWADDR        BEGSR
      *
      ** Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
      *
      ** Move standard address to SWIFT address key
     C                   MOVEL     ZADDR         SFWAD            12
      *
      ** First try customer file, SDCUST
     C     SFWAD         CHAIN     SDCUSTSW                           90
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     BBCUST        ANDNE     ZCUST                                                       18358
     C     SFWAD         READE     SDCUSTSW                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
     C     *IN90         IFEQ      '0'
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   ELSE
      *
      ** If not found on customer file, try C/Party Nostro file SDCNST
     C     SFWAD         CHAIN     SDCNSTSW                           90
      *                                                                   183583
      ** Check if correct Counterparty used is found.                     183583
      *                                                                   183583
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     AWCPNC        ANDNE     ZCUST                                                       18358
     C     SFWAD         READE     SDCNSTSW                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
     C     *IN90         IFEQ      '0'
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   ELSE                                                             X2   10750
      *                                                                   107503
      *  Call ME1400 to access BIC address                                107503
      *                                                                   107503
     C                   MOVE      SFWAD         W01BIC                                        10750
     C                   MOVE      W01ICC        W9BICC                                        10750
     C                   MOVE      W01ICB        W9BICB                                        10750
      *                                                                   107503
     C                   CALL      'ME1400'                                                    10750
     C                   PARM      *BLANKS       W9RTN             7                           10750
     C                   PARM                    W9BICC            8                           10750
     C                   PARM                    W9BICB            3                           10750
     C                   PARM                    SDCUST                                        10750
     C                   PARM                    SDCNST                                        10750
     C                   PARM                    MEBICD                                        10750
     C                   PARM      *BLANKS       W9CUST            1                           10750
     C                   PARM      *BLANKS       W9CNST            1                           10750
     C                   PARM      *BLANKS       W9BICD            1                           10750
      *                                                                   107503
      ** If record found on BIC file, use first line of name & city       107503
      *                                                                   107503
     C     W9BICD        IFEQ      'Y'                                                     3   10750
     C                   MOVEL     BDINS1        ZNAME                                         10750
     C                   MOVEL     BDCITY        ZTOWN                                         10750
     C                   MOVE      '0'           *IN90                                         10750
     C                   END                                                              E3   10750
     C                   END
     C                   END
      *
     C                   ENDSR                                                  SWADDR
     C/EJECT
      *****************************************************************
      *   STADDR - Format Name/Town from STTX address                 *
      *   Called by - DESTAD                                          *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN, Customer/Counterparty town, 35A    *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     STADDR        BEGSR
      *
      ** Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
      *
      ** Move standard address to STTX address key
     C                   MOVEL     ZADDR         STXAD            12
      *
      ** First try customer file, SDCUST
     C     STXAD         CHAIN     SDCUSTST                           90
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     BBCUST        ANDNE     ZCUST                                                       18358
     C     STXAD         READE     SDCUSTST                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
     C     *IN90         IFEQ      '0'
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   ELSE
      *
      ** If not found on customer file, try C/Party Nostro file SDCNST
     C     STXAD         CHAIN     SDCNSTST                           90
      *                                                                   183583
      ** Check if correct Counterparty used is found.                     183583
      *                                                                   183583
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     AWCPNC        ANDNE     ZCUST                                                       18358
     C     STXAD         READE     SDCNSTST                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
     C     *IN90         IFEQ      '0'
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   END
     C                   END
      *
     C                   ENDSR                                                  STADDR
     C/EJECT
      *****************************************************************
      *   TXADDR - Format Name/Town from TELEX address                *
      *   Called by - DESTAD                                          *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN, Customer/Counterparty town, 35A    *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     TXADDR        BEGSR
      *
      ** Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
      *
      ** Move standard address to TELEX address key
     C                   MOVEL     ZADDR         TLXAD            10
      *
      ** First try customer file, SDCUST
     C     TLXAD         CHAIN     SDCUSTTX                           90
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     BBCUST        ANDNE     ZCUST                                                       18358
     C     TLXAD         READE     SDCUSTTX                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
     C     *IN90         IFEQ      '0'
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   ELSE
      *
      ** If not found on customer file, try C/Party Nostro file SDCNST
     C     TLXAD         CHAIN     SDCNSTTX                           90
      *                                                                   183583
      ** Check if correct Counterparty used is found.                     183583
      *                                                                   183583
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     AWCPNC        ANDNE     ZCUST                                                       18358
     C     TLXAD         READE     SDCNSTTX                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
     C     *IN90         IFEQ      '0'
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   END
     C                   END
      *
     C                   ENDSR                                                  TXADDR
     C/EJECT
      *****************************************************************
      *   PAPER  - Clear Name/Town fields for paper messages          *
      *   Called by - DESTAD                                          *
      *   Standard output - ZNAME, *BLANKS, 35A                       *
      *                     ZTOWN, *BLANKS, 35A                       *
      *****************************************************************
      *
     C     PAPER         BEGSR
      *
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
      *
     C                   ENDSR                                                  PAPER
     C/EJECT
      *****************************************************************
      *   CASR  - Format CURRENCY/AMOUNT subfield                     *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     CASR          BEGSR
      *
     C                   MOVEA     *BLANKS       FLD
     C                   MOVEL     MFLD          WK1               1                           18618
     C                   MOVEL     MFLD          MFLD2                                         18618
     C     DIGITS        CHECK     CHAR44                                 47                   18618
     C     WK1           IFEQ      'N'                                                         18618
     C     *IN47         ANDEQ     '1'                                                         18618
     C                   MOVE      MFLD          WK46             46                           18618
     C                   MOVEA     WK46          AMAR                                          18618
     C                   ELSE                                                                  18618
     C                   MOVEL     MFLD          WK3               3
     C                   MOVE      MFLD          WK47             47
     C                   MOVEA     WK47          AMAR
     C                   END                                                                   18618
     C                   Z-ADD     1             A                 2 0
     C     ','           LOOKUP    AMAR(A)                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      '.'           AMAR(A)
     C                   END
     C     WK1           IFEQ      'N'                                                         18618
     C     *IN47         ANDEQ     '1'                                                         18618
     C                   MOVEA     WK1           FLD(1)                                        18618
     C                   MOVEA     CHAR24        FLD(3)                                        18618
     C                   MOVEA     AMAR          FLD(7)                                        18618
     C                   ELSE                                                                  18618
     C                   MOVEA     WK3           FLD(1)
     C                   MOVEA     AMAR          FLD(5)
     C                   END                                                                   18618
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0800CCP2                                           S01408
     C*                                                                   S01408
      *
     C                   MOVEA     FLD           SMFLD
      *
     C                   ENDSR                                                  CASR
     C/EJECT
      *****************************************************************
      *   DCASR - DATE/CCY/AMOUNT subfield                            *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     DCASR         BEGSR
      *
     C                   MOVEA     *BLANKS       AMAR
     C                   MOVEA     MFLD          FLD
     C                   MOVEL     MFLD          MFLD2                                         CSW09
     C     DIGITS        CHECK     CHAR7                                  47                   CSW09
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLD(10)       AMAR
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD(12)       AMAR                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   Z-ADD     1             A
     C     ','           LOOKUP    AMAR(A)                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      '.'           AMAR(A)
     C                   END
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLD(7)        WK3
     C                   MOVEL     MFLD          DAT
      *
      ** By this stage, AMAR contains amount, WK3 contains currency
      ** and DAT (a DS - YY MM DD) contains date
     C                   MOVEA     *BLANKS       FLD
     C                   MOVEA     DD            FLD(1)
     C                   MOVEA     '/'           FLD(3)
     C                   MOVEA     MM            FLD(4)
     C                   MOVEA     '/'           FLD(6)
     C                   MOVEA     YY            FLD(7)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD(9)        WK3                                           CSW09
     C                   MOVEL     MFLD          DAT3                                          CSW09
     C                   MOVEA     *BLANKS       FLD                                           CSW09
     C                   MOVEA     DD3           FLD(1)                                        CSW09
     C                   MOVEA     '/'           FLD(3)                                        CSW09
     C                   MOVEA     MM3           FLD(4)                                        CSW09
     C                   MOVEA     '/'           FLD(6)                                        CSW09
     C                   MOVEA     YY3           FLD(7)                                        CSW09
     C                   ENDIF                                                                 CSW09
      *
     C     DATF          IFEQ      'M'
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLD(1)        WRKDAT
     C                   MOVEL     WRKMM         @CHG5
     C                   MOVE      WRKDD         @CHG5
     C                   MOVE      WRKYY         CHGYY
     C                   MOVEA     CHGDAT        FLD(1)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD(1)        WKDAT                                         CSW09
     C                   MOVEL     WKMM          @CH5                                          CSW09
     C                   MOVE      WKDD          @CH5                                          CSW09
     C                   MOVE      WKYY          CHYY                                          CSW09
     C                   MOVEA     CHDAT         FLD(1)                                        CSW09
     C                   ENDIF                                                                 CSW09
     C                   END
      *
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     WK3           FLD(10)
     C                   MOVEA     AMAR          FLD(14)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     WK3           FLD(12)                                       CSW09
     C                   MOVEA     AMAR          FLD(16)                                       CSW09
     C                   ENDIF                                                                 CSW09
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0800CCP3                                           S01408
     C*                                                                   S01408
      *
     C                   MOVEA     FLD           SMFLD
      *
     C                   ENDSR                                                  DCASR
     C/EJECT
      *****************************************************************
      *   ASR - AMOUNT subfield                                       *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     ASR           BEGSR
      *
     C                   MOVEA     MFLD          AMAR
     C                   Z-ADD     1             A                 2 0
     C     ','           LOOKUP    AMAR(A)                                40
     C     *IN40         IFEQ      '1'
     C                   MOVE      '.'           AMAR(A)
     C                   END
     C                   MOVEA     AMAR          SMFLD
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0800CCP4                                           S01408
     C*                                                                   S01408
      *
     C                   ENDSR                                                  ASR
     C/EJECT
      *****************************************************************
      *   DSR - DATE subfield                                         *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     DSR           BEGSR
      *
     C                   MOVEA     *BLANKS       FLD
      *
      ** Check for defined qualifiers, issuer codes or type in the form   CSW098
      **  MFLD = ':QUAL//TYPE/YYYYMMDD' whereby formatting should         CSW098
      ** only be done on the YYYYMMDD.                                    CSW098
      *                                                                   CSW098
     C                   MOVE      *BLANKS       WMFLD            50                           CSW09
     C                   MOVE      *BLANKS       WFLA             50                           CSW09
     C                   MOVE      *BLANKS       WFLD             50                           CSW09
      *                                                                   CSW098
     C     1             SUBST     MFLD:1        @WM1              1                           CSW09
     C     @WM1          IFEQ      ':'                                          Qualifier StartCSW09
     C     '/'           SCAN      MFLD:7        C                 2 0          Issuer Code EndCSW09
      *                                                                   CSW098
     C     C             IFNE      0                                                           CSW09
     C                   ADD       1             C                                             CSW09
     C     '/'           SCAN      MFLD:C        D                 2 0          Type End       CSW09
     C     D             IFNE      0                                                           CSW09
     C                   Z-ADD     D             C                                             CSW09
     C                   ELSE                                                                  CSW09
     C                   SUB       1             C                                             CSW09
     C                   ENDIF                                                                 CSW09
     C     C             SUBST     MFLD          WMFLD                                         CSW09
     C                   ADD       1             C                                             CSW09
     C                   SUBST     MFLD:C        WFLA                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C                   ELSE                                                                  CSW09
     C                   MOVEL     MFLD          WFLA                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C***********          MOVELMFLD      MFLD2                    CSW097 CSW098
     C                   MOVEL     WFLA          MFLD2                                         CSW09
     C     DIGITS        CHECK     CHAR7                                  47                   CSW09
      *                                                                   CSW097
      ** The seventh character is not numeric.                            CSW097
      *                                                                   CSW097
     C     *IN47         IFEQ      '1'                                                         CSW09
     C***********          MOVELMFLD      DAT                             CSW098
     C                   MOVEL     WFLA          DAT                                           CSW09
     C                   MOVEA     DD            FLD(1)
     C                   MOVEA     '/'           FLD(3)
     C                   MOVEA     MM            FLD(4)
     C                   MOVEA     '/'           FLD(6)
     C                   MOVEA     YY            FLD(7)
     C                   ELSE                                                                  CSW09
     C***********          MOVELMFLD      DAT3                     CSW097 CSW098
     C                   MOVEL     WFLA          DAT3                                          CSW09
     C                   MOVEA     DD3           FLD(1)                                        CSW09
     C                   MOVEA     '/'           FLD(3)                                        CSW09
     C                   MOVEA     MM3           FLD(4)                                        CSW09
     C                   MOVEA     '/'           FLD(6)                                        CSW09
     C                   MOVEA     YY3           FLD(7)                                        CSW09
     C                   ENDIF                                                                 CSW09
      *
     C     DATF          IFEQ      'M'
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLD(1)        WRKDAT
     C                   MOVEL     WRKMM         @CHG5
     C                   MOVE      WRKDD         @CHG5
     C                   MOVE      WRKYY         CHGYY
     C                   MOVEA     CHGDAT        FLD(1)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD(1)        WKDAT                                         CSW09
     C                   MOVEL     WKMM          @CH5                                          CSW09
     C                   MOVE      WKDD          @CH5                                          CSW09
     C                   MOVE      WKYY          CHYY                                          CSW09
     C                   MOVEA     CHDAT         FLD(1)                                        CSW09
     C                   ENDIF                                                                 CSW09
     C                   END
      *
     C     WMFLD         IFNE      *BLANKS                                                     CSW09
     C                   MOVEL     WMFLD         SMFLD                                         CSW09
     C                   MOVEA     FLD           WFLD                                          CSW09
     C                   CAT       WFLD:0        SMFLD                                         CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLD           SMFLD
     C                   ENDIF                                                                 CSW09
      *
      ** If tag is 30G and message type is 350, include end date                              256996
     C     MTPY          IFEQ      '350'                                                      256996
     C     SAVTAG        ANDEQ     ':30G:'                                                    256996
     C                   MOVEA     *BLANKS       FLD                                          256996
     C                   MOVEL     *BLANKS       DAT4                                         256996
     C                   MOVEL     MFLD          DAT4                                         256996
      *                                                                                       256996
     C                   MOVEL     DAT5          DAT3                                         256996
     C                   MOVEA     DD3           FLD(1)                                       256996
     C                   MOVEA     '/'           FLD(3)                                       256996
     C                   MOVEA     MM3           FLD(4)                                       256996
     C                   MOVEA     '/'           FLD(6)                                       256996
     C                   MOVEA     YY3           FLD(7)                                       256996
     C                   MOVEA     FLD           WEND             10                          256996
      *                                                                                       256996
     C     DATF          IFEQ      'M'                                                        256996
     C                   MOVEA     FLD(1)        WKDAT                                        256996
     C                   MOVEL     WKMM          @CH5                                         256996
     C                   MOVE      WKDD          @CH5                                         256996
     C                   MOVE      WKYY          CHYY                                         256996
     C                   MOVEA     CHDAT         FLD(1)                                       256996
     C                   MOVEA     FLD           WEND                                         256996
     C                   ENDIF                                                                256996
      *                                                                                       256996
     C     SMFLD         CAT       ' -':0        SMFLD                                        256996
     C     SMFLD         CAT       WEND:1        SMFLD                                        256996
      *                                                                                       256996
     C                   ENDIF                                                                256996
     C                   ENDSR                                                  DSR
     C/EJECT
      *****************************************************************   CSW098
      *   DTSR - DATE/TIME field                                      *   CSW098
      *   Called by - FLDPRC                                          *   CSW098
      *****************************************************************   CSW098
      *                                                                   CSW098
     C     DTSR          BEGSR                                                                 CSW09
      *                                                                   CSW098
      **  Output date part                                                CSW098
      *                                                                   CSW098
     C                   EXSR      DSR                                                         CSW09
      *                                                                   CSW098
     C                   MOVE      *BLANKS       WFLD                                          CSW09
      *                                                                   CSW098
     C     *IN47         IFEQ      '1'                                                         CSW09
     C     2             SUBST     WFLA:7        @WL2              2                           CSW09
     C                   MOVEL     @WL2          WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:9        @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:11       @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   ELSE                                                                  CSW09
     C     2             SUBST     WFLA:9        @WL2                                          CSW09
     C                   MOVEL     @WL2          WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:11       @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   CAT       ':':0         WFLD                                          CSW09
     C     2             SUBST     WFLA:13       @WL2                                          CSW09
     C                   CAT       @WL2:0        WFLD                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C                   CAT       WFLD:1        SMFLD                                         CSW09
      *                                                                   CSW098
     C                   ENDSR                                                                 CSW09
     C/EJECT                                                              CSW098
      *****************************************************************
      *   CATCH - CATCHALL subfield format                            *
      *   Called by - FLDPRC                                          *
      *****************************************************************
      *
     C     CATCH         BEGSR
      *
     C                   MOVEL     MFLD          SMFLD
      *
     C                   ENDSR                                                  CATCH
     C/EJECT
      *****************************************************************                       196833
      *                                                               *                       196833
      *  SRDEST - Destination for CLS Pay/Receives                    *                       196833
      *           For CLS Pay/Receives, retrieve the SWIFT ID of the  *                       196833
      *           DECN field. This will display the correct Customer  *                       196833
      *           Report name and Town.                               *                       196833
      *                                                               *                       196833
      *****************************************************************                       196833
      *                                                                                       196833
     C     SRDEST        BEGSR
      *                                                                                       196833
     C     TNTP          IFEQ      'PC'
     C     TNTP          OREQ      'RC'
      *                                                                                       196833
     C                   MOVE      *BLANKS       PCUST            10
     C                   MOVEL     DECN          PCUST
      *                                                                                       196833
     C                   CALL      'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    PCUST
     C                   PARM      *BLANKS       PKYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *                                                                                       196833
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     BBCSID        ZADDR
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   Z-ADD     007           DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PCUST         DBKEY
     C                   MOVE      '1'           PERR
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       196833
     C                   ENDIF
      *                                                                                       196833
     C                   ENDSR
      *                                                                                       196833
      *****************************************************************                       196833
      /EJECT                                                                                  196833
      *****************************************************************
      *   *PSSR - Error handling                                      *
      *   Called by - REF, DETL, MLTTRN                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
      *
     C                   ENDSR
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0800CCP5                                           S01408
     C*                                                                   S01408
     X/COPY WNCPYSRC,ME0800X001                                           S01408
** CPY@   **      Object copyright
(c) Finastra International Limited 2001
**  Months MM/MMM format (+E32647)
01JAN
02FEB
03MAR
04APR
05MAY
06JUN
07JUL
08AUG
09SEP
10OCT
11NOV
12DEC
** TEXT - Text for labels (+E29588)
Module id
Midas transaction no.
Transaction type
Sub-type
External system
Sender
Message type
Destination
Network/paper
Priority
Creation date
Delivery notification
Non-delivery warning
Testkey req/d?
*** ORIGINAL ***
*** COPY ***
Message status
Last action date
time
Error
Released by - user
workstation
*** POSSIBLE DUPLICATE ***
Description
Tag
Data
-----------
---
----
Counterparty confirmation status
Broker confirmation status
Midas trans. no.
C/party conf
Broker conf
<NOT AVAILABLE>
<TAG DESCRIPTION NOT FOUND>
<NOT VERIFIED>
***DELETED***
<MSG DESC NOT FOUND>
Account No.
Input Via Message Management
Deliverer of Security
** VERFY - Message types/fields requiring verification
100:32
202:32
203:19
203:30
203:32
103:32
** TRNTG - Multiple TRN Message types/fields
203:20:
210:21:
** TABCD/TABNAR - Table of Status/Narrative.
CRTDCreated
AMNDAmended
DLTDDeleted
RSNDReady to send
PENDPending Transmission
TRANTransmitted
EFMTFormat error
ELAULogical Authentication error
ESEQInput sequence number error
ETIDTerminal ID error
ELENMessage length error
EAUTS.W.I.F.T. authentication error
QRDQReady queue error
QVRQVerification queue error
LACKLogically acknowledged
NACKNegatively acknowledged
EBL1Error in basic header
EBL2Error in application header
EBL4Error in text
EBL5Error in trailer
PRTDPrinted (released)
RRTDRe-routed (released)
TSNTSent                                                                  081505
TOUTPending Transmission                                                  081505
TCANCancelled                                                             081505
TRTYIn retry                                                              081505
TACTActive                                                                081505
TSENSent                                                                  081505
THLEHeld - error                                                          081505
THLOHeld by Telex operator                                                066991
TBOXAt Telex box                                                          066991
TCNRCancel requested                                                      081505
TRELHeld on Telex queue                                                   081505
TWTGWaiting                                                               081505
TRTSReady to send                                                         081505
TDESIn despatch                                                           081505
TONQOn Telex queue                                                        066991
TCMPComplete                                                              081505
TUNKTelex status unknown                                                  066991
TRRTOn Telex re-route queue                                               066991
TDLTDeleted                                                               081505
TSPVSupervisor to authorise                                               081561
THORHeld by Originator                                                    CMT001
THTCHeld Time Constraints                                                 CMT001
THLOHeld by Tx/Fx Operator                                                CMT001
TCARAt Carrier                                                            CMT001
THOPHeld by Operator                                                      CMT001
TIRSItem Reset                                                            CMT001
TCNAComplete not accounted yet                                            CMT001
     X/COPY WNCPYSRC,ME0800X003
** TAB1 TAB2 (Counterparty and Broker status)
00NO FEEDBACK YET
01WAITING
02TIMED OUT
50PROPOSED PAIR
51PAIRED ERROR-O
52PAIRED ERROR-T
53PAIRED ERROR-B
54PROPOSED INVEST
97NONE EXPECTED
99PAIRED NO ERROR
     X/COPY WNCPYSRC,ME0800X002
