000100200529     H DEBUG
000200200529      *****************************************************************
000300200529/*STD *  RPGBASEMOD                                                   *
000400200529/*EXI *  TEXT('Midas SE Corporate actions events maintenance')        *
000500200529/*OVR *  OVRDBF FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)              : *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SE7502N - SE Corporate Actions Events Maintenance            *
001100200529      *            Subordinate Action                                 *
001200200529      *                                                               *
001300200529      *  (c) Finastra International Limited 2001                      *
001400200529      *                                                               *
001700200619      *  Last Amend No. MD046248           Date 27Oct17               *
001800200619      *  Prev Amend No. CER059             Date 19Jul10               *
001900200529      *                 CER020             Date 19May08               *
002000200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
002100200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
002200200529      * Midas Plus 1.4 Base ------------------------------------------*
002300200529      * Midas Plus 1.3 ----------- Base ------------------------------*
002400200529      *                 CSD031             Date 10Apr06               *
002500200529      *                 CSD027             Date 09Dec05               *
002600200529      *                 CGL031             Date 05Jul04               *
002700200529      *                 CSE071             Date 19Jul05               *
002800200529      *                 CGL029             Date 01Sep03               *
002900200529      * Midas Release 4 --------------- Base -------------------------*
003000200529      * Midas DBA 3.03 -----------------------------------------------*
003100200529      *                 CSE020  *CREATE    Date 21Mar00               *
003200200529      *                                                               *
003300200529      *---------------------------------------------------------------*
003400200529      *                                                               *
003800200529      *  MD046248 - Finastra Rebranding                               *
003900200529      *  CER059 - German Feature Upgrade to Delhi                     *
004000200529      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
004100200529      *           Midas Plus (Recompile)                              *
004200200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
004300200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
004400200529      *  CGL031 - Taxation of Savings Income                          *
004500200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
004600200529      *  CGL029 - Increase Account Code to 10 digits                  *
004700200529      *  CSE020 - Corporate Actions Domino Effect Processing          *
004800200529      *                                                               *
004900200529      *****************************************************************
005000200529      /EJECT
005100200529      *
005200200529      **   MA - SE Corporate Actions References - Upd Idx
005300200529     FSECORFL0  UF A E           K DISK
005400200529     F                                     INFSR(*PSSR)
005500200529     F                                     COMMIT
005600200529      *
005700200529      **   MU - SE Corporate Actions Blocked Positions
005800200529     FSECOBKL1  UF   E           K DISK
005900200529     F                                     INFSR(*PSSR)
006000200529     F                                     COMMIT
006100200529      *
006200200529      **  MQ - SE Corporate Actions Customer/Book Reply
006300200529     FSECOREL0  UF A E           K DISK
006400200529     F                                     INFSR(*PSSR)
006500200529     F                                     COMMIT
006600200529      *
006700200529      **  MP - SE Corporate Actions Reply History file-Detail
006800200529     FSECORHL0  UF A E           K DISK    INFSR(*PSSR)
006900200529     F                                     COMMIT
007000200529      *
007100200529      **   MU - SE Corporate Actions Blocked Positions
007200200529     FSECOBKL2  UF A E           K DISK
007300200529     F                                     RENAME(SECOBKD0:SECOBKD2)
007400200529     F                                     INFSR(*PSSR)
007500200529     F                                     COMMIT
007600200529      *
007700200529      **   MA - SE Corporate Actions References - Rtv Idx
007800200529     FSECORFL9  IF   E           K DISK
007900200529     F                                     RENAME(SECORFD0:SECORFD1)
008000200529     F                                     INFSR(*PSSR)
008100200529      *
008200200529      **   Securities Details
008300200529     FSECTYZ1   IF   E           K DISK
008400200529     F                                     INFSR(*PSSR)
008500200529      *
008600200529      **   Market Prices
008700200529     FPRICM     IF   E           K DISK
008800200529     F                                     INFSR(*PSSR)
008900200529      *
009000200529      **   Investment Types Details
009100200529     FINVTP     IF   E           K DISK
009200200529     F                                     INFSR(*PSSR)
009300200529      *
009400200529      **   Security Events by Type
009500200529     FSECED     IF   E           K DISK
009600200529     F                                     INFSR(*PSSR)
009700200529      *
009800200529      **   MM - SE Corporate Actions Types
009900200529     FSECOATL0  IF   E           K DISK
010000200529     F                                     INFSR(*PSSR)
010100200529      *
010200200529      **   MN - SE Option Narrative Code
010300200529     FSECONAL0  IF   E           K DISK
010400200529     F                                     INFSR(*PSSR)
010500200529      *
010600200529      **   MA - SE Corporate Actions Reference Number
010700200529     FSECORFPA  UF A E           K DISK
010800200529     F                                     INFSR(*PSSR)
010900200529     F                                     COMMIT
011000200529      *
011100200529      **   MB - SE Corporate Actions Depots - Rtv Idx
011200200529     FSECODPL1  IF   E           K DISK
011300200529     F                                     RENAME(SECODPD0:SECODPD1)
011400200529     F                                     INFSR(*PSSR)
011500200529      *
011600200529      **   SE Depot Positions by Security
011700200529     FDPOSS     IF   E           K DISK
011800200529     F                                     RENAME(DPOSNDF:DPOSSDF)
011900200529     F                                     INFSR(*PSSR)
012000200529      *
012100200529      **   MC - SE Corporate Actions Allocation - Rtv Idx
012200200529     FSECOALL1  IF   E           K DISK
012300200529     F                                     RENAME(SECOALD0:SECOALDU)
012400200529     F                                     INFSR(*PSSR)
012500200529      *
012600200529      **   MB - SE Corporate Actions Depots - Upd Idx
012700200529     FSECODPL0  UF A E           K DISK
012800200529     F                                     INFSR(*PSSR)
012900200529     F                                     COMMIT
013000200529      *
013100200529      **   MS - SE Corporate Actions Depots Reference
013200200529     FSECODRL1  IF   E           K DISK
013300200529     F                                     RENAME(SECODRD0:SECODRD1)
013400200529     F                                     INFSR(*PSSR)
013500200529      *
013600200529      **   MC - SE Corporate Actions Allocation - Upd Idx
013700200529     FSECOALL0  UF A E           K DISK
013800200529     F                                     INFSR(*PSSR)
013900200529     F                                     COMMIT
014000200529      *
014100200529      **   Midas Corporate Actions - Depots Update index
014200200529     FSECODRL0  UF A E           K DISK
014300200529     F                                     INFSR(*PSSR)
014400200529     F                                     COMMIT
014500200529      *
014600200529      **   MD - SE Corporate Actions - Dividends Events
014700200529     FSECODVL0  UF A E           K DISK
014800200529     F                                     INFSR(*PSSR)
014900200529     F                                     COMMIT
015000200529      *
015100200529      **   ME - SE Corporate Actions - Free Allocations
015200200529     FSECOFRL0  UF A E           K DISK
015300200529     F                                     INFSR(*PSSR)
015400200529     F                                     COMMIT
015500200529      *
015600200529      **   MG - SE Corporate Actions - Capital Events
015700200529     FSECOCEL0  UF A E           K DISK
015800200529     F                                     INFSR(*PSSR)
015900200529     F                                     COMMIT
016000200529      *
016100200529      **   MH - SE Corporate Actions - Merger
016200200529     FSECOCRL0  UF A E           K DISK
016300200529     F                                     INFSR(*PSSR)
016400200529     F                                     COMMIT
016500200529      *
016600200529      **   MI - SE Corporate Actions - Exchange Offers
016700200529     FSECOOFL0  UF A E           K DISK
016800200529     F                                     INFSR(*PSSR)
016900200529     F                                     COMMIT
017000200529      *
017100200529      **   MF - SE Corporate Actions - Rights Issues
017200200529     FSECORGL0  UF A E           K DISK
017300200529     F                                     INFSR(*PSSR)
017400200529     F                                     COMMIT
017500200529      *
017600200529      **   MJ - SE Corporate Actions - Exercises and Conversions
017700200529     FSECOEXL0  UF A E           K DISK
017800200529     F                                     INFSR(*PSSR)
017900200529     F                                     COMMIT
018000200529      *
018100200529      **   MK - SE Corporate Actions - Non Financial Events
018200200529     FSECONFL0  UF A E           K DISK
018300200529     F                                     INFSR(*PSSR)
018400200529     F                                     COMMIT
018500200529      *
018600200529      **   ML - SE Corporate Actions - Name Changes
018700200529     FSECONCL0  UF A E           K DISK
018800200529     F                                     INFSR(*PSSR)
018900200529     F                                     COMMIT
019000200529      *
019100200529      **   NA - SE Corporate Actions (EMU) - Currency Changes
019200200529     FSECOCCL0  UF A E           K DISK
019300200529     F                                     INFSR(*PSSR)
019400200529     F                                     COMMIT
019500200529      *
019600200529      **  NB - Securities Redenomination Bulk Details - Updt Index
019700200529     FSECORBL0  UF   E           K DISK    COMMIT
019800200529     F                                     INFSR(*PSSR)
019900200529      *
020000200529      **  NC - Securities Redenomination Bulk Securities - Updt
020100200529     FSECORSL0  UF   E           K DISK    COMMIT
020200200529     F                                     INFSR(*PSSR)
020300200529      *
020400200529      ** MJ - SE Corporate Actions - Exercises and Conversions,
020500200529      **      Linked Corporate Action Number.
020600200529      *
020700200529     FSECOEXL2  IF   E           K DISK    INFSR(*PSSR)
020800200529     F                                     RENAME(SECOEXD0:SECOEXD2)
020900200529      *
021000200529      **  Securities Corporate Actions - By parent Ref
021100200529     FSECORFLA  IF   E           K DISK
021200200529     F                                     INFSR(*PSSR)
021300200529      *
021400200529      **   Display file
021500200529     FSE7502NDF CF   E             WORKSTN INFDS(SCRDS)
021600200529     F                                     INFSR(*PSSR)
021700200529     F                                     SFILE(SE7502S0:#1RRN)
021800200529     D*****************************************************************
021900200529      /EJECT
022000200529     D********************************************************************
022100200529      *
022200200529      * ID F  C  H  L    Function of indicators
022300200529      * ---------------------------------------
022400200529      *
022500200529      *   KC : CMD  3 - End of program
022600200529      *   KE : CMD  5 - Reset Screen
022700200529      *   KI : CMD  9 - Go to 'Add' or 'Change' Mode
022800200529      *   KL : CMD 12 - Previous screen
022900200529      *
023000200529      *   LR :    Last record
023100200529      *   U7/U8 : Database error
023200200529      *
023300200529      *   06 : CGL031 Indicator                                                               CGL031
023400200529      *   07 : Reverse Image on 'Subject to European Tax'                                     CGL031
023500200529      *   13 : Reverse Image on 'Customer Last Reply Time'
023600200529      *   14 : Reverse Image on 'Depot    Last Reply Time'
023700200529      *   15 : LS=Final Allocation Stock
023800200529      *   16 : LY=Final Allocation Cash and Stock
023900200529      *   17 : S =Stock Authorised
024000200529      *   18 : X =Fully Authorised (Cash & Stock)
024100200529      *   20 : Reverse Image on 'Old Capital Value'
024200200529      *   21 : Reverse Image on 'New Capital Value'
024300200529      *   22 : Reverse Image on 'Old Nominal Value'
024400200529      *   23 : Reverse Image on 'New Nominal Value'
024500200529      *   24 : Reverse Image on 'Market Cum Price'
024600200529      *   26 : Number of options is 01
024700200529      *   27 : Rollup subfile
024800200529      *   28 : Error indicator (Subfile Field)
024900200529      *   29 : Error indicator
025000200529      *   30 : End of Subfile
025100200529      *   31 : Reverse Image on 'Market Ex Price'
025200200529      *   32 : Error indicator
025300200529      *   33 : Error indicator
025400200529      *   35 : Protect/Non-display fields for processing type 'CC'
025500200529      *   37 : Error indicator
025600200529      *   38 : Error indicator
025700200529      *   39 : Error indicator
025800200529      *
025900200529      *   40 : Confirm REVERSAL or DELETION
026000200529      *   41 : Confirm AUTHORISATION
026100200529      *   42 : Reverse Image on 'Block Security'
026200200529      *
026300200529      *   43 : 'AMEND' Mode if *ON
026400200529      *        'ADD  ' Mode if *OFF
026500200529      *   44 : Error indicator
026600200529      *   45 : "First" Time Processing
026700200529      *   46 : Command Key pressed
026800200529      *   47 : Confirmation Screen or 'Full Details' Screen
026900200529      *   48 : Protect 'Allocation Effective Date'
027000200529      *   49 : Reverse Image on 'Event Date'
027100200529      *
027200200529      *   50 : Error indicator (Position Field)
027300200529      *   51 : Error indicator
027400200529      *   52 : Error indicator
027500200529      *
027600200529      *   53 : Access by Security Shortname and Ex-date
027700200529      *   54 : Access by Ex-date and Security Shortname
027800200529      *   55 : Access by Reference Number
027900200529      *
028000200529      *   56 : Protect 'Position/Selection' Fields
028100200529      *   57 : Protect and non-display 'Action'
028200200529      *   58 : Protect Security Shortname', 'Action Type', 'Number of Options',
028300200529      *   59 : Protect 'Ex-date' field
028400200529      *
028500200529      *   60 : Reverse Image on 'Trade Date'
028600200529      *   61 : Enquiry Mode
028700200529      *   62 : Error indicator (Action)
028800200529      *   63 : Protect 'Ex-date' fields
028900200529      *   64 : Report Mode
029000200529      *   65 : Reverse Image on 'Payment Date'
029100200529      *   66 : Reverse Image on 'Trade/Value Date Position'
029200200529      *   67 : Reverse Image on 'Coupon Number'
029300200529      *   68 : Protect 'Final Allocation' field
029400200529      *   69 : Error indicator (Selection Field)
029500200529      *   70 : Reverse Image on 'ShareHolders Meeting Date'
029600200529      *   71 : Reverse Image on 'Letter to be Sent'
029700200529      *   72 : Reverse Image on 'Block Positions'
029800200529      *   73 : Reverse Image on 'Block From Date'
029900200529      *   74 : Reverse Image on 'Block To   Date'
030000200529      *   75 : Protect 'Date of Announcement'
030100200529      *   76 : Reverse Image on 'Refuse Offer'
030200200529      *   77 : Reverse Image on 'Customer Option Narrative Code'
030300200529      *   78 : Reverse Image on 'Default no Reply'
030400200529      *   79 : Reverse Image on 'Default for Cash Preferred'
030500200529      *
030600200529      *   80 : Display Subfile control
030700200529      *   81 : Display Subfile
030800200529      *   82 : Reverse Image on 'Default for Stock Preferred'
030900200529      *   83 : Reverse Image on 'Customer Last Reply Date'
031000200529      *   84 : Subfile Next Change
031100200529      *   85 : Reverse Image on 'Depot Last Reply Date'
031200200529      *
031300200529      *   87 : Read Change indicator
031400200529      *   88 : Working indicator
031500200529      *   89 : Working indicator
031600200529      *
031700200529      *   90-99 : Used by Standard Subroutines
031800200529      *   98 : Indicator used by subroutine ZDATE1
031900200529      *   99 : Indicator used by subroutine ZDATE1
032000200529      **************************************************************************
032100200529      /EJECT
032200200529      **************************************************************************
032300200529      *
032400200529      * Name of the Subroutines
032500200529      * -----------------------
032600200529      *
032700200529      *       P003  - Termination processing
032800200529      *
032900200529      *       P004  - Clear Subfile
033000200529      *       P005  - Build the subfile for Add Mode
033100200529      *       P006  - Build the subfile for Amend/Enquiry Mode
033200200529      *       P008  - Validate subfile records
033300200529      *       P008A - Validate 'Action' field
033400200529      *       P009  - Process 'Action'
033500200529      *       P010  - Process 'Confirmation' screen
033600200529      *       P011  - Process Writing Options with Default Information
033700200529      *       P014  - Initialise error indicators
033800200529      *       P015  - Clear Subfile Fields
033900200529      *       P016  - Load Subfile Fields
034000200529      *       P018  - Process 'Full details' screen
034100200529      *       P019  - Validate 'Full details' screen and update file
034200200529      *       P020  - Blocking Processing
034300200529      *       P021  - Retrieve Next Available Reference Number
034400200529      *       P022  - Apply Action to all Options
034500200529      *       P023  - View/Change Option(s)
034600200529      *       P024  - Verify if the Option Exists
034700200529      *       P025  - Check that no Position Exists on Depot Positions file
034800200529      *
034900200529      *       *PSSR - "Standard" Database error processing
035000200529      *
035100200529      * Name of the Standard Subroutines
035200200529      * --------------------------------
035300200529      *
035400200529      *       ZDATE1 - Validate and convert date to day number
035500200529      *       ZDATE2 - Format a Date for Screen Output
035600200529      *       ZALIGN - Validate/Right align numeric field
035700200529      *       ZSEDIT - Format Amount for Display
035800200529      *       ZASIGN - Validate/Right align signed numeric fields
035900200529      *       ZASNMS - Send Message to Program's message queue
036000200529      *
036100200529      ********************************************************************
036200200529      /EJECT
036300200529      ********************************************************************
036400200529      **   STORE THE EIGHT GROUP EACH CUSTOMER IS ASSOCIATED
036500200529      *
036600200529     D TXT             S             78    DIM(11) CTDATA PERRCD(1)
036700200529      *
036800200529     D NARR            S             27    DIM(9) CTDATA PERRCD(1)
036900200529      *
037000200529     D NSAR            S             10    DIM(180)
037100200529     D                                     INZ(*BLANKS)
037200200529                                                                                              CGL031
037300200529      ** Access Object Parameters                                                             CGL031
037400200529     D PRetCde         S              7A                                                      CGL031
037500200529     D POption         S              7A                                                      CGL031
037600200529     D PSARD           S              6A                                                      CGL031
037700200529                                                                                              CGL031
037800200529      ** Switchable Features                                                                  CGL031
037900200529     D CGL031          S              1A                                                      CGL031
038000200529      ********************************************************************
038100200529      /EJECT
038200200529      ********************************************************************
038300200529      *
038400200529      ** Program Data Structure
038500200529      *
038600200529     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
038700200529      *
038800200529      ** File Information Data Structure
038900200529      *
039000200529     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
039100200529      *
039200200529      ** File Record Data Structure
039300200529      *
039400200529     D FIELD         E DS                  EXTNAME(SECORFPD)
039500200529      *
039600200529     D SCRDS           DS
039700200529     D  DSPNUM               197    205
039800200529     D  CPFPOS               378    379B 0
039900200529      *
040000200529      ** Data Structure for Compilation - Copyright Insertion
040100200529      *
040200200529     D CPYR@#          DS
040300200529     D  CPY@                   1     80
040400200529     D                                     DIM(1) CTDATA PERRCD(1)
040500200529     D  CPY@##                 1     20
040600200529      *
040700200529      ** Data Structure for Database Error
040800200529      *
040900200529     D LDA             DS           256
041000200529     D  WWLOT                132    183
041100200529     D  WWFILE               132    141
041200200529     D  WWKEY                142    170
041300200529     D  WWPGM                171    180
041400200529     D  WWASE                181    183  0
041500200529     D  PGMNAM               184    189
041600200529      *
041700200529     D DIGITS          C                   CONST('0123456789')
041800200529      *
041900200529     D CDDS            DS
042000200529     D  CD01                   1      4  0
042100200529     D  CD02                   5      8  0
042200200529     D  CD03                   9     12  0
042300200529     D  CD04                  13     16  0
042400200529     D  CD05                  17     20  0
042500200529     D  CD06                  21     24  0
042600200529     D  CD07                  25     28  0
042700200529     D  CD08                  29     32  0
042800200529     D  CD09                  33     36  0
042900200529     D  CD10                  37     40  0
043000200529     D  CD11                  41     44  0
043100200529     D  CD12                  45     48  0
043200200529     D  CD                     1     48  0
043300200529     D                                     DIM(12)                              CD01-12 ARRAY
043400200529     D CRDS            DS
043500200529     D  CR01                   1      1
043600200529     D  CR02                   2      2
043700200529     D  CR03                   3      3
043800200529     D  CR04                   4      4
043900200529     D  CR05                   5      5
044000200529     D  CR06                   6      6
044100200529     D  CR07                   7      7
044200200529     D  CR08                   8      8
044300200529     D  CR09                   9      9
044400200529     D  CR10                  10     10
044500200529     D  CR11                  11     11
044600200529     D  CR12                  12     12
044700200529     D  CR                     1     12
044800200529     D                                     DIM(12)                              CR01-12 ARRAY
044900200529     D LOCKDS          DS
045000200529     D  WUSER                  1     10
045100200529     D  WJOBN                 11     20
045200200529      *
045300200529     D ZMUSER          DS            17
045400200529      ** Data area ZMUSER
045500200529     D  BVBRCD                11     13
045600200529      *
045700200529      ** Data structure used to send data to message ID CO00600:
045800200529      ** Linked Corporate Action Number and Processing Type.
045900200529      *
046000200529     D REFLIN          DS
046100200529     D  WWLNKR                 1      6
046200200529     D  WWPTYP                 7      8
046300200529     D RUNDAT        E DS
046400200529      **  Standard Data Area Layout for System flags and Run Date
046500200529      *
046600200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
046700200529      **  Data structure for bank details
046800200529      *
046900200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
047000200529      **  Data structure for branch details
047100200529      *
047200200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
047300200529      **  Data structure for securities trading details
047400200529      *
047500200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
047600200529      **  Data structure for switchable feature details                                       CGL031
047700200529      *                                                                                       CGL031
047800200529     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CGL031
047900200529      **  Short data structure for access objects                                             CGL031
048000200529      *                                                                                       CGL031
048100200529     D DSSDY         E DS                  EXTNAME(DSSDY)
048200200529      **  Long data structure for access objects
048300200529      *
048400200529      *
048500200529      ** +--------------------------------------+
048600200529      ** ¦ Declared variables                   ¦
048700200529      ** ¦ ==================                   ¦
048800200529      ** +--------------------------------------+
048900200529      *
049000200529      ** Parameters for ZDATE1
049100200529     D DateIn          S              6A
049200200529     D DaynoOut        S              5P 0
049300200529     D ErrorFlag       S              1A
049400200529      *
049500200529      ** Parameters for ZDATE2
049600200529     D ZDAYNO          S              5P 0
049700200529     D ZDATE           S              6P 0
049800200529     D ZADATE          S              7A
049900200529      *
050000200529      ** Parameters for ZALIGN
050100200529     D ZAlignOk        S              1A
050200200529     D ZFIELD          S             16A
050300200529     D ZADEC           S              1P 0
050400200529     D ZADIG           S              2P 0
050500200529      *
050600200529      ** Parameters for ZASIGN
050700200529     D ZAsignOk        S              1A
050800200529     D ZFLD17          S             17A
050900200529     D ZSDIG           S              2P 0
051000200529     D ZSDEC           S              1P 0
051100200529     D ZSDCSP          S              1A
051200200529     D ZOUT15          S             15A
051300200529     D ZFSIGN          S              1A
051400200529      *
051500200529      ********************************************************************
051600200529      /EJECT
051700200529      ********************************************************************
051800200529      **    P R O G R A M   S T A R T
051900200529      ********************************************************************
052000200529      *
052100200529     C                   MOVE      P#REFN        #PREF
052200200529     C                   MOVE      '1'           *IN10
052300200529     C                   MOVE      '1'           *IN45
052400200529     C                   MOVE      '0'           *IN53
052500200529     C                   MOVE      '0'           *IN54
052600200529     C                   MOVE      '0'           *IN55
052700200529      *
052800200529     C     P#SEL         IFEQ      'F'
052900200529     C                   MOVEA     TXT(11)       ##CTX1
053000200529     C                   MOVE      '0'           *IN25
053100200529     C                   MOVE      '1'           *IN61
053200200529     C                   ELSE
053300200529     C                   MOVEA     TXT(9)        ##CTX1
053400200529     C                   MOVE      '1'           *IN25
053500200529     C                   ENDIF
053600200529      *
053700200529      ** While F3 and F12 not pressed
053800200529      *
053900200529     C     *INKC         DOWEQ     '0'
054000200529     C     *INKL         ANDEQ     '0'
054100200529     C     WIN12         OREQ      '1'
054200200529      *
054300200529     C                   MOVE      '0'           WIN12
054400200529      *
054500200529      ** If it's the first time processing or F5 is pressed
054600200529      *
054700200529     C     WIN45         IFEQ      '0'
054800200529     C     *INKE         OREQ      '1'
054900200529      *
055000200529     C     *IN43         IFEQ      '1'
055100200529     C     *IN61         ANDEQ     '0'
055200200529     C     *IN61         OREQ      '1'
055300200529      *
055400200529     C                   MOVE      '0'           *IN84
055500200529     C                   MOVE      '0'           *IN47
055600200529     C                   MOVE      '0'           WIN45
055700200529     C     *IN61         IFEQ      '0'
055800200529     C                   MOVE      '0'           *IN57
055900200529     C                   MOVE      '1'           *IN58
056000200529     C                   ENDIF
056100200529     C                   EXSR      P004
056200200529      *
056300200529     C                   EXSR      P014
056400200529     C                   EXSR      P006
056500200529      *
056600200529     C                   ELSE
056700200529      *
056800200529      ** for add mode, Build a blank subfile page
056900200529      *
057000200529     C                   EXSR      P004
057100200529      *
057200200529     C                   MOVE      '1'           *IN57
057300200529     C                   MOVE      '0'           *IN58
057400200529     C                   MOVE      '1'           *IN48
057500200529      *
057600200529     C                   EXSR      P014
057700200529     C                   EXSR      P005
057800200529     C                   MOVE      P#REFN        MAPREF
057900200529     C                   MOVEA     TXT(10)       ##CTX1
058000200529     C                   Z-ADD     1             #1RRN
058100200529      *
058200200529     C                   ENDIF
058300200529     C                   MOVE      '1'           WIN45
058400200529     C                   ENDIF
058500200529      *
058600200529      ** If CMD9 is Pressed
058700200529      *
058800200529     C     *IN09         IFEQ      '1'
058900200529      *
059000200529      ** Check if user is authorised to action 'Insert'
059100200529      *
059200200529     C     AGMBIN        IFNE      'Y'
059300200529      *
059400200529      ** If single branch environment
059500200529      *
059600200529     C                   CALL      'ZVACTU'
059700200529     C                   PARM      'I'           WLACTN            1
059800200529     C                   PARM      *ZERO         WLERR             1 0
059900200529      *
060000200529     C     WLERR         IFNE      *ZERO
060100200529     C                   MOVEL     'CO00034'     ZAMSID
060200200529     C                   EXSR      ZASNMS
060300200529     C                   ENDIF
060400200529      *
060500200529     C                   ELSE
060600200529      *
060700200529      ** If multibranching environment
060800200529      *
060900200529     C                   CALL      'ZVACTBU'
061000200529     C                   PARM      'I'           WLACTN            1
061100200529     C                   PARM      BVBRCD        WLBRCH            3
061200200529     C                   PARM      *ZERO         WLERR             1 0
061300200529      *
061400200529     C     WLERR         IFEQ      1
061500200529     C                   MOVEL     'CO00035'     ZAMSID
061600200529     C                   EXSR      ZASNMS
061700200529     C                   ELSE
061800200529     C     WLERR         IFEQ      2
061900200529     C                   MOVEL     'CO00036'     ZAMSID
062000200529     C                   EXSR      ZASNMS
062100200529     C                   ENDIF
062200200529     C                   ENDIF
062300200529      *
062400200529     C                   ENDIF
062500200529      *
062600200529     C     WLERR         IFEQ      *ZERO
062700200529      *
062800200529      ** If it's the 'AMEND' mode, build a blank subfile
062900200529      *
063000200529     C     *IN43         IFEQ      '1'
063100200529      *
063200200529      ** Initialise error indicators
063300200529      *
063400200529     C                   EXSR      P014
063500200529      *
063600200529      ** Clear subfile
063700200529      *
063800200529     C                   EXSR      P004
063900200529     C                   MOVEA     TXT(10)       ##CTX1
064000200529      *
064100200529      ** Protect/Non-Display 'Action', 'Last/Final Allocation', 'Status' *ON
064200200529      ** Protect on 'Security Short.', 'Action Type', 'Number of Options' *OFF
064300200529      *
064400200529     C                   MOVE      '1'           *IN57
064500200529     C                   MOVE      '0'           *IN58
064600200529      *
064700200529     C                   MOVE      '0'           *IN30
064800200529     C                   MOVE      '0'           *IN59
064900200529     C                   MOVE      '0'           *IN63
065000200529     C                   MOVE      '0'           *IN68
065100200529     C                   MOVE      '1'           *IN48
065200200529     C                   MOVE      '0'           *IN75
065300200529      *
065400200529      ** Build a blank subfile
065500200529      *
065600200529     C                   EXSR      P005
065700200529     C                   Z-ADD     1             #1RRN
065800200529     C                   MOVE      '0'           *IN43
065900200529     C                   ELSE
066000200529      *
066100200529      ** Clear subfile
066200200529      *
066300200529     C                   EXSR      P004
066400200529      *
066500200529      ** Initialise error indicators
066600200529      *
066700200529     C                   EXSR      P014
066800200529      *
066900200529      ** If it's the 'ADD' mode, build a first subfile page
067000200529      ** (beginning at first inserted record)
067100200529      *
067200200529     C                   MOVEA     TXT(9)        ##CTX1
067300200529      *
067400200529     C                   MOVE      '0'           *IN57
067500200529     C                   MOVE      '1'           *IN58
067600200529     C                   MOVE      '0'           WIN45
067700200529      *
067800200529      ** Build the first subfile page
067900200529      *
068000200529     C                   EXSR      P006
068100200529     C                   MOVE      '1'           WIN45
068200200529     C                   MOVE      '1'           *IN43
068300200529     C                   ENDIF
068400200529      *
068500200529     C                   ENDIF
068600200529      *
068700200529     C                   ENDIF
068800200529      *
068900200529      ** If Rollup is pressed
069000200529      *
069100200529     C     *IN27         IFEQ      '1'
069200200529     C                   Z-ADD     WWRRN         #1RRN
069300200529      *
069400200529      ** Reinitialise error indicators
069500200529      *
069600200529     C                   EXSR      P014
069700200529      *
069800200529      ** Clear messages from program message queue.
069900200529      *
070000200529     C                   CALL      'Y2CLMSC'
070100200529     C                   PARM      ##PGM         ZAPGM            10
070200200529     C                   PARM      '*SAME'       ZAPGRL            5
070300200529      *
070400200529      ** If it's the 'ADD' mode only
070500200529      *
070600200529     C     *IN43         IFEQ      '0'
070700200529     C     *IN61         ANDEQ     '0'
070800200529      *
070900200529      ** Build a blank subfile page
071000200529      *
071100200529     C                   EXSR      P005
071200200529      *
071300200529      ** If it's the 'AMEND' mode or the 'ENQUIRY' mode
071400200529      *
071500200529     C                   ELSE
071600200529      *
071700200529      ** Set key fields with blanks or zeros
071800200529      *
071900200529     C                   MOVE      *BLANKS       KREFN
072000200529     C                   MOVE      *BLANKS       KSECN
072100200529     C                   Z-ADD     *ZEROS        KEXDT
072200200529      *
072300200529      ** Build the next subfile page
072400200529      *
072500200529     C                   EXSR      P006
072600200529     C                   ENDIF
072700200529     C                   ENDIF
072800200529      *
072900200529      ** Execute the Subfile Control Record
073000200529      *
073100200529     C                   TIME                    ##TME
073200200529     C                   WRITE     #MSGCTL
073300200529     C                   WRITE     SE7502F1
073400200529     C                   EXFMT     SE7502C0
073500200529      *
073600200529      ** Clear messages frpm program message queue.
073700200529      *
073800200529     C                   CALL      'Y2CLMSC'
073900200529     C                   PARM      ##PGM         ZAPGM            10
074000200529     C                   PARM      '*SAME'       ZAPGRL            5
074100200529      *
074200200529     C     *INKC         IFEQ      *ON
074300200529     C                   MOVE      '3'           P#RTCD
074400200529     C                   ENDIF
074500200529      *
074600200529      ** IF F12
074700200529      *
074800200529     C     *INKL         IFEQ      *ON
074900200529     C     WRBLD         IFEQ      'Y'
075000200529     C                   MOVE      '1'           P#RTCD
075100200529     C                   ELSE
075200200529     C                   MOVE      '2'           P#RTCD
075300200529     C                   ENDIF
075400200529     C                   ENDIF
075500200529      *
075600200529      ** If no function key is pressed and all position/selection
075700200529      ** fields unchanged, validate all subfile records
075800200529      *
075900200529     C     *IN46         IFEQ      '0'
076000200529     C     WWCPT         ANDNE     *ZEROS
076100200529      *
076200200529      ** Reinitialize Error indicators
076300200529      *
076400200529     C                   EXSR      P014
076500200529      *
076600200529     C                   EXSR      P008
076700200529     C                   ENDIF
076800200529     C                   ENDDO
076900200529      *
077000200529      ** Termination Processing
077100200529      *
077200200529     C                   EXSR      P003
077300200529      *
077400200529      *****************************************************************
077500200529      **    P R O G R A M     E N D
077600200529      *****************************************************************
077700200529      /EJECT
077800200529      *****************************************************************
077900200529      * *INZSR : Initial Processing                                   *
078000200529      *****************************************************************
078100200529      *
078200200529     C     *INZSR        BEGSR
078300200529      *
078400200529      ** Entry Parameter
078500200529      *
078600200529     C     *ENTRY        PLIST
078700200529     C                   PARM                    P#REFN            6
078800200529     C                   PARM                    P#COEX            5 0
078900200529     C                   PARM                    P#ACTN            1
079000200529     C                   PARM                    P#SESN           10
079100200529     C                   PARM                    P#STAT            1
079200200529     C                   PARM                    P#FINA            1
079300200529     C                   PARM                    P#SEL             1
079400200529     C                   PARM                    P#PTYP            2
079500200529     C                   PARM                    P#RTCD            1
079600200529      *
079700200529      ** Copyright statement
079800200529      *
079900200529     C                   MOVEA     CPY@          ACT@             80
080000200529     C                   MOVE      '0'           WIN45             1
080100200529      *
080200200529      ** Read in DTAARA/RUNDAT
080300200529      *
080400200529     C     *DTAARA       DEFINE                  RUNDAT
080500200529     C                   IN        RUNDAT
080600200529      *
080700200529      ** Read in DTAARA/ZMUSER
080800200529      *
080900200529     C     *DTAARA       DEFINE                  ZMUSER
081000200529     C                   IN        ZMUSER
081100200529      *
081200200529      ** Set up Key Fields
081300200529      *
081400200529     C     KEY1          KLIST
081500200529     C                   KFLD                    KSECN            10
081600200529     C                   KFLD                    KEXDT             5 0
081700200529     C                   KFLD                    KREFN             6
081800200529      *
081900200529     C     KEY2          KLIST
082000200529     C                   KFLD                    KEXDT
082100200529     C                   KFLD                    KSECN
082200200529     C                   KFLD                    KREFN
082300200529      *
082400200529     C     KEY3          KLIST
082500200529     C                   KFLD                    KNMCY
082600200529     C                   KFLD                    KSITP
082700200529      *
082800200529     C     KEY4          KLIST
082900200529     C                   KFLD                    KSECN
083000200529     C                   KFLD                    KEXDT
083100200529      *
083200200529     C     KEY5          KLIST
083300200529     C                   KFLD                    KSECN            10
083400200529     C                   KFLD                    KEXDT             5 0
083500200529     C                   KFLD                    KTYPE             2
083600200529      *
083700200529     C     KEY6          KLIST
083800200529     C                   KFLD                    KCORF             6
083900200529     C                   KFLD                    KOPTN             2 0
084000200529      *
084100200529     C     KEY7          KLIST
084200200529     C                   KFLD                    KSECN
084300200529     C                   KFLD                    KEXDT
084400200529      *
084500200529      ** Initialise key and work fields
084600200529      *
084700200529     C                   MOVE      *BLANKS       WWLOT
084800200529     C                   MOVEL     'SE7502'      DBPGM            10
084900200529      *
085000200529     C                   Z-ADD     0             WWRRN             4 0
085100200529      *
085200200529      ** Setup screen time
085300200529      *
085400200529     C                   TIME                    ##TME             6 0          Screen time.
085500200529      *
085600200529      ** Access to bank details to retrieve the midas rundate
085700200529      *
085800200529     C                   CALL      'AOBANKR0'
085900200529     C                   PARM      *BLANKS       WLRTCD            7
086000200529     C                   PARM      '*FIRST'      WLOPTN            7
086100200529     C     SDBANK        PARM      SDBANK        DSSDY
086200200529      *
086300200529      ** If record not found
086400200529      *
086500200529     C     WLRTCD        IFNE      *BLANKS
086600200529     C                   MOVEL     '001'         DBASE             3 0          *****************
086700200529     C                   MOVE      'SDBANKPD'    DBFILE           10            * DB ERROR 01   *
086800200529     C                   MOVEL     *BLANKS       DBKEY            29            *****************
086900200529     C                   EXSR      *PSSR
087000200529     C                   ENDIF
087100200529      *
087200200529     C                   MOVE      BJMRDT        ##MRDT                         Midas Run date
087300200529      *
087400200529      ** Determine date format
087500200529      *
087600200529     C     BJDFIN        IFEQ      'M'
087700200529     C                   MOVE      '1'           *IN98
087800200529     C                   ENDIF
087900200529      *
088000200529      ** Access to SE Trading data to retrieve the back value period
088100200529      *
088200200529     C                   CALL      'AOSTRDR0'
088300200529     C                   PARM      *BLANKS       WLRTCD
088400200529     C                   PARM      '*FIRST'      WLOPTN
088500200529     C     SDSTRD        PARM      SDSTRD        DSSDY
088600200529      *
088700200529      ** If record is not found
088800200529      *
088900200529     C     WLRTCD        IFNE      *BLANKS
089000200529     C                   MOVEL     '002'         DBASE                          *****************
089100200529     C                   MOVE      'SDSTRDPD'    DBFILE                         * DB ERROR 02   *
089200200529     C                   MOVEL     *BLANKS       DBKEY                          *****************
089300200529     C                   EXSR      *PSSR
089400200529     C                   ENDIF
089500200529      *
089600200529      ** Calculate Retention Periods
089700200529      *
089800200529     C                   Z-ADD     *ZEROS        WK3N              3 0
089900200529     C     31            MULT      BVROPS        WK3N
090000200529     C     BJRDNB        SUB       WK3N          RTNPOS            5 0
090100200529      *
090200200529     C                   Z-ADD     *ZEROS        WK3N
090300200529     C     31            MULT      BVROST        WK3N
090400200529     C     BJRDNB        SUB       WK3N          RTNTRD            5 0
090500200529      *
090600200529      ** Access SDBRCHPD using the default user branch
090700200529      *
090800200529     C**********         CALL      'AOBRCHR0'                                                 CGL029
090900200529     C                   CALL      'AOBRCHR1'                                                 CGL029
091000200529     C                   PARM      *BLANKS       WLRTCD
091100200529     C                   PARM      '*KEY   '     WLOPTN
091200200529     C                   PARM      BVBRCD        WLBRCH            3
091300200529     C     SDBRCH        PARM      SDBRCH        DSSDY
091400200529      *
091500200529      ** Check if error occurred
091600200529      *
091700200529     C     WLRTCD        IFNE      *BLANKS
091800200529     C                   MOVEL     '003'         DBASE                          *****************
091900200529     C                   MOVE      'SDBRCHPD'    DBFILE                         * DB ERROR 03   *
092000200529     C                   MOVEL     *BLANKS       DBKEY                          *****************
092100200529     C                   MOVEL     BVBRCD        DBKEY
092200200529     C                   EXSR      *PSSR
092300200529     C                   ENDIF
092400200529                                                                                              CGL031
092500200529      ** Check if CGL031 is enabled.                                                          CGL031
092600200529                                                                                              CGL031
092700200529     C                   CALL      'AOSARDR0'                                                 CGL031
092800200529     C                   PARM      *BLANKS       PRetCde                                      CGL031
092900200529     C                   PARM      '*VERIFY'     POption                                      CGL031
093000200529     C                   PARM      'CGL031'      PSARD                                        CGL031
093100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
093200200529                                                                                              CGL031
093300200529     C                   EVAL      CGL031 = 'N'                                               CGL031
093400200529     C                   EVAL      *IN60 = *OFF                                               CGL031
093500200529                                                                                              CGL031
093600200529     C                   IF        PRetCde = *BLANKS                                          CGL031
093700200529     C                   EVAL      CGL031 = 'Y'                                               CGL031
093800200529     C                   EVAL      *IN06 = *ON                                                CGL031
093900200529     C                   ELSE                                                                 CGL031
094000200529                                                                                              CGL031
094100200529     C                   IF        PRetCde <> *BLANKS                                         CGL031
094200200529     C     *LOCK         IN        LDA                                                        CGL031
094300200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
094400200529     C                   EVAL      DBKey = 'CGL031'                                           CGL031
094500200529     C                   EVAL      DBase = 101                                                CGL031
094600200529     C                   OUT       LDA                                                        CGL031
094700200529     C                   ENDIF                                                                CGL031
094800200529                                                                                              CGL031
094900200529     C                   ENDIF                                                                CGL031
095000200529      *
095100200529      ** Calculate the SE Backvalue date
095200200529      *
095300200529     C     BJRDNB        SUB       BVBVP         WBACKD            5 0
095400200529      *
095500200529      ** If the 'ACTION' parameter is equal to 'E' or 'R'
095600200529      ** Seton indicator for Enquiry mode or Report mode
095700200529      *
095800200529     C     P#ACTN        IFEQ      'E'
095900200529     C     P#ACTN        OREQ      'R'
096000200529     C                   MOVE      '1'           *IN61
096100200529     C                   MOVEA     TXT(1)        ##CTX1
096200200529      *
096300200529     C     P#ACTN        IFEQ      'R'
096400200529     C                   MOVE      '1'           *IN64
096500200529     C                   ENDIF
096600200529     C                   ENDIF
096700200529      *
096800200529      ** If the 'ACTION' Parameter is equal to 'A'
096900200529      ** Seton indicator for 'UPDATE' Mode
097000200529      *
097100200529     C     P#ACTN        IFEQ      'A'
097200200529      *
097300200529      ** Access the ER References file to see if there is record in the file
097400200529      *
097500200529     C     P#REFN        SETLL     SECORFLA
097600200529     C     P#REFN        READE     SECORFLA                               89
097700200529      *
097800200529      ** If record is not found, seton the indicator of 'ADD MODE'
097900200529      *
098000200529     C     *IN89         IFEQ      '1'
098100200529     C                   MOVE      '0'           *IN43
098200200529     C                   MOVEA     TXT(10)       ##CTX1
098300200529      *
098400200529      ** If record is not found, seton the indicator of 'AMEND MODE'
098500200529      *
098600200529     C                   ELSE
098700200529     C                   MOVE      '1'           *IN43
098800200529     C                   MOVEA     TXT(9)        ##CTX1
098900200529     C                   ENDIF
099000200529     C                   ENDIF
099100200529      *
099200200529      ** Only to declare the file in 'ADD' mode
099300200529      *
099400200529     C     *IN99         IFEQ      '0'
099500200529     C     *IN99         ANDEQ     '1'
099600200529     C                   WRITE     SECODRD0
099700200529     C                   WRITE     SECODPD0
099800200529     C                   WRITE     SECOALD0
099900200529     C                   WRITE     SECORED0
100000200529     C                   WRITE     SECORHD0
100100200529     C                   ENDIF
100200200529      *
100300200529      ** Retrieve next Reference Number
100400200529      *
100500200529     C     *LOVAL        SETLL     SECORFPA
100600200529     C                   READ(N)   SECORFPA                               89
100700200529      *
100800200529      ** If record not found
100900200529      *
101000200529     C     *IN89         IFEQ      '1'
101100200529     C                   MOVE      'D'           MXRECI
101200200529     C                   Z-ADD     BJRDNB        MXLCD
101300200529     C                   MOVE      'I'           MXCHTP
101400200529     C                   MOVE      ##USR         MXLUID
101500200529     C                   MOVE      '000001'      MXCORF
101600200529     C                   WRITE     SECORFP0
101700200529     C                   ENDIF
101800200529      *
101900200529     C                   MOVE      MXCORF        WWCORF            6 0
102000200529     C                   MOVE      MXCORF        W1CORF            6 0
102100200529      *
102200200529      ** Select the program msgq for error msg
102300200529      *
102400200529     C                   MOVEL     '*'           TOPQ             10
102500200529     C                   MOVEL     '*PRV'        TOPRQ             5
102600200529     C                   MOVEL     'SEUSRMSG'    PMSGF            10
102700200529      *
102800200529      ** Fill in fields for subroutine ZASNMS
102900200529      *
103000200529     C                   MOVEL     'SE7502'      ZAPGM            10            Message queue
103100200529     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10            Message file
103200200529     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
103300200529     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
103400200529     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
103500200529     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
103600200529     C                   MOVE      '0'           WIN12
103700200529      *
103800200529      ** Clear messages from program message queue.
103900200529      *
104000200529     C                   CALL      'Y2CLMSC'
104100200529     C                   PARM      ##PGM         ZAPGM            10
104200200529     C                   PARM      '*SAME'       ZAPGRL            5
104300200529      *
104400200529     C                   WRITE     #MSGCTL
104500200529      *
104600200529      *
104700200529     C                   ENDSR
104800200529      *****************************************************************
104900200529      /EJECT
105000200529      *****************************************************************
105100200529      * P003   : Termination Processing                               *
105200200529      *****************************************************************
105300200529      *
105400200529     C     P003          BEGSR
105500200529      *
105600200529      ** Rollback uncommited changes
105700200529      *
105800200529     C                   ROLBK
105900200529      *
106000200529      ** End of program
106100200529      *
106200200529     C                   MOVE      '1'           *INLR
106300200529     C                   RETURN
106400200529      *
106500200529     C                   ENDSR
106600200529      *****************************************************************
106700200529      /EJECT
106800200529      *****************************************************************
106900200529      * P004  - To clear the subfile                                  *
107000200529      *****************************************************************
107100200529     C     P004          BEGSR
107200200529      *
107300200529      ** Clear subfile
107400200529      *
107500200529     C                   MOVE      '1'           *IN80
107600200529     C                   WRITE     SE7502C0
107700200529     C                   MOVE      '0'           *IN80
107800200529     C                   MOVE      '0'           *IN81
107900200529     C                   Z-ADD     0             #1RRN
108000200529      *
108100200529     C                   ENDSR
108200200529      *****************************************************************
108300200529      /EJECT
108400200529      *****************************************************************
108500200529      * P005   : Build the subfile for add mode                       *
108600200529      *****************************************************************
108700200529      *
108800200529     C     P005          BEGSR
108900200529      *
109000200529      ** Clear messages from program message queue.
109100200529      *
109200200529     C                   CALL      'Y2CLMSC'
109300200529     C                   PARM      ##PGM         ZAPGM            10
109400200529     C                   PARM      '*SAME'       ZAPGRL            5
109500200529      *
109600200529      ** Load a Blank Subfile Page
109700200529      *
109800200529     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
109900200529      *
110000200529      ** Init screen line number
110100200529      *
110200200529     C                   Z-ADD     0             WWCPT             2 0
110300200529      *
110400200529      ** Load subfile
110500200529      *
110600200529     C     WWCPT         DOWLT     15
110700200529      *
110800200529     C                   ADD       1             #1RRN                81        SFLRCDNBR
110900200529     C                   ADD       1             WWCPT                          SCREEN LINE NBR
111000200529      *
111100200529      ** Clear sfl fields
111200200529      *
111300200529     C                   EXSR      P015
111400200529      *
111500200529      ** Add record in subfile
111600200529      *
111700200529     C                   WRITE     SE7502S0
111800200529     C                   ENDDO
111900200529      *
112000200529      ** Save position
112100200529      *
112200200529     C                   Z-ADD     #1RRN         WWRRN                          Save Sfl.Rcd.Nbr.
112300200529      *
112400200529     C                   ENDSR
112500200529      *****************************************************************
112600200529      /EJECT
112700200529      *****************************************************************
112800200529      * P006   : Build the Subfile for Amend/Enquiry Mode             *
112900200529      *****************************************************************
113000200529      *
113100200529     C     P006          BEGSR
113200200529      *
113300200529     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
113400200529      *
113500200529     C     *IN27         IFEQ      '1'
113600200529     C     *IN43         ANDEQ     '1'
113700200529     C     *IN27         OREQ      '1'
113800200529     C     *IN61         ANDEQ     '1'
113900200529      *
114000200529     C     #1RRN         CHAIN     SE7502S0                           88
114100200529     C                   MOVE      #1REFN        KREFN
114200200529     C                   MOVE      #1SECN        KSECN
114300200529      *
114400200529     C                   MOVE      #1EXDT        DateIn
114500200529     C                   EXSR      ZDATE1
114600200529     C                   Z-ADD     DAYNOOUT      KEXDT
114700200529      *
114800200529     C                   ENDIF
114900200529      *
115000200529     C     P#REFN        SETLL     SECORFLA
115100200529     C     P#REFN        READE     SECORFLA                               30
115200200529      *
115300200529     C                   Z-ADD     0             WWCPT             2 0
115400200529     C     *IN30         DOWEQ     '0'
115500200529     C     WWCPT         ANDLT     15
115600200529      *
115700200529      ** Retrieve the "higher" status and final allocation indicator
115800200529      *
115900200529     C                   MOVE      *BLANKS       #1STAT
116000200529     C                   MOVE      *BLANKS       #1FINA
116100200529     C                   MOVE      'Y'           WFIRST            1
116200200529      *
116300200529     C     MACORF        SETLL     SECODRL1
116400200529     C     MACORF        READE     SECODRL1                               89
116500200529      *
116600200529     C     *IN89         IFEQ      '1'
116700200529     C                   MOVE      MASTAT        #1STAT
116800200529     C                   ENDIF
116900200529      *
117000200529     C     *IN89         DOWEQ     '0'
117100200529      *
117200200529     C     MSRECI        IFEQ      'D'
117300200529      *
117400200529     C     WFIRST        IFEQ      'Y'
117500200529     C                   MOVE      MSFAID        #1FINA
117600200529     C                   MOVE      MSCOST        #1STAT
117700200529     C                   MOVE      'N'           WFIRST
117800200529     C                   ELSE
117900200529      *
118000200529      ** Retrieve the "higher" final allocation indicator
118100200529      *
118200200529     C     MSFAID        IFEQ      'Y'
118300200529     C                   MOVE      MSFAID        #1FINA
118400200529     C                   ELSE
118500200529     C     MSFAID        IFEQ      'S'
118600200529     C     #1FINA        ANDEQ     'N'
118700200529     C                   MOVE      MSFAID        #1FINA
118800200529     C                   ENDIF
118900200529     C                   ENDIF
119000200529      *
119100200529      ** Retrieve the "higher" Status
119200200529      *
119300200529     C     MSCOST        IFEQ      'C'
119400200529     C                   MOVE      MSCOST        #1STAT
119500200529     C                   ELSE
119600200529     C     MSCOST        IFEQ      'X'
119700200529     C     #1STAT        IFEQ      'S'
119800200529     C     #1STAT        OREQ      'L'
119900200529     C     #1STAT        OREQ      'I'
120000200529     C                   MOVE      MSCOST        #1STAT
120100200529     C                   ENDIF
120200200529     C                   ENDIF
120300200529      *
120400200529     C     MSCOST        IFEQ      'S'
120500200529     C     #1STAT        IFEQ      'L'
120600200529     C     #1STAT        OREQ      'I'
120700200529     C                   MOVE      MSCOST        #1STAT
120800200529     C                   ENDIF
120900200529     C                   ENDIF
121000200529      *
121100200529     C     MSCOST        IFEQ      'L'
121200200529     C     #1STAT        ANDEQ     'I'
121300200529     C                   MOVE      MSCOST        #1STAT
121400200529     C                   ENDIF
121500200529     C                   ENDIF
121600200529     C                   ENDIF
121700200529     C                   ENDIF
121800200529      *
121900200529     C     MACORF        READE     SECODRL1                               89
122000200529     C                   ENDDO
122100200529      *
122200200529     C     #1FINA        IFEQ      *BLANKS
122300200529     C     #1STAT        ANDEQ     *BLANKS
122400200529     C                   MOVE      'N'           #1FINA
122500200529     C                   MOVE      'I'           #1STAT
122600200529     C                   ENDIF
122700200529      *
122800200529      ** If Amend mode and Cmd 9 not pressed
122900200529      ** or if add Mode and Cmd 9 pressed
123000200529      *
123100200529     C     *IN43         IFEQ      '1'
123200200529     C     *IN09         ANDEQ     '0'
123300200529     C     *IN43         OREQ      '0'
123400200529     C     *IN09         ANDEQ     '1'
123500200529      *
123600200529      ** If 'Lockec bu User Identifier' is not blank
123700200529      **     protect all subfile record fields
123800200529      *
123900200529     C     MAUSER        IFNE      *BLANKS
124000200529     C                   MOVE      '1'           *IN63
124100200529     C                   ELSE
124200200529     C                   MOVE      '0'           *IN63
124300200529     C                   ENDIF
124400200529      *
124500200529      ** If 'Corporate Action Status' is 'I' or 'L' and Final Indicator 'N  '
124600200529      **     non-protect 'EX-DATE' subfile field
124700200529      *
124800200529     C     #1STAT        IFEQ      'I'
124900200529     C     #1STAT        OREQ      'L'
125000200529     C     #1FINA        ANDEQ     'N'
125100200529     C                   MOVE      '0'           *IN59
125200200529     C                   ELSE
125300200529     C                   MOVE      '1'           *IN59
125400200529     C                   ENDIF
125500200529      *
125600200529      ** If 'Corporate Action Status' is equal to S/X/C/R, protect
125700200529      ** Allocation
125800200529      *
125900200529     C     #1STAT        IFEQ      'S'
126000200529     C     #1STAT        OREQ      'X'
126100200529     C     #1STAT        OREQ      'C'
126200200529     C     #1STAT        OREQ      'R'
126300200529     C                   MOVE      '0'           *IN48
126400200529     C                   ELSE
126500200529     C                   MOVE      '1'           *IN48
126600200529     C                   ENDIF
126700200529     C                   ENDIF
126800200529      *
126900200529      ** If 'Corporate Action Status' is 'C' or 'R', Protect Date
127000200529      ** of Announcement
127100200529      *
127200200529     C     #1STAT        IFEQ      'C'
127300200529     C     #1STAT        OREQ      'R'
127400200529     C                   MOVE      '1'           *IN75
127500200529     C                   ELSE
127600200529     C                   MOVE      '0'           *IN75
127700200529     C                   ENDIF
127800200529      *
127900200529     C                   ADD       1             WWCPT                          Screen Line Nbr
128000200529     C                   ADD       1             #1RRN                81        SFLRCDNBR
128100200529     C                   EXSR      P015
128200200529     C                   EXSR      P016
128300200529     C                   WRITE     SE7502S0
128400200529     C     MAPREF        READE     SECORFLA                               30
128500200529     C                   ENDDO
128600200529      *
128700200529      ** Save Position
128800200529      *
128900200529     C                   Z-ADD     #1RRN         WWRRN                          Save Sfl.Rcd.Nbr.
129000200529      *
129100200529      ** If it's not a rollup
129200200529      *
129300200529     C     *IN27         IFEQ      '0'
129400200529     C                   Z-ADD     1             #1RRN
129500200529     C                   ENDIF
129600200529      *
129700200529      ** If no records found, display error message
129800200529      ** Send message 'NO DATA TO DISPLAY'
129900200529      *
130000200529     C     WWCPT         IFEQ      *ZEROS
130100200529     C                   MOVEL     'CO00001'     ZAMSID                         Message id.
130200200529     C                   EXSR      ZASNMS                                       Send message
130300200529     C                   ENDIF
130400200529     C                   ENDSR
130500200529      *****************************************************************
130600200529      /EJECT
130700200529      *****************************************************************
130800200529      * P008   : Validate Subfile Records                             *
130900200529      *****************************************************************
131000200529      *
131100200529     C     P008          BEGSR
131200200529      *
131300200529     C                   MOVE      'N'           ERMSG             1
131400200529     C                   MOVE      'N'           WRBLD
131500200529      *
131600200529      ** Clear messages from program message queue.
131700200529      *
131800200529     C                   CALL      'Y2CLMSC'
131900200529     C                   PARM      ##PGM         ZAPGM            10
132000200529     C                   PARM      '*SAME'       ZAPGRL            5
132100200529      *
132200200529      ** Read changed subfile record
132300200529      *
132400200529     C                   READC     SE7502S0                               87
132500200529      *
132600200529      ** Setup the RRN with the current CPF's Position within the subfile
132700200529      *
132800200529     C     *IN87         IFEQ      '1'
132900200529     C                   Z-ADD     CPFPOS        #1RRN
133000200529     C                   ENDIF
133100200529      *
133200200529      ** Do while end of file is not reached and F12 or F3 not pressed
133300200529      *
133400200529     C     *IN87         DOWEQ     '0'
133500200529     C     *INKC         ANDEQ     '0'
133600200529     C     *INKL         ANDEQ     '0'
133700200529      *
133800200529      ** Reinitialize error indicators
133900200529      *
134000200529     C                   EXSR      P014
134100200529      *
134200200529     C                   MOVE      '1'           *IN84                          SFLNXTCHG
134300200529      *
134400200529      ** If 'ADD MODE'
134500200529      *
134600200529     C     *IN43         IFEQ      '0'
134700200529     C     *IN61         ANDEQ     '0'
134800200529      *
134900200529      ** If at least one field is different than blanks
135000200529      *
135100200529     C     #1SECN        IFNE      *BLANKS
135200200529     C     #1COAT        ORNE      *BLANKS
135300200529     C     #1COAN        ORNE      *BLANKS
135400200529     C     #1EXDT        ORNE      *BLANKS
135500200529     C     #1ALEF        ORNE      *BLANKS
135600200529     C     #1NBOP        ORNE      *BLANKS
135700200529      *
135800200529      ** If 'SECURITY SHORTNAME' left blank
135900200529      *
136000200529     C     #1SECN        IFEQ      *BLANKS
136100200529     C                   MOVE      'Y'           ERMSG
136200200529     C                   MOVE      '1'           *IN39                          Reverse image
136300200529     C                   MOVEL     'CO00005'     ZAMSID                         Message id.
136400200529     C                   EXSR      ZASNMS                                       Send message
136500200529     C                   ELSE
136600200529      *
136700200529      ** Check Security shortname
136800200529      ** Access Security details with current security shortname
136900200529      *
137000200529     C     #1SECN        CHAIN     SECTYZ1                            89
137100200529      *
137200200529      ** If record is not found or is found byt not "Live"
137300200529      *
137400200529     C     *IN89         IFEQ      '1'
137500200529     C     *IN89         OREQ      '0'
137600200529     C     RECI          ANDNE     'D'
137700200529     C                   MOVE      'Y'           ERMSG
137800200529     C                   MOVE      '1'           *IN39                          Reverse image
137900200529     C                   MOVEL     'CO00007'     ZAMSID                         Message id.
138000200529     C                   EXSR      ZASNMS                                       Send message
138100200529     C                   ELSE
138200200529      *
138300200529      ** For Corporate Action with processing type 'DV'
138400200529      *
138500200529     C     MMPTYP        IFEQ      'DV'
138600200529      *
138700200529      ** Access Investment Type file
138800200529      *
138900200529     C                   MOVE      NMCY          KNMCY             3
139000200529     C                   MOVE      SITP          KSITP             3
139100200529      *
139200200529     C     KEY3          CHAIN     INVTP                              89
139300200529      *
139400200529      ** If no record found
139500200529      *
139600200529     C     *IN89         IFEQ      '1'
139700200529     C                   MOVEL     NMCY          WFLD1             6
139800200529     C                   MOVE      SITP          WFLD1
139900200529     C                   MOVEL     '004'         DBASE                          *****************
140000200529     C                   MOVE      'INVTP   '    DBFILE                         * DB ERROR 04   *
140100200529     C                   MOVEL     WFLD1         DBKEY                          *****************
140200200529     C                   EXSR      *PSSR
140300200529     C                   ENDIF
140400200529      *
140500200529      ** Processing type must be '4' or '7'
140600200529      *
140700200529     C     PROT          IFNE      '4'
140800200529     C     PROT          ANDNE     '7'
140900200529     C                   MOVE      'Y'           ERMSG
141000200529     C                   MOVE      '1'           *IN39                          Reverse image
141100200529     C                   MOVEL     'CO00012'     ZAMSID                         Message id.
141200200529     C                   EXSR      ZASNMS                                       Send message
141300200529     C                   ENDIF
141400200529     C                   ENDIF
141500200529      *
141600200529      ** Validate security of the child if its equal to new security
141700200529      ** of the parent
141800200529      *
141900200529      *
142000200529     C                   Z-ADD     1             X                 2 0
142100200529     C                   SELECT
142200200529     C                   WHEN      P#PTYP = 'DV'
142300200529     C     P#REFN        SETLL     SECODVL0
142400200529     C     P#REFN        READE     SECODVL0                               89
142500200529     C     *IN89         DOWEQ     '0'
142600200529      *
142700200529      ** Security should be equal to new security of the parent. If new
142800200529      ** security is blanks, then use the old security of the parent
142900200529      *
143000200529     C     MDNSEC        IFEQ      *BLANKS
143100200529     C                   MOVEA     P#SESN        NSAR(X)
143200200529     C                   ELSE
143300200529     C                   MOVEA     MDNSEC        NSAR(X)
143400200529     C                   ENDIF
143500200529     C                   ADD       1             X
143600200529      *
143700200529     C     P#REFN        READE     SECODVL0                               89
143800200529     C                   ENDDO
143900200529      *
144000200529     C                   WHEN      P#PTYP = 'FR'
144100200529     C     P#REFN        SETLL     SECOFRL0
144200200529     C     P#REFN        READE     SECOFRL0                               89
144300200529     C     *IN89         DOWEQ     '0'
144400200529      *
144500200529      ** Security should be equal to new security of the parent. If new
144600200529      ** security is blanks, then use the old security of the parent
144700200529      *
144800200529     C     MENSEC        IFEQ      *BLANKS
144900200529     C                   MOVEA     P#SESN        NSAR(X)
145000200529     C                   ELSE
145100200529     C                   MOVEA     MENSEC        NSAR(X)
145200200529     C                   ENDIF
145300200529     C                   ADD       1             X
145400200529      *
145500200529     C     P#REFN        READE     SECOFRL0                               89
145600200529     C                   ENDDO
145700200529      *
145800200529     C                   WHEN      P#PTYP = 'CR'
145900200529     C     P#REFN        SETLL     SECOCRL0
146000200529     C     P#REFN        READE     SECOCRL0                               89
146100200529     C     *IN89         DOWEQ     '0'
146200200529      *
146300200529      ** Security should be equal to new security of the parent. If new
146400200529      ** security is blanks, then use the old security of the parent
146500200529      *
146600200529     C     MHSECA        IFEQ      *BLANKS
146700200529     C                   MOVEA     P#SESN        NSAR(X)
146800200529     C                   ELSE
146900200529     C                   MOVEA     MHSECA        NSAR(X)
147000200529     C                   ENDIF
147100200529     C                   ADD       20            X
147200200529      *
147300200529     C     P#REFN        READE     SECOCRL0                               89
147400200529     C                   ENDDO
147500200529      *
147600200529     C                   WHEN      P#PTYP = 'OF'
147700200529     C     P#REFN        SETLL     SECOOFL0
147800200529     C     P#REFN        READE     SECOOFL0                               89
147900200529     C     *IN89         DOWEQ     '0'
148000200529      *
148100200529      ** Security should be equal to new security of the parent. If new
148200200529      ** security is blanks, then use the old security of the parent
148300200529      *
148400200529     C     MINSEC        IFEQ      *BLANKS
148500200529     C                   MOVEA     P#SESN        NSAR(X)
148600200529     C                   ELSE
148700200529     C                   MOVEA     MINSEC        NSAR(X)
148800200529     C                   ENDIF
148900200529     C                   ADD       1             X
149000200529      *
149100200529     C     P#REFN        READE     SECOOFL0                               89
149200200529     C                   ENDDO
149300200529      *
149400200529     C                   WHEN      P#PTYP = 'RG'
149500200529     C     P#REFN        SETLL     SECORGL0
149600200529     C     P#REFN        READE     SECORGL0                               89
149700200529     C     *IN89         DOWEQ     '0'
149800200529      *
149900200529      ** Security should be equal to new security of the parent. If new
150000200529      ** security is blanks, then use the old security of the parent
150100200529      *
150200200529     C     MFNSEC        IFEQ      *BLANKS
150300200529     C                   MOVEA     P#SESN        NSAR(X)
150400200529     C                   ELSE
150500200529     C                   MOVEA     MFNSEC        NSAR(X)
150600200529     C                   ENDIF
150700200529     C                   ADD       1             X
150800200529      *
150900200529     C     P#REFN        READE     SECORGL0                               89
151000200529     C                   ENDDO
151100200529      *
151200200529     C                   WHEN      P#PTYP = 'EX'
151300200529     C     P#REFN        SETLL     SECOEXL0
151400200529     C     P#REFN        READE     SECOEXL0                               89
151500200529     C     *IN89         DOWEQ     '0'
151600200529      *
151700200529      ** Security should be equal to new security of the parent. If new
151800200529      ** security is blanks, then use the old security of the parent
151900200529      *
152000200529     C     MJNSEC        IFEQ      *BLANKS
152100200529     C                   MOVEA     P#SESN        NSAR(X)
152200200529     C                   ELSE
152300200529     C                   MOVEA     MJNSEC        NSAR(X)
152400200529     C                   ENDIF
152500200529     C                   ADD       1             X
152600200529      *
152700200529     C     P#REFN        READE     SECOEXL0                               89
152800200529     C                   ENDDO
152900200529      *
153000200529     C                   WHEN      P#PTYP = 'CC'
153100200529     C     P#REFN        SETLL     SECOCCL0
153200200529     C     P#REFN        READE     SECOCCL0                               89
153300200529     C     *IN89         DOWEQ     '0'
153400200529      *
153500200529      ** Security should be equal to new security of the parent. If new
153600200529      ** security is blanks, then use the old security of the parent
153700200529      *
153800200529     C     NANSEC        IFEQ      *BLANKS
153900200529     C                   MOVEA     P#SESN        NSAR(X)
154000200529     C                   ELSE
154100200529     C                   MOVEA     NANSEC        NSAR(X)
154200200529     C                   ENDIF
154300200529     C                   ADD       1             X
154400200529      *
154500200529     C     P#REFN        READE     SECOCCL0                               89
154600200529     C                   ENDDO
154700200529      *
154800200529     C                   WHEN      P#PTYP = 'NC'
154900200529     C     P#REFN        SETLL     SECONCL0
155000200529     C     P#REFN        READE     SECONCL0                               89
155100200529     C     *IN89         DOWEQ     '0'
155200200529      *
155300200529      ** Security should be equal to new security of the parent. If new
155400200529      ** security is blanks, then use the old security of the parent
155500200529      *
155600200529     C                   MOVEA     MLSESN        NSAR(X)
155700200529     C                   ADD       1             X
155800200529      *
155900200529     C     P#REFN        READE     SECONCL0                               89
156000200529     C                   ENDDO
156100200529      *
156200200529     C                   ENDSL
156300200529      *
156400200529      ** Validate security of the child such that it is equal to
156500200529      ** new security of the parent
156600200529      *
156700200529     C     #1SECN        LOOKUP    NSAR                                   89
156800200529     C     *IN89         IFEQ      '0'
156900200529     C                   MOVE      'Y'           ERMSG
157000200529     C                   MOVE      '1'           *IN39
157100200529     C                   MOVEL     'CO00367'     ZAMSID
157200200529     C                   EXSR      ZASNMS
157300200529     C                   ENDIF
157400200529
157500200529      *
157600200529     C                   ENDIF
157700200529     C                   ENDIF
157800200529      *
157900200529      ** If 'Action type' Left Blank
158000200529      *
158100200529     C     #1COAT        IFEQ      *BLANKS
158200200529     C                   MOVE      'Y'           ERMSG
158300200529     C                   MOVE      '1'           *IN33                          Reverse image
158400200529     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
158500200529     C                   EXSR      ZASNMS                                       Send message
158600200529     C                   ELSE
158700200529      *
158800200529      ** Corporate action type must be a live action type
158900200529      *
159000200529     C     #1COAT        CHAIN     SECOATL0                           89
159100200529      *
159200200529     C     *IN89         IFEQ      '1'
159300200529     C     MMRECI        ORNE      'D'
159400200529     C                   MOVE      'Y'           ERMSG
159500200529     C                   MOVE      '1'           *IN33                          Reverse image
159600200529     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
159700200529     C                   EXSR      ZASNMS                                       Send message
159800200529     C                   ENDIF
159900200529      *
160000200529     C     *IN89         IFEQ      '0'
160100200529     C     MMPTYP        ANDEQ     'CC'
160200200529     C                   MOVE      'Y'           ERMSG
160300200529     C                   MOVE      '1'           *IN33                          Reverse image
160400200529     C                   MOVEL     'CO00577'     ZAMSID                         Message id.
160500200529     C                   EXSR      ZASNMS                                       Send message
160600200529     C                   ENDIF
160700200529     C                   ENDIF
160800200529      *
160900200529      ** Validation 'Number of Option'
161000200529      *
161100200529     C     #1NBOP        IFNE      *BLANKS
161200200529      *
161300200529     C                   MOVE      *BLANKS       ZFIELD
161400200529     C                   MOVEL     #1NBOP        ZFIELD
161500200529     C                   Z-ADD     2             ZADIG
161600200529     C                   Z-ADD     0             ZADEC
161700200529      *
161800200529     C                   EXSR      ZALIGN
161900200529      *
162000200529     C                   MOVE      ZFIELD        #1NBOP
162100200529     C                   MOVE      #1NBOP        W1NBOP
162200200529      *
162300200529      ** If it's not a valid numeric field between 1 and 9
162400200529      *
162500200529     C     ZALIGNok      IFEQ      'N'
162600200529     C     W1NBOP        ORLT      1
162700200529     C     W1NBOP        ORGT      9
162800200529     C                   MOVE      'Y'           ERMSG
162900200529     C                   MOVE      '1'           *IN29                          Reverse image
163000200529     C                   MOVEL     'CO00042'     ZAMSID                         Message id.
163100200529     C                   EXSR      ZASNMS                                       Send message
163200200529     C                   ELSE
163300200529     C     MMPTYP        IFEQ      'NF'
163400200529     C     W1NBOP        ANDNE     1
163500200529     C     MMPTYP        OREQ      'NC'
163600200529     C     W1NBOP        ANDNE     1
163700200529     C     MMPTYP        OREQ      'CC'
163800200529     C     W1NBOP        ANDNE     1
163900200529     C                   MOVE      'Y'           ERMSG
164000200529     C                   MOVE      '1'           *IN29                          Reverse image
164100200529     C                   MOVEL     'CO00261'     ZAMSID                         Message id.
164200200529     C                   EXSR      ZASNMS                                       Send message
164300200529     C                   ENDIF
164400200529     C                   ENDIF
164500200529      *
164600200529     C                   ELSE
164700200529     C                   MOVE      '01'          #1NBOP
164800200529     C                   ENDIF
164900200529      *
165000200529     C                   ENDIF
165100200529     C                   ENDIF
165200200529      *
165300200529      ** If not enquiry mode
165400200529      *
165500200529     C     *IN61         IFEQ      '0'
165600200529      *
165700200529      ** If at least one field is different than blank
165800200529      *
165900200529     C     #1EXDT        IFNE      *BLANKS
166000200529     C     #1REFN        ORNE      *BLANKS
166100200529     C     #1SECN        ORNE      *BLANKS
166200200529     C     #1ALEF        ORNE      *BLANKS
166300200529     C     #1COAN        ORNE      *BLANKS
166400200529      *
166500200529      ** If last allocation date is changed
166600200529      *
166700200529     C     #1COAN        IFNE      #2COAN
166800200529     C     #1COAN        ANDNE     *BLANKS
166900200529      *
167000200529     C                   MOVE      #1COAN        DateIn
167100200529     C                   EXSR      ZDATE1
167200200529      *
167300200529      ** If date of announcement is not a valid date format
167400200529      *
167500200529     C     ErrorFlag     IFEQ      'Y'
167600200529     C                   MOVE      'Y'           ERMSG
167700200529     C                   MOVE      '1'           *IN37                          Reverse image
167800200529     C                   MOVEL     'CO00033'     ZAMSID                         Message id.
167900200529     C                   EXSR      ZASNMS                                       Send message
168000200529     C                   ENDIF
168100200529     C                   ENDIF
168200200529      *
168300200529      ** If Ex-date is changed
168400200529      *
168500200529     C     #1EXDT        IFNE      #2EXDT
168600200529     C     #1EXDT        ANDNE     *BLANKS
168700200529      *
168800200529     C                   MOVE      #1EXDT        DateIn
168900200529     C                   EXSR      ZDATE1
169000200529      *
169100200529      ** If Ex-date is not a valid date format
169200200529      *
169300200529     C     ErrorFlag     IFEQ      'Y'
169400200529     C                   MOVE      'Y'           ERMSG
169500200529     C                   MOVE      '1'           *IN32                          Reverse image
169600200529     C                   MOVEL     'CO00006'     ZAMSID                         Message id.
169700200529     C                   EXSR      ZASNMS                                       Send message
169800200529     C                   ELSE
169900200529     C                   Z-ADD     DAYNOOUT      WEXDT
170000200529      *
170100200529      ** If Ex-date lower or equal than SE Back Value date
170200200529      *
170300200529     C     WEXDT         IFLE      WBACKD
170400200529     C                   MOVE      'Y'           ERMSG
170500200529     C                   MOVE      '1'           *IN32                          Reverse image
170600200529     C                   MOVEL     'CO00013'     ZAMSID                         Message id.
170700200529     C                   EXSR      ZASNMS                                       Send message
170800200529     C                   ENDIF
170900200529      *
171000200529      ** If Ex-date not lower than security maturity date
171100200529      *
171200200529     C     WEXDT         IFGE      MATY
171300200529     C     MATY          ANDNE     *ZEROS
171400200529     C                   MOVE      'Y'           ERMSG
171500200529     C                   MOVE      '1'           *IN32                          Reverse image
171600200529     C                   MOVEL     'CO00014'     ZAMSID                         Message id.
171700200529     C                   EXSR      ZASNMS                                       Send message
171800200529     C                   ENDIF
171900200529      *
172000200529      ** Validate Ex-date so that it is equal to that of the Parent
172100200529      *
172200200529     C     WEXDT         IFNE      P#COEX
172300200529     C                   MOVE      'Y'           ERMSG
172400200529     C                   MOVE      '1'           *IN32
172500200529     C                   MOVEL     'CO00368'     ZAMSID
172600200529     C                   EXSR      ZASNMS
172700200529     C                   ENDIF
172800200529     C                   ENDIF
172900200529      *
173000200529     C                   ELSE
173100200529     C     P#COEX        IFNE      *ZEROS
173200200529     C     #1EXDT        ANDEQ     *BLANKS
173300200529     C                   MOVE      'Y'           ERMSG
173400200529     C                   MOVE      '1'           *IN32
173500200529     C                   MOVEL     'CO00368'     ZAMSID
173600200529     C                   EXSR      ZASNMS
173700200529     C                   ENDIF
173800200529     C                   ENDIF
173900200529      *
174000200529      ** If Allocation Effective Date is changed
174100200529      *
174200200529     C     #1ALEF        IFNE      #2ALEF
174300200529     C     #1ALEF        ANDNE     *BLANKS
174400200529      *
174500200529      ** If 'Allocation Effective Date' entered
174600200529      *
174700200529     C                   MOVE      #1ALEF        DateIn
174800200529     C                   EXSR      ZDATE1
174900200529      *
175000200529     C                   Z-ADD     DAYNOOUT      WALEF
175100200529      *
175200200529      ** If Allocation Effective Date is not a valid date format
175300200529      *
175400200529     C     ErrorFlag     IFEQ      'Y'
175500200529     C                   MOVE      'Y'           ERMSG
175600200529     C                   MOVE      '1'           *IN28                          Reverse image
175700200529     C                   MOVEL     'CO00041'     ZAMSID                         Message id.
175800200529     C                   EXSR      ZASNMS                                       Send message
175900200529     C                   ENDIF
176000200529      *
176100200529     C     WALEF         IFLT      WEXDT
176200200529     C     *IN99         ANDEQ     '0'
176300200529     C                   MOVE      'Y'           ERMSG
176400200529     C                   MOVE      '1'           *IN28                          Reverse image
176500200529     C                   MOVEL     'CO00251'     ZAMSID                         Message id.
176600200529     C                   EXSR      ZASNMS                                       Send message
176700200529     C                   ENDIF
176800200529      *
176900200529      ** If Date not lower than Security Maturity Date
177000200529      *
177100200529     C     WALEF         IFGE      MATY
177200200529     C     MATY          ANDNE     *ZEROS
177300200529     C                   MOVE      'Y'           ERMSG
177400200529     C                   MOVE      '1'           *IN32                          Reverse image
177500200529     C                   MOVEL     'CO00300'     ZAMSID                         Message id.
177600200529     C                   EXSR      ZASNMS                                       Send message
177700200529     C                   ENDIF
177800200529     C                   ENDIF
177900200529     C                   ENDIF
178000200529     C                   ENDIF
178100200529      *
178200200529      ** If 'Amend Mode' or 'Enquiry' Mode
178300200529      *
178400200529     C     *IN43         IFEQ      '1'
178500200529     C     *IN61         OREQ      '1'
178600200529      *
178700200529      ** If Action indicator is changed
178800200529      *
178900200529     C     #1SEL         IFNE      *BLANKS
179000200529     C                   EXSR      P008A
179100200529     C                   ENDIF
179200200529      *
179300200529      ** Process Action (Only Enquiry Mode)
179400200529      *
179500200529     C     ERMSG         IFEQ      'N'
179600200529     C     *IN61         ANDEQ     '1'
179700200529     C                   EXSR      P009
179800200529     C                   MOVE      '0'           *IN84
179900200529     C                   ENDIF
180000200529     C                   ENDIF
180100200529      *
180200200529      ** If an error message is sent or if 'Add Mode'
180300200529      *
180400200529     C     ERMSG         IFEQ      'Y'
180500200529     C     *IN43         OREQ      '0'
180600200529      *
180700200529      ** If 'Corporate Action Status' is 'I' or 'L' and Final Indicator 'N  '
180800200529      **     Non-protect 'Ex-Date' subfile field (Amend Mode)
180900200529      *
181000200529     C     *IN43         IFEQ      '1'
181100200529      *
181200200529     C     #1STAT        IFEQ      'I'
181300200529     C     #1STAT        OREQ      'L'
181400200529     C     #1FINA        ANDEQ     'N'
181500200529     C                   MOVE      '0'           *IN59
181600200529     C                   ELSE
181700200529     C                   MOVE      '1'           *IN59
181800200529     C                   ENDIF
181900200529      *
182000200529      ** If 'Corporate Action Status' is equal to S/X/C/R, protect Allocation
182100200529      *
182200200529     C     #1STAT        IFEQ      'S'
182300200529     C     #1STAT        OREQ      'X'
182400200529     C     #1STAT        OREQ      'C'
182500200529     C     #1STAT        OREQ      'R'
182600200529     C                   MOVE      '0'           *IN48
182700200529     C                   ELSE
182800200529     C                   MOVE      '1'           *IN48
182900200529     C                   ENDIF
183000200529      *
183100200529      ** If 'Corporate Action Status' is 'C' or 'R', protect
183200200529      ** Date of Announcement
183300200529      *
183400200529     C     #1STAT        IFEQ      'C'
183500200529     C     #1STAT        OREQ      'R'
183600200529     C                   MOVE      '1'           *IN75
183700200529     C                   ELSE
183800200529     C                   MOVE      '0'           *IN75
183900200529     C                   ENDIF
184000200529      *
184100200529      ** If 'Locked by User Identifier' is not blank protect all
184200200529      ** Subfile record fields
184300200529      *
184400200529     C     #1REFN        CHAIN     SECORFL9                           89
184500200529      *
184600200529     C     MAUSER        IFNE      *BLANKS
184700200529     C                   MOVE      '1'           *IN63
184800200529     C                   ELSE
184900200529     C                   MOVE      '0'           *IN63
185000200529     C                   ENDIF
185100200529      *
185200200529     C                   ENDIF
185300200529      *
185400200529      ** Update subfile record (for reversed error fields)
185500200529      *
185600200529     C                   UPDATE    SE7502S0
185700200529      *
185800200529      ** Goto next read of the subfile changing
185900200529      *
186000200529     C                   GOTO      TAG4
186100200529     C                   ENDIF
186200200529      *
186300200529      ** If 'Amend Mode'
186400200529      *
186500200529     C     *IN43         IFEQ      '1'
186600200529      *
186700200529      ** if Date of Announcement, Ex-Date, Final Indicator, Status or
186800200529      ** Allocation Effective Date is/are changed
186900200529      *
187000200529     C     #1COAN        IFNE      #2COAN
187100200529     C     #1EXDT        ORNE      #2EXDT
187200200529     C     #1ALEF        ORNE      #2ALEF
187300200529      *
187400200529      ** Access Corporate Action Reference file with current reference
187500200529      *
187600200529     C     #1REFN        CHAIN     SECORFL0                           89
187700200529      *
187800200529      ** If record is different than read at changing of subfile
187900200529      *
188000200529     C     FIELD         IFNE      #FIELD
188100200529     C                   MOVE      'Y'           ERMSG
188200200529     C                   MOVE      '1'           *IN28                          Reverse image
188300200529     C                   MOVE      '1'           *IN29                          Reverse image
188400200529     C                   MOVE      '1'           *IN32                          Reverse image
188500200529     C                   MOVE      '1'           *IN33                          Reverse image
188600200529     C                   MOVE      '1'           *IN34                          Reverse image
188700200529     C                   MOVE      '1'           *IN37                          Reverse image
188800200529     C                   MOVE      '1'           *IN38                          Reverse image
188900200529     C                   MOVE      '1'           *IN39                          Reverse image
189000200529     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
189100200529     C                   EXSR      ZASNMS                                       Send message
189200200529      *
189300200529      ** Update subfile record (For reversed error fields)
189400200529      *
189500200529     C                   UPDATE    SE7502S0
189600200529      *
189700200529      ** Release the record
189800200529      *
189900200529     C     #1REFN        SETLL     SECORFL0
190000200529      *
190100200529      ** Goto next read of the subfile changing
190200200529      *
190300200529     C                   GOTO      TAG4
190400200529     C                   ELSE
190500200529      *
190600200529     C                   MOVE      'D'           MARECI
190700200529     C                   Z-ADD     BJRDNB        MALCD
190800200529     C                   MOVE      'A'           MACHTP
190900200529     C                   MOVE      ##USR         MALUID
191000200529      *
191100200529      ** If Date of Announcement changed
191200200529      *
191300200529     C     #1COAN        IFNE      #2COAN
191400200529      *
191500200529     C                   MOVE      #1COAN        DateIn
191600200529     C                   EXSR      ZDATE1
191700200529      *
191800200529     C                   Z-ADD     DAYNOOUT      MACOAN
191900200529     C                   MOVE      #1COAN        #2COAN
192000200529      *
192100200529     C                   ENDIF
192200200529      *
192300200529      ** If Ex-Date Changed
192400200529      *
192500200529     C     #1EXDT        IFNE      #2EXDT
192600200529      *
192700200529     C                   MOVE      #1EXDT        DateIn
192800200529     C                   EXSR      ZDATE1
192900200529      *
193000200529     C                   Z-ADD     DAYNOOUT      MACOEX
193100200529      *
193200200529     C                   MOVE      #1EXDT        #2EXDT
193300200529      *
193400200529     C                   ENDIF
193500200529      *
193600200529      ** If Allocation Effective Date Changed
193700200529      *
193800200529     C     #1ALEF        IFNE      #2ALEF
193900200529      *
194000200529     C                   MOVE      #1ALEF        DateIn
194100200529     C                   EXSR      ZDATE1
194200200529      *
194300200529     C                   Z-ADD     DAYNOOUT      MAALEF
194400200529     C                   MOVE      #1ALEF        #2ALEF
194800200529     C                   ENDIF
194900200529      *
195000200529     C                   UPDATE    SECORFD0
195100200529     C                   MOVE      'Y'           WRBLD
195200200529     C                   MOVE      MAJOBN        WAJOBN           10
195300200529     C                   MOVE      MAUSER        WAUSER           10
195400200529     C                   Z-ADD     MAJNBR        WAJNBR            6 0
195500200529     C                   MOVE      *BLANKS       MAJOBN
195600200529     C                   MOVE      *BLANKS       MAUSER
195700200529     C                   Z-ADD     *ZEROS        MAJNBR
195800200529     C                   MOVE      FIELD         #FIELD
195900200529     C                   MOVE      WAJOBN        MAJOBN
196000200529     C                   MOVE      WAUSER        MAUSER
196100200529     C                   Z-ADD     WAJNBR        MAJNBR
196200200529     C                   ENDIF
196300200529     C                   ENDIF
196400200529      *
196500200529      ** Execute Commitment Control
196600200529      *
196700200529     C                   COMMIT
196800200529      *
196900200529      ** If Action is changed
197000200529      *
197100200529     C     #1SEL         IFNE      #2SEL
197200200529      *
197300200529      ** Access Corporate Action Reference with Current Reference
197400200529      *
197500200529     C     #1REFN        CHAIN     SECORFL0                           89
197600200529      *
197700200529      ** If Record is different than read at changing of subfile
197800200529      *
197900200529     C     FIELD         IFNE      #FIELD
198000200529     C                   MOVE      'Y'           ERMSG
198100200529     C                   MOVE      '1'           *IN28                          Reverse image
198200200529     C                   MOVE      '1'           *IN29                          Reverse image
198300200529     C                   MOVE      '1'           *IN32                          Reverse image
198400200529     C                   MOVE      '1'           *IN33                          Reverse image
198500200529     C                   MOVE      '1'           *IN34                          Reverse image
198600200529     C                   MOVE      '1'           *IN37                          Reverse image
198700200529     C                   MOVE      '1'           *IN38                          Reverse image
198800200529     C                   MOVE      '1'           *IN39                          Reverse image
198900200529     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
199000200529     C                   EXSR      ZASNMS                                       Send message
199100200529      *
199200200529      ** Update subfile record (For Reversed error fields)
199300200529      *
199400200529     C                   UPDATE    SE7502S0
199500200529      *
199600200529      ** Release the record
199700200529      *
199800200529     C     #1REFN        SETLL     SECORFL0
199900200529      *
200000200529      ** Goto next read of the subfile changing
200100200529      *
200200200529     C                   GOTO      TAG4
200300200529     C                   ELSE
200400200529      *
200500200529     C                   MOVE      ##JOB         MAJOBN
200600200529     C                   MOVE      ##USR         MAUSER
200700200529     C                   Z-ADD     ##JNO         MAJNBR
200800200529      *
200900200529      ** Update the record in Corporate Action Reference file
201000200529      *
201100200529     C                   UPDATE    SECORFD0
201200200529     C                   MOVE      MAJOBN        WAJOBN           10
201300200529     C                   MOVE      MAUSER        WAUSER           10
201400200529     C                   Z-ADD     MAJNBR        WAJNBR            6 0
201500200529     C                   MOVE      *BLANKS       MAJOBN
201600200529     C                   MOVE      *BLANKS       MAUSER
201700200529     C                   Z-ADD     *ZEROS        MAJNBR
201800200529     C                   MOVE      FIELD         #FIELD
201900200529     C                   MOVE      WAJOBN        MAJOBN
202000200529     C                   MOVE      WAUSER        MAUSER
202100200529     C                   Z-ADD     WAJNBR        MAJNBR
202200200529      *
202300200529      ** Execute the commitment instruction
202400200529      *
202500200529     C                   COMMIT
202600200529      *
202700200529      ** Process Action
202800200529      *
202900200529     C                   EXSR      P009
203000200529     C                   ENDIF
203100200529     C                   ENDIF
203200200529      *
203300200529      ** If 'Corporate Action Status' is 'I' or 'L' and final ind. 'N'
203400200529      ** Non-protect 'Ex-Date' Subfile field (Amend Mode)
203500200529      *
203600200529     C     #1STAT        IFEQ      'I'
203700200529     C     #1STAT        OREQ      'L'
203800200529     C     #1FINA        ANDEQ     'N'
203900200529     C                   MOVE      '0'           *IN59
204000200529     C                   ELSE
204100200529     C                   MOVE      '1'           *IN59
204200200529     C                   ENDIF
204300200529      *
204400200529      ** If 'Corporate Action Status' is equal to S/X/C/R, protect
204500200529      ** Allocation
204600200529      *
204700200529     C     #1STAT        IFEQ      'S'
204800200529     C     #1STAT        OREQ      'X'
204900200529     C     #1STAT        OREQ      'C'
205000200529     C     #1STAT        OREQ      'R'
205100200529     C                   MOVE      '0'           *IN48
205200200529     C                   ELSE
205300200529     C                   MOVE      '1'           *IN48
205400200529     C                   ENDIF
205500200529      *
205600200529      ** If 'Corporate Action Status' is 'C' or 'R', protect Date
205700200529      ** of Announcement
205800200529      *
205900200529     C     #1STAT        IFEQ      'C'
206000200529     C     #1STAT        OREQ      'R'
206100200529     C                   MOVE      '1'           *IN75
206200200529     C                   ELSE
206300200529     C                   MOVE      '0'           *IN75
206400200529     C                   ENDIF
206500200529      *
206600200529      ** If 'Locked by User Identifier' is not blank, protect all
206700200529      ** Subfile record fields
206800200529      *
206900200529     C     MAUSER        IFNE      *BLANKS
207000200529     C                   MOVE      '1'           *IN63
207100200529     C                   ELSE
207200200529     C                   MOVE      '0'           *IN63
207300200529     C                   ENDIF
207400200529      *
207500200529      ** If no error message sent
207600200529      *
207700200529     C     ERMSG         IFEQ      'N'
207800200529     C                   MOVE      '0'           *IN84
207900200529     C                   UPDATE    SE7502S0
208000200529     C                   ELSE
208100200529     C                   MOVE      '1'           *IN84
208200200529     C                   UPDATE    SE7502S0
208300200529     C                   ENDIF
208400200529     C                   ENDIF
208500200529      *
208600200529     C     TAG4          TAG
208700200529      *
208800200529     C                   WRITE     #MSGCTL
208900200529      *
209000200529      ** Read changed subfile record
209100200529      *
209200200529     C                   READC     SE7502S0                               87
209300200529     C                   ENDDO
209400200529      *
209500200529      ** If 'Add Mode' and if no error message is sent
209600200529      *
209700200529     C     *IN43         IFEQ      '0'
209800200529     C     *IN61         ANDEQ     '0'
209900200529     C     ERMSG         ANDEQ     'N'
210000200529      *
210100200529     C                   Z-ADD     1             #1RRN
210200200529     C                   MOVE      'Y'           FINSR             1
210300200529      *
210400200529      ** Read first record of subfile
210500200529      *
210600200529     C                   READC     SE7502S0                               87
210700200529      *
210800200529      ** Do while end of subfile is not reached
210900200529      *
211000200529     C     *IN87         DOWEQ     '0'
211100200529      *
211200200529      ** Retrieve next available Reference Number
211300200529      *
211400200529     C                   EXSR      P021
211500200529      *
211600200529      ** If Security Shortname is left blank
211700200529      *
211800200529     C     #1SECN        IFNE      *BLANKS
211900200529      *
212000200529      ** Access to ER Reference file with Current Reference
212100200529      *
212200200529     C     #1REFN        CHAIN     SECORFL9                           88
212300200529      *
212400200529      ** If a record is found
212500200529      *
212600200529     C     *IN88         IFEQ      '0'
212700200529     C                   MOVE      '1'           *IN28                          Reverse image
212800200529     C                   MOVE      '1'           *IN29                          Reverse image
212900200529     C                   MOVE      '1'           *IN32                          Reverse image
213000200529     C                   MOVE      '1'           *IN33                          Reverse image
213100200529     C                   MOVE      '1'           *IN34                          Reverse image
213200200529     C                   MOVE      '1'           *IN37                          Reverse image
213300200529     C                   MOVE      '1'           *IN38                          Reverse image
213400200529     C                   MOVE      '1'           *IN39                          Reverse image
213500200529     C                   MOVEL     'CO00002'     ZAMSID                         Message id.
213600200529     C                   EXSR      ZASNMS                                       Send message
213700200529      *
213800200529      ** Update subfile record (for reversed error fields)
213900200529      *
214000200529     C                   UPDATE    SE7502S0
214100200529      *
214200200529      ** Rollback instruction to reverse all inserts
214300200529      *
214400200529     C                   ROLBK
214500200529      *
214600200529      ** Terminate current processing
214700200529      *
214800200529     C                   GOTO      TAG5
214900200529     C                   ELSE
215000200529      *
215100200529      ** Write a record in Corporate Action Reference file
215200200529      *
215300200529     C                   MOVE      'D'           MARECI
215400200529     C                   Z-ADD     BJRDNB        MALCD
215500200529     C                   MOVE      'I'           MACHTP
215600200529     C                   MOVE      ##USR         MALUID
215700200529     C                   MOVE      #1REFN        MACORF
215800200529     C                   MOVE      ##JOB         MAJOBN
215900200529     C                   MOVE      ##USR         MAUSER
216000200529     C                   Z-ADD     ##JNO         MAJNBR
216100200529     C                   MOVE      #1SECN        MASESN
216200200529     C                   MOVE      #1COAT        MACOAT
216300200529      *
216400200529     C     #1COAT        CHAIN     SECOATL0                           89
216500200529     C                   MOVE      MMPTYP        MAPTYP
216600200529      *
216700200529     C     #1COAN        IFNE      *BLANKS
216800200529      *
216900200529     C                   MOVE      #1COAN        DateIn
217000200529     C                   EXSR      ZDATE1
217100200529      *
217200200529     C                   Z-ADD     DAYNOOUT      MACOAN
217300200529     C                   ELSE
217400200529     C                   Z-ADD     *ZEROS        MACOAN
217500200529     C                   ENDIF
217600200529      *
217700200529     C     #1EXDT        IFNE      *BLANKS
217800200529      *
217900200529     C                   MOVE      #1EXDT        DateIn
218000200529     C                   EXSR      ZDATE1
218100200529      *
218200200529     C                   Z-ADD     DAYNOOUT      MACOEX
218300200529     C                   ELSE
218400200529     C                   Z-ADD     *ZEROS        MACOEX
218500200529     C                   ENDIF
218600200529      *
218700200529     C     #1ALEF        IFNE      *BLANKS
218800200529      *
218900200529     C                   MOVE      #1ALEF        DateIn
219000200529     C                   EXSR      ZDATE1
219100200529      *
219200200529     C                   Z-ADD     DAYNOOUT      MAALEF
219300200529     C                   ELSE
219400200529     C                   Z-ADD     *ZEROS        MAALEF
219500200529     C                   ENDIF
219600200529      *
219700200529     C                   MOVE      #1NBOP        MANBOP
219800200529     C                   MOVE      'T'           MATDVD
219900200529     C                   Z-ADD     MAALEF        MACOPD
220000200529     C                   Z-ADD     MAALEF        MATDDT
220100200529     C                   Z-ADD     MACOEX        MAEVDT
220200200529     C                   Z-ADD     *ZEROS        MACPNB
220300200529     C                   Z-ADD     *ZEROS        MASHMD
220400200529     C                   MOVE      'N'           MALTBS
220500200529     C                   Z-ADD     *ZEROS        MAOCPV
220600200529     C                   Z-ADD     *ZEROS        MANCPV
220700200529     C                   Z-ADD     *ZEROS        MAONML
220800200529     C                   Z-ADD     *ZEROS        MANNML
220900200529      *
221000200529     C                   MOVE      MASESN        KSECN
221100200529     C                   Z-ADD     MACOEX        KEXDT
221200200529      *
221300200529     C     KEY7          SETLL     PRICM
221400200529     C                   READ      PRICM                                  89
221500200529      *
221600200529     C     *IN89         IFEQ      '0'
221700200529     C     PSSN          ANDEQ     KSECN
221800200529     C     PVDT          ANDGE     KEXDT
221900200529     C     KEXDT         ANDNE     *ZEROS
222000200529     C                   Z-ADD     PPRC          MACUPC
222100200529     C                   Z-ADD     PPRC          MAEXPC
222200200529     C                   ELSE
222300200529      *
222400200529     C                   MOVE      'PR'          KTYPE
222500200529      *
222600200529     C     KEY5          SETLL     SECED
222700200529     C                   READ      SECED                                  89
222800200529      *
222900200529     C     *IN89         IFEQ      '0'
223000200529     C     SNSN          ANDEQ     KSECN
223100200529     C     SNDT          ANDGE     KEXDT
223200200529     C     SNET          ANDEQ     'PR'
223300200529     C     KEXDT         ANDNE     *ZEROS
223400200529     C                   Z-ADD     SNPR          MACUPC
223500200529     C                   Z-ADD     SNPR          MAEXPC
223600200529     C                   ELSE
223700200529     C     KSECN         CHAIN     SECTYZ1                            89
223800200529     C     *IN89         IFEQ      '0'
223900200529     C                   Z-ADD     MKPR          MACUPC
224000200529     C                   Z-ADD     MKPR          MAEXPC
224100200529     C                   ELSE
224200200529     C                   Z-ADD     *ZEROS        MACUPC
224300200529     C                   Z-ADD     *ZEROS        MAEXPC
224400200529     C                   ENDIF
224500200529     C                   ENDIF
224600200529     C                   ENDIF
224700200529      *
224800200529     C                   Z-ADD     *ZEROS        MACLRD
224900200529     C                   Z-ADD     *ZEROS        MACLRT
225000200529     C                   Z-ADD     *ZEROS        MADLRD
225100200529     C                   Z-ADD     *ZEROS        MADLRT
225200200529     C                   MOVE      'N'           MABLOS
225300200529     C                   MOVE      'N'           MABLOP
225400200529     C                   Z-ADD     *ZEROS        MABFRD
225500200529     C                   Z-ADD     *ZEROS        MABEND
225600200529      *                                                                                       CGL031
225700200529     C                   EVAL      MASETX = *BLANKS                                           CGL031
225800200529      *                                                                                       CGL031
225900200529     C                   IF        CGL031 = 'Y' AND                                           CGL031
226000200529     C                             #1COAT = 'DI'                                              CGL031
226100200529     C                   EVAL      KSECN = #1SECN                                             CGL031
226200200529     C     KSECN         CHAIN     SECTYZ1                                                    CGL031
226300200529     C                   IF        %FOUND                                                     CGL031
226400200529     C                   EVAL      MASETX = SETX                                              CGL031
226500200529     C                   ENDIF                                                                CGL031
226600200529     C                   ENDIF                                                                CGL031
226700200529      *                                                                                       CGL031
226800200529     C                   MOVE      'N'           MAREFO
226900200529     C                   MOVE      *BLANKS       MACONR
227000200529     C                   MOVE      *BLANKS       MADFNR
227100200529     C                   MOVE      *BLANKS       MADFCP
227200200529     C                   MOVE      *BLANKS       MADFSP
227300200529     C                   MOVE      'N'           MALREQ
227400200529     C                   Z-ADD     *ZEROS        MALPRO
227500200529     C                   MOVE      'N'           MALTSI
227600200529     C                   MOVE      'I'           MASTAT
227700200529      *
227800200529     C                   WRITE     SECORFD0
227900200529      *
228000200529     C                   Z-ADD     1             WWOPNB            2 0
228100200529     C                   MOVE      #1NBOP        W1NBOP            2 0
228200200529      *
228300200529      ** Write the record(s) on the Corporate Action Option file
228400200529      ** Depending of the processing type
228500200529      *
228600200529     C     WWOPNB        DOWLE     W1NBOP
228700200529     C                   EXSR      P011
228800200529     C                   ADD       1             WWOPNB
228900200529     C                   ENDDO
229000200529      *
229100200529      ** Save the first inserted record fields
229200200529      *
229300200529     C     FINSR         IFEQ      'Y'
229400200529     C                   MOVE      MACORF        KREFN
229500200529     C                   MOVE      '1'           *IN55
229600200529     C                   MOVE      'N'           FINSR
229700200529     C                   ENDIF
229800200529      *
229900200529      ** Update subfile record (for Reversed error fields)
230000200529      *
230100200529     C                   UPDATE    SE7502S0
230200200529      *
230300200529      ** Initialise error indicators
230400200529      *
230500200529     C                   EVAL      *IN07 = *OFF                                               CGL031
230600200529     C                   MOVE      '0'           *IN13
230700200529     C                   MOVE      '0'           *IN14
230800200529     C                   MOVE      '0'           *IN20
230900200529     C                   MOVE      '0'           *IN21
231000200529     C                   MOVE      '0'           *IN22
231100200529     C                   MOVE      '0'           *IN23
231200200529     C                   MOVE      '0'           *IN24
231300200529     C                   MOVE      '0'           *IN31
231400200529     C                   MOVE      '0'           *IN35
231500200529     C                   MOVE      '1'           *IN36
231600200529     C                   MOVE      '0'           *IN42
231700200529     C                   MOVE      '1'           *IN43
231800200529     C                   MOVE      '0'           *IN49
231900200529     C                   MOVE      '0'           *IN60
232000200529     C                   MOVE      '0'           *IN65
232100200529     C                   MOVE      '0'           *IN66
232200200529     C                   MOVE      '0'           *IN67
232300200529     C                   MOVE      '0'           *IN70
232400200529     C                   MOVE      '0'           *IN71
232500200529     C                   MOVE      '0'           *IN72
232600200529     C                   MOVE      '0'           *IN73
232700200529     C                   MOVE      '0'           *IN74
232800200529     C                   MOVE      '0'           *IN76
232900200529     C                   MOVE      '0'           *IN77
233000200529     C                   MOVE      '0'           *IN78
233100200529     C                   MOVE      '0'           *IN79
233200200529     C                   MOVE      '0'           *IN82
233300200529     C                   MOVE      '0'           *IN83
233400200529     C                   MOVE      '0'           *IN85
233500200529      *
233600200529     C                   MOVE      'N'           #1FINA
233700200529     C                   MOVE      'I'           #1STAT
233800200529     C                   MOVE      'G'           #1SEL
233900200529     C                   MOVE      'Y'           WWINPT            1
234000200529     C                   MOVE      'Y'           WRBLD             1
234100200529     C                   EXSR      P018
234200200529     C                   MOVE      '0'           *IN36
234300200529     C                   MOVE      '0'           *IN43
234400200529     C                   MOVE      ' '           #1SEL
234500200529     C                   MOVE      'N'           WWINPT
234600200529      *
234700200529     C     #1REFN        CHAIN     SECORFL0                           89
234800200529      *
234900200529     C                   MOVE      *BLANKS       MAJOBN
235000200529     C                   MOVE      *BLANKS       MAUSER
235100200529     C                   Z-ADD     *ZEROS        MAJNBR
235200200529      *
235300200529     C     *IN89         IFEQ      '0'
235400200529     C                   UPDATE    SECORFD0
235500200529     C                   ENDIF
235600200529     C                   ENDIF
235700200529     C                   ENDIF
235800200529      *
235900200529      ** Read first record of subfile
236000200529      *
236100200529     C                   READC     SE7502S0                               87
236200200529     C                   ENDDO
236300200529      *
236400200529      ** If at least one record created
236500200529      *
236600200529     C     W1CORF        IFNE      WWCORF
236700200529     C     *LOVAL        SETLL     SECORFPA
236800200529     C                   READ      SECORFPA                               89
236900200529      *
237000200529     C     *IN89         IFEQ      '0'
237100200529     C                   MOVE      WWCORF        MXCORF
237200200529     C                   UPDATE    SECORFP0
237300200529     C                   ENDIF
237400200529      *
237500200529     C                   ENDIF
237600200529      *
237700200529      ** Execute Commitment Control to fix all inserted records
237800200529      *
237900200529     C                   COMMIT
238000200529      *
238100200529      ** Set key fields from KLIST to first inserted record
238200200529      *
238300200529     C                   Z-ADD     0             WWRRN             4 0          Save Rcd.Nbr.
238400200529      *
238500200529      **   Clear subfile
238600200529      *
238700200529     C                   EXSR      P004
238800200529      *
238900200529      ** Set indicator to return to 'Amend Mode'
239000200529      *
239100200529     C                   MOVE      '1'           *IN43
239200200529     C                   MOVEA     TXT(9)        ##CTX1
239300200529      *
239400200529     C                   MOVE      '0'           *IN57
239500200529     C                   MOVE      '1'           *IN58
239600200529      *
239700200529     C                   MOVE      '0'           WIN45
239800200529     C                   MOVE      '0'           *IN30
239900200529      *
240000200529     C                   EXSR      P006
240100200529     C                   MOVE      '1'           WIN45
240200200529      *
240300200529     C                   ENDIF
240400200529      *
240500200529     C     TAG5          ENDSR
240600200529      *****************************************************************
240700200529      /EJECT
240800200529      *****************************************************************
240900200529      * P008A  : Validate 'Action' Field                              *
241000200529      *****************************************************************
241100200529      *
241200200529     C     P008A         BEGSR
241300200529      *
241400200529      ** If it's not the report mode
241500200529      *
241600200529     C     *IN64         IFEQ      '0'
241700200529      *
241800200529      ** If it's the Enq. mode, the 'Action' must be eq. to 'E' or 'F'
241900200529      *
242000200529     C     *IN61         IFEQ      '1'
242100200529      *
242200200529     C     #1SEL         IFNE      'E'
242300200529     C     #1SEL         ANDNE     'F'
242400200529     C     #1SEL         ANDNE     'V'
242500200529     C                   MOVE      'Y'           ERMSG
242600200529     C                   MOVE      '1'           *IN62                          Reverse image
242700200529     C                   MOVEL     'CO00017'     ZAMSID                         Message id.
242800200529     C                   EXSR      ZASNMS                                       Send message
242900200529     C                   GOTO      TAG2
243000200529     C                   ENDIF
243100200529      *
243200200529     C                   ELSE
243300200529      *
243400200529      ** 'Action' Code can be 'G','F','A','E','R','Y','P','V','D','C','N'
243500200529      *
243600200529     C     #1SEL         IFNE      'G'
243700200529     C     #1SEL         ANDNE     'F'
243800200529     C     #1SEL         ANDNE     'A'
243900200529     C     #1SEL         ANDNE     'E'
244000200529     C     #1SEL         ANDNE     'R'
244100200529     C     #1SEL         ANDNE     'Y'
244200200529     C     #1SEL         ANDNE     'P'
244300200529     C     #1SEL         ANDNE     'V'
244400200529     C     #1SEL         ANDNE     'D'
244500200529     C     #1SEL         ANDNE     'C'
244600200529     C     #1SEL         ANDNE     'N'
244700200529     C                   MOVE      'Y'           ERMSG
244800200529     C                   MOVE      '1'           *IN62                          Reverse image
244900200529     C                   MOVEL     'CO00018'     ZAMSID                         Message id.
245000200529     C                   EXSR      ZASNMS                                       Send message
245100200529     C                   GOTO      TAG2
245200200529     C                   ENDIF
245300200529     C                   ENDIF
245400200529      *
245500200529      ** If it's the report mode, the 'Action' must be equal to 'P'
245600200529      *
245700200529     C                   ELSE
245800200529      *
245900200529     C     #1SEL         IFNE      'P'
246000200529     C                   MOVE      'Y'           ERMSG
246100200529     C                   MOVE      '1'           *IN62                          Reverse image
246200200529     C                   MOVEL     'CO00019'     ZAMSID                         Message id.
246300200529     C                   EXSR      ZASNMS                                       Send message
246400200529     C                   GOTO      TAG2
246500200529     C                   ENDIF
246600200529     C                   ENDIF
246700200529      *
246800200529      ** If 'Ex-Date' is *GE than 'Run Date' and Action is not equal to 'F'
246900200529      *
247000200529     C                   MOVE      #1EXDT        DateIn
247100200529     C                   EXSR      ZDATE1
247200200529      *
247300200529     C                   Z-ADD     DAYNOOUT      KEXDT
247400200529      *
247500200529     C     #1SEL         IFEQ      'A'
247600200529     C     #1SEL         OREQ      'E'
247700200529     C     #1SEL         OREQ      'Y'
247800200529     C     KEXDT         IFGE      BJRDNB
247900200529     C                   MOVE      'Y'           ERMSG
248000200529     C                   MOVE      '1'           *IN62                          Reverse image
248100200529     C                   MOVEL     'CO00020'     ZAMSID                         Message id.
248200200529     C                   EXSR      ZASNMS                                       Send message
248300200529     C                   GOTO      TAG2
248400200529     C                   ENDIF
248500200529     C                   ENDIF
248600200529      *
248700200529      ** Access ER Reference file
248800200529      *
248900200529     C     #1REFN        CHAIN     SECORFL9                           89
249000200529      *
249100200529      ** If Locked by User Identifier is not blank
249200200529      *
249300200529     C     MAUSER        IFNE      *BLANKS
249400200529     C                   MOVE      MAUSER        WUSER
249500200529     C                   MOVE      MAJOBN        WJOBN
249600200529     C                   MOVE      'Y'           ERMSG
249700200529     C                   MOVE      '1'           *IN28                          Reverse image
249800200529     C                   MOVE      '1'           *IN29                          Reverse image
249900200529     C                   MOVE      '1'           *IN32                          Reverse image
250000200529     C                   MOVE      '1'           *IN33                          Reverse image
250100200529     C                   MOVE      '1'           *IN34                          Reverse image
250200200529     C                   MOVE      '1'           *IN37                          Reverse image
250300200529     C                   MOVE      '1'           *IN38                          Reverse image
250400200529     C                   MOVE      '1'           *IN39                          Reverse image
250500200529     C                   MOVEL     LOCKDS        ZAMSDA
250600200529     C                   MOVEL     'CO00021'     ZAMSID                         Message id.
250700200529     C                   EXSR      ZASNMS                                       Send message
250800200529     C                   GOTO      TAG2
250900200529     C                   ENDIF
251000200529      *
251100200529      ** If 'Processing type' is not 'NC' and 'Action' is 'N'
251200200529      ** Error message : Action 'N' not allowed
251300200529      *
251400200529     C     #1PTYP        IFNE      'NC'
251500200529     C     #1SEL         ANDEQ     'N'
251600200529     C                   MOVE      'Y'           ERMSG
251700200529     C                   MOVE      '1'           *IN62                          Reverse image
251800200529     C                   MOVEL     'CO00254'     ZAMSID                         Message id.
251900200529     C                   EXSR      ZASNMS                                       Send message
252000200529     C                   GOTO      TAG2
252100200529     C                   ENDIF
252200200529      *
252300200529      ** If 'Action' is 'N' and status different than 'I'
252400200529      ** Error message : Action 'N' not allowed
252500200529      *
252600200529     C     #1SEL         IFEQ      'N'
252700200529     C     #1GSTS        ANDNE     'I'
252800200529     C                   MOVE      'Y'           ERMSG
252900200529     C                   MOVE      '1'           *IN62                          Reverse image
253000200529     C                   MOVEL     'CO00257'     ZAMSID                         Message id.
253100200529     C                   EXSR      ZASNMS                                       Send message
253200200529     C                   GOTO      TAG2
253300200529     C                   ENDIF
253400200529      *
253500200529      ** If 'CO status' is 'Authorised' and Action is 'G', 'D' 'Y' or N
253600200529      ** Error message: ... Not allowed with status 'X' (Authorised)
253700200529      *
253800200529     C     #1GSTS        IFEQ      'X'
253900200529     C     #1SEL         IFEQ      'G'
254000200529     C     #1SEL         OREQ      'D'
254100200529     C     #1SEL         OREQ      'Y'
254200200529     C     #1SEL         OREQ      'N'
254300200529     C                   MOVE      'Y'           ERMSG
254400200529     C                   MOVE      '1'           *IN62                          Reverse image
254500200529     C                   MOVEL     'CO00023'     ZAMSID                         Message id.
254600200529     C                   EXSR      ZASNMS                                       Send message
254700200529     C                   GOTO      TAG2
254800200529     C                   ENDIF
254900200529     C                   ENDIF
255000200529      *
255100200529      ** If 'CO Status' is 'Stock Authorised' & Actn is 'G', 'D', 'Y', 'N'
255200200529      ** Error message : Not Allowed with Status 'S' (Stock Authorised)
255300200529      *
255400200529     C     #1GSTS        IFEQ      'S'
255500200529     C     #1SEL         IFEQ      'D'
255600200529     C     #1SEL         OREQ      'Y'
255700200529     C     #1SEL         OREQ      'N'
255800200529     C                   MOVE      'Y'           ERMSG
255900200529     C                   MOVE      '1'           *IN62                          Reverse image
256000200529     C                   MOVEL     'CO00098'     ZAMSID                         Message id.
256100200529     C                   EXSR      ZASNMS                                       Send message
256200200529     C                   GOTO      TAG2
256300200529     C                   ENDIF
256400200529     C                   ENDIF
256500200529      *
256600200529      ** If 'CO STATUS' is 'COMPLETED' & Actn is 'G', 'A', 'D', 'Y', N
256700200529      ** Error message : Not allowed with status 'C' (Completed)
256800200529      *
256900200529     C     #1GSTS        IFEQ      'C'
257000200529     C     #1SEL         IFEQ      'G'
257100200529     C     #1SEL         OREQ      'A'
257200200529     C     #1SEL         OREQ      'D'
257300200529     C     #1SEL         OREQ      'Y'
257400200529     C     #1SEL         OREQ      'N'
257500200529     C                   MOVE      'Y'           ERMSG
257600200529     C                   MOVE      '1'           *IN62                          Reverse image
257700200529     C                   MOVEL     'CO00024'     ZAMSID                         Message id.
257800200529     C                   EXSR      ZASNMS                                       Send message
257900200529     C                   GOTO      TAG2
258000200529     C                   ENDIF
258100200529     C                   ENDIF
258200200529      *
258300200529      ** If 'CO STATUS' is 'REVERSED' and action is not 'E'
258400200529      ** Error message : only 'F' and 'P' allowed when status 'R'
258500200529      *
258600200529     C     #1GSTS        IFEQ      'R'
258700200529     C     #1SEL         ANDNE     'F'
258800200529     C     #1SEL         ANDNE     'P'
258900200529     C                   MOVE      'Y'           ERMSG
259000200529     C                   MOVE      '1'           *IN62                          Reverse image
259100200529     C                   MOVEL     'CO00025'     ZAMSID                         Message id.
259200200529     C                   EXSR      ZASNMS                                       Send message
259300200529     C                   GOTO      TAG2
259400200529     C                   ENDIF
259500200529      *
259600200529      ** If 'Action' is 'Delete' ('D'), test if it's possible to
259700200529      ** Delete.
259800200529      *
259900200529     C     #1SEL         IFEQ      'D'
260000200529      *
260100200529      ** If Processing Type = Dividend Events, Rights Issues or Offer  s.
260200200529      *
260300200529     C     #1PTYP        IFEQ      'DV'
260400200529     C     #1PTYP        OREQ      'RG'
260500200529     C     #1PTYP        OREQ      'FR'
260600200529      *
260700200529      ** If there is a linked Exercises and Conversions Corporate.
260800200529      *
260900200529     C     #1REFN        CHAIN     SECOEXL2                           89
261000200529     C     *IN89         IFEQ      '0'
261100200529     C     MJCORF        CHAIN     SECORFL9                           89
261200200529     C     *IN89         IFEQ      '0'
261300200529     C     MASTAT        IFEQ      'R'
261400200529      *
261500200529      ** If the linked 'EX' Corporate is Reversed, Delete not allowed  ,
261600200529      ** only Reverse allowed.
261700200529      *
261800200529     C                   MOVEL     'CO00599'     ZAMSID                         Message id.
261900200529     C                   ELSE
262000200529      *
262100200529      ** If the linked 'EX' Corporate is not Reversed, Delete not
262200200529      ** allowed.
262300200529      *
262400200529     C                   MOVEL     'CO00597'     ZAMSID                         Message id.
262500200529     C                   ENDIF
262600200529     C                   MOVE      'Y'           ERMSG
262700200529     C                   MOVE      '1'           *IN62                          Reverse image
262800200529     C                   MOVEL(P)  MJCORF        ZAMSDA
262900200529     C                   EXSR      ZASNMS                                       Send message
263000200529     C                   GOTO      TAG2
263100200529     C                   ENDIF
263200200529     C                   ENDIF
263300200529     C                   ENDIF
263400200529      *
263500200529     C                   ENDIF
263600200529      *
263700200529      ** If 'ACTION' is 'REVERSE' ('R'), test if it's possible to REVERSE
263800200529      *
263900200529     C     #1SEL         IFEQ      'R'
264000200529      *
264100200529      ** Access Security details to retrieve Security Maturity Date
264200200529      *
264300200529     C     #1SECN        CHAIN     SECTYZ1                            89
264400200529      *
264500200529      ** If 'Ex-Date' is not greater than calculated 'Back Value Date'
264600200529      ** or if 'Run Date' is not lower than Security 'Maturity datE'
264700200529      *
264800200529     C     KEXDT         IFLE      WBACKD
264900200529     C     KEXDT         ANDNE     *ZEROS
265000200529     C     BJRDNB        ORGE      MATY
265100200529     C     MATY          ANDNE     *ZEROS
265200200529     C                   MOVE      'Y'           ERMSG
265300200529     C                   MOVE      '1'           *IN62                          Reverse image
265400200529     C                   MOVEL     'CO00028'     ZAMSID                         Message id.
265500200529     C                   EXSR      ZASNMS                                       Send message
265600200529     C                   GOTO      TAG2
265700200529     C                   ENDIF
265800200529      *
265900200529     C     BJRDNB        SUB       MATDDT        RTNWRF            5 0
266000200529      *
266100200529     C     RTNWRF        IFGE      RTNPOS
266200200529     C     RTNWRF        ORGE      RTNTRD
266300200529     C     MASTAT        IFNE      'I'
266400200529     C                   MOVE      'Y'           ERMSG
266500200529     C                   MOVE      '1'           *IN62                          Reverse image
266600200529     C                   MOVEL     'CO00556'     ZAMSID                         Message id.
266700200529     C                   EXSR      ZASNMS                                       Send message
266800200529     C                   GOTO      TAG2
266900200529     C                   ENDIF
267000200529     C                   ENDIF
267100200529      *
267200200529      ** If Processing Type = Dividend Events, Rights Issues or Offer  s.
267300200529      *
267400200529     C     #1PTYP        IFEQ      'DV'
267500200529     C     #1PTYP        OREQ      'RG'
267600200529     C     #1PTYP        OREQ      'FR'
267700200529      *
267800200529      ** If there is a linked Exercises and Conversions Corporate and
267900200529      ** this linked Corporate not Reversed, Reverse not allowed.
268000200529      *
268100200529     C     #1REFN        CHAIN     SECOEXL2                           89
268200200529     C     *IN89         IFEQ      '0'
268300200529     C     MJCORF        CHAIN     SECORFL9                           89
268400200529     C     *IN89         IFEQ      '0'
268500200529     C     MASTAT        ANDNE     'R'
268600200529     C                   MOVE      'Y'           ERMSG
268700200529     C                   MOVE      '1'           *IN62                          Reverse image
268800200529     C                   MOVEL     'CO00598'     ZAMSID                         Message id.
268900200529     C                   MOVEL(P)  MJCORF        ZAMSDA
269000200529     C                   EXSR      ZASNMS                                       Send message
269100200529     C                   GOTO      TAG2
269200200529     C                   ENDIF
269300200529     C                   ENDIF
269400200529     C                   ENDIF
269500200529      *
269600200529     C                   ENDIF
269700200529      *
269800200529     C     #1SEL         IFEQ      'R'
269900200529     C     #1SEL         OREQ      'D'
270000200529     C     #1REFN        CHAIN     SECORFLA                           89
270100200529     C     *IN89         IFEQ      *OFF
270200200529     C     MASTAT        ANDEQ     'R'
270300200529     C                   MOVE      'Y'           ERMSG
270400200529     C                   MOVE      '1'           *IN62
270500200529     C                   MOVEL     'CO00369'     ZAMSID
270600200529     C                   EXSR      ZASNMS
270700200529     C                   ENDIF
270800200529     C                   ENDIF
270900200529      *
271000200529      ** If 'Action' is 'Reply' and if processing type 'NC' or 'CC'
271100200529      *
271200200529     C     #1SEL         IFEQ      'Y'
271300200529     C     #1PTYP        ANDEQ     'NC'
271400200529     C     #1SEL         OREQ      'Y'
271500200529     C     #1PTYP        ANDEQ     'CC'
271600200529     C                   MOVE      'Y'           ERMSG
271700200529     C                   MOVE      '1'           *IN62                          Reverse image
271800200529     C                   MOVEL     'CO00110'     ZAMSID                         Message id.
271900200529     C                   EXSR      ZASNMS                                       Send message
272000200529     C                   ENDIF
272100200529      *
272200200529     C     #1SEL         IFEQ      'F'
272300200529     C     #1SEL         OREQ      'V'
272400200529     C     #1SEL         OREQ      'E'
272500200529     C                   MOVE      'E'           WLACTN
272600200529     C                   ELSE
272700200529     C     #1SEL         IFEQ      'N'
272800200529     C                   MOVE      'X'           WLACTN
272900200529     C                   ELSE
273000200529     C                   MOVE      #1SEL         WLACTN
273100200529     C                   ENDIF
273200200529     C                   ENDIF
273300200529      *
273400200529     C     #1SEL         IFEQ      'E'
273500200529     C     #1SEL         OREQ      'Y'
273600200529     C     #1SEL         OREQ      'V'
273700200529     C     #1SEL         OREQ      'N'
273800200529     C                   EXSR      P025
273900200529     C                   ENDIF
274000200529      *
274100200529      ** Check if user is authorised to the action code
274200200529      *
274300200529      ** If single branch environment
274400200529      *
274500200529     C     AGMBIN        IFNE      'Y'
274600200529     C                   CALL      'ZVACTU'
274700200529     C                   PARM                    WLACTN            1
274800200529     C                   PARM                    WLERR             1 0
274900200529      *
275000200529     C     WLERR         IFNE      *ZERO
275100200529     C                   MOVE      'Y'           ERMSG
275200200529     C                   MOVE      '1'           *IN62
275300200529     C                   MOVEL     'CO00034'     ZAMSID
275400200529     C                   EXSR      ZASNMS
275500200529     C                   ENDIF
275600200529      *
275700200529     C                   ELSE
275800200529      *
275900200529      ** If multibranching environment
276000200529      *
276100200529     C                   CALL      'ZVACTBU'
276200200529     C                   PARM                    WLACTN            1
276300200529     C                   PARM      BVBRCD        WLBRCH            3
276400200529     C                   PARM                    WLERR             1 0
276500200529      *
276600200529     C     WLERR         IFEQ      1
276700200529     C                   MOVE      'Y'           ERMSG
276800200529     C                   MOVE      '1'           *IN62
276900200529     C                   MOVEL     'CO00035'     ZAMSID
277000200529     C                   EXSR      ZASNMS
277100200529     C                   ELSE
277200200529     C     WLERR         IFEQ      2
277300200529     C                   MOVE      'Y'           ERMSG
277400200529     C                   MOVE      '1'           *IN62
277500200529     C                   MOVEL     'CO00036'     ZAMSID
277600200529     C                   EXSR      ZASNMS
277700200529     C                   ENDIF
277800200529     C                   ENDIF
277900200529      *
278000200529     C                   ENDIF
278100200529      *
278200200529     C     TAG2          ENDSR
278300200529      *****************************************************************
278400200529      /EJECT
278500200529      *****************************************************************
278600200529      * P009   : Process 'Action'                                     *
278700200529      *****************************************************************
278800200529      *
278900200529     C     P009          BEGSR
279000200529      *
279100200529      ** If Action is 'Amend' Call 'Depots Maintenance' Program
279200200529      ** or if Action is 'Enquiry' Call 'Depots Enquiry' Program
279300200529      *
279400200529     C     #1SEL         IFEQ      'A'
279500200529     C     #1SEL         OREQ      'E'
279600200529      *
279700200529     C                   MOVE      *BLANKS       P#RTCD
279800200529      *
279900200529     C                   MOVE      #1EXDT        DateIn
280000200529     C                   EXSR      ZDATE1
280100200529     C                   MOVE      DAYNOOUT      WEXDAT
280200200529      *
280300200529     C                   MOVE      *BLANKS       WNBOP
280400200529     C                   MOVE      #1NBOP        WNBOP             2
280500200529      *
280600200529     C                   CALL      'SE7512'                             99
280700200529     C                   PARM                    #1REFN                         ER Reference
280800200529     C                   PARM                    #1SECN                         Security Shortname
280900200529     C                   PARM                    #1COAT                         Corporate Action Typ
281000200529     C                   PARM                    #1PTYP                         Processing Type
281100200529     C                   PARM                    WEXDAT            5            Ex-Date
281200200529     C                   PARM                    WNBOP                          Number of Options
281300200529     C                   PARM                    #1SEL                          Amend or Enquiry ?
281400200529     C                   PARM      *BLANKS       WWGSTS            1            General Status
281500200529     C                   PARM                    P#RTCD            1            Return Code
281600200529      *
281700200529     C     #1SEL         IFEQ      'A'
281800200529     C                   MOVE      WWGSTS        #1GSTS
281900200529      *
282000200529      ** Retrieve the "Higher" Status and final allocation indicator
282100200529      *
282200200529     C                   MOVE      *BLANKS       #1STAT
282300200529     C                   MOVE      *BLANKS       #1FINA
282400200529     C                   MOVE      'Y'           WFIRST            1
282500200529      *
282600200529     C     #1REFN        SETLL     SECODRL1
282700200529     C     #1REFN        READE     SECODRL1                               89
282800200529      *
282900200529     C     *IN89         IFEQ      '1'
283000200529     C                   MOVE      MASTAT        #1STAT
283100200529     C                   ENDIF
283200200529      *
283300200529     C     *IN89         DOWEQ     '0'
283400200529      *
283500200529     C     MSRECI        IFEQ      'D'
283600200529      *
283700200529     C     WFIRST        IFEQ      'Y'
283800200529     C                   MOVE      MSFAID        #1FINA
283900200529     C                   MOVE      MSCOST        #1STAT
284000200529     C                   MOVE      'N'           WFIRST
284100200529     C                   ELSE
284200200529      *
284300200529      ** Retrieve the "Higher" Final allocation indicator
284400200529      *
284500200529     C     MSFAID        IFEQ      'Y'
284600200529     C                   MOVE      MSFAID        #1FINA
284700200529     C                   ELSE
284800200529     C     MSFAID        IFEQ      'S'
284900200529     C     #1FINA        ANDEQ     'N'
285000200529     C                   MOVE      MSFAID        #1FINA
285100200529     C                   ENDIF
285200200529     C                   ENDIF
285300200529      *
285400200529      ** Retrieve the "Higher" Status
285500200529      *
285600200529     C     MSCOST        IFEQ      'C'
285700200529     C                   MOVE      MSCOST        #1STAT
285800200529     C                   ELSE
285900200529     C     MSCOST        IFEQ      'X'
286000200529     C     #1STAT        IFEQ      'S'
286100200529     C     #1STAT        OREQ      'L'
286200200529     C     #1STAT        OREQ      'I'
286300200529     C                   MOVE      MSCOST        #1STAT
286400200529     C                   ENDIF
286500200529     C                   ENDIF
286600200529      *
286700200529     C     MSCOST        IFEQ      'S'
286800200529     C     #1STAT        IFEQ      'L'
286900200529     C     #1STAT        OREQ      'I'
287000200529     C                   MOVE      MSCOST        #1STAT
287100200529     C                   ENDIF
287200200529     C                   ENDIF
287300200529      *
287400200529     C     MSCOST        IFEQ      'L'
287500200529     C     #1STAT        ANDEQ     'I'
287600200529     C                   MOVE      MSCOST        #1STAT
287700200529     C                   ENDIF
287800200529     C                   ENDIF
287900200529     C                   ENDIF
288000200529     C                   ENDIF
288100200529      *
288200200529     C     #1REFN        READE     SECODRL1                               89
288300200529     C                   ENDDO
288400200529      *
288500200529     C     #1FINA        IFEQ      *BLANKS
288600200529     C     #1STAT        ANDEQ     *BLANKS
288700200529     C                   MOVE      'N'           #1FINA
288800200529     C                   MOVE      'I'           #1STAT
288900200529     C                   ENDIF
289000200529     C                   ENDIF
289100200529      *
289200200529      ** If error indicator of the program call is on or if return
289300200529      ** Code is equal to 'E' (Error), database error
289400200529      *
289500200529     C     *IN99         IFEQ      '1'
289600200529     C     P#RTCD        OREQ      'E'
289700200529     C                   MOVEL     '005'         DBASE             3 0          *****************
289800200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 05 **
289900200529     C                   MOVEL     NARR(5)       DBKEY            29            *****************
290000200529     C                   EXSR      *PSSR
290100200529     C                   ENDIF
290200200529      *
290300200529     C     P#RTCD        IFNE      'M'
290400200529     C                   MOVE      *BLANKS       #1SEL
290500200529     C                   ENDIF
290600200529      *
290700200529      ** If Return code is equal to '2', '3' or 'M'
290800200529      *
290900200529     C     P#RTCD        IFEQ      '2'
291000200529     C     P#RTCD        OREQ      '3'
291100200529     C     P#RTCD        OREQ      'M'
291200200529      *
291300200529      ** Access to ER Reference file with current reference
291400200529      *
291500200529     C     #1REFN        CHAIN     SECORFL0                           88
291600200529      *
291700200529     C                   MOVE      *BLANKS       MAJOBN
291800200529     C                   MOVE      *BLANKS       MAUSER
291900200529     C                   Z-ADD     *ZEROS        MAJNBR
292000200529      *
292100200529     C                   UPDATE    SECORFD0
292200200529     C                   MOVE      FIELD         #FIELD
292300200529      *
292400200529      ** Commitment instruction
292500200529      *
292600200529     C                   COMMIT
292700200529      *
292800200529     C     P#RTCD        IFEQ      '3'
292900200529     C                   MOVE      '1'           *INKC
293000200529     C                   ENDIF
293100200529      *
293200200529     C     P#RTCD        IFEQ      'M'
293300200529     C                   MOVE      'Y'           ERMSG
293400200529     C                   MOVE      '1'           *IN62                          Reverse image
293500200529     C                   MOVEL     'CO00031'     ZAMSID                         Message id.
293600200529     C                   EXSR      ZASNMS                                       Send message
293700200529     C                   ENDIF
293800200529      *
293900200529     C                   GOTO      TAG3
294000200529     C                   ENDIF
294100200529     C                   ENDIF
294200200529      *
294300200529      ** If 'Action' is print
294400200529      *
294500200529     C     #1SEL         IFEQ      'P'
294600200529      *
294700200529     C                   MOVE      *BLANKS       #1SEL
294800200529      *
294900200529     C                   MOVE      *BLANKS       @PARM           100
295000200529     C                   MOVEL     'SE7533'      @RNAM
295100200529     C                   MOVEL     'SEC7533B'    @COTT
295200200529      *
295300200529     C                   CALL      'FC0040X'
295400200529     C                   PARM      *BLANKS       @RTCD             7
295500200529     C                   PARM                    @RNAM            10
295600200529     C                   PARM                    @COTT            10
295700200529     C                   PARM      '10004'       @CSEQ             5
295800200529     C                   PARM      #1REFN        @PARM           100
295900200529     C                   PARM      AGMBIN        @MBRC             1
296000200529     C                   PARM      'S'           @LVL              1
296100200529     C                   PARM      *BLANKS       @ETTY             3
296200200529      *
296300200529      ** If error indicator of the program call is on or if return
296400200529      ** Code is equal to 'E' (Error), database error
296500200529      *
296600200529     C     @RTCD         IFNE      *BLANKS
296700200529     C                   MOVEL     '006'         DBASE             3 0          *****************
296800200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 06 **
296900200529     C                   MOVEL     NARR(8)       DBKEY            29            *****************
297000200529     C                   EXSR      *PSSR
297100200529     C                   ENDIF
297200200529      *
297300200529      ** If return code is equal to blank
297400200529      *
297500200529     C     @RTCD         IFEQ      ' '
297600200529      *
297700200529      ** Access to ER Reference file with current reference
297800200529      *
297900200529     C     #1REFN        CHAIN     SECORFL0                           88
298000200529      *
298100200529     C                   MOVE      *BLANKS       MAJOBN
298200200529     C                   MOVE      *BLANKS       MAUSER
298300200529     C                   Z-ADD     *ZEROS        MAJNBR
298400200529      *
298500200529     C                   UPDATE    SECORFD0
298600200529     C                   MOVE      FIELD         #FIELD
298700200529      *
298800200529     C                   MOVEL     'CO00294'     ZAMSID
298900200529     C                   EXSR      ZASNMS
299000200529      *
299100200529      ** Commitment instruction
299200200529      *
299300200529     C                   COMMIT
299400200529      *
299500200529     C                   ENDIF
299600200529     C                   ENDIF
299700200529      *
299800200529      ** If 'Action' is reverse, delete or authorisation
299900200529      ** (processing type 'NC')
300000200529      *
300100200529     C     #1SEL         IFEQ      'R'
300200200529     C     #1SEL         OREQ      'D'
300300200529     C     #1SEL         OREQ      'N'
300400200529      *
300500200529      ** Produce confirmation screen
300600200529      *
300700200529     C                   EXSR      P010
300800200529      *
300900200529      ** Clear messages from program message queue.
301000200529      *
301100200529     C                   CALL      'Y2CLMSC'
301200200529     C                   PARM      ##PGM         ZAPGM            10
301300200529     C                   PARM      '*SAME'       ZAPGRL            5
301400200529      *
301500200529      ** If Confirmation indicator returned is not equal to 'Y'
301600200529      *
301700200529     C     #1CONF        IFNE      'Y'
301800200529      *
301900200529      ** Access to ER Reference file with current reference
302000200529      *
302100200529     C     #1REFN        CHAIN     SECORFL0                           88
302200200529      *
302300200529     C                   MOVE      *BLANKS       MAJOBN
302400200529     C                   MOVE      *BLANKS       MAUSER
302500200529     C                   Z-ADD     *ZEROS        MAJNBR
302600200529      *
302700200529     C                   UPDATE    SECORFD0
302800200529     C                   MOVE      FIELD         #FIELD
302900200529      *
303000200529     C                   COMMIT
303100200529      *
303200200529     C                   MOVE      *BLANKS       #1SEL
303300200529      *
303400200529      ** Terminate current processing
303500200529      *
303600200529     C                   GOTO      TAG3
303700200529      *
303800200529     C                   ENDIF
303900200529     C                   ENDIF
304000200529      *
304100200529      ** If 'Action' is reverse
304200200529      *
304300200529     C     #1SEL         IFEQ      'R'
304400200529      *
304500200529      ** Access Corporate action Reference with current Reference
304600200529      *
304700200529     C     #1REFN        CHAIN     SECORFL0                           88
304800200529      *
304900200529     C                   MOVE      'D'           MARECI
305000200529     C                   Z-ADD     BJRDNB        MALCD
305100200529     C                   MOVE      'R'           MACHTP
305200200529     C                   MOVE      ##USR         MALUID
305300200529      *
305400200529      ** If Ex-Date changed
305500200529      *
305600200529     C     #1EXDT        IFNE      #2EXDT
305700200529     C                   MOVE      #1EXDT        DateIn
305800200529     C                   EXSR      ZDATE1
305900200529      *
306000200529     C                   Z-ADD     DAYNOOUT      MACOEX
306100200529      *
306200200529     C                   MOVE      #1EXDT        #2EXDT
306300200529     C                   ENDIF
306400200529      *
306500200529      ** If Date of Announcement changed
306600200529      *
306700200529     C     #1COAN        IFNE      #2COAN
306800200529     C                   MOVE      #1COAN        DateIn
306900200529     C                   EXSR      ZDATE1
307000200529      *
307100200529     C                   Z-ADD     DAYNOOUT      MACOAN
307200200529     C                   MOVE      #1COAN        #2COAN
307300200529     C                   ENDIF
307400200529      *
307500200529      ** If Allocation effective date changed
307600200529      *
307700200529     C     #1ALEF        IFNE      #2ALEF
307800200529     C                   MOVE      #1ALEF        DateIn
307900200529     C                   EXSR      ZDATE1
308000200529     C                   Z-ADD     DAYNOOUT      MAALEF
308100200529      *
308200200529     C                   MOVE      #1ALEF        #2ALEF
308300200529     C                   ENDIF
308400200529      *
308500200529     C     #1REFN        SETLL     SECOALL0
308600200529     C     #1REFN        READE     SECOALL0                               89
308700200529      *
308800200529      ** Do while end of file not reached and same reference number
308900200529      *
309000200529     C     *IN89         DOWEQ     '0'
309100200529     C     #1REFN        ANDEQ     MCCORF
309200200529      *
309300200529     C     MCRECI        IFEQ      '*'
309400200529     C                   DELETE    SECOALD0
309500200529     C                   ELSE
309600200529     C                   MOVE      '*'           MCRECI
309700200529     C                   Z-ADD     BJRDNB        MCLCD
309800200529     C                   MOVE      'R'           MCCHTP
309900200529     C                   MOVE      ##USR         MCLUID
310000200529     C                   UPDATE    SECOALD0
310100200529     C                   ENDIF
310200200529      *
310300200529      ** Access next record
310400200529      *
310500200529     C     #1REFN        READE     SECOALL0                               89
310600200529     C                   ENDDO
310700200529      *
310800200529     C     #1REFN        SETLL     SECODPL0
310900200529     C     #1REFN        READE     SECODPL0                               89
311000200529      *
311100200529      ** Do while end of file not reached and same reference number
311200200529      *
311300200529     C     *IN89         DOWEQ     '0'
311400200529     C     #1REFN        ANDEQ     MBCORF
311500200529      *
311600200529     C     MBRECI        IFEQ      '*'
311700200529     C                   DELETE    SECODPD0
311800200529     C                   ELSE
311900200529     C                   MOVE      '*'           MBRECI
312000200529     C                   Z-ADD     BJRDNB        MBLCD
312100200529     C                   MOVE      'R'           MBCHTP
312200200529     C                   MOVE      ##USR         MBLUID
312300200529     C                   UPDATE    SECODPD0
312400200529     C                   ENDIF
312500200529      *
312600200529      ** Access next record
312700200529      *
312800200529     C     #1REFN        READE     SECODPL0                               89
312900200529     C                   ENDDO
313000200529      *
313100200529     C     #1REFN        SETLL     SECODRL0
313200200529     C     #1REFN        READE     SECODRL0                               89
313300200529      *
313400200529      ** Do while end of file not reached and same reference number
313500200529      *
313600200529     C     *IN89         DOWEQ     '0'
313700200529     C     #1REFN        ANDEQ     MSCORF
313800200529      *
313900200529     C                   Z-ADD     BJRDNB        MSLCD
314000200529     C                   MOVE      'R'           MSCHTP
314100200529     C                   MOVE      ##USR         MSLUID
314200200529     C                   MOVE      'R'           MSCOST
314300200529     C                   UPDATE    SECODRD0
314400200529      *
314500200529      ** Access next record
314600200529      *
314700200529     C     #1REFN        READE     SECODRL0                               89
314800200529     C                   ENDDO
314900200529      *
315000200529      ** Reverse records on Blocking File.
315100200529      *
315200200529     C     #1REFN        SETLL     SECOBKL1
315300200529     C     #1REFN        READE     SECOBKL1                               89
315400200529      *
315500200529      ** Do while end of file not reached.
315600200529      *
315700200529     C     *IN89         DOWEQ     '0'
315800200529      *
315900200529     C     MURECI        IFEQ      '*'
316000200529     C                   DELETE    SECOBKD0
316100200529     C                   ELSE
316200200529     C                   Z-ADD     BJRDNB        MULCD
316300200529     C                   MOVE      'R'           MUCHTP
316400200529     C                   MOVE      ##USR         MULUID
316500200529     C                   MOVE      '*'           MURECI
316600200529     C                   UPDATE    SECOBKD0
316700200529     C                   ENDIF
316800200529      *
316900200529      ** Access next record.
317000200529      *
317100200529     C     #1REFN        READE     SECOBKL1                               89
317200200529     C                   ENDDO
317300200529      *
317400200529     C                   MOVE      *BLANKS       MAJOBN
317500200529     C                   MOVE      *BLANKS       MAUSER
317600200529     C                   Z-ADD     *ZEROS        MAJNBR
317700200529     C                   MOVE      'R'           MASTAT
317800200529      *
317900200529     C                   UPDATE    SECORFD0
318000200529     C                   MOVE      'Y'           WRBLD             1
318100200529     C                   MOVE(P)   FIELD         WWFLD           175
318200200529      *
318300200529      ** If Exercises and Conversions and 'DV', 'RG' or 'OF' linked
318400200529      ** Corporate Action exists.
318500200529      *
318600200529     C     #1PTYP        IFEQ      'EX'
318700200529     C     WWLNKR        ANDNE     *BLANKS
318800200529     C     WWLNKR        CHAIN     SECORFL9                           89
318900200529      *
319000200529      ** If Status of the 'DV', 'RG' or 'FR' linked Corporate Action
319100200529      ** neither Stock Autorised, nor Fully Authorised, nor Complete,
319200200529      ** set 'Rights' fields to blank or zero (and 'Subscription Rights
319300200529      ** Tradable' field if 'DV' to 'N').
319400200529      *
319500200529     C     *IN89         IFEQ      '0'
319600200529     C     MASTAT        IFNE      'S'
319700200529     C     MASTAT        ANDNE     'X'
319800200529     C     MASTAT        ANDNE     'C'
319900200529     C     WWPTYP        IFEQ      'DV'
320000200529     C     WWLNKR        CHAIN     SECODVL0                           89
320100200529     C     *IN89         IFEQ      '0'
320200200529     C                   MOVE      'N'           MDSBRT
320300200529     C                   MOVE      *BLANKS       MDSBRS
320400200529     C                   Z-ADD     0             MDREPR
320500200529     C                   Z-ADD     0             MDREXD
320600200529     C                   Z-ADD     0             MDREXA
320700200529     C                   MOVE      *BLANKS       MDREAT
320800200529     C                   Z-ADD     0             MDRNNS
320900200529     C                   Z-ADD     0             MDRNRI
321000200529     C                   Z-ADD     0             MDRMLT
321100200529     C                   Z-ADD     0             MDRDIV
321200200529     C                   Z-ADD     0             MDRTRF
321300200529     C                   Z-ADD     0             MDRTRT
321400200529     C                   Z-ADD     BJRDNB        MDLCD
321500200529     C                   MOVE      'A'           MDCHTP
321600200529     C                   MOVE      ##USR         MDLUID
321700200529     C                   UPDATE    SECODVD0
321800200529     C                   ENDIF
321900200529     C                   ELSE
322000200529     C     WWPTYP        IFEQ      'RG'
322100200529     C     WWLNKR        CHAIN     SECORGL0                           89
322200200529     C     *IN89         IFEQ      '0'
322300200529     C                   MOVE      *BLANKS       MFSBRS
322400200529     C                   Z-ADD     0             MFSBRP
322500200529     C                   Z-ADD     0             MFREXD
322600200529     C                   Z-ADD     0             MFREXA
322700200529     C                   MOVE      *BLANKS       MFREAT
322800200529     C                   Z-ADD     0             MFRNNS
322900200529     C                   Z-ADD     0             MFRNRI
323000200529     C                   Z-ADD     0             MFRMLT
323100200529     C                   Z-ADD     0             MFRDIV
323200200529     C                   Z-ADD     0             MFRTRF
323300200529     C                   Z-ADD     0             MFRTRT
323400200529     C                   MOVE      *BLANKS       MFAVOP
323500200529     C                   Z-ADD     BJRDNB        MFLCD
323600200529     C                   MOVE      'A'           MFCHTP
323700200529     C                   MOVE      ##USR         MFLUID
323800200529     C                   UPDATE    SECORGD0
323900200529     C                   ENDIF
324000200529     C                   ELSE
324100200529     C     WWLNKR        CHAIN     SECOFRL0                           89
324200200529     C     *IN89         IFEQ      '0'
324300200529     C                   MOVE      'N'           MESBRT
324400200529     C                   MOVE      *BLANKS       MESBRS
324500200529     C                   Z-ADD     0             MEREPR
324600200529     C                   Z-ADD     0             MEREXD
324700200529     C                   Z-ADD     0             MEREXA
324800200529     C                   MOVE      *BLANKS       MEREAT
324900200529     C                   Z-ADD     0             MERNNS
325000200529     C                   Z-ADD     0             MERNRI
325100200529     C                   Z-ADD     0             MERMLT
325200200529     C                   Z-ADD     0             MERDIV
325300200529     C                   Z-ADD     0             MERTRF
325400200529     C                   Z-ADD     0             MERTRT
325500200529     C                   Z-ADD     BJRDNB        MELCD
325600200529     C                   MOVE      'A'           MECHTP
325700200529     C                   MOVE      ##USR         MELUID
325800200529     C                   UPDATE    SECOFRD0
325900200529     C                   ENDIF
326000200529     C                   ENDIF
326100200529     C                   ENDIF
326200200529      *
326300200529     C     #1REFN        CHAIN     SECOEXL0                           89
326400200529     C     *IN89         IFEQ      '0'
326500200529     C                   MOVE      *BLANKS       MJLNKR
326600200529     C                   Z-ADD     BJRDNB        MJLCD
326700200529     C                   MOVE      'A'           MJCHTP
326800200529     C                   MOVE      ##USR         MJLUID
326900200529     C                   UPDATE    SECOEXD0
327000200529     C                   ENDIF
327100200529     C                   ENDIF
327200200529     C                   ENDIF
327300200529     C                   MOVE      WWFLD         FIELD
327400200529     C                   ENDIF
327500200529      *
327600200529     C     #1PTYP        IFEQ      'CC'
327700200529     C     #1REFN        CHAIN     SECOCCL0                           89
327800200529      *
327900200529     C     *IN89         IFEQ      '0'
328000200529     C                   MOVE      '*'           NARECI
328100200529     C                   Z-ADD     BJRDNB        NALCD
328200200529     C                   MOVE      'R'           NACHTP
328300200529     C                   MOVE      ##USR         NALUID
328400200529     C                   UPDATE    SECOCCD0
328500200529     C                   ENDIF
328600200529      *
328700200529     C     NABLKR        IFNE      *ZEROS
328800200529     C     *IN89         ANDEQ     '0'
328900200529     C                   Z-ADD     *ZEROS        WCOUNT
329000200529     C                   MOVE      #1REFN        W1REFN
329100200529     C     NABLKR        CHAIN     SECORBL0                           89
329200200529      *
329300200529      ** Reverse all matching records in LF/SECORSL0
329400200529      *
329500200529     C     NBBLKR        SETLL     SECORSL0
329600200529     C     NBBLKR        READE     SECORSL0                               89
329700200529      *
329800200529     C     *IN89         DOWEQ     '0'
329900200529     C     NCRECI        IFEQ      'D'
330000200529     C                   ADD       1             WCOUNT
330100200529     C                   ENDIF
330200200529     C     W1REFN        IFEQ      NCCORF
330300200529     C                   MOVE      '*'           NCRECI
330400200529     C                   Z-ADD     BJRDNB        NCLCD
330500200529     C                   MOVE      'R'           NCCHTP
330600200529     C                   MOVE      ##USR         NCLUID
330700200529     C                   UPDATE    SECORSD0
330800200529     C                   SUB       1             WCOUNT
330900200529     C                   ENDIF
331000200529     C     NBBLKR        READE     SECORSL0                               89
331100200529     C                   ENDDO
331200200529      *
331300200529      ** Reverse matching record in LF/SECORBL0
331400200529      *
331500200529     C     WCOUNT        IFEQ      *ZEROS
331600200529     C                   MOVE      'R'           NBSTAT
331700200529     C                   Z-ADD     BJRDNB        NBLCD
331800200529     C                   MOVE      'R'           NBCHTP
331900200529     C                   MOVE      ##USR         NBLUID
332000200529     C                   UPDATE    SECORBD0
332100200529     C                   ENDIF
332200200529     C                   ENDIF
332300200529      *
332400200529     C                   ENDIF
332500200529      *
332600200529      ** Update subfile fields
332700200529      *
332800200529     C                   MOVE      FIELD         #FIELD
332900200529     C                   MOVE      *BLANKS       #1SEL
333000200529     C                   MOVE      'R'           #1STAT
333100200529     C                   MOVE      'R'           #1GSTS
333200200529      *
333300200529      ** Commitment instruction
333400200529      *
333500200529     C                   COMMIT
333600200529     C                   ENDIF
333700200529      *
333800200529      ** If 'Action' is 'General Information', 'F' - Enquiry or
333900200529      ** 'G' - Maintenance
334000200529      *
334100200529     C     #1SEL         IFEQ      'F'
334200200529     C     #1SEL         OREQ      'G'
334300200529      *
334400200529     C                   MOVE      '0'           *IN35
334500200529     C     #1PTYP        IFEQ      'CC'
334600200529     C                   MOVE      '1'           *IN35
334700200529     C                   ENDIF
334800200529      *
334900200529     C                   MOVE      *IN61         WIN61             1
335000200529     C     #1SEL         IFEQ      'F'
335100200529     C                   MOVE      '1'           *IN61
335200200529     C                   ENDIF
335300200529      *
335400200529      ** Initialise error indicators
335500200529      *
335600200529     C                   EVAL      *IN07 = *OFF                                               CGL031
335700200529     C                   MOVE      '0'           *IN13
335800200529     C                   MOVE      '0'           *IN14
335900200529     C                   MOVE      '0'           *IN20
336000200529     C                   MOVE      '0'           *IN21
336100200529     C                   MOVE      '0'           *IN22
336200200529     C                   MOVE      '0'           *IN23
336300200529     C                   MOVE      '0'           *IN24
336400200529     C                   MOVE      '0'           *IN31
336500200529     C                   MOVE      '0'           *IN42
336600200529     C                   MOVE      '0'           *IN49
336700200529     C                   MOVE      '0'           *IN60
336800200529     C                   MOVE      '0'           *IN65
336900200529     C                   MOVE      '0'           *IN66
337000200529     C                   MOVE      '0'           *IN67
337100200529     C                   MOVE      '0'           *IN70
337200200529     C                   MOVE      '0'           *IN71
337300200529     C                   MOVE      '0'           *IN72
337400200529     C                   MOVE      '0'           *IN73
337500200529     C                   MOVE      '0'           *IN74
337600200529     C                   MOVE      '0'           *IN76
337700200529     C                   MOVE      '0'           *IN77
337800200529     C                   MOVE      '0'           *IN78
337900200529     C                   MOVE      '0'           *IN79
338000200529     C                   MOVE      '0'           *IN82
338100200529     C                   MOVE      '0'           *IN83
338200200529     C                   MOVE      '0'           *IN85
338300200529      *
338400200529      ** Process 'Full Details' Screen
338500200529      *
338600200529     C                   EXSR      P018
338700200529      *
338800200529      ** If F3 or F12 is pressed of if all fields protected
338900200529      *
339000200529     C     *INKC         IFEQ      '1'
339100200529     C     *INKL         OREQ      '1'
339200200529     C     *IN61         OREQ      '1'
339300200529      *
339400200529      ** Access Corporate Action Reference with current reference
339500200529      *
339600200529     C     #1REFN        CHAIN     SECORFL0                           88
339700200529      *
339800200529     C                   MOVE      *BLANKS       MAJOBN
339900200529     C                   MOVE      *BLANKS       MAUSER
340000200529     C                   Z-ADD     *ZEROS        MAJNBR
340100200529      *
340200200529     C                   UPDATE    SECORFD0
340300200529      *
340400200529      ** Update subfile fields
340500200529      *
340600200529     C                   MOVE      FIELD         #FIELD
340700200529      *
340800200529      ** Commitment instruction
340900200529      *
341000200529     C                   COMMIT
341100200529     C                   ENDIF
341200200529      *
341300200529     C                   MOVE      *BLANKS       #1SEL
341400200529      *
341500200529     C                   MOVE      WIN61         *IN61
341600200529      *
341700200529     C                   ENDIF
341800200529      *
341900200529      ** If 'Action' is delete
342000200529      *
342100200529     C     #1SEL         IFEQ      'D'
342200200529      *
342300200529      ** Delete records in depot files
342400200529      *
342500200529     C     #1REFN        SETLL     SECODPL0
342600200529     C     #1REFN        READE     SECODPL0                               89
342700200529      *
342800200529      ** Do while end of file not reached and same reference number
342900200529      *
343000200529     C     *IN89         DOWEQ     '0'
343100200529     C     #1REFN        ANDEQ     MBCORF
343200200529      *
343300200529     C                   DELETE    SECODPD0
343400200529      *
343500200529      ** Access next record
343600200529      *
343700200529     C     #1REFN        READE     SECODPL0                               89
343800200529     C                   ENDDO
343900200529      *
344000200529      ** Delete records in depot files
344100200529      *
344200200529     C     #1REFN        SETLL     SECODRL0
344300200529     C     #1REFN        READE     SECODRL0                               89
344400200529      *
344500200529      ** Do while end of file not reached and same reference number
344600200529      *
344700200529     C     *IN89         DOWEQ     '0'
344800200529     C     #1REFN        ANDEQ     MSCORF
344900200529      *
345000200529     C                   DELETE    SECODRD0
345100200529      *
345200200529      ** Access next record
345300200529      *
345400200529     C     #1REFN        READE     SECODRL0                               89
345500200529     C                   ENDDO
345600200529      *
345700200529      ** Delete records in allocation files
345800200529      *
345900200529     C     #1REFN        SETLL     SECOALL0
346000200529     C     #1REFN        READE     SECOALL0                               89
346100200529      *
346200200529      ** Do while end of file not reached and same reference number
346300200529      *
346400200529     C     *IN89         DOWEQ     '0'
346500200529     C     #1REFN        ANDEQ     MCCORF
346600200529      *
346700200529     C                   DELETE    SECOALD0
346800200529      *
346900200529      ** Access next record
347000200529      *
347100200529     C     #1REFN        READE     SECOALL0                               89
347200200529     C                   ENDDO
347300200529      *
347400200529      ** Delete records in Reply Handling files
347500200529      *
347600200529     C     #1REFN        SETLL     SECOREL0
347700200529     C     #1REFN        READE     SECOREL0                               89
347800200529      *
347900200529      ** Do while end of file not reached and same Reference Number
348000200529      *
348100200529     C     *IN89         DOWEQ     '0'
348200200529     C     #1REFN        ANDEQ     MQCORF
348300200529      *
348400200529     C                   DELETE    SECORED0
348500200529      *
348600200529      ** Access next record
348700200529      *
348800200529     C     #1REFN        READE     SECOREL0                               89
348900200529     C                   ENDDO
349000200529      *
349100200529      ** Delete records in Historic Reply Handling files
349200200529      *
349300200529     C     #1REFN        SETLL     SECORHL0
349400200529     C     #1REFN        READE     SECORHL0                               89
349500200529      *
349600200529      ** Do while end of file not reached and same reference number
349700200529      *
349800200529     C     *IN89         DOWEQ     '0'
349900200529     C     #1REFN        ANDEQ     MPCORF
350000200529      *
350100200529     C                   DELETE    SECORHD0
350200200529      *
350300200529      ** Access next record
350400200529      *
350500200529     C     #1REFN        READE     SECORHL0                               89
350600200529     C                   ENDDO
350700200529      *
350800200529      ** Delete records in blocking file
350900200529      *
351000200529     C     #1REFN        SETLL     SECOBKL1
351100200529     C     #1REFN        READE     SECOBKL1                               89
351200200529      *
351300200529      ** Do while end of file not reached and same reference number
351400200529      *
351500200529     C     *IN89         DOWEQ     '0'
351600200529     C     #1REFN        ANDEQ     MUCORF
351700200529      *
351800200529     C                   DELETE    SECOBKD0
351900200529      *
352000200529      ** Access next record
352100200529      *
352200200529     C     #1REFN        READE     SECOBKL1                               89
352300200529     C                   ENDDO
352400200529      *
352500200529      ** Delete all the relative options
352600200529      *
352700200529     C                   EXSR      P022
352800200529      *
352900200529      ** Access Corporate action Reference with current Reference
353000200529      *
353100200529     C     #1REFN        CHAIN     SECORFL0                           88
353200200529     C                   DELETE    SECORFD0
353300200529     C                   MOVE      'Y'           WRBLD
353400200529      *
353500200529      ** If Exercises and Conversions and 'DV', 'RG' or 'FR' linked
353600200529      ** Corporate Action exists.
353700200529      *
353800200529     C     #1PTYP        IFEQ      'EX'
353900200529     C     WWLNKR        ANDNE     *BLANKS
354000200529     C     WWLNKR        CHAIN     SECORFL9                           89
354100200529      *
354200200529      ** If Status of the 'DV', 'RG' or 'FR' linked Corporate Action
354300200529      ** neither Stock Autorised, nor Fully Authorised, nor Complete,
354400200529      ** set 'Rights' fields to blank or zero (and 'Subscription Rights
354500200529      ** Tradable' field if 'DV' to 'N').
354600200529      *
354700200529     C     *IN89         IFEQ      '0'
354800200529     C     MASTAT        IFNE      'S'
354900200529     C     MASTAT        ANDNE     'X'
355000200529     C     MASTAT        ANDNE     'C'
355100200529     C     WWPTYP        IFEQ      'DV'
355200200529     C     WWLNKR        CHAIN     SECODVL0                           89
355300200529     C     *IN89         IFEQ      '0'
355400200529     C                   MOVE      'N'           MDSBRT
355500200529     C                   MOVE      *BLANKS       MDSBRS
355600200529     C                   Z-ADD     0             MDREPR
355700200529     C                   Z-ADD     0             MDREXD
355800200529     C                   Z-ADD     0             MDREXA
355900200529     C                   MOVE      *BLANKS       MDREAT
356000200529     C                   Z-ADD     0             MDRNNS
356100200529     C                   Z-ADD     0             MDRNRI
356200200529     C                   Z-ADD     0             MDRMLT
356300200529     C                   Z-ADD     0             MDRDIV
356400200529     C                   Z-ADD     0             MDRTRF
356500200529     C                   Z-ADD     0             MDRTRT
356600200529     C                   Z-ADD     BJRDNB        MDLCD
356700200529     C                   MOVE      'A'           MDCHTP
356800200529     C                   MOVE      ##USR         MDLUID
356900200529     C                   UPDATE    SECODVD0
357000200529     C                   ENDIF
357100200529     C                   ELSE
357200200529     C     WWPTYP        IFEQ      'RG'
357300200529     C     WWLNKR        CHAIN     SECORGL0                           89
357400200529     C     *IN89         IFEQ      '0'
357500200529     C                   MOVE      *BLANKS       MFSBRS
357600200529     C                   Z-ADD     0             MFSBRP
357700200529     C                   Z-ADD     0             MFREXD
357800200529     C                   Z-ADD     0             MFREXA
357900200529     C                   MOVE      *BLANKS       MFREAT
358000200529     C                   Z-ADD     0             MFRNNS
358100200529     C                   Z-ADD     0             MFRNRI
358200200529     C                   Z-ADD     0             MFRMLT
358300200529     C                   Z-ADD     0             MFRDIV
358400200529     C                   Z-ADD     0             MFRTRF
358500200529     C                   Z-ADD     0             MFRTRT
358600200529     C                   MOVE      *BLANKS       MFAVOP
358700200529     C                   Z-ADD     BJRDNB        MFLCD
358800200529     C                   MOVE      'A'           MFCHTP
358900200529     C                   MOVE      ##USR         MFLUID
359000200529     C                   UPDATE    SECORGD0
359100200529     C                   ENDIF
359200200529     C                   ELSE
359300200529     C     WWLNKR        CHAIN     SECOFRL0                           89
359400200529     C     *IN89         IFEQ      '0'
359500200529     C                   MOVE      'N'           MESBRT
359600200529     C                   MOVE      *BLANKS       MESBRS
359700200529     C                   Z-ADD     0             MEREPR
359800200529     C                   Z-ADD     0             MEREXD
359900200529     C                   Z-ADD     0             MEREXA
360000200529     C                   MOVE      *BLANKS       MEREAT
360100200529     C                   Z-ADD     0             MERNNS
360200200529     C                   Z-ADD     0             MERNRI
360300200529     C                   Z-ADD     0             MERMLT
360400200529     C                   Z-ADD     0             MERDIV
360500200529     C                   Z-ADD     0             MERTRF
360600200529     C                   Z-ADD     0             MERTRT
360700200529     C                   Z-ADD     BJRDNB        MELCD
360800200529     C                   MOVE      'A'           MECHTP
360900200529     C                   MOVE      ##USR         MELUID
361000200529     C                   UPDATE    SECOFRD0
361100200529     C                   ENDIF
361200200529     C                   ENDIF
361300200529     C                   ENDIF
361400200529     C                   ENDIF
361500200529     C                   ENDIF
361600200529     C                   ENDIF
361700200529      *
361800200529      ** Commitment instruction
361900200529      *
362000200529     C                   COMMIT
362100200529      *
362200200529     C                   MOVE      *BLANKS       #1SEL
362300200529     C                   MOVE      '0'           WIN45
362400200529     C                   ENDIF
362500200529      *
362600200529      ** If 'Action' is Authorisation (Processing type 'NC')
362700200529      *
362800200529     C     #1SEL         IFEQ      'N'
362900200529      *
363000200529      ** Access Corporate Action Reference with Current Reference
363100200529      *
363200200529     C     #1REFN        CHAIN     SECORFL0                           88
363300200529      *
363400200529     C                   MOVE      'D'           MARECI
363500200529     C                   Z-ADD     BJRDNB        MALCD
363600200529     C                   MOVE      'A'           MACHTP
363700200529     C                   MOVE      ##USR         MALUID
363800200529     C                   MOVE      'X'           MASTAT
363900200529     C                   UPDATE    SECORFD0
364000200529     C                   MOVE      'Y'           WRBLD
364100200529      *
364200200529      ** Update subfile fields
364300200529      *
364400200529     C                   MOVE      FIELD         #FIELD
364500200529     C                   MOVE      *BLANKS       #1SEL
364600200529     C                   MOVE      'X'           #1GSTS
364700200529      *
364800200529      ** Commitment Instruction
364900200529      *
365000200529     C                   COMMIT
365100200529     C                   ENDIF
365200200529      *
365300200529      ** If 'Action' is Customer Reply Handle
365400200529      *
365500200529     C     #1SEL         IFEQ      'Y'
365600200529      *
365700200529     C                   MOVE      *BLANKS       P#RTCD
365800200529      *
365900200529     C                   MOVE      #1EXDT        DateIn
366000200529     C                   EXSR      ZDATE1
366100200529     C                   MOVE      DAYNOOUT      WEXDAT
366200200529      *
366300200529     C                   CALL      'SE7514'                             99
366400200529     C                   PARM                    #1REFN                         ER Reference
366500200529     C                   PARM                    #1SECN                         Security Shortname
366600200529     C                   PARM                    #1COAT                         Corporate Action Typ
366700200529     C                   PARM                    #1STAT                         Corporate Action Sta
366800200529     C                   PARM                    #1PTYP                         Processing Type
366900200529     C                   PARM                    WEXDAT            5            Ex-Date
367000200529     C                   PARM                    NMCY              3            Nominal Currency
367100200529     C                   PARM                    P#RTCD            1            Return Code
367200200529      *
367300200529      ** If error indicator of the program call is on or if return
367400200529      ** Code is equal to 'E' (Error), database error
367500200529      *
367600200529     C     *IN99         IFEQ      '1'
367700200529     C     P#RTCD        OREQ      'E'
367800200529     C                   MOVEL     '007'         DBASE             3 0          *****************
367900200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 07 **
368000200529     C                   MOVEL     NARR(6)       DBKEY            29            *****************
368100200529     C                   EXSR      *PSSR
368200200529     C                   ENDIF
368300200529      *
368400200529     C     P#RTCD        IFNE      'M'
368500200529     C                   MOVE      *BLANKS       #1SEL
368600200529     C                   ENDIF
368700200529      *
368800200529      ** If Return Code is equal to '2', '3' or 'M'
368900200529      *
369000200529     C     P#RTCD        IFEQ      '2'
369100200529     C     P#RTCD        OREQ      '3'
369200200529     C     P#RTCD        OREQ      'M'
369300200529      *
369400200529      ** Access Corporate Action Reference with Current Reference
369500200529      *
369600200529     C     #1REFN        CHAIN     SECORFL0                           88
369700200529      *
369800200529     C                   MOVE      *BLANKS       MAJOBN
369900200529     C                   MOVE      *BLANKS       MAUSER
370000200529     C                   Z-ADD     *ZEROS        MAJNBR
370100200529      *
370200200529     C                   UPDATE    SECORFD0
370300200529      *
370400200529      ** Update subfile fields
370500200529      *
370600200529     C                   MOVE      FIELD         #FIELD
370700200529      *
370800200529      ** Commitment instruction
370900200529      *
371000200529     C                   COMMIT
371100200529      *
371200200529     C     P#RTCD        IFEQ      '3'
371300200529     C                   MOVE      '1'           *INKC
371400200529     C                   ENDIF
371500200529      *
371600200529     C                   ENDIF
371700200529      *
371800200529     C                   MOVE      *BLANKS       #1SEL
371900200529      *
372000200529     C                   ENDIF
372100200529      *
372200200529      ** If 'Action' is view Customer Allocations
372300200529      *
372400200529     C     #1SEL         IFEQ      'V'
372500200529      *
372600200529     C                   MOVE      *BLANKS       P#RTCD
372700200529     C     *LOCK         IN        LDA
372800200529     C                   MOVEL     'SE7502'      PGMNAM
372900200529     C                   OUT       LDA
373000200529      *
373100200529     C                   CALL      'SE7540'                             99
373200200529     C                   PARM                    #1REFN                         ER Reference
373300200529     C                   PARM      *BLANKS       WWOPTN            2            Option number
373400200529     C                   PARM      *BLANKS       WWBRCD            3            Branch Code
373500200529     C                   PARM      *BLANKS       WWBOOK            2            Book
373600200529     C                   PARM      *BLANKS       WWCUST            6            Customer
373700200529     C                   PARM      *BLANKS       WWPTFR            4            Portfolio
373800200529     C                   PARM      *BLANKS       WWCPGM            6            Calling Pgm
373900200529     C                   PARM                    P#RTCD            1            Return Code
374000200529      *
374100200529     C     *LOCK         IN        LDA
374200200529     C                   MOVEL     *BLANKS       PGMNAM
374300200529     C                   OUT       LDA
374400200529      *
374500200529      ** If error indicator of the program call is on or if return
374600200529      ** Code is equal to 'E' (Error), database error
374700200529      *
374800200529     C     *IN99         IFEQ      '1'
374900200529     C     P#RTCD        OREQ      'E'
375000200529     C                   MOVEL     '008'         DBASE             3 0          *****************
375100200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 08 **
375200200529     C                   MOVEL     NARR(9)       DBKEY            29            *****************
375300200529     C                   EXSR      *PSSR
375400200529     C                   ENDIF
375500200529      *
375600200529     C     P#RTCD        IFNE      'M'
375700200529     C                   MOVE      *BLANKS       #1SEL
375800200529     C                   ENDIF
375900200529      *
376000200529      ** If Return code is equal to '2', '3' or 'M'
376100200529      *
376200200529     C     P#RTCD        IFEQ      '2'
376300200529     C     P#RTCD        OREQ      '3'
376400200529     C     P#RTCD        OREQ      'M'
376500200529      *
376600200529      ** Access Corporate Action Reference with current Reference
376700200529      *
376800200529     C     #1REFN        CHAIN     SECORFL0                           88
376900200529      *
377000200529     C                   MOVE      *BLANKS       MAJOBN
377100200529     C                   MOVE      *BLANKS       MAUSER
377200200529     C                   Z-ADD     *ZEROS        MAJNBR
377300200529      *
377400200529     C                   UPDATE    SECORFD0
377500200529      *
377600200529      ** Update subfile fields
377700200529      *
377800200529     C                   MOVE      FIELD         #FIELD
377900200529      *
378000200529      ** Commitment Instruction
378100200529      *
378200200529     C                   COMMIT
378300200529      *
378400200529     C     P#RTCD        IFEQ      '3'
378500200529     C                   MOVE      '1'           *INKC
378600200529     C                   ENDIF
378700200529     C                   ENDIF
378800200529      *
378900200529     C                   ENDIF
379000200529      *
379100200529      ** If 'Action' is Print Correspondence, *** Future use, Phase II ***
379200200529      *
379300200529     C     #1SEL         IFEQ      'C'
379400200529      *
379500200529     C                   MOVE      'Y'           ERMSG
379600200529     C                   MOVE      '1'           *IN62                          Reverse image
379700200529     C                   MOVEL     'CO00258'     ZAMSID
379800200529     C                   EXSR      ZASNMS
379900200529      *
380000200529      ** Access Corporate Action Reference with Current Reference
380100200529      *
380200200529     C     #1REFN        CHAIN     SECORFL0                           88
380300200529      *
380400200529     C                   MOVE      *BLANKS       MAJOBN
380500200529     C                   MOVE      *BLANKS       MAUSER
380600200529     C                   Z-ADD     *ZEROS        MAJNBR
380700200529      *
380800200529     C                   UPDATE    SECORFD0
380900200529      *
381000200529      ** Update subfile fields
381100200529      *
381200200529     C                   MOVE      FIELD         #FIELD
381300200529      *
381400200529      ** Commitment Instruction
381500200529      *
381600200529     C                   COMMIT
381700200529      *
381800200529     C                   ENDIF
381900200529      *
382000200529     C     TAG3          ENDSR
382100200529      *****************************************************************
382200200529      /EJECT
382300200529      *****************************************************************
382400200529      * P010   : Process 'Confirmation' Screen                        *
382500200529      *****************************************************************
382600200529      *
382700200529     C     P010          BEGSR
382800200529      *
382900200529     C                   MOVE      *BLANKS       #1CONF
383000200529      *
383100200529     C                   MOVE      '0'           *IN40
383200200529     C                   MOVE      '0'           *IN41
383300200529      *
383400200529     C                   MOVE      '0'           *IN44
383500200529     C                   MOVE      '1'           *IN47
383600200529      *
383700200529      ** If Delete or Reverse of a Corporate Action type Exercises an  d
383800200529      ** Conversions, check if there is a linked Corporate Action.
383900200529      *
384000200529     C                   MOVE      *BLANKS       REFLIN
384100200529     C     #1PTYP        IFEQ      'EX'
384200200529     C     #1SEL         ANDEQ     'D'
384300200529     C     #1PTYP        OREQ      'EX'
384400200529     C     #1SEL         ANDEQ     'R'
384500200529     C     #1REFN        CHAIN(N)  SECOEXL0                           89
384600200529     C     MJLNKR        IFNE      *BLANKS
384700200529     C     MJLNKR        CHAIN(N)  SECODVL0                           89
384800200529     C     *IN89         IFEQ      '0'
384900200529     C                   MOVE      MJLNKR        WWLNKR
385000200529     C                   MOVE      'DV'          WWPTYP
385100200529     C                   ELSE
385200200529     C     MJLNKR        CHAIN(N)  SECORGL0                           89
385300200529     C     *IN89         IFEQ      '0'
385400200529     C                   MOVE      MJLNKR        WWLNKR
385500200529     C                   MOVE      'RG'          WWPTYP
385600200529     C                   ELSE
385700200529     C     MJLNKR        CHAIN(N)  SECOFRL0                           89
385800200529     C     *IN89         IFEQ      '0'
385900200529     C                   MOVE      MJLNKR        WWLNKR
386000200529     C                   MOVE      'FR'          WWPTYP
386100200529     C                   ENDIF
386200200529     C                   ENDIF
386300200529     C                   ENDIF
386400200529     C                   ENDIF
386500200529     C                   ENDIF
386600200529      *
386700200529      ** Depending of the 'Action', Set the correct narrative
386800200529      **   *** CONFIRM REVERSAL ***
386900200529      *
387000200529     C     #1SEL         IFEQ      'R'
387100200529     C                   MOVE      '1'           *IN40
387200200529     C                   MOVE      '0'           *IN41
387300200529     C                   ELSE
387400200529      *
387500200529      **   *** CONFIRM DELETION ***
387600200529      *
387700200529     C     #1SEL         IFEQ      'D'
387800200529     C                   MOVE      '0'           *IN40
387900200529     C                   MOVE      '0'           *IN41
388000200529     C                   ELSE
388100200529      *
388200200529      **   *** CONFIRM AUTHORISATION ***
388300200529      *
388400200529     C     #1SEL         IFEQ      'N'
388500200529     C                   MOVE      '0'           *IN40
388600200529     C                   MOVE      '1'           *IN41
388700200529     C                   ENDIF
388800200529     C                   ENDIF
388900200529     C                   ENDIF
389000200529      *
389100200529     C                   MOVEA     TXT(6)        ##CTX1
389200200529      *
389300200529      ** Do while F3 or F12 not pressed and no error
389400200529      *
389500200529     C     *INKC         DOWEQ     '0'
389600200529     C     *INKL         ANDEQ     '0'
389700200529     C     #1CONF        ANDNE     'Y'
389800200529     C     #1CONF        ANDNE     'N'
389900200529      *
390000200529      ** Setup Screen time
390100200529      *
390200200529     C                   TIME                    ##TME                          Screen time.
390300200529      *
390400200529      ** If Delete or Reverse CO type 'EX' linked with CO type 'DV' o  r
390500200529      ** 'RG' or 'FR', send warning message.
390600200529      *
390700200529     C     #1SEL         IFEQ      'D'
390800200529     C     WWLNKR        ANDNE     *BLANKS
390900200529     C     #1SEL         OREQ      'R'
391000200529     C     WWLNKR        ANDNE     *BLANKS
391100200529     C                   MOVEL(P)  REFLIN        ZAMSDA
391200200529     C                   MOVEL     'CO00600'     ZAMSID                         Message id.
391300200529     C                   EXSR      ZASNMS                                       Send message
391400200529     C                   ENDIF
391500200529      *
391600200529      ** Execute Screen format
391700200529      *
391800200529     C                   WRITE     #MSGCTL
391900200529     C                   WRITE     SE7502F1
392000200529     C                   EXFMT     SE7502F2
392100200529      *
392200200529     C     *INKL         IFEQ      '1'
392300200529     C                   MOVE      '1'           WIN12
392400200529     C                   ELSE
392500200529     C                   MOVE      '0'           WIN12
392600200529     C                   ENDIF
392700200529      *
392800200529     C     *INKC         IFEQ      '1'
392900200529     C                   MOVE      '3'           P#RTCD
393000200529     C                   ENDIF
393100200529      *
393200200529      ** Clear messages from program message queue.
393300200529      *
393400200529     C                   CALL      'Y2CLMSC'
393500200529     C                   PARM      ##PGM         ZAPGM            10
393600200529     C                   PARM      '*SAME'       ZAPGRL            5
393700200529      *
393800200529      ** If 'Confirmation indicator' is not equal to 'Y' or 'N'
393900200529      *
394000200529     C     #1CONF        IFNE      'N'
394100200529     C     #1CONF        ANDNE     'Y'
394200200529     C                   MOVE      '1'           *IN44                          Reverse image
394300200529     C                   MOVEL     'CO00032'     ZAMSID                         Message id.
394400200529     C                   EXSR      ZASNMS                                       Send message
394500200529     C                   ELSE
394600200529     C                   MOVE      '0'           *IN44                          Reverse image
394700200529     C                   ENDIF
394800200529     C                   ENDDO
394900200529      *
395000200529     C                   MOVEA     TXT(9)        ##CTX1
395100200529     C                   MOVE      '0'           *IN47
395200200529      *
395300200529     C                   ENDSR
395400200529      *****************************************************************
395500200529      /EJECT
395600200529      *****************************************************************
395700200529      * P011   : Write Option(s) with default Information             *
395800200529      *****************************************************************
395900200529      *
396000200529     C     P011          BEGSR
396100200529      *
396200200529     C                   MOVEL     NARR(4)       WWOPSH           26
396300200529     C                   MOVE      WWOPNB        WWOPSH
396400200529      *
396500200529     C     MAPTYP        IFEQ      'DV'
396600200529     C                   CLEAR                   SECODVD0
396700200529     C                   MOVE      'D'           MDRECI
396800200529     C                   Z-ADD     BJRDNB        MDLCD
396900200529     C                   MOVE      'I'           MDCHTP
397000200529     C                   MOVE      ##USR         MDLUID
397100200529     C                   MOVE      #1REFN        MDCORF
397200200529     C                   Z-ADD     WWOPNB        MDOPTN
397300200529     C                   MOVE      #1SECN        MDNSEC
397400200529     C                   MOVE      'D'           MDRNDN
397500200529     C                   MOVE      'N'           MDRNDS
397600200529     C                   MOVE      'N'           MDSBRT
397700200529     C                   MOVEL     WWOPSH        MDOPSH
397800200529     C                   WRITE     SECODVD0
397900200529     C                   ELSE
398000200529     C     MAPTYP        IFEQ      'FR'
398100200529     C                   CLEAR                   SECOFRD0
398200200529     C                   MOVE      'D'           MERECI
398300200529     C                   Z-ADD     BJRDNB        MELCD
398400200529     C                   MOVE      'I'           MECHTP
398500200529     C                   MOVE      ##USR         MELUID
398600200529     C                   MOVE      #1REFN        MECORF
398700200529     C                   Z-ADD     WWOPNB        MEOPTN
398800200529     C                   MOVE      #1SECN        MENSEC
398900200529     C                   MOVE      'D'           MERNDN
399000200529     C                   MOVE      'N'           MERNDS
399100200529     C                   MOVEL     WWOPSH        MEOPSH
399200200529     C                   WRITE     SECOFRD0
399300200529     C                   ELSE
399400200529     C     MAPTYP        IFEQ      'CE'
399500200529     C                   CLEAR                   SECOCED0
399600200529     C                   MOVE      'D'           MGRECI
399700200529     C                   Z-ADD     BJRDNB        MGLCD
399800200529     C                   MOVE      'I'           MGCHTP
399900200529     C                   MOVE      ##USR         MGLUID
400000200529     C                   MOVE      #1REFN        MGCORF
400100200529     C                   Z-ADD     WWOPNB        MGOPTN
400200200529     C                   MOVEL     WWOPSH        MGOPSH
400300200529     C                   WRITE     SECOCED0
400400200529     C                   ELSE
400500200529     C     MAPTYP        IFEQ      'CR'
400600200529     C                   CLEAR                   SECOCRD0
400700200529     C                   MOVE      'D'           MHRECI
400800200529     C                   Z-ADD     BJRDNB        MHLCD
400900200529     C                   MOVE      'I'           MHCHTP
401000200529     C                   MOVE      ##USR         MHLUID
401100200529     C                   MOVE      #1REFN        MHCORF
401200200529     C                   Z-ADD     WWOPNB        MHOPTN
401300200529     C                   MOVEL     WWOPSH        MHOPSH
401400200529     C                   WRITE     SECOCRD0
401500200529     C                   ELSE
401600200529     C     MAPTYP        IFEQ      'OF'
401700200529     C                   CLEAR                   SECOOFD0
401800200529     C                   MOVE      'D'           MIRECI
401900200529     C                   Z-ADD     BJRDNB        MILCD
402000200529     C                   MOVE      'I'           MICHTP
402100200529     C                   MOVE      ##USR         MILUID
402200200529     C                   MOVE      #1REFN        MICORF
402300200529     C                   MOVE      'D'           MIRNDN
402400200529     C                   MOVE      'N'           MIRNDS
402500200529     C                   Z-ADD     WWOPNB        MIOPTN
402600200529     C                   MOVEL     WWOPSH        MIOPSH
402700200529     C                   WRITE     SECOOFD0
402800200529     C                   ELSE
402900200529     C     MAPTYP        IFEQ      'RG'
403000200529     C                   CLEAR                   SECORGD0
403100200529     C                   MOVE      'D'           MFRECI
403200200529     C                   Z-ADD     BJRDNB        MFLCD
403300200529     C                   MOVE      'I'           MFCHTP
403400200529     C                   MOVE      ##USR         MFLUID
403500200529     C                   MOVE      #1REFN        MFCORF
403600200529     C                   Z-ADD     WWOPNB        MFOPTN
403700200529     C                   MOVE      #1SECN        MFNSEC
403800200529     C                   MOVE      'D'           MFRNDN
403900200529     C                   MOVE      'N'           MFRNDS
404000200529     C                   MOVEL     WWOPSH        MFOPSH
404100200529     C                   WRITE     SECORGD0
404200200529     C                   ELSE
404300200529     C     MAPTYP        IFEQ      'EX'
404400200529     C                   CLEAR                   SECOEXD0
404500200529     C                   MOVE      'D'           MJRECI
404600200529     C                   Z-ADD     BJRDNB        MJLCD
404700200529     C                   MOVE      'I'           MJCHTP
404800200529     C                   MOVE      ##USR         MJLUID
404900200529     C                   MOVE      #1REFN        MJCORF
405000200529     C                   Z-ADD     WWOPNB        MJOPTN
405100200529     C                   MOVE      'D'           MJRNDN
405200200529     C                   MOVE      'N'           MJRNDS
405300200529     C                   MOVE      'N'           MJOPT1
405400200529     C                   MOVE      'N'           MJOPT2
405500200529     C                   MOVE      'N'           MJOPT3
405600200529     C                   MOVE      'N'           MJOPT4
405700200529     C                   MOVE      'N'           MJOPT5
405800200529     C                   MOVE      'N'           MJOPT6
405900200529     C                   MOVE      'N'           MJOPT7
406000200529     C                   MOVEL     WWOPSH        MJOPSH
406100200529     C                   WRITE     SECOEXD0
406200200529     C                   ELSE
406300200529     C     MAPTYP        IFEQ      'NF'
406400200529     C                   CLEAR                   SECONFD0
406500200529     C                   MOVE      'D'           MKRECI
406600200529     C                   Z-ADD     BJRDNB        MKLCD
406700200529     C                   MOVE      'I'           MKCHTP
406800200529     C                   MOVE      ##USR         MKLUID
406900200529     C                   MOVE      #1REFN        MKCORF
407000200529     C                   Z-ADD     1             MKSEQN
407100200529     C                   WRITE     SECONFD0
407200200529     C                   ELSE
407300200529     C     MAPTYP        IFEQ      'NC'
407400200529     C                   CLEAR                   SECONCD0
407500200529     C                   MOVE      'D'           MLRECI
407600200529     C                   Z-ADD     BJRDNB        MLLCD
407700200529     C                   MOVE      'I'           MLCHTP
407800200529     C                   MOVE      ##USR         MLLUID
407900200529     C                   MOVE      #1REFN        MLCORF
408000200529     C                   WRITE     SECONCD0
408100200529     C                   ELSE
408200200529     C     MAPTYP        IFEQ      'CC'
408300200529     C                   CLEAR                   SECOCCD0
408400200529     C                   MOVE      'D'           NARECI
408500200529     C                   Z-ADD     BJRDNB        NALCD
408600200529     C                   MOVE      'I'           NACHTP
408700200529     C                   MOVE      ##USR         NALUID
408800200529     C                   MOVE      #1REFN        NACORF
408900200529     C                   WRITE     SECOCCD0
409000200529     C                   ENDIF
409100200529     C                   ENDIF
409200200529     C                   ENDIF
409300200529     C                   ENDIF
409400200529     C                   ENDIF
409500200529     C                   ENDIF
409600200529     C                   ENDIF
409700200529     C                   ENDIF
409800200529     C                   ENDIF
409900200529     C                   ENDIF
410000200529      *
410100200529     C                   ENDSR
410200200529      *****************************************************************
410300200529      /EJECT
410400200529      *****************************************************************
410500200529      * P014   : Reinitialise Indicators                              *
410600200529      *****************************************************************
410700200529      *
410800200529     C     P014          BEGSR
410900200529      *
411000200529      ** Reinitialise indicators
411100200529      *
411200200529     C                   MOVE      '0'           *IN28                          Error on Allocation
411300200529     C                   MOVE      '0'           *IN29                          Error on Number Opti
411400200529     C                   MOVE      '0'           *IN32                          Error on Ex-Date
411500200529     C                   MOVE      '0'           *IN33                          Error on Action Type
411600200529     C                   MOVE      '0'           *IN34                          Error on Status
411700200529     C                   MOVE      '0'           *IN37                          Error on Date Announ
411800200529     C                   MOVE      '0'           *IN38                          Error on Reference
411900200529     C                   MOVE      '0'           *IN39                          Error on Shortname
412000200529     C                   MOVE      '0'           *IN62                          Error on Action
412100200529      *
412200200529     C                   ENDSR
412300200529      *****************************************************************
412400200529      /EJECT
412500200529      *****************************************************************
412600200529      * P015   : Clear Sfl Fields                                     *
412700200529      *****************************************************************
412800200529      *
412900200529     C     P015          BEGSR
413000200529      *
413100200529      ** Initialise subfile record
413200200529      *
413300200529     C                   MOVE      *BLANKS       #1SEL
413400200529     C                   MOVE      *BLANKS       #1REFN
413500200529     C                   MOVE      *BLANKS       #1SECN
413600200529     C                   MOVE      *BLANKS       #1COAT
413700200529     C                   MOVE      *BLANKS       #1COAN
413800200529     C                   MOVE      *BLANKS       #1EXDT
413900200529     C                   MOVE      *BLANKS       #1ALEF
414000200529     C                   MOVE      *BLANKS       #1NBOP
414100200529     C                   MOVE      *BLANKS       #1GSTS
414200200529      *
414300200529      ** Initialise hidden subfile fields
414400200529      *
414500200529     C                   MOVE      *BLANKS       #FIELD
414600200529     C                   MOVE      *BLANKS       #1PTYP
414700200529     C                   MOVE      *BLANKS       #1TDVD
414800200529      *
414900200529     C                   MOVE      *BLANKS       #2SEL
415000200529     C                   MOVE      *BLANKS       #2COAN
415100200529     C                   MOVE      *BLANKS       #2EXDT
415200200529     C                   MOVE      *BLANKS       #2ALEF
415300200529      *
415400200529     C                   ENDSR
415500200529      ********************************************************************
415600200529      /EJECT
415700200529      *****************************************************************
415800200529      * P016  : Load Sfl Fields                                       *
415900200529      *****************************************************************
416000200529      *
416100200529     C     P016          BEGSR
416200200529      *
416300200529      ** Initialise subfile record
416400200529      *
416500200529     C                   MOVE      *BLANKS       #1SEL
416600200529     C                   MOVE      MACORF        #1REFN
416700200529     C                   MOVE      MASESN        #1SECN
416800200529     C                   MOVE      MACOAT        #1COAT
416900200529     C                   MOVE      MAPTYP        #1PTYP
417000200529     C                   MOVE      MATDVD        #1TDVD
417100200529      *
417200200529     C     MACOAN        IFNE      *ZEROS
417300200529     C                   Z-ADD     MACOAN        ZDAYNO
417400200529     C                   EXSR      ZDATE2
417500200529      *
417600200529     C                   MOVE      ZDATE         #1COAN
417700200529     C                   ELSE
417800200529     C                   MOVE      *BLANKS       #1COAN
417900200529     C                   ENDIF
418000200529      *
418100200529     C     MACOEX        IFNE      *ZEROS
418200200529     C                   Z-ADD     MACOEX        ZDAYNO
418300200529     C                   EXSR      ZDATE2
418400200529     C                   MOVE      ZDATE         #1EXDT
418500200529     C                   ELSE
418600200529     C                   MOVE      *BLANKS       #1EXDT
418700200529     C                   ENDIF
418800200529      *
418900200529     C     MAALEF        IFNE      *ZEROS
419000200529     C                   Z-ADD     MAALEF        ZDAYNO
419100200529     C                   EXSR      ZDATE2
419200200529     C                   MOVE      ZDATE         #1ALEF
419300200529     C                   ELSE
419400200529     C                   MOVE      *BLANKS       #1ALEF
419500200529     C                   ENDIF
419600200529      *
419700200529     C                   MOVE      MANBOP        #1NBOP
419800200529     C                   MOVE      MASTAT        #1GSTS
419900200529      *
420000200529      ** Initialise hidden subfile fields
420100200529      *
420200200529     C                   MOVE      MAJOBN        WAJOBN           10
420300200529     C                   MOVE      MAUSER        WAUSER           10
420400200529     C                   Z-ADD     MAJNBR        WAJNBR            6 0
420500200529     C                   MOVE      *BLANKS       MAJOBN
420600200529     C                   MOVE      *BLANKS       MAUSER
420700200529     C                   Z-ADD     *ZEROS        MAJNBR
420800200529     C                   MOVE      FIELD         #FIELD
420900200529     C                   MOVE      WAJOBN        MAJOBN
421000200529     C                   MOVE      WAUSER        MAUSER
421100200529     C                   Z-ADD     WAJNBR        MAJNBR
421200200529     C                   MOVE      *BLANKS       #2SEL
421300200529     C                   MOVE      #1COAN        #2COAN
421400200529     C                   MOVE      #1EXDT        #2EXDT
421500200529     C                   MOVE      #1ALEF        #2ALEF
421600200529      *
421700200529     C                   ENDSR
421800200529      ********************************************************************
421900200529      /EJECT
422000200529      *****************************************************************
422100200529      * P018  : Process 'Full Details' Screen                         *
422200200529      *****************************************************************
422300200529      *
422400200529     C     P018          BEGSR
422500200529      *
422600200529      ** Setup the display fields
422700200529      *
422800200529     C                   MOVE      *BLANKS       #1BLKR
422900200529     C     MAPTYP        IFEQ      'CC'
423000200529     C     #1REFN        CHAIN     SECOCCL0                           89
423100200529      *
423200200529     C     *IN89         IFEQ      '0'
423300200529     C     NABLKR        ANDNE     *ZEROS
423400200529     C                   MOVE      NABLKR        #1BLKR
423500200529     C                   ENDIF
423600200529      *
423700200529     C     MAPREF        IFNE      *BLANKS
423800200529     C                   MOVE      MAPREF        #PREF
423900200529     C                   MOVE      '1'           *IN12
424000200529     C                   ELSE
424100200529     C                   MOVE      '0'           *IN12
424200200529     C                   ENDIF
424300200529     C                   MOVE      *IN12         WWIN12            1
424400200529      *
424500200529     C                   ENDIF
424600200529      *
424700200529     C                   MOVE      MATDVD        #1TDVD
424800200529      *
424900200529     C     MACOPD        IFNE      *ZEROS
425000200529     C                   Z-ADD     MACOPD        ZDAYNO
425100200529     C                   EXSR      ZDATE2
425200200529     C                   MOVE      ZDATE         #1COPD
425300200529     C                   ELSE
425400200529     C                   MOVE      #1ALEF        #1COPD
425500200529     C                   ENDIF
425600200529      *
425700200529     C     MATDDT        IFNE      *ZEROS
425800200529     C                   Z-ADD     MATDDT        ZDAYNO
425900200529     C                   EXSR      ZDATE2
426000200529     C                   MOVE      ZDATE         #1TDDT
426100200529     C                   ELSE
426200200529     C                   MOVE      #1ALEF        #1TDDT
426300200529     C                   ENDIF
426400200529      *
426500200529     C     MAEVDT        IFNE      *ZEROS
426600200529     C                   Z-ADD     MAEVDT        ZDAYNO
426700200529     C                   EXSR      ZDATE2
426800200529     C                   MOVE      ZDATE         #1EVDT
426900200529     C                   ELSE
427000200529     C                   MOVE      #1EXDT        #1EVDT
427100200529     C                   ENDIF
427200200529      *
427300200529     C     MACPNB        IFEQ      *ZEROS
427400200529     C                   MOVE      *BLANKS       #1CPNB
427500200529     C                   ELSE
427600200529     C                   MOVE      MACPNB        #1CPNB
427700200529     C                   ENDIF
427800200529      *
427900200529     C     MASHMD        IFNE      *ZEROS
428000200529     C                   Z-ADD     MASHMD        ZDAYNO
428100200529     C                   EXSR      ZDATE2
428200200529      *
428300200529     C                   MOVE      ZDATE         #1SHMD
428400200529     C                   ELSE
428500200529     C                   MOVE      *BLANKS       #1SHMD
428600200529     C                   ENDIF
428700200529      *
428800200529     C                   MOVE      MALTBS        #1LTBS
428900200529      *
429000200529      ** Access Security Details to Retrieve Number of Decimals
429100200529      ** on the Security
429200200529      *
429300200529     C     MASESN        CHAIN     SECTYZ1                            89
429400200529      *
429500200529     C     MAOCPV        IFNE      *ZEROS
429600200529     C                   Z-ADD     *ZEROS        ZFLD15
429700200529     C                   Z-ADD     MAOCPV        ZFLD15
429800200529     C                   Z-ADD     NMDP          ZDECS
429900200529     C                   MOVE      'L'           ZECODE
430000200529      *
430100200529     C                   EXSR      ZSEDIT
430200200529     C                   MOVEL     *BLANKS       #1OCPV
430300200529     C                   MOVE      ZOUT21        WFLD17           17
430400200529     C                   MOVEL     WFLD17        #1OCPV
430500200529     C                   ELSE
430600200529     C                   MOVE      *BLANKS       #1OCPV
430700200529     C                   ENDIF
430800200529      *
430900200529     C     MANCPV        IFNE      *ZEROS
431000200529     C                   MOVE      *BLANKS       ZFLD15
431100200529     C                   MOVE      MANCPV        ZFLD15
431200200529     C                   Z-ADD     NMDP          ZDECS
431300200529     C                   MOVE      'L'           ZECODE
431400200529      *
431500200529     C                   EXSR      ZSEDIT
431600200529      *
431700200529     C                   MOVEL     *BLANKS       #1NCPV
431800200529     C                   MOVE      ZOUT21        WFLD17
431900200529     C                   MOVEL     WFLD17        #1NCPV
432000200529     C                   ELSE
432100200529     C                   MOVE      *BLANKS       #1NCPV
432200200529     C                   ENDIF
432300200529      *
432400200529     C     MAONML        IFNE      *ZEROS
432500200529     C                   MOVE      *BLANKS       ZFLD15
432600200529     C                   MOVE      MAONML        ZFLD15
432700200529     C                   Z-ADD     NMDP          ZDECS
432800200529     C                   MOVE      'L'           ZECODE
432900200529      *
433000200529     C                   EXSR      ZSEDIT
433100200529      *
433200200529     C                   MOVEL     *BLANKS       #1ONML
433300200529     C                   MOVE      ZOUT21        WFLD17
433400200529     C                   MOVEL     WFLD17        #1ONML
433500200529     C                   ELSE
433600200529     C                   MOVE      *BLANKS       #1ONML
433700200529     C                   ENDIF
433800200529      *
433900200529     C     MANNML        IFNE      *ZEROS
434000200529     C                   MOVE      *BLANKS       ZFLD15
434100200529     C                   MOVE      MANNML        ZFLD15
434200200529     C                   Z-ADD     NMDP          ZDECS
434300200529     C                   MOVE      'L'           ZECODE
434400200529      *
434500200529     C                   EXSR      ZSEDIT
434600200529      *
434700200529     C                   MOVEL     *BLANKS       #1NNML
434800200529     C                   MOVE      ZOUT21        WFLD17
434900200529     C                   MOVEL     WFLD17        #1NNML
435000200529     C                   ELSE
435100200529     C                   MOVE      *BLANKS       #1NNML
435200200529     C                   ENDIF
435300200529      *
435400200529     C     MACUPC        IFNE      *ZEROS
435500200529     C                   MOVE      *BLANKS       ZFLD15
435600200529     C                   MOVE      MACUPC        ZFLD15
435700200529     C                   Z-ADD     8             ZDECS
435800200529     C                   MOVE      'L'           ZECODE
435900200529      *
436000200529     C                   EXSR      ZSEDIT
436100200529      *
436200200529     C                   MOVEL     *BLANKS       #1CUPC
436300200529     C                   MOVE      ZOUT21        WFLD17
436400200529     C                   MOVEL     WFLD17        #1CUPC
436500200529     C                   ELSE
436600200529     C                   MOVE      *BLANKS       #1CUPC
436700200529     C                   ENDIF
436800200529      *
436900200529     C     MAEXPC        IFNE      *ZEROS
437000200529     C                   MOVE      *BLANKS       ZFLD15
437100200529     C                   MOVE      MAEXPC        ZFLD15
437200200529     C                   Z-ADD     8             ZDECS
437300200529     C                   MOVE      'L'           ZECODE
437400200529      *
437500200529     C                   EXSR      ZSEDIT
437600200529      *
437700200529     C                   MOVEL     *BLANKS       #1EXPC
437800200529     C                   MOVE      ZOUT21        WFLD17
437900200529     C                   MOVEL     WFLD17        #1EXPC
438000200529     C                   ELSE
438100200529     C                   MOVE      *BLANKS       #1EXPC
438200200529     C                   ENDIF
438300200529      *
438400200529     C     MACLRD        IFNE      *ZEROS
438500200529     C                   Z-ADD     MACLRD        ZDAYNO
438600200529     C                   EXSR      ZDATE2
438700200529     C                   MOVE      ZDATE         #1CLRD
438800200529     C                   ELSE
438900200529     C                   MOVE      *BLANKS       #1CLRD
439000200529     C                   ENDIF
439100200529      *
439200200529     C     MACLRT        IFNE      *ZEROS
439300200529     C                   MOVE      MACLRT        #1CLRT
439400200529     C                   ELSE
439500200529     C                   MOVE      *BLANKS       #1CLRT
439600200529     C                   ENDIF
439700200529      *
439800200529     C     MADLRD        IFNE      *ZEROS
439900200529     C                   Z-ADD     MADLRD        ZDAYNO
440000200529     C                   EXSR      ZDATE2
440100200529     C                   MOVE      ZDATE         #1DLRD
440200200529     C                   ELSE
440300200529     C                   MOVE      *BLANKS       #1DLRD
440400200529     C                   ENDIF
440500200529      *
440600200529     C     MADLRT        IFNE      *ZEROS
440700200529     C                   MOVE      MADLRT        #1DLRT
440800200529     C                   ELSE
440900200529     C                   MOVE      *BLANKS       #1DLRT
441000200529     C                   ENDIF
441100200529      *
441200200529     C                   MOVE      MABLOP        #1BLOP
441300200529     C                   MOVE      MABLOP        #2BLOP
441400200529     C                   MOVE      MABLOS        #1BLOS
441500200529     C                   MOVE      MABLOS        #2BLOS
441600200529      *
441700200529     C     MABFRD        IFNE      *ZEROS
441800200529     C                   Z-ADD     MABFRD        ZDAYNO
441900200529     C                   EXSR      ZDATE2
442000200529     C                   MOVE      ZDATE         #1BFRD
442100200529     C                   ELSE
442200200529     C                   MOVE      *BLANKS       #1BFRD
442300200529     C                   ENDIF
442400200529      *
442500200529     C                   MOVE      #1BFRD        #2BFRD
442600200529      *
442700200529     C     MABEND        IFNE      *ZEROS
442800200529     C     MABEND        ANDNE     *HIVAL
442900200529     C                   Z-ADD     MABEND        ZDAYNO
443000200529     C                   EXSR      ZDATE2
443100200529     C                   MOVE      ZDATE         #1BEND
443200200529     C                   ELSE
443300200529     C                   MOVE      *BLANKS       #1BEND
443400200529     C                   ENDIF
443500200529      *
443600200529     C                   MOVE      #1BEND        #2BEND
443700200529      *                                                                                       CGL031
443800200529      ** Move relevant file fields to screen fields if CGL031 is enabled.                     CGL031
443900200529      *                                                                                       CGL031
444000200529     C                   IF        CGL031 = 'Y'                                               CGL031
444100200529     C                   EVAL      #1SETX = MASETX                                            CGL031
444200200529     C                   ENDIF                                                                CGL031
444300200529      *
444400200529     C                   MOVE      MAREFO        #1REFO
444500200529     C                   MOVE      MACONR        #1CONR
444600200529     C                   MOVE      MADFNR        #1DFNR
444700200529     C                   MOVE      MADFCP        #1DFCP
444800200529     C                   MOVE      MADFSP        #1DFSP
444900200529      *
445000200529      ** Move parent reference field to screen fields.
445100200529      *
445200200529     C     MAPREF        IFNE      *BLANKS
445300200529     C                   MOVE      MAPREF        #1PREF
445400200529     C                   MOVE      '1'           *IN12
445500200529     C                   ELSE
445600200529     C                   MOVE      '0'           *IN12
445700200529     C                   ENDIF
445800200529     C                   MOVE      *IN12         WWIN12
445900200529      *
446000200529     C                   MOVE      MANBOP        WNBOP
446100200529      *
446200200529     C                   MOVE      '1'           *IN47
446300200529      *
446400200529     C     WWINPT        IFEQ      'Y'
446500200529     C                   MOVEA     TXT(6)        ##CTX1
446600200529     C                   ELSE
446700200529     C     *IN61         IFEQ      '1'
446800200529     C                   MOVEA     TXT(4)        ##CTX1
446900200529     C                   ELSE
447000200529     C                   MOVEA     TXT(5)        ##CTX1
447100200529     C                   ENDIF
447200200529     C                   ENDIF
447300200529      *
447400200529     C                   MOVE      'Y'           ERROR             1
447500200529     C                   MOVE      '1'           *IN84
447600200529      *
447700200529      ** Determine fields to protect depending of the Status and the
447800200529      ** Final Allocation
447900200529      *
448000200529     C                   MOVE      '0'           *IN15
448100200529     C                   MOVE      '0'           *IN16
448200200529     C                   MOVE      '0'           *IN17
448300200529     C                   MOVE      '0'           *IN18
448400200529     C                   MOVE      '0'           *IN19
448500200529      *
448600200529      ** LS=Final Allocation Stock          (*IN15)
448700200529      ** LY=Final Allocation Cash and Stock (*IN16)
448800200529      ** S =Stock Authorised                (*IN17)
448900200529      ** X =Fully Authorised (Cash & Stock) (*IN18)
449000200529      ** C =Completed                       (*IN18 + *IN19)
449100200529      ** R =Reversed                        (*IN18 + *IN19)
449200200529      *
449300200529     C     #1STAT        IFEQ      'L'
449400200529     C     #1FINA        IFEQ      'S'
449500200529     C                   MOVE      '1'           *IN15
449600200529     C                   ELSE
449700200529     C     #1FINA        IFEQ      'Y'
449800200529     C                   MOVE      '1'           *IN16
449900200529     C                   ENDIF
450000200529     C                   ENDIF
450100200529     C                   ELSE
450200200529     C     #1STAT        IFEQ      'S'
450300200529     C                   MOVE      '1'           *IN17
450400200529     C                   ELSE
450500200529     C     #1STAT        IFEQ      'X'
450600200529     C                   MOVE      '1'           *IN18
450700200529     C                   ELSE
450800200529     C     #1STAT        IFEQ      'C'
450900200529     C     #1STAT        OREQ      'R'
451000200529     C                   MOVE      '1'           *IN18
451100200529     C                   MOVE      '1'           *IN19
451200200529     C                   ENDIF
451300200529     C                   ENDIF
451400200529     C                   ENDIF
451500200529     C                   ENDIF
451600200529      *
451700200529      ** Do while F12 or F3 is not pressed and no error
451800200529      *
451900200529     C     *INKC         DOWEQ     '0'
452000200529     C     *INKL         ANDEQ     '0'
452100200529     C     ERROR         ANDEQ     'Y'
452200200529     C     WIN12         ANDEQ     '0'
452300200529      *
452400200529      ** If 'Number of Options' is not 01, non protect the fields
452500200529      ** 'Accept offer', 'Refuse offer', 'Option Narrative',
452600200529      ** 'Default Cash', 'Default Stock', 'Default for'
452700200529      *
452800200529     C                   MOVE      WNBOP         W1NBOP
452900200529      *
453000200529     C     W1NBOP        IFNE      1
453100200529     C                   MOVE      '0'           *IN26
453200200529     C                   ELSE
453300200529     C                   MOVE      '1'           *IN26
453400200529     C                   ENDIF
453500200529     C                   MOVE      WWIN12        *IN12
453600200529      *
453700200529      ** Setup Screen time
453800200529      *
453900200529     C                   TIME                    ##TME                          Screen time.
454000200529      *
454100200529      ** Execute screen format
454200200529      *
454300200529     C                   WRITE     #MSGCTL
454400200529     C                   WRITE     SE7502F1
454500200529     C                   EXFMT     SE7502F3
454600200529      *
454700200529     C     *INKL         IFEQ      '1'
454800200529     C                   MOVE      '1'           WIN12             1
454900200529     C                   ELSE
455000200529     C                   MOVE      '0'           WIN12
455100200529     C                   ENDIF
455200200529      *
455300200529     C     *INKC         IFEQ      '1'
455400200529     C                   MOVE      '3'           P#RTCD
455500200529     C                   ENDIF
455600200529      *
455700200529      ** Clear messages from program message queue.
455800200529      *
455900200529     C                   CALL      'Y2CLMSC'
456000200529     C                   PARM      ##PGM         ZAPGM            10
456100200529     C                   PARM      '*SAME'       ZAPGRL            5
456200200529      *
456300200529     C                   MOVE      'N'           ERROR
456400200529      *
456500200529      ** If Cmd11 Pressed
456600200529      *
456700200529     C     *INKK         IFEQ      '1'
456800200529     C     *INKC         OREQ      '0'
456900200529     C     *INKL         ANDEQ     '0'
457000200529     C     WWINPT        ANDEQ     'Y'
457100200529      *
457200200529      ** Validate details and Update file if no error
457300200529      *
457400200529     C     *IN61         IFEQ      '0'
457500200529     C                   EXSR      P019
457600200529     C                   ENDIF
457700200529      *
457800200529      ** View/Change Option(s)
457900200529      *
458000200529     C     ERROR         IFEQ      'N'
458100200529     C                   EXSR      P023
458200200529     C                   ENDIF
458300200529     C                   ELSE
458400200529      *
458500200529      ** If all input fields are not protected
458600200529      *
458700200529     C     *IN61         IFEQ      '0'
458800200529     C     #1SECN        CHAIN     SECTYZ1                            89
458900200529      *
459000200529      ** Validate details and update file if no error
459100200529      *
459200200529     C                   EXSR      P019
459300200529     C                   ENDIF
459400200529     C                   ENDIF
459500200529     C                   ENDDO
459600200529      *
459700200529     C                   MOVE      '0'           *IN15
459800200529     C                   MOVE      '0'           *IN16
459900200529     C                   MOVE      '0'           *IN17
460000200529     C                   MOVE      '0'           *IN18
460100200529     C                   MOVE      '0'           *IN19
460200200529      *
460300200529      ** Setup correctly the command keys Available
460400200529      *
460500200529     C                   MOVEA     TXT(9)        ##CTX1
460600200529      *
460700200529     C                   MOVE      '0'           *IN47
460800200529      *
460900200529      ** Clear messages from program message queue.
461000200529      *
461100200529     C                   CALL      'Y2CLMSC'
461200200529     C                   PARM      ##PGM         ZAPGM            10
461300200529     C                   PARM      '*SAME'       ZAPGRL            5
461400200529      *
461500200529     C                   ENDSR
461600200529      ****************************************************************
461700200529      /EJECT
461800200529      *****************************************************************
461900200529      * P019  : Validate 'Full Details' Screen and Update file        *
462000200529      *****************************************************************
462100200529      *
462200200529     C     P019          BEGSR
462300200529      *
462400200529      ** Access Secutiry details with current Security Shortname
462500200529      *
462600200529     C     #1SECN        CHAIN     SECTYZ1                            89
462700200529      *
462800200529      ** Initialise error indicators
462900200529      *
463000200529     C                   EVAL      *IN07 = *OFF                                               CGL031
463100200529     C                   MOVE      '0'           *IN13
463200200529     C                   MOVE      '0'           *IN14
463300200529     C                   MOVE      '0'           *IN20
463400200529     C                   MOVE      '0'           *IN21
463500200529     C                   MOVE      '0'           *IN22
463600200529     C                   MOVE      '0'           *IN23
463700200529     C                   MOVE      '0'           *IN24
463800200529     C                   MOVE      '0'           *IN31
463900200529     C                   MOVE      '0'           *IN42
464000200529     C                   MOVE      '0'           *IN49
464100200529     C                   MOVE      '0'           *IN60
464200200529     C                   MOVE      '0'           *IN65
464300200529     C                   MOVE      '0'           *IN66
464400200529     C                   MOVE      '0'           *IN67
464500200529     C                   MOVE      '0'           *IN70
464600200529     C                   MOVE      '0'           *IN71
464700200529     C                   MOVE      '0'           *IN72
464800200529     C                   MOVE      '0'           *IN73
464900200529     C                   MOVE      '0'           *IN74
465000200529     C                   MOVE      '0'           *IN76
465100200529     C                   MOVE      '0'           *IN77
465200200529     C                   MOVE      '0'           *IN78
465300200529     C                   MOVE      '0'           *IN79
465400200529     C                   MOVE      '0'           *IN82
465500200529     C                   MOVE      '0'           *IN83
465600200529     C                   MOVE      '0'           *IN85
465700200529      *
465800200529     C                   Z-ADD     *ZEROS        WCOPD             5 0
465900200529     C                   Z-ADD     *ZEROS        WTDDT             5 0
466000200529     C                   Z-ADD     *ZEROS        WEVDT             5 0
466100200529      *
466200200529     C                   MOVE      #1EXDT        DateIn
466300200529     C                   EXSR      ZDATE1
466400200529     C                   Z-ADD     DAYNOOUT      WEXDT             5 0
466500200529      *
466600200529     C                   MOVE      #1ALEF        DateIn
466700200529     C                   EXSR      ZDATE1
466800200529     C                   Z-ADD     DAYNOOUT      WALEF             5 0
466900200529      *
467000200529      ** If 'Payment Date' is not blank
467100200529      *
467200200529     C     #1COPD        IFNE      *BLANKS
467300200529      *
467400200529     C                   MOVE      #1COPD        DateIn
467500200529     C                   EXSR      ZDATE1
467600200529      *
467700200529      ** If 'Payment Date is not a valid date format
467800200529      *
467900200529     C     ErrorFlag     IFEQ      'Y'
468000200529     C                   MOVE      'Y'           ERROR
468100200529     C                   MOVE      '1'           *IN65                          Reverse image
468200200529     C                   MOVEL     'CO00038'     ZAMSID                         Message id.
468300200529     C                   EXSR      ZASNMS                                       Send message
468400200529     C                   ELSE
468500200529     C                   Z-ADD     DAYNOOUT      WCOPD             5 0
468600200529      *
468700200529      ** If 'Payment Date' is before the 'Ex-Date'
468800200529      *
468900200529     C     WCOPD         IFLT      WEXDT
469000200529     C     WEXDT         ANDNE     *ZEROS
469100200529     C                   MOVE      'Y'           ERROR
469200200529     C                   MOVE      '1'           *IN65                          Reverse image
469300200529     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
469400200529     C                   EXSR      ZASNMS                                       Send message
469500200529     C                   ENDIF
469600200529      *
469700200529      ** If 'Payment Date' is before the 'Allocation Effective Date'
469800200529      *
469900200529     C     WCOPD         IFLT      WALEF
470000200529     C     WALEF         ANDNE     *ZEROS
470100200529     C                   MOVE      'Y'           ERROR
470200200529     C                   MOVE      '1'           *IN65                          Reverse image
470300200619     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
470500200529     C                   EXSR      ZASNMS                                       Send message
470600200529     C                   ENDIF
470700200529      *
470800200529      ** If 'Payment date' is greater or equal to the Maturity date
470900200529      ** of the Security
471000200529      *
471100200529     C     WCOPD         IFGE      MATY
471200200529     C     MATY          ANDNE     *ZEROS
471300200529     C                   MOVE      'Y'           ERROR
471400200529     C                   MOVE      '1'           *IN65                          Reverse image
471500200529     C                   MOVEL     'CO00217'     ZAMSID                         Message id.
471600200529     C                   EXSR      ZASNMS                                       Send message
471700200529     C                   ENDIF
471800200529     C                   ENDIF
471900200529     C                   ENDIF
472000200529      *
472100200529      ** If 'Trade Date' is not blank
472200200529      *
472300200529     C     #1TDDT        IFNE      *BLANKS
472400200529      *
472500200529     C                   MOVE      #1TDDT        DateIn
472600200529     C                   EXSR      ZDATE1
472700200529      *
472800200529      ** If 'Trade Date is not a valid date format
472900200529      *
473000200529     C     ErrorFlag     IFEQ      'Y'
473100200529     C                   MOVE      'Y'           ERROR
473200200529     C                   MOVE      '1'           *IN60                          Reverse image
473300200529     C                   MOVEL     'CO00301'     ZAMSID                         Message id.
473400200529     C                   EXSR      ZASNMS                                       Send message
473500200529     C                   ELSE
473600200529     C                   Z-ADD     DAYNOOUT      WTDDT             5 0
473700200529      *
473800200529      ** If 'Trade Date' is greater than the 'Allocation Effective Date'
473900200529      *
474000200529     C     WTDDT         IFGT      WALEF
474100200529     C     WALEF         ANDNE     *ZEROS
474200200529     C                   MOVE      'Y'           ERROR
474300200529     C                   MOVE      '1'           *IN60                          Reverse image
474400200529     C                   MOVEL     'CO00212'     ZAMSID                         Message id.
474500200529     C                   EXSR      ZASNMS                                       Send message
474600200529     C                   ENDIF
474700200529      *
474800200529      ** If 'Trade date must be lower than the Maturity date of the
474900200529      ** Security
475000200529      *
475100200529     C     WTDDT         IFGE      MATY
475200200529     C     MATY          ANDNE     *ZEROS
475300200529     C                   MOVE      'Y'           ERROR
475400200529     C                   MOVE      '1'           *IN60                          Reverse image
475500200529     C                   MOVEL     'CO00218'     ZAMSID                         Message id.
475600200529     C                   EXSR      ZASNMS                                       Send message
475700200529     C                   ENDIF
475800200529      *
475900200529      ** If 'Trade Date' must be greater or equal than SE back value
476000200529      ** period
476100200529      *
476200200529     C     WTDDT         IFLT      WBACKD
476300200529     C                   MOVE      'Y'           ERROR
476400200529     C                   MOVE      '1'           *IN60                          Reverse image
476500200529     C                   MOVEL     'CO00219'     ZAMSID                         Message id.
476600200529     C                   EXSR      ZASNMS                                       Send message
476700200529     C                   ENDIF
476800200529     C                   ENDIF
476900200529     C                   ENDIF
477000200529      *
477100200529      ** If 'Event Date' is not blank
477200200529      *
477300200529     C     #1EVDT        IFNE      *BLANKS
477400200529      *
477500200529     C                   MOVE      #1EVDT        DateIn
477600200529     C                   EXSR      ZDATE1
477700200529      *
477800200529      ** If 'Event date is not a valid date format
477900200529      *
478000200529     C     ErrorFlag     IFEQ      'Y'
478100200529     C                   MOVE      'Y'           ERROR
478200200529     C                   MOVE      '1'           *IN49                          Reverse image
478300200529     C                   MOVEL     'CO00211'     ZAMSID                         Message id.
478400200529     C                   EXSR      ZASNMS                                       Send message
478500200529     C                   ELSE
478600200529     C                   Z-ADD     DAYNOOUT      WEVDT             5 0
478700200529      *
478800200529      ** If 'Payment Date' is before 'Event Date'
478900200529      *
479000200529     C     WCOPD         IFLT      WEVDT
479100200529     C     WCOPD         ANDNE     *ZEROS
479200200529     C                   MOVE      'Y'           ERROR
479300200529     C                   MOVE      '1'           *IN65                          Reverse image
479400200529     C                   MOVEL     'CO00216'     ZAMSID                         Message id.
479500200529     C                   EXSR      ZASNMS                                       Send message
479600200529     C                   ENDIF
479700200529      *
479800200529      ** If 'Event date' must not be before 'Ex-Date'
479900200529      *
480000200529     C     WEVDT         IFLT      WEXDT
480100200529     C                   MOVE      'Y'           ERROR
480200200529     C                   MOVE      '1'           *IN49                          Reverse image
480300200529     C                   MOVEL     'CO00213'     ZAMSID                         Message id.
480400200529     C                   EXSR      ZASNMS                                       Send message
480500200529     C                   ENDIF
480600200529      *
480700200529      ** If 'Event Date' must be lower than maturity date of the
480800200529      ** Security
480900200529      *
481000200529     C     WEVDT         IFGE      MATY
481100200529     C     MATY          ANDNE     *ZEROS
481200200529     C                   MOVE      'Y'           ERROR
481300200529     C                   MOVE      '1'           *IN49                          Reverse image
481400200529     C                   MOVEL     'CO00220'     ZAMSID                         Message id.
481500200529     C                   EXSR      ZASNMS                                       Send message
481600200529     C                   ENDIF
481700200529     C                   ENDIF
481800200529     C                   ENDIF
481900200529      *
482000200529      ** If 'Trade/Value Date Position' is entered
482100200529      *
482200200529     C     #1TDVD        IFNE      *BLANKS
482300200529      *
482400200529      ** 'Trade/Value date Position' must be equal to 'T' or 'V'
482500200529      *
482600200529     C     #1TDVD        IFNE      'T'
482700200529     C     #1TDVD        ANDNE     'V'
482800200529     C                   MOVE      'Y'           ERROR
482900200529     C                   MOVE      '1'           *IN66                          Reverse image
483000200529     C                   MOVEL     'CO00037'     ZAMSID                         Message id.
483100200529     C                   EXSR      ZASNMS                                       Send message
483200200529     C                   ENDIF
483300200529     C                   ELSE
483400200529     C                   MOVE      'T'           #1TDVD
483500200529     C                   ENDIF
483600200529      *
483700200529      ** If 'Coupon Number' is entered
483800200529      *
483900200529     C     #1CPNB        IFNE      *BLANKS
484000200529      *
484100200529      ** Check it's a valid numeric field
484200200529      *
484300200529     C     DIGITS        CHECK     #1CPNB:1      N                 1 0    89
484400200529      *
484500200529      ** If it's not a valid numeric field
484600200529      *
484700200529     C     *IN89         IFEQ      '1'
484800200529     C                   MOVE      'Y'           ERROR
484900200529     C                   MOVE      '1'           *IN67                          Reverse image
485000200529     C                   MOVEL     'CO00040'     ZAMSID                         Message id.
485100200529     C                   EXSR      ZASNMS                                       Send message
485200200529     C                   ENDIF
485300200529     C                   ENDIF
485400200529      *
485500200529      ** If 'Shareholders meeting date' is entered
485600200529      *
485700200529     C     #1SHMD        IFNE      *BLANKS
485800200529      *
485900200529     C                   MOVE      #1SHMD        DateIn
486000200529     C                   EXSR      ZDATE1
486100200529      *
486200200529      ** If 'Shareholders meeting date' is not a valid date format
486300200529      *
486400200529     C     ErrorFlag     IFEQ      'Y'
486500200529     C                   MOVE      'Y'           ERROR
486600200529     C                   MOVE      '1'           *IN70                          Reverse image
486700200529     C                   MOVEL     'CO00043'     ZAMSID                         Message id.
486800200529     C                   EXSR      ZASNMS                                       Send message
486900200529     C                   ENDIF
487000200529     C                   ENDIF
487100200529      *
487200200529      ** If 'Letter to be sent' has been entered
487300200529      *
487400200529     C     #1LTBS        IFNE      *BLANKS
487500200529      *
487600200529      ** 'Letter to be sent' must be equal to 'Y' or 'N'
487700200529      *
487800200529     C     #1LTBS        IFNE      'Y'
487900200529     C     #1LTBS        ANDNE     'N'
488000200529     C                   MOVE      'Y'           ERROR
488100200529     C                   MOVE      '1'           *IN71                          Reverse image
488200200529     C                   MOVEL     'CO00044'     ZAMSID                         Message id.
488300200529     C                   EXSR      ZASNMS                                       Send message
488400200529     C                   ENDIF
488500200529     C                   ELSE
488600200529     C                   MOVE      'N'           #1LTBS
488700200529     C                   ENDIF
488800200529      *
488900200529      ** If 'Old Capital Value' has been entered
489000200529      *
489100200529     C     #1OCPV        IFNE      *BLANKS
489200200529     C                   MOVE      *BLANKS       ZFLD17
489300200529     C                   MOVE      #1OCPV        ZFLD17
489400200529     C     15            SUB       NMDP          ZSDIG
489500200529     C                   Z-ADD     NMDP          ZSDEC
489600200529      *
489700200529     C                   EXSR      ZASIGN
489800200529      *
489900200529     C     ZASIGNok      IFEQ      'N'
490000200529     C                   MOVEL     'CO00129'     ZAMSID
490100200529     C                   EXSR      ZASNMS
490200200529     C                   MOVE      'Y'           ERROR
490300200529     C                   MOVE      '1'           *IN20
490400200529     C                   ENDIF
490500200529     C                   ENDIF
490600200529      *
490700200529      ** If 'New Capital Value' has been entered
490800200529      *
490900200529     C     #1NCPV        IFNE      *BLANKS
491000200529     C                   MOVE      *BLANKS       ZFLD17
491100200529     C                   MOVE      #1NCPV        ZFLD17
491200200529     C     15            SUB       NMDP          ZSDIG
491300200529     C                   Z-ADD     NMDP          ZSDEC
491400200529      *
491500200529     C                   EXSR      ZASIGN
491600200529      *
491700200529     C     ZASIGNok      IFEQ      'N'
491800200529     C                   MOVEL     'CO00130'     ZAMSID
491900200529     C                   EXSR      ZASNMS
492000200529     C                   MOVE      'Y'           ERROR
492100200529     C                   MOVE      '1'           *IN21
492200200529     C                   ENDIF
492300200529     C                   ENDIF
492400200529      *
492500200529      ** If 'Old Nominal Value' has been entered
492600200529      *
492700200529     C     #1ONML        IFNE      *BLANKS
492800200529     C                   MOVE      *BLANKS       ZFLD17
492900200529     C                   MOVE      #1ONML        ZFLD17
493000200529     C     15            SUB       NMDP          ZSDIG
493100200529     C                   Z-ADD     NMDP          ZSDEC
493200200529      *
493300200529     C                   EXSR      ZASIGN
493400200529      *
493500200529     C     ZASIGNok      IFEQ      'N'
493600200529     C                   MOVEL     'CO00131'     ZAMSID
493700200529     C                   EXSR      ZASNMS
493800200529     C                   MOVE      'Y'           ERROR
493900200529     C                   MOVE      '1'           *IN22
494000200529     C                   ENDIF
494100200529     C                   ENDIF
494200200529      *
494300200529      ** If 'New Nominal Value' has been entered
494400200529      *
494500200529     C     #1NNML        IFNE      *BLANKS
494600200529     C                   MOVE      *BLANKS       ZFLD17
494700200529     C                   MOVE      #1NNML        ZFLD17
494800200529     C     15            SUB       NMDP          ZSDIG
494900200529     C                   Z-ADD     NMDP          ZSDEC
495000200529      *
495100200529     C                   EXSR      ZASIGN
495200200529      *
495300200529     C     ZASIGNok      IFEQ      'N'
495400200529     C                   MOVEL     'CO00132'     ZAMSID
495500200529     C                   EXSR      ZASNMS
495600200529     C                   MOVE      'Y'           ERROR
495700200529     C                   MOVE      '1'           *IN23
495800200529     C                   ENDIF
495900200529     C                   ENDIF
496000200529      *
496100200529      ** If 'Market Cum Price' has been entered
496200200529      *
496300200529     C     #1CUPC        IFNE      *BLANKS
496400200529     C                   MOVE      *BLANKS       ZFIELD
496500200529     C                   MOVE      #1CUPC        ZFIELD
496600200529     C                   Z-ADD     7             ZADIG
496700200529     C                   Z-ADD     8             ZADEC
496800200529      *
496900200529     C                   EXSR      ZALIGN
497000200529      *
497100200529     C     ZALIGNok      IFEQ      'N'
497200200529     C                   MOVEL     'CO00133'     ZAMSID
497300200529     C                   EXSR      ZASNMS
497400200529     C                   MOVE      'Y'           ERROR
497500200529     C                   MOVE      '1'           *IN24
497600200529     C                   ENDIF
497700200529     C                   ENDIF
497800200529      *
497900200529      ** If 'Market Ex Price' has been entered
498000200529      *
498100200529     C     #1EXPC        IFNE      *BLANKS
498200200529     C                   MOVE      *BLANKS       ZFIELD
498300200529     C                   MOVE      #1EXPC        ZFIELD
498400200529     C                   Z-ADD     7             ZADIG
498500200529     C                   Z-ADD     8             ZADEC
498600200529      *
498700200529     C                   EXSR      ZALIGN
498800200529      *
498900200529     C     ZALIGNok      IFEQ      'N'
499000200529     C                   MOVEL     'CO00134'     ZAMSID
499100200529     C                   EXSR      ZASNMS
499200200529     C                   MOVE      'Y'           ERROR
499300200529     C                   MOVE      '1'           *IN31
499400200529     C                   ENDIF
499500200529     C                   ENDIF
499600200529      *
499700200529      ** If 'Customer Last Reply Date' has been entered
499800200529      *
499900200529     C     #1CLRD        IFNE      *BLANKS
500000200529      *
500100200529     C                   MOVE      #1CLRD        DateIn
500200200529     C                   EXSR      ZDATE1
500300200529      *
500400200529      ** 'Customer Last Reply Date' must be a valid Date format
500500200529      *
500600200529     C     ErrorFlag     IFEQ      'Y'
500700200529     C                   MOVE      'Y'           ERROR
500800200529     C                   MOVE      '1'           *IN83                          Reverse image
500900200529     C                   MOVEL     'CO00059'     ZAMSID                         Message id.
501000200529     C                   EXSR      ZASNMS                                       Send message
501100200529     C                   ENDIF
501200200529     C                   ENDIF
501300200529      *
501400200529      ** If 'Customer Last Reply time' has been entered
501500200529      *
501600200529     C     #1CLRT        IFNE      *BLANKS
501700200529      *
501800200529      ** No entry allowed when 'Customer LAst Reply Date' is not entered
501900200529      *
502000200529     C     #1CLRD        IFEQ      *BLANKS
502100200529     C                   MOVE      'Y'           ERROR
502200200529     C                   MOVE      '1'           *IN13                          Reverse image
502300200529     C                   MOVEL     'CO00062'     ZAMSID                         Message id.
502400200529     C                   EXSR      ZASNMS                                       Send message
502500200529     C                   ELSE
502600200529      *
502700200529     C                   MOVEL     #1CLRT        WWHOUR            2 0
502800200529     C                   MOVE      #1CLRT        WWMISE            4
502900200529     C                   MOVEL     WWMISE        WWMINS            2 0
503000200529     C                   MOVE      WWMISE        WWSECS            2 0
503100200529      *
503200200529      ** 'Customer Last Reply Time' must be a valid time format
503300200529      *
503400200529     C     WWHOUR        IFGT      23
503500200529     C     WWHOUR        ORLT      0
503600200529     C     WWMINS        ORGT      59
503700200529     C     WWMINS        ORLT      0
503800200529     C     WWSECS        ORGT      59
503900200529     C     WWSECS        ORLT      0
504000200529     C                   MOVE      'Y'           ERROR
504100200529     C                   MOVE      '1'           *IN13                          Reverse image
504200200529     C                   MOVEL     'CO00061'     ZAMSID                         Message id.
504300200529     C                   EXSR      ZASNMS                                       Send message
504400200529     C                   ENDIF
504500200529     C                   ENDIF
504600200529     C                   ENDIF
504700200529      *
504800200529      ** If 'Depot Last Reply date' has been entered
504900200529      *
505000200529     C     #1DLRD        IFNE      *BLANKS
505100200529      *
505200200529     C                   MOVE      #1DLRD        DateIn
505300200529     C                   EXSR      ZDATE1
505400200529      *
505500200529      ** 'Depot Last Reply Date' must be a valid Date format
505600200529      *
505700200529     C     ErrorFlag     IFEQ      'Y'
505800200529     C                   MOVE      'Y'           ERROR
505900200529     C                   MOVE      '1'           *IN85                          Reverse image
506000200529     C                   MOVEL     'CO00060'     ZAMSID                         Message id.
506100200529     C                   EXSR      ZASNMS                                       Send message
506200200529     C                   ENDIF
506300200529     C                   ENDIF
506400200529      *
506500200529      ** If 'Depot Last Reply Time' has been entered
506600200529      *
506700200529     C     #1DLRT        IFNE      *BLANKS
506800200529      *
506900200529      ** No Entry allowed when 'Depot Last Reply Date' is not entered
507000200529      *
507100200529     C     #1DLRD        IFEQ      *BLANKS
507200200529     C                   MOVE      'Y'           ERROR
507300200529     C                   MOVE      '1'           *IN14                          Reverse image
507400200529     C                   MOVEL     'CO00064'     ZAMSID                         Message id.
507500200529     C                   EXSR      ZASNMS                                       Send message
507600200529     C                   ELSE
507700200529      *
507800200529     C                   MOVEL     #1DLRT        WWHOUR            2 0
507900200529     C                   MOVE      #1DLRT        WWMISE            4
508000200529     C                   MOVEL     WWMISE        WWMINS            2 0
508100200529     C                   MOVE      WWMISE        WWSECS            2 0
508200200529      *
508300200529      ** 'Customer Last Reply time' must be a valid time format
508400200529      *
508500200529     C     WWHOUR        IFGT      23
508600200529     C     WWHOUR        ORLT      0
508700200529     C     WWMINS        ORGT      59
508800200529     C     WWMINS        ORLT      0
508900200529     C     WWSECS        ORGT      59
509000200529     C     WWSECS        ORLT      0
509100200529     C                   MOVE      'Y'           ERROR
509200200529     C                   MOVE      '1'           *IN14                          Reverse image
509300200529     C                   MOVEL     'CO00063'     ZAMSID                         Message id.
509400200529     C                   EXSR      ZASNMS                                       Send message
509500200529     C                   ENDIF
509600200529     C                   ENDIF
509700200529     C                   ENDIF
509800200529      *
509900200529      ** If 'Block Security' has been entered
510000200529      *
510100200529     C     #1BLOS        IFNE      *BLANKS
510200200529      *
510300200529      ** 'Block Security' must be equal to 'E', 'W' or 'N'
510400200529      *
510500200529     C     #1BLOS        IFNE      'E'
510600200529     C     #1BLOS        ANDNE     'W'
510700200529     C     #1BLOS        ANDNE     'N'
510800200529     C                   MOVE      'Y'           ERROR
510900200529     C                   MOVE      '1'           *IN42                          Reverse image
511000200529     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
511100200529     C                   EXSR      ZASNMS                                       Send message
511200200529     C                   ENDIF
511300200529     C                   ELSE
511400200529     C                   MOVE      'N'           #1BLOS
511500200529     C                   ENDIF
511600200529      *
511700200529      ** If 'Block Position' has been entered
511800200529      *
511900200529     C     #1BLOP        IFNE      *BLANKS
512000200529      *
512100200529      ** 'Block Position' must be equal to 'E', 'W' or 'N'
512200200529      *
512300200529     C     #1BLOP        IFNE      'E'
512400200529     C     #1BLOP        ANDNE     'W'
512500200529     C     #1BLOP        ANDNE     'N'
512600200529     C                   MOVE      'Y'           ERROR
512700200529     C                   MOVE      '1'           *IN72                          Reverse image
512800200529     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
512900200529     C                   EXSR      ZASNMS                                       Send message
513000200529     C                   ENDIF
513100200529     C                   ELSE
513200200529     C                   MOVE      'N'           #1BLOP
513300200529     C                   ENDIF
513400200529      *
513500200529     C     #1BLOP        IFEQ      'E'
513600200529     C     #1BLOP        ANDEQ     'W'
513700200529     C     #1BLOS        OREQ      'E'
513800200529     C     #1BLOS        ANDEQ     'W'
513900200529      *
514000200529     C     #1BFRD        IFEQ      *BLANKS
514100200529     C                   MOVE      #1EXDT        #1BFRD
514200200529     C                   MOVE      #1EXDT        #2BFRD
514300200529     C                   ENDIF
514400200529      *
514500200529     C     #1BEND        IFEQ      *BLANKS
514600200529     C                   MOVE      #1ALEF        #1BEND
514700200529     C                   MOVE      #1ALEF        #2BEND
514800200529     C                   ENDIF
514900200529     C                   ENDIF
515000200529      *
515100200529     C                   Z-ADD     *ZEROS        W1BFRD            5 0
515200200529      *
515300200529      ** If 'Block from Date' has been entered
515400200529      *
515500200529     C     #1BFRD        IFNE      *BLANKS
515600200529      *
515700200529      ** 'Block from date' must not be entered if Block indicator= 'N'
515800200529      *
515900200529     C     #1BLOP        IFEQ      'N'
516000200529     C     #1BLOS        ANDEQ     'N'
516100200529     C                   MOVE      'Y'           ERROR
516200200529     C                   MOVE      '1'           *IN73                          Reverse image
516300200529     C                   MOVEL     'CO00046'     ZAMSID                         Message id.
516400200529     C                   EXSR      ZASNMS                                       Send message
516500200529     C                   ELSE
516600200529      *
516700200529     C                   MOVE      #1BFRD        DateIn
516800200529     C                   EXSR      ZDATE1
516900200529     C                   Z-ADD     DAYNOOUT      W1BFRD
517000200529      *
517100200529      ** If 'Block from date' is not a valid date format
517200200529      *
517300200529     C     ErrorFlag     IFEQ      'Y'
517400200529     C                   MOVE      'Y'           ERROR
517500200529     C                   MOVE      '1'           *IN73                          Reverse image
517600200529     C                   MOVEL     'CO00048'     ZAMSID                         Message id.
517700200529     C                   EXSR      ZASNMS                                       Send message
517800200529     C                   ELSE
517900200529      *
518000200529      ** 'Block from Date' must be greater than run date
518100200529      *
518200200529     C     DAYNOOUT      IFLE      BJRDNB
518300200529     C                   MOVE      'Y'           ERROR
518400200529     C                   MOVE      '1'           *IN73                          Reverse image
518500200529     C                   MOVEL     'CO00050'     ZAMSID                         Message id.
518600200529     C                   EXSR      ZASNMS                                       Send message
518700200529     C                   ENDIF
518800200529     C                   ENDIF
518900200529     C                   ENDIF
519000200529     C                   ELSE
519100200529      *
519200200529      ** 'Block from date' must be entered if block position is 'E' or 'W
519300200529      *
519400200529     C     #1BLOP        IFEQ      'E'
519500200529     C     #1BLOP        OREQ      'W'
519600200529     C     #1BLOS        OREQ      'E'
519700200529     C     #1BLOS        OREQ      'W'
519800200529     C     #1BEND        IFEQ      *BLANKS
519900200529     C                   MOVE      'Y'           ERROR
520000200529     C                   MOVE      '1'           *IN73                          Reverse image
520100200529     C                   MOVEL     'CO00243'     ZAMSID                         Message id.
520200200529     C                   EXSR      ZASNMS                                       Send message
520300200529     C                   ENDIF
520400200529     C                   ENDIF
520500200529     C                   ENDIF
520600200529      *
520700200529      ** If 'Block End Date' has been entered
520800200529      *
520900200529     C     #1BEND        IFNE      *BLANKS
521000200529      *
521100200529      ** 'Block end date' must not be entered if Block Indicators ='N'
521200200529      *
521300200529     C     #1BLOP        IFEQ      'N'
521400200529     C     #1BLOS        ANDEQ     'N'
521500200529     C                   MOVE      'Y'           ERROR
521600200529     C                   MOVE      '1'           *IN74                          Reverse image
521700200529     C                   MOVEL     'CO00047'     ZAMSID                         Message id.
521800200529     C                   EXSR      ZASNMS                                       Send message
521900200529     C                   ELSE
522000200529      *
522100200529     C                   MOVE      #1BEND        DateIn
522200200529     C                   EXSR      ZDATE1
522300200529      *
522400200529      ** If 'Block end date' is not a valid date format
522500200529      *
522600200529     C     ErrorFlag     IFEQ      'Y'
522700200529     C                   MOVE      'Y'           ERROR
522800200529     C                   MOVE      '1'           *IN74                          Reverse image
522900200529     C                   MOVEL     'CO00049'     ZAMSID                         Message id.
523000200529     C                   EXSR      ZASNMS                                       Send message
523100200529     C                   ELSE
523200200529      *
523300200529      ** 'Block End Date' must be greater than Run Date/From Date
523400200529      ** and before Maturity Date of the Security
523500200529      *
523600200529     C     DAYNOOUT      IFLE      BJRDNB
523700200529     C     DAYNOOUT      ORLE      W1BFRD
523800200529     C     DAYNOOUT      ORGE      MATY
523900200529     C     MATY          ANDNE     *ZEROS
524000200529     C                   MOVE      'Y'           ERROR
524100200529     C                   MOVE      '1'           *IN74                          Reverse image
524200200529     C                   MOVEL     'CO00051'     ZAMSID                         Message id.
524300200529     C                   EXSR      ZASNMS                                       Send message
524400200529     C                   ENDIF
524500200529     C                   ENDIF
524600200529     C                   ENDIF
524700200529      *
524800200529     C                   ELSE
524900200529      *
525000200529      ** 'Block End Date' must be entered if Block Position is 'E' or 'W'
525100200529      *
525200200529     C     #1BLOP        IFEQ      'E'
525300200529     C     #1BLOP        OREQ      'W'
525400200529     C     #1BLOS        OREQ      'E'
525500200529     C     #1BLOS        OREQ      'W'
525600200529     C     #1BFRD        IFEQ      *BLANKS
525700200529     C                   MOVE      'Y'           ERROR
525800200529     C                   MOVE      '1'           *IN74                          Reverse image
525900200529     C                   MOVEL     'CO00244'     ZAMSID                         Message id.
526000200529     C                   EXSR      ZASNMS                                       Send message
526100200529     C                   ENDIF
526200200529     C                   ENDIF
526300200529     C                   ENDIF
526400200529                                                                                              CGL031
526500200529      ** Validate Subject to European Tax if CGL031 is enabled.                               CGL031
526600200529                                                                                              CGL031
526700200529     C                   IF        CGL031 = 'Y'                                               CGL031
526800200529                                                                                              CGL031
526900200529     C                   IF        #1SETX = *BLANK                                            CGL031
527000200529                                                                                              CGL031
527100200529     C                   IF        #1COAT = 'DI'                                              CGL031
527200200529     C                   EVAL      #1SETX = SETX                                              CGL031
527300200529     C                   ELSE                                                                 CGL031
527400200529                                                                                              CGL031
527500200529      ** Subject to European Tax is mandatory.                                                CGL031
527600200529                                                                                              CGL031
527700200529     C                   EVAL      ERROR = 'Y'                                                CGL031
527800200529     C                   EVAL      *IN07 = *ON                                                CGL031
527900200529     C                   EVAL      ZAMSID = 'SEA0907'                                         CGL031
528000200529     C                   EXSR      ZASNMS                                                     CGL031
528100200529     C                   ENDIF                                                                CGL031
528200200529                                                                                              CGL031
528300200529     C                   ELSE                                                                 CGL031
528400200529                                                                                              CGL031
528500200529     C                   IF        #1SETX <> 'Y' AND                                          CGL031
528600200529     C                             #1SETX <> 'N'                                              CGL031
528700200529                                                                                              CGL031
528800200529      ** Subject to European Tax must be 'Y' or 'N'.                                          CGL031
528900200529                                                                                              CGL031
529000200529     C                   EVAL      ERROR = 'Y'                                                CGL031
529100200529     C                   EVAL      *IN07 = *ON                                                CGL031
529200200529     C                   EVAL      ZAMSID = 'SEA0908'                                         CGL031
529300200529     C                   EXSR      ZASNMS                                                     CGL031
529400200529     C                   ENDIF                                                                CGL031
529500200529                                                                                              CGL031
529600200529     C                   ENDIF                                                                CGL031
529700200529                                                                                              CGL031
529800200529     C                   ENDIF                                                                CGL031
529900200529      *
530000200529      ** If 'Number of Options' greater than 1
530100200529      *
530200200529     C     *IN26         IFEQ      '0'
530300200529      *
530400200529      ** 'Refuse Offer' must be equal to 'Y' or 'N'
530500200529      *
530600200529     C     #1REFO        IFNE      'Y'
530700200529     C     #1REFO        ANDNE     'N'
530800200529     C                   MOVE      'Y'           ERROR
530900200529     C                   MOVE      '1'           *IN76                          Reverse image
531000200529     C                   MOVEL     'CO00053'     ZAMSID                         Message id.
531100200529     C                   EXSR      ZASNMS                                       Send message
531200200529     C                   ENDIF
531300200529      *
531400200529      ** Validate 'Customer Option Narrative'
531500200529      *
531600200529     C     #1CONR        IFEQ      *BLANKS
531700200529      *
531800200529      ** 'Customer Option Narrative' mandatory if Refuse Offer 'Y'
531900200529      *
532000200529     C     #1REFO        IFEQ      'Y'
532100200529     C                   MOVE      'Y'           ERROR
532200200529     C                   MOVE      '1'           *IN77                          Reverse image
532300200529     C                   MOVEL     'CO00054'     ZAMSID                         Message id.
532400200529     C                   EXSR      ZASNMS                                       Send message
532500200529     C                   ENDIF
532600200529      *
532700200529     C                   ELSE
532800200529      *
532900200529      ** 'Customer Option Narrative' must Refer to a Valid live code
533000200529      *
533100200529     C     #1CONR        CHAIN     SECONAL0                           89
533200200529     C     *IN89         IFEQ      '1'
533300200529     C     MNRECI        ORNE      'D'
533400200529     C                   MOVE      'Y'           ERROR
533500200529     C                   MOVE      '1'           *IN77                          Reverse image
533600200529     C                   MOVEL     'CO00055'     ZAMSID                         Message id.
533700200529     C                   EXSR      ZASNMS                                       Send message
533800200529     C                   ENDIF
533900200529     C                   ENDIF
534000200529      *
534100200529      ** 'Default for no Reply' must be equal to one of the Customer   OPTIONS
534200200529      *
534300200529     C     #1DFNR        IFNE      '1'
534400200529     C     #1DFNR        ANDNE     '2'
534500200529     C     #1DFNR        ANDNE     '3'
534600200529     C     #1DFNR        ANDNE     '4'
534700200529     C     #1DFNR        ANDNE     '5'
534800200529     C     #1DFNR        ANDNE     '6'
534900200529     C     #1DFNR        ANDNE     '7'
535000200529     C     #1DFNR        ANDNE     '8'
535100200529     C     #1DFNR        ANDNE     '9'
535200200529     C     #1DFNR        ANDNE     ' '
535300200529     C                   MOVE      'Y'           ERROR
535400200529     C                   MOVE      '1'           *IN78                          Reverse image
535500200529     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
535600200529     C                   EXSR      ZASNMS                                       Send message
535700200529     C                   ELSE
535800200529     C                   MOVE      #1REFN        KCORF
535900200529     C                   Z-ADD     *ZEROS        KOPTN
536000200529     C                   MOVE      #1DFNR        KOPTN
536100200529      *
536200200529     C     #1PTYP        IFNE      'NC'
536300200529     C     #1PTYP        ANDNE     'NF'
536400200529     C     #1PTYP        ANDNE     'CC'
536500200529     C                   EXSR      P024
536600200529     C                   ELSE
536700200529     C                   MOVE      '0'           *IN89
536800200529     C                   ENDIF
536900200529      *
537000200529     C     *IN89         IFEQ      '1'
537100200529     C     #1PTYP        OREQ      'NC'
537200200529     C     #1DFNR        ANDNE     '1'
537300200529     C     #1PTYP        OREQ      'NF'
537400200529     C     #1DFNR        ANDNE     '1'
537500200529     C     #1PTYP        OREQ      'CC'
537600200529     C     #1DFNR        ANDNE     '1'
537700200529     C                   MOVE      'Y'           ERROR
537800200529     C                   MOVE      '1'           *IN78                          Reverse image
537900200529     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
538000200529     C                   EXSR      ZASNMS                                       Send message
538100200529     C                   ENDIF
538200200529     C                   ENDIF
538300200529      *
538400200529      ** 'Default for Cash Preferred' must be equal to one of the
538500200529      ** Customer Option
538600200529      *
538700200529     C     #1DFCP        IFNE      '1'
538800200529     C     #1DFCP        ANDNE     '2'
538900200529     C     #1DFCP        ANDNE     '3'
539000200529     C     #1DFCP        ANDNE     '4'
539100200529     C     #1DFCP        ANDNE     '5'
539200200529     C     #1DFCP        ANDNE     '6'
539300200529     C     #1DFCP        ANDNE     '7'
539400200529     C     #1DFCP        ANDNE     '8'
539500200529     C     #1DFCP        ANDNE     '9'
539600200529     C     #1DFCP        ANDNE     ' '
539700200529     C                   MOVE      'Y'           ERROR
539800200529     C                   MOVE      '1'           *IN79                          Reverse image
539900200529     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
540000200529     C                   EXSR      ZASNMS                                       Send message
540100200529     C                   ELSE
540200200529     C                   MOVE      #1REFN        KCORF
540300200529     C                   Z-ADD     *ZEROS        KOPTN
540400200529     C                   MOVE      #1DFCP        KOPTN
540500200529      *
540600200529     C     #1PTYP        IFNE      'NC'
540700200529     C     #1PTYP        ANDNE     'NF'
540800200529     C     #1PTYP        ANDNE     'CC'
540900200529     C                   EXSR      P024
541000200529     C                   ELSE
541100200529     C                   MOVE      '0'           *IN89
541200200529     C                   ENDIF
541300200529      *
541400200529     C     *IN89         IFEQ      '1'
541500200529     C     #1PTYP        OREQ      'NC'
541600200529     C     #1DFCP        ANDNE     '1'
541700200529     C     #1PTYP        OREQ      'NF'
541800200529     C     #1DFCP        ANDNE     '1'
541900200529     C     #1PTYP        OREQ      'CC'
542000200529     C     #1DFCP        ANDNE     '1'
542100200529     C                   MOVE      'Y'           ERROR
542200200529     C                   MOVE      '1'           *IN79                          Reverse image
542300200529     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
542400200529     C                   EXSR      ZASNMS                                       Send message
542500200529     C                   ENDIF
542600200529     C                   ENDIF
542700200529      *
542800200529      ** 'Default for Stock Referred' must be equal to one of the      STOMER OP
542900200529      ** Customer Option
543000200529      *
543100200529     C     #1DFSP        IFNE      '1'
543200200529     C     #1DFSP        ANDNE     '2'
543300200529     C     #1DFSP        ANDNE     '3'
543400200529     C     #1DFSP        ANDNE     '4'
543500200529     C     #1DFSP        ANDNE     '5'
543600200529     C     #1DFSP        ANDNE     '6'
543700200529     C     #1DFSP        ANDNE     '7'
543800200529     C     #1DFSP        ANDNE     '8'
543900200529     C     #1DFSP        ANDNE     '9'
544000200529     C     #1DFSP        ANDNE     ' '
544100200529     C                   MOVE      'Y'           ERROR
544200200529     C                   MOVE      '1'           *IN82                          Reverse image
544300200529     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
544400200529     C                   EXSR      ZASNMS                                       Send message
544500200529     C                   ELSE
544600200529     C                   MOVE      #1REFN        KCORF
544700200529     C                   Z-ADD     *ZEROS        KOPTN
544800200529     C                   MOVE      #1DFSP        KOPTN
544900200529      *
545000200529     C     #1PTYP        IFNE      'NC'
545100200529     C     #1PTYP        ANDNE     'NF'
545200200529     C     #1PTYP        ANDNE     'CC'
545300200529     C                   EXSR      P024
545400200529     C                   ELSE
545500200529     C                   MOVE      '0'           *IN89
545600200529     C                   ENDIF
545700200529      *
545800200529     C     *IN89         IFEQ      '1'
545900200529     C     #1PTYP        OREQ      'NC'
546000200529     C     #1DFSP        ANDNE     '1'
546100200529     C     #1PTYP        OREQ      'NF'
546200200529     C     #1DFSP        ANDNE     '1'
546300200529     C     #1PTYP        OREQ      'CC'
546400200529     C     #1DFSP        ANDNE     '1'
546500200529     C                   MOVE      'Y'           ERROR
546600200529     C                   MOVE      '1'           *IN82                          Reverse image
546700200529     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
546800200529     C                   EXSR      ZASNMS                                       Send message
546900200529     C                   ENDIF
547000200529     C                   ENDIF
547100200529     C                   ENDIF
547200200529      *
547300200529      ** If no error detected
547400200529      *
547500200529     C     ERROR         IFEQ      'N'
547600200529      *
547700200529      ** Access to ER Reference file with current Reference
547800200529      *
547900200529     C     #1REFN        CHAIN     SECORFL0                           88
548000200529      *
548100200529     C                   MOVE      'D'           MARECI
548200200529     C                   Z-ADD     BJRDNB        MALCD
548300200529     C                   MOVE      'A'           MACHTP
548400200529     C                   MOVE      ##USR         MALUID
548500200529      *
548600200529     C     *INKK         IFEQ      '0'
548700200529     C                   MOVE      *BLANKS       MAJOBN
548800200529     C                   MOVE      *BLANKS       MAUSER
548900200529     C                   Z-ADD     *ZEROS        MAJNBR
549000200529     C                   ENDIF
549100200529      *
549200200529     C                   Z-ADD     WCOPD         MACOPD
549300200529     C                   Z-ADD     WTDDT         MATDDT
549400200529     C                   MOVE      #1TDVD        MATDVD
549500200529     C                   Z-ADD     WCOPD         MACOPD
549600200529     C                   Z-ADD     WTDDT         MATDDT
549700200529     C                   Z-ADD     WEVDT         MAEVDT
549800200529     C                   MOVE      #1CPNB        MACPNB
549900200529      *
550000200529     C                   MOVE      #1SHMD        DateIn
550100200529     C                   EXSR      ZDATE1
550200200529     C                   Z-ADD     DAYNOOUT      MASHMD
550300200529      *
550400200529     C                   MOVE      #1LTBS        MALTBS
550500200529      *
550600200529     C                   MOVE      *BLANKS       ZFLD17
550700200529     C                   MOVEL     #1OCPV        ZFLD17
550800200529     C     15            SUB       NMDP          ZSDIG
550900200529     C                   Z-ADD     NMDP          ZSDEC
551000200529      *
551100200529     C                   EXSR      ZASIGN
551200200529      *
551300200529     C                   MOVE      ZOUT15        WOUT15           15 0
551400200529      *
551500200529     C     ZFSIGN        IFEQ      '+'
551600200529     C                   Z-ADD     WOUT15        MAOCPV
551700200529     C                   ELSE
551800200529     C                   Z-SUB     WOUT15        MAOCPV
551900200529     C                   ENDIF
552000200529      *
552100200529     C                   MOVE      *BLANKS       ZFLD17
552200200529     C                   MOVEL     #1NCPV        ZFLD17
552300200529     C     15            SUB       NMDP          ZSDIG
552400200529     C                   Z-ADD     NMDP          ZSDEC
552500200529     C                   EXSR      ZASIGN
552600200529     C                   MOVE      ZOUT15        WOUT15
552700200529      *
552800200529     C     ZFSIGN        IFEQ      '+'
552900200529     C                   Z-ADD     WOUT15        MANCPV
553000200529     C                   ELSE
553100200529     C                   Z-SUB     WOUT15        MANCPV
553200200529     C                   ENDIF
553300200529      *
553400200529     C                   MOVE      *BLANKS       ZFLD17
553500200529     C                   MOVEL     #1ONML        ZFLD17
553600200529     C     15            SUB       NMDP          ZSDIG
553700200529     C                   Z-ADD     NMDP          ZSDEC
553800200529     C                   EXSR      ZASIGN
553900200529     C                   MOVE      ZOUT15        WOUT15
554000200529      *
554100200529     C     ZFSIGN        IFEQ      '+'
554200200529     C                   Z-ADD     WOUT15        MAONML
554300200529     C                   ELSE
554400200529     C                   Z-SUB     WOUT15        MAONML
554500200529     C                   ENDIF
554600200529      *
554700200529     C                   MOVE      *BLANKS       ZFLD17
554800200529     C                   MOVEL     #1NNML        ZFLD17
554900200529     C     15            SUB       NMDP          ZSDIG
555000200529     C                   Z-ADD     NMDP          ZSDEC
555100200529     C                   EXSR      ZASIGN
555200200529      *
555300200529     C                   MOVE      ZOUT15        WOUT15
555400200529      *
555500200529     C     ZFSIGN        IFEQ      '+'
555600200529     C                   Z-ADD     WOUT15        MANNML
555700200529     C                   ELSE
555800200529     C                   Z-SUB     WOUT15        MANNML
555900200529     C                   ENDIF
556000200529      *
556100200529     C                   MOVE      *BLANKS       ZFIELD
556200200529     C                   MOVEL     #1CUPC        ZFIELD
556300200529     C                   Z-ADD     7             ZADIG
556400200529     C                   Z-ADD     8             ZADEC
556500200529     C                   EXSR      ZALIGN
556600200529     C                   MOVE      ZFIELD        MACUPC
556700200529      *
556800200529     C                   MOVE      *BLANKS       ZFIELD
556900200529     C                   MOVEL     #1EXPC        ZFIELD
557000200529     C                   Z-ADD     7             ZADIG
557100200529     C                   Z-ADD     8             ZADEC
557200200529     C                   EXSR      ZALIGN
557300200529     C                   MOVE      ZFIELD        MAEXPC
557400200529      *
557500200529     C                   MOVE      #1CLRD        DateIn
557600200529     C                   EXSR      ZDATE1
557700200529     C                   Z-ADD     DAYNOOUT      MACLRD
557800200529      *
557900200529     C                   MOVE      #1CLRT        MACLRT
558000200529      *
558100200529     C                   MOVE      #1DLRD        DateIn
558200200529     C                   EXSR      ZDATE1
558300200529     C                   Z-ADD     DAYNOOUT      MADLRD
558400200529      *
558500200529     C                   MOVE      #1DLRT        MADLRT
558600200529     C                   MOVE      #1BLOS        MABLOS
558700200529     C                   MOVE      #1BLOP        MABLOP
558800200529      *
558900200529     C                   MOVE      #1BFRD        DateIn
559000200529     C                   EXSR      ZDATE1
559100200529     C                   Z-ADD     DAYNOOUT      MABFRD
559200200529      *
559300200529     C     #1BEND        IFNE      *BLANKS
559400200529     C                   MOVE      #1BEND        DateIn
559500200529     C                   EXSR      ZDATE1
559600200529     C                   Z-ADD     DAYNOOUT      MABEND
559700200529     C                   ELSE
559800200529     C     #1BLOS        IFEQ      'E'
559900200529     C     #1BLOS        OREQ      'W'
560000200529     C     #1BLOP        OREQ      'E'
560100200529     C     #1BLOP        OREQ      'W'
560200200529     C                   Z-ADD     *HIVAL        MABEND
560300200529     C                   ELSE
560400200529     C                   Z-ADD     *ZEROS        MABEND
560500200529     C                   ENDIF
560600200529     C                   ENDIF
560700200529      *                                                                                       CGL031
560800200529      ** Move relevant screen fields to file fields if CGL031 is enabled.                     CGL031
560900200529      *                                                                                       CGL031
561000200529     C                   IF        CGL031 = 'Y'                                               CGL031
561100200529     C                   EVAL      MASETX = #1SETX                                            CGL031
561200200529     C                   ELSE                                                                 CGL031
561300200529     C                   EVAL      MASETX = *BLANK                                            CGL031
561400200529     C                   ENDIF                                                                CGL031
561500200529      *
561600200529     C                   MOVE      #1REFO        MAREFO
561700200529     C                   MOVE      #1CONR        MACONR
561800200529     C                   MOVE      #1DFNR        MADFNR
561900200529     C                   MOVE      #1DFCP        MADFCP
562000200529     C                   MOVE      #1DFSP        MADFSP
562100200529      *
562200200529      ** Blocking Processing
562300200529      *
562400200529     C     #1BLOS        IFNE      #2BLOS
562500200529     C     #1BFRD        ORNE      #2BFRD
562600200529     C     #1BEND        ORNE      #2BEND
562700200529     C                   EXSR      P020
562800200529     C                   ENDIF
562900200529      *
563000200529     C                   UPDATE    SECORFD0
563100200529     C                   MOVE      FIELD         #FIELD
563200200529      *
563300200529      ** Add commitment instruction
563400200529      *
563500200529     C                   COMMIT
563600200529      *
563700200529     C                   ENDIF
563800200529      *
563900200529     C                   ENDSR
564000200529      *****************************************************************
564100200529      /EJECT
564200200529      *****************************************************************
564300200529      * P020  : Blocking Processing                                   *
564400200529      *****************************************************************
564500200529      *
564600200529     C     P020          BEGSR
564700200529      *
564800200529      ** Access blocking file with the Corporate Action Reference
564900200529      *
565000200529     C     MACORF        CHAIN     SECOBKL2                           89
565100200529      *
565200200529      ** If Block exists, reverse the Current Blocking record
565300200529      *
565400200529     C     *IN89         IFEQ      '0'
565500200529     C                   MOVE      '*'           MURECI
565600200529     C                   UPDATE    SECOBKD2
565700200529     C                   ENDIF
565800200529      *
565900200529      ** Access Blocking file with the Corporate Action Reference
566000200529      *
566100200529     C     MACORF        CHAIN     SECOBKL2                           89
566200200529      *
566300200529      ** If Block exists, reverse the current blocking record
566400200529      *
566500200529     C     *IN89         IFEQ      '0'
566600200529     C                   MOVE      '*'           MURECI
566700200529     C                   UPDATE    SECOBKD2
566800200529     C                   ENDIF
566900200529      *
567000200529      ** Create the new blocking record if Block Position 'E' or'W'
567100200529      *
567200200529     C     MABLOS        IFEQ      'E'
567300200529     C     MABLOS        OREQ      'W'
567400200529     C                   MOVE      'D'           MURECI
567500200529     C                   Z-ADD     BJRDNB        MULCD
567600200529     C                   MOVE      'I'           MUCHTP
567700200529     C                   MOVE      ##USR         MULUID
567800200529     C                   MOVE      BVBRCD        MUBRCD
567900200529     C**********         Z-ADD     *ZEROS        MUCNUM                                       CSD027
568000200529     C                   EVAL      MUCNUM = *BLANKS                                           CSD027
568100200529     C                   MOVE      *BLANKS       MUPTFR
568200200529     C                   MOVE      'P'           MUBLTY
568300200529     C                   MOVE      MASESN        MUSESN
568400200529     C                   MOVE      MABEND        MUBEDT
568500200529     C                   Z-ADD     *ZEROS        MUNOMB
568600200529      *
568700200529     C                   MOVEL     MACOAT        WWBNAR            9
568800200529     C                   MOVE      MACORF        WWBNAR
568900200529     C                   MOVEL     WWBNAR        MUBNAR
569000200529      *
569100200529     C                   Z-ADD     1             MUSEQN
569200200529     C                   MOVE      MABFRD        MUBSTT
569300200529     C                   MOVE      MABLOS        MUBEWI
569400200529     C                   MOVE      MACORF        MUCORF
569500200529     C                   WRITE     SECOBKD2
569600200529     C                   MOVE      'S'           MUBLTY
569700200529     C                   WRITE     SECOBKD2
569800200529     C                   ENDIF
569900200529      *
570000200529     C                   ENDSR
570100200529      *****************************************************************
570200200529      /EJECT
570300200529      *****************************************************************
570400200529      * P021  : Retrieve next available Reference number              *
570500200529      *****************************************************************
570600200529      *
570700200529     C     P021          BEGSR
570800200529      *
570900200529      ** Setup "Reference" field with next available number
571000200529      *
571100200529     C                   MOVE      WWCORF        #1REFN
571200200529     C                   ADD       1             WWCORF
571300200529      *
571400200529      ** Access to ER Reference file with current Reference
571500200529      *
571600200529     C     #1REFN        CHAIN     SECORFL9                           88
571700200529      *
571800200529      ** If a record is found
571900200529      *
572000200529     C     *IN88         DOWEQ     '0'
572100200529      *
572200200529     C                   MOVE      WWCORF        #1REFN
572300200529     C                   ADD       1             WWCORF
572400200529      *
572500200529      ** Access to ER Reference file with current reference
572600200529      *
572700200529     C     #1REFN        CHAIN     SECORFL9                           88
572800200529     C                   ENDDO
572900200529      *
573000200529     C                   MOVE      #1BLOS        #2BLOS
573100200529     C                   MOVE      #1BEND        #2BEND
573200200529     C                   MOVE      #1BFRD        #2BFRD
573300200529      *
573400200529     C                   ENDSR
573500200529      ****************************************************************
573600200529      /EJECT
573700200529      *****************************************************************
573800200529      * P022  : Apply Action to All Options                           *
573900200529      *****************************************************************
574000200529      *
574100200529     C     P022          BEGSR
574200200529      *
574300200529     C                   SELECT
574400200529     C     #1PTYP        WHENEQ    'DV'
574500200529     C     #1REFN        SETLL     SECODVL0
574600200529     C     #1REFN        READE     SECODVL0                               89
574700200529      *
574800200529     C     #1PTYP        WHENEQ    'FR'
574900200529     C     #1REFN        SETLL     SECOFRL0
575000200529     C     #1REFN        READE     SECOFRL0                               89
575100200529      *
575200200529     C     #1PTYP        WHENEQ    'CE'
575300200529     C     #1REFN        SETLL     SECOCEL0
575400200529     C     #1REFN        READE     SECOCEL0                               89
575500200529      *
575600200529     C     #1PTYP        WHENEQ    'CR'
575700200529     C     #1REFN        SETLL     SECOCRL0
575800200529     C     #1REFN        READE     SECOCRL0                               89
575900200529      *
576000200529     C     #1PTYP        WHENEQ    'OF'
576100200529     C     #1REFN        SETLL     SECOOFL0
576200200529     C     #1REFN        READE     SECOOFL0                               89
576300200529      *
576400200529     C     #1PTYP        WHENEQ    'RG'
576500200529     C     #1REFN        SETLL     SECORGL0
576600200529     C     #1REFN        READE     SECORGL0                               89
576700200529      *
576800200529     C     #1PTYP        WHENEQ    'EX'
576900200529     C     #1REFN        SETLL     SECOEXL0
577000200529     C     #1REFN        READE     SECOEXL0                               89
577100200529      *
577200200529     C     #1PTYP        WHENEQ    'NC'
577300200529     C     #1REFN        SETLL     SECONCL0
577400200529     C     #1REFN        READE     SECONCL0                               89
577500200529      *
577600200529     C     #1PTYP        WHENEQ    'NF'
577700200529     C     #1REFN        SETLL     SECONFL0
577800200529     C     #1REFN        READE     SECONFL0                               89
577900200529      *
578000200529     C     #1PTYP        WHENEQ    'CC'
578100200529     C     #1REFN        SETLL     SECOCCL0
578200200529     C     #1REFN        READE     SECOCCL0                               89
578300200529     C                   ENDSL
578400200529      *
578500200529     C     *IN89         DOWEQ     '0'
578600200529      *
578700200529     C                   SELECT
578800200529     C     #1PTYP        WHENEQ    'DV'
578900200529     C     #1SEL         IFEQ      'D'
579000200529     C                   DELETE    SECODVD0
579100200529     C                   ENDIF
579200200529     C     #1REFN        READE     SECODVL0                               89
579300200529      *
579400200529     C     #1PTYP        WHENEQ    'FR'
579500200529      *
579600200529     C     #1SEL         IFEQ      'D'
579700200529     C                   DELETE    SECOFRD0
579800200529     C                   ENDIF
579900200529     C     #1REFN        READE     SECOFRL0                               89
580000200529      *
580100200529     C     #1PTYP        WHENEQ    'CE'
580200200529     C     #1SEL         IFEQ      'D'
580300200529     C                   DELETE    SECOCED0
580400200529     C                   ENDIF
580500200529     C     #1REFN        READE     SECOCEL0                               89
580600200529      *
580700200529     C     #1PTYP        WHENEQ    'CR'
580800200529     C     #1SEL         IFEQ      'D'
580900200529     C                   DELETE    SECOCRD0
581000200529     C                   ELSE
581100200529     C                   ENDIF
581200200529     C     #1REFN        READE     SECOCRL0                               89
581300200529      *
581400200529     C     #1PTYP        WHENEQ    'OF'
581500200529     C     #1SEL         IFEQ      'D'
581600200529     C                   DELETE    SECOOFD0
581700200529     C                   ENDIF
581800200529     C     #1REFN        READE     SECOOFL0                               89
581900200529      *
582000200529     C     #1PTYP        WHENEQ    'RG'
582100200529     C     #1SEL         IFEQ      'D'
582200200529     C                   DELETE    SECORGD0
582300200529     C                   ENDIF
582400200529     C     #1REFN        READE     SECORGL0                               89
582500200529      *
582600200529     C     #1PTYP        WHENEQ    'EX'
582700200529     C     #1SEL         IFEQ      'D'
582800200529     C                   DELETE    SECOEXD0
582900200529     C                   ENDIF
583000200529      *
583100200529     C     #1REFN        READE     SECOEXL0                               89
583200200529      *
583300200529     C     #1PTYP        WHENEQ    'NC'
583400200529     C     #1SEL         IFEQ      'D'
583500200529     C                   DELETE    SECONCD0
583600200529     C                   ENDIF
583700200529     C     #1REFN        READE     SECONCL0                               89
583800200529      *
583900200529     C     #1PTYP        WHENEQ    'NF'
584000200529     C     #1SEL         IFEQ      'D'
584100200529     C                   DELETE    SECONFD0
584200200529     C                   ENDIF
584300200529     C     #1REFN        READE     SECONFL0                               89
584400200529      *
584500200529     C     #1PTYP        WHENEQ    'CC'
584600200529     C     #1SEL         IFEQ      'D'
584700200529      *
584800200529     C     NABLKR        IFNE      *ZEROS
584900200529     C                   Z-ADD     *ZEROS        WCOUNT            5 0
585000200529     C                   MOVE      #1REFN        W1REFN            6 0
585100200529      *
585200200529     C     NABLKR        SETLL     SECORSL0
585300200529     C     NABLKR        READE     SECORSL0                               88
585400200529     C     *IN88         DOWEQ     '0'
585500200529     C                   ADD       1             WCOUNT
585600200529     C     W1REFN        IFEQ      NCCORF
585700200529     C     NCRECI        ORNE      'D'
585800200529     C                   DELETE    SECORSD0
585900200529     C                   SUB       1             WCOUNT
586000200529     C                   ENDIF
586100200529     C     NABLKR        READE     SECORSL0                               88
586200200529     C                   ENDDO
586300200529      *
586400200529     C     WCOUNT        IFEQ      *ZEROS
586500200529     C     NABLKR        CHAIN     SECORBL0                           88
586600200529     C     *IN88         IFEQ      '0'
586700200529     C                   DELETE    SECORBD0
586800200529     C                   ENDIF
586900200529     C                   ENDIF
587000200529     C                   ENDIF
587100200529      *
587200200529     C                   DELETE    SECOCCD0
587300200529     C                   ENDIF
587400200529     C     #1REFN        READE     SECOCCL0                               89
587500200529     C                   ENDSL
587600200529      *
587700200529     C                   ENDDO
587800200529      *
587900200529     C                   ENDSR
588000200529      *****************************************************************
588100200529      /EJECT
588200200529      *****************************************************************
588300200529      * P023  : View/Change Option(s)                                 *
588400200529      *****************************************************************
588500200529      *
588600200529     C     P023          BEGSR
588700200529      *
588800200529     C                   MOVE      'Y'           ERROR
588900200529      *
589000200529     C     #1COAT        CHAIN     SECOATL0                           89
589100200529      *
589200200529     C                   MOVE      *BLANKS       P#RTCD
589300200529      *
589400200529     C                   MOVE      #1EXDT        DateIn
589500200529     C                   EXSR      ZDATE1
589600200529     C                   MOVE      DAYNOOUT      WEXDAT
589700200529      *
589800200529     C                   MOVE      *BLANKS       WNBOP
589900200529     C                   MOVE      #1NBOP        WNBOP             2
590000200529     C                   MOVE      #1NBOP        SNBOP             2
590100200529      *
590200200529     C     MMPTYP        IFEQ      'NF'
590300200529     C                   CALL      'SE7510'                             99
590400200529     C                   PARM                    #1REFN                         ER Reference
590500200529     C                   PARM                    #1SECN                         Security Shortname
590600200529     C                   PARM                    #1COAT                         Corporate Action Typ
590700200529     C                   PARM                    #1STAT                         Corporate Action Sta
590800200529     C                   PARM                    #1FINA                         Final Allocation Ind
590900200529     C                   PARM                    MMPTYP                         Processing Type
591000200529     C                   PARM                    WEXDAT            5            Ex-Date
591100200529     C                   PARM                    #1SEL                          Action
591200200529     C                   PARM                    P#RTCD            1            Return Code
591300200529     C                   ELSE
591400200529      *
591500200529     C     MMPTYP        IFEQ      'NC'
591600200529     C                   CALL      'SE7511'                             99
591700200529     C                   PARM                    #1REFN                         ER Reference
591800200529     C                   PARM                    #1SECN                         Security Shortname
591900200529     C                   PARM                    #1COAT                         Corporate Action Typ
592000200529     C                   PARM                    #1STAT                         Corporate Action Sta
592100200529     C                   PARM                    #1FINA                         Final Allocation Ind
592200200529     C                   PARM                    MMPTYP                         Processing Type
592300200529     C                   PARM                    WEXDAT            5            Ex-Date
592400200529     C                   PARM                    #1SEL                          Action
592500200529     C                   PARM                    P#RTCD            1            Return Code
592600200529     C                   ELSE
592700200529      *
592800200529     C     MMPTYP        IFEQ      'CC'
592900200529     C                   CALL      'SE7520'                             99
593000200529     C                   PARM                    #1REFN                         Ref.
593100200529     C                   PARM                    #1SECN                         Security
593200200529     C                   PARM                    #1COAT                         Type
593300200529     C                   PARM                    #1STAT                         Status
593400200529     C                   PARM                    #1FINA                         Alloc.
593500200529     C                   PARM                    MMPTYP                         Proc.
593600200529     C                   PARM                    WEXDAT            5            Ex-Date
593700200529     C                   PARM                    #1SEL                          Action
593800200529     C                   PARM                    P#RTCD            1            Return
593900200529     C                   ELSE
594000200529      *
594100200529     C                   CALL      'SE7599'                             99
594200200529     C                   PARM                    #1REFN                         ER Reference
594300200529     C                   PARM                    #1SECN                         Security Shortname
594400200529     C                   PARM                    #1COAT                         Corporate Action Typ
594500200529     C                   PARM                    #1STAT                         Corporate Action Sta
594600200529     C                   PARM                    #1FINA                         Final Allocation Ind
594700200529     C                   PARM                    MMPTYP                         Processing Type
594800200529     C                   PARM                    WEXDAT            5            Ex-Date
594900200529     C                   PARM                    WNBOP                          Number of Options
595000200529     C                   PARM                    #1SEL                          Action
595100200529     C                   PARM      'E'           WWEVDP            1            Events or Depots
595200200529     C                   PARM                    #1TDVD                         Trade/Value Position
595300200529     C                   PARM                    P#RTCD            1            Return Code
595400200529     C                   PARM      ' '           WWREX             1
595500200529     C                   ENDIF
595600200529     C                   ENDIF
595700200529     C                   ENDIF
595800200529      *
595900200529      ** If error indicator of the program call is on or if return
596000200529      ** code is equal to 'E' (Error), database error
596100200529      *
596200200529     C     *IN99         IFEQ      '1'
596300200529     C     P#RTCD        OREQ      'E'
596400200529      *
596500200529     C     MMPTYP        IFEQ      'NF'
596600200529     C                   MOVEL     NARR(2)       DBKEY            29
596700200529     C                   ELSE
596800200529     C     MMPTYP        IFEQ      'NC'
596900200529     C                   MOVEL     NARR(3)       DBKEY
597000200529     C                   ELSE
597100200529     C     MMPTYP        IFEQ      'CC'
597200200529     C                   MOVEL     NARR(7)       DBKEY
597300200529     C                   ELSE
597400200529     C                   MOVEL     NARR(1)       DBKEY
597500200529     C                   ENDIF
597600200529     C                   ENDIF
597700200529     C                   ENDIF
597800200529      *
597900200529     C                   MOVEL     '009'         DBASE             3 0          *****************
598000200529     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 09 **
598100200529     C                   EXSR      *PSSR                                        *****************
598200200529     C                   ENDIF
598300200529      *
598400200529      ** If Return code is equal to '2', '3'
598500200529      *
598600200529     C     P#RTCD        IFEQ      '3'
598700200529      *
598800200529      ** Access to ER Reference file with current Reference
598900200529      *
599000200529     C     #1REFN        CHAIN     SECORFL0                           88
599100200529      *
599200200529     C     *IN88         IFEQ      '0'
599300200529     C                   MOVE      *BLANKS       MAJOBN
599400200529     C                   MOVE      *BLANKS       MAUSER
599500200529     C                   Z-ADD     *ZEROS        MAJNBR
599600200529      *
599700200529     C     MACHTP        IFNE      'R'
599800200529     C     MASTAT        ANDNE     'R'
599900200529     C     MASTAT        ANDNE     'C'
600000200529     C                   MOVE      'D'           MARECI
600100200529     C                   Z-ADD     BJRDNB        MALCD
600200200529     C                   MOVE      'A'           MACHTP
600300200529     C                   MOVE      ##USR         MALUID
600400200529     C                   ENDIF
600500200529      *
600600200529     C                   UPDATE    SECORFD0
600700200529     C                   MOVE      FIELD         #FIELD
600800200529     C                   ENDIF
600900200529      *
601000200529      ** Commitment Instruction
601100200529      *
601200200529     C                   COMMIT
601300200529     C                   ENDIF
601400200529      *
601500200529     C     P#RTCD        IFEQ      '3'
601600200529     C                   MOVE      '1'           *INKC
601700200529     C                   ELSE
601800200529     C     WWINPT        IFEQ      'Y'
601900200529     C                   MOVE      '1'           WIN12
602000200529     C                   ENDIF
602100200529     C                   ENDIF
602200200529      *
602300200529     C     WNBOP         IFNE      SNBOP
602400200529     C                   MOVE      '0'           WIN45
602500200529     C                   ENDIF
602600200529      *
602700200529     C                   ENDSR
602800200529      ****************************************************************
602900200529      /EJECT
603000200529      *****************************************************************
603100200529      * P024  : Verify if the Option Exists                           *
603200200529      *****************************************************************
603300200529      *
603400200529     C     P024          BEGSR
603500200529      *
603600200529     C                   MOVE      '0'           *IN89
603700200529      *
603800200529     C     #1PTYP        IFEQ      'DV'
603900200529     C     KEY6          CHAIN     SECODVL0                           89
604000200529      *
604100200529     C                   ELSE
604200200529     C     #1PTYP        IFEQ      'FR'
604300200529     C     KEY6          CHAIN     SECOFRL0                           89
604400200529      *
604500200529     C                   ELSE
604600200529     C     #1PTYP        IFEQ      'CE'
604700200529     C     KEY6          CHAIN     SECOCEL0                           89
604800200529      *
604900200529     C                   ELSE
605000200529     C     #1PTYP        IFEQ      'CR'
605100200529     C     KEY6          CHAIN     SECOCRL0                           89
605200200529      *
605300200529     C                   ELSE
605400200529     C     #1PTYP        IFEQ      'OF'
605500200529     C     KEY6          CHAIN     SECOOFL0                           89
605600200529      *
605700200529     C                   ELSE
605800200529     C     #1PTYP        IFEQ      'RG'
605900200529     C     KEY6          CHAIN     SECORGL0                           89
606000200529      *
606100200529     C                   ELSE
606200200529     C     #1PTYP        IFEQ      'EX'
606300200529     C     KEY6          CHAIN     SECOEXL0                           89
606400200529     C                   ENDIF
606500200529     C                   ENDIF
606600200529     C                   ENDIF
606700200529     C                   ENDIF
606800200529     C                   ENDIF
606900200529     C                   ENDIF
607000200529     C                   ENDIF
607100200529      *
607200200529     C                   ENDSR
607300200529      ****************************************************************
607400200529      /EJECT
607500200529      *****************************************************************
607600200529      * P025  : Check that no Position Exists on Depot Positions file *
607700200529      *****************************************************************
607800200529      *
607900200529     C     P025          BEGSR
608000200529      *
608100200529     C                   MOVE      '0'           *IN89
608200200529      *
608300200529     C     #1SEL         IFEQ      'E'
608400200529     C     #1REFN        CHAIN     SECODPL1                           89
608500200529     C                   ELSE
608600200529     C     #1SEL         IFEQ      'V'
608700200529     C     #1REFN        CHAIN     SECOALL1                           89
608800200529     C                   ENDIF
608900200529     C                   ENDIF
609000200529      *
609100200529     C     *IN89         IFEQ      '1'
609200200529     C                   MOVE      'Y'           ERMSG
609300200529     C                   MOVE      '1'           *IN62                          Reverse image
609400200529     C                   MOVEL     'CO00256'     ZAMSID                         Message id.
609500200529     C                   EXSR      ZASNMS                                       Send message
609600200529     C                   ENDIF
609700200529      *
609800200529     C     #1SEL         IFEQ      'N'
609900200529     C     #1SECN        CHAIN     DPOSS                              89
610000200529      *
610100200529     C     *IN89         IFEQ      '0'
610200200529     C                   MOVE      'Y'           ERMSG
610300200529     C                   MOVE      '1'           *IN62                          Reverse image
610400200529     C                   MOVEL     'CO00255'     ZAMSID                         Message id.
610500200529     C                   EXSR      ZASNMS                                       Send message
610600200529     C                   ENDIF
610700200529     C                   ENDIF
610800200529      *
610900200529     C                   ENDSR
611000200529      ****************************************************************
611100200529      /EJECT
611200200529      *****************************************************************
611300200529      *                                                               *
611400200529      *  ZDATE1   - Validate and convert date to day number           *
611500200529      *                                                               *
611600200529      *****************************************************************
611700200529     C     ZDATE1        BEGSR
611800200529      *
611900200529     C                   CALLB     'ZDATE1'
612000200529     C                   PARM                    DateIn
612100200529     C                   PARM      *ZERO         DaynoOut
612200200529     C                   PARM                    BJDFIN
612300200529     C                   PARM      *BLANK        ErrorFlag
612400200529      *
612500200529     C                   ENDSR
612600200529      *****************************************************************
612700200529      /EJECT
612800200529      *****************************************************************
612900200529      *                                                               *
613000200529      *  ZDATE2 - Format a Date for Screen Output                     *
613100200529      *                                                               *
613200200529      *****************************************************************
613300200529     C     ZDATE2        BEGSR
613400200529      *
613500200529     C                   CALLB     'ZDATE2'
613600200529     C                   PARM                    ZDAYNO
613700200529     C                   PARM                    BJDFIN
613800200529     C                   PARM      *Zero         ZDATE
613900200529     C                   PARM      *BLanks       ZADATE
614000200529      *
614100200529     C                   ENDSR
614200200529      *****************************************************************
614300200529      /EJECT
614400200529      *****************************************************************
614500200529      *                                                               *
614600200529      *  ZALIGN - Validate/Right align numeric field                  *
614700200529      *                                                               *
614800200529      *****************************************************************
614900200529     C     ZALIGN        BEGSR
615000200529      *
615100200529     C                   CALLB     'ZALIGN'
615200200529     C                   PARM      'Y'           ZAlignOk
615300200529     C                   PARM                    ZFIELD
615400200529     C                   PARM                    ZADEC
615500200529     C                   PARM                    ZADIG
615600200529      *
615700200529     C                   ENDSR
615800200529      *****************************************************************
615900200529      /EJECT
616000200529      *****************************************************************
616100200529      *                                                               *
616200200529      *  ZSEDIT - Format Amount for Display                           *
616300200529      *                                                               *
616400200529      *****************************************************************
616500200529     C     ZSEDIT        BEGSR
616600200529      *
616700200529     C                   CALLB     'ZSEDIT'
616800200529     C                   PARM                    ZFLD15           15 0
616900200529     C                   PARM                    ZDECS             1 0
617000200529     C                   PARM      *BLANKS       ZECODE            1
617100200529     C                   PARM                    ZOUT21           21
617200200529      *
617300200529     C                   EVAL      ZFLD15 = *ZEROS
617400200529     C                   ENDSR
617500200529      *****************************************************************
617600200529      /EJECT
617700200529      *****************************************************************
617800200529      *                                                               *
617900200529      *  ZASIGN - Validate/Right align signed numeric fields          *
618000200529      *                                                               *
618100200529      *****************************************************************
618200200529     C     ZASIGN        BEGSR
618300200529      *
618400200529     C                   CALLB     'ZASIGN'
618500200529     C                   PARM      'Y'           ZAsignOk
618600200529     C                   PARM                    ZFLD17
618700200529     C                   PARM                    ZSDIG
618800200529     C                   PARM                    ZSDEC
618900200529     C                   PARM                    ZSDCSP
619000200529     C                   PARM                    ZOUT15
619100200529     C                   PARM                    ZFSIGN
619200200529      *
619300200529     C                   ENDSR
619400200529      *****************************************************************
619500200529      /EJECT
619600200529      ****************************************************************
619700200529      *  ZASNMS : Send Message to Program's Message Queue            *
619800200529      ****************************************************************
619900200529      *
620000200529     C     ZASNMS        BEGSR
620100200529      *
620200200529      **   message file specified use PMSGF
620300200529      *
620400200529     C                   MOVEL     PMSGF         ZAMSGF
620500200529     C                   CALL      'Y2SNMGC'
620600200529     C                   PARM                    ZAPGM            10            Program queue
620700200529     C                   PARM                    ZAPGRL            5            Rel queue
620800200529     C                   PARM                    ZAMSID            7            Message Id.
620900200529     C                   PARM                    ZAMSGF           10            Message file.
621000200529     C                   PARM                    ZAMSDA          132            Message data.
621100200529     C                   PARM                    ZAMSTP            7            Message type.
621200200529      *
621300200529      ** Clear all fields for default mechanism next time.
621400200529      *
621500200529     C                   MOVEL     *BLANK        ZAPGM                          Program queue
621600200529     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
621700200529     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
621800200529     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
621900200529     C                   MOVEL     *BLANK        ZAMSGF                         Message file
622000200529     C                   MOVEL     *BLANK        ZAMSID                         Message id.
622100200529      *
622200200529     C                   ENDSR
622300200529      *****************************************************************
622400200529      /EJECT
622500200529      *****************************************************************
622600200529      * *PSSR - TO PROCESS ABNORMAL END OF PROGRAM                    *
622700200529      *****************************************************************
622800200529     C     *PSSR         BEGSR
622900200529      *
623000200529      ** Update LDA with error information
623100200529      *
623200200529     C     *DTAARA       DEFINE                  LDA
623300200529     C     *LOCK         IN        LDA
623400200529     C                   MOVEL     DBFILE        WWFILE
623500200529     C                   MOVEL     DBKEY         WWKEY
623600200529     C                   MOVEL     DBPGM         WWPGM
623700200529     C                   MOVEL     DBASE         WWASE
623800200529     C                   OUT       LDA
623900200529      *
624000200529      ** Rollback changes, print dump and cancel program
624100200529      *
624200200529     C                   ROLBK
624300200529     C                   DUMP
624400200529      *
624500200529      ** Try ti release corporate action by access to ER reference file
624600200529      ** if current ER Reference is not blank
624700200529      *
624800200529     C     #1REFN        IFNE      *BLANKS
624900200529     C     #1REFN        SETLL     SECORFL0
625000200529     C                   READ      SECORFL0                               89
625100200529      *
625200200529      ** If the record exists
625300200529      *
625400200529     C     *IN89         IFEQ      '0'
625500200529      *
625600200529     C                   MOVE      *BLANKS       MAJOBN
625700200529     C                   MOVE      *BLANKS       MAUSER
625800200529     C                   Z-ADD     *ZEROS        MAJNBR
625900200529      *
626000200529      ** Update the record
626100200529      *
626200200529     C                   UPDATE    SECORFD0
626300200529     C                   MOVE      FIELD         #FIELD
626400200529      *
626500200529      ** Commitment instruction
626600200529      *
626700200529     C                   COMMIT
626800200529     C                   ENDIF
626900200529     C                   ENDIF
627000200529      *
627100200529     C                   MOVE      '1'           *INU7
627200200529     C                   MOVE      '1'           *INU8
627300200529     C                   MOVE      '1'           *INLR
627400200529     C                   CALL      'DBERRCTL'
627500200529     C                   RETURN
627600200529      *
627700200529     C                   ENDSR
627800200529      *****************************************************************
627900200529      /EJECT
628000200529**CTDATA CPY@
628100200529(c) Finastra International Limited 2001
628200200529**CTDATA TXT
628300200529F3=Exit  F5=Refresh Screen  F11=View Option(s) Rollup/Rolldown
628400200529F3=Exit  F5=Refresh Screen  F9=Go to 'Change' Mode  Rollup/Rolldown
628500200529F3=Exit  F5=Refresh Screen  F9=Go to 'Add' Mode  Rollup/Rolldown
628600200529F3=Exit  F11=View Option(s)  F12=Previous
628700200529F3=Exit  F11=Change Option(s)  F12=Previous
628800200529F3=Exit  F12=Previous
628900200529F3=Exit  F11=View Option(s)    F12=Previous  F8=Subordinate Action
629000200529F3=Exit  F11=Change Option(s)  F12=Previous  F8=Subordinate Action
629100200529F3=Exit  F5=Refresh  F9=Go to 'Add' Mode  Rollup/Rolldown  F12=Parent Action
629200200529F3=Exit  F5=Refresh  F9=Go to Change Mode  Rollup/Rolldown  F12=Parent Action
629300200529F3=Exit  F5=Refresh            F12=Parent Action  Rollup/Rolldown
629400200529**CTDATA NARR
629500200529ERROR CALL PGM 'SE7599'
629600200529ERROR CALL PGM 'SE7510'
629700200529ERROR CALL PGM 'SE7511'
629800200529OPTION SHORTNAME NUMBER
629900200529ERROR CALL PGM 'SE7512'
630000200529ERROR CALL PGM 'SE7514'
630100200529ERROR CALL PGM 'SE7520'
630200200529ERROR CALL PGM 'SE7533'
630300200529ERROR CALL PGM 'SE7540'
