     H******  1                                                           S01421
     H DEBUG FTRANS DFTNAME(S01421)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058081
/*STD *  RPGSQLBND                                                    *                     MD058081
/*EXI *  TEXT('Midas MG Instrs to clearing system messages')          *
      *****************************************************************
      *                                                               *
      *  Midas - Message Generation Module                            *
      *                                                               *
      *   MG0580 - FORMAT MT580 MESSAGES                              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058081           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 26Mar02               *
      *                 192221             Date 26Nov01               *
      *                 184136             Date 29Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSW201             Date 02May01               *
      *                 183583             Date 25Jun01               *
      *                 CSE022             Date 29Mar01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 188866             Date 20Mar01               *
      *                 185241             Date 29Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 167826             DATE 22Jun00               *
      *                 173491             Date 26Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 141572             DATE 21SEP98               *
      *                 CEU005             DATE 04FEB98               *
      *                 113207             DATE 03MAR98               *
      *                 113352             DATE 13FEB98               *
      *                 122078             DATE 17Feb98               *
      *                 122283             DATE 16FEB98               *
      *                 CFF004             DATE 02OCT96               *
      *                 064596             DATE 10MAY96               *
      *                 090572             DATE 09MAY96               *
      *                 068695             DATE 09MAY96               *
      *                 056532             DATE 09MAY96               *
      *                 057263             DATE 09MAY96               *
      *                 102916             DATE 08MAY96               *
      *                 073848             DATE 08MAY96               *
      *                 078256             DATE 07MAY96               *
      *                 071394             DATE 03MAY96               *
      *                 102766             DATE 02MAY96               *
      *                 082282             DATE 02MAY96               *
      *                 CSW003             DATE 09JAN96               *
      *                 089450             DATE 12JAN95               *
      *                 091250             DATE 24FEB95               *
      *                 080096             DATE 12JAN95               *
      *                 069020             DATE 15APR94               *
      *                 S01421             DATE 18AUG93               *
      *                 S01401             DATE 14JUN93               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058081 - Deliverable Data Split for ME and MS              *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type & suppress multiples    *
      *  192221 - Format message tag 87 to include account lines      *
      *           2 to 4.                                             *
      *  184136 - Allow field 35A to be correctly formatted for       *
      *           several types of Swift Security Code.               *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  183583 - Add extension file MGOEXTPD to store customer no.   *
      *           of field with SWIFT address.                        *
      *  CSE022 - Depository Definition Enhancement                   *
      *  188866 - 167826 incomplete - add extra parm to all calls to  *
      *           ZM1340.                                             *
      *  185241 - Database error in SEC0603. Applied fixes 141579,    *
      *           138847 and 130960.                                  *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  167826 - DataBase error in ZM1340 at 061. Apply 153374.      *
      *  173491 - Check if MGCCTN contains SWIFT ID else assume it is *
      *           customer no. or shortname. Apply fix 168025.        *
      *  141572 - Setup CINDV (century flag) SVDT ( value date).      *
      *  CEU005 - EMU SE Settlement Ccy Conversion.                   *
      *  113207 - For clearance type 2 or 4 the system should format  *
      *           the clearing correspondent (field 84a) with the     *
      *           counterparty depot reference number.                *
      *           (ie. For 'TP' use "Deliver from" and for 'TS' use   *
      *                "Deliver to".)                                 *
      *  113352 - Set-up CIND (Century flag)  to correct year2000     *
      *           display problem.                                    *
      *  122078 - BYPASS THE ACCOUNT LINE AND GET CSID AFTER IN CASE  *
      *           OPTION TAG 'A' DOES NOT START WITH ACCOUNT LINE.    *
      *  122283 - Blank line in MGOMSGPD if account number is blank   *
      *           and not account line.                               *
      *  CFF004 - Increase in size of Price Fields,(Recompiled Only)  *
      *  064596 - Field 87C report name,town not shown on MG0580P1    *  *
      *  090572 - Processing when WWLENG is greater than 2000 is      *  *
      *           inconsistent.                                       *  *
      *  068695 - Some transactions rejected by EUROCLEAR due to      *
      *           wrong trade price.                                  *
      *  056532 - Process incorrect car. '-' ' ' ':' in first position*
      *  057263 - All postiion in field "MTAG" need to be full.       *
      *  102916 - Field :33T: 'YLD' instead 'REN' if trade basis is
      *           'Y' = yield basis. Price field will already contain
      *           the 'Price/Discount/Yield' value.
      *  073848 - Avoid corruption of message sub-type                *  *
      *  078256 - Use nominal decimal places from file                *
      *  071394 - For MT592, field 33T is formatted in the same       *
      *           way as field 37J,37L,37S,37P. (for report only)     *
      *           That's not correct as they do not have the          *
      *           same syntax.                                        *
      *           Field 33T -> 3a,15n         Field 37x -> 15n        *
      *           All the fields are not correctly formatted on       *
      *           report. File is correctly updated.                  *
      *  102766 - Depot movement messages have wrong price format     *
      *  082282 - Set message status according to customer details    *
      *  CSW003 - MT5XX Message Generation - Phase 2. New structure   *
      *           for TRN of MT580 in order to differenciate between  *
      *           'DN' and 'DT' subtype for depot movement.           *
      *  089450 - Setup WWSENT before it is used for comparison.      *
      *  091250 - Print Files MG0580P1/P2 renamed to MG0580A1/A2 as   *
      *           these are audit reports.                            *
      *  080096 - RECOMPILE BECAUSE COPY MEMBER MGCPYSRC,SWIFTTRANS   *
      *           CHANGED                                             *
      *  069020 - MULTIPLE DATA ARRAYS FOR MGOREFD NOT BEING CLEAR    *
      *           CORRECTLY CAUSED MESSAGE DROP PROGRAM ENDED         *
      *           ABNORMALLY.                                         *
      *  S01421 - REPLACE THE SWIFT TRANSLATION TABLE WITH A          *
      *           /COPY STATEMENT (SWIFTTRANS).                       *
      *  S01401 - MT500 messages for Release 10.                      *
      *           (This also includes SWIFT SEPT 93 message format    *
      *           changes)                                            *
      *                                                               *
      *****************************************************************
     F*
     FMGF580L0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     FMGOREFL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(MGOREFD0:MGORELA)
     FMGOMSGLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(MGOMSGD0:MGMSGLA)
     FSDCUSTL7  IF   E           K DISK    INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     FSDSTRDPD  IF   E             DISK    INFSR(*PSSR)
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCUSTL6  IF   E           K DISK    INFSR(*PSSR)
     FSDSECSL1  IF   E           K DISK    INFSR(*PSSR)
     FSDSECSJ4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTZ0:SDCUSZ4)
     FSDSECSJ5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUSTZ0:SDCUSZ5)
     FSDBRCHL1  IF   E           K DISK    INFSR(*PSSR)
     FSDCURRL1  IF   E           K DISK    INFSR(*PSSR)
     FSDMGMEPD  IF   E             DISK    INFSR(*PSSR)
     FSECRTNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*MGE580PD* IF   E             DISK    INFSR(*PSSR)                                    MD058081
     FMGOREFPD  O    E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     FMGOMSGPD  O    E             DISK    COMMIT
     F                                     INFSR(*PSSR)
     FMGOEXTPD  O    E             DISK    COMMIT                               183583
     F                                     INFSR(*PSSR)                         183583
     F*G0580P1O***E********************PRINTER******KINFDS*OVRFL1         091250
     FMG0580A1  O    E             PRINTER INFDS(OVRFL1)                        091250
     F                                     INFSR(*PSSR)
     F*G0580P2O***E********************PRINTER******KINFDS*OVRFL2     UC  091250
     FMG0580A2  O    E             PRINTER INFDS(OVRFL2)                        091250
     F                                     USROPN
     F                                     INFSR(*PSSR)
     FMG0580AU  O    E             PRINTER USROPN
     FMGF579PD  O    E             DISK    INFSR(*PSSR)
     F                                     USROPN
     F*
     F/COPY WNCPYSRC,MG0580F001
     F*****************************************************************
     F/EJECT
     F*****************************************************************
     D*
     D** ARRAY USED FOR COPYRIGHT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*
     D** ARRAY TO DETERMINE FIELD REQUIREMENTS
     D ARR1            S             50    DIM(38)
     D*
     D** ARRAY OF CASE NUMBERS FOR FIELD :87a: PROCESSING
     D ARR2            S              2  0 DIM(28) CTDATA PERRCD(14)
     D*
     D** ARRAY USED TO FORMAT ERROR MESSAGE FIELD ON MULTIPLE
     D** OCCURENCE DATA STRUCTURE
     D**********          ERRA    1  53 55                                 68695
     D ERRA            S             55    DIM(54) CTDATA PERRCD(1)                               68
     D*
     D** ARRAY USED TO FORMAT DESCRIPTION FIELD ON MULTIPLE
     D** OCCURENCE DATA STRUCTURE
     D DESA            S             36    DIM(32) CTDATA PERRCD(1)
     D*
     D** ARRAY OF NUMERIC VALUES
     D NUM             S              1    DIM(10) CTDATA PERRCD(10)
     D*
     D** ARRAY USED TO GENERATE ONLY MANDATORY FIELDS
     D OPT             S              1    DIM(50)
     D*
     D** ARRAY USED TO REMOVE FORBIDDEN CHARACTERS (E.G. %)
     D FORB            S              1    DIM(50)
     D*
     D** ARRAY FOR FORMATTING CANCELLATION MESSAGES
     D TAGAMT          S              5    DIM(4) CTDATA PERRCD(4)
     D TAGRAT          S              5    DIM(5) CTDATA PERRCD(5)
     D TAGBIC          S              5    DIM(4) CTDATA PERRCD(4)
     D TAGOTH          S              5    DIM(18) CTDATA PERRCD(16)
     D TABT            S              5    DIM(38) CTDATA PERRCD(11)
     D TABN            S              2  0 DIM(38) ALT(TABT)
     D*
     D*COPY*ZSRSRC,ZDATE1Z1                                                                 MD058081
     D/COPY ZSRSRC,ZDATE2Z1LE                                                               MD058081
     D*
      **  Array used to set message status                                082282
     D @ST             S              3    DIM(15)                                               082
     D*
     D** Multiple occurrence data structure for message
     D MULT            DS                  OCCURS(500)
     D  MDES                   1     36
     D  MTAG                  37     41
     D  MDAT                  42     91
     D  MERR                  92    146
     D  CRNM                 160    179
     D  CRTN                 182    191
     D  RDAT                 147    196
     D  R1RDNM               201    220
     D  R1RDTN               221    230
     D*
     D** Multiple occurrence data structure for incorrectly
     D** formatted messages
     D WMULT           DS                  OCCURS(500)
     D  WMTAG                  1      5
     D  WMDAT                  6     55
     D  WMERR                 56    110
      *                                                                   183583
      ** Multiple occurrence data structure for extension file            183583
      *                                                                   183583
     D EXTN            DS                  OCCURS(95)                           183583
     D  MPSN                   1      2  0                                      183583
     D  MTG                    3      7                                         183583
     D  MCSI                   8     15                                         183583
      *                                                                   183583
      ** Field tag data structure                                         183583
      *                                                                   183583
     D                 DS                                                       183583
     D  @MTG                   1      5                                         183583
     D  FLDTYP                 2      2                                         183583
     D  FLDTAG                 4      4                                         183583
     D*
     D** Multiple occurrence data structure for each MGOREFPD record
     D REFDS           DS                  OCCURS(10)
     D  WWMOD                  1      2
     D  WWTRNO                 3     18
     D  WWMTRN                19     33
     D  WWTNTP                34     35
     D  WWSBTP                36     37
     D  WWDECN                38     43
     D  WWNWBN                44     63
     D  WWSVDT                64     69
     D  WWCCY                 70     72
     D  WWBRCA                73     75
     D  WWHRDT                76     81
     D*
     D** Multiple occurrence data structure for each Transaction field
     D TRANS           DS                  OCCURS(11)
     D  WWTRNM                 1     16
     D*
     D** Local data area
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D*
     D** DATA STRUCTURE TO OBTAIN THE LATEST MT580 TRN
     D M5STAT        E DS
     D*
     D** DATA STRUCTURE FOR CONSTRUCTING DATA FIELD
     D WWMDAT          DS                  OCCURS(50)
     D  WD0103                 1      3
     D  WD0104                 1      4
     D  WD0105                 1      5
     D  WD0106                 1      6
     D  WD0107                 1      7
     D  WD0112                 1     12
     D  WD0409                 4      9
     D  WD0419                 4     19
     D  WD0420                 4     20
     D  WD0516                 5     16
     D  WD0617                 6     17
     D  WD0709                 7      9
     D  WD0710                 7     10
     D  WD0808                 8      8
     D  WD0810                 8     10
     D  WD0817                 8     17
     D  WD0913                 9     13
     D  WD1016                10     16
     D  WD1416                14     16
     D*
     D** DATA STRUCTURE FOR CONSTRUCTING DATA FIELD
     D WWRDAT          DS                  OCCURS(50)
     D  WR0108                 1      8
     D  WR0912                 9     12
     D  WR0103                 1      3
     D  WR0424                 4     24
     D  WR0937                 9     37
     D*
     D** DATA STRUCTURE TO DETERMINE FIELD REQUIREMENTS
     D WWFDAT          DS
     D  WWFLDS                 1     50
     D  WWFL01                 1      1
     D  WWFL02                 2      2
     D  WWFL03                 3      3
     D  WWFL04                 4      4
     D  WWFL05                 5      5
     D  WWFL06                 6      6
     D  WWFL07                 7      7
     D  WWFL08                 8      8
     D  WWFL09                 9      9
     D  WWFL10                10     10
     D  WWFL11                11     11
     D  WWFL12                12     12
     D  WWFL13                13     13
     D  WWFL14                14     14
     D  WWFL15                15     15
     D  WWFL16                16     16
     D  WWFL17                17     17
     D  WWFL18                18     18
     D  WWFL19                19     19
     D  WWFL20                20     20
     D  WWFL21                21     21
     D  WWFL22                22     22
     D  WWFL23                23     23
     D  WWFL24                24     24
     D  WWFL25                25     25
     D  WWFL26                26     26
     D  WWFL27                27     27
     D  WWFL28                28     28
     D  WWFL29                29     29
     D  WWFL30                30     30
     D  WWFL31                31     31
     D  WWFL32                32     32
     D  WWFL33                33     33
     D  WWFL34                34     34
     D*
     D** DATA STRUCTURE FOR READING MATCHING RECORDS ON MGF580L0
     D WWDS1           DS
     D  WWKDS1                 1     11
     D  WWMODI                 1      2
     D**********                              3   80WWDEST                                    CSD027
     D  WWDEST                 3      8
     D  WWSNBR                 9     11
     D*
     D** DATA STRUCTURE FOR READING MATCHING RECORDS ON MGF580L0
     D WWDS2           DS
     D  WWKDS2                 1     11
     D  MGMODI                 1      2
     D**********                              3   80MGDEST                                    CSD027
     D  MGDEST                 3      8
     D  MGSNBR                 9     11
     D*
     D** DATA STRUCTURE FOR CRLF CONTROL CHARACTER
     D CRLFDS          DS             2
     D  CTRC                   1      2
     D  WWCR                   1      1
     D  WWLF                   2      2
     D*
     D** DATA STRUCTURE FOR DBERROR
     D DBERR           DS            20
     D  @MODI                  1      2
     D  @TRAN                  3     17
     D*
     D** DATA STRUCTURE FOR DBERROR
     D DBERR1          DS            26
     D  @SNDR                  1      6
     D  @SCSD                  7     18
     D  @DEST                 19     24
     D  @SETP                 25     26
     D*
     D** DATA STRUCTURE FOR DBERROR
     D DBERR2          DS            20
     D  WWMODE                 1      2
     D  @TREF                  3     17
     D*
     D** DATA STRUCTURE TO SPLIT DATE
     D                 DS
     D  ZSDATE                 1      6
     D  WWYEAR                 1      2
     D  WWMNTH                 3      4
     D  WWDAY                  5      6
     D*
     D** DATA STRUCTURE TO BUILD DATE
     D                 DS
     D  WRDATE                 1      8
     D  WRYEAR                 1      2
     D  WRSL1                  3      3    INZ('/')
     D  WRMNTH                 4      5
     D  WRSL2                  6      6    INZ('/')
     D  WRDAY                  7      8
     D*
     D** DATA STRUCTURE TO BUILD PARAMETER FOR MG5900
     D                 DS
     D  WWTREF                 1     15
     D  WT1313                13     13
     D*
     D** DATA STRUCTURE TO SPLIT OMFLD
     D                 DS
     D  OMFLD                  1     50
     D  OM0103                 1      3
     D  OM0106                 1      6
     D  OM0112                 1     12
     D  OM0116                 1     16
     D  OM0204                 2      4
     D  OM0418                 4     18                                         071394
     D  OM0419                 4     19
     D  OM0816                 8     16
     D  OM0735                 7     35
     D*
     D** DATA STRUCTURE TO BUILD TAG INPUT FIELD
     D                 DS
     D  WWTAG                  1      5
     D  WWTAG1                 1      1    INZ(':')
     D  WWTAGN                 2      3
     D  WWTAGI                 4      4
     D  WWTAG5                 5      5    INZ(':')
     D*
     D***DATA*STRUCTURE*FOR*OVERFLOW*ON*PRINTER*MG0580P1***               091250
     D** FILE INFORMATION DATA STRUCTURE FOR MG0580A1                     091250
     D OVRFL1          DS
     D  WWOFL1               188    189B 0
     D  WWPTL1               367    368B 0
     D*
     D***DATA*STRUCTURE*FOR*OVERFLOW*ON*PRINTER*MG0580P2***               091250
     D** FILE INFORMATION DATA STRUCTURE FOR MG0580A2                     091250
     D OVRFL2          DS
     D  WWOFL2               188    189B 0
     D  WWPTL2               367    368B 0
     D*
     D** DATA STRUCTURE FOR RECEIVER OF SECURITIES AC/LINE
     D                 DS
     D  MGRSS1                 1     35
     D  MGRS26                 2      6
     D  MGRS27                 2      7                                         064596
     D  MGRS59                 5      9
     D*
     D** DATA STRUCTURE FOR DELIVERER OF SECURITIES AC/LINE
     D                 DS
     D  MGDSS1                 1     35
     D  MGDS26                 2      6
     D  MGDS27                 2      7                                         064596
     D  MGDS59                 5      9
     D*                                                                   CEU005
     D* Data structure for 'IN' Ccy and amount on FLD72                   CEU005
     D                 DS                                                       CEU005
     D  WOCMT                  1     30                                         CEU005
     D  OCMT                   1      6                                         CEU005
     D  OTRC                   7      9                                         CEU005
     D  OTRA                  10     30                                         CEU005
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW003
      ** External data structure for Switchable Features                  CSW003
      *                                                                   CSW003
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CSW003
      ** First Data Structure for Access Objects                          CSW003
      *                                                                   CSW003
      * Data structures for access objects                                082282
     D DSSDY         E DS                  EXTNAME(DSSDY)                       082282
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    082282
     D MGE580        E DS                  EXTNAME(MG580JW0)                                MD058081
      *                                                                   082282
     I*****************************************************************
     I/EJECT
     I*****************************************************************
     IMGMSGLA
     I              MTAG                        OMTAG
     I              MFLD                        OMFLD
     I              CTRC                        OCTRC
     I              TRNO                        OTRNO
     I              PTDL                        OPTDL
      *                                                                   082282
     I*****************************************************************
     I/EJECT
     I*****************************************************************
      *                                                               *
      * 1. Multiple Data Structure MULT                               *
      *      The multiple occurrence data structure is used to        *
      *      store up the records that make up the SWIFT message      *
      *      before writing the whole message to file.                *
      *      To store the records of the message, you must            *
      *      first access an OCUR record, obtain the Message Tag      *
      *      & Message field data values for this OCUR record,        *
      *      then go on to the next OCUR record and continue          *
      *      this process until the SWIFT message is complete.        *
      *                                                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*   WWCASE, INSTRUCTIONS SENT TO CEDEL.                         *
     C*                                                               *
     C*    1 :   4F =  RECFREE, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*    2 :   4T =  RECFREE, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*    3 :   6F =  RECFREE, EXTERNAL, BOOK ENTRY                  *
     C*    4 :   6F =  RECFREE, EXTERNAL, PHYSICAL                    *
     C*    5 :   41 =  RECAPMT, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*    6 :   4T =  RECAPMT, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*    7 :   61 =  RECAPMT, EXTERNAL, BOOK ENTRY                  *
     C*    8 :   61 =  RECAPMT, EXTERNAL, PHYSICAL                    *
     C*    9 :                                                        *
     C*   10 :   31 =  DELFREE, INTERNAL OR BRIDGE, TRANSFER          *
     C*   11 :   5F =  DELFREE, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*   12 :   5T =  DELFREE, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*   13 :   8D =  DELFREE, EXTERNAL, BOOK ENTRY                  *
     C*   14 :   81 =  DELFREE, EXTERNAL, PHYSICAL                    *
     C*   15 :   51 =  DELAPMT, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*   16 :   5T =  DELAPMT, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*   17 :   8M =  DELAPMT, EXTERNAL, BOOK ENTRY                  *
     C*   18 :   8A =  DELAPMT, EXTERNAL, PHYSICAL                    *
     C*   19 :         (NOT USED)                                     *
     C*                                                               *
     C*   WWCASE, INSTRUCTIONS SENT TO EUROCLEAR.                     *
     C*                                                               *
     C*   20 :      =  RECFREE, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*   21 :      =  RECFREE, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*   22 :      =  RECFREE, EXTERNAL, BOOK ENTRY                  *
     C*   23 :      =  RECFREE, EXTERNAL, PHYSICAL                    *
     C*   24 :      =  RECAPMT, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*   25 :      =  RECAPMT, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*   26 :      =  RECAPMT, EXTERNAL, BOOK ENTRY                  *
     C*   27 :      =  RECAPMT, EXTERNAL, PHYSICAL                    *
     C*   28 :                                                        *
     C*   29 :      =  DELFREE, INTERNAL OR BRIDGE, TRANSFER          *
     C*   30 :      =  DELFREE, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*   31 :      =  DELFREE, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*   32 :      =  DELFREE, EXTERNAL, BOOK ENTRY                  *
     C*   33 :      =  DELFREE, EXTERNAL, PHYSICAL                    *
     C*   34 :      =  DELAPMT, INTERNAL OR BRIDGE, SETTLEMENT        *
     C*   35 :      =  DELAPMT, INTERNAL OR BRIDGE, MATCHING ONLY     *
     C*   36 :      =  DELAPMT, EXTERNAL, BOOK ENTRY                  *
     C*   37 :      =  DELAPMT, EXTERNAL, PHYSICAL                    *
     C*   38 :         (NOT USED)                                     *
     C*                                                               *
     C*                                                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*   WWFLDS, FIELDS DEFINITION.                                  *
     C*                                                               *
     C*   WWFL01  =         (NOT USED)                                *
     C*   WWFL02  =         (NOT USED)                                *
     C*   WWFL03  =         (NOT USED)                                *
     C*   WWFL04  =    30   SETTLEMENT DATE                           *
     C*   WWFL05  =         (NOT USED)                                *
     C*   WWFL06  =    31P  DATE AND PLACE OF TRADE                   *
     C*   WWFL07  =    31T  TIME OF TRADE                             *
     C*   WWFL08  =    26J  REQUESTED PRIORITY                        *
     C*   WWFL09  =    35A  QUANTITY OF SECURITIES                    *
     C*   WWFL10  =    35B  IDENTIFICATION OF SECURITIES              *
     C*   WWFL11  =    35E  CERTIFICATE NUMBERS                       *
     C*   WWFL12  =    83R  SENDER'S ROLE                             *
     C*   WWFL13  =    83C  SAFEKEEPING ACCOUNT                       *
     C*   WWFL14  =    84A  CLEARING CORRESPONDENT                    *
     C*   WWFL15  =    87a  DELIVERER/RECEIVER OF SECURITIES          *
     C*   WWFL16  =    85a  DELIVERER'S INSTRUCTING PARTY             *
     C*   WWFL17  =    88a  BENEFICIARY OF SECURITIES                 *
     C*   WWFL18  =    57a  ACCOUNT WITH INSTITUTION                  *
     C*   WWFL19  =    58a  BENEFICIARY OF MONEY                      *
     C*   WWFL20  =    33T  DEAL PRICE                                *
     C*   WWFL21  =    32M  DEAL AMOUNT                               *
     C*   WWFL22  =    37J  DEAL AMOUNT EXCHANGE RATE                 *
     C*   WWFL23  =    34a  ACCRUED INTEREST                          *
     C*   WWFL24  =    37L  ACCRUED INTEREST EXCHANGE RATE            *
     C*   WWFL25  =    37S  ACCRUED INTEREST RATE AND BASIS           *
     C*   WWFL26  =    33S  SPECIAL CONCESSIONS                       *
     C*   WWFL27  =    37P  SPECIAL CONCESSIONS EXCHANGE RATE         *
     C*   WWFL28  =    32B  SETTLEMENT AMOUNT                         *
     C*   WWFL29  =    26L  FUNGIBILITY CODE                          *
     C*   WWFL20  =    26K  DENOMINATION CHOICE                       *
     C*   WWFL31  =    77B  FURTHER INFORMATION                       *
     C*   WWFL32  =    72   SENDER TO RECEIVER INFORMATION            *
     C*   WWFL33  =    79   NARRATIVE                                 *
     C*   WWFL34  =    77D  REGISTRATIONS DETAILS                     *
     C*                                                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C*   MAIN PROCESSING - FORMAT MT580                              *
     C*                                                               *
     C*   CALLS THE FOLLOWING SUBROUTINES                             *
     C*                                                               *
     C*   INIT     - INITIALISATION                                   *
     C*   INTF     - INITIALISE NON-CONSTANT FIELDS                   *
     C*   ROUT     - DETERMINE MESSAGE ROUTING                        *
     C*   FLDR     - DETERMINE FIELD REQUIREMENTS                     *
     C*   NRSEQ    - FORMAT FIELDS FOR NON-REPETITIVE SEQUENCE        *
     C*   RSEQ     - FORMAT FIELDS FOR REPETITIVE SEQUENCE            *
     C*   UGGU     - UPDATE GENERATION GENERATED INDICATOR(@MODE ='U')*
     C*   UGGB     - UPDATE GENERATION GENERATED INDICATOR            *
     C*   FLD20N   - FORMAT FIELD :20: (NON-REPETITIVE SEQUENCE)      *
     C*   FLD23    - FORMAT MANDATORY FIELD :23:                      *
     C*   FLD30    - FORMAT FIELD :30:                                *
     C*   FLD20R   - FORMAT FIELD :20: (REPETITIVE SEQUENCE)          *
     C*   FLD31P   - FORMAT FIELD :31P:                               *
     C*   FLD31T   - FORMAT FIELD :31T:                               *
     C*   FLD26J   - FORMAT FIELD :26J:                               *
     C*   FLD35A   - FORMAT FIELD :35A:                               *
     C*   FLD35B   - FORMAT FIELD :35B:                               *
     C*   FLD35E   - FORMAT FIELD :35E:                               *
     C*   FLD83R   - FORMAT FIELD :83R:                               *
     C*   FLD83C   - FORMAT FIELD :83C:                               *
     C*   FLD84A   - FORMAT FIELD :84A:                               *
     C*   FLD87A   - FORMAT FIELD :87a:                               *
     C*   FLD85A   - FORMAT FIELD :85a:                               *
     C*   FLD88A   - FORMAT FIELD :88a:                               *
     C*   FLD57A   - FORMAT FIELD :57a:                               *
     C*   FLD58A   - FORMAT FIELD :58a:                               *
     C*   FLD33T   - FORMAT FIELD :33T:                               *
     C*   FLD32M   - FORMAT FIELD :32M:                               *
     C*   FLD37J   - FORMAT FIELD :37J:                               *
     C*   FLD34A   - FORMAT FIELD :34a:                               *
     C*   FLD37L   - FORMAT FIELD :37L:                               *
     C*   FLD37S   - FORMAT FIELD :37S:                               *
     C*   FLD33S   - FORMAT FIELD :33S:                               *
     C*   FLD37P   - FORMAT FIELD :37P:                               *
     C*   FLD32B   - FORMAT FIELD :32B:                               *
     C*   FLD26L   - FORMAT FIELD :26L:                               *
     C*   FLD26K   - FORMAT FIELD :26K:                               *
     C*   FLD77B   - FORMAT FIELD :77B:                               *
     C*   FLD77D   - FORMAT FIELD :77D:                               *
     C*   FLD72    - FORMAT FIELD :72:                                *
     C*   FLD79    - FORMAT FIELD :79:                                *
     C*   #ZA      - FORMAT ADDRESSES                                 *
     C*   #W01     - PRINT MESSAGE GENERATED DETAILS                  *
     C*   #W02     - PRINT MESSAGE NOT GENERATED DETAILS              *
     C*   #W03     - PRINT DATABASE ERROR REPORT                      *
     C*   #W05     - WRITE TO MGOREFPD                                *
     C*   *PSSR    - ERROR HANDLING                                   *
     C*   CEDELC   - CEDEL CANCELLATION PROCESSING                    *
     C*   CANCEL   - CEDEL CANCELLATION PROCESSING                    *
     C*   PARTPS   - CEDEL CANCELLATION PROCESSING - FIND PARTS       *
     C*   FORCAN   - CEDEL CANCELLATION PROCESSING - FORMAT           *
     C*   ZDATE1   - CONVERT DATE TO NUMBER OF DAYS                   *
     C*                                                               *
     C*****************************************************************
     C*
     C** INITIALISATION
     C                   EXSR      INIT
     C*
     C** READ FIRST RECORD FROM LF/MGF580L0
     C                   READ      MGF580L0                               10
     C*
     C** IF RECORDS PRESENT ON THE FILE, STORE KEY FIELDS
     C     *IN10         IFEQ      '0'
     C*
     C                   MOVE      MGMODI        WWMODI
     C                   MOVE      MGDEST        WWDEST
     C                   MOVE      MGSNBR        WWSNBR
     C*
     C** DO WHILE RECORDS ON MGF580L0
     C     *IN10         DOWEQ     '0'
     C*
     C** CEDEL CANCELLATION PROCESSING
     C     MGFIN1        IFEQ      '/CANCEL/'
     C                   MOVEL     'Y'           CEDPRO            1
     C                   ELSE
     C                   MOVEL     'N'           CEDPRO
     C                   END
     C*
     C** INITIALISE NON-CONSTANT FIELDS
     C                   EXSR      INTF
     C*
     C** DETERMINE MESSAGE ROUTING
     C                   EXSR      ROUT
     C*
     C** STORE FIELDS FROM MGF580L0 FOR REPORT HEADERS
     C                   MOVE      MGSNBR        WWHDR1
     C                   MOVE      MGDEST        WWHDR2
     C                   MOVE      MGMODI        WWHDR3
     C*
     C** FORMAT FIELD :20: ( NON REPETITIVE SEQUENCE)
     C                   EXSR      FLD20N
     C*
     C** FORMAT FIELDS FOR REPETITIVE SEQUENCE IF NOT CEDEL CANCELLATION
     C     CEDPRO        IFEQ      'N'
     C                   EXSR      RSEQ
     C*
     C** PROCESS CEDEL CANCELLATION
     C                   ELSE
     C                   EXSR      CEDELC
     C                   END
     C*
     C** IF ERROR FOUND ON MESSAGE THEN SET UP DATA STRUCTURE TO WRITE
     C** ONLY THIS PART OF MESSAGE TO MESSAGES NOT CORRECTLY GENERATED
     C** REPORT
     C     WWNGEN        IFEQ      'Y'
     C                   EXSR      NGEN
     C                   ELSE
     C*
     C* NO ERROR FOUND, PERFORM UPDATES
     C                   MOVE      'Y'           WWVALP            1
     C*
     C** UPDATE SEQUENCE NUMBERS ON TRANSACTION RECORD
     C*
     C** IF SENT TO CEDEL, PASS THE CEDEL SEQUENCE NO
     C     MGDEST        IFEQ      WWCEDN
     C     WWSENT        OREQ      'CEDEL'
     C                   Z-ADD     WW80CE        @LSWS
     C                   MOVE      'L'           @MODE
     C                   ELSE
     C                   Z-ADD     *ZEROS        @LSWS
     C                   MOVE      'U'           @MODE
     C                   END
     C*
     C** DO NOT UPDATE SEQUENCE NUMBER IF CANCELLATION CEDEL
     C     CEDPRO        IFEQ      'N'
     C*
     C** FORMAT @TRAN AS FOLLOWS
     C** CHARS 1-6 TO LEFTMOST 6 CHARS FROM MGTNUM
     C** CHARS 7-13 TO BLANKS
     C** CHARS 14-15 TO MGTTYP
     C                   MOVEL     MGTNUM        WWFSIX            6
     C                   MOVEL     WWFSIX        WWTRAN           15
     C                   MOVE      MGTTYP        WWTRAN
     C                   CALL      'MG5900'                             20
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTRAN        @TRAN            15
     C                   PARM      'PR'          @PROG             2
     C                   PARM                    @MODE             1
     C                   PARM                    @LSWS             7 0
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM      CSW003        @MT5XX            1                           CSW00
     C*
     C** IF PROGRAM MG5900 NOT FOUND
     C     *IN20         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '001'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 001  *
     C                   MOVEL     'MG5900'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM MG5900
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '002'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 002  *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5900'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C*
     C** UPDATE GENERATION GENERATED INDICATOR WITH @MODE = 'U'
     C                   EXSR      UGGU
     C*
     C                   END
     C*
     C** DELETE THE RECORD ON LF/MGF580L0 PROCESSED
     C                   DELETE    MGF580D0                             11
     C*
     C** IF ERROR ON DELETE OF RECORD
     C     *IN11         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '003'         DBASE                            * * * * * * *
     C                   MOVEL     MGTNUM        DBKEY                            * DBERR 003 *
     C                   MOVEL     'MGF580L0'    DBFILE                           * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** READ NEXT RECORD FROM LF/MGF580L0
     C                   READ      MGF580L0                               10
     C*
     C** FORCE A 580 WITH CERTIFICATE NUMBERS TO BE GENERATED
     C** ALONE AND FOLLOWED BY THE RELEVANT 579
     C     MGCRTN        IFEQ      'Y'
     C                   MOVE      'Y'           WKCRTN            1
     C                   END
     C*
     C** INIT LENGTH OF RECORD
     C                   Z-ADD     67            WWLENG            4 0
     C/COPY WNCPYSRC,MG0580C006
     C*
     C** DO WHILE THE KEY FIELDS ON THE RECORD READ MATCH THE
     C** STORED KEY FIELDS, BUT EXECUTE THE LOOP NO MORE THAN
     C** 9 TIMES
     C     WWKDS1        DOWEQ     WWKDS2                                       REPETITIVE/DO
     C/COPY WNCPYSRC,MG0580C007
     C     WWTOT1        ANDLT     5
     C/COPY WNCPYSRC,MG0580C008
     C     WWLENG        ANDLT     2000
     C     WKCRTN        ANDNE     'Y'
     C     *IN10         ANDEQ     '0'
     C     CSW025        ANDNE     'Y'
     C/COPY WNCPYSRC,MG0580C001
     C*
     C                   ADD       1             WWTOT1
     C*
     C** UPDATE SEQUENCE NUMBERS ON TRANSACTION RECORD
     C*
     C** IF SENT TO CEDEL, MODE IS 'L' INSTEAD OF ' '
     C     MGDEST        IFEQ      WWCEDN
     C     WWSENT        OREQ      'CEDEL'
     C                   MOVE      'C'           @MODE
     C                   ELSE
     C                   MOVE      ' '           @MODE
     C                   END
     C*
     C** CEDEL CANCELLATION PROCESSING
     C     MGFIN1        IFEQ      '/CANCEL/'
     C                   MOVEL     'Y'           CEDPRO
     C                   ELSE
     C                   MOVEL     'N'           CEDPRO
     C                   END
     C*
     C** FORMAT @TRAN AS FOLLOWS
     C** CHARS 1-6 TO LEFTMOST 6 CHARS FROM MGTNUM
     C** CHARS 7-13 TO BLANKS
     C** CHARS 14-15 TO MGTTYP
     C                   MOVEL     MGTNUM        WWFSIX
     C                   MOVEL     WWFSIX        WWTRAN
     C                   MOVE      MGTTYP        WWTRAN
     C                   CALL      'MG5900'                             20
     C                   PARM      MGMODI        @MODI
     C                   PARM      WWTRAN        @TRAN
     C                   PARM      'PR'          @PROG
     C                   PARM                    @MODE
     C                   PARM      *ZEROS        @LSWS
     C                   PARM      *BLANKS       @ERCD
     C                   PARM      CSW003        @MT5XX                                        CSW00
     C*
     C** IF PROGRAM MG5900 NOT FOUND
     C     *IN20         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '011'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 011  *
     C                   MOVEL     'MG5900'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM MG5900
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '014'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 014  *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5900'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** UPDATE GENERATION GENERATED INDICATOR WITH @MODE = BLANKS
     C                   EXSR      UGGB
     C*
     C** FORMAT FIELDS FOR REPETITIVE SEQUENCE IF NOT CEDEL CANCELLATION
     C     CEDPRO        IFEQ      'N'
     C                   EXSR      RSEQ
     C*
     C** PROCESS CEDEL CANCELLATION
     C                   ELSE
     C                   EXSR      CEDELC
     C                   END
     C*
     C** IF ERROR FOUND ON MESSAGE THEN SET UP DATA STRUCTURE TO WRITE
     C** ONLY THIS PART OF MESSAGE TO MESSAGES NOT CORRECTLY GENERATED
     C** REPORT
     C     WWNGEN        IFEQ      'Y'
     C                   EXSR      NGEN
     C                   ELSE
     C*
     C** MAXIMUM LENGTH BY MESSAGE IS 2000 (SWIFT RESTRICTION)
     C***********WWLENG    IFLT 2000                                      090572
     C*
     C* NO ERROR FOUND, PERFORM UPDATES
     C                   MOVE      'Y'           WWVALP
     C*
     C** UPDATE SEQUENCE NUMBERS ON TRANSACTION RECORD
     C*
     C** IF SENT TO CEDEL, PASS THE CEDEL SEQUENCE NO
     C     MGDEST        IFEQ      WWCEDN
     C     WWSENT        OREQ      'CEDEL'
     C                   Z-ADD     WW80CE        @LSWS
     C                   MOVEL     'L'           @MODE
     C                   ELSE
     C                   Z-ADD     *ZEROS        @LSWS
     C                   MOVEL     'U'           @MODE
     C                   END
     C*
     C** DO NOT UPDATE SEQUENCE NUMBER IF CANCELLATION CEDEL
     C     CEDPRO        IFEQ      'N'
     C*
     C** FORMAT @TRAN AS FOLLOWS
     C** CHARS 1-6 TO LEFTMOST 6 CHARS FROM MGTNUM
     C** CHARS 7-13 TO BLANKS
     C** CHARS 14-15 TO MGTTYP
     C                   MOVEL     MGTNUM        WWFSIX
     C                   MOVEL     WWFSIX        WWTRAN
     C                   MOVE      MGTTYP        WWTRAN
     C                   CALL      'MG5900'                             20
     C                   PARM      MGMODI        @MODI
     C                   PARM      WWTRAN        @TRAN
     C                   PARM      'PR'          @PROG
     C                   PARM                    @MODE
     C                   PARM                    @LSWS
     C                   PARM      *BLANKS       @ERCD
     C                   PARM      CSW003        @MT5XX                                        CSW00
     C*
     C** IF PROGRAM MG5900 NOT FOUND
     C     *IN20         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '015'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 015  *
     C                   MOVEL     'MG5900'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM MG5900
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '018'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 018  *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5900'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C*
     C** UPDATE GENERATION GENERATED INDICATOR WITH @MODE = 'U'
     C                   EXSR      UGGU
     C*
     C***********          END                                            090572
     C*
     C                   END
     C*
     C** DELETE THE RECORD PROCESSED
     C***********WWLENG    IFLT 2000                                      090572
     C***********WWTOT1    ORLE 5                                         090572
     C/COPY WNCPYSRC,MG0580C009
     C     WWTOT1        IFLE      5                                                           09057
     C/COPY WNCPYSRC,MG0580C010
     C*
     C                   DELETE    MGF580D0                             11
     C*
     C** IF ERROR ON DELETE OF RECORD
     C     *IN11         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '020'         DBASE                          * * * * * * * *
     C                   MOVEL     MGTNUM        DBKEY                          *  DBERR 020  *
     C                   MOVEL     'MGF580L0'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** READ NEXT RECORD FROM LF/MGF580L0
     C                   READ      MGF580L0                               10
     C*
     C                   END
     C*
     C                   END                                                    REPETITIVE/END
     C*
     C** IF ERROR FOUND WHILE FORMATTING THIS MESSAGE
     C     @ERR          IFEQ      'Y'
     C*
     C** PRINT MESSAGE NOT GENERATED DETAILS AND RESET ERROR FLAG
     C                   EXSR      #W02
     C                   MOVE      *BLANKS       @ERR
     C                   END
     C*
     C** WRITE TO MIDAS SWIFT DATABASE FILES
     C     WWVALP        IFEQ      'Y'
     C                   EXSR      OFLDS
     C*
     C** PRINT MESSAGE GENERATED DETAILS
     C                   EXSR      #W01
     C                   MOVE      'Y'           WWPTR1            1
     C                   MOVE      *BLANKS       WWVALP
     C                   END
     C*
     C** COMMIT ALL UPDATES TO FILE
     C                   COMMIT
     C*
     C** GENERATE THE RELEVANT MT579 MESSAGE
     C     WKCRTN        IFEQ      'Y'
     C                   CALL      'MG0579'                             61
     C     *IN61         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '079'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 079  *
     C                   MOVEL     'MG0579'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END
     C*
     C** RESET CERTIFICATE NUMBERS WORKFIELD
     C                   MOVE      *BLANKS       WKCRTN
     C*
     C** RE-READ LAST RECORD ON LF/MGF580L0 TO LOCK THE RECORD
     C** FOR THE NEXT DELETE
     C     *LOVAL        SETLL     MGF580L0
     C                   READ      MGF580L0                               10
     C*
     C** STORE KEY FIELDS OF LAST RECORD READ
     C                   MOVE      MGMODI        WWMODI
     C                   MOVE      MGDEST        WWDEST
     C                   MOVE      MGSNBR        WWSNBR
     C*
     C                   END
     C*
     C** WRITE TRAILER ON SWIFT MESSAGES GENERATED REPORT
     C** ONLY IF MESSAGES GENERATED
     C     WWPTR1        IFNE      'Y'
     C                   WRITE     HEADER1
     C                   WRITE     NODETS
     C*
     C                   ELSE
     C*
     C** CHECK FOR OVERFLOW
     C     WWOFL1        SUB       WWPTL1        WWLINE            2 0
     C*
     C     WWLINE        IFLT      4
     C                   WRITE     HEADER1
     C                   END
     C                   WRITE     EOREPT1
     C                   END
     C*
     C** WRITE TRAILER ON SWIFT MESSAGES NOT GENERATED REPORT
     C** IF THE PRINTER FILE HAS BEEN OPENED
     C     *IN50         IFEQ      '1'
     C*
     C** CHECK FOR OVERFLOW
     C     WWOFL2        SUB       WWPTL2        WWLINE
     C*
     C     WWLINE        IFLT      4
     C                   WRITE     HEADER2
     C                   END
     C*
     C                   WRITE     EOREPT2
     C                   END
     C*
     C                   ELSE
     C*
     C** WRITE NO DETAILS TO REPORT
     C                   WRITE     HEADER1
     C                   WRITE     NODETS
     C                   END
     C/COPY WNCPYSRC,MG0580C003
     C*
     C                   SETON                                        LR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  INIT      - INITIALISATION                                  *
     C**                                                              *
     C**  CALLS     - *PSSR                                           *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESS                                    *
     C**                                                              *
     C*****************************************************************
     C*
     C     INIT          BEGSR
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** DEFINE WORK FIELDS
     C     *LIKE         DEFINE    A6NBDP        WWCDPN
     C     *LIKE         DEFINE    MGDEST        WWHDR2
     C     *LIKE         DEFINE    MGSNBR        WWHDR1
     C     *LIKE         DEFINE    MGMODI        WWHDR3
     C     *LIKE         DEFINE    BBCSSN        WWEURC
     C     *LIKE         DEFINE    BBCSSN        WWCEDL
     C     *LIKE         DEFINE    MGRSS1        WWRSS1
     C     *LIKE         DEFINE    BVDR1         WWCNUM
     C     *LIKE         DEFINE    MGTNUM        WWTNUM
     C     *LIKE         DEFINE    MGTTYP        WWTTYP
     C     *LIKE         DEFINE    MGTSTP        WWTSTP
     C     *LIKE         DEFINE    MGBSSN        WWBSSN
     C     *LIKE         DEFINE    MGSTCY        WWSTCY
     C*
     C                   Z-ADD     0             WWCASE            2 0
     C*
     C** SET UP LDA
     C     *DTAARA       DEFINE                  LDA
     C*
     C** ACCESS SDBANKPD FOR BANK DETAILS
     C     1             SETLL     SDBANKPD
     C                   READ      SDBANKPD                               12
     C*
     C** IF RECORD NOT FOUND OR LAST CHANGE TYPE = 'D'
     C     *IN12         IFEQ      '1'
     C     BJTYLC        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '004'         DBASE                          * * * * * * * *
     C                   MOVEL     *BLANKS       DBKEY                          *  DBERR 004  *
     C                   MOVEL     'SDBANKPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C     BJDFIN        IFEQ      'D'
     C                   MOVE      '0'           *IN98
     C                   ELSE
     C                   MOVE      '1'           *IN98
     C                   END
     C*
     C** ACCESS SDSTRDPD FOR SE ICD DETAILS
     C     1             SETLL     SDSTRDPD
     C                   READ      SDSTRDPD                               15
     C*
     C** IF RECORD NOT FOUND OR LAST CHANGE TYPE = 'D'
     C     *IN15         IFEQ      '1'
     C     BVTYLC        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '030'         DBASE                          * * * * * * * *
     C                   MOVEL     *BLANKS       DBKEY                          *  DBERR 030  *
     C                   MOVEL     'SDSTRDPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** ACCESS SDCUSTL1 FOR EUROCLEAR SHORTNAME
     C     BVDR1         CHAIN     SDCUSTL1                           16
     C*
     C** IF RECORD NOT FOUND OR LAST CHANGE TYPE = 'D'
     C     *IN16         IFEQ      '1'
     C     BBTYLC        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '032'         DBASE                          * * * * * * * *
     C                   MOVEL     BVDR1         DBKEY                          *  DBERR 032  *
     C                   MOVEL     'SDCUSTL1'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C*
     C                   ELSE
     C*
     C** RECORD IS FOUND, STORE SHORTNAME (EUROCLEAR SHORTNAME)
     C                   MOVE      BBCSSN        WWEURC
     C                   END
     C*
     C** ACCESS SDCUSTL1 FOR CEDEL SHORTNAME
     C     BVDR2         CHAIN     SDCUSTL1                           16
     C*
     C** IF RECORD NOT FOUND OR LAST CHANGE TYPE = 'D'
     C     *IN16         IFEQ      '1'
     C     BBTYLC        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '031'         DBASE                          * * * * * * * *
     C                   MOVEL     BVDR2         DBKEY                          *  DBERR 031  *
     C                   MOVEL     'SDCUSTL1'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C*
     C                   ELSE
     C*
     C** RECORD IS FOUND, STORE SHORTNAME (CEDEL SHORTNAME)
     C** AND CEDEL CUSTOMER NO
     C                   MOVE      BBCSSN        WWCEDL
     C**********           MOVELBVDR2     WWCEDN  60                                          CSD027
     C                   MOVEL     BVDR2         WWCEDN            6
     C                   END
     C*
     C** ACCESS SDMGMEPD FOR MESSAGE GENERATION & MESSAGE MANAGEMENT
     C     1             SETLL     SDMGMEPD
     C                   READ      SDMGMEPD                               18
     C*
     C** IF RECORD NOT FOUND OR LAST CHANGE TYPE = 'D'
     C     *IN18         IFEQ      '1'
     C     ENTYLC        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '034'         DBASE                          * * * * * * * *
     C                   MOVEL     *BLANKS       DBKEY                          *  DBERR 034  *
     C                   MOVEL     'SDMGMEPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FULL IN THE ARRAY FOR FIELDS REQUIREMENTS
     C                   Z-ADD     0             I                 3 0
     C*****1****         SETLL     MGE580PD                                                 MD058081
     C**********         READ      MGE580PD                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ declare ACursor insensitive scroll cursor for                                       MD058081
     C+ select * from MG580JW0                                                              MD058081
     C+ order by MGMATX                                                                     MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ open ACursor                                                                        MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MGE580                                                MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C******IN60         DOWEQ     '0'                                                      MD058081
     C     SQLCODE       DOWEQ     0                                                        MD058081
     C                   ADD       1             I
     C                   MOVEL     MGMATX        ARR1(I)
     C**********         READ      MGE580PD                               60                MD058081
     C/EXEC SQL                                                                             MD058081
     C+ fetch next from ACursor into :MGE580                                                MD058081
     C/END-EXEC                                                                             MD058081
     C                   END
     C*
     C/EXEC SQL                                                                             MD058081
     C+ close ACursor                                                                       MD058081
     C/END-EXEC                                                                             MD058081
                                                                                            MD058081
     C** STORE HEX DETAILS OF CRLF CONTROL CHARACTER
     C                   MOVE      *LOVAL        CTRC
     C                   BITON     '457'         WWCR
     C                   BITON     '257'         WWLF
     C*
      ** Check if (CSW003) MT5XX - Phase 2 Message Generation is on.      CSW003
      *                                                                   CSW003
     C                   CALL      'AOSARDR0'                                                  CSW00
     C                   PARM      '*BLANKS'     WRTCD             7                           CSW00
     C                   PARM      '*VERIFY'     WOPTN             7                           CSW00
     C                   PARM      'CSW003'      @SARD             6                           CSW00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSW00
      *                                                                   CSW003
     C     WRTCD         IFEQ      *BLANKS                                                     CSW00
     C                   MOVE      'Y'           CSW003            1                           CSW00
     C                   ENDIF                                                                 CSW00
      *                                                                   CSW003
     C**  Access SAR details file to see if CEU005 SAR is installed.      CEU005
     C*                                                                   CEU005
     C                   CALL      'AOSARDR0'                                                  CEU00
     C                   PARM      *BLANKS       WRTCD                                         CEU00
     C                   PARM      '*VERIFY'     WOPTN                                         CEU00
     C                   PARM      'CEU005'      @SARD                                         CEU00
     C*                                                                   CEU005
     C     @RTCD         IFEQ      *BLANK                                                      CEU00
     C                   MOVE      'Y'           CEU005            1                           CEU00
     C                   ELSE                                                                  CEU00
     C                   MOVE      'N'           CEU005                                        CEU00
     C                   ENDIF                                                                 CEU00
     C/COPY WNCPYSRC,MG0580C002
     C*                                                                   CEU005
      ** Call SWIF2001 to check if CSW201 is switched on.                                     CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       PRTCD             7
      *                                                                                       CSW201
      ** If return with an error (LR seton in called program) then                            CSW201
      ** process for database error.                                                          CSW201
      *                                                                                       CSW201
     C     *IN90         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     047           DBASE
     C                   MOVEL     'SWIF2001'    DBFILE
     C                   MOVE      '*CALL   '    DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       CSW201
     C     PRTCD         IFEQ      'CSW2001'
     C                   MOVE      'Y'           CSW201            1
     C                   ELSE
     C                   MOVE      'N'           CSW201
     C                   ENDIF
      *                                                                                       CSW201
     C                   ENDIF
      *                                                                                       CSW201
      ** Is CSW025 installed?                                                                 CSW025
      *                                                                                       CSW025
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW025'      @SARD
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '048'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSW025            1
     C                   ENDIF
      *                                                                                       CSW025
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  INTF      - INITIALISE NON-CONSTANT FIELDS                  *
     C**                                                              *
     C**  CALLS     - MG5900, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESS                                    *
     C**                                                              *
     C*****************************************************************
     C*
     C     INTF          BEGSR
     C*                                                                   089450
     C** CHECK IF DESTINATION IS EOC OR CEDEL                             089450
     C                   MOVE      MGDEST        ZZCNUM                                        08945
     C     ZZCNUM        CHAIN     SDSECSL1                           13                       08945
     C     *IN13         IFEQ      '1'                                                         08945
     C     *LOCK         IN        LDA                                                         08945
     C                   MOVE      '068'         DBASE                          * * * * * * * *08945
     C                   MOVEL     ZZCNUM        DBKEY                          *  DBERR 068  *08945
     C                   MOVEL     'SDSECSL1'    DBFILE                         * * * * * * * *08945
     C                   MOVEL     'MG0580'      DBPGM                                         08945
     C                   OUT       LDA                                                         08945
     C                   EXSR      *PSSR                                                       08945
     C                   END                                                                   08945
     C*                                                                   089450
     C                   MOVE      *BLANKS       WWSENT                                        08945
     C     BFCLAS        IFEQ      'E'                                                         08945
     C                   MOVE      'EOC  '       WWSENT                                        08945
     C                   END                                                                   08945
     C     BFCLAS        IFEQ      'C'                                                         08945
     C                   MOVE      'CEDEL'       WWSENT                                        08945
     C                   END                                                                   08945
     C*
     C** OBTAIN SEQUENCE NUMBERS FROM TRANSACTION RECORD
     C** IF SENT TO CEDEL, MODE IS 'L' INSTEAD OF ' '
     C     MGDEST        IFEQ      WWCEDN
     C     WWSENT        OREQ      'CEDEL'
     C                   MOVE      'C'           @MODE
     C                   ELSE
     C                   MOVE      ' '           @MODE
     C                   END
     C*
     C** FORMAT @TRAN AS FOLLOWS
     C** CHARS 1-6 EQUAL TO LEFTMOST 6 CHARS FROM MGTNUM
     C** CHARS 7-13 EQUAL TO BLANKS
     C** CHARS 14-15 EQUAL TO MGTTYP
     C                   MOVEL     MGTNUM        WWFSIX
     C                   MOVEL     WWFSIX        WWTRAN
     C                   MOVE      MGTTYP        WWTRAN
     C*
     C                   CALL      'MG5900'                             20
     C                   PARM      MGMODI        @MODI
     C                   PARM      WWTRAN        @TRAN
     C                   PARM      'PR'          @PROG
     C                   PARM                    @MODE
     C                   PARM      *ZEROS        @LSWS
     C                   PARM      *BLANKS       @ERCD
     C                   PARM      CSW003        @MT5XX                                        CSW00
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN20         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '005'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 005  *
     C                   MOVEL     'MG5900'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM MG5900
     C     @ERCD         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '006'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 006  *
     C                   MOVEL     DBERR         DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5900'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** UPDATE GENERATION GENERATED INDICATOR WITH @MODE = BLANKS
     C                   EXSR      UGGB
     C*
     C** CLEAR MULTIPLE OCCURENCE DATA STRUCTURE, MULT
     C                   Z-ADD     1             X                 3 0
     C     X             OCCUR     MULT
     C*
     C     X             DOWLT     500
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   MOVE      *BLANKS       MULT
     C*
     C** SET INDEX TO FIRST OCCURENCE
     C                   Z-ADD     1             X
     C     X             OCCUR     MULT
     C*
     C** CLEAR MULTIPLE OCCURENCE DATA STRUCTURE, WMULT
     C                   Z-ADD     1             WWZ               3 0
     C     WWZ           OCCUR     WMULT
     C*
     C     WWZ           DOWLE     500
     C     WMULT         ANDNE     *BLANKS
     C                   MOVE      *BLANKS       WMULT
     C                   ADD       1             WWZ
     C     WWZ           OCCUR     WMULT
     C                   END
     C*
     C** SET INDEX TO FIRST OCCURENCE
     C                   Z-ADD     1             WWZ
     C     WWZ           OCCUR     WMULT
     C*
     C** CLEAR MULTIPLE OCCURENCE DS OF RECORDS TO PF/MGOREFPD
     C                   Z-ADD     1             WWTOT1            2 0
     C     WWTOT1        OCCUR     REFDS
     C/COPY WNCPYSRC,MG0580C011
     C*
     C     WWTOT1        DOWLT     5
     C/COPY WNCPYSRC,MG0580C012
     C***********WWLENG    ANDLT2000                                      069020
     C***********REFDS     ANDNE*BLANKS                                   069020
     C                   MOVE      *BLANKS       REFDS
     C                   ADD       1             WWTOT1
     C     WWTOT1        OCCUR     REFDS
     C                   END
     C*
     C** SET INDEX TO FIRST OCCURENCE
     C                   Z-ADD     1             WWTOT1
     C     WWTOT1        OCCUR     REFDS
     C*
     C** CLEAR MULTIPLE OCCURENCE DS OF RECORDS TO PF/MGOMSGPD
     C                   Z-ADD     1             WWTOT1
     C     WWTOT1        OCCUR     TRANS
     C*
     C/COPY WNCPYSRC,MG0580C013
     C     WWTOT1        DOWLT     6
     C/COPY WNCPYSRC,MG0580C014
     C***********WWLENG    ANDLT2000                                      069020
     C***********TRANS     ANDNE*BLANKS                                   069020
     C                   MOVE      *BLANKS       TRANS
     C                   ADD       1             WWTOT1
     C     WWTOT1        OCCUR     TRANS
     C                   END
      *                                                                   183583
      ** Clear multiple occurrence DS for the extension file.             183583
      *                                                                   183583
     C                   Z-ADD     1             V                 2 0                         18358
     C     V             DOWLE     95                                                          18358
     C     MCSI          ANDNE     *BLANKS                                                     18358
     C     V             OCCUR     EXTN                                                        18358
     C                   Z-ADD     *ZEROS        MPSN                                          18358
     C                   MOVE      *BLANKS       MTG                                           18358
     C                   MOVE      *BLANKS       MCSI                                          18358
     C                   ADD       1             V                                             18358
     C                   ENDDO                                                                 18358
     C                   Z-ADD     0             V                                             18358
     C*
     C** SET INDEX TO FIRST OCCURENCE
     C                   Z-ADD     1             WWTOT1
     C     WWTOT1        OCCUR     TRANS
     C*
     C** SET FLAG FOR MESSAGE CORRECTLY GENERATED
     C                   MOVE      *BLANKS       @ERR              1
     C                   MOVE      *BLANKS       WWNGEN            1
     C                   MOVE      *BLANKS       DSERR
     C                   MOVE      *BLANKS       NWERR            50
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  ROUT      - DETERMINE MESSAGE ROUTING                       *
     C**                                                              *
     C**  CALLS     - *PSSR, ZM1100                                   *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESS                                    *
     C**                                                              *
     C*****************************************************************
     C*
     C     ROUT          BEGSR
     C*
     C** ACCESS SDBRCHL1 USING KEY OF MGSNBR FROM PF/MGF554L0
     C     MGSNBR        CHAIN     SDBRCHL1                           13
     C*
     C** IF RECORD NOT FOUND OR LAST CHANGE TYPE = 'D'
     C     *IN13         IFEQ      '1'
     C     A8BRCD        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '007'         DBASE                          * * * * * * * *
     C                   MOVEL     MGSNBR        DBKEY                          *  DBERR 007  *
     C                   MOVEL     'SDBRCHL1'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** DETERMINE NETWORK ROUTING AND ADDRESSES
     C                   MOVE      A8BICN        @SNDR             6
     C                   MOVE      A8BTID        @SCSD            12
     C                   MOVE      MGDEST        @DEST             6
     C                   MOVEL     MGSETP        @SETP             2
     C                   MOVE      *BLANKS       @NWSN            20
     C                   MOVE      *BLANKS       @NWDS            22
     C                   MOVE      *BLANKS       @NWRK             6
     C                   MOVE      *BLANKS       @ERRC             1
     C                   MOVE      *BLANKS       @SRNM            20
     C                   MOVE      *BLANKS       @SRTN            10
     C                   MOVE      *BLANKS       @DRNM            20
     C                   MOVE      *BLANKS       @DRTN            10
     C*
     C                   CALL      'ZM1100'                             21
     C                   PARM                    @SNDR
     C                   PARM                    @SCSD
     C                   PARM                    @DEST
     C                   PARM                    @SETP
     C                   PARM                    @NWSN
     C                   PARM                    @NWDS
     C                   PARM                    @NWRK
     C                   PARM                    @ERRC
     C                   PARM                    @SRNM
     C                   PARM                    @SRTN
     C                   PARM                    @DRNM
     C                   PARM                    @DRTN
     C*
     C** IF PROGRAM ZM1100 NOT FOUND
     C     *IN21         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 008  *
     C                   MOVEL     'ZM1100'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING CALLED PROGRAM
     C     @ERRC         IFEQ      'S'
     C     *LOCK         IN        LDA
     C                   MOVE      '009'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 009  *
     C                   MOVEL     DBERR1        DBKEY                          * * * * * * * *
     C                   MOVEL     'ZM1100'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DESTINATION ERROR MESSAGE
     C     @ERRC         IFEQ      'D'
     C                   MOVE      *BLANKS       DSERR            50
     C                   MOVEL     ERRA(1)       DSERR
     C                   MOVE      'Y'           @ERR
     C                   END
     C*
     C** MOVE DESTINATION CUSTOMER NO. MGDEST INTO CHARACTER
     C** FIELD FOR COMPARISON WITH BVDR1  AND BVDR2 - SDSECSL1
     C                   MOVE      MGDEST        WWCNUM
     C*
     C** CHECK IF DESTINATION IS NOT EOC OR CEDEL ANYWAY
     C                   MOVE      MGDEST        ZZCNUM            6
     C     ZZCNUM        CHAIN     SDSECSL1                           13
     C     *IN13         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '068'         DBASE                          * * * * * * * *
     C                   MOVEL     ZZCNUM        DBKEY                          *  DBERR 068  *
     C                   MOVEL     'SDSECSL1'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   MOVE      *BLANKS       WWSENT            5
     C     BFCLAS        IFEQ      'E'
     C                   MOVE      'EOC  '       WWSENT
     C                   END
     C     BFCLAS        IFEQ      'C'
     C                   MOVE      'CEDEL'       WWSENT
     C                   END
     C*
     C** IF DESTINATION CUSTOMER NO. IS NOT EOC OR CEDEL CUSTOMER NO.
     C     WWCNUM        IFNE      BVDR1
     C     WWCNUM        ANDNE     BVDR2
     C     WWSENT        ANDNE     'EOC  '
     C     WWSENT        ANDNE     'CEDEL'
     C                   MOVE      ERRA(47)      DSERR
     C                   MOVE      'Y'           @ERR
     C                   END
     C*
     C** FORMAT NETWORK ERROR MESSAGE
     C     @NWRK         IFEQ      'UNROUT'
     C                   MOVEL     ERRA(48)      NWERR
     C                   MOVE      'Y'           @ERR
     C                   END
     C*
     C** IF ERROR DETERMINING MESSAGE ROUTING, SET FLAG TO
     C** OUTPUT THIS PART OF MESSAGE TO MG0580P2
     C     @ERR          IFEQ      'Y'
     C                   MOVE      'Y'           WWERR1
     C                   MOVE      'Y'           WWNGEN
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLDR      - DETERMINE FIELD REQUIREMENTS                    *
     C**                                                              *
     C**  CALLS     -                                                 *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLDR          BEGSR
     C*
     C** INITIALIZE VALID FLAG  AND ERROR FLAG
     C                   MOVE      'N'           WWVALD            1
     C                   MOVE      *BLANKS       WWER84            1
     C                   MOVE      *BLANKS       WWCOMB            1
     C                   MOVE      *BLANKS       WWCASR            1
     C*
     C** ERROR IF CUSTOMER NUMBER IS CEDEL
     C** AND CLEARING CUSTOMER IS BLANK
     C     WWCNUM        IFEQ      BVDR2
     C     MGCCTN        ANDEQ     *BLANKS
     C     WWSENT        OREQ      'CEDEL'                                                     CSW00
     C     MGCCTN        ANDEQ     *BLANKS                                                     CSW00
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWER84
     C                   MOVE      'Y'           WWNGEN
     C                   GOTO      ENDFLD
     C                   END
     C*
     C** RECEIVE FREE OF PAYMENT
     C     MGF231        IFEQ      'RECFREE'
     C*
     C** VALIDATIONS
     C     MGINSS        IFEQ      'TRANS'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C                   MOVEL     'Y'           WWCOMB
     C                   GOTO      ENDFLD
     C                   END
     C*
     C** PREVIOUS PROCESSING TO DETECT THE CASE REPLACED BY THE FOLLOWING
     C*
     C** INSTRUCTIONS SUB-TYPE
     C     MGINSS        IFEQ      'SETTL'
     C                   Z-ADD     1             WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'MATCH'
     C                   Z-ADD     2             WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'BOOK '
     C                   Z-ADD     3             WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'PHYSI'
     C                   Z-ADD     4             WWCASE
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C*
     C** RECEIVE AGAINST PAYMENT
     C     MGF231        IFEQ      'RECAPMT'
     C*
     C** VALIDATIONS
     C     MGINSS        IFEQ      'TRANS'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C                   MOVEL     'Y'           WWCOMB
     C                   GOTO      ENDFLD
     C                   END
     C*
     C** INSTRUCTIONS SUB-TYPE
     C     MGINSS        IFEQ      'SETTL'
     C                   Z-ADD     5             WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'MATCH'
     C                   Z-ADD     6             WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'BOOK '
     C                   Z-ADD     7             WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'PHYSI'
     C                   Z-ADD     8             WWCASE
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C*
     C** DELIVER FREE OF PAYMENT
     C     MGF231        IFEQ      'DELFREE'
     C*
     C** INSTRUCTIONS SUB-TYPE
     C     MGINSS        IFEQ      'TRANS'
     C                   Z-ADD     10            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'SETTL'
     C                   Z-ADD     11            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'MATCH'
     C                   Z-ADD     12            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'BOOK '
     C                   Z-ADD     13            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'PHYSI'
     C                   Z-ADD     14            WWCASE
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C*
     C** DELIVER AGAINST PAYMENT
     C     MGF231        IFEQ      'DELAPMT'
     C*
     C** VALIDATIONS
     C     MGINSS        IFEQ      'TRANS'
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C                   MOVEL     'Y'           WWCOMB
     C                   GOTO      ENDFLD
     C                   END
     C*
     C** INSTRUCTIONS SUB-TYPE
     C     MGINSS        IFEQ      'SETTL'
     C                   Z-ADD     15            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'MATCH'
     C                   Z-ADD     16            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'BOOK '
     C                   Z-ADD     17            WWCASE
     C                   ELSE
     C     MGINSS        IFEQ      'PHYSI'
     C                   Z-ADD     18            WWCASE
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C*
     C** DESTINATION CUSTOMER IS EUROCLEAR CUSTOMER NO.
     C     WWCNUM        IFEQ      BVDR1
     C     WWSENT        OREQ      'EOC  '                                                     CSW00
     C                   ADD       19            WWCASE
     C                   END
     C*
     C*
     C** IF VALID THEN SELECT THE ELEMENT OF THE ARRAY CORRESPONDING TO
     C** THE CASE NUMBER SET UP AND MOVE THIS ARRAY FIELD INTO THE
     C** RELEVENT DATA STRUCTURE
     C     WWCASE        IFGT      0
     C                   MOVE      'Y'           WWVALD
     C                   MOVE      WWCASE        J                 2 0
     C                   MOVE      ARR1(J)       WWFLDS
     C                   ELSE
     C*
     C** SET FLAG - FIELD REQUIREMENTS CANNOT BE DETERMINED
     C                   MOVE      'Y'           WWERR1            1
     C                   MOVE      'Y'           WWNGEN
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWCASR
     C                   MOVE      'O'           WWFL14
     C                   END
     C*
     C     ENDFLD        ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  UGGU      - UPDATE GENERATION GENERATED INDICATOR           *
     C**                                                              *
     C**  CALLS     - MG5910                                          *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING, INTF                           *
     C**                                                              *
     C*****************************************************************
     C*
     C     UGGU          BEGSR
     C*
     C** FORMAT @TREF AS FOLLOWS
     C** CHARS 7-13 TO BLANKS
     C** CHARS 14-15 TO MGTTYP
     C                   MOVE      *BLANKS       WWTREF
     C                   MOVEL     MGTNUM        WWFL6             6
     C                   MOVEL     WWFL6         WWTREF
     C                   MOVE      MGTTYP        WWTREF
     C*
     C** IF MGTTYP EQUALS 'DM' AND MGTSTP IS ONE OF THE FOLLOWING
     C     MGTTYP        IFEQ      'DM'
     C     CSW003        ANDNE     'Y'                                                         CSW00
     C*
     C     MGTSTP        IFEQ      'RR'
     C     MGTSTP        OREQ      'RP'
     C     MGTSTP        OREQ      'BB'
     C     MGTSTP        OREQ      'BL'
     C     MGTSTP        OREQ      'PL'
     C     MGTSTP        OREQ      'PD'
     C     MGTSTP        OREQ      'DT'                                                        18524
     C*
     C** MOVE 'A' TO POSITION 13 OF PARAMETER
     C** REM : SEE ALSO MG5910 AND SE1873                                 CSW003
     C                   MOVEL     'A'           WT1313
     C                   END
     C*
     C                   END
     C*
     C** CANCELLATION CEDEL
     C     CEDPRO        IFEQ      'N'
     C                   MOVEL     'U'           @MODE
     C                   ELSE
     C                   MOVEL     'C'           @MODE
     C                   END
     C*
     C                   CALL      'MG5910'                             27
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTREF        @TREF            15
     C                   PARM      'PR'          @PROG             2
     C                   PARM                    @MODE             1
     C                   PARM      *BLANKS       @CONG             1
     C                   PARM      *BLANKS       @RCDG             1
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM      CSW003        @MT5XX                                        CSW00
     C*                                                                   CSW003
     C                   MOVEL     @MODI         WWMODE
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN27         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '039'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 039  *
     C                   MOVEL     'MG5910'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM
     C     @ERCD         IFEQ      'Y'
     C     MGTSTP        ANDNE     'DT'                                                        18524
     C     MGTSTP        ANDNE     'RP'                                                        18524
     C     MGTSTP        ANDNE     'RR'                                                        18524
     C     MGTSTP        ANDNE     'BL'                                                        18524
     C     MGTSTP        ANDNE     'BB'                                                        18524
     C     MGTSTP        ANDNE     'PL'                                                        18524
     C     MGTSTP        ANDNE     'PD'                                                        18524
     C     *LOCK         IN        LDA
     C                   MOVE      '040'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 040  *
     C                   MOVEL     DBERR2        DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF @RCDG EQUALS 'Y'  AND MESSAGE NOT CANCELLATION CEDEL
     C** OR IF @RCDG EQUALS 'N' AND MESSAGE IS CANCELLATION CEDEL
     C     @RCDG         IFEQ      'Y'
     C     CEDPRO        ANDEQ     'N'
     C     MGTSTP        ANDNE     'DT'                                                        18524
     C     MGTSTP        ANDNE     'RP'                                                        18524
     C     MGTSTP        ANDNE     'RR'                                                        18524
     C     MGTSTP        ANDNE     'BL'                                                        18524
     C     MGTSTP        ANDNE     'BB'                                                        18524
     C     MGTSTP        ANDNE     'PL'                                                        18524
     C     MGTSTP        ANDNE     'PD'                                                        18524
     C     @RCDG         OREQ      'N'
     C     CEDPRO        ANDEQ     'Y'
     C     MGTSTP        ANDNE     'DT'                                                        18524
     C     MGTSTP        ANDNE     'RP'                                                        18524
     C     MGTSTP        ANDNE     'RR'                                                        18524
     C     MGTSTP        ANDNE     'BL'                                                        18524
     C     MGTSTP        ANDNE     'BB'                                                        18524
     C     MGTSTP        ANDNE     'PL'                                                        18524
     C     MGTSTP        ANDNE     'PD'                                                        18524
     C     *LOCK         IN        LDA
     C                   MOVE      '041'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 041  *
     C                   MOVEL     DBERR2        DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  UGGB      - UPDATE GENERATION GENERATED INDICATOR           *
     C**                                                              *
     C**  CALLS     - MG5910                                          *
     C**                                                              *
     C**  CALLED BY - INTF                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     UGGB          BEGSR
     C*
     C** FORMAT @TREF AS FOLLOWS
     C** CHARS 7-13 TO BLANKS
     C** CHARS 14-15 TO MGTTYP
     C                   MOVE      *BLANKS       WWTREF
     C                   MOVEL     MGTNUM        WWFL6
     C                   MOVEL     WWFL6         WWTREF
     C                   MOVE      MGTTYP        WWTREF
     C*
     C** IF MGTTYP EQUALS 'DM' AND MGTSTP IS ONE OF THE FOLLOWING
     C     MGTTYP        IFEQ      'DM'
     C     CSW003        ANDNE     'Y'                                                         CSW00
     C*
     C     MGTSTP        IFEQ      'RR'
     C     MGTSTP        OREQ      'RP'
     C     MGTSTP        OREQ      'BB'
     C     MGTSTP        OREQ      'BL'
     C     MGTSTP        OREQ      'PL'
     C     MGTSTP        OREQ      'PD'
     C     MGTSTP        OREQ      'DT'                                                        18524
     C*
     C** MOVE 'A' TO POSITION 13 OF PARAMETER
     C                   MOVEL     'A'           WT1313
     C                   END
     C*
     C                   END
     C*
     C                   CALL      'MG5910'                             27
     C                   PARM      MGMODI        @MODI             2
     C                   PARM      WWTREF        @TREF            15
     C                   PARM      'PR'          @PROG             2
     C                   PARM      *BLANKS       @MODE             1
     C                   PARM      *BLANKS       @CONG             1
     C                   PARM      *BLANKS       @RCDG             1
     C                   PARM      *BLANKS       @ERCD             1
     C                   PARM      CSW003        @MT5XX                                        CSW00
     C*                                                                   CSW003
     C                   MOVEL     @MODI         WWMODE
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN27         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '042'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 042  *
     C                   MOVEL     'MG5910'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM
     C     @ERCD         IFEQ      'Y'
     C     MGTSTP        ANDNE     'DT'                                                        18524
     C     MGTSTP        ANDNE     'RP'                                                        18524
     C     MGTSTP        ANDNE     'RR'                                                        18524
     C     MGTSTP        ANDNE     'BL'                                                        18524
     C     MGTSTP        ANDNE     'BB'                                                        18524
     C     MGTSTP        ANDNE     'PL'                                                        18524
     C     MGTSTP        ANDNE     'PD'                                                        18524
     C     *LOCK         IN        LDA
     C                   MOVE      '043'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 043  *
     C                   MOVEL     DBERR2        DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF @RCDG EQUALS 'Y'  AND MESSAGE NOT CANCELLATION CEDEL
     C** OR IF @RCDG EQUALS 'N' AND MESSAGE IS CANCELLATION CEDEL
     C     @RCDG         IFEQ      'Y'
     C     CEDPRO        ANDEQ     'N'
     C     MGTSTP        ANDNE     'DT'                                                        18524
     C     MGTSTP        ANDNE     'RP'                                                        18524
     C     MGTSTP        ANDNE     'RR'                                                        18524
     C     MGTSTP        ANDNE     'BL'                                                        18524
     C     MGTSTP        ANDNE     'BB'                                                        18524
     C     MGTSTP        ANDNE     'PL'                                                        18524
     C     MGTSTP        ANDNE     'PD'                                                        18524
     C     @RCDG         OREQ      'N'
     C     CEDPRO        ANDEQ     'Y'
     C     MGTSTP        ANDNE     'DT'                                                        18524
     C     MGTSTP        ANDNE     'RP'                                                        18524
     C     MGTSTP        ANDNE     'RR'                                                        18524
     C     MGTSTP        ANDNE     'BL'                                                        18524
     C     MGTSTP        ANDNE     'BB'                                                        18524
     C     MGTSTP        ANDNE     'PL'                                                        18524
     C     MGTSTP        ANDNE     'PD'                                                        18524
     C     *LOCK         IN        LDA
     C                   MOVE      '044'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 044  *
     C                   MOVEL     DBERR2        DBKEY                          * * * * * * * *
     C                   MOVEL     'MG5910'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  RSEQ      - FORMAT FIELDS FOR REPETITIVE SEQUENCE           *
     C**                                                              *
     C**  CALLS     - FLDR, FLD23, FLD30, FLD20R, FLD31P, FLD31T,     *
     C**            - FLD26J, FLD35A, FLD35B, FLD35E, FLD83R, FLD83C, *
     C**            - FLD84A, FLD87A, FLD85A, FLD88A, FLD57A, FLD58A  *
     C**            - FLD33T, FLD32M, FLD37J, FLD34A, FLD37L, FLD37S  *
     C**            - FLD33S, FLD37P, FLD32B, FLD26L, FLD26K, FLD77B  *
     C**            - FLD77D, FLD72, FLD79.                           *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     RSEQ          BEGSR
     C*
     C** IF ERROR FLAG IS NOT SET, DETERMINE REQUIREMENTS
     C     WWERR1        IFNE      'Y'
     C                   EXSR      FLDR
     C                   END
     C*
     C** IF ERROR FLAG IS NOT SET, FORMAT FIELDS
     C     WWERR1        IFNE      'Y'
     C*
     C** FORMAT MANDATORY FIELD :23:
     C                   EXSR      FLD23
     C*
     C** FORMAT FIELD :30:
     C                   EXSR      FLD30
     C*
     C** FORMAT MANDATORY FIELD :20:
     C                   EXSR      FLD20R
     C*
     C** FORMAT FIELD :31P:
     C                   EXSR      FLD31P
     C*
     C** FORMAT FIELD :31T:
     C                   EXSR      FLD31T
     C*
     C** FORMAT FIELD :26J:
     C                   EXSR      FLD26J
     C*
     C** FORMAT FIELD :35A:
     C                   EXSR      FLD35A
     C*
     C** FORMAT FIELD :35B:
     C                   EXSR      FLD35B
     C*
     C** FORMAT FIELD :35E:
     C                   EXSR      FLD35E
     C*
     C** FORMAT FIELD :83R:
     C                   EXSR      FLD83R
     C*
     C** FORMAT FIELD :83C:
     C                   EXSR      FLD83C
     C*
     C** FORMAT FIELD :84A:
     C                   EXSR      FLD84A
     C*
     C** FORMAT FIELD :87a:
     C                   EXSR      FLD87A
     C*
     C** FORMAT FIELD :85a:
     C                   EXSR      FLD85A
     C*
     C** FORMAT FIELD :88a:
     C                   EXSR      FLD88A
     C*
     C** FORMAT FIELD :57a:
     C                   EXSR      FLD57A
     C*
     C** FORMAT FIELD :58a:
     C                   EXSR      FLD58A
     C*
     C** FORMAT FIELD :33T:
     C                   EXSR      FLD33T
     C*
     C** FORMAT FIELD :32M:
     C                   EXSR      FLD32M
     C*
     C** FORMAT FIELD :37J:
     C                   EXSR      FLD37J
     C*
     C** FORMAT FIELD :34a:
     C                   EXSR      FLD34A
     C*
     C** FORMAT FIELD :37L:
     C                   EXSR      FLD37L
     C*
     C** FORMAT FIELD :37S:
     C                   EXSR      FLD37S
     C*
     C** FORMAT FIELD :33S:
     C                   EXSR      FLD33S
     C*
     C** FORMAT FIELD :37P:
     C                   EXSR      FLD37P
     C*
     C** FORMAT FIELD :32B:
     C                   EXSR      FLD32B
     C*
     C** FORMAT FIELD :26L:
     C                   EXSR      FLD26L
     C*
     C** FORMAT FIELD :26K:
     C                   EXSR      FLD26K
     C*
     C** FORMAT FIELD :77B:
     C                   EXSR      FLD77B
     C*
     C** FORMAT FIELD :77D:
     C                   EXSR      FLD77D
     C*
     C** FORMAT FIELD :72:
     C                   EXSR      FLD72
     C*
     C** FORMAT FIELD :79:
     C                   EXSR      FLD79
     C*
     C** FOR FURTHER PROCESSING...
     C                   Z-ADD     X             Y
     C*
     C** SET UP REFERENCE FILE INFORMATION FOR EACH PART OF MT580
     C                   EXSR      WREF
     C*
     C** ELSE ERROR FLAG IS SET
     C                   ELSE
     C*
     C** FORMAT MANDATORY FIELD :23:
     C                   EXSR      FLD23
     C*
     C** FORMAT MANDATORY FIELD :20:
     C                   EXSR      FLD20R
     C*
     C** FORMAT FIELD :84A:
     C                   EXSR      FLD84A
     C*
     C                   MOVE      *BLANKS       WWERR1
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD20N    - FORMAT FIELD :20: (NON-REPETITIVE SEQUENCE)     *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - MAIN                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD20N        BEGSR
     C*
     C** FORMAT DESCRIPTION FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     DESA(5)       MDES
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C***********          MOVEL':20:'    MTAG                            057263
     C                   MOVEL     ':20: '       MTAG                                          05726
     C*
     C** OBTAIN THE LATEST MT580 TRN
     C     *DTAARA       DEFINE                  M5STAT
     C     *LOCK         IN        M5STAT
     C*
     C** CONVERT MT80TR ALPHANUMERIC FIELD TO NUMERIC
     C                   MOVE      MT80TR        WW80TR           13 0
     C                   ADD       1             WW80TR
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WW80TN           16
     C                   MOVE      WW80TR        WW80TN
     C                   MOVEL     'SE8'         WW80TN
     C                   MOVE      *BLANKS       MDAT
     C                   MOVEL     WW80TN        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** UPDATE WMULT WITH DETAILS OF THIS FIELD IN CASE PART OF THIS
     C** MESSAGE IS WRITTEN TO MESSAGES INCORRECTLY GENERATED REPORT
     C                   MOVEL     MDAT          WMDAT
     C                   MOVEL     MERR          WMERR
     C                   MOVEL     MTAG          WMTAG
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE - WMULT
     C                   ADD       1             WWZ
     C     WWZ           OCCUR     WMULT
     C*
     C** UPDATE AND RELEASE DATA AREA
     C                   MOVE      WW80TR        MT80TR
     C                   OUT       M5STAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD23     - FORMAT MANDATORY FIELD :23:                     *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD23         BEGSR
     C*
     C** STORE POSITION ON MULT OCCURENCE DATA STRUCTURE IN CASE
     C** THERE IS AN ERROR IN FORMATTING THIS MESSAGE - OUTPUT THIS
     C** PART OF MESSAGE TO MG0580P2
     C                   Z-ADD     X             WWX1              3 0
     C*
     C** IF ERROR FLAG IS SET FORMAT ERROR MESSAGE (COMBINATION ERROR)
     C     WWCOMB        IFEQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(3)       MERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** END OF FIELD :23: PROCESSING
     C                   GOTO      END23
     C                   END
     C*
     C** IF ERROR FLAG IS SET FORMAT ERROR MESSAGE (CASE IS ZERO)
     C     WWCASR        IFEQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(4)       MERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** END OF FIELD :23: PROCESSING
     C                   GOTO      END23
     C*
     C                   END
     C*
     C     MGGDEL        IFNE      *BLANKS
     C     MGGDEL        ANDNE     'G'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(5)       MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** END OF FIELD :23: PROCESSING
     C                   GOTO      END23
     C                   END
     C*
     C** INCREASE LENGTH
     C                   ADD       22            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(2)       MDES
     C*
     C** FORMAT TAG FIELD
     C***********          MOVEL':23:'    MTAG                            057263
     C                   MOVEL     ':23: '       MTAG                                          05726
     C*
     C     MGINSS        IFEQ      *BLANKS
     C     MGINSS        OREQ      'SETTL'
     C     MGINSS        OREQ      'BOOK '
     C     MGINSS        OREQ      'PHYSI'
     C*
     C** FORMAT DATA FIELD OF MULTIPLE OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     MGF231        WD0107
     C*
     C     MGGDEL        IFEQ      'G'
     C                   MOVEL     '//G'         WD0810
     C                   END
     C*
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C                   ELSE
     C*
     C*  ELSE MGFID2 IS NOT BLANK
     C** FORMAT DATA FIELD OF MULTIPLE OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     MGF231        WD0107
     C                   MOVE      '/'           WD0808
     C                   MOVEL     MGINSS        WD0913
     C*
     C     MGGDEL        IFEQ      'G'
     C                   MOVEL     '/G '         WD1416
     C                   END
     C*
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   END
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C     END23         ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD30     - FORMAT FIELD :30:                               *
     C**                                                              *
     C**  CALLS     - ZM0060, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD30         BEGSR
     C*
     C** CHECK IF FIELD IS MANDATORY FOR THIS MESSASGE
     C     WWFL04        IFEQ      'M'
     C     MGSDAT        ANDEQ     0
     C     MGINSS        ANDNE     'MATCH'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(6)       MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :30: PROCESSING IF
     C** FIELD IS NOT REQUIRED OR MGSDAT IS ZERO
     C     WWFL04        IFNE      'N'
     C     MGSDAT        ANDNE     0
     C*
     C** INCREASE LENGTH
     C                   ADD       12            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(1)       MDES
     C*
     C** FORMAT TAG FIELD
     C***********          MOVEL':30:'    MTAG                            057263
     C                   MOVEL     ':30: '       MTAG                                          05726
     C*
     C** CONVERT TRADE DATE TO SWIFT FORMAT
     C                   CALL      'ZM0060'                             22
     C                   PARM      MGSDAT        ZMDAY
     C                   PARM      *BLANKS       ZSDATE
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '010'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 010  *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSDATE        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     WWYEAR        WRYEAR
     C                   MOVEL     WWMNTH        WRMNTH
     C                   MOVEL     WWDAY         WRDAY
     C                   MOVEL     WRDATE        RDAT
     C*
     C** STORE DATE FOR WRITE TO SWIFT DATABASE FILES
     C                   MOVEL     ZSDATE        WWDATE            6
     C*
     C** CONVERT HISTORY RETENTION DATE TO SWIFT FORMAT
     C     MGDEST        IFNE      WWCEDN
     C     WWSENT        ANDNE     'CEDEL'
     C     MGSDAT        ADD       ENDSMN        ZMDAY
     C                   ELSE
     C     MGSDAT        ADD       60            ZMDAY
     C                   END
     C                   MOVE      *BLANKS       ZSDATE
     C*
     C                   CALL      'ZM0060'                             22
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '035'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 035  *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** SET HISTORY RETENTION DATE HRDT TO ZSDATE
     C                   MOVEL     ZSDATE        WWHIST            6
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD20R    - FORMAT MANDATORY FIELD :20: (REPETITIVE SEQ)    *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD20R        BEGSR
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER20            1
     C*
     C** IF TRANSACTION TYPE NOT VALID SET FLAG FOR ERROR IN FIELD :20:
     C     MGTTYP        IFNE      'TR'
     C     MGTTYP        ANDNE     'TS'                                                        CSW00
     C     MGTTYP        ANDNE     'DM'
     C     MGTTYP        ANDNE     'DN'                                                        CSW00
     C                   MOVE      'Y'           WWER20
     C                   END
     C*
     C     MGMODI        IFNE      'SE'                                         1
     C     WWFSIX        OREQ      *BLANKS
     C     WWER20        OREQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ERRA(2)       MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE                                                   X1
     C*
     C** INCREASE LENGTH
     C                   ADD       22            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     DESA(5)       MDES
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C***********          MOVEL':20:'    MTAG                            057263
     C                   MOVEL     ':20: '       MTAG                                          05726
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C*
     C** IF DESTINATION IS NOT CEDEL
     C     MGDEST        IFNE      WWCEDN                                       2
     C     WWSENT        ANDNE     'CEDEL'
     C*
     C** POSITIONS 1-3
     C     MGMODI        IFEQ      'SE'                                         3
     C     MGTTYP        ANDEQ     'TR'
     C                   MOVEL     'SET'         WD0103
     C                   ELSE
     C     MGMODI        IFEQ      'SE'
     C     MGTTYP        ANDEQ     'DM'
     C                   MOVEL     'SED'         WD0103
     C                   ELSE                                                                  CSW00
     C     MGMODI        IFEQ      'SE'                                                        CSW00
     C     MGTTYP        ANDEQ     'DN'                                                        CSW00
     C                   MOVEL     'SEE'         WD0103                                        CSW00
     C                   ELSE                                                                  CSW00
     C     MGMODI        IFEQ      'SE'                                                        CSW00
     C     MGTTYP        ANDEQ     'TS'                                                        CSW00
     C                   MOVEL     'SEU'         WD0103                                        CSW00
     C                   ENDIF                                                                 CSW00
     C                   ENDIF                                                                 CSW00
     C                   END
     C                   END                                                    E3
     C*
     C** POSITIONS 4-9
     C                   MOVEL     MGTNUM        WD0409
     C** POSITIONS 10-12
     C     @LSWS         IFEQ      9999999
     C                   Z-ADD     1             WWLSWS            7 0
     C                   ELSE
     C     @LSWS         ADD       1             WWLSWS
     C                   END
     C                   MOVEL     WWLSWS        WD1016
     C*
     C                   ELSE                                                   X2
     C** DESTINATION IS CEDEL
     C*
     C** OBTAIN THE LATEST MT580 TRN FOR CEDEL
     C     *LOCK         IN        M5STAT
     C*
     C** CONVERT MT80CE ALPHANUMERIC FIELD TO NUMERIC
     C                   MOVE      MT80CE        WW80CE            7 0
     C     WW80CE        IFEQ      9999999
     C                   Z-ADD     1             WW80CE
     C                   ELSE
     C                   ADD       1             WW80CE
     C                   END
     C     MGTTYP        IFEQ      'DM'
     C                   MOVEL     '001'         WD0103
     C                   ELSE
     C     MGTTYP        IFEQ      'DN'                                                       CSW003
     C                   MOVEL     '002'         WD0103                                       CSW003
     C                   ELSE                                                                 CSW003
     C     MGTTYP        IFEQ      'TS'                                                       CSW003
     C                   MOVEL     '003'         WD0103                                       CSW003
     C                   ELSE                                                                 CSW003
     C                   MOVEL     '000'         WD0103
     C                   END
     C                   ENDIF                                                                CSW003
     C                   ENDIF                                                                CSW003
     C                   MOVEL     MGTNUM        WD0409
     C                   MOVEL     WW80CE        WD1016
     C*
     C** UPDATE AND RELEASE DATA AREA
     C                   MOVE      WW80CE        MT80CE
     C                   OUT       M5STAT
     C*
     C                   END                                                    E2
     C*
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** SAVE DATA FIELD IN WORK FIELD (FOR WRITE TO MGF579PD)
     C                   MOVEL     WWMDAT        WWD579           16
     C*
     C** SAVE DATA FIELD IN WORK FIELD (FOR WRITE TO MGOREFPD)
     C                   MOVEL     WWMDAT        WWDATA           16
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD31P    - FORMAT FIELD :31P:                              *
     C**                                                              *
     C**  CALLS     - ZM0060, *PSSR,                                  *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD31P        BEGSR
     C*
     C** SET FLAG TO INDICATE FIELD :31P: PRESENT IN THIS SEQUENCE
     C                   MOVE      'Y'           WWF31P            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE THEN
     C** DATE OF TRADE MUST NOT BE ZERO OR > SETTLEMENT DATE
     C     WWFL06        IFEQ      'M'
     C     MGTDAT        IFEQ      0
     C     MGTDAT        ORGT      MGSDAT
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(7)       MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** END OF FIELD :31P: PROCESSING
     C                   GOTO      END31P
     C                   END
     C                   END
     C*
     C** END OF FIELD :31P: PROCESSING IF
     C** FIELD IS NOT REQUIRED OR MGTDAT IS ZERO
     C     WWFL06        IFEQ      'N'
     C     MGTDAT        OREQ      0
     C                   MOVE      'N'           WWF31P
     C*
     C                   ELSE
     C*
     C** INCREASE LENGTH
     C                   ADD       17            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(3)       MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':31P:'       MTAG
     C*
     C** CONVERT TRADE DATE TO SWIFT FORMAT
     C                   CALL      'ZM0060'                             22
     C                   PARM      MGTDAT        ZMDAY             5 0
     C                   PARM      *BLANKS       ZSDATE            6
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '029'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 029  *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     *BLANKS       WWMDAT
     C                   MOVEL     *BLANKS       WWRDAT
     C** POSITIONS 1-6
     C                   MOVEL     ZSDATE        WD0106
     C                   MOVEL     WWYEAR        WRYEAR
     C                   MOVEL     WWMNTH        WRMNTH
     C                   MOVEL     WWDAY         WRDAY
     C                   MOVEL     WRDATE        WR0108
     C** POSITIONS 7-10
     C     MGMKTI        IFEQ      'P'
     C                   MOVEL     'PRIM'        WD0710
     C                   MOVEL     'PRIM'        WR0912
     C                   END
     C*
     C     MGMKTI        IFEQ      'S'
     C                   MOVEL     'SECM'        WD0710
     C                   MOVEL     'SECM'        WR0912
     C                   END
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C     END31P        ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD31T    - FORMAT FIELD :31T:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD31T        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE THEN
     C** TIME OF TRADE MUST NOT BE BLANK
     C     WWFL07        IFEQ      'M'
     C     MGTRTT        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(8)       MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :31T: PROCESSING IF FIELD IS NOT
     C** REQUIRED OR MGTRTT IS BLANK OR :31P: NOT PRESENT
     C     WWFL07        IFNE      'N'
     C     MGTRTT        ANDNE     *BLANKS
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       11            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(6)       MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':31T:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGTRTT        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD26J    - FORMAT FIELD :26J:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD26J        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE THEN
     C** REQUESTED PRIORITY MUST BE 1, 2, 3, OR 4
     C     WWFL08        IFEQ      'M'
     C     MGRPTY        ANDNE     '1'
     C     MGRPTY        ANDNE     '2'
     C     MGRPTY        ANDNE     '3'
     C     MGRPTY        ANDNE     '4'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(9)       MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :26J: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR MGRPTY IS BLANK OR MGFID2 = 'MATCH'
     C     WWFL08        IFNE      'N'
     C     MGRPTY        ANDNE     *BLANKS
     C     MGINSS        ANDNE     'MATCH'
     C*
     C** INCREASE LENGTH
     C                   ADD       8             WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(4)       MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':26J:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRPTY        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD35A    - FORMAT FIELD :35A:                              *
     C**                                                              *
     C**  CALLS     - ZM1140 *PSSR                                    *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD35A        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE THEN
     C** QUANTITY OF SECURITIES MUST NOT BE ZERO,
     C** SWIFT SECURITY TYPE MUST BE 'FMT', 'SHS' OR 'WTS'
     C     WWFL09        IFEQ      'M'
     C     MGQANT        ANDEQ     0
     C     MGSWTP        ORNE      'FMT'
     C     MGSWTP        ANDNE     'SHS'
     C     MGSWTP        ANDNE     'WTS'
     C     MGSWTP        ANDNE     'UNT'                                                       18413
     C     MGSWTP        ANDNE     'RTS'                                                       18413
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(10)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :35A: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR MGQANT IS ZERO
     C     WWFL09        IFNE      'N'
     C     MGQANT        ANDNE     0
     C*
     C** INCREASE LENGTH
     C                   ADD       25            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(7)       MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':35A:'       MTAG
     C*
     C** CONVERT MIDAS AMOUNT TO SWIFT FORMAT
     C                   CALL      'ZM1140'                             23
     C                   PARM      MGQANT        ZAMNT            15 0
     C***********          PARM 0         ZCDP    10                      078256
     C                   PARM      MGNMDP        ZCDP              1 0                         07825
     C                   PARM      *BLANKS       ZSAMNT           17
     C                   PARM      *BLANKS       ZOAMNT           21
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN23         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '021'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 021  *
     C                   MOVEL     'ZM1140'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     MGSWTP        WD0103
     C                   MOVEL     ZSAMNT        WD0420
     C                   MOVEL     WWMDAT        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVE      *BLANKS       WWRDAT
     C                   MOVEL     MGSWTP        WR0103
     C                   MOVEL     ZOAMNT        WR0424
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD35B    - FORMAT FIELD :35B:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD35B        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE THEN
     C** SECURITY FULL NAME - MGSFN1 MUST NOT BE BLANK
     C     WWFL10        IFEQ      'M'
     C     MGSFN1        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(11)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :35B: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR MGSFN1 IS BLANK
     C     WWFL10        IFNE      'N'
     C     MGSFN1        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       61            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(8)       MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':35B:'       MTAG
     C*
     C** IF ISIN OF SECURITY IS NON BLANK
     C     MGISIN        IFNE      *BLANKS
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C*
     C** CHECK ISIN OR COMMON CODE
     C                   MOVE      MGISIN        WWISIN            1
     C     WWISIN        IFNE      *BLANK
     C                   MOVEL     'ISIN '       WD0105                         ISIN code
     C                   MOVEL     MGISIN        WD0617
     C                   ELSE
     C                   MOVEL     '/XS/'        WD0104                         COMMON code
     C                   MOVEL     MGISIN        WD0516
     C                   END
     C*
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** REMOVE FORBIDDEN CHARACTERS (E.G. %)
     C                   MOVEA     MGSFN1        FORB
     C                   Z-ADD     1             J                 2 0
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '%'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'                                          found.
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN1
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '&'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN1
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '/'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN1
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '$'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN1
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J                                             05653
     C     FORB(J)       DOWEQ     '-'                                                         05653
     C     FORB(J)       OREQ      ' '                                                         05653
     C     FORB(J)       OREQ      ':'                                                         05653
     C                   ADD       1             J                                             05653
     C                   MOVE      *BLANKS       MGSFN1                                        05653
     C                   MOVEA     FORB(J)       MGSFN1                                        05653
     C     J             IFEQ      50                                                          05653
     C     FORB(50)      IFEQ      '-'                                                         05653
     C     FORB(50)      OREQ      ':'                                                         05653
     C                   MOVE      *BLANKS       MGSFN1                                        05653
     C                   ENDIF                                                                 05653
     C                   LEAVE                                                                 05653
     C                   ENDIF                                                                 05653
     C                   ENDDO                                                                 05653
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGSFN1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** IF SECURITY FULL NAME 2 IS NON BLANK
     C     MGSFN2        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       37            WWLENG
     C*
     C** REMOVE FORBIDDEN CHARACTERS (E.G. %)
     C                   MOVEA     MGSFN2        FORB
     C                   Z-ADD     1             J                 2 0
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '%'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'                                          found.
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN2
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '&'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN2
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '/'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN2
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J
     C     *IN85         DOUEQ     '0'                                                         05653
     C     '$'           LOOKUP    FORB(J)                                85
     C     *IN85         IFEQ      '1'
     C                   MOVE      ' '           FORB(J)
     C                   MOVEA     FORB          MGSFN2
     C                   END
     C                   ENDDO                                                                 05653
     C                   Z-ADD     1             J                                             05653
     C     FORB(J)       DOWEQ     '-'                                                         05653
     C     FORB(J)       OREQ      ' '                                                         05653
     C     FORB(J)       OREQ      ':'                                                         05653
     C                   ADD       1             J                                             05653
     C                   MOVE      *BLANKS       MGSFN2                                        05653
     C                   MOVEA     FORB(J)       MGSFN2                                        05653
     C     J             IFEQ      50                                                          05653
     C     FORB(50)      IFEQ      '-'                                                         05653
     C     FORB(50)      OREQ      ':'                                                         05653
     C                   MOVE      *BLANKS       MGSFN2                                        05653
     C                   ENDIF                                                                 05653
     C                   LEAVE                                                                 05653
     C                   ENDIF                                                                 05653
     C                   ENDDO                                                                 05653
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGSFN2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD35E    - FORMAT FIELD :35E:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD35E        BEGSR
     C*
     C** SET FLAG TO INDICATE '/MSG579/' REQUIRED ON :72: MESSAGE
     C                   MOVE      'Y'           WWM579            1
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER35            1
     C*
     C** RESET CERTIFICATE NUMBERS WORKFIELD
     C                   MOVE      *BLANKS       WKCRTN
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND CERTIFICATE
     C** NUMBERS REQUIRED = 'N' THEN ERROR
     C     WWFL11        IFEQ      'M'
     C     MGCRTN        ANDEQ     'N'
     C                   MOVE      'Y'           WWER35
     C                   END
     C*
     C     WWER35        IFEQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(12)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :35E: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR CERTIFICATE NUMBERS REQUIRED = 'N'
     C     WWFL11        IFEQ      'N'
     C     MGCRTN        OREQ      'N'
     C                   MOVE      'N'           WWM579
     C                   GOTO      END35E
     C                   END
     C*
     C** END OF FIELD :35E: PROCESSING IF
     C** FUNGIBILITY CODE IS NOT '1' OR '2'
     C     MGFCOD        IFNE      '1'
     C     MGFCOD        ANDNE     '2'
     C                   MOVE      'N'           WWM579
     C                   GOTO      END35E
     C                   END
     C*
     C** ACCESS SECRTNL1 USING KEY OF LEFTMOST 6 CHARS OF
     C** MGTNUM - SECRTNL1
     C                   MOVEL     MGTNUM        WWKEY1            6
     C*
     C     *IN51         IFEQ      '0'
     C                   OPEN      SECRTNL1
     C                   MOVE      '1'           *IN51
     C                   END
     C     WWKEY1        CHAIN     SECRTNL1                           17
     C*
     C** IF RECORD FOUND
     C     *IN17         IFEQ      '0'
     C*
     C** WRITE A RECORD TO MGF579PD
     C                   MOVEL     WWD579        MGRREF
     C                   OPEN      MGF579PD
     C                   WRITE     MGF579D0
     C                   CLOSE     MGF579PD
     C                   MOVE      'Y'           WKCRTN
     C                   ELSE
     C*
     C** FORMAT ERROR FIELD
     C                   MOVEL     ERRA(13)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   END
     C*
     C     END35E        ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD83R    - FORMAT FIELD :83R:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD83R        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** SENDER'S ROLE IS BLANK
     C     WWFL12        IFEQ      'M'
     C     MGSROL        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(14)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :83R: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR MGSROL IS BLANK
     C     WWFL12        IFNE      'N'
     C     MGSROL        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       11            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(10)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':83R:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGSROL        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD83C    - FORMAT FIELD :83C:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD83C        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** SAFEKEEPING ACCOUNT IS BLANK
     C     WWFL13        IFEQ      'M'
     C     MGSAFA        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(15)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :83C: PROCESSING IF FIELD IS  REQUIRED
     C     WWFL13        IFNE      'N'
     C     MGSAFA        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       13            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(11)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':83C:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGSAFA        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD84A    - FORMAT FIELD :84A:                              *
     C**                                                              *
     C**  CALLS     - ZM0050, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD84A        BEGSR
     C*
     C** IF ERROR FLAG SET FOR :84A:
     C     WWER84        IFEQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(16)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** CLEARING CRRESPONDENT IS BLANK
     C     WWFL14        IFEQ      'M'
     C     MGCCTN        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(17)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :84A: PROCESSING IF FIELD IS
     C** REQUIRED AND MGCCTN IS NOT BLANK
     C     WWFL14        IFNE      'N'
     C     MGCCTN        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       19            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(12)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':84A:'       MTAG
     C                   MOVE      *BLANKS       SAVMTG                                        18358
     C                   MOVE      MTAG          SAVMTG                                        18358
      *******                                                             113207
     C***FORMAT*DATA*FIELD*OF*MULT*OCCURENCE*DATA*STRUCTURE               113207
     C*******              MOVELMGCCTN    MDAT                            113207
     C*******              MOVELMDAT      RDAT                            113207
     C*******                                                             113207
     C***INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE                    113207
     C*******              ADD  1         X                               113207
     C*******    X         OCUR MULT                                      113207
      **                                                                  113207
      *                                                                   173491
      ** If MGCCTN contains SWIFT ID get necessary data else assume       173491
      ** it is a customer number, or shortname.                           173491
      *                                                                   173491
     C                   MOVE      MGCCTN        WWCCTN           12                           17349
     C     WWCCTN        CHAIN     SDCUSTL7                           69                       17349
     C     *IN69         IFEQ      '0'                                                         17349
     C                   MOVEL     BBCRTN        ZCRTN                                         17349
     C                   MOVEL     BBCRNM        ZCRNM                                         17349
     C                   MOVEL     MGCCTN        ZSADD1                                        17349
     C                   MOVE      *BLANKS       ZSADD2                                        17349
     C                   MOVE      *BLANKS       ZSADD3                                        17349
     C                   MOVE      *BLANKS       ZSADD4                                        17349
     C                   MOVE      *BLANK        ZERR                                          17349
     C                   MOVE      'A'           ZSTAG                                         17349
     C                   MOVEL     ':84A:'       MTAG                                          17349
     C                   MOVE      *BLANKS       SAVMTG                                        18358
     C                   MOVE      MTAG          SAVMTG                                        18358
     C                   ELSE                                                                  17349
     C** Format address fields for tag'A' or 'D'                          113207
     C                   CALL      'ZM1150'                             25                     11320
     C                   PARM      MGCCTN        ZDEST                                         11320
     C                   PARM      *BLANKS       ZSADD1                                        11320
     C                   PARM      *BLANKS       ZSADD2                                        11320
     C                   PARM      *BLANKS       ZSADD3                                        11320
     C                   PARM      *BLANKS       ZSADD4                                        11320
     C                   PARM      *BLANKS       ZSTAG                                         11320
     C                   PARM      *BLANKS       ZSTYPE                                        11320
     C                   PARM      *BLANKS       ZERR                                          11320
     C                   PARM      *BLANKS       ZCRNM                                         11320
     C                   PARM      *BLANKS       ZCRTN                                         11320
     C                   PARM      *BLANK        ZDBEI
     C*                                                                   113207
     C** IF PROGRAM NOT FOUND                                             113207
     C     *IN25         IFEQ      '1'                                                         11320
     C     *LOCK         IN        LDA                                                         11320
     C                   MOVE      '070'         DBASE                          * * * * * * * *11320
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 033  *11320
     C                   MOVEL     'ZM1150'      DBPGM                          * * * * * * * *11320
     C                   OUT       LDA                                                         11320
     C                   EXSR      *PSSR                                                       11320
     C                   END                                                                   11320
     C                   ENDIF                                                                 17349
     C*                                                                   113207
     C** IF ERROR DURING CALLED PROGRAM                                   113207
     C     ZERR          IFEQ      '1'                                                         11320
     C                   MOVEL     ERRA(17)      MERR                                          11320
     C                   MOVE      'Y'           @ERR                                          11320
     C                   MOVE      'Y'           WWNGEN                                        11320
     C*                                                                   113207
     C** INCREASE INDEX FOR MULT OCCURRENCE DATA STRUCTURE                113207
     C                   ADD       1             X                                             11320
     C     X             OCCUR     MULT                                                        11320
     C*                                                                   113207
     C                   ELSE                                                                  11320
     C*                                                                   113207
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE                113207
     C*                                                                   113207
     C** ZSTAG='A'                                                        113207
     C     ZSTAG         IFEQ      'A'                                                         11320
     C                   MOVEL     ':84A:'       MTAG                                          11320
     C                   MOVE      *BLANKS       SAVMTG                                        18358
     C                   MOVE      MTAG          SAVMTG                                        18358
     C                   ELSE                                                                  11320
     C** ZSTAG='D'                                                        113207
     C                   MOVEL     ':84D:'       MTAG                                          11320
     C                   END                                                                   11320
     C*                                                                   113207
     C*                                                                   113207
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCTURE               113207
     C                   MOVEL     MGCCTN        MDAT                                          18358
     C                   EXSR      #ZA                                                         11320
     C*                                                                   113207
     C                   END                                                                   11320
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   Z-ADD     X             Y                 3 0
     C     END84         ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD87A    - FORMAT FIELD :87a:                              *
     C**                                                              *
     C**  CALLS     - ZM1070, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD87A        BEGSR
     C*
     C** RETRIEVE RECEIVER OF SEC. COUNTERPARTY SHORTNAME & TOWN
     C     MGRSS1        IFNE      *BLANKS
     C*
     C***********          MOVE MGRS26    ZZCUST  6                                           CSE022
     C                   MOVE      MGRS26        WZCUST            6
     C                   MOVEL     WZCUST        ZZCUST           20
     C     ZZCUST        CHAIN     SDSECSJ4                           62
     C     *IN62         IFEQ      '1'
     C***********          MOVE MGRS59    ZZCUST                                              CSE022
     C                   MOVE      MGRS26        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ4                           62
     C                   END
     C     *IN62         IFEQ      '1'
     C***********          MOVE MGRS26    ZZCUST                                              CSE022
     C                   MOVE      MGRS59        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ5                           62
     C                   END
     C     *IN62         IFEQ      '1'
     C***********          MOVE MGRS59    ZZCUST                                              CSE022
     C                   MOVE      MGRS27        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ5                           62
     C                   END
     C     *IN62         IFEQ      '1'                                                         06459
     C***********          MOVE MGRS27    ZZCUST                          064596              CSE022
     C                   MOVE      MGRS27        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ4                           62                       06459
     C                   ENDIF                                                                 06459
     C     *IN62         IFEQ      '1'                                                         06459
     C***********          MOVE MGRS27    ZZCUST                          064596              CSE022
     C                   MOVE      MGRS27        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ5                           62                       06459
     C                   ENDIF                                                                 06459
     C     *IN62         IFEQ      '0'
     C                   MOVEL     BBCRNM        R1RDNM
     C                   MOVEL     BBCRTN        R1RDTN
     C                   END
     C                   END
     C*
     C** RETRIEVE DELIVERER OF SEC. COUNTERPARTY SHORTNAME & TOWN
     C     MGDSS1        IFNE      *BLANKS
     C*
     C***********          MOVE MGDS26    ZZCUST                                              CSE022
     C                   MOVE      MGRS26        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ4                           62
     C     *IN62         IFEQ      '1'
     C***********          MOVE MGDS59    ZZCUST                                              CSE022
     C                   MOVE      MGDS59        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ4                           62
     C                   END
     C     *IN62         IFEQ      '1'
     C***********          MOVE MGDS26    ZZCUST                                              CSE022
     C                   MOVE      MGDS26        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ5                           62
     C                   END
     C     *IN62         IFEQ      '1'
     C***********          MOVE MGDS59    ZZCUST                                              CSE022
     C                   MOVE      MGDS59        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ5                           62
     C                   END
     C     *IN62         IFEQ      '1'                                                         06459
     C***********          MOVE MGDS27    ZZCUST                          064596              CSE022
     C                   MOVE      MGDS27        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ4                           62                       06459
     C                   ENDIF                                                                 06459
     C     *IN62         IFEQ      '1'                                                         06459
     C***********          MOVE MGDS27    ZZCUST                          064596              CSE022
     C                   MOVE      MGDS27        WZCUST
     C                   MOVEL     WZCUST        ZZCUST
     C     ZZCUST        CHAIN     SDSECSJ5                           62                       06459
     C                   ENDIF                                                                 06459
     C     *IN62         IFEQ      '0'
     C                   MOVEL     BBCRNM        R1RDNM
     C                   MOVEL     BBCRTN        R1RDTN
     C                   END
     C                   END
     C*
     C** MERGE RECEIVER AND DELIVERER INTO RECEIVER/DELIVERER
     C     MGTSTP        IFEQ      'TP'
     C                   MOVE      MGDSSA        MGRSSA
     C                   MOVE      MGDSSN        MGRSSN
     C                   MOVE      MGDSS1        MGRSS1
     C                   MOVE      MGDSS2        MGRSS2
     C                   MOVE      MGDSS3        MGRSS3
     C                   MOVE      MGDSS4        MGRSS4
     C                   END
     C*
     C** WHEN THE USER WANT TO NOT GENERATE THIS FIELD
     C                   MOVEL     MGRSS1        WKRSS1            1
     C     WKRSS1        IFNE      '#'
     C*
     C** INITIALIZE ERROR INDICATOR & OPTION FIELD
     C                   MOVE      *BLANKS       WWER87            1
     C                   MOVE      *BLANKS       WWOPTC            1
     C*
     C     WWCASE        LOOKUP    ARR2                                   30
     C** IF CASE NUMBER FOUND IN ARRAY THEN ONLY OPTION 'C' IS VALID
     C     *IN30         IFEQ      '1'                                          found.
     C                   MOVE      'Y'           WWOPTC
     C                   END
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE CHECK IF FIELD
     C** CAN BE FORMATTED
     C     WWFL15        IFEQ      'M'
     C*
     C     MGRSSN        IFEQ      *BLANKS
     C     MGRSS1        ANDEQ     *BLANKS
     C     WWOPTC        OREQ      'Y'
     C     MGRSS1        ANDEQ     *BLANKS
     C     WWCASE        OREQ      33
     C     MGRSS1        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWER87
     C                   END
     C                   END
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C     WWER87        IFEQ      'Y'
     C*
     C                   MOVEL     ERRA(20)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** PROCESSING IF FIELD IS NOT REQUIRED
     C     WWFL15        IFEQ      'N'
     C     MGRSSN        OREQ      *BLANKS
     C     MGRSS1        ANDEQ     *BLANKS
     C     WWOPTC        OREQ      'Y'
     C     MGRSS1        ANDEQ     *BLANKS
     C     WWCASE        OREQ      33
     C     MGRSS1        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWER87
     C                   END
     C*
     C** NO ERROR WAS FOUND AND THIS FIELD IS NOT TO BE REMOVED
     C     WWER87        IFNE      'Y'
     C*
     C** INCREASE LENGTH
     C                   MOVEL     MGRSS1        ZZRSS1            2
     C     ZZRSS1        IFEQ      '//'
     C                   ADD       17            WWLENG
     C                   ELSE
     C                   ADD       42            WWLENG
     C                   END
     C*
     C** FORMAT DESCRIPTION FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     DESA(13)      MDES
     C*
     C** (1) - FORMAT DATA FIELD ENTERED FROM SCREEN
     C     MGRSSA        IFNE      *BLANK
     C                   MOVE      '87'          WWTAGN
     C                   MOVE      MGRSSA        WWTAGI
     C                   MOVE      WWTAG         MTAG
     C*
     C** IF MGRSS1 IS BLANK
     C     MGRSS1        IFEQ      *BLANK
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(50)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** IF MGRSS1 IS NOT BLANK
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRSS1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGRSS2 IS NOT BLANK
     C     MGRSS2        IFNE      *BLANK
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRSS2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGRSS3 IS NOT BLANK
     C     MGRSS3        IFNE      *BLANK
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRSS3        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGRSS4 IS NOT BLANK
     C     MGRSS4        IFNE      *BLANK
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRSS4        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   ELSE
     C*
     C** (2) - FORMAT TAG FIELD AS EXPECTED TO BE 'C'
     C     WWOPTC        IFEQ      'Y'
     C                   MOVEL     ':87C:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRSS1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       192221
      ** Include account lines 2 to 4 for tag 87                                              192221
      *                                                                                       192221
     C     MGRSS2        IFNE      *BLANKS
     C                   MOVEL     MGRSS2        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C     MGRSS3        IFNE      *BLANKS
     C                   MOVEL     MGRSS3        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C     MGRSS4        IFNE      *BLANKS
     C                   MOVEL     MGRSS4        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C*
     C                   ELSE
     C*
     C** (3) - ONLY OPTION 'D' IS VALID
     C     WWCASE        IFEQ      8
     C     WWCASE        OREQ      14
     C     WWCASE        OREQ      18
     C     WWCASE        OREQ      33
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':87D:'       MTAG
     C*
     C                   MOVEL     MGRSSN        WWFLD1            1
     C     WWFLD1        LOOKUP    NUM                                    31
     C     *IN31         IFEQ      '1'                                          cust. number
     C                   MOVEL     MGRSSN        WWFLD6            6
     C     WWFLD6        CHAIN     SDCUSTL1                           16
     C                   ELSE                                                   cust. shortname
     C                   MOVEL     MGRSSN        WWCUST           10
     C     WWCUST        CHAIN     SDCUSTL6                           17
     C                   END
     C*
     C** IF NO RECORD FOUND ON SDCUSTL1 OR SDCUSTL6
     C     *IN16         IFEQ      '1'
     C     *IN17         OREQ      '1'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(21)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** ACCOUNT LINE FIELD IS MANDATORY
     C     WWCASE        IFEQ      33
      *                                                                                       192221
      ** Format Rcvr of Securities Account lines for WWCASE = 8 or                            192221
      ** 14 or 18                                                                             192221
      *                                                                                       192221
     C     WWCASE        OREQ      8
     C     WWCASE        OREQ      14
     C     WWCASE        OREQ      18
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   MOVEL     MGRSS1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
      *                                                                                       192221
      ** Format Rcvr of Securities Account lines 2 to 4 if not                                192221
      ** blank                                                                                192221
      *                                                                                       192221
     C     MGRSS2        IFNE      *BLANKS
     C                   MOVEL     MGRSS2        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C     MGRSS3        IFNE      *BLANKS
     C                   MOVEL     MGRSS3        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C     MGRSS4        IFNE      *BLANKS
     C                   MOVEL     MGRSS4        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C     BBCNA2        IFNE      *BLANKS
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C     BBCNA3        IFNE      *BLANKS
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA3        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C     BBCNA4        IFNE      *BLANKS
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA4        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   END
     C*
     C                   END
     C*
     C** (4) - OPTION COULD BE ANYTHING AND IS TO BE RETRIEVED
     C     WWCASE        IFNE      8
     C     WWCASE        ANDNE     14
     C     WWCASE        ANDNE     18
     C     WWCASE        ANDNE     33
     C*
     C** FORMAT ADDRESS FIELDS
     C     WWCASE        IFEQ      3
     C                   MOVE      *BLANKS       WWRSS1
     C                   ELSE
     C                   MOVE      MGRSS1        WWRSS1
     C                   END
     C*
     C                   CALL      'ZM1070'                             26
     C                   PARM      MGRSSN        ZDEST            12
     C                   PARM      WWRSS1        ZACLN            35
     C                   PARM      *BLANKS       ZSADD1           35
     C                   PARM      *BLANKS       ZSADD2           35
     C                   PARM      *BLANKS       ZSADD3           35
     C                   PARM      *BLANKS       ZSADD4           35
     C                   PARM      *BLANKS       ZSTAG             1
     C                   PARM      *BLANKS       ZSTYPE            1
     C                   PARM      *BLANKS       ZERR              1
     C                   PARM      *BLANKS       ZCRNM            20
     C                   PARM      *BLANKS       ZCRTN            10
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN26         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '019'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 019  *
     C                   MOVEL     'ZM1070'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING CALLED PROGRAM
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(21)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ELSE
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C*
     C** IF ZSTAG IS 'A'
     C                   MOVE      *BLANKS       SAVMTG            5                           18358
     C     ZSTAG         IFEQ      'A'
     C                   MOVEL     ':87A:'       MTAG
     C                   MOVE      MTAG          SAVMTG                                        18358
     C                   END
     C*
     C** IF ZSTAG IS 'C'
     C     ZSTAG         IFEQ      'C'
     C                   MOVEL     ':87C:'       MTAG
     C                   ELSE
     C*
     C** IF ZSTAG IS 'D'
     C                   MOVEL     ':87D:'       MTAG
     C                   END
     C*
     C** IF MGRSS1 IS NOT BLANK
     C     MGRSS1        IFNE      *BLANKS
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGRSS1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
      *                                                                                       192221
      ** Include account lines 2 to 4 for tag 87                                              192221
      *                                                                                       192221
     C     MGRSS2        IFNE      *BLANKS
     C                   MOVEL     MGRSS2        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C     MGRSS3        IFNE      *BLANKS
     C                   MOVEL     MGRSS3        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C     MGRSS4        IFNE      *BLANKS
     C                   MOVEL     MGRSS4        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ENDIF
      *                                                                                       192221
     C*
     C** FORMAT ADDRESSES (UP TO 4 OCCURENCES)
     C                   EXSR      #ZA
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C                   MOVEL     *BLANKS       R1RDNM
     C                   MOVEL     *BLANKS       R1RDTN
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD85A    - FORMAT FIELD :85a:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD85A        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** DELIVERER'S INSTRUCTING PARTY IS BLANK
     C     WWFL16        IFEQ      'M'
     C     MGDIPL        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(22)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :85a: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR MGDIPL IS BLANK
     C     WWFL16        IFNE      'N'
     C     MGDIPL        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       13            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(14)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':85C:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGDIPL        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD88A    - FORMAT FIELD :88a:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD88A        BEGSR
     C*
     C** WHEN THE USER WANT TO NOT GENERATE THIS FIELD
     C                   MOVEL     MGBSS1        WKBSS1            1
     C     WKBSS1        IFNE      '#'
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER88            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE CHECK IF FIELD
     C** CAN BE FORMATTED
     C     WWFL17        IFEQ      'M'
     C     MGBSSN        ANDEQ     *BLANKS
     C     MGBSS1        ANDEQ     *BLANKS
     C** WHEN SENT TO CEDEL
     C     WWFL17        OREQ      'M'
     C     WWCNUM        ANDEQ     BVDR2
     C     MGBSSA        ANDEQ     *BLANKS
     C     MGBSSN        ANDEQ     *BLANKS
     C     WWFL17        OREQ      'M'                                                         CSW00
     C     WWSENT        ANDEQ     'CEDEL'                                                     CSW00
     C     MGBSSA        ANDEQ     *BLANKS                                                     CSW00
     C     MGBSSN        ANDEQ     *BLANKS                                                     CSW00
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(23)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** PROCESSING IF FIELD IS NOT REQUIRED
     C     WWFL17        IFEQ      'N'
     C     MGBSSN        OREQ      *BLANKS
     C     MGBSS1        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWER88
     C                   END
     C*
     C** NO ERROR WAS FOUND AND THIS FIELD IS NOT TO BE REMOVED
     C     WWER88        IFNE      'Y'
     C*
     C** FORMAT DESCRIPTION FIELD OF MULT OCCURENCE DATAT STRUCTURE
     C                   MOVEL     DESA(15)      MDES
     C*
     C** (1) - FORMAT DATA FIELD ENTERED FROM SCREEN
     C     MGBSSA        IFNE      *BLANK
     C                   MOVE      '88'          WWTAGN
     C                   MOVE      MGBSSA        WWTAGI
     C                   MOVE      WWTAG         MTAG
     C*
     C** IF MGBSS1 IS BLANK
     C     MGBSS1        IFEQ      *BLANK
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(51)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** IF MGBSS1 IS NOT BLANK
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBSS1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGBSS2 IS NOT BLANK
     C     MGBSS2        IFNE      *BLANK
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBSS2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   ELSE
     C*
     C** (2) FORMAT TAG FIELD AS EXPECTED TO BE 'C' (FOR EUROCLEAR ONLY)
     C     MGBSSN        IFEQ      *BLANKS
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ':88C:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBSS1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** (3) FORMAT TAG FIELD AS EXPECTED TO BE 'D'
     C                   MOVEL     MGBSSN        WWFLD1
     C     WWFLD1        LOOKUP    NUM                                    31
     C     *IN31         IFEQ      '1'                                          cust. number
     C                   MOVEL     MGBSSN        WWFLD6            6
     C     WWFLD6        CHAIN     SDCUSTL1                           16
     C                   ELSE                                                   cust. shortname
     C                   MOVEL     MGBSSN        WWCUST           10
     C     WWCUST        CHAIN     SDCUSTL6                           17
     C                   END
     C*
     C** IF NO RECORD FOUND ON SDCUSTL1 OR SDCUSTL6
     C     *IN16         IFEQ      '1'
     C     *IN17         OREQ      '1'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(24)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ':88D:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C     BBCNA2        IFNE      *BLANKS
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C     BBCNA3        IFNE      *BLANKS
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA3        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C     BBCNA4        IFNE      *BLANKS
     C                   ADD       42            WWLENG
     C                   MOVEL     BBCNA4        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD57A    - FORMAT FIELD :57a:                              *
     C**                                                              *
     C**  CALLS     - ZM0050, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD57A        BEGSR
      *                                                                                       CSW201
      ** Set field not to allow BEIs on field dedicated to financial                          CSW201
      ** Institution when enhancement "SWIFT 2001 Standards Update"                           CSW201
      ** is installed.                                                                        CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C                   MOVE      'Y'           ZDBEI             1
     C                   ENDIF
     C*
     C** WHEN THE USER WANT TO NOT GENERATE THIS FIELD
     C                   MOVEL     MGAWIL        WKAWI1            1
     C     WKAWI1        IFNE      '#'
     C*
     C** SET FLAG TO INDICATE FIELD :57a: FORMATTED
     C                   MOVE      'Y'           WWFM57            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE CHECK IF FIELD
     C** CAN BE FORMATTED
     C     WWFL18        IFEQ      'M'
     C     MGAWIN        ANDEQ     *BLANKS
     C     MGAWIL        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(25)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** PROCESSING IF FIELD IS NOT REQUIRED
     C     WWFL18        IFEQ      'N'
     C     MGAWIN        OREQ      *BLANKS
     C     MGAWIL        ANDEQ     *BLANKS
     C*
     C** SET FLAG TO INDICATE FIELD NOT FORMATTED
     C                   MOVE      'N'           WWFM57
     C                   ELSE
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     DESA(16)      MDES
     C*
     C** (1) - FORMAT DATA FIELD ENTERED FROM SCREEN
     C     MGAWIA        IFNE      *BLANK
     C                   MOVE      '57'          WWTAGN
     C                   MOVE      MGAWIA        WWTAGI
     C                   MOVE      WWTAG         MTAG
     C*
     C** IF MGAWIL IS BLANK
     C     MGAWIL        IFEQ      *BLANK
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(52)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** IF MGAWIL IS NOT BLANK
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGAWIL        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   ELSE
     C*
     C** (2) FORMAT ADDRESS FIELDS FOR TAG 'A' OR 'D'
     C                   CALL      'ZM1150'                             25
     C                   PARM      MGAWIN        ZDEST
     C                   PARM      *BLANKS       ZSADD1
     C                   PARM      *BLANKS       ZSADD2
     C                   PARM      *BLANKS       ZSADD3
     C                   PARM      *BLANKS       ZSADD4
     C                   PARM      *BLANKS       ZSTAG
     C                   PARM      *BLANKS       ZSTYPE
     C                   PARM      *BLANKS       ZERR
     C                   PARM      *BLANKS       ZCRNM
     C                   PARM      *BLANKS       ZCRTN
     C                   PARM                    ZDBEI
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN25         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '033'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 033  *
     C                   MOVEL     'ZM1150'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING CALLED PROGRAM
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(26)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C*
     C** IF ZSTAG IS 'A'
     C                   MOVE      *BLANKS       SAVMTG            5                           18358
     C     ZSTAG         IFEQ      'A'
     C                   MOVEL     ':57A:'       MTAG
     C                   MOVE      MTAG          SAVMTG                                        18358
     C                   ELSE
     C** IF ZSTAG IS 'D'
     C                   MOVEL     ':57D:'       MTAG
     C                   END
     C*
     C     MGAWIL        IFNE      *BLANKS
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGAWIL        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   EXSR      #ZA
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C                   MOVE      *BLANK        ZDBEI
      *                                                                                       CSW201
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD58A    - FORMAT FIELD :58a:                              *
     C**                                                              *
     C**  CALLS     - ZM0050, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD58A        BEGSR
     C*
     C** WHEN THE USER WANT TO NOT GENERATE THIS FIELD
     C                   MOVEL     MGBOF1        WKBOF1            1
     C     WKBOF1        IFNE      '#'
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER58            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** BENEFICIARY OF MONEY IS BLANK
     C     WWFL19        IFEQ      'M'
     C     MGBOFN        ANDEQ     *BLANKS
     C     MGBOF1        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(27)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** PROCESSING IF FIELD IS NOT REQUIRED
     C     WWFL19        IFEQ      'N'
     C     MGBOFN        OREQ      *BLANKS
     C     MGBOF1        ANDEQ     *BLANKS
     C                   MOVE      'Y'           WWER58
     C                   END
     C*
     C** IF FIELD :57a: IS PRESENT THEN FIELD :58a: MUST BE PRESENT
     C     WWFM57        IFEQ      'Y'
     C     WWER58        ANDEQ     'Y'
     C*
     C** FORMAT ERROR FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ERRA(28)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** WHEN FIELD :58a: IS PRESENT FIELD :57a: MUST ALSO BE PRESENT
     C     WWER58        IFEQ      *BLANKS
     C*
     C     WWFM57        IFEQ      'N'
     C*
     C** FORMAT ERROR FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ERRA(29)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(17)      MDES
     C*
     C** (1) - FORMAT DATA FIELD ENTERED FROM SCREEN
     C     MGBOFA        IFNE      *BLANK
     C                   MOVE      '58'          WWTAGN
     C                   MOVE      MGBOFA        WWTAGI
     C                   MOVE      WWTAG         MTAG
     C*
     C** IF MGBOF1 IS BLANK
     C     MGBOF1        IFEQ      *BLANK
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(53)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** IF MGBOF1 IS NOT BLANK
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBOF1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGBOF2 IS NOT BLANK
     C     MGBOF2        IFNE      *BLANK
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBOF2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   ELSE
     C*
     C** (2) FORMAT TAG FIELD AS EXPECTED TO BE 'A' OR 'D'
     C     MGBOFN        IFNE      *BLANKS
     C*
     C** FORMAT ADDRESS FIELDS
     C                   CALL      'ZM1150'                             25
     C                   PARM      MGBOFN        ZDEST
     C                   PARM      *BLANKS       ZSADD1
     C                   PARM      *BLANKS       ZSADD2
     C                   PARM      *BLANKS       ZSADD3
     C                   PARM      *BLANKS       ZSADD4
     C                   PARM      *BLANKS       ZSTAG
     C                   PARM      *BLANKS       ZSTYPE
     C                   PARM      *BLANKS       ZERR
     C                   PARM      *BLANKS       ZCRNM
     C                   PARM      *BLANKS       ZCRTN
     C                   PARM      *BLANK        ZDBEI
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN25         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '028'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 028  *
     C                   MOVEL     'ZM1150'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING CALLED PROGRAM
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(30)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C*
     C** IF ZSTAG IS 'A'
     C                   MOVE      *BLANKS       SAVMTG                                        18358
     C     ZSTAG         IFEQ      'A'
     C                   MOVEL     ':58A:'       MTAG
     C                   MOVE      MTAG          SAVMTG                                        18358
     C                   ELSE
     C** IF ZSTAG IS 'D'
     C                   MOVEL     ':58D:'       MTAG
     C                   END
     C*
     C     MGBOF1        IFNE      *BLANKS
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBOF1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     MGBOF2        IFNE      *BLANKS
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGBOF2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   EXSR      #ZA
     C*
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD33T    - FORMAT FIELD :33T:                              *
     C**                                                              *
     C**  CALLS     - ZM1190, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD33T        BEGSR
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER33            1
     C*
     C** SET FLAG TO INDICATE FIELD :33T: PRESENT IN THIS SEQUENCE
     C                   MOVE      'N'           WWF33T            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE THEN
     C** CHECK IF THE FIELD CAN BE FORMATTED
     C     WWFL20        IFEQ      'M'
     C     MGPRIC        ANDEQ     0
     C                   MOVE      'Y'           WWER33
     C                   END
     C*
     C     MGTTYP        IFEQ      'TR'
     C     MGTTYP        OREQ      'TS'                                                        CSW00
     C     MGTTYP        OREQ      'DM'                                                        CSW00
     C     MGTTYP        OREQ      'DN'                                                        CSW00
     C*
     C     MGSTBS        IFNE      'Y'
     C     MGSTBS        ANDNE     'P'
     C     MGSTBS        ANDNE     'D'
     C                   MOVE      'Y'           WWER33
     C                   END
     C*
     C     MGSTBS        IFEQ      'P'
     C     MGSPBS        IFNE      'P'
     C     MGSPBS        ANDNE     'U'
     C                   MOVE      'Y'           WWER33
     C                   END
     C                   END
     C*
     C                   END
     C*
     C     WWER33        IFEQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(31)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :33T: PROCESSING IF FIELD IS
     C** NOT REQUIRED OR MGPRIC IS ZERO OR FIELD :31P: NOT PRESENT
     C     WWFL20        IFNE      'N'
     C     MGPRIC        ANDNE     0
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       25            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(18)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':33T:'       MTAG
     C*
     C** SET UP BASIS WORK FIELD
      *                                                                   102916
     C     MGSTBS        IFEQ      'Y'                                                         10291
     C                   MOVEL     'YLD'         WWSBAS                                        10291
     C                   END                                                                   10291
     C***********MGSTBS    IFEQ 'Y'                                       102916
     C***********MGSTBS    OREQ 'D'                                       102916
     C     MGSTBS        IFEQ      'D'                                                         10291
     C                   MOVE      'REN'         WWSBAS            3
     C                   END
     C*
     C     MGSTBS        IFEQ      'P'
     C***********MGTTYP    OREQ 'DM'                                      102766
     C***********MGTTYP    OREQ 'DN'                               CSW003 102766
     C*
     C     MGSPBS        IFEQ      'P'
     C***********MGTTYP    ANDEQ'TR'                                      102766
     C***********MGSPBS    OREQ 'P'                                CSW003 102766
     C***********MGTTYP    ANDEQ'TS'                               CSW003 102766
     C                   MOVE      'PCT'         WWSBAS
     C                   ELSE
     C*
     C** MGSPBS IS 'U' OR DEPOT MOVEMENT -
     C** ACCESS SDCURRL1 TO OBTAIN SWIFT CURRENCY CODE
     C     MGNMCY        CHAIN     SDCURRL1                           14
     C*
     C** IF CURRENCY NOT FOUND ON FILE
     C     *IN14         IFEQ      '1'
     C*
     C** FORMAT ERROR FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ERRA(32)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C                   MOVE      MGNMCY        A6SWCY
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   GOTO      END33T
     C                   END
     C*
     C** SET BASIS WORK FIELD TO SWIFT CURRENCY CODE, SDCURRL1
     C                   MOVE      A6SWCY        WWSBAS
     C                   END
     C*
     C                   END
     C*                                                                   068695
     C** Check security price don't contain too many decs FOR EUROCLEAR   068695
     C     MGDEST        IFNE      WWCEDN                                                      06869
     C     WWSENT        ANDNE     'CEDEL'                                                     06869
     C                   Z-ADD     0             CHECK            15 6                         06869
     C                   Z-ADD     0             CHECK1           15 8                         06869
     C                   Z-ADD     0             RESUL            15 8                         06869
     C                   Z-ADD     MGPRIC        CHECK1                                        06869
     C                   Z-ADD     MGPRIC        CHECK                                         06869
     C     CHECK1        SUB       CHECK         RESUL                                         06869
     C     RESUL         IFGT      0                                                           06869
     C*                                                                   068695
     C** FORMAT ERROR FIELD OF MULT OCCURENCE DATA STRUCTURE              068695
     C                   MOVEL     ERRA(54)      MERR                                          06869
     C                   MOVE      'Y'           @ERR                                          06869
     C                   MOVE      'Y'           WWNGEN                                        06869
     C*                                                                   068695
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE                    068695
     C                   ADD       1             X                                             06869
     C     X             OCCUR     MULT                                                        06869
     C                   GOTO      END33T                                                      06869
     C                   END                                                                   06869
     C                   END                                                                   06869
     C*
     C** CONVERT SECURITY PRICE TO SWIFT FORMAT
     C                   CALL      'ZM1190'                             28
     C                   PARM      MGPRIC        ZPRIC            15 8
     C                   PARM      *BLANKS       ZSPRIC           16
     C                   PARM      *BLANKS       ZOPRIC           21
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN28         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '022'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 022  *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** SET FLAG TO INDICATE FIELD :33T: PRESENT IN THIS SEQUENCE
     C                   MOVE      'Y'           WWF33T
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     WWSBAS        WD0103
     C                   MOVEL     ZSPRIC        WD0419
     C                   MOVEL     WWMDAT        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVE      *BLANKS       WWRDAT
     C                   MOVEL     WWSBAS        WR0103
     C                   MOVEL     ZOPRIC        WR0424
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C     END33T        TAG
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD32M    - FORMAT FIELD :32M:                              *
     C**                                                              *
     C**  CALLS     - ZM1240, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD32M        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** DEAL AMOUNT IS ZERO
     C     WWFL21        IFEQ      'M'
     C     MGDLAM        ANDEQ     0
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(33)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :32M: PROCESSING IF FIELD IS NOT REQUIRED
     C** OR MGDLAM IS ZERO OR FIELD :31P: NOT PRESENT
     C     WWFL21        IFNE      'N'
     C     MGDLAM        ANDNE     0
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       25            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(19)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':32M:'       MTAG
     C*
     C** CONVERT MIDAS AMOUNT TO SWIFT FORMAT
     C                   Z-ADD     MGDLAM        ZAMT             13 0
     C                   CALL      'ZM1240'                             29
     C                   PARM                    ZAMT
     C                   PARM      MGNMCY        ZCCY              3
     C                   PARM      *BLANKS       ZSAMNT           17
     C                   PARM      *BLANKS       ZOAMNT           21
     C                   PARM      *BLANKS       ZSCCY             3
     C                   PARM      *BLANKS       ZERR
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN29         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '023'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 023  *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM ZM1240
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(33)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     *BLANKS       WWMDAT
     C                   MOVEL     ZSCCY         WD0103
     C                   MOVEL     ZSAMNT        WD0419
     C                   MOVEL     WWMDAT        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     *BLANKS       WWRDAT
     C                   MOVEL     ZSCCY         WR0103
     C                   MOVEL     ZOAMNT        WR0424
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD37J    - FORMAT FIELD :37J:                              *
     C**                                                              *
     C**  CALLS     - ZM1190, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD37J        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** MGDAXR IS ZERO
     C     WWFL22        IFEQ      'M'
     C     MGDAXR        ANDEQ     0
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(34)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :37J: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE NOT SATISFIED
     C     WWFL22        IFNE      'N'
     C     MGDAXR        ANDNE     0
     C     MGNMCY        ANDNE     MGSTCY
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       19            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(20)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':37J:'       MTAG
     C*
     C** CONVERT EXCHANGE RATE TO SWIFT FORMAT
     C                   CALL      'ZM1190'                             28
     C                   PARM      MGDAXR        ZPRIC
     C                   PARM      *BLANKS       ZSPRIC
     C                   PARM      *BLANKS       ZOPRIC           21
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN28         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '027'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 027  *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSPRIC        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     ZOPRIC        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD34A    - FORMAT FIELD :34a:                              *
     C**                                                              *
     C**  CALLS     - ZM1240, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD34A        BEGSR
     C*
     C** SET FLAG TO INDICATE THAT FIELD :34a: IS PRESENT
     C                   MOVE      'Y'           WWFM34            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND (INTEREST AMOUNT
     C** IS ZERO OR ACCRUED INTEREST CURRENCY IS BLANK)
     C     WWFL23        IFEQ      'M'
     C     MGITRA        IFEQ      0
     C     MGITCY        OREQ      *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(35)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   ELSE
     C*
     C** END OF FIELD :34a: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE NOT SATISFIED
     C     WWFL23        IFNE      'N'
     C     MGITRA        ANDNE     0
     C     MGITCY        ANDNE     *BLANKS
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       30            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(21)      MDES
     C*
     C** FORMAT TAG FIELD
     C     MGACIN        IFEQ      'C'
     C     MGACIN        OREQ      *BLANKS
     C                   MOVEL     ':34G:'       MTAG
     C                   ELSE
     C** ELSE MGACIN = 'X'
     C                   MOVEL     ':34H:'       MTAG
     C                   END
     C*
     C** CONVERT MIDAS AMOUNT TO SWIFT FORMAT
     C                   Z-ADD     MGITRA        ZAMT
     C*
     C                   CALL      'ZM1240'                             29
     C                   PARM                    ZAMT
     C                   PARM      MGITCY        ZCCY
     C                   PARM      *BLANKS       ZSAMNT
     C                   PARM      *BLANKS       ZOAMNT
     C                   PARM      *BLANKS       ZSCCY
     C                   PARM      *BLANKS       ZERR
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN29         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '026'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 026  *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM ZM1240
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(35)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C     MGACND        IFNE      0
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGACND        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     ZSCCY         WD0103
     C                   MOVEL     ZSAMNT        WD0419
     C                   MOVEL     WWMDAT        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVE      *BLANKS       WWRDAT
     C                   MOVEL     ZSCCY         WR0103
     C                   MOVEL     ZOAMNT        WR0424
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   ELSE
     C*
     C** SET FLAG TO INDICATE FIELD IS NOT PRESENT
     C                   MOVE      'N'           WWFM34
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD37L    - FORMAT FIELD :37L:                              *
     C**                                                              *
     C**  CALLS     - ZM1190, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD37L        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** MGITXR IS ZERO
     C     WWFL24        IFEQ      'M'
     C     MGITXR        ANDEQ     0
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(36)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :37L: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE NOT SATISFIED
     C     WWFL24        IFNE      'N'
     C     MGITXR        ANDNE     0
     C     MGITCY        ANDNE     MGSTCY
     C     WWFM34        ANDEQ     'Y'
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       19            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(22)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':37L:'       MTAG
     C*
     C** CONVERT EXCHANGE RATE TO SWIFT FORMAT
     C                   CALL      'ZM1190'                             28
     C                   PARM      MGITXR        ZPRIC
     C                   PARM      *BLANKS       ZSPRIC
     C                   PARM      *BLANKS       ZOPRIC
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN28         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '025'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 025  *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSPRIC        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     ZOPRIC        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD37S    - FORMAT FIELD :37S:                              *
     C**                                                              *
     C**  CALLS     - ZM1190, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD37S        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** ACCRUED INTEREST RATE IS ZERO
     C     WWFL25        IFEQ      'M'
     C     MGITRT        ANDEQ     0
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(37)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :37S: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE NOT SATISFIED
     C     WWFL25        IFNE      'N'
     C     MGITRT        ANDNE     0
     C     MGACND        ANDNE     0
     C     WWFM34        ANDEQ     'Y'
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       24            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(23)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':37S:'       MTAG
     C*
     C** CONVERT EXCHANGE RATE TO SWIFT FORMAT
     C                   CALL      'ZM1190'                             28
     C                   PARM      MGITRT        ZPRIC
     C                   PARM      *BLANKS       ZSPRIC
     C                   PARM      *BLANKS       ZOPRIC
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN28         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '024'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 024  *
     C                   MOVEL     'ZM1190'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C** ZSPRIC WITH '/' ADDED TO FIRST NON BLANK CHARACTER
     C** FOLLOWED BY MGITCB
     C                   MOVEL     ZSPRIC        WWPRIC           17
     C                   MOVEL     ZOPRIC        WOPRIC           22
     C     MGITCB        IFNE      *BLANKS
     C     WWPRIC        CAT       '/':0         WWPRIC
     C     WOPRIC        CAT       '/':0         WOPRIC
     C     WWPRIC        CAT       MGITCB:0      WWPRIC
     C     WOPRIC        CAT       MGITCB:0      WOPRIC
     C                   END
     C*
     C                   MOVEL     WWPRIC        MDAT
     C                   MOVEL     WOPRIC        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD33S    - FORMAT FIELD :33S:                              *
     C**                                                              *
     C**  CALLS     - ZM1240, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD33S        BEGSR
     C*
     C** SET FLAG TO INDICATE FIELD :33S: IS PRESENT
     C                   MOVE      'Y'           WWFM33            1
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER33
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND (SPECIAL
     C** CONCESSIONS AMOUNT IS ZERO OR CURRENCY IS BLANK)
     C     MGSCAM        IFEQ      0
     C     MGSCCY        OREQ      *BLANKS
     C                   MOVE      'Y'           WWER33
     C                   END
     C*
     C     WWFL26        IFEQ      'M'
     C     WWER33        ANDEQ     'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(38)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :33S: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE SATISFIED
     C     WWFL26        IFEQ      'N'
     C     MGSCAM        OREQ      0
     C     MGSCCY        OREQ      *BLANKS
     C     WWF31P        OREQ      'N'
     C*
     C** SET FLAG TO INDICATE FIELD :33S: NOT PRESENT
     C                   MOVE      'N'           WWFM33
     C                   ELSE
     C*
     C** INCREASE LENGTH
     C                   ADD       25            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(24)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':33S:'       MTAG
     C*
     C** CONVERT MIDAS AMOUNT TO SWIFT FORMAT
     C                   Z-ADD     MGSCAM        ZAMT
     C*
     C                   CALL      'ZM1240'                             29
     C                   PARM                    ZAMT
     C                   PARM      MGSCCY        ZCCY
     C                   PARM      *BLANKS       ZSAMNT
     C                   PARM      *BLANKS       ZOAMNT
     C                   PARM      *BLANKS       ZSCCY
     C                   PARM      *BLANKS       ZERR
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN29         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '013'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 013  *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM ZM1240
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(38)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ELSE
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     *BLANKS       WWMDAT
     C                   MOVEL     ZSCCY         WD0103
     C                   MOVEL     ZSAMNT        WD0420
     C                   MOVEL     WWMDAT        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     *BLANKS       WWRDAT
     C                   MOVEL     ZSCCY         WR0103
     C                   MOVEL     ZOAMNT        WR0424
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD37P    - FORMAT FIELD :37P:                              *
     C**                                                              *
     C**  CALLS     - ZM1190, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD37P        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** EXCHANGE RATE IS ZERO
     C     WWFL27        IFEQ      'M'
     C     MGSCXR        ANDEQ     0
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(39)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :37P: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE NOT SATISFIED
     C     WWFL27        IFNE      'N'
     C     MGSCXR        ANDNE     0
     C     MGSCCY        ANDNE     MGSTCY
     C     WWFM33        ANDEQ     'Y'
     C     WWF31P        ANDEQ     'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       19            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(25)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':37P:'       MTAG
     C*
     C** CONVERT SECURITY PRICE TO SWIFT FORMAT
     C                   CALL      'ZM1190'                             28
     C                   PARM      MGSCXR        ZPRIC
     C                   PARM      *BLANKS       ZSPRIC
     C                   PARM      *BLANKS       ZOPRIC
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSPRIC        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     ZOPRIC        RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD32B    - FORMAT FIELD :32B:                              *
     C**                                                              *
     C**  CALLS     - ZM1240, *PSSR                                   *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD32B        BEGSR
     C*
     C** INITIALIZE ERROR FIELD
     C                   MOVE      *BLANKS       WWER32            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** (SETTLEMENT AMOUNT IS ZERO OR CURRENCY IS BLANK)
     C     MGSTAM        IFEQ      0
     C     MGSTCY        OREQ      *BLANKS
     C                   MOVE      'Y'           WWER32
     C                   END
     C*
     C     WWFL28        IFEQ      'M'
     C     WWER32        ANDEQ     'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(40)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :32B: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE NOT SATISFIED
     C     WWFL28        IFNE      'N'
     C     MGSTAM        ANDNE     0
     C     MGSTCY        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       25            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(26)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':32B:'       MTAG
     C*
     C** CONVERT MIDAS AMOUNT TO SWIFT FORMAT
     C                   Z-ADD     MGSTAM        ZAMT
     C                   CALL      'ZM1240'                             29
     C                   PARM                    ZAMT
     C                   PARM      MGSTCY        ZCCY
     C                   PARM      *BLANKS       ZSAMNT
     C                   PARM      *BLANKS       ZOAMNT
     C                   PARM      *BLANKS       ZSCCY
     C                   PARM      *BLANKS       ZERR
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN29         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '012'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 012  *
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** IF ERROR DURING PROGRAM ZM1240
     C     ZERR          IFEQ      '1'
     C                   MOVEL     ERRA(40)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     *BLANKS       WWMDAT
     C                   MOVEL     ZSCCY         WD0103
     C                   MOVEL     ZSAMNT        WD0419
     C                   MOVEL     WWMDAT        MDAT
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE FOR REPORT
     C                   MOVEL     *BLANKS       WWRDAT
     C                   MOVEL     ZSCCY         WR0103
     C                   MOVEL     ZOAMNT        WR0424
     C                   MOVEL     WWRDAT        RDAT
     C*
     C** STORE ZSAMNT IN WORK FIELD FOR SWIFT MESSAGE FILES
     C                   MOVEL     ZSAMNT        WWSAMT           17
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD26L    - FORMAT FIELD :26L:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD26L        BEGSR
     C*
     C** THIS FIELD IS NEVER MANDATORY - IF IT IS NOT PRESENT, A
     C** DEFAULT VALUE OF '0' WILL BE APPLIED BY THE RECEIVER
     C*
     C** END OF FIELD :26L: PROCESSING IF FIELD IS NOT REQUIRED
     C** OR MGFCOD IS BLANK
     C     WWFL29        IFNE      'N'
     C     MGFCOD        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       8             WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(27)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':26L:'       MTAG
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     MGFCOD        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD26K    - FORMAT FIELD :26K:                              *
     C**                                                              *
     C**  CALLS     - ZM1060                                          *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD26K        BEGSR
     C*
     C** INITIALIZE ERROR FIELD
     C                   MOVE      *BLANKS       WWER26            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE CHECK IF FIELD
     C** :26K: CAN BE FORMATTED
     C     WWFL30        IFEQ      'M'
     C     MGCRTN        ANDEQ     'N'
     C                   MOVE      'Y'           WWER26
     C                   END
     C*
     C     MGCRTN        IFEQ      'Y'
     C     WWM579        ANDEQ     'N'
     C*
     C     MGFCOD        IFNE      '0'
     C     MGFCOD        ANDNE     '3'
     C                   MOVE      'Y'           WWER26
     C                   END
     C*
     C                   END
     C*
     C     WWER26        IFEQ      'Y'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(41)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :26K: PROCESSING IF FIELD IS
     C** NOT REQUIRED AND THE FOLLOWING CONDITIONS ARE SATISFIED
     C     WWFL30        IFEQ      'N'
     C     MGCRTN        OREQ      'N'
     C                   MOVE      'Y'           WWER26
     C                   END
     C*
     C     MGFCOD        IFNE      '0'
     C     MGFCOD        ANDNE     '3'
     C                   MOVE      'Y'           WWER26
     C                   END
     C*
     C     WWER26        IFNE      'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(28)      MDES
     C*
     C** FORMAT TAG FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ':26K:'       MTAG
     C*
     C** FORMAT CERTIFICATE NUMBERS
     C                   CALL      'ZM1060'                             19
     C                   PARM      WWFSIX        WWTDRF            6
     C                   PARM      0             WWSEQN            4 0
     C                   PARM      *BLANKS       WWCRT1           35
     C                   PARM      *BLANKS       WWCRT2           35
     C                   PARM      *BLANKS       WWCRT3           35
     C                   PARM      *BLANKS       WWCRT4           35
     C                   PARM      *BLANKS       WWCRT5           35
     C                   PARM      *BLANKS       WWCRT6           35
     C                   PARM      *BLANKS       WWFIN             1
     C                   PARM      *BLANKS       WWERR             1
     C*
     C** IF PROGRAM ZM1060 NOT FOUND
     C     *IN19         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '016'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          * DBERROR 016 *
     C                   MOVEL     'ZM1060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** FORMAT ERROR FIELD OF MULT OCCUR. DATA STRUCTURE
     C     WWERR         IFEQ      '1'
     C                   MOVEL     ERRA(42)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C                   END
     C*
     C** FORMAT ERROR FIELD OF MULT OCCUR. DATA STRUCTURE
     C     WWFIN         IFEQ      'N'
     C                   MOVEL     ERRA(43)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C                   END
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     WWCRT1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C     WWCRT2        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   MOVEL     WWCRT2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     WWCRT3        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   MOVEL     WWCRT3        MDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     WWCRT4        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   MOVEL     WWCRT4        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     WWCRT5        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   MOVEL     WWCRT5        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     WWCRT6        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** SET UP DATA FIELD OF MULT OCCURENCE DATA STRUCUTURE
     C                   MOVEL     WWCRT6        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD77B    - FORMAT FIELD :77B:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD77B        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** FURTHER INFORMATION FIELD IS BALNK
     C     WWFL31        IFEQ      'M'
     C     MGFIN1        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(44)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :77B: PROCESSING IF FIELD IS NOT REQUIRED
     C** OR MGFIN1 IS BLANK
     C     WWFL31        IFNE      'N'
     C     MGFIN1        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(29)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':77B:'       MTAG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGFIN1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGFIN2 IS NOT BLANKS
     C     MGFIN2        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGFIN2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD77D    - FORMAT FIELD :77D:                              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD77D        BEGSR
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** FURTHER INFORMATION FIELD IS BLANK
     C     WWFL34        IFEQ      'M'
     C     MGRED1        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(49)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :77D: PROCESSING IF FIELD IS NOT REQUIRED
     C** OR MGNAL1 IS BLANK
     C     WWFL31        IFNE      'N'
     C     MGRED1        ANDNE     *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(32)      MDES
     C*
     C** FORMAT TAG FIELD
     C                   MOVEL     ':77D:'       MTAG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGRED1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGRED2 IS NOT BLANKS
     C     MGRED2        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGRED2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD72     - FORMAT FIELD :72:                               *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD72         BEGSR
     C*
     C** INITIALIZE ERROR INDICATOR & WORK FIELDS
     C                   MOVE      *BLANKS       WWER72            1
     C                   MOVE      *BLANKS       WWMDAT
     C*
     C** IF CANCELLATION OF A MESSAGE WITH DESTINATION CEDEL
     C     MGSRL1        IFEQ      '/CANCEL/'
     C                   MOVEL     MGSRL1        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE CHECK
     C** IF FIELD :72: CAN BE FORMATTED
     C     WWFL32        IFEQ      'M'
     C     MGSRL1        ANDEQ     *BLANKS
     C     MGSTBS        ANDNE     'P'
     C     MGSTBS        ANDNE     'D'
     C     WWM579        ANDEQ     'N'
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(45)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :72: PROCESSING IF FIELD IS NOT REQUIRED
     C** AND THE FOLLOWING CONDITIONS ARE SATISFIED
     C     WWFL32        IFEQ      'N'
     C                   MOVE      'Y'           WWER72
     C                   END
     C*
     C     WWER72        IFNE      'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(30)      MDES
     C*
     C** FORMAT TAG FIELD
     C***********          MOVEL':72:'    MTAG                            057263
     C                   MOVEL     ':72: '       MTAG                                          05726
     C*
     C     MGCRTN        IFEQ      'Y'
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     '/MSG579/'    MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     MGDEST        IFEQ      WWCEDN
     C     WWSENT        OREQ      'CEDEL'
     C*
     C     WWF33T        IFEQ      'Y'
     C*
     C     MGSTBS        IFEQ      'P'
     C     MGPRIC        ANDGT     100
     C*
     C** FORMAT DATA FIELD
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     '/PREMI'      WD0106
     C                   MOVEL     'UM/'         WD0709
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     MGSTBS        IFEQ      'D'
     C     MGSTBS        OREQ      'P'
     C     MGPRIC        ANDLE     100
     C*
     C** FORMAT DATA FIELD
     C                   MOVE      *BLANKS       WWMDAT
     C                   MOVEL     '/DISCO'      WD0106
     C                   MOVEL     'UNT/'        WD0710
     C                   MOVEL     WWMDAT        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   END
     C                   END
     C*
     C** FORMAT DATA FIELD
     C     MGSRL1        IFNE      *BLANKS
     C                   MOVEL     MGSRL1        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGSRL2 IS NOT BLANK
     C     MGSRL2        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGSRL2        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF MGSRL3 IS NOT BLANK
     C     MGSRL3        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGSRL3        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVE      'N'           WWER72
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C     WWER72        IFNE      'N'
     C                   MOVE      *BLANKS       MTAG
     C                   MOVE      *BLANKS       MDES
     C                   END
     C*
     C                   END
     C                   END
     C                   END
     C*                                                                   CEU005
     C** If CEU005 is on and MGOTRA is non zero then amend                CEU005
     C** the FIELD 72 on the MT0580.                                      CEU005
     C*                                                                   CEU005
     C     CEU005        IFEQ      'Y'                                                         CEU00
     C     MGOTRA        ANDNE     0                                                           CEU00
     C*                                                                   CEU005
     C** Format description field of MULT occurence data structure        CEU005
     C                   MOVEL     DESA(30)      MDES                                          CEU00
     C*                                                                   CEU005
     C*  Format TAG field of MULT occurence data structure                CEU005
     C                   MOVEL     ':72: '       MTAG                                          CEU00
     C*                                                                   CEU005
     C                   MOVEL     '/OCMT/'      OCMT                                          CEU00
     C                   MOVEL     MGOTRC        OTRC                                          CEU00
     C*                                                                   CEU005
     C** Call ZM1240 to convert amount into SWIFT format.                 CEU005
     C                   Z-ADD     MGOTRA        ZAMT                                          CEU00
     C                   MOVE      MGOTRC        ZCCY                                          CEU00
     C                   MOVE      *BLANKS       ZSAMNT                                        CEU00
     C                   MOVE      *BLANKS       ZOAMNT                                        CEU00
     C                   MOVE      *BLANKS       ZSCCY                                         CEU00
     C                   MOVE      *BLANKS       ZERR                                          CEU00
     C*                                                                   CEU005
     C                   CALL      'ZM1240'                             28                     CEU00
     C                   PARM                    ZAMT                                          CEU00
     C                   PARM                    ZCCY                                          CEU00
     C                   PARM                    ZSAMNT                                        CEU00
     C                   PARM                    ZOAMNT                                        CEU00
     C                   PARM                    ZSCCY                                         CEU00
     C                   PARM                    ZERR                                          CEU00
     C*                                                                   CEU005
     C** IF PROGRAM NOT FOUND                                             CEU005
     C     *IN28         IFEQ      '1'                                                         CEU00
     C     *LOCK         IN        LDA                                                         CEU00
     C                   MOVE      '080'         DBASE                          * * * * * * * *CEU00
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 080  *CEU00
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *CEU00
     C                   OUT       LDA                                                         CEU00
     C                   EXSR      *PSSR                                                       CEU00
     C                   END                                                                   CEU00
     C*                                                                   CEU005
     C** If ERROR during program ZM1240                                   CEU005
     C     ZERR          IFEQ      '1'                                                         CEU00
     C     *LOCK         IN        LDA                                                         CEU00
     C                   MOVE      '081'         DBASE                          * * * * * * * *CEU00
     C                   MOVEL     DBERR2        DBKEY                          *  DBERR 081  *CEU00
     C                   MOVEL     'ZM1240'      DBPGM                          * * * * * * * *CEU00
     C                   OUT       LDA                                                         CEU00
     C                   EXSR      *PSSR                                                       CEU00
     C                   END                                                                   CEU00
     C*                                                                   CEU005
     C                   MOVEL     ZSAMNT        OTRA                                          CEU00
     C*                                                                   CEU005
     C** Format DATA field of MULT occurence data structure               CEU005
     C                   MOVEL     WOCMT         MDAT                                          CEU00
     C*                                                                   CEU005
     C** Format FIELD for report                                          CEU005
     C                   MOVEL     MDAT          RDAT                                          CEU00
     C                   MOVE      'N'           WWER72                                        CEU00
     C*                                                                   CEU005
     C** Increase INDEX for MULT OCCUR. data structure                    CEU005
     C                   ADD       1             X                                             CEU00
     C     X             OCCUR     MULT                                                        CEU00
     C*                                                                   CEU005
     C                   ENDIF                                                                 CEU00
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  FLD79     - FORMAT FIELD :79:                               *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     FLD79         BEGSR
     C*
     C** INITIALIZE ERROR FLAG
     C                   MOVE      *BLANKS       WWER79            1
     C*
     C** IF FIELD IS MANDATORY FOR THIS MESSAGE AND
     C** NARRATIVE FIELDS ARE ALL BLANK
     C     WWFL33        IFEQ      'M'
     C     MGNAL1        ANDEQ     *BLANKS
     C*
     C** FORMAT ERROR MESSAGE FIELD
     C                   MOVEL     ERRA(46)      MERR
     C                   MOVE      'Y'           @ERR
     C                   MOVE      'Y'           WWNGEN
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ELSE
     C*
     C** END OF FIELD :79: PROCESSING IF FIELD IS NOT REQUIRED
     C** OR NARRATIVE FIELDS ARE BLANK
     C     WWFL33        IFEQ      'N'
     C                   MOVE      'Y'           WWER79
     C                   END
     C*
     C     MGNAL1        IFEQ      *BLANKS
     C                   MOVE      'Y'           WWER79
     C                   END
     C*
     C     WWER79        IFNE      'Y'
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DESCRIPTION FIELD
     C                   MOVEL     DESA(31)      MDES
     C*
     C** FORMAT TAG FIELD
     C***********          MOVEL':79:'    MTAG                            057263
     C                   MOVEL     ':79: '       MTAG                                          05726
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGNAL1        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C     MGNAL2        IFNE      *BLANKS
     C*
     C** INCREASE LENGTH
     C                   ADD       42            WWLENG
     C*
     C** FORMAT DATA FIELD
     C                   MOVEL     MGNAL2        MDAT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C                   END
     C                   END
     C*
     C                   Z-ADD     X             Y
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  NGEN      - FORMAT MESSAGE FOR MG0580P2 REPORT              *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     NGEN          BEGSR
     C*
     C** STORE LATEST OCCURENCE OF MULT DATA STRUCTURE AND RETURN TO
     C** THE START OF THIS PART OF MESSAGE
     C                   Z-ADD     X             WWX2              3 0
     C                   Z-ADD     WWX1          X
     C     X             OCCUR     MULT
     C*
     C** SET UP DATA STRUCTURE FOR INCORRECTLY GENERATED MESSAGES
     C** AND CLEAR THESE DETAILS FROM DATA STRUCTURE FOR CORRECTLY
     C** GENERATED MESSAGES
     C     X             DOUEQ     WWX2
     C                   MOVEL     MDAT          WMDAT
     C                   MOVEL     MTAG          WMTAG
     C                   MOVEL     MERR          WMERR
     C                   MOVE      *BLANKS       MULT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*
     C                   ADD       1             WWZ
     C     WWZ           OCCUR     WMULT
     C*
     C                   END
     C*
     C                   Z-ADD     WWZ           WWY               3 0
     C*
     C** RETURN TO OCCURENCE BEFORE THE ERROR
     C                   Z-ADD     WWX1          X
     C                   Z-ADD     WWX1          Y
     C     X             OCCUR     MULT
     C*
     C** REMOVE REFERENCE FROM REFDS AND TRANS TO AVOID OUTPUT OF INCORRECT
     C** MESSAGE TO THE FILES
     C     WWTOT1        OCCUR     TRANS
     C     WWTOT1        OCCUR     REFDS
     C                   MOVEL     *BLANKS       TRANS
     C                   MOVEL     *BLANKS       REFDS
     C                   SUB       1             WWTOT1
     C*
     C** RESET MESSAGE NOT GENERATED CORRECTLY FLAG
     C                   MOVE      *BLANKS       WWNGEN
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  WREF      - FORMAT FIELDS FOR PF/MGOREFPD DATA STRUCTURE    *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - RSEQ                                            *
     C**                                                              *
     C*****************************************************************
     C*
     C     WREF          BEGSR
     C*
     C     WWTOT1        OCCUR     REFDS
     C     WWTOT1        OCCUR     TRANS
     C                   MOVEL     MGMODI        WWMOD
     C                   MOVEL     WWDATA        WWTRNO
     C                   MOVEL     MGTNUM        WWMTRN
     C                   MOVEL     MGTTYP        WWTNTP
     C                   MOVEL     MGTSTP        WWSBTP
     C                   MOVEL     MGDEST        WWDECN
     C                   MOVEL     MGBSSN        WWNWBN
     C                   MOVEL     WWDATE        WWSVDT
     C                   MOVEL     MGSTCY        WWCCY
     C                   MOVEL     MGBRCA        WWBRCA
     C                   MOVEL     WWHIST        WWHRDT
     C                   MOVEL     WWDATA        WWTRNM
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  OFLDS     - WRITE TO MIDAS SWIFT DATABASE FILES             *
     C**                                                              *
     C**  CALLS     - ZM0060, *PSSR, #W05                             *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     OFLDS         BEGSR
     C*
     C** CLEAR ALL FIELDS IN PF/MGOREFPD
     C                   CLEAR                   MGOREFD0
     C*
     C** CONVERT MESSAGE GEN. DATE TO SWIFT FORMAT
     C                   MOVEL     BJRDNB        ZMDAY
     C                   MOVE      *BLANKS       ZSDATE
     C*
     C                   CALL      'ZM0060'                             22
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '036'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 036  *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** SET MESSAGE GEN. DATE MGDE TO ZSDATE
     C                   MOVEL     ZSDATE        MGDE
      *                                                                   113352
      ** Set-up Message Generation  Century flag                          113352
      *                                                                   113352
     C                   MOVEL     MGDE          YY                2 0                         11335
     C     YY            IFLT      72                                                          11335
     C                   MOVE      '2'           CIND                                          11335
     C                   ELSE                                                                  11335
     C                   MOVE      '1'           CIND                                          11335
     C                   ENDIF                                                                 11335
     C*
     C** SET INDEX TO PROCESS MULTIPLE OCCURRENCE DS FOR PF/MGOREFPD
     C                   Z-ADD     1             W                 2 0
     C*
     C** SAVE FIRST PART OF THE MULTIPLE MESSAGE FOR TRANS NUMBER
     C     W             OCCUR     TRANS
     C                   MOVE      WWTRNM        WWTRNF           16
     C*
     C** PROCESS MULTIPLE OCCURRENCE DATA STRUCTURE FOR PF/MGOREFPD
     C     W             DOWLE     WWTOT1
     C     W             OCCUR     REFDS
     C*
     C** FORMAT FIELDS ON PF/MGOREFPD
     C                   EXSR      #W05
     C/COPY WNCPYSRC,MG0580C004
     C*
     C** WRITE RECORD TO PF/MGOREFPD
     C                   MOVEL     MGCHG         AORR
     C                   WRITE     MGOREFD0                             32
     C*
     C** IF ERROR ON WRITE TO RECORD
     C     *IN32         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '037'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 037  *
     C                   MOVEL     'MGOREFPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   END
     C*
     C** PROCESS MULTIPLE OCCURRENCE DATA STRUCTURE
     C                   Z-ADD     1             Z                 3 0
     C     Z             DOWLT     Y
     C     Z             OCCUR     MULT
     C*
     C** FORMAT FIELDS ON PF/MGOMSGPD
     C                   MOVEL     MDAT          MFLD
     C                   MOVEL     WWTRNF        TRNO
     C                   MOVE      *BLANKS       PTDL
     C*
     C** WRITE RECORD TO PF/MGOMSGPD
     C                   WRITE     MGOMSGD0                             33
     C*
     C** IF ERROR ON WRITE TO RECORD
     C     *IN33         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '038'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 038  *
     C                   MOVEL     'MGOMSGPD'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** ADD 1 TO INDEX OF MULT OCURENCE DATA STRUCTURE
     C                   ADD       1             Z
     C*
     C                   END
      *                                                                   183583
      ** Write multiple occurrence data structure to MGOEXTPD             183583
      *                                                                   183583
     C                   Z-ADD     1             VV                2 0                         18358
     C     VV            DOWLE     V                                                           18358
     C     MCSI          ANDNE     *BLANKS                                                     18358
     C     VV            OCCUR     EXTN                                                        18358
     C                   WRITE     MGOEXTD0                             06                     18358
      *                                                                   183583
      ** Error on write to PF/MGOEXTPD (message data extension file)      183583
      *                                                                   183583
     C     *IN06         IFEQ      '1'                                                         18358
     C     *LOCK         IN        LDA                                                         18358
     C                   MOVE      '067'         DBASE                          ************** 18358
     C                   MOVEL     '        '    DBKEY                          * DBERROR 67 * 18358
     C                   MOVEL     'MGOEXTPD'    DBFILE                         ************** 18358
     C                   OUT       LDA                                                         18358
     C                   EXSR      *PSSR                                                       18358
     C                   ENDIF                                                                 18358
     C                   ADD       1             VV                                            18358
     C                   ENDDO                                                                 18358
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  #W05      - FORMAT FIELDS FOR MGOREFPD                      *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     #W05          BEGSR
     C*
     C** FORMAT FIELDS ON PF/MGOREFPD
     C                   MOVEL     WWMOD         MODI
     C                   MOVEL     WWTRNO        TRNO
     C                   MOVEL     WWMTRN        MTRN
     C                   MOVEL     WWTNTP        TNTP
     C                   MOVEL     WWSBTP        SBTP
     C                   MOVEL     @NWRK         NWRK
     C                   MOVEL     A8BICN        SECN
     C                   MOVEL     @NWSN         NWSN
     C                   MOVEL     WWDECN        DECN
     C                   MOVEL     @NWDS         NWDS
     C                   MOVEL     WWNWBN        NWBN
     C                   MOVEL     '580'         MTPY
     C                   MOVEL     'N'           MPRY
     C***********          MOVEL'1'       MGSG                            082282
     C***********          MOVEL'CRTD'    MGST                            082282
     C                   EXSR      MSTAT                                                       08228
     C                   TIME                    MGTM
     C                   MOVEL     BJMRDT        LADT
     C                   TIME                    LATM
     C                   MOVEL     WWSVDT        SVDT
      *                                                                   141572
      ** Setup century indicator CINDV for value date SVDT                141572
     C     SVDT          IFEQ      *BLANK                                                      14157
     C                   MOVE      *BLANK        CINDV                                         14157
     C                   ELSE                                                                  14157
     C                   MOVEL     SVDT          YY                2 0                         14157
     C     YY            IFLT      72                                                          14157
     C                   MOVE      '2'           CINDV                                         14157
     C                   ELSE                                                                  14157
     C                   MOVE      '1'           CINDV                                         14157
     C                   ENDIF                                                                 14157
     C                   ENDIF                                                                 14157
      *                                                                   141572
     C                   MOVEL     WWCCY         CCY
     C                   MOVEL     WWBRCA        BRCA
     C                   MOVEL     WWHRDT        HRDT
     C                   MOVEL     'Y'           TSKS
     C*
     C** INCREMENT INDEX
     C                   ADD       1             W
     C     WWTOT1        IFGT      1
     C     W             OCCUR     TRANS
     C                   MOVEL     WWTRNF        TRNF
     C                   MOVEL     WWTRNM        TRNM
     C                   END
     C*
     C* FISRT PART OF MULTIPLE MUST HAVE TRNF BLANK
     C     W             IFEQ      2
     C                   MOVEL     *BLANKS       TRNF
     C                   END
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT                                                              082282
     C*****************************************************************   082282
     C**                                                              *   082282
     C**  MSTAT     - Determine message status                        *   082282
     C**                                                              *   082282
     C*****************************************************************   082282
      *                                                                   082282
     C     MSTAT         BEGSR                                                                 08228
      *                                                                   082282
      * Reset status array                                                082282
     C                   CLEAR                   @ST                                           08228
      *                                                                   082282
      * Set key to destination customer number                            082282
     C                   MOVEL(P)  DECN          @KEY                                          08228
      *                                                                   082282
      * Get customer details via access object                            082282
     C                   CALL      'AOCUSTR0'                                                  08228
     C                   PARM      *BLANKS       @RTCD             7                           08228
     C                   PARM      '*KEY   '     @OPTN             7                           08228
     C                   PARM                    @KEY             10                           08228
     C                   PARM      *BLANKS       @KYST             7                           08228
     C     SDCUST        PARM      SDCUST        DSSDY                                         08228
      *                                                                   082282
      * Fill status array                                                 082282
     C     @RTCD         IFEQ      *BLANKS                                                     08228
     C                   MOVEL     BBDS01        @ST(1)                                        08228
     C                   MOVEL     BBDS02        @ST(2)                                        08228
     C                   MOVEL     BBDS03        @ST(3)                                        08228
     C                   MOVEL     BBDS04        @ST(4)                                        08228
     C                   MOVEL     BBDS05        @ST(5)                                        08228
     C                   MOVEL     BBDS06        @ST(6)                                        08228
     C                   MOVEL     BBDS07        @ST(7)                                        08228
     C                   MOVEL     BBDS08        @ST(8)                                        08228
     C                   MOVEL     BBDS09        @ST(9)                                        08228
     C                   MOVEL     BBDS10        @ST(10)                                       08228
     C                   MOVEL     BBDS11        @ST(11)                                       08228
     C                   MOVEL     BBDS12        @ST(12)                                       08228
     C                   MOVEL     BBDS13        @ST(13)                                       08228
     C                   MOVEL     BBDS14        @ST(14)                                       08228
     C                   MOVEL     BBDS15        @ST(15)                                       08228
     C                   ENDIF                                                                 08228
      *                                                                   082282
      * Is the message type in the array? Set on *IN60 if it is.          082282
     C     '580'         LOOKUP    @ST                                    60                   08228
     C  N60'58*'         LOOKUP    @ST                                    60                   08228
     C  N60'5**'         LOOKUP    @ST                                    60                   08228
      *                                                                   082282
      * If found, set status to 'ready to send', else set to 'created'    082282
     C     *IN60         IFEQ      *ON                                                         08228
     C                   MOVEL     'RSND'        MGST                                          08228
     C                   MOVEL     '2'           MGSG                                          08228
     C                   ELSE                                                                  08228
     C                   MOVEL     'CRTD'        MGST                                          08228
     C                   MOVEL     '1'           MGSG                                          08228
     C                   ENDIF                                                                 08228
      *                                                                   082282
     C                   ENDSR                                                                 08228
      *                                                                   082282
     C*****************************************************************   082282
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  #ZA       - FORMAT ADDRESSES                                *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - FLD53A, FLD83C, FLD87A                          *
     C**                                                              *
     C*****************************************************************
     C*
     C     #ZA           BEGSR
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C     ZSADD1        IFNE      *BLANKS                                                     12228
     C                   MOVEL     ZSADD1        MDAT
     C                   EXSR      SEXTN                                                       18358
     C*
     C** FORMAT FIELD FOR REPORT
     C                   MOVEL     MDAT          RDAT
     C*
     C** PRINT CUSTOMER REPORT NAME AND REPORT TOWN
     C     MTAG          IFEQ      ':84A:'
     C     MTAG          OREQ      ':87A:'
     C     MTAG          OREQ      ':57A:'
     C     MTAG          OREQ      ':58A:'
     C                   MOVEL     ZCRNM         CRNM
     C                   MOVEL     ZCRTN         CRTN
     C                   END
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C*                                                                   122283
     C                   END                                                                   12228
     C*
     C** IF ZSADD2 IS NOT BLANK
     C     ZSADD2        IFNE      *BLANKS
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSADD2        MDAT
     C*
     C** FORMAT FIELD FOR REPORT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF ZSADD3 IS NOT BLANK
     C     ZSADD3        IFNE      *BLANKS
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSADD3        MDAT
     C*
     C** FORMAT FIELD FOR REPORT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C** IF ZSADD4 IS NOT BLANK
     C     ZSADD4        IFNE      *BLANKS
     C*
     C** FORMAT DATA FIELD OF MULT OCCURENCE DATA STRUCTURE
     C                   MOVEL     ZSADD4        MDAT
     C*
     C** FORMAT FIELD FOR REPORT
     C                   MOVEL     MDAT          RDAT
     C*
     C** INCREASE INDEX FOR MULT OCCUR. DATA STRUCTURE
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT                                                              183583
      *****************************************************************   183583
      *                                                               *   183583
      *   SEXTN - Store customer with SWIFT address to data structure *   183583
      *                                                               *   183583
      *   Called by: #ZA                                              *   183583
      *   Calls    : None                                             *   183583
      *                                                               *   183583
      *****************************************************************   183583
      *                                                                   183583
     C     SEXTN         BEGSR                                                                 18358
      *                                                                   183583
     C     SAVMTG        IFNE      *BLANKS                                                     18358
     C                   MOVE      SAVMTG        @MTG                                          18358
     C                   ELSE                                                                  18358
     C                   MOVEL     MTAG          @MTG                                          18358
     C                   ENDIF                                                                 18358
      *                                                                   183583
     C     FLDTYP        IFEQ      '5'                                                         18358
     C     FLDTAG        ANDEQ     'A'                                                         18358
     C     FLDTYP        OREQ      '8'                                                         18358
     C     FLDTAG        ANDEQ     'A'                                                         18358
     C                   ADD       1             V                                             18358
     C     V             OCCUR     EXTN                                                        18358
     C                   Z-ADD     X             MPSN                                          18358
     C                   MOVEL     @MTG          MTG                                           18358
     C                   MOVEL     ZDEST         MCSI                                          18358
     C                   ENDIF                                                                 18358
      *                                                                   183583
     C     SEXT9         ENDSR                                                                 18358
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  #W01      - PRINT MESSAGE GENERATED DETAILS                 *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     #W01          BEGSR
     C*
     C** INITIALISE FIELDS USED IN REPORT
     C                   MOVE      *BLANKS       R1SNBR
     C                   MOVE      *BLANKS       R1SNDR
     C                   MOVE      *BLANKS       R1NWSN
     C                   MOVE      *BLANKS       R1DEST
     C                   MOVE      *BLANKS       R1NWRK
     C                   MOVE      *BLANKS       R1NWDS
     C*
     C** FORMAT REPORT FIELDS
     C                   MOVEL     WWHDR1        R1SNBR
     C                   MOVEL     @SNDR         R1SNDR
     C                   MOVEL     @NWSN         R1NWSN
     C                   MOVE      'N'           R1MESS
     C                   MOVEL     WWHDR2        R1DEST
     C                   MOVEL     @NWRK         R1NWRK
     C                   MOVEL     @NWDS         R1NWDS
     C                   MOVEL     @SRNM         R1SRNM
     C                   MOVEL     @SRTN         R1SRTN
     C                   MOVEL     @DRNM         R1DRNM
     C                   MOVEL     @DRTN         R1DRTN
     C*
     C** WRITE THE HEADER AND THE MAIN TEXT FOR THE REPORT
     C                   WRITE     HEADER1
     C                   WRITE     TEXT1
     C                   MOVEL     'N'           WWC1              1
     C*
     C** PROCESS MULTIPLE OCCURRENCE DATA STRUCTURE
     C                   Z-ADD     0             I                 3 0
     C     I             DOWLE     Y
     C                   ADD       1             I
     C     I             OCCUR     MULT
     C*
     C** CHECKING FOR OVERFLOW
     C     WWOFL1        SUB       WWPTL1        WWLINE
     C     WWLINE        IFLT      3
     C                   WRITE     HEADER1
     C     MTAG          IFEQ      ':23: '
     C                   WRITE     CONTI1
     C                   END
     C                   ELSE
     C*
     C** NEW PAGE FOR EACH NEW PART
     C     MTAG          IFEQ      ':23: '
     C     WWC1          ANDEQ     'Y'
     C                   WRITE     HEADER1
     C                   WRITE     CONTI1
     C                   END
     C*
     C                   END
     C*
     C** WRITE A DETAIL LINE TO THE REPORT
     C                   WRITE     LINE1
     C*
     C     MTAG          IFEQ      ':35A:'
     C                   MOVEL     'Y'           WWC1
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  #W02      - PRINT MESSAGE NOT GENERATED DETAILS             *
     C**                                                              *
     C**  CALLS     - NONE                                            *
     C**                                                              *
     C**  CALLED BY - MAIN PROCESSING                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     #W02          BEGSR
     C*
     C** INITIALISE  FIELDS USED IN REPORT
     C                   MOVE      *BLANKS       R2SNBR
     C                   MOVE      *BLANKS       R2SNDR
     C                   MOVE      *BLANKS       R2NWSN
     C**********           Z-ADD*ZEROS    R2DEST                                              CSD027
     C                   MOVE      *BLANKS       R2DEST
     C                   MOVE      *BLANKS       R2NWDS
     C                   MOVE      *BLANKS       R2DERR
     C                   MOVE      *BLANKS       R2NWRK
     C                   MOVE      *BLANKS       R2MODI
     C*
     C** OPEN PRINTER FILE
     C     *IN50         IFEQ      '0'
     C************         OPEN MG0580P2                                  091250
     C                   OPEN      MG0580A2                                                    09125
     C                   MOVE      '1'           *IN50
     C                   END
     C*
     C** FORMAT REPORT FIELDS
     C                   MOVEL     WWHDR1        R2SNBR
     C                   MOVEL     @SNDR         R2SNDR
     C                   MOVEL     @NWSN         R2NWSN
     C                   MOVEL     WWHDR2        R2DEST
     C                   MOVEL     @NWDS         R2NWDS
     C                   MOVEL     DSERR         R2DERR
     C                   MOVEL     @NWRK         R2NWRK
     C                   MOVEL     NWERR         R2NWER
     C                   MOVEL     WWHDR3        R2MODI
     C                   MOVEL     'N'           R2PRTY
     C*
     C** WRITE THE HEADER AND THE MAIN TEXT FOR THE REPORT
     C                   WRITE     HEADER2
     C                   WRITE     TEXT2
     C                   MOVEL     'N'           WWC2              1
     C*
     C** PROCESS MULTIPLE OCCURRENCE DATA STRUCTURE
     C                   Z-ADD     0             I
     C     I             DOWLE     WWY
     C                   ADD       1             I
     C     I             OCCUR     WMULT
     C*
     C** CHECKING FOR OVERFLOW
     C     WWOFL2        SUB       WWPTL2        WWLINE
     C     WWLINE        IFLT      3
     C                   WRITE     HEADER2
     C     MTAG          IFEQ      ':23: '
     C                   WRITE     CONTI2
     C                   END
     C                   ELSE
     C*
     C** NEW PAGE FOR EACH NEW PART
     C     MTAG          IFEQ      ':23: '
     C     WWC2          ANDEQ     'Y'
     C                   WRITE     HEADER2
     C                   WRITE     CONTI2
     C                   END
     C*
     C                   END
     C*
     C** WRITE A DETAIL LINE TO THE REPORT
     C                   WRITE     LINE2
     C*
     C     MTAG          IFEQ      ':35A:'
     C                   MOVEL     'Y'           WWC2
     C                   END
     C*
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*   CEDELC - CEDEL CANCELLATION PROCESSING                      *
     C*   Called by   Main process                                    *
     C*   Calls       - CANCEL                                        *
     C*****************************************************************
     C*
     C     CEDELC        BEGSR
     C*
     C*...............................................................*
     C* Single Messages                                               *
     C* 1.  A message is 'deleted' when the message status field on   *
     C*     the reference field (MGST, PF/MGOREFPD), is equal to      *
     C*     'DLTD'.                                                   *
     C*                                                               *
     C* Multiple Messages (MT554, MT580)                              *
     C* 2.  The message status field of the header record on the      *
     C*     message reference file (PF/MGOREFPD), contains the        *
     C*     status for the multiple message. This status is then      *
     C*     the status for all parts within the multiple message.     *
     C*
     C*     If the message status field (MGST, PF/MGOREFPD), of the   *
     C*     header record contains the value 'DLTD' the whole         *
     C*     message is deleted, (i.e. all parts are deleted).         *
     C*                                                               *
     C*     To delete a message part from the multiple message, the   *
     C*     message is descibed as 'part deleted'. The reference      *
     C*     record for the message part being deleted has the         *
     C*     'part deleted' field (PTST, PF/MGOREFPD), set to 'D'.     *
     C*     The header record message status (MGST, PF/MGOREFPD),     *
     C*     is then set to 'AMND', to indicate the multiple message   *
     C*     has been 'amended'.                                       *
     C*...............................................................*
     C*
     C** INITIALISE FLAG FOR MESSAGE SUCCESSFULLY DELETED
     C                   MOVE      'N'           WWFLAG            1
     C     MGTTYP        IFEQ      'DM'
     C                   MOVEL     '001'         WWNINE
     C                   ELSE
     C     MGTTYP        IFEQ      'DN'                                                       CSW003
     C                   MOVEL     '002'         WWNINE                                       CSW003
     C                   ELSE                                                                 CSW003
     C     MGTTYP        IFEQ      'TS'                                                       CSW003
     C                   MOVEL     '003'         WWNINE                                       CSW003
     C                   ELSE                                                                 CSW003
     C                   MOVEL     '000'         WWNINE
     C                   END
     C                   ENDIF                                                                CSW003
     C                   ENDIF                                                                CSW003
     C                   MOVEL     MGTNUM        WWFSIX
     C                   MOVE      WWFSIX        WWNINE            9
     C                   MOVEL     WWNINE        @TNUM
     C                   MOVE      @LSWS         @TNUM            16
     C                   MOVEL     ' '           WOUT72            1
     C*
     C**  Use the parameter @TNUM to access the message we are deleting
     C     @TNUM         CHAIN     MGOREFL0                           05
     C*
     C**  Error message not found
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '049'         DBASE                          * * * * * * * *
     C                   MOVEL     @TNUM         DBKEY                          *  DBERR 049  *
     C                   MOVEL     'MGOREFL0'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** If message not already cancelled, process cancellation
     C     CARQ          IFNE      'Y'
     C                   EXSR      CANCEL
     C                   END
     C*
     C** If cancellation message not successfully generated
     C     WWFLAG        IFEQ      'N'
     C     *LOCK         IN        LDA
     C                   MOVE      '050'         DBASE                          * * * * * * * *
     C                   MOVEL     WWHEAD        DBKEY                          *  DBERR 050  *
     C                   MOVEL     'MGOMSGLA'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*   CANCEL - CREATE CANCELLATION MESSAGE                        *
     C*   Called by   Main process                                    *
     C*   Calls       - PARTPS                                        *
     C*****************************************************************
     C*
     C     CANCEL        BEGSR
     C*
     C*----------------------------------------------------------------
     C*  OBTAIN HEADER FIELDS FROM MGOREFPD
     C*----------------------------------------------------------------
     C                   MOVEL     NWSN          @NWSN
     C                   MOVEL     NWDS          @NWDS
     C                   MOVEL     NWRK          @NWRK
     C*
     C*----------------------------------------------------------------
     C** DETERMINE IF MESSAGE IS SINGLE OR MULTIPLE
     C*----------------------------------------------------------------
     C*
     C*
     C** INITIALISE MULTIPLE MESSAGE FLAG
     C                   MOVE      'N'           MMEG              1
     C                   MOVE      'N'           WW72
     C*
     C**  The message being deleted is part of a multiple and
     C**  is part-deleted from the multiple message (PF/MGOREFPD)
     C     TRNF          IFNE      *BLANKS
     C     TRNM          ORNE      *BLANKS
     C*
     C                   MOVE      'Y'           MMEG
     C*
     C**  The header TRN is the TRN of the message being deleted
     C     TRNF          IFEQ      *BLANKS
     C                   MOVEL     @TNUM         WWHEAD           16
     C*
     C**  The header TRN is the 'TRN of the first part' (TRNF)
     C                   ELSE
     C*
     C                   MOVEL     TRNF          WWHEAD
     C                   END
     C*
     C                   ELSE
     C                   MOVEL     @TNUM         WWHEAD           16
     C                   END
     C*
     C*----------------------------------------------------------------
     C** DETERMINE POSITION OF PART TO BE CANCELLED
     C*----------------------------------------------------------------
     C*
     C                   EXSR      PARTPS
     C*
     C*----------------------------------------------------------------
     C** CANCEL MULTIPLE MESSAGE
     C*----------------------------------------------------------------
     C*
     C** IF MESSAGE TO BE CANCELLED IS A MULTIPLE MESSAGE
     C     MMEG          IFEQ      'Y'
     C*
     C** ACCESS LF/MGOMSGLA WITH KEY OF WWHEAD
     C     WWHEAD        CHAIN     MGMSGLA                            07
     C*
     C     *IN07         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '051'         DBASE                          * * * * * * * *
     C                   MOVEL     WWHEAD        DBKEY                          *  DBERR 051  *
     C                   MOVEL     'MGOMSGLA'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   MOVE      'N'           FOUND
     C                   Z-ADD     0             WW23              2 0
     C*
     C** READ THROUGH THE MULTIPLE MESSAGE RECORDS TO FIND THE
     C** PART BEING CANCELED
     C     WWHEAD        DOWEQ     OTRNO
     C     *IN07         ANDEQ     '0'
     C     FOUND         ANDEQ     'N'
     C*
     C**  For MT580, part found when part position within multiple on
     C**  the reference file is equal to the number of field :23:'s
     C**  we have read within the message on the data file
     C     MTPY          IFEQ      '580'
     C     OMTAG         ANDEQ     ':23: '
     C                   ADD       1             WW23
     C*
     C     WW23          IFEQ      WWPTPS
     C*
     C**  For this part of the multiple message, flag as part deleted
     C     OMTAG         DOUEQ     ':23: '
     C     *IN07         OREQ      '1'
     C     WWHEAD        ORNE      OTRNO
     C*
     C** FORMAT TAG AND DATA FIELD OF MULT. OCCUR DATA STRUCTURE
     C                   EXSR      FORCAN
     C*
     C** READ NEXT RECORD FROM PF/MGOMSGLA
     C                   READ      MGMSGLA                                07
     C                   END
     C*  IF FIELD 72 HAS NOT BEEN OUTPUT, OUTPUT IT NOW
     C     WOUT72        IFNE      'Y'
     C                   MOVE      'Y'           WOUT72
     C***********          MOVEL':72:'    MTAG                            057263
     C                   MOVEL     ':72: '       MTAG                                          05726
     C                   MOVEL     DESA(30)      MDES
     C                   MOVEL     '/CANCEL/'    MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C*
     C**  Message-part flagged as part deleted
     C                   MOVE      'Y'           FOUND             1
     C                   END
     C*
     C                   END
     C*
     C** READ NEXT RECORD FROM PF/MGOMSGLA
     C                   READ      MGMSGLA                                07
     C                   END
     C*
     C** IF FOUND EQUALS 'N'
     C     FOUND         IFEQ      'N'
     C     *LOCK         IN        LDA
     C                   MOVE      '052'         DBASE                          * * * * * * * *
     C                   MOVEL     OTRNO         DBKEY                          *  DBERR 052  *
     C                   MOVEL     'MGOMSGLA'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   END
     C*
     C*----------------------------------------------------------------
     C** CANCEL SINGLE MESSAGE
     C*----------------------------------------------------------------
     C*
     C** IF MESSAGE TO BE CANCELLED IS A SIGNLE MESSAGE
     C     MMEG          IFEQ      'N'
     C*
     C** ACCESS LF/MGOMSGLA WITH KEY OF @TNUM
     C     @TNUM         CHAIN     MGMSGLA                            07
     C*
     C     *IN07         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '053'         DBASE                          * * * * * * * *
     C                   MOVEL     @TNUM         DBKEY                          *  DBERR 053  *
     C                   MOVEL     'MGOMSGLA'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** WHILE OTRNO EQUALS @TNUM AND NOT EOF
     C     OTRNO         DOWEQ     @TNUM
     C     *IN07         ANDEQ     '0'
     C*
     C** FORMAT TAG AND DATA FIELD OF MULT. OCCUR DATA STRUCTURE
     C     OM0103        IFNE      'SE8'
     C                   EXSR      FORCAN
     C                   END
     C*
     C** READ NEXT RECORD FROM PF/MGOMSGLA
     C                   READ      MGMSGLA                                07
     C                   END
     C*
     C*  IF FIELD 72 HAS NOT BEEN OUTPUT, OUTPUT IT NOW
     C     WOUT72        IFNE      'Y'
     C                   MOVE      'Y'           WOUT72
     C***********          MOVEL':72:'    MTAG                            057263
     C                   MOVEL     ':72: '       MTAG                                          05726
     C                   MOVEL     DESA(30)      MDES
     C                   MOVEL     '/CANCEL/'    MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   END
     C*----------------------------------------------------------------
     C** UPDATE THE MESSAGE TO LF/MGOREFL0
     C*----------------------------------------------------------------
     C*
     C** ACCESS LF/MGOREFL0 WITH KEY OF @TNUM
     C     @TNUM         CHAIN     MGOREFL0                           05
     C*
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '054'         DBASE                          * * * * * * * *
     C                   MOVEL     @TNUM         DBKEY                          *  DBERR 054  *
     C                   MOVEL     'MGOREFL0'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C** UPDATE THE MESSAGE TO BE CANCELLED
     C                   MOVE      'Y'           CARQ
     C                   MOVEL     BJMRDT        LADT
     C                   TIME                    LATM
     C                   UPDATE    MGORELA
     C*
     C** SET FLAG FOR MESSAGE SUCCESSFULLY DELETED
     C                   MOVE      'Y'           WWFLAG
     C*
     C** STORE INDEX
     C                   Z-ADD     X             Y
     C*----------------------------------------------------------------
     C** SET UP REFERENCE FILE INFORMATION
     C*----------------------------------------------------------------
     C*
     C                   EXSR      WREF
     C*
     C                   ENDSR
     C*
     C*****************************************************************
     C/COPY WNCPYSRC,MG0580C005
     C/EJECT
     C*****************************************************************
     C*   PARTPS - DETERMINE POSITION OF PART TO BE CANCELLED         *
     C*   Called by   CANCEL                                          *
     C*   Calls       *PSSR                                           *
     C*****************************************************************
     C*
     C     PARTPS        BEGSR
     C*
     C** Access the next part of the multiple message
     C     WWHEAD        CHAIN     MGOREFL0                           05
     C*
     C**  Next part not found
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '055'         DBASE                          * * * * * * * *
     C                   MOVEL     WWHEAD        DBKEY                          *  DBERR 055  *
     C                   MOVEL     'MGOREFL0'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C**  INITIALISE PARTS READ COUNTER
     C                   Z-ADD     1             WWREAD            2 0
     C                   MOVE      'N'           PARTFO            1
     C*
     C**  IF TRNO EQUALS @TNUM
     C     TRNO          IFEQ      @TNUM
     C*
     C**  INITIALISE PART POSITION WITHIN MULTIPLE
     C                   Z-ADD     1             WWPTPS            2 0
     C* PART HAS BEEN FOUND
     C                   MOVE      'Y'           PARTFO
     C*
     C                   ELSE
     C*
     C                   Z-ADD     0             WWPTPS
     C                   END
     C*
     C**  Check until no more parts or 2 live parts have been found
     C     MTPY          IFEQ      '580'
     C*
     C     TRNM          DOWNE     *BLANKS
     C     *IN05         ANDEQ     '0'
     C     PARTFO        ANDEQ     'N'
     C*
     C**  Access the next part of the multiple message
     C     TRNM          CHAIN     MGOREFL0                           05
     C*
     C**  Next part not found
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '056'         DBASE                          * * * * * * * *
     C                   MOVEL     TRNM          DBKEY                          *  DBERR 056  *
     C                   MOVEL     'MGOREFL0'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C**  ADD 1 TO PARTS READ COUNTER
     C                   ADD       1             WWREAD
     C*
     C** IF TRNO EQUALS @TNUM
     C     TRNO          IFEQ      @TNUM
     C*
     C** SET PART POSITION WITHIN MULTIPLE TO PARTS READ COUNTER
     C                   Z-ADD     WWREAD        WWPTPS
     C* PART HAS BEEN FOUND
     C                   MOVE      'Y'           PARTFO
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C** ACCESS LF/MGOREFL0 USING KEY OF @TNUM
     C     @TNUM         CHAIN     MGOREFL0                           05
     C*
     C**  Next part not found
     C     *IN05         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '057'         DBASE                          * * * * * * * *
     C                   MOVEL     @TNUM         DBKEY                          *  DBERR 057  *
     C                   MOVEL     'MGOREFL0'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*   FORCAN - FORMAT CANCELLATION MESSAGE FOR REPORTING          *
     C*   Called by   CANCEL                                          *
     C*   Calls       *PSSR                                           *
     C*****************************************************************
     C*
     C     FORCAN        BEGSR
     C*
     C                   MOVE      ' '           WOC
     C                   MOVE      ' '           WWPROC            1
     C*
     C** FORMAT FIELD 20
     C***********OMTAG     IFEQ ':20:'                                    057263
     C     OMTAG         IFEQ      ':20: '                                                     05726
     C                   MOVE      'Y'           WWPROC
     C     MGTTYP        IFEQ      'DM'
     C     MGTTYP        OREQ      'DN'                                                        CSW00
     C                   MOVEL     '991'         OM0103
     C                   ELSE
     C                   MOVEL     '999'         OM0103
     C                   END
     C                   MOVEL     OM0116        WWDATA
     C                   MOVEL     OM0116        MDAT
     C                   MOVEL     MDAT          RDAT
     C                   END
     C*
     C** FORMAT FIELD 23
     C***********OMTAG     IFEQ ':23:'                                    057263
     C     OMTAG         IFEQ      ':23: '                                                     05726
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     OMFLD         WWDATA
     C                   MOVEL     OMFLD         MDAT
     C                   MOVEL     MDAT          RDAT
     C***********OM0204    IFEQ 'REC'                                     073848
     C***********          MOVE 'TP'      MGTSTP                          073848
     C***********          ELSE                                           073848
     C***********          MOVE 'TS'      MGTSTP                          073848
     C***********          END                                            073848
     C                   END
     C** FORMAT DATES
     C***********OMTAG     IFEQ ':30:'                                    057263
     C     OMTAG         IFEQ      ':30: '                                                     05726
     C     OMTAG         OREQ      ':31P:'
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     OM0106        ZSDATE
     C                   MOVEL     OMFLD         MDAT
     C*
     C                   MOVEL     WWYEAR        WRYEAR
     C                   MOVEL     WWMNTH        WRMNTH
     C                   MOVEL     WWDAY         WRDAY
     C                   MOVEL     OM0735        WR0937
     C                   MOVEL     WRDATE        WR0108
     C                   MOVEL     WWRDAT        RDAT
     C*
     C     OMTAG         IFEQ      ':30: '
     C                   MOVEL     ZSDATE        WWDATE            6
     C*
     C                   MOVE      WWYEAR        WR4               4
     C                   MOVEL     WWMNTH        WR4
     C                   MOVE      WR4           WR6               6
     C                   MOVEL     WWDAY         WR6
     C                   MOVE      WR6           ZDATE
     C                   EXSR      ZDATE1
     C*
     C**     if date not correct
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '058'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 058  *
     C                   MOVEL     'ZDATE1'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     ZDAYNO        MGSDAT
     C                   END
     C*
     C** CONVERT HISTORY RETENTION DATE TO SWIFT FORMAT
     C     MGDEST        IFNE      WWCEDN
     C     WWSENT        ANDNE     'CEDEL'
     C     MGSDAT        ADD       ENDSMN        ZMDAY
     C                   ELSE
     C     MGSDAT        ADD       60            ZMDAY
     C                   END
     C                   MOVE      *BLANKS       ZSDATE
     C*
     C                   CALL      'ZM0060'                             22
     C                   PARM                    ZMDAY
     C                   PARM                    ZSDATE
     C*
     C** IF PROGRAM NOT FOUND
     C     *IN22         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '059'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 059  *
     C                   MOVEL     'ZM0060'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C                   MOVEL     ZSDATE        WWHIST
     C                   END
     C*
     C** FORMAT AMOUNTS
     C     OMTAG         LOOKUP    TAGAMT                                 70
     C     *IN70         IFEQ      '1'
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     OMFLD         MDAT
     C*
     C                   MOVE      OM0419        @WAMT            16
     C     OMTAG         IFEQ      ':35A:'
     C**********           MOVE *BLANKS   @WCCY                           167826
     C                   MOVE      MGNMCY        @WCCY                                         16782
     C                   ELSE
     C                   MOVE      OM0103        @WCCY             3
     C                   END
     C                   CALL      'ZM1340'                             21
     C                   PARM                    @WAMT
     C                   PARM                    @WCCY
     C                   PARM      'A'           @WTYP             1
     C                   PARM      *BLANKS       @REST            16
     C                   PARM      *BLANKS       @ERRC             1
     C                   PARM      MGNMDP        @CDP                                          18886
     C*
     C**     if program ZM1340 not found
     C     *IN21         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '060'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 060  *
     C                   MOVEL     'ZM1340'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C**      if error during called program
     C     @ERRC         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '061'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 061  *
     C                   MOVEL     DBERR1        DBKEY                          * * * * * * * *
     C                   MOVEL     'ZM1340'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      *BLANKS       WWRDAT
     C                   MOVEL     OM0103        WR0103
     C                   MOVEL     @REST         WR0424
     C                   MOVEL     WWRDAT        RDAT
     C                   END
     C*
     C     OMTAG         IFEQ      ':32B:'
     C                   MOVEL     OM0103        MGSTCY
     C                   END
     C*
     C** FORMAT FIELD 34G AND 34H
     C     OMTAG         IFEQ      ':34G:'
     C     OMTAG         OREQ      ':34H:'
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     'Y'           WW34              1
     C     OM0419        IFEQ      *BLANKS
     C                   MOVEL     OMFLD         MDAT
     C                   MOVEL     MDAT          RDAT
     C                   END
     C                   END
     C**    if blanks from position 4, this is the amount field
     C     WW34          IFEQ      'Y'
     C     OM0419        ANDNE     *BLANKS
     C*
     C                   MOVE      'Y'           WWPROC
     C                   MOVE      OM0419        @WAMT            16
     C                   MOVE      OM0103        @WCCY             3
     C                   CALL      'ZM1340'                             21
     C                   PARM                    @WAMT
     C                   PARM                    @WCCY
     C                   PARM      'A'           @WTYP             1
     C                   PARM      *BLANKS       @REST            16
     C                   PARM      *BLANKS       @ERRC             1
     C                   PARM      MGNMDP        @CDP              1 0                         16782
     C*
     C**      if program ZM1340 not found
     C     *IN21         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '062'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 062  *
     C                   MOVEL     'ZM1340'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C**      if error during called program
     C     @ERRC         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '063'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 063  *
     C                   MOVEL     DBERR1        DBKEY                          * * * * * * * *
     C                   MOVEL     'ZM1340'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      *BLANKS       WWRDAT
     C                   MOVEL     OM0103        WR0103
     C                   MOVEL     @REST         WR0424
     C                   MOVEL     WWRDAT        RDAT
     C                   MOVEL     OMFLD         MDAT
     C                   MOVEL     'N'           WW34
     C                   END
     C*
     C** FORMAT OPTION FIELDS A
     C     OMTAG         LOOKUP    TAGBIC                                 70
     C     *IN70         IFEQ      '1'
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     OMFLD         MDAT
     C                   MOVEL     MDAT          RDAT
     C     OMTAG         IFEQ      ':88A:'
     C                   MOVEL     OMFLD         MGBSSN
     C                   END
     C*       if swift id, obtain name and town
     C     OMTAG         IFNE      ':84A:'
     C                   MOVE      *BLANKS       WRK1              1                           12207
     C                   MOVEL     OM0112        WRK1                                          12207
      * Option tag 'A' may begin with the account line, so bypass the account li
      * line and get the CSID after.                                      122078
     C     WRK1          IFEQ      '/'                                                         12207
     C                   MOVEL     OMFLD         MDAT                                          12207
     C                   MOVEL     MDAT          RDAT                                          12207
     C                   MOVE      'Y'           WWPROC                                        12207
     C                   ELSE                                                                  12207
     C*
     C**      access SDCUSTL7 to obtain name and town
     C     OM0112        CHAIN     SDCUSTL7                           16
     C*
     C**      if record not found or deleted
     C     *IN16         IFEQ      '1'
     C     BBTYLC        OREQ      'D'
     C     *LOCK         IN        LDA
     C                   MOVE      '064'         DBASE                          * * * * * * * *
     C                   MOVEL     OM0112        DBKEY                          *  DBERR 064  *
     C                   MOVEL     'SDCUSTL7'    DBFILE                         * * * * * * * *
     C                   MOVEL     'MG0580'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   END                                                                   12207
     C*
     C                   END
     C                   END
     C*
     C** FORMAT RATE FIELDS
     C     OMTAG         LOOKUP    TAGRAT                                 70
     C     *IN70         IFEQ      '1'
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     OMFLD         MDAT
     C*****                MOVE OM0419    @WAMT  16
     C***********          MOVE OMFLD     @WAMT  16                       071394
     C*                                                                   071394
     C** Processing should be different for 33T                           071394
     C*                                                                   071394
     C     OMTAG         IFEQ      ':33T:'                                                     07139
     C                   MOVE      *BLANKS       @WAMT            16                           07139
     C                   MOVEL     OM0418        @WAMT                                         07139
     C                   ELSE                                                                  07139
     C                   MOVE      *BLANKS       @WAMT            16                           07139
     C                   MOVEL     OMFLD         @WAMT                                         07139
     C                   END                                                                   07139
     C*                                                                   071394
     C                   CALL      'ZM1340'                             21
     C                   PARM                    @WAMT
     C                   PARM      *BLANKS       @WCCY
     C                   PARM      'R'           @WTYP             1
     C                   PARM      *BLANKS       @REST            16
     C                   PARM      *BLANKS       @ERRC             1
     C                   PARM      MGNMDP        @CDP                                          16782
     C*
     C**     if program ZM1340 not found
     C     *IN21         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '065'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 065  *
     C                   MOVEL     'ZM1340'      DBPGM                          * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C*
     C**     if error during called program
     C     @ERRC         IFEQ      'Y'
     C     *LOCK         IN        LDA
     C                   MOVE      '066'         DBASE                          * * * * * * * *
     C                   MOVE      *BLANKS       DBKEY                          *  DBERR 066  *
     C                   MOVEL     DBERR1        DBKEY                          * * * * * * * *
     C                   MOVEL     'ZM1340'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C     OMTAG         IFEQ      ':33T:'                                                     07139
     C                   MOVEL     @REST         WR0424
     C                   MOVEL     OM0103        WR0103
     C                   MOVEL     WWRDAT        RDAT
     C*                                                                   071394
     C                   ELSE                                                                  07139
     C                   MOVEL     @REST         RDAT                                          07139
     C                   ENDIF                                                                 07139
     C*                                                                   071394
     C                   END
     C*
     C** FORMAT CONTINUATION LINES
     C** AND FIELDS NOT REQUIRING SPECIAL FORMATTING
     C     WWPROC        IFNE      'Y'
     C     OMTAG         LOOKUP    TAGOTH                                 70
     C     OMTAG         IFEQ      *BLANKS
     C     OMFLD         ANDNE     *BLANKS
     C     WW72          ANDNE     'Y'
     C     *IN70         OREQ      '1'
     C                   MOVE      'Y'           WWPROC
     C                   MOVEL     OMFLD         MDAT
     C                   MOVEL     MDAT          RDAT
     C                   END
     C                   END
     C*
     C** FORMAT FIELD 72
     C     OMTAG         IFEQ      ':72: '
     C                   MOVE      'Y'           WOUT72
     C                   MOVEL     '/CANCEL/'    MDAT
     C                   MOVEL     MDAT          RDAT
     C                   MOVEL     'Y'           WW72              1
     C                   END
     C*
     C**        BYPASS THE OTHER LINES OF FLD72
     C     WW72          IFEQ      'Y'
     C     OMTAG         ANDEQ     *BLANKS
     C                   MOVE      'N'           WOC               1
     C                   END
     C     OMTAG         IFEQ      ':79: '
     C     OMTAG         OREQ      ':77D:'
     C*    if field 72 has not been output, output it now
     C     WOUT72        IFNE      'Y'
     C                   MOVE      'Y'           WOUT72
     C                   MOVEL     '/CANCEL/'    MDAT
     C                   MOVEL     MDAT          RDAT
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   ELSE
     C                   MOVE      'N'           WW72
     C                   END
     C                   END
     C*
     C** FILL TAG AND DESCRIPTION
     C                   MOVEL     OMTAG         MTAG
     C     OMTAG         LOOKUP    TABT          TABN                     71
     C     *IN71         IFEQ      '1'
     C                   MOVEL     TABN          WI                2 0
     C                   MOVEL     DESA(WI)      MDES
     C                   ELSE
     C                   MOVEL     *BLANKS       MDES
     C                   END
     C*
     C** ADD 1 TO INDEX OF MULT. OCCUR DATA STRUCTURE
     C     WOC           IFEQ      ' '
     C                   ADD       1             X
     C     X             OCCUR     MULT
     C                   END
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*COPY*ZSRSRC,ZDATE1Z2                                                                 MD058081
     C/COPY ZSRSRC,ZDATE1Z2LE                                                               MD058081
     C/EJECT
     C*****************************************************************
     C**                                                              *
     C**  PSSR      - ERROR HANDLING                                  *
     C**                                                              *
     C**  CALLS     -                                                 *
     C**                                                              *
     C**  CALLED BY -                                                 *
     C**                                                              *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR
     C*
     C** WRITE DATABASE ERROR TO REPORT
     C                   OPEN      MG0580AU
     C                   WRITE     HEAD
     C                   WRITE     DBERROR
     C*
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   RETURN
     C                   ENDSR
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C****
     C* IF DESA IS AMENDED, THE TABLE DEST/DESN SHOULD BE CHECKED AS DESN IS
     C* THE INDEX USED TO RETRIEVE DESCRIPTION IN DESA
     C****
     C*COPY*MGCPYSRC,SWIFTTRANS                                           BLI605            MD058081
     C/COPY MGCPYSRC,MGSWIFTRAN                                                             MD058081
** CPY@   Object Copyright
(c) Fina  stra International Limited 2001
** ARR2  CASE NUMBERS
01020506  07101112131516172021
22232425  26272930313234353637
** ERRA   ERROR MESSAGES
Customer number not found on customer file                                   01
Unable to format mandatory field :20:                                        02
Unable to format field :23: - combination invalid                            03
Unable to format field :23: - subfield 1 or 2 invalid                        04
Unable to format field :23: - subfield 3 invalid                             05
Unable to format mandatory field :30:                                        06
Unable to format mandatory field :31P:                                       07
Unable to format mandatory field :31T:                                       08
Unable to format mandatory field :26J:                                       09
Unable to format mandatory field :35A:                                       10
Unable to format mandatory field :35B:                                       11
Unable to format mandatory field :35E:                                       12
Certificate numbers not found for :35E:                                      13
Unable to format mandatory field :83R:                                       14
Unable to format mandatory field :83C:                                       15
Clearing Corres. must be entered for Cedel :84A:                             16
Unable to format mandatory field :84A:                                       17
(removed)                                                                    18
(removed)                                                                    19
Unable to format mandatory field :87a:                                       20
Address not found for field :87a:                                            21
Unable to format mandatory field :85C:                                       22
Unable to format mandatory field :88a:                                       23
Address not found for field :88a:                                            24
Unable to format mandatory field :57a:                                       25
Unable to format addresses for :57a:                                         26
Unable to format mandatory field :58a:                                       27
Field :58a: must be present when field :57a: is present                      28
Field :57a: must be present when field :58a: is present                      29
Unable to format addresses for :58a:                                         30
Unable to format mandatory field :33T:                                       31
Nominal Currency not found for field :33T:                                   32
Unable to format mandatory field :32M:                                       33
Unable to format mandatory field :37J:                                       34
Unable to format mandatory field :34a:                                       35
Unable to format mandatory field :37L:                                       36
Unable to format mandatory field :37S:                                       37
Unable to format mandatory field :33S:                                       38
Unable to format mandatory field :37P:                                       39
Unable to format mandatory field :32B:                                       40
Unable to format mandatory field :26K:                                       41
Unable to format field :26K:                                                 42
Too many denomination choices for field :26K:                                43
Unable to format mandatory field :77B:                                       44
Unable to format mandatory field :72:                                        45
Unable to format mandatory field :79:                                        46
Destination not Euroclear or Cedel                                           47
*** Message is Unroutable ***                                                48
Unable to format mandatory field :77D:                                       49
Invalid formatting for field :87a:                                           40
Invalid formatting for field :88a:                                           51
Invalid formatting for field :57a:                                           52
Invalid formatting for field :58a:                                           53
** DESA   DESCRIPTIONS
                     SETTLEMENT DATE
              FURTHER IDENTIFICATION
             DATE AND PLACE OF TRADE
                  REQUESTED PRIORITY
                              T.R.N.
                       TIME OF TRADE
              QUANTITY OF SECURITIES
        IDENTIFICATION OF SECURITIES
                 CERTIFICATE NUMBERS
                       SENDER'S ROLE
                 SAFEKEEPING ACCOUNT
              CLEARING CORRESPONDENT
    RECEIVER/DELIVERER OF SECURITIES
       DELIVERER'S INSTRUCTING PARTY
           BENEFICIARY OF SECURITIES
            ACCOUNT WITH INSTITUTION
                BENEFICIARY OF MONEY
                          DEAL PRICE
                         DEAL AMOUNT
           DEAL AMOUNT EXCHANGE RATE
                    ACCRUED INTEREST
      ACCRUED INTEREST EXCHANGE RATE
ACCRUED INTEREST RATE AND CALC BASIS
                 SPECIAL CONCESSIONS
   SPECIAL CONCESSIONS EXCHANGE RATE
                   SETTLEMENT AMOUNT
                    FUNGIBILITY CODE
                 DENOMINATION CHOICE
                 FURTHER INFORMATION
      SENDER TO RECEIVER INFORMATION
                           NARRATIVE
               REGISTRATIONS DETAILS
** NUM
1234567890
** TAGAMT
:32B::33S::35A::32M:
** TAGRAT
:37J::37L::37S::37P::33T:
** TAGBIC
:84A::87A::57A::58A:
** TAGOTH
:26J::26L::26K::31T::35B::35E::57D::58D::77B::77D::79: :83R::83C::85C::87C::87D:
:88C::88D:
** TDEST/TDESN
:30: 01:23: 02:31P:03:26J:04:20: 05:31T:06:35A:07:35B:08:35E:09:83R:10:83C:11
:84A:12:87A:13:87C:13:87D:13:85C:14:88C:15:88D:15:57A:16:57D:16:58A:17:58D:17
:33T:18:32M:19:37J:20:34G:21:34H:31:37L:22:37S:23:33S:24:37P:25:32B:26:26L:27
:26K:28:77B:29:72: 30:79: 31:77D:32
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
