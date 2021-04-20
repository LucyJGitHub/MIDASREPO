     H DEBUG FTRANS
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Outgoing message maintenance')                *
/*XBIF*: OVRDBF FILE(MGOREFLU) TOFILE(MGOREFL0)                     : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management                                   *
     F*                                                               *
     F*  ME0600 - Outgoing Message Detail Enquiry/Maintenance         *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056560           Date 31Aug20               *
      *  Prev Amend No. MD052485           Date 02Apr19               *
      *                 MD051910           Date 02Apr19               *
      *                 CSW218             Date 19Mar18               *
      *                 MD046248           Date 27Oct17               *
      *                 CSW213             Date 03Jun13               *
      *                 MD020899           Date 26Jun13               *
      *                 263130             Date 14Dec09               *
      *                 264001             Date 23Feb10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 258797             Date 10Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14915           Date 25Sep07               *
      *                 CSW207             Date 13Jun07               *
      *                 121288             Date 15Dec06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 174844             Date 02Nov02               *
      *                 CSD031             Date 10Apr06               *
      *                 204225             Date 02May06               *
      *                 206803             Date 10Jul02               *
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
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 212173             Date 18Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 158656             Date 11Dec01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 196833             Date 16Aug01               *
      *                 183583             Date 08Jun01               *
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186181             Date 08Nov00               *
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTK001             Date 11May99               *
     F*                 141572             Date 21SEP98               *
      *                 CMT001             Date 02NOV98               *
      *                 131215             DATE 18OCT98               *
      *                 140629             Date 18Sep98               *
     F*                 CSW098             Date 24MAR97               *
     F*                 113352             Date 13Feb97               *
     F*                 115412             DATE 17Feb98               *
     F*                 107503             DATE 11APR97
     F*                 CSW097             Date 26May97               *
     F*                 S01408             Date 14Nov96               *
     F*                 CSW096             DATE 03SEP96               *
     F*                 098075             DATE 21JUN96               *
     F*                 093005             DATE 07MAY96               *
     F*                 CSW003             DATE 19JAN96               *
     F*                 S01408             DATE 09JAN96               *
     F*                 087198             DATE 23OCT95               *
     F*                 087654             DATE 10OCT95               *
     F*                 087653             DATE 10OCT95               *
     F*                 087779             DATE 05JUN95               *
     F*                 S01408             DATE 21APR95               *
     F*                 081561             DATE 12JAN95               *
     F*                 081505             DATE 12JAN95               *
     F*                 067471             DATE 01NOV94               *
     F*                 067460             DATE 01NOV94               *
     F*                 067236             DATE 01NOV94               *
     F*                 067210             DATE 01NOV94               *
     F*                 067054             DATE 01NOV94               *
     F*                 066991             DATE 01NOV94               *
     F*                 078455             DATE 25OCT94               *
     F*                 S01435             DATE 10NOV93               *
     F*                 057745             DATE 02FEB94               *
     F*                 042081             DATE 26MAY93               *
     F*                 E38493             DATE 15APR92               *
     F*                 E29588             DATE 31OCT91               *
     F*                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD052485 - MT202 F52A + F57A incorrect field data in SpA Ldn *
      *             printed report vs. MPM.                           *
      *  MD051910 - Incorrect 57a tag extended details.               *
      *           - Applied for MD052485.                             *
      *  CSW218 - SWIFT Changes 2018                                  *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW213 - SWIFT Changes 2013 (Recompile)                      *
      *  MD020899 - There are spaces between field 50F lines          *
      *  263130 - Do not expand 50F.                                  *
      *  264001 - Outgoing Message picking up wrong address in field  *
      *           57A. Ensure that if message type is 202 and tag     *
      *           :119: is present, the sequence number is reset so   *
      *           that the correct details will be displayed for tag  *
      *           57A. Apply and correct fix 263606.                  *
      *  258797 - Invalid characters in the displayed MTCASH message. *
      *           Remove all characters '#' and '¢' in array TXT.     *
      *  BUG14915 - Error in using Corporate BEI field                *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  121288 - Display 'Deliverer of Securities' as text if second *
      *           occurrence of field tag 87. (1st occurrence in an   *
      *           MT512 is always 'Receiver of Securities').          *
      *  174844 - For MT580, display part deleted as for MT210 and    *
      *           MT203.                                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  204225 - Field tag :50: is incorrect on SWIFT MT103.         *
      *           CROSSMAR customers must be checked first before tag *
      *           :50A: or tag :50K: is written/shown on MT103.       *
      *  206803 - Ensure that the correct record is accessed in       *
      *           MGOEXTPD for fields 5Na and 8Na for MT103s with     *
      *           field :119:.                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  210868 - In MT202, data replicated in field 57A:.            *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  212173 - Process validation fields for MT103s                *
     F*  158656 - Fix 183583 made it mandatory to have a record in    *
     F*           PF/MGOEXTPD to display the report name and town     *
     F*           of the Swift Address of field tag :5nA:. Replace    *
     F*           BIC customer parameter only if a record exists.     *
      *  196833 - Additional SWIFT Address for CLS Nostros            *
      *  183583 - Read created extension file MGOEXTPD in order to    *
      *           obtain the correct customer number and to retrieve  *
      *           its corresponding customer name & town.             *
      *  CSW201 - SWIFT 2001 Standards Update                         *
     F*  186181 - Format for currency and amounts needs to be able to *
     F*           cope with a sign in front                           *
     F*  CTK001 - Testkey module conversion from DOS to WINDOWS       *
     F*           95/NT (Testkey II) Error message changed from UNABLE*
     F*           TO GENERATE TESTKEY - INVALID MIDAS TESTKEY         *
     F*           WORKSTATION to ....TESTKEY USER                     *
     F*  141572 - Recompile over changes in MGOREFPD                  *
     F*  CMT001 - Orion Telex 3.3 Implementation.                     *
     F*           Addition of new Telex status codes.                 *
     F*  131215 - If priority entered is 'Urgent' then both delivery  *
     F*           monitoring Fields should be filled.                 *
     F*  140629 - Convert field 72 amount (, to .)                    *
     F*  CSW098 - SWIFT 1998 changes.                                 *
     F*           This program is changed to recognise MT515/518      *
     F*           tags :98a: date/time format suffixed with a         *
     F*           qualifier and/or type (:qual//type/yyymmddhhmmss).  *
     F*           A new tag format 'DT' is introduced to format time  *
     F*           to hh:mm:ss.  Also, :95P: (:qual//swiftid) should   *
     F*           also be output with name and address as with :5nA:  *
     F*           and :8nA: tags. Furthermore, MG5910 must also be    *
     F*           run when deleting the new MT515 and MT518 messages. *
     F*  113352  -  Recompile over changes in MGOREFPD                *
     F*  115412 - Data base error in MG5910 at 10                     *
     F*           Do not call MG5910 for other message type than      *
     F*           MT510,512,520,521,522,523,554,580.                  *
     F*  107503 - If destination is from SWIFT BIC file, output name  *
     F*           and city from this file                             *
     F*  CSW097 - Swift changes 1997:                                 *
     F*           The program was amended to recognise dates          *
     F*           in CCYYMMDD format.                                 *
     F*           Also, display name and town for :8nA: fields        *
     F*  S01408 - Addition of core hook ME0600CP13                    *
     F*         - Addition of core hook ME0600CP12                    *
     F*         - Addition of core hook ME0600EEP1                    *
     F*         - Addition of core hook ME0600X001                    *
     F*         - Addition of core hook ME0600OOP1                    *
     F*  CSW096 - Swift Changes 1996:                                 *
     F*           Add validation for field 22.                        *
     F*  098075 - Verification field in message management allows     *
     F*           anything to be input to transmit SWIFT pay          *
     F*           messages for message MT200 when ICD is set to 'Y'   *
     F*           for verify payment messages.                        *
     F*  093005 - Additional code for CORE FIX 087779.                *
     F*  CSW003 - MT5XX Message Generation - Phase 2.                 *
     F*  S01408 - Core hook ME0600CCP3 added                          *
     F*         - Core hook ME0600CCP4 added                          *
     F*         - Core hook ME0600CCP5 added                          *
     F*         - Core hook ME0600CCP6 added                          *
     F*         - Core hook ME0600CCP7 added                          *
     F*         - Core hook ME0600CCP8 added                          *
     F*         - Core hook ME0600CCP9 added                          *
     F*         - Core hook ME0600CP10 added                          *
     F*         - Core hook ME0600CP11 added                          *
     F*  087198 - Review validation of priority and delivery          *
     F*           combination.                                        *
     F*  087654 - For MT210s, output multiple message TRN, instead    *
     F*           of MIDAS transaction number because TRN is          *
     F*           otherwise not shown for part. apply fix E42824      *
     F*  087653 - Allow  deletion of entire MT203.                    *
     F*  087779 - Ensure CONG and RCDG are reset if an SE message     *
     F*           is deleted, otherwise a DB error can occur later.   *
     F*  S01408 - Core hook ME0600FFPG added                          *
     F*         - Core hook ME0600IIPG added                          *
     F*         - Core hook ME0600CCPG added                          *
     F*         - Core hook ME0600CCP1 added                          *
     F*         - Core hook ME0600CCP2 added                          *
     F*  081561 - Additional message status for supervisors added.    *
     F*  081505 - Message status text changed to be more meaningful.  *
     F*  067471 - Testkey not reported                                *
     F*  067460 - ME0600 fails trying to generate tetskey if not      *
     F*           run from Testkey workstation                        *
     F*  067236 - Return code added to Testkey CL processing          *
     F*  067210 - Pass date to Testkey in DDMMYY format (rather       *
     F*           than YYMMDD)                                        *
     F*  067054 - Pass telex shortname to Testkey, rather than        *
     F*           customer number                                     *
     F*  066991 - Orion not passing Telex status back to Midas        *
     F*  078455 - Midas Leo Integration. Bypass the code that set up  *
     F*           Midas customer numbers for external systems.        *
     F*  S01435 - Incoming Message Management                         *
     F*  057745 - VERIFY MT200 NOSTRO TRANSFER TRANSMISSION           *
     F*  042081 - Add town to address                                 *
      *   E38493  -  SUPRESS ALL BRANCH INFO WHEN SINGLE BRANCHING    *  *
      *   E29588 - POST-COLLECTION SWIFT RATIONALISATION AMENDMENTS   *
      *             o Do not output SWIFT error line if it contains   *
      *               non-numeric data                                *
      *             o Update last action date and time for all        *
      *               amendments                                      *
      *             o Change status to AMENDED for all amendments     *
      *               except re-route to paper                        *
      *             o Output correct narrative for ME/MX free-format  *
      *               messages                                        *
      *                                                               *
      *  RE-WRITTEN FOR S01344 - SWIFT RATIONALISATION PHASE 2        *
      *                                                               *
      *****************************************************************
     FME0600DF  CF   E             WORKSTN
     F                                     SFILE(ME0600F2:RRN)
     FMGOREFL0  IF   E           K DISK
     FMGOREFLU  UF   E           K DISK
     F                                     RENAME(MGOREFD0:MGOREFU0)
     F/COPY WNCPYSRC,ME0600F001
     FMGOMSGPD  IF   E           K DISK
     FMGOEXTLF  IF   E           K DISK                                         183583
     FSDMTPYL0  IF   E           K DISK
     F*SDMTAGL0* IF   E           K DISK                                                    MD056560
     FSDMMODPD  IF   E             DISK
     FSDBRCHL5  IF   E           K DISK
     FSDCUSTL0  IF   E           K DISK
     FSDCUSTL7  IF   E           K DISK
     F                                     RENAME(@CUSTGE:SDCUSTSW)
     FSDCUSTL9  IF   E           K DISK
     F                                     RENAME(@CUSTLG:SDCUSTST)
     FSDCUSTLA  IF   E           K DISK
     F                                     RENAME(@CUSTLH:SDCUSTTX)
     FSDCNSTL2  IF   E           K DISK
     F                                     RENAME(@CNSTLD:SDCNSTSW)
     FSDCNSTL3  IF   E           K DISK
     F                                     RENAME(@CNSTLE:SDCNSTST)
     FSDCNSTL4  IF   E           K DISK
     F                                     RENAME(@CNSTLF:SDCNSTTX)
     FSDCUSTLI  IF   E           K DISK
     F                                     RENAME(SDCUSTD0:SDCUSTBE)
     FTKOTIPF   O  A E             DISK    USROPN
     FTKOTOPF   IF   E             DISK    USROPN
      *                                                                                       CSW201
      ** MG Transaction history file                                                          CSW201
     FMGHISTL3  IF   E           K DISK
      *                                                                                       CSW201
      ** MG Transaction history file by first transaction number                              CSW201
     FMGHISTL4  IF   E           K DISK
     F                                     RENAME(MGHISTD0:MGHISTD2)
      *                                                                                       CSW201
     FSDCWHTL1  IF   E           K DISK
      ** Compliance Watch Hit List by Function Type                                           CSD015
      *                                                                                       CSD015
     FMEBICDL2  IF   E           K DISK
      ** BIC Directory table                                                                  CSW218
     F*                                                                   S01408
     F/COPY WNCPYSRC,ME0600FFPG                                           S01408
     F*                                                                   S01408
      *
      * ID C  F  H  L    Function of indicators
      *    10            EOF MGOREFPD
      *    11            EOF MFOMSGPD
      *    15            MG9205 not found (error on call)
      *    20            SFLDSP
      *    21            SFLDSPCTL
      *    22            SFLEND
      *    23            Enable F8-Previous
      *    24            Enable F9-Next
      *    25            Enable F10-Delete
      *    26            Enable F20-Amend
      *    27            Enable F24-Release
      *    28            Display delete prompt
      *    29            Display amend prompt
      *    30            Display release prompt
      *    31            ENTER pressed
      *    35            Error
      *    40            Error - Message/Part to delete
      *    41            Error - Network
      *    42            Error - Priority
      *    43            Error - Delivery
      *    44            Error - Non-delivery
      *    45            Error - Verification
      *    46            Error - Testkey
      *    50            MM/MMM LOKUP
      *    51            Status codes LOKUP
      *    52            Verify field LOKUP
      *    53            Format field LOKUP
      *    60            Verification required
      *    61            Testkey required
      *    62            SWIFT message => enable prioity/deliver input
      *    70            ON  => title on display is '... Maintenance'
      *    --            OFF => title on display is '... Enquiry'
      *    75            ELIN (Error line) contains non-numeric data      E29588
      *    81            USED IN SCAN FOR /OCMT/ AND /CHGS/               140629
      *    90            EOF SDCUSTPD/SDCNSTPD
      *    96            EOF SDMTYPPD
      *    97            EOF SDMMODPD
      *    98            EOF SDMTAGPD
      *    KH            F8
      *    KI            F9
      *    KJ            F10
      *    KL            F12
      *    KU            F20
      *    KY            F24
      *    U7U8LR        DB error
      *
      *                                                                   S01408
     D/COPY WNCPYSRC,ME0600EEP1                                           S01408
      *                                                                   S01408
     D TABMM           S              2    DIM(12) CTDATA PERRCD(1)             months MM/MMM format
     D TABMON          S              3    DIM(12) ALT(TABMM)
     D/COPY WNCPYSRC,ME0600E004
     D******************* TXT     1  23 78               text             067236
     D********************TXT     1  26 78               text       067236CTK001
     D********************TXT     1  27 78               text      CTK001 121288
     D TXT             S             78    DIM(28) CTDATA PERRCD(1)             text             121
     D/COPY WNCPYSRC,ME0600E005
     D******************* TABCD   1  23  4   TABNAR 35   status codes     066991
     D******************* TABCD   1  41  4   TABNAR 35   status code066991081561
     D******************* TABCD   1  42  4   TABNAR 35   status code081561CMT001
     D TABCD           S              4    DIM(49) CTDATA PERRCD(1)             status codes     CMT
     D TABNAR          S             35    DIM(49) ALT(TABCD)
     D***********         VERFY   1   5  6               verify field     098075
     D/COPY WNCPYSRC,ME0600E001
     D***********         VERFY   1   6  6               verify field     098075              212173
     D VERFY           S              6    DIM(7) CTDATA PERRCD(1)              verify field
     D/COPY WNCPYSRC,ME0600E002
     D TAB1            S              2  0 DIM(10) CTDATA PERRCD(1)             Match status textS01
     D TAB2            S             15    DIM(10) ALT(TAB1)
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,ME0600E003
     D FLA             S              1    DIM(50)                              format field
     D FLB             S              1    DIM(50)                              formatted field
      ** Array for determining end of correspondent.                      CTK001
      *                                                                   CTK001
     D/COPY WNCPYSRC,ME0600E006
      *
     D USMTPY          DS             3                                         CSW096
     D  USCH1                  1      1                                         CSW096
     D  USCH2                  2      2                                         CSW096
     D  USCH3                  3      3                                         CSW096
      *                                                                   CSW096
     D LDA             DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      **  Local data area
      *
     D                SDS
     D  WSID                 244    253
     D  USRID                254    263
      **  Workstation ID
      *
     D DSRUN           DS            13
     D  RUNA                   1      7
     D/COPY WNCPYSRC,ME0600I005
     D  DATF                  12     12
     D  MBIN                  13     13
      **  RUNDAT data area
      *
     D DSSTAT          DS           256
     D  SEQ                    1      5  0
      **  MTSTAT data area
     D/COPY WNCPYSRC,ME0600I002
      *
     D                 DS
     D  MGDE                   1      6  0
     D  YY                     1      2
     D  MM                     3      4
     D  DD                     5      6
     D                 DS
     D  @DMY                   1      7
     D  @DD                    1      2
     D  @MM                    3      5
     D  @YY                    6      7
      **  Message date
      *
     D                 DS
     D  @MTAG                  1      5
     D  @WK3                   1      3
     D  @WK1                   2      2
     D  @WL1                   4      4
     D/COPY WNCPYSRC,ME0600I001
      **  Message tag
      *
     D                 DS
     D  @DN                    1      2
     D  @D                     1      1
     D  @N                     2      2
      **  Delivery, non delivery notification
      *
     D                 DS
     D  RCD1                   1     78
     D  @RCD1                  1     40
     D  BRCA                   8     10
     D  OTHT                  17     36
     D  OTHB                  38     40
     D  RCBR                  66     68
     D                 DS
     D  RCD2                   1     78
     D  NWRK                   9     14
     D  MTPY                  30     32
     D  @TYP                  34     68
     D  @PDE                  71     78
     D                 DS
     D  RCD3                   1     78
     D  NWSN                  17     36
     D  @MGDE                 59     65
     D                 DS
     D  RCD4                   1     78
     D  NWDS                  17     36
     D  @NAME                 45     64
     D  @TOWN                 66     75
     D                 DS
     D  RCD5                   1     78
     D  @DSC                  17     41
     D  LADT                  50     56
     D  @LATM                 63     70  0
     D  @@HH                  63     64
     D  @@MM                  66     67
     D  @@SS                  69     70
     D*                                                                   S01408
     D/COPY WNCPYSRC,ME0600IIPG                                           S01408
     D*                                                                   S01408
      **  Common headings
      *
     D                 DS
     D  RCD6                   1     78
     D  MODI                   8      9
     D  MTRN                  29     43
     D  TNTP                  50     51
     D  SBTP                  61     62
     D  IPME                  11     78
      **  MIDAS generated single message headings
      *
     D                 DS
     D  RCD7                   1     78
     D  @MODI                  8      9
     D**********                             29  43 SACN                                      CGL029
     D  SACN                  29     49
      **  MIDAS generated MT950 statement message
      *
     D                 DS
     D  RCD8                   1     78
     D  SYTM                  17     22
      **  External system message headings
      *
     D                 DS
     D  RCD9                   1     78
     D  @RCD9                  1     44
     D  @MPRY                 10     15
     D  @DEL                  21     21
     D  @NDL                  31     31
     D  MSE1                  51     53
     D  ELIN                  55     57
      **  SWIFT headings
      *
     D                 DS
     D  RCD10                  1     78
     D  TSKSN                 17     19
      **  Telex headings
      *
     D                 DS
     D  RCD11                  1     78
     D  CPYNAR                19     33
     D  BRKNAR                55     69
      **  Single message confirmation matching headings
      *
     D                 DS
     D  RCD12                  1     78
     D  @DLT                   2     12
     D  @MODL                 18     19
     D************                           24  40 @MTRN                 087654
     D  @MTRN                 26     40                                         087654
     D  @TNTP                 47     48
     D  @SBTP                 54     55
     D  @CPY                  57     65
     D  @CFCPY                63     64
     D  @BRK                  66     73
     D  @CFBRK                71     72
     D  @BLK                  57     72
      **  Multiple message part headings
      *
     D                 DS
     D  RCD13                  1     78
     D**EFSCFD*                1     20                                                     MD056560
     D  XFSCFD                 1     20                                                     MD056560
     D  MTAG                  22     26
     D  MTAG#                 23     24                                         121288
     D**********                             27  27 @#                                        258797
     D  MFLD                  28     77
     D  @WM1                  28     28
      **  Message text field
      *
     D                 DS                                                       E29588
     D  RCDME                  1     78                                         E29588
     D  MEMOD                  8      9                                         E29588
      **  Heading for Message Managemnt free-format messages              E29588
      *                                                                   E29588
     D                 DS                                                       067471
     D  RCDTK                  1     78                                         067471
     D  @TKY                  17     31                                         067471
      **  Heading for Testkey                                             067471
      *                                                                   067471
     D/COPY WNCPYSRC,ME0600I003
     D                 DS
     D  WRKDAT                 1      8
     D  WRKYY                  1      2
     D  WRKMM                  4      5
     D  WRKDD                  7      8
      **  Data structure for rearranging date
      *
     D                 DS
     D  CHGDAT                 1      8
     D  @CHG5                  1      5
     D  @1                     3      3    INZ('/')
     D  @@2                    6      6    INZ('/')
     D  CHGYY                  7      8
      *                                                                   CSW097
      ** New data structure was introduced to accommodate                 CSW097
      ** CCYYMMDD format.                                                 CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  WKDAT                  1     10                                         CSW097
     D  WKYY                   1      4                                         CSW097
     D  WKMM                   6      7                                         CSW097
     D  WKDD                   9     10                                         CSW097
      *                                                                   CSW097
      ** Data structure for rearranging date in CCYYMMDD format.          CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  CHDAT                  1     10                                         CSW097
     D  @CH5                   1      5                                         CSW097
     D  @3                     3      3    INZ('/')                             CSW097
     D  @@4                    6      6    INZ('/')                             CSW097
     D  CHYY                   7     10                                         CSW097
      *                                                                   CSW097
      ** Define a constant.                                               CSW097
      *                                                                   CSW097
     D DIGITS          C                   CONST('0123456789')                  CSW097
     D/COPY WNCPYSRC,ME0600I004
      **  Data structure for rearranging date
      *
     D                 DS
     D  WRKLAT                 1      6
     D  @WKHH                  1      2
     D  @WKMM                  3      4
     D  @WKSS                  5      6
      **  Date structure for time
      *
     D                 DS
     D  ZSWFT                  1     12
     D  USID                   8      8                                         CSW096
     D  BIC                    9     11
      ** DS to check for BIC address
      *
     D                 DS                                                       S01156
     D  TKIN                   1     35                                         S01156
     D  W1                     1      2  0                                      S01156
     D  DTTP                   3      3                                         S01156
     D  CLN                    4      4                                         S01156
     D  DATA                   5     35                                         S01156
     D  DATX                   5     35                                         CTK001
     D                                     DIM(31)                                               CTK
     D  DTA4                   8      8                                         S01156
     D  DTA2                  11     12                                         S01156
     D  DTA3                  13     13                                         S01156
     D  DTA5                  15     15                                         067054
      **  Data structure to hold message passed to testkey                S01156
      *                                                                   S01156
     D                 DS            34
     D  TKOT                   1     34
     D  ID                     1      2  0                                      S01156
     D  SYS1                   2      2
     D  TSKY1                  4     33
     D  ERRR                   4      4
      ** Data structure to hold message received from testkey
      *
     D                 DS
     D  SVDT                   1      6
     D  YY1                    1      2
     D  MM1                    3      4
     D  DD1                    5      6
      *
     D                 DS
     D  @SVDT                  1      6
     D  DD2                    1      2
     D  MM2                    3      4
     D  YY2                    5      6
      *                                                                   107503
      **  Data structure to split BIC address                             107503
      *                                                                   107503
     D                 DS                                                       107503
     D  W01BIC                 1     12                                         107503
     D  W01ICC                 1      8                                         107503
     D  W01ICB                 9     11                                         107503
      **  Data structure to reformat value date
      *
     D WHREF           DS                  OCCURS(16)
     D  HSMODI                 1      2
     D  HSTRAN                 3      8
     D  HSSEQ                  9     11
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
     D** Message Management details.
     D*
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW003
      *                                                                   CSW003
      ** External data structure for Switchable Features                  CSW003
      *                                                                   CSW003
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
     D BICLAY          DS            77                                         S01435
      * Format for Report                                                 S01435
     D  #SCR1                 28     62                                         S01435
     D  #SCR2                 63     77                                         S01435
      /EJECT                                                              S01435
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Access object DS
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      ** Long data structure for access objects                                               196833
      *                                                                                       196833
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)
      ** Midas Functions for Watch List Checking Details File                                 CSD015
      *                                                                                       CSD015
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
      ** SD data area                                                                         CSD015
     I/COPY WNCPYSRC,ME0600I006
      *                                                                                       CSD015
     C     MGTAGK        KLIST
     C                   KFLD                    MTAGK             5
     C                   KFLD                    MTPYK             3
      *                                                                   CSW098
     C     KMTAG         KLIST                                                                 CSW09
     C                   KFLD                    MTAGK                                         CSW09
     C                   KFLD                    MTPYK                                         CSW09
     C                   KFLD                    MSEQN             3                           CSW09
      *                                                                   183583
      ** KLIST for MGOEXTLF                                               183583
      *                                                                   183583
     C     KEXTN         KLIST                                                                 18358
     C                   KFLD                    TRNO                                          18358
     C                   KFLD                    MTPY                                          18358
     C                   KFLD                    @V                2 0                         18358
      *
     C     *ENTRY        PLIST
     C                   PARM                    TRNO             16
     C                   PARM                    BGCFMT            1
     C                   PARM                    ACTN              1
     C                   PARM                    FILA              1
     C                   PARM                    RTCD              2
     C                   PARM                    @ERR              1
     C                   PARM                    @TK               1                           06746
      *
      **  ZM1001 ERROR
     C     PLIST3        PLIST
     C                   PARM                    @MSGID           10
     C                   PARM                    @MSDTA           78
      *
     C                   MOVEL     'ME0600'      PGMQ             10                           S0122
     C                   MOVEL     *BLANKS       MSGKEY            4
      *                                                                                       CSW201
     C     KHIST         KLIST
     C                   KFLD                    HSMODI
     C                   KFLD                    HSTRAN
     C                   KFLD                    HSMTPY
     C                   KFLD                    HSSEQ
      *
      *****************************************************************
      *                   Index to subroutines                        *
      *   main process                                                *
      *   INIT   - initial process                                    *
      *   HDNG   - write message headings                             *
      *   TEXT   - write message text                                 *
      *   DELT   - delete message                                     *
      *   AMND   - amend message                                      *
      *   RELS   - release message                                    *
      *   SWADDR - format Name/Town from SWIFT address                *
      *   STADDR - format Name/Town from STTX address                 *
      *   TXADDR - format Name/Town from TELEX address                *
      *   PAPER  - clear Name/Town fields for paper messages          *
      *   FORM   - Format subfield                                    *
      *   *PSSR  - error handling                                     *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *   main process                                                *
      *   Calls - INIT initial process                                *
      *           HDNG write message headings                         *
      *           TEXT write message text                             *
      *           DELT delete message                                 *
      *           AMND amend message                                  *
      *           RELS release message                                *
      *****************************************************************
      *
      **  Perform initial process
     C                   EXSR      INIT
      *
      **  Access message reference file using transaction reference
     C     TRNO          CHAIN     MGOREFL0                           10
      *
     C     *IN10         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     TRNO          DBKEY                          * DB ERROR 03 *
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C067
      *
      **  If transaction is part of mutiple message
      **  access message reference file using message reference
     C     TRNF          IFNE      *BLANKS                                                 1
     C                   MOVE      TRNF          TRNO
      *
     C     TRNO          CHAIN     MGOREFL0                           10
      *
     C     *IN10         IFEQ      '1'                                                     2
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVEL     TRNO          DBKEY                          * DB ERROR 04 *
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C068
     C                   END                                                              E1
      *
      **  Save header message details
     C                   MOVE      TRNO          @TRNO            16
     C                   MOVE      MGSG          @MGSG             1
     C                   MOVE      NWRK          @NWRK             6
     C                   MOVE      TSKS          @TSKS             1
     C/COPY WNCPYSRC,ME0600C006
      *
      **  Write message headings
     C                   EXSR      HDNG
      *
      **  Access message file using message reference
     C     TRNO          CHAIN     MGOMSGPD                           11
      *                                                                                       174844
      **  Initialise variable for first part of MT580.                                        174844
     C                   MOVEL     'FIRST'       PHS               5
      *
     C     *IN11         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     TRNO          DBKEY                          * DB ERROR 05 *
     C                   MOVEL     'MGOMSGPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C015
      *
      **  Process messages records with message reference
      *                                                                                       206803
     C     MTPY          IFEQ      '103'
     C     MTAG          ANDEQ     ':119:'
     C     MTPY          OREQ      '202'
     C     MTAG          ANDEQ     ':119:'
     C     MTPY          OREQ      '103'
     C     MTAG          ANDEQ     ':121:'
     C     MTPY          OREQ      '202'
     C     MTAG          ANDEQ     ':121:'
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
     C     *IN11         DOWEQ     '0'                                                     1
     C/COPY WNCPYSRC,ME0600C016
      *
      **  Write message text
     C                   EXSR      TEXT
      *
      **  Access next message file record with message reference
     C     @TRNO         READE     MGOMSGPD                               11
      *                                                                                       206803
     C     W#RSET        IFEQ      'Y'
     C                   Z-ADD     1             @V
     C                   MOVE      'N'           W#RSET
     C                   ELSE
     C                   ADD       1             @V                                            18358
     C                   ENDIF
      *                                                                                       206803
     C     @MARK         IFEQ      'Y'
     C                   MOVE      'Y'           W#RSET
     C                   MOVE      'N'           @MARK
     C                   ENDIF
      *                                                                                     MD052485
     C/COPY WNCPYSRC,ME0600C007
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C017
      *
      **  If last or single message disable F8-Next
     C     FILA          IFNE      'L'                                                     1
     C     FILA          ANDNE     'S'
     C                   SETON                                        23
     C                   END                                                              E1
      *
      **  If first or single message disable F9-Previous
     C     FILA          IFNE      'F'                                                     1
     C     FILA          ANDNE     'S'
     C                   SETON                                        24
     C                   END                                                              E1
      *
      **  Do until F8, F9 or F12 pressed
     C     *INKH         DOWEQ     '0'                                                     1
     C     *INKI         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
      *
      **  If no errors clear input fields
     C     *IN35         IFEQ      '0'                                                     2
     C                   MOVE      *BLANKS       STRN
     C                   MOVE      *BLANKS       SNWK
     C                   MOVE      *BLANKS       SPTY
     C                   MOVE      *BLANKS       SDEL
     C                   MOVE      *BLANKS       SNDL
     C                   MOVE      *BLANKS       STKY
     C                   MOVE      *BLANKS       SDAT
     C                   MOVE      *BLANKS       SCCY
     C                   MOVE      *BLANKS       SAMT
     C/COPY WNCPYSRC,ME0600C069
     C                   SETOFF                                       252627
     C                   SETOFF                                       282930
     C/COPY WNCPYSRC,ME0600C018
     C                   END                                                              E2
      *
      **  If not enquiry
     C     ACTN          IFNE      'E'                                                     2
      *
      **  Set indicator for 'Maintenance' on display
     C                   SETON                                        70
      *
      **  If unreleased enable F10-Delete & F20-amend
     C     @MGSG         IFEQ      '1'
     C                   SETON                                        2526                 3
      *
      **  If SWIFT, telex or STTX enable F24-Release
     C     @NWRK         IFEQ      'SWIFT'                                                 4
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP3                                           S01408
     C*                                                                   S01408
     C     @NWRK         OREQ      'TELEX'
     C     @NWRK         OREQ      'STTX'
     C/COPY WNCPYSRC,ME0600C054
     C                   SETON                                        27
     C                   END                                                              E4
     C                   END                                                              E3
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C043
      *
      **  If F10 pressed display delete prompt
     C     *IN25         IFEQ      '1'                                                     2
     C     *INKJ         ANDEQ     '1'
     C                   SETON                                        28
     C                   SETOFF                                       2930
     C/COPY WNCPYSRC,ME0600C019
     C                   END                                                              E2
      *
      **  If F20 pressed display amend prompt - If message is for the
      **  SWIFT network, enable priority/delivery input.
     C     *IN26         IFEQ      '1'                                                     2
     C     *INKU         ANDEQ     '1'
     C     @NWRK         IFEQ      'SWIFT'
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP9                                           S01408
     C*                                                                   S01408
     C                   SETON                                        62
     C                   ELSE
     C                   SETOFF                                       62
     C                   END
     C                   SETON                                        29
     C                   SETOFF                                       2830
     C/COPY WNCPYSRC,ME0600C008
     C                   END                                                              E2
      *
      **  If F24 pressed display verification prompt
     C     *IN27         IFEQ      '1'                                                     2
     C     *INKY         ANDEQ     '1'
     C/COPY WNCPYSRC,ME0600C051
      *
     C     ENVPM         IFEQ      'Y'                                                     3
     C/COPY WNCPYSRC,ME0600C020
     C     MTPY          IFEQ      '100'                                                   4
     C     MTPY          OREQ      '202'
     C     MTPY          OREQ      '203'
     C     MTPY          OREQ      '200'                                                       05774
     C     MTPY          OREQ      '103'
     C/COPY WNCPYSRC,ME0600C076
     C                   SETON                                        30
     C                   SETOFF                                       2829
     C                   END                                                              E4
     C/COPY WNCPYSRC,ME0600C021
     C                   END                                                              E3
      *
     C                   SETOFF                                       61
     C     @NWRK         IFEQ      'TELEX'                                                 3
     C     @TSKS         ANDEQ     'Y'
     C                   SETON                                        3061
     C/COPY WNCPYSRC,ME0600C044
     C                   SETOFF                                       2829
     C                   END                                                              E3
      *
      **  ..or release
     C     *IN30         IFEQ      '0'                                                     3
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCPG                                           S01408
     C/COPY WNCPYSRC,ME0600C041                                           S01408
     C*                                                                   S01408
     C                   EXSR      RELS
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP2                                           S01408
     C*                                                                   S01408
     C     *IN35         IFEQ      '0'                                                     4
     C                   SETOFF                                       252627
     C                   END                                                              E4
     C/COPY WNCPYSRC,ME0600C022
     C                   END                                                              E3
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C023
      *
      **  Write Subfile
     C                   WRITE     ME0600F1
     C                   WRITE     SFLMSGC
     C                   EXFMT     ME0600F3
     C                   CALL      'ZM1002'
     C                   SETOFF                                       35
     C                   SETOFF                                       404142
     C                   SETOFF                                       434445
     C                   SETOFF                                       46
      *
     C/COPY WNCPYSRC,ME0600C055
      *
      **  If ENTER pressed
     C     *IN31         IFEQ      '0'                                                     2
      *
     C     *IN28         IFEQ      '1'                                                     3
     C/COPY WNCPYSRC,ME0600C060
     C                   EXSR      DELT
     C/COPY WNCPYSRC,ME0600C061
     C                   END                                                              E3
      *
     C     *IN29         IFEQ      '1'                                                     3
     C/COPY WNCPYSRC,ME0600C009
     C                   EXSR      AMND
     C                   END                                                              E3
      *
     C     *IN30         IFEQ      '1'                                                     3
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCPG                                           S01408
     C/COPY WNCPYSRC,ME0600C042                                           S01408
     C*                                                                   S01408
     C                   EXSR      RELS
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP2                                           S01408
     C*                                                                   S01408
     C                   END                                                              E3
     C                   END                                                              E2
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C024
      *
      **  If F8 pressed
     C     *INKH         IFEQ      '1'                                                     1
     C                   MOVE      '08'          RTCD
     C                   END                                                              E1
      *
      **  If F9 pressed
     C     *INKI         IFEQ      '1'                                                     1
     C                   MOVE      '09'          RTCD
     C                   END                                                              E1
      *
      **  If F12 pressed
     C     *INKL         IFEQ      '1'                                                     1
     C                   MOVE      '12'          RTCD
     C                   END                                                              E1
      *
     C                   SETON                                        LR
     C/EJECT
      *****************************************************************
      *   INIT - inital process                                       *
      *   Called by - main process                                    *
      *****************************************************************
      *
     C     INIT          BEGSR
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP1                                           S01408
     C*                                                                   S01408
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      **  Set up LDA
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   MOVEL     'ME0600'      DBPGM
     C                   MOVE      *BLANKS       DBASE
     C                   OUT       LDA
      *
      ** Access SDMGMEPD for verification flag via access program.
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY                          * DB ERROR 04 *
     C                   MOVEL     'SDMGMEPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
      *
      **
     C     ENVPM         IFEQ      'Y'
     C                   SETON                                        60
     C                   END
      *
      *                                                                   CSW003
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
      *                                                                   CSW098
      ** Check if (CSW098) SWIFT 1998 changes is on                       CSW098
      *                                                                   CSW098
     C                   CALL      'SWIFT98'                            7676                   CSW09
     C                   PARM      *BLANKS       CSW098            7                           CSW09
      *                                                                   CSW098
     C     *IN76         IFEQ      '1'                                                         CSW09
     C     *LOCK         IN        LDA                                                         CSW09
     C                   MOVE      '011'         DBASE                                         CSW09
     C                   MOVEL     'SWIFT98 '    KEY16                                         CSW09
     C                   MOVE      'ERROR   '    KEY16            16            * * * * * * * *CSW09
     C                   MOVEL     KEY16         DBKEY                          *  DBERR 011  *CSW09
     C                   MOVEL     *BLANKS       DBFILE                         * * * * * * * *CSW09
     C                   OUT       LDA                                                         CSW09
     C                   EXSR      *PSSR                                                       CSW09
     C                   END                                                                   CSW09
      *                                                                                       CSW201
      ** Check if (CSW201) SWIFT 2001 changes is on                                           CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'
     C                   PARM                    P@RTCD            7
      *                                                                                       CSW201
     C     P@RTCD        IFEQ      'CSW2001'
     C                   MOVE      'Y'           CSW201            1
     C                   ELSE
     C                   MOVE      'N'           CSW201
     C                   ENDIF
      *                                                                   CSW003
      *                                                                                       CSD015
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
      *                                                                                       CSD015
      ** Check if Midas Compliance Watch (CSD015) is installed                                CSD015
      *                                                                                       CSD015
     C                   MOVE      'N'           CSD015            1
      *                                                                                       CSD015
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSD015'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '032'         DBASE
     C                   MOVEL     'CSD015'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD015
     C     PRTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CSD015
     C                   ENDIF
      *                                                                                       CSD015
      ** If CSD015 is on, check that function code is being monitored by                      CSD015
      ** Compliance Watch by calling AOWLCCR0                                                 CSD015
      *                                                                                       CSD015
     C     CSD015        IFEQ      'Y'
      *                                                                                       CSD015
     C                   CALL      'AOWLCCR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      'MESSGENT'    PFUNC             8
     C     SDWLCC        PARM      SDWLCC        DSFDY
      *                                                                                       CSD015
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDWLCCPD'    DBFILE
     C                   MOVEL     '033'         DBASE
     C                   MOVEL     PFUNC         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSD015
     C                   ENDIF
      *                                                                                       CSD015
      ** Compliance Watch Hit List Key List                                                   CSD015
      *                                                                                       CSD015
     C     KWHTKY        KLIST
     C                   KFLD                    WFUNT             8
     C                   KFLD                    WIDEN            40
     C                   KFLD                    BRCA
      *                                                                                       CSD015
     C/COPY WNCPYSRC,ME0600C070
      **  Access SDMMODPD for active networks
     C     1             CHAIN     SDMMODPD                           97
      *
     C     *IN97         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'FIRST'       DBKEY                          * DB ERROR 02 *
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
      *
      **  Access RUNDAT to find run date & multibranching indicator
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C     *LOCK         IN        DSRUN
     C                   OUT       DSRUN
      *
      **  Set up texts
     C                   MOVE      TXT(1)        RCD1
     C                   MOVE      TXT(2)        RCD2
     C                   MOVEL     TXT(3)        RCD3
     C                   MOVEL     TXT(4)        RCD4
     C                   MOVEL     TXT(5)        RCD5
     C                   MOVEL     TXT(6)        RCD6
     C                   MOVE      TXT(7)        RCD7
     C                   MOVE      TXT(8)        RCD8
     C                   MOVE      TXT(9)        RCD9
     C                   MOVE      TXT(10)       RCD10
     C                   MOVE      TXT(11)       RCD11
     C                   MOVE      TXT(12)       RCD12
     C                   MOVE      TXT(21)       RCDME            78
     C                   MOVE      TXT(25)       RCDTK                                         06747
     C/COPY WNCPYSRC,ME0600C071
     C**********           MOVE *LOVAL    @#                                                  258797
     C                   MOVE      *LOVAL        @#                1
     C                   BITON     '123467'      @#
      *                                                                   CSW096
      **  Check if SWIFT Changes 1996 (CSW096) is installed               CSW096
      *                                                                   CSW096
     C                   CALL      'SWIFT96'                                                   CSW09
     C                   PARM      *BLANKS       @RTCD             7                           CSW09
      *                                                                   CSW096
     C     @RTCD         IFEQ      'CSW096'                                                    CSW09
     C                   MOVE      'Y'           CSW096            1                           CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVE      'N'           CSW096                                        CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                                       CSW218
      ** Check if Swift 2018 changes is installed.                                            CSW218
      *                                                                                       CSW218
     C                   CALL      'SWIF2018'
     C                   PARM                    PRTCD
     C     PRTCD         IFEQ      'CSW2018'
     C                   MOVEL     'Y'           CSW218            1
     C                   ELSE
     C                   MOVEL     'N'           CSW218
     C                   ENDIF
      *                                                                                       CSW218
     C     KBICD         KLIST
     C                   KFLD                    WBICC
     C                   KFLD                    WBICB
      *
      **  Clear subfile
     C                   SETOFF                                       2021
     C                   WRITE     ME0600F3
     C                   SETON                                        202122
     C/COPY WNCPYSRC,ME0600C052
     C                   Z-ADD     1             RRN               5 0
      **                                                                  121288
     C                   MOVE      'N'           FLD87             1                           12128
      *
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP8                                           S01408
     C*                                                                   S01408
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   HDNG - Write message headings                               *
      *   Called by main process                                      *
      *             - DELT delete message                             *
      *               AMND amend message                              *
      *               RELS release message                            *
      *   Calls - SWADDR format Name/Town from SWIFT address          *
      *           STADDR format Name/Town from STTX address           *
      *           TXADDR format Name/Town from TELEX address          *
      *           PAPER  clear Name/Town fields for paper messages    *
      *****************************************************************
      *
     C     HDNG          BEGSR
      *
     C/COPY WNCPYSRC,ME0600C081
     C                   MOVE      *BLANKS       RCD
      *                                                                   078455
      **  Only perform the Midas address processing if this is a Midas    078455
      **  message. If it is from an external system bypass this code      078455
      **  and set the addresses to blank.                                 078455
     C     SYTM          IFEQ      *BLANKS                                                     07845
      *
      **  Access Sender's customer details for non-SWIFT addresses
     C                   MOVE      SECN          @WK6              6
     C     @WK6          CHAIN     SDCUSTL0                           90
      *
     C     *IN90         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   MOVEL     SECN          DBKEY
     C                   MOVEL     'SDCUSTL0'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
      *
      **  Store Sender's non-SWIFT addresses
     C                   MOVEL     BBCRNM        SNAME            20
     C                   MOVEL     BBTXA1        STELX            10
     C                   MOVEL     BBSTAD        SSTTX            12
      *
      ** Access branch file for Sender's SWIFT TID
     C     @WK6          CHAIN     SDBRCHL5                           90
      *
     C     *IN90         IFEQ      '1'                                                     1
     C     *LOCK         IN        LDA
     C                   Z-ADD     9             DBASE
     C                   MOVEL     SECN          DBKEY
     C                   MOVEL     'SDBRCHL5'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E1
      *
      ** Store Sender's SWIFT TID
     C                   MOVEL     A8BTID        SSWFT            12
      *
      **  Access all available network addresses using current address
      **  non SWIFT, telex or STTX messages are accessed by customer
     C                   MOVEL     NWDS          ZADDR
     C                   MOVEL     DECN          ZCUST             8                           18358
     C                   EXSR      SRDEST
     C     NWRK          CASEQ     'SWIFT'       SWADDR                                    1
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP4                                           S01408
     C*                                                                   S01408
     C     NWRK          CASEQ     'STTX'        STADDR
     C     NWRK          CASEQ     'TELEX'       TXADDR
     C                   CAS                     PAPER
     C                   END                                                              E1
      *
      **  Store all Destination's network addresses
     C                   MOVEL     ZNAME         DNAME            20
     C                   MOVEL     ZTELX         DTELX            10
     C                   MOVEL     ZSTTX         DSTTX            12
      *                                                                                       CSW218
     C     CSW218        IFEQ      'N'
      *
      ** A 'BIC' code is not a valid SWIFT address - check BIC in DS
     C     BIC           IFNE      'BIC'
     C     CSW096        ANDEQ     'N'                                                         CSW09
     C     USID          ORNE      '1'                                                         CSW09
     C     CSW096        ANDEQ     'Y'                                                         CSW09
     C                   MOVEL     ZSWFT         DSWFT            12
     C                   ELSE
     C                   MOVEL     *BLANKS       DSWFT
     C                   END
      *                                                                                       CSW218
     C                   ELSE
      ** Check SWIFT address if connected to SWIFTNet FIN when CSW218 is ON                   CSW218
      *                                                                                       CSW218
     C                   MOVEL     *BLANKS       WSID19
     C     ZSWFT         IFNE      *BLANKS
     C                   MOVEL     ZSWFT         WBICC             8
     C     3             SUBST     ZSWFT:9       WBICB             3
     C     WBICB         IFEQ      *BLANKS
     C                   MOVEL     'XXX'         WBICB
     C                   ENDIF
      *                                                                                       CSW218
     C     KBICD         CHAIN     MEBICDL2                           89
     C     *IN89         IFEQ      '0'
     C     1             SUBST     BDXINF:19     WSID19            1
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW218
      ** BIC address indicates not connected if the                                           CSW218
      ** Extra Information field position 19 is set to 'N'                                    CSW218
      *                                                                                       CSW218
     C     WSID19        IFEQ      'N'
     C                   MOVE      *BLANKS       DSWFT
     C                   ELSE
     C                   MOVEL     ZSWFT         DSWFT
     C                   ENDIF
     C                   ENDIF
      *                                                                   078455
      ** for an external system......                                     078455
     C                   ELSE                                                                  07845
     C                   MOVE      *BLANKS       DNAME                                         07845
     C                   MOVE      *BLANKS       DTELX                                         07845
     C                   MOVE      *BLANKS       DSTTX                                         07845
     C                   END                                                                   07845
      *
      **  Write common headings
     C     MBIN          IFEQ      'Y'                                                         E3849
     C     RCBR          IFEQ      *BLANKS
     C                   MOVEL     @RCD1         RCD
     C                   ELSE
     C                   MOVE      RCD1          RCD
     C                   END
     C                   ELSE                                                                  E3849
     C                   MOVE      *BLANKS       RCD1                                          E3849
     C                   MOVE      *BLANKS       @RCD1                                         E3849
     C                   END                                                                   E3849
      *
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
      *
     C     MTPY          CHAIN     SDMTPYL0                           96
     C     *IN96         IFEQ      '1'                                                     1
     C                   MOVEL     TXT(15)       @TYP
     C                   ELSE                                                             X1
     C                   MOVEL     EEMTPD        @TYP
     C                   END                                                              E1
      *
     C                   MOVE      *BLANKS       @PDE
     C     MPDE          IFNE      *BLANKS                                                 1
     C                   MOVEL     TXT(14)       @PDE
     C                   END                                                              E1
      *
     C                   MOVE      RCD2          RCD
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
      *
     C     MM            LOOKUP    TABMM         TABMON                   50
     C                   MOVE      YY            @YY
     C                   MOVE      TABMON        @MM
     C                   MOVE      DD            @DD
     C                   MOVE      @DMY          @MGDE
      *
     C                   MOVE      RCD3          RCD
     C/COPY WNCPYSRC,ME0600C045
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
      *
     C     NWRK          IFNE      'PAPER'
     C                   MOVEL     ZNAME         @NAME
     C                   MOVEL     ZTOWN         @TOWN
     C                   ELSE
     C                   MOVEL     *BLANKS       @NAME
     C                   MOVEL     *BLANKS       @TOWN
     C                   END
      *
     C                   MOVE      RCD4          RCD
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
      *
     C     MGST          LOOKUP    TABCD         TABNAR                   51
     C     *IN51         IFEQ      '1'                                                     1
     C                   MOVEL     TABNAR        @DSC
     C                   ELSE                                                             X1
      *                                                                   S01408
     C/COPY WNCPYSRC,ME0600CP12                                           S01408
      *                                                                   S01408
     C                   MOVEL     *BLANKS       @DSC
     C                   MOVEL     MGST          @DSC
     C                   END                                                              E1
      *                                                                   S01408
     C/COPY WNCPYSRC,ME0600CP13                                           S01408
      *                                                                   S01408
     C                   MOVE      LATM          WRKLAT
     C                   MOVE      @WKHH         @@HH
     C                   MOVE      @WKMM         @@MM
     C                   MOVE      @WKSS         @@SS
      *
     C                   MOVE      RCD5          RCD
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
      *
      **  Write MIDAS generated single message headings
     C     SYTM          IFEQ      *BLANKS                                                 1
     C     TRNM          ANDEQ     *BLANKS
      *
      **  If not statement message output MIDAS details
     C     MTPY          IFNE      '950'
     C     MTPY          ANDNE     '940'                                                   2
      *
      **  If message input via ME, display appropriate heading
     C     MODI          IFEQ      'ME'                                                    3
     C     MODI          OREQ      'MX'                                                        E2958
     C                   MOVE      MODI          MEMOD                                         E2958
     C                   MOVEL     RCDME         RCD
     C                   ELSE                                                             X3
      *
      **  ...else message generated from MIDAS transaction, so display
      **  transaction details
     C                   MOVEL     RCD6          RCD
     C                   END                                                              E3
     C                   ELSE                                                             X2
      *
      **  ...else statement message, so output SWIFT a/c
     C                   MOVEL     MODI          @MODI
     C                   MOVEL     RCD7          RCD
     C                   END                                                              E2
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
     C                   END                                                              E1
      *
      **  Write external system message headings
     C     SYTM          IFNE      *BLANKS                                                 1
     C                   MOVEL     RCD8          RCD
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
     C                   END                                                              E1
      *
      **  Write SWIFT headings
     C     NWRK          IFEQ      'SWIFT'                                                 1
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CP10                                           S01408
     C*                                                                   S01408
     C     MPRY          IFEQ      'N'                                                     2
     C                   MOVE      'NORMAL'      @MPRY
     C                   ELSE                                                             X2
     C                   MOVE      'URGENT'      @MPRY
     C                   END                                                              E2
      *
     C                   MOVE      'N'           @DEL
     C                   MOVE      'N'           @NDL
      *
     C     DELC          IFEQ      '1'                                                     2
     C                   MOVE      'Y'           @NDL
     C                   END                                                              E2
     C     DELC          IFEQ      '2'                                                     2
     C                   MOVE      'Y'           @DEL
     C                   END                                                              E2
     C     DELC          IFEQ      '3'                                                     2
     C                   MOVE      'Y'           @DEL
     C                   MOVE      'Y'           @NDL
     C                   END                                                              E2
      *
      ** If ELIN does not contain numeric data it probably contains       E29588
      ** rubbish. output '---' instead                                    E29588
     C     ELIN          IFNE      *BLANKS                                                 2   E2958
     C                   TESTN                   ELIN                 75                       E2958
     C     *IN75         IFEQ      '0'                                                     3   E2958
     C                   MOVE      '---'         ELIN                                          E2958
     C                   END                                                              E3   E2958
     C                   END                                                              E2   E2958
      *                                                                   E29588
     C                   MOVE      *BLANKS       RCD
     C     MSE1          IFEQ      *BLANK
     C     ELIN          ANDEQ     *BLANK
     C                   MOVEL     @RCD9         RCD
     C                   ELSE
     C                   MOVEL     RCD9          RCD
     C                   END
      *
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
     C                   END                                                              E1
      *
      **  If unreleased telex message, output whether testkey is
      **  required
     C     NWRK          IFEQ      'TELEX'
     C***********@MGSG     ANDEQ'1'                                   1   067471
     C     @MGSG         IFEQ      '1'                                                     x   06747
     C                   MOVE      *BLANKS       TSKSN
     C     @TSKS         IFEQ      'Y'                                                     2
     C                   MOVEL     'Yes'         TSKSN
     C                   ELSE
     C                   MOVEL     'No'          TSKSN
     C                   END
     C                   MOVE      RCD10         RCD
     C                   WRITE     ME0600F2                                               E2
     C                   ADD       1             RRN
     C                   ELSE                                                             Xx   06747
     C     TSKY          IFNE      *BLANKS                                                 y   06747
     C                   MOVEL     TSKY          @TKY                                          06747
     C                   MOVEL     RCDTK         RCD                                           06747
     C                   WRITE     ME0600F2                                                    06747
     C                   ADD       1             RRN                                           06747
     C                   ENDIF                                                            Ey   06747
     C                   ENDIF                                                            Ex   06747
     C                   END                                                              E1
      *
      **  Write single message confirmation matching headings
     C     BGCFMT        IFEQ      'Y'                                                     1
     C     TRNM          ANDEQ     *BLANKS
     C/COPY WNCPYSRC,ME0600C001
      *
     C                   CALL      'ZM0100'
     C                   PARM      TRNO          ZTRN             16
     C                   PARM                    ZSCPMS            2 0
     C                   PARM                    ZSBKMS            2 0
     C                   PARM                    ZSERR             1
     C/COPY WNCPYSRC,ME0600C002
      *
     C     ZSERR         IFEQ      *BLANKS                                                 2
      *
      **  Obtain narrative for CF match status - if status not found
      **  output code only
     C     ZSCPMS        LOOKUP    TAB1          TAB2                     65
     C     *IN65         IFEQ      '1'
     C                   MOVEL     TAB2          CPYNAR
     C                   ELSE
     C                   MOVE      *BLANKS       CPYNAR
     C                   MOVEL     ZSCPMS        CPYNAR
     C                   END
     C     ZSBKMS        LOOKUP    TAB1          TAB2                     65
     C     *IN65         IFEQ      '1'
     C                   MOVEL     TAB2          BRKNAR
     C                   ELSE
     C                   MOVE      *BLANKS       BRKNAR
     C                   MOVEL     ZSBKMS        BRKNAR
     C                   END
      *
     C                   MOVE      RCD11         RCD
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
     C                   END                                                             E2
     C                   END                                                             E1
     C/COPY WNCPYSRC,ME0600C046
      *
      **  Write detail headings
     C                   MOVE      TXT(13)       RCD
     C                   ADD       1             RRN
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   TEXT - write message text                                   *
      *   Called by main process                                      *
      *             - DELT delete message                             *
      *               AMND amend message                              *
      *               RELS release message                            *
      *   Calls - FORM format subfield                                *
      *****************************************************************
      *
     C     TEXT          BEGSR
      *
     C                   MOVE      *BLANKS       RCD
      *
     C                   MOVE      *BLANKS       EFSCFD
     C                   MOVE      *BLANKS       EFTAGF
     C     MTAG          IFNE      *BLANKS                                                 1
     C                   MOVE      MTAG          @MTAG
      *
      **  If first line of multiple message part
     C     TRNF          IFNE      *BLANKS                                                 2
     C     TRNM          ORNE      *BLANKS
      *
      **  Field :20: (203) or :21: (210) marks the beginning of an
      **  an individual transaction in a multiple, so access message
      **  reference for transaction details
      **  Idem for field :23: in MT580.                                                       174844
     C     MTPY          IFEQ      '203'                                                   3
     C     MTAG          ANDEQ     ':20:'
     C     MTPY          OREQ      '210'
     C     MTAG          ANDEQ     ':21:'
     C     MTPY          OREQ      '580'
     C     MTAG          ANDEQ     ':23:'
     C/COPY WNCPYSRC,ME0600C025
      *
      **  Access message reference file using transaction reference
      **  of next part (210) or contents of :20: (203)
     C     MTPY          IFEQ      '210'
     C/COPY WNCPYSRC,ME0600C026
     C                   MOVEL     TRNM          @WK16            16
     C                   ELSE
     C/COPY WNCPYSRC,ME0600C078
     C                   MOVEL     MFLD          @WK16            16
     C/COPY WNCPYSRC,ME0600C079
     C                   END
     C/COPY WNCPYSRC,ME0600C027
      *                                                                                       174844
      ** For MT580, reaccess  GOREFPD with TRNO as first part of                              174844
      ** message is about to be processed (PHS=FIRST).                                        174844
     C     MTPY          IFEQ      '580'
     C     PHS           IFEQ      'FIRST'
     C                   MOVEL     TRNO          @WK16            16
     C                   MOVEL     *BLANKS       PHS
     C                   MOVEL     'NEXT'        PHS
      *                                                                                       174844
     C                   ELSE
      ** For next parts, TRNM must be used.                                                   174844
     C                   MOVEL     TRNM          @WK16            16
     C                   ENDIF
     C                   ENDIF
      *                                                                                       174844
     C     @WK16         CHAIN     MGOREFL0                           10
      *
     C     *IN10         IFEQ      '1'                                                     4
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE
     C                   MOVEL     @WK16         DBKEY                          * DB ERROR 06 *
     C                   MOVEL     'MGOREFPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E4
     C/COPY WNCPYSRC,ME0600C028
      *
     C                   MOVE      *BLANKS       @BLK
     C     BGCFMT        IFEQ      'Y'                                                     4
     C/COPY WNCPYSRC,ME0600C003
     C                   CALL      'ZM0100'
     C                   PARM      TRNO          ZTRN             16
     C                   PARM                    ZSCPMS            2 0
     C                   PARM                    ZSBKMS            2 0
     C                   PARM                    ZSERR             1
     C/COPY WNCPYSRC,ME0600C004
      *
     C     ZSERR         IFEQ      *BLANKS                                                 5
     C                   MOVEL     TXT(17)       @CPY
     C                   MOVE      ZSCPMS        @CFCPY
     C                   MOVEL     TXT(18)       @BRK
     C                   MOVE      ZSBKMS        @CFBRK
     C                   END                                                              E5
     C/COPY WNCPYSRC,ME0600C029
     C                   END                                                              E4
      *
      **  Write multiple message part headings
     C                   MOVE      *BLANKS       @DLT
     C     PTST          IFNE      *BLANKS                                                 4
     C                   MOVEL     TXT(16)       @DLT
     C                   END                                                              E4
      *
      **  For MT210, output TRN, instead of Midas transaction number      087654
     C     MTPY          IFEQ      '210'                                                       08765
     C                   MOVEL     TRNO          @MTRN                                         08765
     C                   ELSE                                                                  08765
     C                   MOVE      MTRN          @MTRN
     C                   END                                                                   08765
     C                   MOVE      TNTP          @TNTP
     C                   MOVE      SBTP          @SBTP
     C                   MOVE      MODI          @MODL
      *
     C                   MOVE      RCD12         RCD
     C                   ADD       1             RRN
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
     C                   END                                                              E3
     C/COPY WNCPYSRC,ME0600C030
     C                   END                                                              E2
      *
      **  Access field tag file using message tag & type then just tag
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
     C******IN98         IFEQ      '1'                                                     2MD056560
     C                   IF        SQLCODE = 100                                            MD056560
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
     C******IN98         IFEQ      '1'                                                     3MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     TXT(19)       EFSCFD
     C                   END                                                              E3
     C***********          END                                       E2   CSW098
     C** MT512 - Deliverer of Securities.                                 121288
     C******IN98         IFEQ      '0'                                                12128 MD056560
     C     SQLCODE       IFEQ      0                                                        MD056560
     C     MTPY          ANDEQ     '512'                                                       12128
     C     MTAG#         ANDEQ     '87'                                                        12128
     C     FLD87         IFEQ      'Y'                                                         12128
     C                   MOVEL     TXT(28)       EFSCFD                                        12128
     C                   ELSE                                                                  12128
     C                   MOVE      'Y'           FLD87                                         12128
     C                   END                                                                   12128
     C                   END                                                                   12128
     C**                                                                  121288
     C                   END                                                              E1
      *
      **  If verification field on unverified, unreleased message
     C/COPY WNCPYSRC,ME0600C031
     C                   eval      XFSCFD = EFSCFD                                          MD056560
     C                   MOVEL     MTPY          VERFYK            6
     C                   MOVE      @WK3          VERFYK
     C/COPY WNCPYSRC,ME0600C032
     C     VERFYK        LOOKUP    VERFY                                  52
      *
     C/COPY WNCPYSRC,ME0600C056
     C     ENVPM         IFEQ      'Y'                                                     1
     C/COPY WNCPYSRC,ME0600C059
     C     @MGSG         ANDEQ     '1'
     C     *IN52         ANDEQ     '1'
     C                   MOVEL     TXT(20)       MFLD
      *
      **  Call appropriate formatting subroutine
     C                   ELSE                                                             X1
     C     EFTAGF        IFNE      *BLANKS                                                 2
     C                   EXSR      FORM
      *
      **  If SWIFT address obtain name/town
     C                   ELSE                                                             X2
     C     @WK1          IFEQ      '5'                                                     3
     C     @WL1          ANDEQ     'A'
     C********** @WM1      ANDNE'/'                                       183583
     C     @WM1          ANDNE     '/'
     C     @MTAG         OREQ      ':50F:'
     C     @WK1          OREQ      '8'                                                     3   CSW09
     C     @WL1          ANDEQ     'A'                                                         CSW09
     C     @WK1          OREQ      '9'                                                         CSW09
     C     @WL1          ANDEQ     'P'                                                         CSW09
      *                                                                                       204225
     C                   MOVE      @WK3          WWK2              1
     C                   MOVE      '1'           *IN05
     C     @WK1          IFEQ      '5'                                                     3
     C     WWK2          ANDEQ     '0'
     C     @WL1          ANDEQ     'A'
     C********** @WK1      OREQ '5'                                                  CSW207 BUG14915
     C********** WWK2      ANDEQ'0'                                                  CSW207 BUG14915
     C********** @WL1      ANDEQ'F'                                                  CSW207 BUG14915
     C                   MOVEL     MFLD          WBEI             11
     C     WBEI          CHAIN     SDCUSTBE                           05
     C                   MOVE      *BLANKS       ZCUST
     C                   ENDIF
      *                                                                   S01435
      *  Format as SWIFT device print remove SWADDR processing            S01435
      *                                                                   S01435
     C     *IN05         IFEQ      '1'
     C                   EXSR      SEXTNR                                                      18358
     C                   ENDIF
     C*************        MOVELMFLD      ZADDR                           S01435
     C*************        EXSR SWADDR                                    S01435
     C*************        MOVELMFLD      @WK50  50                       S01435
     C*************        MOVE ZNAME     @WK50                           S01435
     C*************        MOVELZTOWN     @WK10  10                 042081S01435
     C*************        MOVE @WK10     @WK50                     042081S10435
     C*************        MOVEL@WK50     MFLD                            S01435
      *                                                                   S01435
      *  Information now displayed on lines after BIC as per SWIFT        S01435
      *  Standard                                                         S01435
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
      *  Call Access object to validate identifier                        S01435
      *                                                                   S01435
     C     @WL1          IFEQ      'P'                                                         CSW09
     C     8             SUBST     MFLD:8        W9BICC                                        CSW09
     C     3             SUBST     MFLD:16       W9BICB                                        CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEL     MFLD          W9BICC                                        S0143
     C     3             SUBST     MFLD:9        W9BICB                                        S0143
     C                   ENDIF                                                                 CSW09
      *                                                                   S01435
     C     @WK1          IFEQ      '5'                                                         18358
     C     @WL1          ANDEQ     'A'                                                         18358
     C********** @MTAG     OREQ ':50F:'                                              BUG14915 263130
     C     @WK1          OREQ      '8'                                                         18358
     C     @WL1          ANDEQ     'A'                                                         18358
     C     ZCUST         IFNE      *BLANKS                                                     15865
     C                   MOVE      *BLANKS       W9BICC                                        18358
     C                   MOVEL     ZCUST         W9BICC                                        18358
     C                   ENDIF                                                                 15865
     C                   ENDIF                                                                 18358
      *                                                                   183583
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
     C                   MOVEL     *BLANKS       RCD13                                         S0143
      *                                                                   S01435
     C                   SELECT                                                                S0143
      *                                                                   S01435
      *  Record not found - S.W.I.F.T does not exist                      S01435
      *                                                                   S01435
     C     W9RTN         WHENEQ    'Y2U0005'                                                   S0143
      * No action                                                         S01435
      *                                                                   S01435
     C                   GOTO      EXTEXT                                                      S0143
      *                                                                   S01435
      *  Use data depending on file that the data exists on               S01435
      *                                                                   S01435
     C     W9BICD        WHENEQ    'Y'                                                         S0143
      *                                                                   S01435
      * Format First Line for screen                                      S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C                   MOVEL     BDINS1        #SCR1                                         S0143
      *                                                                   S01435
      *  Check fields not concatenated                                    S01435
      *                                                                   S01435
     C     1             SUBST     BDINS2:1      ##001             1                           S0143
     C     ##001         IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BDINS2        #SCR2                                         S0143
     C                   ELSE                                                                  S0143
     C     15            SUBST     BDINS2:2      #SCR2                                         S0143
     C                   END                                                                   S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
      *                                                                   S01435
      * Format Second Line for screen                                     S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C                   MOVEL     BDCITY        #SCR1                                         S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
      *                                                                   S01435
      * Format Third Line for screen                                      S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BDBRC1        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BDBRC1        #SCR1                                         S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
     C                   GOTO      EXTEXT                                                      S0143
      *                                                                   S01435
     C     W9CUST        WHENEQ    'Y'                                                         S0143
      *                                                                   S01435
      * Format Customer Name and Town                                     S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BBCRNM        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BBCRNM        #SCR1                                         S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
     C                   END                                                                   S0143
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BBCRTN        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     BBCRTN        #SCR1                                         S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
     C                   GOTO      EXTEXT                                                      S0143
      *                                                                   S01435
     C     W9CNST        WHENEQ    'Y'                                                         S0143
      *                                                                   S01435
      * Format Counterparty Name and Town                                 S01435
      *                                                                   S01435
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     AWCPNM        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     AWCPNM        #SCR1                                         S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
     C                   END                                                                   S0143
     C                   MOVEL     *BLANKS       BICLAY                                        S0143
     C     BBCRNM        IFNE      *BLANKS                                                     S0143
     C                   MOVEL     AWCNTN        #SCR1                                         S0143
     C                   MOVEL     BICLAY        RCD13                                         S0143
      *                                                                   S01435
      *  Write screen line                                                S01435
      *                                                                   S01435
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   MOVE      RCD13         RCD                                           S0143
     C                   WRITE     ME0600F2                                                    S0143
     C                   ADD       1             RRN                                           S0143
      *                                                                   S01435
     C                   MOVEL     *BLANKS       RCD13                                         S0143
     C                   END                                                                   S0143
      *                                                                   S01435
     C                   GOTO      EXTEXT                                                      S0143
      *                                                                   S01435
     C                   ENDSL                                                                 S0143
     C                   END                                                             E3
     C                   END                                                             E2
     C                   END                                                             E1
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
     C     RCD13         IFNE      *BLANKS
     C                   MOVE      RCD13         RCD
     C                   WRITE     ME0600F2
     C                   ADD       1             RRN
     C                   ENDIF
      *
     C     EXTEXT        TAG                                                                   S0143
     C                   MOVE      *LOVAL        @#                                            S0143
     C                   BITON     '123467'      @#                                            S0143
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   DELT - delete message                                       *
      *   Called by - main process                                    *
      *   Calls - HDNG write message headings                         *
      *           TEXT write message text                             *
      *****************************************************************
      *
     C     DELT          BEGSR
      *
      **  Re access message reference file
     C     @TRNO         CHAIN     MGOREFD0                           10
      *
      **  If message status has changed..
     C     MGSG          IFNE      '1'                                                     1
     C                   MOVEL     'MEM1060'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3540
      *
      **  ..or TRN entered is not TRN of message or part of multiple
     C                   ELSE                                                             X1
     C*                                                                   087653
     C     MTPY          IFNE      '203'                                                       08765
     C     STRN          ORNE      *BLANKS                                                     08765
     C*                                                                   087653
     C     STRN          IFNE      @TRNO                                                   2
     C     STRN          CHAIN     MGOREFD0                           10
      *
     C     *IN10         IFEQ      '1'                                                     3
     C     TRNF          ORNE      @TRNO
     C     PTST          OREQ      'D'
     C                   MOVEL     'MEM1061'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3540
     C                   END                                                              E3
     C                   END                                                              E2
     C                   END                                                                   08765
     C                   END                                                              E1
     C*                                                                   087653
     C     MTPY          IFEQ      '203'                                                       08765
     C     STRN          ANDEQ     *BLANKS                                                     08765
     C                   MOVE      @TRNO         STRN                                          08765
     C                   MOVE      'M'           PERR              1                           08765
     C                   ELSE                                                                  08765
     C                   MOVE      *BLANKS       PERR                                          08765
     C                   END                                                                   08765
      *
      **  If no errors cancel message or part of multiple
     C***********          MOVELSTRN      PMOD                            093005
     C                   MOVE      MODI          PMOD                                          09300
     C     *IN35         IFEQ      '0'                                                     1
     C/COPY WNCPYSRC,ME0600C033
      *                                                                                       CSW201
      ** If Swift 2001 is installed and message type is '362', get                            CSW201
      ** the message to be cancelled' First transaction no. in MT362                          CSW201
      ** field found in MGHISTPD.                                                             CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     MTPY          ANDEQ     '362'
     C                   MOVEL     TRNO          WHREF
     C                   MOVE      MTPY          HSMTPY
     C     KHIST         CHAIN     MGHISTL3                           10
     C                   ENDIF
      *                                                                                       CSW201
     C                   CALL      'MG9205'                             15
     C                   PARM      STRN          PTRN             16
     C                   PARM                    PMOD              2
     C***********          PARM *BLANKS   PERR    1                       087653
     C                   PARM                    PERR                                          08765
     C/COPY WNCPYSRC,ME0600C034
     C                   END                                                              E1
      *
      ** If MG9205 not found , set up LDA and return to calling program
      *
     C     *IN15         IFEQ      '1'                                                     3
     C     *LOCK         IN        LDA
     C                   MOVE      '008'         DBASE
     C                   MOVEL     'MG9205 E'    KEY16
     C                   MOVE      'RROR    '    KEY16            16            * * * * * * * *
     C                   MOVEL     KEY16         DBKEY                          *  DBERR 008  *
     C                   MOVEL     *BLANKS       DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END                                                              E3
      *
      ** If database error in MG9205 return control to calling program
      *
     C     PERR          IFNE      *BLANKS                                                 3
     C     *LOCK         IN        LDA
     C                   EXSR      *PSSR
     C                   OUT       LDA
     C                   END                                                              E3
      *                                                                   115412
      *                                                                                       CSW201
      ** Delete all record in MGOREFPD that has the same first                                CSW201
      ** transaction number as the transaction being deleted if CSW201                        CSW201
      ** is installed and message type is '362'                                               CSW201
      *                                                                                       CSW201
     C     *IN35         IFEQ      '0'
     C     CSW201        IFEQ      'Y'
     C     MTPY          ANDEQ     '362'
     C                   MOVE      HSFTRN        KFTRN            16
      *                                                                                       CSW201
     C     KFTRN         SETLL     MGHISTL4
     C     KFTRN         READE     MGHISTL4                               10
      *                                                                                       CSW201
     C     *IN10         DOWEQ     *OFF
     C     KFTRN         ANDNE     *BLANKS
      *                                                                                       CSW201
     C                   MOVEL     WHREF         WTRNO            16
      *                                                                                       CSW201
     C     TRNO          IFNE      WTRNO
     C     WTRNO         CHAIN     MGOREFD0                           11
     C     *IN11         IFEQ      *OFF
     C                   CALL      'MG9205'                             15
     C                   PARM      TRNO          PTRN
     C                   PARM                    PMOD
     C                   PARM                    PERR
      *                                                                                       CSW201
      ** If MG9205 not found , set up LDA and return to calling program                       CSW201
      *                                                                                       CSW201
     C     *IN15         IFEQ      '1'
     C     PERR          ORNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE
     C                   MOVEL     TRNO          DBKEY
     C                   MOVEL     'MG9205'      DBPGM
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW201
     C     KFTRN         READE     MGHISTL4                               10
     C                   ENDDO
      *                                                                                       CSW201
     C                   ENDIF
     C                   ENDIF
      ** Only call MG5910 if message type is MT5xx                        115412
      *                                                                   115412
     C/COPY WNCPYSRC,ME0600C085
     C     MTPY          IFEQ      '580'                                                       11541
     C     MTPY          OREQ      '554'                                                       11541
     C     MTPY          OREQ      '523'                                                       11541
     C     MTPY          OREQ      '522'                                                       11541
     C     MTPY          OREQ      '521'                                                       11541
     C     MTPY          OREQ      '520'                                                       11541
     C     MTPY          OREQ      '512'                                                       11541
     C     MTPY          OREQ      '510'                                                       11541
     C     MTPY          OREQ      '515'                                                       CSW09
     C     MTPY          OREQ      '518'                                                       CSW09
      *                                                                   087779
      ** If SE msg and deleted successfully, call MG5910.                 087779
      *                                                                   087779
     C     *IN15         IFEQ      '0'                                                         08777
     C     PERR          ANDEQ     *BLANKS                                                     08777
     C     PMOD          ANDEQ     'SE'                                                        08777
      *                                                                   087779
      ** Initialise PRM1                                                  087779
      *                                                                   087779
     C                   MOVE      *BLANKS       PRM1             15                           08777
     C                   MOVEL     MTRN          PRM1                                          08777
     C                   MOVE      TNTP          PRM1                                          08777
      *                                                                   087779
      ** Initialise PRM2                                                  087779
      *                                                                   087779
     C     MTPY          IFEQ      '580'                                                       08777
     C     MTPY          OREQ      '554'                                                       08777
     C     MTPY          OREQ      '523'                                                       08777
     C     MTPY          OREQ      '522'                                                       08777
     C     MTPY          OREQ      '521'                                                       08777
     C     MTPY          OREQ      '520'                                                       08777
     C                   MOVE      'PR'          PRM2              2                           08777
     C                   ELSE                                                                  08777
     C                   MOVE      'CE'          PRM2                                          08777
     C                   END                                                                   08777
      *                                                                   087779
     C                   CALL      'MG5910'                             17                     08777
     C                   PARM      'SE'          PRM0              2                           08777
     C                   PARM                    PRM1                                          08777
     C                   PARM                    PRM2                                          08777
     C                   PARM      'C'           PRM3              1                           08777
     C                   PARM      *BLANKS       PRM4              1                           08777
     C                   PARM      *BLANKS       PRM5              1                           08777
     C                   PARM      *BLANKS       PRM6              1                           08777
     C                   PARM      CSW003        @MT5XX            1                           CSW00
      *                                                                   087779
     C     PRM6          IFEQ      'Y'                                                         08777
     C     *LOCK         IN        LDA                                                         08777
     C                   MOVE      '010'         DBASE                                         08777
     C                   MOVEL     PRM1          DBKEY                          * DB ERROR 10 *08777
     C                   MOVEL     'EXT FILE'    DBFILE                                        08777
     C                   OUT       LDA                                                         08777
     C                   EXSR      *PSSR                                                       08777
     C                   END                                                                   08777
      *                                                                   087779
     C                   END                                                                   08777
      *                                                                   115412
     C                   END                                                                   11541
     C/COPY WNCPYSRC,ME0600C082
      *
      **  Clear subfile
     C                   SETOFF                                       2021
     C                   WRITE     ME0600F3
     C                   SETON                                        202122
     C                   Z-ADD     1             RRN               5 0
      *
      **  Re access message reference file
     C     @TRNO         CHAIN     MGOREFD0                           10
     C                   MOVE      MGSG          @MGSG             1
     C                   MOVE      NWRK          @NWRK             6
     C                   MOVE      TSKS          @TSKS             1
      *
      **  Write message headings
     C                   EXSR      HDNG
      *
      **  Access message file using message reference
     C     @TRNO         CHAIN     MGOMSGPD                           11
      **  Initialise variable for first part of MT580.                                        174844
     C                   MOVEL     'FIRST'       PHS               5
      *                                                                                       174844
      *
     C/COPY WNCPYSRC,ME0600C035
      **  Process messages records with message reference
      *                                                                                       206803
     C     MTPY          IFEQ      '103'
     C     MTAG          ANDEQ     ':119:'
     C                   MOVE      'Y'           W#RSET
     C                   ELSE
     C                   MOVE      'N'           W#RSET
     C                   ENDIF
      *                                                                                       206803
     C                   Z-ADD     1             @V                                            18358
     C     *IN11         DOWEQ     '0'                                                     1
      *
      **  Write message text
     C                   EXSR      TEXT
      *
      **  Access next message file record with message reference
     C     @TRNO         READE     MGOMSGPD                               11
      *                                                                                       206803
     C     W#RSET        IFEQ      'Y'
     C                   Z-ADD     1             @V
     C                   MOVE      'N'           W#RSET
     C                   ELSE
     C                   ADD       1             @V                                            18358
     C                   ENDIF
      *                                                                                       206803
     C                   END                                                              E1
      *
     C                   ENDSR
     C/COPY WNCPYSRC,ME0600C062
     C/EJECT
      *****************************************************************
      *   AMND - amend message                                        *
      *   Called by - main process                                    *
      *   Calls - VALD validate amendment                             *
      *           HDNG write message headings                         *
      *           TEXT write message text                             *
      *****************************************************************
      *
     C     AMND          BEGSR
      *
      **  Re access message reference file
     C     @TRNO         CHAIN     MGOREFU0                           10
     C/COPY WNCPYSRC,ME0600C075
      *
      **  If message status has changed..
     C     MGSG          IFNE      '1'                                                     1
     C                   MOVEL     'MEM1062'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        35
      *
      **  Validate amendment entered
     C                   ELSE                                                             X1
     C                   EXSR      VALD
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C010
      *
      **  If no errors amend message
     C     *IN35         IFEQ      '0'                                                     1
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     MTPY          ANDEQ     '362'                                                       11541
     C                   MOVEL     TRNO          WHREF
     C                   MOVE      MTPY          HSMTPY
     C     KHIST         CHAIN     MGHISTL3                           10
     C                   ENDIF
      *
     C     SNWK          IFNE      *BLANKS                                                 2
     C                   MOVE      SNWK          NWRK
     C                   END                                                              E2
      *
     C     SPTY          IFNE      *BLANKS                                                 2
     C                   MOVE      SPTY          MPRY
     C                   END                                                              E2
      *
     C                   MOVE      'NN'          @DN
     C     DELC          IFEQ      '1'                                                     2
     C                   MOVE      'NY'          @DN
     C                   END                                                              E2
     C     DELC          IFEQ      '2'                                                     2
     C                   MOVE      'YN'          @DN
     C                   END                                                              E2
     C     DELC          IFEQ      '3'                                                     2
     C                   MOVE      'YY'          @DN
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C072
      *
     C     SDEL          IFNE      *BLANKS                                                 2
     C                   MOVE      SDEL          @D
     C                   END                                                              E2
     C     SNDL          IFNE      *BLANKS                                                 2
     C                   MOVE      SNDL          @N
     C                   END                                                              E2
      *
     C     @DN           IFEQ      'NN'                                                    2
     C                   MOVE      *BLANKS       DELC
     C                   END                                                              E2
     C     @DN           IFEQ      'NY'                                                    2
     C                   MOVE      '1'           DELC
     C                   END                                                              E2
     C     @DN           IFEQ      'YN'                                                    2
     C                   MOVE      '2'           DELC
     C                   END                                                              E2
     C     @DN           IFEQ      'YY'                                                    2
     C                   MOVE      '3'           DELC
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C073
      *                                                                   E29588
      **  Update last action date and time for this amendment             E29588
     C                   MOVE      RUNA          LADT                                          E2958
     C                   TIME                    LATM                                          E2958
      *
      **  Update status of PAPER message to PRTD to prevent amendment
     C     NWRK          IFEQ      'PAPER'                                                 2
     C                   MOVE      '2'           MGSG
     C                   MOVE      'RRTD'        MGST
     C******************** MOVE RUNA      LADT                            E29588
     C******************** TIME           LATM                            E29588
     C                   MOVE      RUNA          RELD
     C                   MOVE      LATM          RELT
     C                   MOVE      USRID         RUSR
     C                   MOVE      WSID          RWSN
     C                   ELSE                                                             X2   E2958
      *                                                                   E29588
      **  If not routed to paper, change status to AMENDED                E29588
     C/COPY WNCPYSRC,ME0600C047
     C                   MOVE      'AMND'        MGST                                          E2958
     C/COPY WNCPYSRC,ME0600C048
     C                   END                                                              E2
      *
     C                   UPDATE    MGOREFU0
      *
      **  Submit PAPER message print via RCF
     C     NWRK          IFEQ      'PAPER'                                                 2
     C                   CALL      'MEC0846R'
     C                   PARM                    TRNO
     C                   PARM                    BRCA
     C                   PARM                    MBIN
     C                   END                                                              E2
      *                                                                                       CSW201
      ** Amend all record in MGOREFPD that has the same first                                 CSW201
      ** transaction number as the transaction being deleted if CSW201                        CSW201
      ** is installed and message type is '362'                                               CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     MTPY          ANDEQ     '362'
     C                   MOVE      HSFTRN        KFTRN            16
      *                                                                                       CSW201
     C     KFTRN         SETLL     MGHISTL4
     C     KFTRN         READE     MGHISTL4                               10
      *                                                                                       CSW201
     C     *IN10         DOWEQ     *OFF
     C     KFTRN         ANDNE     *BLANKS
      *                                                                                       CSW201
     C                   MOVEL     WHREF         WTRNO
      *                                                                                       CSW201
     C     TRNO          IFNE      WTRNO
     C     WTRNO         CHAIN     MGOREFU0                           11
     C     *IN11         IFEQ      *OFF
      *                                                                                       CSW201
     C     SNWK          IFNE      *BLANKS
     C                   MOVE      SNWK          NWRK
     C                   ENDIF
      *                                                                                       CSW201
     C     SPTY          IFNE      *BLANKS
     C                   MOVE      SPTY          MPRY
     C                   ENDIF
      *                                                                                       CSW201
     C                   MOVE      'NN'          @DN
      *                                                                                       CSW201
     C                   SELECT
     C     DELC          WHENEQ    '1'
     C                   MOVE      'NY'          @DN
     C     DELC          WHENEQ    '2'
     C                   MOVE      'YN'          @DN
     C     DELC          WHENEQ    '3'
     C                   MOVE      'YY'          @DN
     C                   ENDSL
      *                                                                                       CSW201
     C     SDEL          IFNE      *BLANKS
     C                   MOVE      SDEL          @D
     C                   ENDIF
      *                                                                                       CSW201
     C     SNDL          IFNE      *BLANKS
     C                   MOVE      SNDL          @N
     C                   ENDIF
      *                                                                                       CSW201
     C                   SELECT
     C     @DN           WHENEQ    'NN'
     C                   MOVE      *BLANKS       DELC
     C     @DN           WHENEQ    'NY'
     C                   MOVE      '1'           DELC
     C     @DN           WHENEQ    'YN'
     C                   MOVE      '2'           DELC
     C     @DN           WHENEQ    'YY'
     C                   MOVE      '3'           DELC
     C                   ENDSL
      *                                                                                       CSW201
      **  Update last action date and time for this amendment                                 CSW201
      *                                                                                       CSW201
     C                   MOVE      RUNA          LADT
     C                   TIME                    LATM
      *                                                                                       CSW201
      **  Update status of PAPER message to PRTD to prevent amendment                         CSW201
      *                                                                                       CSW201
     C     NWRK          IFEQ      'PAPER'
     C                   MOVE      '2'           MGSG
     C                   MOVE      'RRTD'        MGST
     C                   MOVE      RUNA          RELD
     C                   MOVE      LATM          RELT
     C                   MOVE      USRID         RUSR
     C                   MOVE      WSID          RWSN
     C                   ELSE
      *                                                                                       CSW201
      **  If not routed to paper, change status to AMENDED                                    CSW201
      *                                                                                       CSW201
     C                   MOVE      'AMND'        MGST
     C                   ENDIF
      *                                                                                       CSW201
     C                   UPDATE    MGOREFU0
      *                                                                                       CSW201
      **  Submit PAPER message print via RCF                                                  CSW201
      *                                                                                       CSW201
     C     NWRK          IFEQ      'PAPER'
     C                   CALL      'MEC0846R'
     C                   PARM                    TRNO
     C                   PARM                    BRCA
     C                   PARM                    MBIN
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     KFTRN         READE     MGHISTL4                               10
     C                   ENDDO
      *                                                                                       CSW201
     C                   ENDIF
      *
     C                   ELSE                                                             X1
     C                   EXCEPT
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C011
      *
      **  Clear subfile
     C                   SETOFF                                       2021
     C                   WRITE     ME0600F3
     C                   SETON                                        202122
     C                   Z-ADD     1             RRN               5 0
     C                   MOVE      MGSG          @MGSG             1
     C                   MOVE      NWRK          @NWRK             6
     C                   MOVE      TSKS          @TSKS             1
      *
      **  Write message headings
     C                   EXSR      HDNG
      *
      **  Access message file using message reference
     C     @TRNO         CHAIN     MGOMSGPD                           11
     C/COPY WNCPYSRC,ME0600C036
      *
      **  Process messages records with message reference
      *                                                                                       206803
     C     MTPY          IFEQ      '103'
     C     MTAG          ANDEQ     ':119:'
     C                   MOVE      'Y'           W#RSET            1
     C                   ELSE
     C                   MOVE      'N'           W#RSET
     C                   ENDIF
      *                                                                                       206803
     C                   Z-ADD     1             @V                                            18358
     C     *IN11         DOWEQ     '0'                                                     1
      *
      **  Write message text
     C                   EXSR      TEXT
      *
      **  Access next message file record with message reference
     C     @TRNO         READE     MGOMSGPD                               11
      *                                                                                       206803
     C     W#RSET        IFEQ      'Y'
     C                   Z-ADD     1             @V
     C                   MOVE      'N'           W#RSET
     C                   ELSE
     C                   ADD       1             @V                                            18358
     C                   ENDIF
      *                                                                                       206803
     C                   END                                                              E1
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   RELS - release message                                      *
      *   Called by - main process                                    *
      *   Calls - HDNG write message headings                         *
      *           TEXT write message text                             *
      *****************************************************************
      *
     C     RELS          BEGSR
      *
      **  Re access message reference file
     C***********@TRNO     CHAINMGOREFU0             10                   CTK001
     C     @TRNO         CHAIN     MGOREFU0                           1013                     CTK00
     C/COPY WNCPYSRC,ME0600C080
      *                                                                   CTK001
      **  If record is now locked                                         CTK001
     C     *IN13         IFEQ      '1'                                                     1   CTK00
     C                   MOVEL     TXT(27)       @MSDTA                                        CTK00
     C                   CALL      'ZM1001'      PLIST3                                        CTK00
     C                   MOVE      *BLANKS       @MSDTA                                        CTK00
     C                   SETON                                        3545                     CTK00
     C                   ELSE                                                                  CTK00
      *                                                                                       CSD015
      ** If Midas Compliance Watch is active and watch list                                   CSD015
      ** checking applied, check trade if pending investigation                               CSD015
      *                                                                                       CSD015
     C     W1EWLC        IFEQ      'Y'
      *                                                                                       CSD015
      ** Check if message type exists in the watch list                                       CSD015
      *                                                                                       CSD015
     C                   CALL      'AOWLMTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*MTYP'       POPTN             7
     C                   PARM      MTPY          PMTYP             3
     C                   PARM      *BLANKS       PMTAG            50
      *                                                                                       CSD015
      ** If Message Type exists, Execute SRWTCH subroutine                                    CSD015
      *                                                                                       CSD015
     C     PRTCD         IFEQ      *BLANKS
      *                                                                                       CSD015
     C                   MOVE      'MGOREF  '    WFUNT
     C                   MOVE      *BLANK        WIDEN
     C                   MOVEL     TRNO          WIDEN
      *                                                                                       CSD015
     C     KWHTKY        CHAIN     SDCWHTL1                           32
      *                                                                                       CSD015
      ** If record found and under investigation, display error                               CSD015
      ** message 'Item under review by Compliance Officer'                                    CSD015
      *                                                                                       CSD015
     C     *IN32         IFEQ      *OFF
     C     W3TREL        ANDNE     'Y'
     C                   MOVEL     'MEM9933'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   MOVE      *ON           *IN35
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSD015
     C                   ENDIF
      *
      **  If message status has changed..
     C     MGSG          IFNE      '1'                                                     1
     C                   MOVEL     'MEM1071'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        35
      *
      **  ..or verifiction is on and
     C                   ELSE                                                             X1
     C     ENVPM         IFEQ      'Y'                                                     2
     C/COPY WNCPYSRC,ME0600C057
     C     MTPY          IFEQ      '100'                                                   3
     C     MTPY          OREQ      '202'
     C     MTPY          OREQ      '203'
     C     MTPY          OREQ      '200'                                                       09807
     C     MTPY          OREQ      '103'
     C/COPY WNCPYSRC,ME0600C077
      *
      **  value date entered is not date of message
     C     SDAT          IFNE      SVDT                                                    4
     C                   SETON                                        3545
     C                   END                                                              E4
      *
      **  currency entered is not currency of message
     C     SCCY          IFNE      CCY                                                     4
     C                   SETON                                        3545
     C                   END                                                              E4
      *
      **  amount entered is not amount of message or total of multiple
     C     TRNM          IFEQ      *BLANKS                                                 4
     C     SAMT          ANDNE     AMTS
     C                   SETON                                        3545
     C                   END                                                              E4
      *
     C     TRNM          IFNE      *BLANKS                                                 4
     C     SAMT          ANDNE     AMTX
     C                   SETON                                        3545
     C                   END                                                              E4
      *
      **  If user has entered an incorrect verification field issue
      **  error message
     C     *IN45         IFEQ      '1'                                                     4
     C                   MOVEL     'MEM1072'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   END                                                              E4
     C                   END                                                              E3
     C/COPY WNCPYSRC,ME0600C084
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C037
      *
      **  Testkey can only be added to Telex payment message
     C     NWRK          IFNE      'TELEX'                                                 2
     C     TSKS          ANDNE     'Y'
     C     STKY          ANDNE     *BLANKS
     C                   MOVEL     'MEM1073'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3546
     C                   END                                                              E2
      *
      **  Testkey must be added to telex payment message
     C     NWRK          IFEQ      'TELEX'                                                 2
     C     TSKS          ANDEQ     'Y'
     C     STKY          ANDEQ     *BLANKS
     C/COPY WNCPYSRC,ME0600C049
     C                   MOVEL     'MEM1074'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3546
     C                   END                                                              E2
      *
      **  If GEN entered generate testkey using testkey package
     C     STKY          IFEQ      'GEN'                                                   2
     C                   EXSR      TKEY
     C                   END                                                              E2
     C/COPY WNCPYSRC,ME0600C038
     C                   END                                                              E1
     C                   ENDIF                                                                 CTK00
      *
      **  If no errors release message
     C     *IN35         IFEQ      '0'                                                     1
      *                                                                                       CSW201
      ** If Swift 2001 is installed and message type is '362', get                            CSW201
      ** the message to be releaed' First transaction no. in MT362                            CSW201
      ** field found in MGHISTPD.                                                             CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     MTPY          ANDEQ     '362'                                                       11541
     C                   MOVEL     TRNO          WHREF
     C                   MOVE      MTPY          HSMTPY
     C     KHIST         CHAIN     MGHISTL3                           10
     C                   ENDIF
      *
     C     STKY          IFNE      *BLANKS                                                 2
     C     *DTAARA       DEFINE    MTSTAT        DSSTAT
     C     *LOCK         IN        DSSTAT
     C                   ADD       1             SEQ
     C                   OUT       DSSTAT
     C                   MOVE      STKY          TSKY
     C                   MOVE      SEQ           TSEQ
     C                   END                                                              E2
      *
     C/COPY WNCPYSRC,ME0600C058
     C                   MOVE      '2'           MGSG
     C                   MOVE      'RSND'        MGST
     C/COPY WNCPYSRC,ME0600C053
     C                   MOVE      RUNA          LADT
     C                   TIME                    LATM
     C                   MOVE      RUNA          RELD
     C                   MOVE      LATM          RELT
     C                   MOVE      USRID         RUSR
     C                   MOVE      WSID          RWSN
     C/COPY WNCPYSRC,ME0600C050
      *
     C                   UPDATE    MGOREFU0
     C/COPY WNCPYSRC,ME0600C005
      *                                                                                       CSW201
      ** Release all records in MGOREFPD that has the same first                              CSW201
      ** transaction number being released if CSW201 is on and                                CSW201
      ** message type is '362'                                                                CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'
     C     MTPY          ANDEQ     '362'
     C                   MOVE      HSFTRN        KFTRN            16
      *                                                                                       CSW201
     C     KFTRN         SETLL     MGHISTL4
     C     KFTRN         READE     MGHISTL4                               10
      *                                                                                       CSW201
     C     *IN10         DOWEQ     *OFF
     C     KFTRN         ANDNE     *BLANKS
      *                                                                                       CSW201
     C                   MOVEL     WHREF         WTRNO
      *                                                                                       CSW201
     C     TRNO          IFNE      WTRNO
     C     WTRNO         CHAIN     MGOREFU0                           11
     C     *IN11         IFEQ      *OFF
      *                                                                                       CSW201
     C     STKY          IFNE      *BLANKS
     C     *LOCK         IN        DSSTAT
     C                   ADD       1             SEQ
     C                   OUT       DSSTAT
     C                   MOVE      STKY          TSKY
     C                   MOVE      SEQ           TSEQ
     C                   ENDIF
      *                                                                                       CSW201
     C                   MOVE      '2'           MGSG
     C                   MOVE      'RSND'        MGST
     C                   MOVE      RUNA          LADT
     C                   TIME                    LATM
     C                   MOVE      RUNA          RELD
     C                   MOVE      LATM          RELT
     C                   MOVE      USRID         RUSR
     C                   MOVE      WSID          RWSN
      *                                                                                       CSW201
     C                   UPDATE    MGOREFU0
      *                                                                                       CSW201
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSW201
     C     KFTRN         READE     MGHISTL4                               10
     C                   ENDDO
      *                                                                                       CSW201
     C                   ENDIF
      *
     C                   ELSE                                                             X1
     C**********           EXCPT                                          CTK001
     C                   UNLOCK    MGOREFLU                                                    CTK00
     C                   END                                                              E1
      *
      **  Clear subfile
     C                   SETOFF                                       2021
     C                   WRITE     ME0600F3
     C                   SETON                                        202122
     C                   Z-ADD     1             RRN               5 0
     C                   MOVE      MGSG          @MGSG             1
     C                   MOVE      NWRK          @NWRK             6
     C                   MOVE      TSKS          @TSKS             1
      *
      **  Write message headings
     C                   EXSR      HDNG
      *
      **  Access message file using message reference
     C     @TRNO         CHAIN     MGOMSGPD                           11
      *                                                                                       174844
      **  Initialise variable for first part of MT580.                                        174844
     C                   MOVEL     'FIRST'       PHS               5
      *                                                                                       174844
     C/COPY WNCPYSRC,ME0600C039
      *
      **  Process messages records with message reference
      *                                                                                       206803
     C     MTPY          IFEQ      '103'
     C     MTAG          ANDEQ     ':119:'
     C                   MOVE      'Y'           W#RSET            1
     C                   ELSE
     C                   MOVE      'N'           W#RSET
     C                   ENDIF
      *                                                                                       206803
     C                   Z-ADD     1             @V                                            18358
     C     *IN11         DOWEQ     '0'                                                     1
      *
      **  Write message text
     C                   EXSR      TEXT
      *
      **  Access next message file record with message reference
     C     @TRNO         READE     MGOMSGPD                               11
      *                                                                                       206803
     C     W#RSET        IFEQ      'Y'
     C                   Z-ADD     1             @V
     C                   MOVE      'N'           W#RSET
     C                   ELSE
     C                   ADD       1             @V                                            18358
     C                   ENDIF
      *                                                                                       206803
     C                   END                                                              E1
      *
     C                   ENDSR
      /EJECT                                                              183583
      *****************************************************************   183583
      *                                                               *   183583
      *   SEXTNR - Reads MGOEXTPD to get the SWIFT ID's cust. no.     *   183583
      *                                                               *   183583
      *   Called by: TEXT                                             *   183583
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
     C/COPY WNCPYSRC,ME0600C040
      *****************************************************************
      *   SWADDR - Format Name/Town from SWIFT address and get other  *
      *            Network adresses for this SWIFT address            *
      *   Called by - HDNG, VALD                                      *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN, Customer/Counterparty town, 35A    *
      *                     ZSWFT  Address for SWIFT                  *
      *                     ZTELX  Address for TELEX                  *
      *                     ZSTTX  Address for STTX                   *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     SWADDR        BEGSR
      *
      **  Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
     C                   MOVE      *BLANKS       ZSWFT            12
     C                   MOVE      *BLANKS       ZTELX            10
     C                   MOVE      *BLANKS       ZSTTX            12
      *
      **  Move standard address to SWIFT address key
     C                   MOVEL     ZADDR         SFWAD            12
      *
      **  First try customer file, SDCUST
     C     SFWAD         CHAIN     SDCUSTSW                           90
      *                                                                   183583
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     BBCUST        ANDNE     ZCUST                                                       18358
     C     SFWAD         READE     SDCUSTSW                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
      *                                                                   183583
     C     *IN90         IFEQ      '0'                                                     1
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   MOVEL     BBCSID        ZSWFT
     C                   MOVEL     BBTXA1        ZTELX
     C                   MOVEL     BBSTAD        ZSTTX
     C                   ELSE                                                             X1
      *
      **  If not found on customer file, try C/Party Nostro file SDCNST
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
      *                                                                   183583
     C     *IN90         IFEQ      '0'                                                     2
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   MOVEL     AWSWID        ZSWFT
     C                   MOVEL     AWTXA1        ZTELX
     C                   MOVEL     AWSTAD        ZSTTX
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
      *                                                                   107503
     C                   END                                                              E2
     C                   END                                                              E1
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   STADDR - Format Name/Town from STTX address get other       *
      *            Network addresses for this STTX address            *
      *   Called by - HDNG, VALD                                      *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN  Customer/Counterparty town, 35A    *
      *                     ZSWFT  Address for SWIFT                  *
      *                     ZTELX  Address for TELEX                  *
      *                     ZSTTX  Address for STTX                   *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     STADDR        BEGSR
      *
      **  Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
     C                   MOVE      *BLANKS       ZSWFT            12
     C                   MOVE      *BLANKS       ZTELX            10
     C                   MOVE      *BLANKS       ZSTTX            12
      *
      **  Move standard address to STTX address key
     C                   MOVEL     ZADDR         STXAD            12
      *
      **  First try customer file, SDCUST
     C     STXAD         CHAIN     SDCUSTST                           90
      *                                                                   183583
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     BBCUST        ANDNE     ZCUST                                                       18358
     C     STXAD         READE     SDCUSTST                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
      *                                                                   183583
     C     *IN90         IFEQ      '0'                                                     1
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   MOVEL     BBCSID        ZSWFT
     C                   MOVEL     BBTXA1        ZTELX
     C                   MOVEL     BBSTAD        ZSTTX
     C                   ELSE                                                             X1
      *
      **  If not found on customer file, try C/Party Nostro file SDCNST
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
      *                                                                   183583
     C     *IN90         IFEQ      '0'                                                     2
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   MOVEL     AWSWID        ZSWFT
     C                   MOVEL     AWTXA1        ZTELX
     C                   MOVEL     AWSTAD        ZSTTX
     C                   END                                                              E2
     C                   END                                                              E1
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   TXADDR - Format Name/Town from TELEX address and get other  *
      *            Network addresses for this TELEX address           *
      *   Called by - HDNG, VALD                                      *
      *   Standard input -  ZADDR, Address, 20A                       *
      *   Standard output - ZNAME, Customer/Countreparty name, 35A    *
      *                     ZTOWN  Customer/Counterparty town, 35A    *
      *                     ZSWFT  Address for SWIFT                  *
      *                     ZTELX  Address for TELEX                  *
      *                     ZSTTX  Address for STTX                   *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     TXADDR        BEGSR
      *
      **  Define standard fields
     C                   MOVE      ZADDR         ZADDR            20
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZTOWN            20
     C                   MOVE      *BLANKS       ZSWFT            12
     C                   MOVE      *BLANKS       ZTELX            10
     C                   MOVE      *BLANKS       ZSTTX            12
      *
      **  Move standard address to TELEX address key
     C                   MOVEL     ZADDR         TLXAD            10
      *
      **  First try customer file, SDCUST
     C     TLXAD         CHAIN     SDCUSTTX                           90
      *                                                                   183583
     C     ZCUST         IFNE      *BLANKS                                                     18358
     C     *IN90         DOWEQ     '0'                                                         18358
     C     BBCUST        ANDNE     ZCUST                                                       18358
     C     TLXAD         READE     SDCUSTTX                               90                   18358
     C                   ENDDO                                                                 18358
     C                   ENDIF                                                                 18358
      *                                                                   183583
     C     *IN90         IFEQ      '0'                                                     1
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCRTN        ZTOWN
     C                   MOVEL     BBCSID        ZSWFT
     C                   MOVEL     BBTXA1        ZTELX
     C                   MOVEL     BBSTAD        ZSTTX
     C                   ELSE                                                             X1
      *
      **  If not found on customer file, try C/Party Nostro file SDCNST
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
      *                                                                   183583
     C     *IN90         IFEQ      '0'                                                     2
     C                   MOVEL     AWCPNM        ZNAME
     C                   MOVEL     AWCNTN        ZTOWN
     C                   MOVEL     AWSWID        ZSWFT
     C                   MOVEL     AWTXA1        ZTELX
     C                   MOVEL     AWSTAD        ZSTTX
     C                   END                                                              E2
     C                   END                                                              E1
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   PAPER - If current network is paper, access destination by  *
      *           customer number, because no single, unique entry in *
      *           network address can be used to acccess party.       *
      *   Called by - VALD                                            *
      *   Standard output - ZNAME  Address for PAPER                  *
      *                     ZSWFT  Address for SWIFT                  *
      *                     ZTELX  Address for TELEX                  *
      *                     ZSTTX  Address for STTX                   *
      *                     *IN90 If ON implies no record found       *
      *****************************************************************
      *
     C     PAPER         BEGSR
      *
      **  Define standard fields
     C                   MOVE      *BLANKS       ZNAME            35
     C                   MOVE      *BLANKS       ZSWFT            12
     C                   MOVE      *BLANKS       ZTELX            10
     C                   MOVE      *BLANKS       ZSTTX            12
     C/COPY WNCPYSRC,ME0600C012
      *
     C                   MOVE      DECN          @WK6              6
     C     @WK6          CHAIN     SDCUSTL0                           90
     C     *IN90         IFEQ      '0'                                                     1
     C                   MOVEL     BBCRNM        ZNAME
     C                   MOVEL     BBCSID        ZSWFT
     C                   MOVEL     BBTXA1        ZTELX
     C                   MOVEL     BBSTAD        ZSTTX
     C/COPY WNCPYSRC,ME0600C013
     C                   END                                                              E1
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   FORM  - Format subfield                                     *
      *   Called by - TEXT write message text                         *
      *****************************************************************
      *
     C     FORM          BEGSR
      *
      ** Check for defined qualifiers, issuer codes or type in the form   CSW098
      **  MFLD = ':QUAL/ISSUERCD/TYPE/data' whereby formatting should     CSW098
      ** only be done on the data.                                        CSW098
      *                                                                   CSW098
     C                   MOVEA     *BLANKS       FLA                                           CSW09
     C                   MOVE      *BLANKS       WMFLD            50                           CSW09
     C                   MOVE      *BLANKS       WFLA             50                           CSW09
     C                   MOVE      *BLANKS       WFLB             50                           CSW09
      *                                                                   CSW098
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
     C                   MOVEA     WFLA          FLA                                           CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C                   ELSE                                                                  CSW09
      *                                                                   CSW098
     C                   MOVEA     MFLD          FLA
      *                                                                   CSW098
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW098
     C                   MOVE      *BLANKS       FLB
     C                   Z-ADD     1             A                 2 0
     C     ','           LOOKUP    FLA(A)                                 53
     C     *IN53         IFEQ      '1'                                                     1
     C                   MOVE      '.'           FLA(A)
     C                   END                                                              E1
      *
     C     EFTAGF        IFEQ      'DCA'                                                   1
     C     EFTAGF        OREQ      'DT'                                                        CSW09
     C     EFTAGF        OREQ      'D'
     C     DIGITS        CHECK     FLA(7)                                 47                   CSW09
      *                                                                   CSW097
      ** The seventh character is not numeric.                            CSW097
      *                                                                   CSW097
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLA(1)        @WK2              2
     C                   MOVEA     @WK2          FLB(1)
     C                   MOVE      '/'           FLB(3)
     C                   MOVEA     FLA(3)        @WK2
     C                   MOVEA     @WK2          FLB(4)
     C                   MOVE      '/'           FLB(6)
     C                   MOVEA     FLA(5)        @WK2
     C                   MOVEA     @WK2          FLB(7)
      *
     C                   MOVEA     FLB(1)        WRKDAT
     C                   MOVE      WRKYY         CHGYY
     C                   ELSE                                                                  CSW09
      *                                                                   CSW097
      ** It is numeric, therefore the date is in CCYYMMDD format.         CSW097
      *                                                                   CSW097
     C                   MOVEA     FLA(1)        @WK4              4                           CSW09
     C                   MOVEA     @WK4          FLB(1)                                        CSW09
     C                   MOVE      '/'           FLB(5)                                        CSW09
     C                   MOVEA     FLA(5)        @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(6)                                        CSW09
     C                   MOVE      '/'           FLB(8)                                        CSW09
     C                   MOVEA     FLA(7)        @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(9)                                        CSW09
      *                                                                   CSW097
     C                   MOVEA     FLB(1)        WKDAT                                         CSW09
     C                   MOVE      WKYY          CHYY                                          CSW09
     C                   ENDIF                                                                 CSW09
      *
     C     DATF          IFEQ      'M'
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEL     WRKMM         @CHG5
     C                   MOVE      WRKDD         @CHG5
     C                   ELSE                                                                  CSW09
     C                   MOVEL     WKMM          @CH5                                          CSW09
     C                   MOVE      WKDD          @CH5                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   ELSE
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVE      WRKMM         @CHG5
     C                   MOVEL     WRKDD         @CHG5
     C                   ELSE                                                                  CSW09
     C                   MOVE      WKMM          @CH5                                          CSW09
     C                   MOVEL     WKDD          @CH5                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   END
      *
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     CHGDAT        FLB(1)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     CHDAT         FLB(1)                                        CSW09
     C                   ENDIF                                                                 CSW09
      *
     C                   END                                                              E1
      *
     C     EFTAGF        IFEQ      'DCA'                                                   1
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLA(7)        @WL3              3
     C                   MOVEA     @WL3          FLB(10)
     C                   MOVEA     FLA(10)       @WK15            15
     C/COPY WNCPYSRC,ME0600C086
     C                   MOVEA     @WK15         FLB(14)
     C/COPY WNCPYSRC,ME0600C087
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLA(9)        @WL3                                          CSW09
     C                   MOVEA     @WL3          FLB(12)                                       CSW09
     C                   MOVEA     FLA(12)       @WK15                                         CSW09
     C/COPY WNCPYSRC,ME0600C088
     C                   MOVEA     @WK15         FLB(16)                                       CSW09
     C/COPY WNCPYSRC,ME0600C089
     C                   ENDIF                                                                 CSW09
     C                   END                                                              E1
     C*                                                                   CSW098
     C     EFTAGF        IFEQ      'DT'                                                    1   CSW09
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLA(7)        @WL2              2                           CSW09
     C                   MOVEA     @WL2          FLB(10)                                       CSW09
     C                   MOVE      ':'           FLB(12)                                       CSW09
     C                   MOVEA     FLA(9)        @WL2                                          CSW09
     C                   MOVEA     @WL2          FLB(13)                                       CSW09
     C                   MOVE      ':'           FLB(15)                                       CSW09
     C                   MOVEA     FLA(11)       @WL2                                          CSW09
     C                   MOVEA     @WL2          FLB(16)                                       CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLA(9)        @WL2                                          CSW09
     C                   MOVEA     @WL2          FLB(12)                                       CSW09
     C                   MOVE      ':'           FLB(14)                                       CSW09
     C                   MOVEA     FLA(11)       @WL2                                          CSW09
     C                   MOVEA     @WL2          FLB(15)                                       CSW09
     C                   MOVE      ':'           FLB(17)                                       CSW09
     C                   MOVEA     FLA(13)       @WL2                                          CSW09
     C                   MOVEA     @WL2          FLB(18)                                       CSW09
     C                   ENDIF                                                                 CSW09
     C                   END                                                              E1   CSW09
      *
     C     EFTAGF        IFEQ      'CA'                                                    1
     C                   MOVEA     FLA(1)        @WM1              1
     C     DIGITS        CHECK     FLA(4)                                 47
      *                                                                                       186181
      ** If field starts with 'N', could be that the 'N' is the sign.                         186181
      ** If 4th character is not numeric, then currency is in this                            186181
      ** part of the field. So the field is in the format                                     186181
      ** Ncccaaaaaaaaaaaaaaa, where N is the sign, ccc is the currency                        186181
      ** and aaaaaaaaaaaaaaa is the amount. Otherwise the field is in                         186181
      ** format cccaaaaaaaaaaaaaaa.                                                           186181
      *                                                                                       186181
     C     @WM1          IFEQ      'N'
     C     *IN47         ANDEQ     '1'
     C                   MOVEA     @WM1          FLB(1)
     C                   MOVEA     FLA(2)        @WL3
     C                   MOVEA     @WL3          FLB(3)
     C                   MOVEA     FLA(5)        @WK15
     C/COPY WNCPYSRC,ME0600C090
     C                   MOVEA     @WK15         FLB(7)
     C/COPY WNCPYSRC,ME0600C091
     C                   ELSE
     C                   MOVEA     FLA(1)        @WL3
     C                   MOVEA     @WL3          FLB(1)
     C                   MOVEA     FLA(4)        @WK15
     C/COPY WNCPYSRC,ME0600C092
     C                   MOVEA     @WK15         FLB(5)
     C/COPY WNCPYSRC,ME0600C093
     C                   END
     C                   END                                                              E1
      *
     C     EFTAGF        IFEQ      'A'                                                     1
     C/COPY WNCPYSRC,ME0600C094
     C                   MOVEA     FLA(1)        FLB(1)
     C/COPY WNCPYSRC,ME0600C095
     C                   END                                                              E1
      *                                                                   CSW098
     C     WMFLD         IFNE      *BLANKS                                                     CSW09
     C                   MOVEL     WMFLD         MFLD                                          CSW09
     C                   MOVEA     FLB           WFLB                                          CSW09
     C                   CAT       WFLB:0        MFLD                                          CSW09
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLB           MFLD
     C                   ENDIF                                                                 CSW09
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *   VALD - validate amendment                                   *
      *   Called by - AMND amend message                              *
      *****************************************************************
      *
     C     VALD          BEGSR
      *
     C     SNWK          IFNE      *BLANKS                                                 1
      *
      **  If network entered invalid
     C     SNWK          IFNE      'SWIFT'                                                 2
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP5                                           S01408
     C*                                                                   S01408
     C     SNWK          ANDNE     'TELEX'
     C     SNWK          ANDNE     'STTX'
     C     SNWK          ANDNE     'PAPER'
     C                   MOVEL     'MEM1014'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   END                                                              E2
      *
      **  If network entered same as existing network
     C     SNWK          IFEQ      NWRK                                                    2
     C                   MOVEL     'MEM1063'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   END                                                              E2
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP7                                           S01408
     C*                                                                   S01408
      *
      **  If network entered inactive
     C     SNWK          IFEQ      'SWIFT'                                                 2
     C     BGMSDL        ANDNE     'Y'
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CCP6                                           S01408
     C*                                                                   S01408
     C                   MOVEL     'MEM1049'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   END                                                              E2
      *
     C     SNWK          IFEQ      'TELEX'                                                 2
     C/COPY WNCPYSRC,ME0600C064
     C     BGMTMI        ANDNE     'Y'
     C                   MOVEL     'MEM1050'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   END                                                              E2
      *
     C     SNWK          IFEQ      'STTX'                                                  2
     C     BGMSDL        ANDNE     'Y'
     C                   MOVEL     'MEM1051'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   END                                                              E2
      *                                                                   CSW096
     C                   MOVE      MTPY          USMTPY                                        CSW09
     C     SNWK          IFEQ      'SWIFT'                                                     CSW09
     C     USCH1         ANDEQ     '3'                                                         CSW09
     C     USCH2         ANDNE     '9'                                                         CSW09
      *                                                                   CSW096
     C     TRNO          CHAIN     MGOMSGD0                           11                       CSW09
      *                                                                   CSW096
     C     *IN11         IFEQ      '0'                                                         CSW09
     C                   READ      MGOMSGPD                               11                   CSW09
     C     *IN11         IFEQ      '0'                                                         CSW09
     C                   READ      MGOMSGPD                               11                   CSW09
     C     *IN11         IFEQ      '0'                                                         CSW09
      *                                                                   CSW096
     C     MTAG          IFEQ      ':22: '                                                     CSW09
     C                   MOVEA     *BLANKS       FLA                                           CSW09
     C                   MOVEA     MFLD          FLA                                           CSW09
     C                   Z-ADD     1             A                                             CSW09
      *                                                                   CSW096
     C     '/'           LOOKUP    FLA(A)                                 53                   CSW09
     C     *IN53         IFEQ      '1'                                                         CSW09
     C                   Z-ADD     A             B                 2 0                         CSW09
      *                                                                   CSW096
     C     ' '           LOOKUP    FLA(B)                                 53                   CSW09
     C     *IN53         IFEQ      '1'                                                         CSW09
     C     B             SUB       A             USLEN             2 0                         CSW09
     C                   ADD       1             USLEN                                         CSW09
      *                                                                   CSW096
     C     USLEN         IFLT      16                                                          CSW09
     C                   MOVEL     'MEM1096'     @MSGID                                        CSW09
     C                   CALL      'ZM1001'      PLIST3                                        CSW09
     C                   MOVE      '1'           *IN35                                         CSW09
     C                   MOVE      '1'           *IN41                                         CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   ENDIF                                                                 CSW09
      *                                                                   CSW096
     C                   END                                                              E1
      *
     C     SPTY          IFNE      *BLANKS                                                 1
     C     SDEL          ORNE      *BLANKS                                                     08719
     C     SNDL          ORNE      *BLANKS                                                     08719
      *
      **  If priority entered invalid
     C     SPTY          IFNE      'N'                                                     2
     C     SPTY          ANDNE     'U'
     C                   MOVEL     'MEM1002'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3542
     C                   END                                                              E2
      *
      **  If priority does not change, notification may be changed.       087198
      **  So  remove this error message.                                  087198
      ***********                                                         087198
      ****If*priority entered same as existing priority                   087198
     C***********SPTY      IFEQ MPRY                                  2   087198
     C***********          MOVEL'MEM1068' @MSGID                          087198
     C***********          CALL 'ZM1001'  PLIST3                          087198
     C***********          SETON                     3542                 087198
     C**********           END                                       E2   087198
      *                                                                   131215
      ** If priority entered is 'Urgent' then both delivery monitoring    131215
      ** fields should have values.                                       131215
      *                                                                   131215
     C     SPTY          IFEQ      'U'                                                     2   13121
     C     SDEL          IFEQ      ' '                                                     3   13121
     C     SNDL          OREQ      ' '                                                         13121
     C                   MOVEL     'MEM1097'     @MSGID                                        13121
     C                   CALL      'ZM1001'      PLIST3                                        13121
     C                   SETON                                        3542                     13121
     C                   END                                                              E3   13121
     C                   END                                                              E2   13121
      *                                                                   087198
      **  If priority entered is 'Urgent' then delivery monitoring        087198
      **  should be '1' or '3'. (Mandatory)  Can not be '2' OR ' '.       087198
     C     SPTY          IFEQ      'U'                                                     2   08719
     C     SDEL          IFEQ      'Y'                                                     3   08719
     C     SNDL          ANDEQ     'N'                                                         08719
     C     SDEL          OREQ      'N'                                                         08719
     C     SNDL          ANDEQ     'N'                                                         08719
     C     SDEL          OREQ      ' '                                                         08719
     C     SNDL          ANDEQ     ' '                                                         08719
     C                   MOVEL     'MEM1094'     @MSGID                                        08719
     C                   CALL      'ZM1001'      PLIST3                                        08719
     C                   SETON                                        3542                     08719
     C                   END                                                              E3   08719
     C                   END                                                              E2   08719
      *                                                                   087198
      **  If priority entered is 'Normal' then delivery monitoring        087198
      **  may optionaly be '2' instead of ' '. Can not be '1' or '3'.     087198
     C     SPTY          IFEQ      'N'                                                     2   08719
     C     SDEL          IFEQ      'Y'                                                     3   08719
     C     SNDL          ANDEQ     'Y'                                                         08719
     C     SDEL          OREQ      'N'                                                         08719
     C     SNDL          ANDEQ     'Y'                                                         08719
     C     SDEL          OREQ      ' '                                                         08719
     C     SNDL          ANDEQ     ' '                                                         08719
     C                   MOVEL     'MEM1095'     @MSGID                                        08719
     C                   CALL      'ZM1001'      PLIST3                                        08719
     C                   SETON                                        3542                     08719
     C                   END                                                              E3   08719
     C                   END                                                              E2   08719
     C                   END                                                              E1
      *
      **  If delivery note entered invalid
     C     SDEL          IFNE      'Y'                                                     1
     C     SDEL          ANDNE     'N'
     C     SDEL          ANDNE     ' '
     C                   MOVEL     'MEM1069'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3543
     C                   END                                                              E1
      *
      **  If non delivery note entered invalid
     C     SNDL          IFNE      'Y'                                                     1
     C     SNDL          ANDNE     'N'
     C     SNDL          ANDNE     ' '
     C                   MOVEL     'MEM1070'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3544
     C                   END                                                              E1
     C/COPY WNCPYSRC,ME0600C074
      *
      **  If no errors attempt to re-route if required
     C     *IN35         IFEQ      '0'                                                     1
     C     SNWK          ANDNE     *BLANKS
      *
     C     SNWK          IFEQ      'SWIFT'                                                 2
     C*                                                                   S01408
     C/COPY WNCPYSRC,ME0600CP11                                           S01408
     C*                                                                   S01408
     C     SSWFT         IFEQ      *BLANKS
     C     DSWFT         OREQ      *BLANKS                                                 3
     C                   MOVEL     'MEM1064'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   ELSE                                                             X3
     C                   MOVEL     SNWK          NWRK
     C                   MOVE      *BLANKS       NWSN
     C                   MOVEL     SSWFT         NWSN
     C                   MOVE      *BLANKS       NWDS
     C                   MOVEL     DSWFT         NWDS
     C                   END                                                              E3
     C                   END                                                              E2
      *
     C/COPY WNCPYSRC,ME0600C063
     C     SNWK          IFEQ      'TELEX'                                                 2
     C/COPY WNCPYSRC,ME0600C065
     C     STELX         IFEQ      *BLANKS
     C     DTELX         OREQ      *BLANKS                                                 3
     C                   MOVEL     'MEM1065'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   ELSE                                                             X3
     C                   MOVEL     SNWK          NWRK
     C                   MOVE      *BLANKS       NWSN
     C                   MOVEL     STELX         NWSN
     C                   MOVE      *BLANKS       NWDS
     C                   MOVEL     DTELX         NWDS
     C                   END                                                              E3
     C/COPY WNCPYSRC,ME0600C066
     C                   END                                                              E2
      *
     C     SNWK          IFEQ      'STTX'                                                  2
     C     SSTTX         IFEQ      *BLANKS
     C     DSTTX         OREQ      *BLANKS                                                 3
     C                   MOVEL     'MEM1066'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   ELSE                                                             X3
     C                   MOVEL     SNWK          NWRK
     C                   MOVE      *BLANKS       NWSN
     C                   MOVEL     SSTTX         NWSN
     C                   MOVE      *BLANKS       NWDS
     C                   MOVEL     DSTTX         NWDS
     C                   END                                                              E3
     C                   END                                                              E2
      *
     C     SNWK          IFEQ      'PAPER'                                                 2
     C     SNAME         IFEQ      *BLANKS
     C     DNAME         OREQ      *BLANKS                                                 3
     C                   MOVEL     'MEM1067'     @MSGID
     C                   CALL      'ZM1001'      PLIST3
     C                   SETON                                        3541
     C                   ELSE                                                             X3
     C                   MOVEL     SNWK          NWRK
     C                   MOVE      *BLANKS       NWSN
     C                   MOVEL     SNAME         NWSN
     C                   MOVE      *BLANKS       NWDS
     C                   MOVEL     DNAME         NWDS
     C                   END                                                              E3
     C                   END                                                              E2
     C                   END                                                              E1
      *
     C                   ENDSR
     C/EJECT
     C/COPY WNCPYSRC,ME0600C014
      *****************************************************************
      *   TKEY - Generate testkey                                     *
      *****************************************************************
      *
     C     TKEY          BEGSR
      *
      **  Clear message id, because this subroutine sends hard-coded      067236
      **  error messages                                                  067236
     C                   CLEAR                   @MSGID                                        06723
     C                   CLEAR                   @MSDTA                                        06723
      *                                                                   067460
      **  If not Midas Testkey workstation, send error message            067460
     C     @TK           IFNE      'Y'                                                         06746
     C                   MOVEL     TXT(24)       @MSDTA                                        06746
     C                   CALL      'ZM1001'      PLIST3                                        06746
     C                   SETON                                        3546                     06746
     C                   ELSE                                                                  06746
     C                   OPEN      TKOTIPF
      *                                                                   CTK001
      ** Before proceeding, ensure record is not now being used/been      CTK001
      ** cleared by another user                                          CTK001
      *                                                                   CTK001
     C     TRNO          CHAIN     MGOREFL0                           1013                     CTK00
      *                                                                   CTK001
     C     *IN10         IFEQ      *OFF                                                        CTK00
     C     *IN13         ANDEQ     *OFF                                                        CTK00
      *
      **  Write the 1st record to TKOTIPF                                 S01156
     C                   Z-ADD     1             W1                                            S0115
     C                   MOVE      'U'           DTTP                                          S0115
     C                   MOVE      ':'           CLN                                           S0115
     C                   MOVE      *BLANKS       DATA                                          S0115
     C                   MOVEL     'MIDAS'       DATA                                          S0115
     C                   MOVE      MODI          DTA2                                          S0115
     C                   MOVE      ':'           DTA3                                          S0115
     C                   WRITE     TKOTIPFF                                                    S0115
      *                                                                   S01156
      **  Write the 2nd record to TKOTIPF                                 S01156
     C                   MOVE      'S'           DTTP                                          S0115
     C                   MOVE      *BLANKS       DATA                                          S0115
     C******************** MOVELDECN      DATA                      S01156067054
     C******************** MOVEL':'       DTA2                      S01156067054
     C                   MOVEL     NWDS          DATA                                          06705
     C***********          MOVEL':'       DTA5                      067054CTK001
      *                                                                   CTK001
      ** Determine position for colon                                     CTK001
      *                                                                   CTK001
     C                   Z-ADD     31            N                 2 0                         CTK00
      *                                                                   CTK001
     C     N             DOWGT     *ZERO                                                       CTK00
     C     DATX(N)       ANDEQ     *BLANKS                                                     CTK00
     C                   SUB       1             N                                             CTK00
     C                   ENDDO                                                                 CTK00
      *                                                                   CTK001
     C     N             IFNE      *ZERO                                                       CTK00
     C                   ADD       1             N                                             CTK00
     C                   MOVE      ':'           DATX(N)                                       CTK00
     C                   ENDIF                                                                 CTK00
      *                                                                   CTK001
     C                   WRITE     TKOTIPFF                                                    S0115
      *                                                                   S01156
      **  Write the 3rd record to TKOTIPF                                 S01156
     C                   MOVE      YY1           YY2
     C                   MOVE      MM1           MM2
     C                   MOVE      DD1           DD2
      *
     C                   MOVE      'D'           DTTP                                          S0115
     C                   MOVE      *BLANKS       DATA                                          S0115
     C******************** MOVELSVDT      DATA                      S01156067210
     C                   MOVEL     @SVDT         DATA                                          06721
     C                   MOVEL     ':'           DTA2                                          S0115
     C                   WRITE     TKOTIPFF                                                    S0115
      *                                                                   S01156
      **  Write the 4th record to TKOTIPF                                 S01156
     C                   MOVE      'C'           DTTP                                          S0115
     C                   MOVE      *BLANKS       DATA                                          S0115
     C                   MOVEL     CCY           DATA                                          S0115
     C                   MOVEL     ':'           DTA4                                          S0115
     C                   WRITE     TKOTIPFF                                                    S0115
      *                                                                   S01156
      **  Write the 5th record to TKOTIPF                                 S01156
     C                   MOVE      'A'           DTTP                                          S0115
     C                   MOVE      *BLANKS       FLA                                           S0115
     C                   Z-ADD     1             A                                             S0115
      *
     C     TRNM          IFEQ      *BLANKS                                                 1
     C                   MOVEA     AMTS          FLA
     C                   ELSE                                                             X1
     C                   MOVEA     AMTX          FLA
     C                   END                                                              E1
      *
     C     A             DOWLT     50                                                      1   S0115
     C     FLA(A)        ANDNE     ','                                                         S0115
     C     FLA(A)        ANDNE     ' '                                                         S0115
     C                   ADD       1             A                                             S0115
     C                   END                                                              E1   S0115
     C                   MOVE      ':'           FLA(A)                                        S0115
      *                                                                   S01156
      **  Blank out any remainder                                         S01156
     C     A             IFLT      50                                                      1   S0115
     C                   ADD       1             A                                             S0115
     C                   MOVEA     *BLANKS       FLA(A)                                        S0115
     C                   END                                                              E1   S0115
     C                   MOVEA     FLA           DATA                                          S0115
     C                   WRITE     TKOTIPFF                                                    S0115
      *
     C                   CLOSE     TKOTIPF
      *
     C                   CALL      'MTC4030'
     C                   PARM      *BLANK        @MTRT             1                           06723
      *                                                                   CTK001
      ** If record locked or removed my another user                      CTK001
      *                                                                   CTK001
     C                   ELSE                                                                  CTK00
     C                   MOVEL     TXT(27)       @MSDTA                                        CTK00
     C                   CALL      'ZM1001'      PLIST3                                        CTK00
     C                   MOVE      *BLANKS       @MSDTA                                        CTK00
     C                   SETON                                        3546                     CTK00
     C                   ENDIF                                                                 CTK00
      *                                                                   067236
      **  If program ends in error, display error message                 067236
     C     @MTRT         IFEQ      'E'                                                         06723
     C                   MOVEL     TXT(23)       @MSDTA                                        06723
     C                   CALL      'ZM1001'      PLIST3                                        06723
     C                   MOVE      *BLANKS       @MSDTA                                        06723
     C                   SETON                                        3546                     06723
     C                   ELSE                                                                  06723
      *
     C                   OPEN      TKOTOPF
      *
      **  Read the TKOTOPF file                                           S01156
     C     1             CHAIN     TKOTOPFF                           10                       S0115
      *                                                                   S01156
      **  Return error which prevented calculation of testkey             S01156
      **   - if file empty, may be because PC Organizer (PCO.EXE) not     067236
      **     started in PC's AUTOEXEC.BAT                                 067236
     C     *IN10         IFEQ      '1'                                                     1
     C     SYS1          OREQ      'E'
     C     ERRR          OREQ      'E'
     C     TKOT          OREQ      *BLANK
     C     *IN10         IFEQ      '0'                                                         06723
     C                   MOVEL     TXT(22)       @MSDTA
     C                   MOVE      TKOT          @MSDTA
     C                   ELSE                                                                  06723
     C                   MOVEL     TXT(23)       @MSDTA                                        06723
     C                   END                                                                   06723
     C                   CALL      'ZM1001'      PLIST3
     C                   MOVE      *BLANKS       @MSDTA
     C                   SETON                                        3546
      *                                                                   S01156
      **  Return generated testkey after removing colon                   S01156
     C                   ELSE                                                             X1   S0115
     C                   MOVE      *BLANKS       FLA                                           S0115
     C                   Z-ADD     1             A                                             S0115
      *
     C                   MOVEA     TSKY1         FLA                                           S0119
     C     A             DOWLE     50                                                      2   S0115
     C     FLA(A)        ANDNE     ':'                                                         S0115
     C                   ADD       1             A
     C                   END                                                              E2   S0115
      *
     C     A             IFLE      50                                                      2   S0115
     C                   MOVEA     *BLANKS       FLA(A)                                        S0115
     C                   END                                                              E2   S0115
     C                   MOVEA     FLA           STKY                                          S0115
     C                   END                                                              E1
      *
     C                   CLOSE     TKOTOPF
      *                                                                   067236
     C                   END                                                                   06723
      *
     C                   END                                                                   06746
      *                                                                   067460
     C                   ENDSR
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
     C                   Z-ADD     012           DBASE
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     PCUST         DBKEY
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
      *   *PSSR - error handling                                      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   MOVE      '1'           @ERR
     C                   SETON                                        LR
     C                   DUMP
     C/COPY WNCPYSRC,ME0600C083
     C                   RETURN
      *
     C                   ENDSR
     C/COPY WNCPYSRC,ME0600C096
      *
     OMGOREFU0  E
      /COPY WNCPYSRC,ME0600OOP1                                           S01408
** File translation table for high intensity bytes
ME0600DF  227B204A
     X/COPY WNCPYSRC,ME0600X001                                           S01408
**  Months MM/MMM format
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
**  Text
Branch XXX      XXXXXXXXXXXXXXXXXXXX XXX    Settlement - receive XXX
Network XXXXXX  Message type XXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXX
Sender          XXXXXXXXXXXXXXXXXXXX        Creation date XXXXXXX
Destination     XXXXXXXXXXXXXXXXXXXX        XXXXXXXXXXXXXXXXXXXX XXXXXXXXXX
Message status  XXXXXXXXXXXXXXXXXXXXXXXXX   Date XXXXXXX Time XX:XX:XX
Module XX       Transaction XXXXXXXXXXXXXXX Type XX Subtype XX
Module XX     SWIFT account XXXXXXXXXXXXXXX
External System XXXXXX
Priority XXXXXX Del X Non del X notif.      Error XXX XXX
Testkey req/d?  XXX
C/Pty conf status XXXXXXXXXXXXXXX  Broker conf status XXXXXXXXXXXXXXX
 XXXXXXXXXXX Mod XX  Tr. XXXXXXXXXXXXXXX Type XX Sub XX XXXXX XX XXXX XX
Description          Tag   Data
*P.D.E.*
<MSG DESC NOT FOUND>
* DELETED *
C/Pty
Brok
<TAG DESC NOT FOUND>
<NOT VERIFIED>
Module XX - message input via Message Management
MIDAS testkey returned error message:
MIDAS Testkey program ended in error - see job-log
Unable to generate testkey - not Midas Testkey user
Testkey         X
123456789 123456789 123456789 123456789 123456789 123456789 123456789 12345678
The record for this message is locked. Please refresh screen and re-try
Deliverer of Security
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
TSNTSent via Telex                                                        081505
TOUTPending Transmission                                                  081505
TCANCancelled                                                             081505
TRTYIn retry                                                              081505
TACTActive                                                                081505
TSENSent via Telex                                                        066991
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
     X/COPY WNCPYSRC,ME0600X003
** VERFY - Message types/fields requiring verification
100:32
200:32                                                                    098075
202:32
203:19
203:30
203:32
103:32
     X/COPY WNCPYSRC,ME0600X002
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
** CPY@   **      OBJECT COPYRIGHT
(c) Finastra International Limited 2001
