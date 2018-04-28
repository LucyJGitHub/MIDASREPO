     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Corporate actions events maintenance')        *
/*OVR *  OVRDBF FILE(SECTYZ1) TOFILE(SECTY) SHARE(*NO)              : *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7502N - SE Corporate Actions Events Maintenance            *
      *            Subordinate Action                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE020  *CREATE    Date 21Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSE020 - Corporate Actions Domino Effect Processing          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      **   MA - SE Corporate Actions References - Upd Idx
     FSECORFL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MU - SE Corporate Actions Blocked Positions
     FSECOBKL1  UF   E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **  MQ - SE Corporate Actions Customer/Book Reply
     FSECOREL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **  MP - SE Corporate Actions Reply History file-Detail
     FSECORHL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MU - SE Corporate Actions Blocked Positions
     FSECOBKL2  UF A E           K DISK
     F                                     RENAME(SECOBKD0:SECOBKD2)
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MA - SE Corporate Actions References - Rtv Idx
     FSECORFL9  IF   E           K DISK
     F                                     RENAME(SECORFD0:SECORFD1)
     F                                     INFSR(*PSSR)
      *
      **   Securities Details
     FSECTYZ1   IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   Market Prices
     FPRICM     IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   Investment Types Details
     FINVTP     IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   Security Events by Type
     FSECED     IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   MM - SE Corporate Actions Types
     FSECOATL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   MN - SE Option Narrative Code
     FSECONAL0  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   MA - SE Corporate Actions Reference Number
     FSECORFPA  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MB - SE Corporate Actions Depots - Rtv Idx
     FSECODPL1  IF   E           K DISK
     F                                     RENAME(SECODPD0:SECODPD1)
     F                                     INFSR(*PSSR)
      *
      **   SE Depot Positions by Security
     FDPOSS     IF   E           K DISK
     F                                     RENAME(DPOSNDF:DPOSSDF)
     F                                     INFSR(*PSSR)
      *
      **   MC - SE Corporate Actions Allocation - Rtv Idx
     FSECOALL1  IF   E           K DISK
     F                                     RENAME(SECOALD0:SECOALDU)
     F                                     INFSR(*PSSR)
      *
      **   MB - SE Corporate Actions Depots - Upd Idx
     FSECODPL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MS - SE Corporate Actions Depots Reference
     FSECODRL1  IF   E           K DISK
     F                                     RENAME(SECODRD0:SECODRD1)
     F                                     INFSR(*PSSR)
      *
      **   MC - SE Corporate Actions Allocation - Upd Idx
     FSECOALL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   Midas Corporate Actions - Depots Update index
     FSECODRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MD - SE Corporate Actions - Dividends Events
     FSECODVL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   ME - SE Corporate Actions - Free Allocations
     FSECOFRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MG - SE Corporate Actions - Capital Events
     FSECOCEL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MH - SE Corporate Actions - Merger
     FSECOCRL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MI - SE Corporate Actions - Exchange Offers
     FSECOOFL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MF - SE Corporate Actions - Rights Issues
     FSECORGL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MJ - SE Corporate Actions - Exercises and Conversions
     FSECOEXL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   MK - SE Corporate Actions - Non Financial Events
     FSECONFL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   ML - SE Corporate Actions - Name Changes
     FSECONCL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **   NA - SE Corporate Actions (EMU) - Currency Changes
     FSECOCCL0  UF A E           K DISK
     F                                     INFSR(*PSSR)
     F                                     COMMIT
      *
      **  NB - Securities Redenomination Bulk Details - Updt Index
     FSECORBL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      *
      **  NC - Securities Redenomination Bulk Securities - Updt
     FSECORSL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      *
      ** MJ - SE Corporate Actions - Exercises and Conversions,
      **      Linked Corporate Action Number.
      *
     FSECOEXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SECOEXD0:SECOEXD2)
      *
      **  Securities Corporate Actions - By parent Ref
     FSECORFLA  IF   E           K DISK
     F                                     INFSR(*PSSR)
      *
      **   Display file
     FSE7502NDF CF   E             WORKSTN INFDS(SCRDS)
     F                                     INFSR(*PSSR)
     F                                     SFILE(SE7502S0:#1RRN)
     D*****************************************************************
      /EJECT
     D********************************************************************
      *
      * ID F  C  H  L    Function of indicators
      * ---------------------------------------
      *
      *   KC : CMD  3 - End of program
      *   KE : CMD  5 - Reset Screen
      *   KI : CMD  9 - Go to 'Add' or 'Change' Mode
      *   KL : CMD 12 - Previous screen
      *
      *   LR :    Last record
      *   U7/U8 : Database error
      *
      *   06 : CGL031 Indicator                                                               CGL031
      *   07 : Reverse Image on 'Subject to European Tax'                                     CGL031
      *   13 : Reverse Image on 'Customer Last Reply Time'
      *   14 : Reverse Image on 'Depot    Last Reply Time'
      *   15 : LS=Final Allocation Stock
      *   16 : LY=Final Allocation Cash and Stock
      *   17 : S =Stock Authorised
      *   18 : X =Fully Authorised (Cash & Stock)
      *   20 : Reverse Image on 'Old Capital Value'
      *   21 : Reverse Image on 'New Capital Value'
      *   22 : Reverse Image on 'Old Nominal Value'
      *   23 : Reverse Image on 'New Nominal Value'
      *   24 : Reverse Image on 'Market Cum Price'
      *   26 : Number of options is 01
      *   27 : Rollup subfile
      *   28 : Error indicator (Subfile Field)
      *   29 : Error indicator
      *   30 : End of Subfile
      *   31 : Reverse Image on 'Market Ex Price'
      *   32 : Error indicator
      *   33 : Error indicator
      *   35 : Protect/Non-display fields for processing type 'CC'
      *   37 : Error indicator
      *   38 : Error indicator
      *   39 : Error indicator
      *
      *   40 : Confirm REVERSAL or DELETION
      *   41 : Confirm AUTHORISATION
      *   42 : Reverse Image on 'Block Security'
      *
      *   43 : 'AMEND' Mode if *ON
      *        'ADD  ' Mode if *OFF
      *   44 : Error indicator
      *   45 : "First" Time Processing
      *   46 : Command Key pressed
      *   47 : Confirmation Screen or 'Full Details' Screen
      *   48 : Protect 'Allocation Effective Date'
      *   49 : Reverse Image on 'Event Date'
      *
      *   50 : Error indicator (Position Field)
      *   51 : Error indicator
      *   52 : Error indicator
      *
      *   53 : Access by Security Shortname and Ex-date
      *   54 : Access by Ex-date and Security Shortname
      *   55 : Access by Reference Number
      *
      *   56 : Protect 'Position/Selection' Fields
      *   57 : Protect and non-display 'Action'
      *   58 : Protect Security Shortname', 'Action Type', 'Number of Options',
      *   59 : Protect 'Ex-date' field
      *
      *   60 : Reverse Image on 'Trade Date'
      *   61 : Enquiry Mode
      *   62 : Error indicator (Action)
      *   63 : Protect 'Ex-date' fields
      *   64 : Report Mode
      *   65 : Reverse Image on 'Payment Date'
      *   66 : Reverse Image on 'Trade/Value Date Position'
      *   67 : Reverse Image on 'Coupon Number'
      *   68 : Protect 'Final Allocation' field
      *   69 : Error indicator (Selection Field)
      *   70 : Reverse Image on 'ShareHolders Meeting Date'
      *   71 : Reverse Image on 'Letter to be Sent'
      *   72 : Reverse Image on 'Block Positions'
      *   73 : Reverse Image on 'Block From Date'
      *   74 : Reverse Image on 'Block To   Date'
      *   75 : Protect 'Date of Announcement'
      *   76 : Reverse Image on 'Refuse Offer'
      *   77 : Reverse Image on 'Customer Option Narrative Code'
      *   78 : Reverse Image on 'Default no Reply'
      *   79 : Reverse Image on 'Default for Cash Preferred'
      *
      *   80 : Display Subfile control
      *   81 : Display Subfile
      *   82 : Reverse Image on 'Default for Stock Preferred'
      *   83 : Reverse Image on 'Customer Last Reply Date'
      *   84 : Subfile Next Change
      *   85 : Reverse Image on 'Depot Last Reply Date'
      *
      *   87 : Read Change indicator
      *   88 : Working indicator
      *   89 : Working indicator
      *
      *   90-99 : Used by Standard Subroutines
      *   98 : Indicator used by subroutine ZDATE1
      *   99 : Indicator used by subroutine ZDATE1
      **************************************************************************
      /EJECT
      **************************************************************************
      *
      * Name of the Subroutines
      * -----------------------
      *
      *       P003  - Termination processing
      *
      *       P004  - Clear Subfile
      *       P005  - Build the subfile for Add Mode
      *       P006  - Build the subfile for Amend/Enquiry Mode
      *       P008  - Validate subfile records
      *       P008A - Validate 'Action' field
      *       P009  - Process 'Action'
      *       P010  - Process 'Confirmation' screen
      *       P011  - Process Writing Options with Default Information
      *       P014  - Initialise error indicators
      *       P015  - Clear Subfile Fields
      *       P016  - Load Subfile Fields
      *       P018  - Process 'Full details' screen
      *       P019  - Validate 'Full details' screen and update file
      *       P020  - Blocking Processing
      *       P021  - Retrieve Next Available Reference Number
      *       P022  - Apply Action to all Options
      *       P023  - View/Change Option(s)
      *       P024  - Verify if the Option Exists
      *       P025  - Check that no Position Exists on Depot Positions file
      *
      *       *PSSR - "Standard" Database error processing
      *
      * Name of the Standard Subroutines
      * --------------------------------
      *
      *       ZDATE1 - Validate and convert date to day number
      *       ZDATE2 - Format a Date for Screen Output
      *       ZALIGN - Validate/Right align numeric field
      *       ZSEDIT - Format Amount for Display
      *       ZASIGN - Validate/Right align signed numeric fields
      *       ZASNMS - Send Message to Program's message queue
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      **   STORE THE EIGHT GROUP EACH CUSTOMER IS ASSOCIATED
      *
     D TXT             S             78    DIM(11) CTDATA PERRCD(1)
      *
     D NARR            S             27    DIM(9) CTDATA PERRCD(1)
      *
     D NSAR            S             10    DIM(180)
     D                                     INZ(*BLANKS)
                                                                                              CGL031
      ** Access Object Parameters                                                             CGL031
     D PRetCde         S              7A                                                      CGL031
     D POption         S              7A                                                      CGL031
     D PSARD           S              6A                                                      CGL031
                                                                                              CGL031
      ** Switchable Features                                                                  CGL031
     D CGL031          S              1A                                                      CGL031
      ********************************************************************
      /EJECT
      ********************************************************************
      *
      ** Program Data Structure
      *
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      *
      ** File Information Data Structure
      *
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      ** File Record Data Structure
      *
     D FIELD         E DS                  EXTNAME(SECORFPD)
      *
     D SCRDS           DS
     D  DSPNUM               197    205
     D  CPFPOS               378    379B 0
      *
      ** Data Structure for Compilation - Copyright Insertion
      *
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
      ** Data Structure for Database Error
      *
     D LDA             DS           256
     D  WWLOT                132    183
     D  WWFILE               132    141
     D  WWKEY                142    170
     D  WWPGM                171    180
     D  WWASE                181    183  0
     D  PGMNAM               184    189
      *
     D DIGITS          C                   CONST('0123456789')
      *
     D CDDS            DS
     D  CD01                   1      4  0
     D  CD02                   5      8  0
     D  CD03                   9     12  0
     D  CD04                  13     16  0
     D  CD05                  17     20  0
     D  CD06                  21     24  0
     D  CD07                  25     28  0
     D  CD08                  29     32  0
     D  CD09                  33     36  0
     D  CD10                  37     40  0
     D  CD11                  41     44  0
     D  CD12                  45     48  0
     D  CD                     1     48  0
     D                                     DIM(12)                              CD01-12 ARRAY
     D CRDS            DS
     D  CR01                   1      1
     D  CR02                   2      2
     D  CR03                   3      3
     D  CR04                   4      4
     D  CR05                   5      5
     D  CR06                   6      6
     D  CR07                   7      7
     D  CR08                   8      8
     D  CR09                   9      9
     D  CR10                  10     10
     D  CR11                  11     11
     D  CR12                  12     12
     D  CR                     1     12
     D                                     DIM(12)                              CR01-12 ARRAY
     D LOCKDS          DS
     D  WUSER                  1     10
     D  WJOBN                 11     20
      *
     D ZMUSER          DS            17
      ** Data area ZMUSER
     D  BVBRCD                11     13
      *
      ** Data structure used to send data to message ID CO00600:
      ** Linked Corporate Action Number and Processing Type.
      *
     D REFLIN          DS
     D  WWLNKR                 1      6
     D  WWPTYP                 7      8
     D RUNDAT        E DS
      **  Standard Data Area Layout for System flags and Run Date
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      **  Data structure for bank details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      **  Data structure for branch details
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  Data structure for securities trading details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL031
      **  Data structure for switchable feature details                                       CGL031
      *                                                                                       CGL031
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CGL031
      **  Short data structure for access objects                                             CGL031
      *                                                                                       CGL031
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access objects
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
      *
      ** Parameters for ZDATE2
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
      *
      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
      *
      ** Parameters for ZASIGN
     D ZAsignOk        S              1A
     D ZFLD17          S             17A
     D ZSDIG           S              2P 0
     D ZSDEC           S              1P 0
     D ZSDCSP          S              1A
     D ZOUT15          S             15A
     D ZFSIGN          S              1A
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      **    P R O G R A M   S T A R T
      ********************************************************************
      *
     C                   MOVE      P#REFN        #PREF
     C                   MOVE      '1'           *IN10
     C                   MOVE      '1'           *IN45
     C                   MOVE      '0'           *IN53
     C                   MOVE      '0'           *IN54
     C                   MOVE      '0'           *IN55
      *
     C     P#SEL         IFEQ      'F'
     C                   MOVEA     TXT(11)       ##CTX1
     C                   MOVE      '0'           *IN25
     C                   MOVE      '1'           *IN61
     C                   ELSE
     C                   MOVEA     TXT(9)        ##CTX1
     C                   MOVE      '1'           *IN25
     C                   ENDIF
      *
      ** While F3 and F12 not pressed
      *
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C     WIN12         OREQ      '1'
      *
     C                   MOVE      '0'           WIN12
      *
      ** If it's the first time processing or F5 is pressed
      *
     C     WIN45         IFEQ      '0'
     C     *INKE         OREQ      '1'
      *
     C     *IN43         IFEQ      '1'
     C     *IN61         ANDEQ     '0'
     C     *IN61         OREQ      '1'
      *
     C                   MOVE      '0'           *IN84
     C                   MOVE      '0'           *IN47
     C                   MOVE      '0'           WIN45
     C     *IN61         IFEQ      '0'
     C                   MOVE      '0'           *IN57
     C                   MOVE      '1'           *IN58
     C                   ENDIF
     C                   EXSR      P004
      *
     C                   EXSR      P014
     C                   EXSR      P006
      *
     C                   ELSE
      *
      ** for add mode, Build a blank subfile page
      *
     C                   EXSR      P004
      *
     C                   MOVE      '1'           *IN57
     C                   MOVE      '0'           *IN58
     C                   MOVE      '1'           *IN48
      *
     C                   EXSR      P014
     C                   EXSR      P005
     C                   MOVE      P#REFN        MAPREF
     C                   MOVEA     TXT(10)       ##CTX1
     C                   Z-ADD     1             #1RRN
      *
     C                   ENDIF
     C                   MOVE      '1'           WIN45
     C                   ENDIF
      *
      ** If CMD9 is Pressed
      *
     C     *IN09         IFEQ      '1'
      *
      ** Check if user is authorised to action 'Insert'
      *
     C     AGMBIN        IFNE      'Y'
      *
      ** If single branch environment
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'I'           WLACTN            1
     C                   PARM      *ZERO         WLERR             1 0
      *
     C     WLERR         IFNE      *ZERO
     C                   MOVEL     'CO00034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If multibranching environment
      *
     C                   CALL      'ZVACTBU'
     C                   PARM      'I'           WLACTN            1
     C                   PARM      BVBRCD        WLBRCH            3
     C                   PARM      *ZERO         WLERR             1 0
      *
     C     WLERR         IFEQ      1
     C                   MOVEL     'CO00035'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WLERR         IFEQ      2
     C                   MOVEL     'CO00036'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WLERR         IFEQ      *ZERO
      *
      ** If it's the 'AMEND' mode, build a blank subfile
      *
     C     *IN43         IFEQ      '1'
      *
      ** Initialise error indicators
      *
     C                   EXSR      P014
      *
      ** Clear subfile
      *
     C                   EXSR      P004
     C                   MOVEA     TXT(10)       ##CTX1
      *
      ** Protect/Non-Display 'Action', 'Last/Final Allocation', 'Status' *ON
      ** Protect on 'Security Short.', 'Action Type', 'Number of Options' *OFF
      *
     C                   MOVE      '1'           *IN57
     C                   MOVE      '0'           *IN58
      *
     C                   MOVE      '0'           *IN30
     C                   MOVE      '0'           *IN59
     C                   MOVE      '0'           *IN63
     C                   MOVE      '0'           *IN68
     C                   MOVE      '1'           *IN48
     C                   MOVE      '0'           *IN75
      *
      ** Build a blank subfile
      *
     C                   EXSR      P005
     C                   Z-ADD     1             #1RRN
     C                   MOVE      '0'           *IN43
     C                   ELSE
      *
      ** Clear subfile
      *
     C                   EXSR      P004
      *
      ** Initialise error indicators
      *
     C                   EXSR      P014
      *
      ** If it's the 'ADD' mode, build a first subfile page
      ** (beginning at first inserted record)
      *
     C                   MOVEA     TXT(9)        ##CTX1
      *
     C                   MOVE      '0'           *IN57
     C                   MOVE      '1'           *IN58
     C                   MOVE      '0'           WIN45
      *
      ** Build the first subfile page
      *
     C                   EXSR      P006
     C                   MOVE      '1'           WIN45
     C                   MOVE      '1'           *IN43
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If Rollup is pressed
      *
     C     *IN27         IFEQ      '1'
     C                   Z-ADD     WWRRN         #1RRN
      *
      ** Reinitialise error indicators
      *
     C                   EXSR      P014
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** If it's the 'ADD' mode only
      *
     C     *IN43         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
      *
      ** Build a blank subfile page
      *
     C                   EXSR      P005
      *
      ** If it's the 'AMEND' mode or the 'ENQUIRY' mode
      *
     C                   ELSE
      *
      ** Set key fields with blanks or zeros
      *
     C                   MOVE      *BLANKS       KREFN
     C                   MOVE      *BLANKS       KSECN
     C                   Z-ADD     *ZEROS        KEXDT
      *
      ** Build the next subfile page
      *
     C                   EXSR      P006
     C                   ENDIF
     C                   ENDIF
      *
      ** Execute the Subfile Control Record
      *
     C                   TIME                    ##TME
     C                   WRITE     #MSGCTL
     C                   WRITE     SE7502F1
     C                   EXFMT     SE7502C0
      *
      ** Clear messages frpm program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C     *INKC         IFEQ      *ON
     C                   MOVE      '3'           P#RTCD
     C                   ENDIF
      *
      ** IF F12
      *
     C     *INKL         IFEQ      *ON
     C     WRBLD         IFEQ      'Y'
     C                   MOVE      '1'           P#RTCD
     C                   ELSE
     C                   MOVE      '2'           P#RTCD
     C                   ENDIF
     C                   ENDIF
      *
      ** If no function key is pressed and all position/selection
      ** fields unchanged, validate all subfile records
      *
     C     *IN46         IFEQ      '0'
     C     WWCPT         ANDNE     *ZEROS
      *
      ** Reinitialize Error indicators
      *
     C                   EXSR      P014
      *
     C                   EXSR      P008
     C                   ENDIF
     C                   ENDDO
      *
      ** Termination Processing
      *
     C                   EXSR      P003
      *
      *****************************************************************
      **    P R O G R A M     E N D
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR : Initial Processing                                   *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Entry Parameter
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#REFN            6
     C                   PARM                    P#COEX            5 0
     C                   PARM                    P#ACTN            1
     C                   PARM                    P#SESN           10
     C                   PARM                    P#STAT            1
     C                   PARM                    P#FINA            1
     C                   PARM                    P#SEL             1
     C                   PARM                    P#PTYP            2
     C                   PARM                    P#RTCD            1
      *
      ** Copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
     C                   MOVE      '0'           WIN45             1
      *
      ** Read in DTAARA/RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Read in DTAARA/ZMUSER
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Set up Key Fields
      *
     C     KEY1          KLIST
     C                   KFLD                    KSECN            10
     C                   KFLD                    KEXDT             5 0
     C                   KFLD                    KREFN             6
      *
     C     KEY2          KLIST
     C                   KFLD                    KEXDT
     C                   KFLD                    KSECN
     C                   KFLD                    KREFN
      *
     C     KEY3          KLIST
     C                   KFLD                    KNMCY
     C                   KFLD                    KSITP
      *
     C     KEY4          KLIST
     C                   KFLD                    KSECN
     C                   KFLD                    KEXDT
      *
     C     KEY5          KLIST
     C                   KFLD                    KSECN            10
     C                   KFLD                    KEXDT             5 0
     C                   KFLD                    KTYPE             2
      *
     C     KEY6          KLIST
     C                   KFLD                    KCORF             6
     C                   KFLD                    KOPTN             2 0
      *
     C     KEY7          KLIST
     C                   KFLD                    KSECN
     C                   KFLD                    KEXDT
      *
      ** Initialise key and work fields
      *
     C                   MOVE      *BLANKS       WWLOT
     C                   MOVEL     'SE7502'      DBPGM            10
      *
     C                   Z-ADD     0             WWRRN             4 0
      *
      ** Setup screen time
      *
     C                   TIME                    ##TME             6 0          Screen time.
      *
      ** Access to bank details to retrieve the midas rundate
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       WLRTCD            7
     C                   PARM      '*FIRST'      WLOPTN            7
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** If record not found
      *
     C     WLRTCD        IFNE      *BLANKS
     C                   MOVEL     '001'         DBASE             3 0          *****************
     C                   MOVE      'SDBANKPD'    DBFILE           10            * DB ERROR 01   *
     C                   MOVEL     *BLANKS       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      BJMRDT        ##MRDT                         Midas Run date
      *
      ** Determine date format
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   ENDIF
      *
      ** Access to SE Trading data to retrieve the back value period
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       WLRTCD
     C                   PARM      '*FIRST'      WLOPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** If record is not found
      *
     C     WLRTCD        IFNE      *BLANKS
     C                   MOVEL     '002'         DBASE                          *****************
     C                   MOVE      'SDSTRDPD'    DBFILE                         * DB ERROR 02   *
     C                   MOVEL     *BLANKS       DBKEY                          *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Calculate Retention Periods
      *
     C                   Z-ADD     *ZEROS        WK3N              3 0
     C     31            MULT      BVROPS        WK3N
     C     BJRDNB        SUB       WK3N          RTNPOS            5 0
      *
     C                   Z-ADD     *ZEROS        WK3N
     C     31            MULT      BVROST        WK3N
     C     BJRDNB        SUB       WK3N          RTNTRD            5 0
      *
      ** Access SDBRCHPD using the default user branch
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       WLRTCD
     C                   PARM      '*KEY   '     WLOPTN
     C                   PARM      BVBRCD        WLBRCH            3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Check if error occurred
      *
     C     WLRTCD        IFNE      *BLANKS
     C                   MOVEL     '003'         DBASE                          *****************
     C                   MOVE      'SDBRCHPD'    DBFILE                         * DB ERROR 03   *
     C                   MOVEL     *BLANKS       DBKEY                          *****************
     C                   MOVEL     BVBRCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CGL031
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRetCde                                      CGL031
     C                   PARM      '*VERIFY'     POption                                      CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
     C                   EVAL      *IN60 = *OFF                                               CGL031
                                                                                              CGL031
     C                   IF        PRetCde = *BLANKS                                          CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   EVAL      *IN06 = *ON                                                CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRetCde <> *BLANKS                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Calculate the SE Backvalue date
      *
     C     BJRDNB        SUB       BVBVP         WBACKD            5 0
      *
      ** If the 'ACTION' parameter is equal to 'E' or 'R'
      ** Seton indicator for Enquiry mode or Report mode
      *
     C     P#ACTN        IFEQ      'E'
     C     P#ACTN        OREQ      'R'
     C                   MOVE      '1'           *IN61
     C                   MOVEA     TXT(1)        ##CTX1
      *
     C     P#ACTN        IFEQ      'R'
     C                   MOVE      '1'           *IN64
     C                   ENDIF
     C                   ENDIF
      *
      ** If the 'ACTION' Parameter is equal to 'A'
      ** Seton indicator for 'UPDATE' Mode
      *
     C     P#ACTN        IFEQ      'A'
      *
      ** Access the ER References file to see if there is record in the file
      *
     C     P#REFN        SETLL     SECORFLA
     C     P#REFN        READE     SECORFLA                               89
      *
      ** If record is not found, seton the indicator of 'ADD MODE'
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      '0'           *IN43
     C                   MOVEA     TXT(10)       ##CTX1
      *
      ** If record is not found, seton the indicator of 'AMEND MODE'
      *
     C                   ELSE
     C                   MOVE      '1'           *IN43
     C                   MOVEA     TXT(9)        ##CTX1
     C                   ENDIF
     C                   ENDIF
      *
      ** Only to declare the file in 'ADD' mode
      *
     C     *IN99         IFEQ      '0'
     C     *IN99         ANDEQ     '1'
     C                   WRITE     SECODRD0
     C                   WRITE     SECODPD0
     C                   WRITE     SECOALD0
     C                   WRITE     SECORED0
     C                   WRITE     SECORHD0
     C                   ENDIF
      *
      ** Retrieve next Reference Number
      *
     C     *LOVAL        SETLL     SECORFPA
     C                   READ(N)   SECORFPA                               89
      *
      ** If record not found
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      'D'           MXRECI
     C                   Z-ADD     BJRDNB        MXLCD
     C                   MOVE      'I'           MXCHTP
     C                   MOVE      ##USR         MXLUID
     C                   MOVE      '000001'      MXCORF
     C                   WRITE     SECORFP0
     C                   ENDIF
      *
     C                   MOVE      MXCORF        WWCORF            6 0
     C                   MOVE      MXCORF        W1CORF            6 0
      *
      ** Select the program msgq for error msg
      *
     C                   MOVEL     '*'           TOPQ             10
     C                   MOVEL     '*PRV'        TOPRQ             5
     C                   MOVEL     'SEUSRMSG'    PMSGF            10
      *
      ** Fill in fields for subroutine ZASNMS
      *
     C                   MOVEL     'SE7502'      ZAPGM            10            Message queue
     C                   MOVEL     'SEUSRMSG'    ZAMSGF           10            Message file
     C                   MOVEL     *BLANK        ZAPGRL            5            Rel queue
     C                   MOVEL     *BLANK        ZAMSID            7            Message Id.
     C                   MOVEL     *BLANK        ZAMSDA          132            Message data.
     C                   MOVEL     *BLANK        ZAMSTP            7            Message type.
     C                   MOVE      '0'           WIN12
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   WRITE     #MSGCTL
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P003   : Termination Processing                               *
      *****************************************************************
      *
     C     P003          BEGSR
      *
      ** Rollback uncommited changes
      *
     C                   ROLBK
      *
      ** End of program
      *
     C                   MOVE      '1'           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P004  - To clear the subfile                                  *
      *****************************************************************
     C     P004          BEGSR
      *
      ** Clear subfile
      *
     C                   MOVE      '1'           *IN80
     C                   WRITE     SE7502C0
     C                   MOVE      '0'           *IN80
     C                   MOVE      '0'           *IN81
     C                   Z-ADD     0             #1RRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P005   : Build the subfile for add mode                       *
      *****************************************************************
      *
     C     P005          BEGSR
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** Load a Blank Subfile Page
      *
     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
      *
      ** Init screen line number
      *
     C                   Z-ADD     0             WWCPT             2 0
      *
      ** Load subfile
      *
     C     WWCPT         DOWLT     15
      *
     C                   ADD       1             #1RRN                81        SFLRCDNBR
     C                   ADD       1             WWCPT                          SCREEN LINE NBR
      *
      ** Clear sfl fields
      *
     C                   EXSR      P015
      *
      ** Add record in subfile
      *
     C                   WRITE     SE7502S0
     C                   ENDDO
      *
      ** Save position
      *
     C                   Z-ADD     #1RRN         WWRRN                          Save Sfl.Rcd.Nbr.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P006   : Build the Subfile for Amend/Enquiry Mode             *
      *****************************************************************
      *
     C     P006          BEGSR
      *
     C                   MOVE      '0'           *IN84                          No SFLNXTCHG
      *
     C     *IN27         IFEQ      '1'
     C     *IN43         ANDEQ     '1'
     C     *IN27         OREQ      '1'
     C     *IN61         ANDEQ     '1'
      *
     C     #1RRN         CHAIN     SE7502S0                           88
     C                   MOVE      #1REFN        KREFN
     C                   MOVE      #1SECN        KSECN
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      KEXDT
      *
     C                   ENDIF
      *
     C     P#REFN        SETLL     SECORFLA
     C     P#REFN        READE     SECORFLA                               30
      *
     C                   Z-ADD     0             WWCPT             2 0
     C     *IN30         DOWEQ     '0'
     C     WWCPT         ANDLT     15
      *
      ** Retrieve the "higher" status and final allocation indicator
      *
     C                   MOVE      *BLANKS       #1STAT
     C                   MOVE      *BLANKS       #1FINA
     C                   MOVE      'Y'           WFIRST            1
      *
     C     MACORF        SETLL     SECODRL1
     C     MACORF        READE     SECODRL1                               89
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      MASTAT        #1STAT
     C                   ENDIF
      *
     C     *IN89         DOWEQ     '0'
      *
     C     MSRECI        IFEQ      'D'
      *
     C     WFIRST        IFEQ      'Y'
     C                   MOVE      MSFAID        #1FINA
     C                   MOVE      MSCOST        #1STAT
     C                   MOVE      'N'           WFIRST
     C                   ELSE
      *
      ** Retrieve the "higher" final allocation indicator
      *
     C     MSFAID        IFEQ      'Y'
     C                   MOVE      MSFAID        #1FINA
     C                   ELSE
     C     MSFAID        IFEQ      'S'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      MSFAID        #1FINA
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve the "higher" Status
      *
     C     MSCOST        IFEQ      'C'
     C                   MOVE      MSCOST        #1STAT
     C                   ELSE
     C     MSCOST        IFEQ      'X'
     C     #1STAT        IFEQ      'S'
     C     #1STAT        OREQ      'L'
     C     #1STAT        OREQ      'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF
     C                   ENDIF
      *
     C     MSCOST        IFEQ      'S'
     C     #1STAT        IFEQ      'L'
     C     #1STAT        OREQ      'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF
     C                   ENDIF
      *
     C     MSCOST        IFEQ      'L'
     C     #1STAT        ANDEQ     'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     MACORF        READE     SECODRL1                               89
     C                   ENDDO
      *
     C     #1FINA        IFEQ      *BLANKS
     C     #1STAT        ANDEQ     *BLANKS
     C                   MOVE      'N'           #1FINA
     C                   MOVE      'I'           #1STAT
     C                   ENDIF
      *
      ** If Amend mode and Cmd 9 not pressed
      ** or if add Mode and Cmd 9 pressed
      *
     C     *IN43         IFEQ      '1'
     C     *IN09         ANDEQ     '0'
     C     *IN43         OREQ      '0'
     C     *IN09         ANDEQ     '1'
      *
      ** If 'Lockec bu User Identifier' is not blank
      **     protect all subfile record fields
      *
     C     MAUSER        IFNE      *BLANKS
     C                   MOVE      '1'           *IN63
     C                   ELSE
     C                   MOVE      '0'           *IN63
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is 'I' or 'L' and Final Indicator 'N  '
      **     non-protect 'EX-DATE' subfile field
      *
     C     #1STAT        IFEQ      'I'
     C     #1STAT        OREQ      'L'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      '0'           *IN59
     C                   ELSE
     C                   MOVE      '1'           *IN59
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is equal to S/X/C/R, protect
      ** Allocation
      *
     C     #1STAT        IFEQ      'S'
     C     #1STAT        OREQ      'X'
     C     #1STAT        OREQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '0'           *IN48
     C                   ELSE
     C                   MOVE      '1'           *IN48
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is 'C' or 'R', Protect Date
      ** of Announcement
      *
     C     #1STAT        IFEQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN75
     C                   ELSE
     C                   MOVE      '0'           *IN75
     C                   ENDIF
      *
     C                   ADD       1             WWCPT                          Screen Line Nbr
     C                   ADD       1             #1RRN                81        SFLRCDNBR
     C                   EXSR      P015
     C                   EXSR      P016
     C                   WRITE     SE7502S0
     C     MAPREF        READE     SECORFLA                               30
     C                   ENDDO
      *
      ** Save Position
      *
     C                   Z-ADD     #1RRN         WWRRN                          Save Sfl.Rcd.Nbr.
      *
      ** If it's not a rollup
      *
     C     *IN27         IFEQ      '0'
     C                   Z-ADD     1             #1RRN
     C                   ENDIF
      *
      ** If no records found, display error message
      ** Send message 'NO DATA TO DISPLAY'
      *
     C     WWCPT         IFEQ      *ZEROS
     C                   MOVEL     'CO00001'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P008   : Validate Subfile Records                             *
      *****************************************************************
      *
     C     P008          BEGSR
      *
     C                   MOVE      'N'           ERMSG             1
     C                   MOVE      'N'           WRBLD
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** Read changed subfile record
      *
     C                   READC     SE7502S0                               87
      *
      ** Setup the RRN with the current CPF's Position within the subfile
      *
     C     *IN87         IFEQ      '1'
     C                   Z-ADD     CPFPOS        #1RRN
     C                   ENDIF
      *
      ** Do while end of file is not reached and F12 or F3 not pressed
      *
     C     *IN87         DOWEQ     '0'
     C     *INKC         ANDEQ     '0'
     C     *INKL         ANDEQ     '0'
      *
      ** Reinitialize error indicators
      *
     C                   EXSR      P014
      *
     C                   MOVE      '1'           *IN84                          SFLNXTCHG
      *
      ** If 'ADD MODE'
      *
     C     *IN43         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
      *
      ** If at least one field is different than blanks
      *
     C     #1SECN        IFNE      *BLANKS
     C     #1COAT        ORNE      *BLANKS
     C     #1COAN        ORNE      *BLANKS
     C     #1EXDT        ORNE      *BLANKS
     C     #1ALEF        ORNE      *BLANKS
     C     #1NBOP        ORNE      *BLANKS
      *
      ** If 'SECURITY SHORTNAME' left blank
      *
     C     #1SECN        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00005'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
      ** Check Security shortname
      ** Access Security details with current security shortname
      *
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      ** If record is not found or is found byt not "Live"
      *
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00007'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
      ** For Corporate Action with processing type 'DV'
      *
     C     MMPTYP        IFEQ      'DV'
      *
      ** Access Investment Type file
      *
     C                   MOVE      NMCY          KNMCY             3
     C                   MOVE      SITP          KSITP             3
      *
     C     KEY3          CHAIN     INVTP                              89
      *
      ** If no record found
      *
     C     *IN89         IFEQ      '1'
     C                   MOVEL     NMCY          WFLD1             6
     C                   MOVE      SITP          WFLD1
     C                   MOVEL     '004'         DBASE                          *****************
     C                   MOVE      'INVTP   '    DBFILE                         * DB ERROR 04   *
     C                   MOVEL     WFLD1         DBKEY                          *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Processing type must be '4' or '7'
      *
     C     PROT          IFNE      '4'
     C     PROT          ANDNE     '7'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00012'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate security of the child if its equal to new security
      ** of the parent
      *
      *
     C                   Z-ADD     1             X                 2 0
     C                   SELECT
     C                   WHEN      P#PTYP = 'DV'
     C     P#REFN        SETLL     SECODVL0
     C     P#REFN        READE     SECODVL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     MDNSEC        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     MDNSEC        NSAR(X)
     C                   ENDIF
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECODVL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'FR'
     C     P#REFN        SETLL     SECOFRL0
     C     P#REFN        READE     SECOFRL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     MENSEC        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     MENSEC        NSAR(X)
     C                   ENDIF
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECOFRL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'CR'
     C     P#REFN        SETLL     SECOCRL0
     C     P#REFN        READE     SECOCRL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     MHSECA        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     MHSECA        NSAR(X)
     C                   ENDIF
     C                   ADD       20            X
      *
     C     P#REFN        READE     SECOCRL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'OF'
     C     P#REFN        SETLL     SECOOFL0
     C     P#REFN        READE     SECOOFL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     MINSEC        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     MINSEC        NSAR(X)
     C                   ENDIF
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECOOFL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'RG'
     C     P#REFN        SETLL     SECORGL0
     C     P#REFN        READE     SECORGL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     MFNSEC        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     MFNSEC        NSAR(X)
     C                   ENDIF
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECORGL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'EX'
     C     P#REFN        SETLL     SECOEXL0
     C     P#REFN        READE     SECOEXL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     MJNSEC        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     MJNSEC        NSAR(X)
     C                   ENDIF
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECOEXL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'CC'
     C     P#REFN        SETLL     SECOCCL0
     C     P#REFN        READE     SECOCCL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C     NANSEC        IFEQ      *BLANKS
     C                   MOVEA     P#SESN        NSAR(X)
     C                   ELSE
     C                   MOVEA     NANSEC        NSAR(X)
     C                   ENDIF
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECOCCL0                               89
     C                   ENDDO
      *
     C                   WHEN      P#PTYP = 'NC'
     C     P#REFN        SETLL     SECONCL0
     C     P#REFN        READE     SECONCL0                               89
     C     *IN89         DOWEQ     '0'
      *
      ** Security should be equal to new security of the parent. If new
      ** security is blanks, then use the old security of the parent
      *
     C                   MOVEA     MLSESN        NSAR(X)
     C                   ADD       1             X
      *
     C     P#REFN        READE     SECONCL0                               89
     C                   ENDDO
      *
     C                   ENDSL
      *
      ** Validate security of the child such that it is equal to
      ** new security of the parent
      *
     C     #1SECN        LOOKUP    NSAR                                   89
     C     *IN89         IFEQ      '0'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN39
     C                   MOVEL     'CO00367'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
 
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Action type' Left Blank
      *
     C     #1COAT        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
      ** Corporate action type must be a live action type
      *
     C     #1COAT        CHAIN     SECOATL0                           89
      *
     C     *IN89         IFEQ      '1'
     C     MMRECI        ORNE      'D'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVEL     'CO00009'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
     C     *IN89         IFEQ      '0'
     C     MMPTYP        ANDEQ     'CC'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVEL     'CO00577'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** Validation 'Number of Option'
      *
     C     #1NBOP        IFNE      *BLANKS
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     #1NBOP        ZFIELD
     C                   Z-ADD     2             ZADIG
     C                   Z-ADD     0             ZADEC
      *
     C                   EXSR      ZALIGN
      *
     C                   MOVE      ZFIELD        #1NBOP
     C                   MOVE      #1NBOP        W1NBOP
      *
      ** If it's not a valid numeric field between 1 and 9
      *
     C     ZALIGNok      IFEQ      'N'
     C     W1NBOP        ORLT      1
     C     W1NBOP        ORGT      9
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVEL     'CO00042'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C     MMPTYP        IFEQ      'NF'
     C     W1NBOP        ANDNE     1
     C     MMPTYP        OREQ      'NC'
     C     W1NBOP        ANDNE     1
     C     MMPTYP        OREQ      'CC'
     C     W1NBOP        ANDNE     1
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVEL     'CO00261'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVE      '01'          #1NBOP
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If not enquiry mode
      *
     C     *IN61         IFEQ      '0'
      *
      ** If at least one field is different than blank
      *
     C     #1EXDT        IFNE      *BLANKS
     C     #1REFN        ORNE      *BLANKS
     C     #1SECN        ORNE      *BLANKS
     C     #1ALEF        ORNE      *BLANKS
     C     #1COAN        ORNE      *BLANKS
      *
      ** If last allocation date is changed
      *
     C     #1COAN        IFNE      #2COAN
     C     #1COAN        ANDNE     *BLANKS
      *
     C                   MOVE      #1COAN        DateIn
     C                   EXSR      ZDATE1
      *
      ** If date of announcement is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVEL     'CO00033'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** If Ex-date is changed
      *
     C     #1EXDT        IFNE      #2EXDT
     C     #1EXDT        ANDNE     *BLANKS
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
      *
      ** If Ex-date is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00006'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WEXDT
      *
      ** If Ex-date lower or equal than SE Back Value date
      *
     C     WEXDT         IFLE      WBACKD
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00013'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If Ex-date not lower than security maturity date
      *
     C     WEXDT         IFGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00014'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** Validate Ex-date so that it is equal to that of the Parent
      *
     C     WEXDT         IFNE      P#COEX
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32
     C                   MOVEL     'CO00368'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C     P#COEX        IFNE      *ZEROS
     C     #1EXDT        ANDEQ     *BLANKS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32
     C                   MOVEL     'CO00368'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** If Allocation Effective Date is changed
      *
     C     #1ALEF        IFNE      #2ALEF
     C     #1ALEF        ANDNE     *BLANKS
      *
      ** If 'Allocation Effective Date' entered
      *
     C                   MOVE      #1ALEF        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      WALEF
      *
      ** If Allocation Effective Date is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVEL     'CO00041'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
     C     WALEF         IFLT      WEXDT
     C     *IN99         ANDEQ     '0'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVEL     'CO00251'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If Date not lower than Security Maturity Date
      *
     C     WALEF         IFGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVEL     'CO00300'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Amend Mode' or 'Enquiry' Mode
      *
     C     *IN43         IFEQ      '1'
     C     *IN61         OREQ      '1'
      *
      ** If Action indicator is changed
      *
     C     #1SEL         IFNE      *BLANKS
     C                   EXSR      P008A
     C                   ENDIF
      *
      ** Process Action (Only Enquiry Mode)
      *
     C     ERMSG         IFEQ      'N'
     C     *IN61         ANDEQ     '1'
     C                   EXSR      P009
     C                   MOVE      '0'           *IN84
     C                   ENDIF
     C                   ENDIF
      *
      ** If an error message is sent or if 'Add Mode'
      *
     C     ERMSG         IFEQ      'Y'
     C     *IN43         OREQ      '0'
      *
      ** If 'Corporate Action Status' is 'I' or 'L' and Final Indicator 'N  '
      **     Non-protect 'Ex-Date' subfile field (Amend Mode)
      *
     C     *IN43         IFEQ      '1'
      *
     C     #1STAT        IFEQ      'I'
     C     #1STAT        OREQ      'L'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      '0'           *IN59
     C                   ELSE
     C                   MOVE      '1'           *IN59
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is equal to S/X/C/R, protect Allocation
      *
     C     #1STAT        IFEQ      'S'
     C     #1STAT        OREQ      'X'
     C     #1STAT        OREQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '0'           *IN48
     C                   ELSE
     C                   MOVE      '1'           *IN48
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is 'C' or 'R', protect
      ** Date of Announcement
      *
     C     #1STAT        IFEQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN75
     C                   ELSE
     C                   MOVE      '0'           *IN75
     C                   ENDIF
      *
      ** If 'Locked by User Identifier' is not blank protect all
      ** Subfile record fields
      *
     C     #1REFN        CHAIN     SECORFL9                           89
      *
     C     MAUSER        IFNE      *BLANKS
     C                   MOVE      '1'           *IN63
     C                   ELSE
     C                   MOVE      '0'           *IN63
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update subfile record (for reversed error fields)
      *
     C                   UPDATE    SE7502S0
      *
      ** Goto next read of the subfile changing
      *
     C                   GOTO      TAG4
     C                   ENDIF
      *
      ** If 'Amend Mode'
      *
     C     *IN43         IFEQ      '1'
      *
      ** if Date of Announcement, Ex-Date, Final Indicator, Status or
      ** Allocation Effective Date is/are changed
      *
     C     #1COAN        IFNE      #2COAN
     C     #1EXDT        ORNE      #2EXDT
     C     #1ALEF        ORNE      #2ALEF
      *
      ** Access Corporate Action Reference file with current reference
      *
     C     #1REFN        CHAIN     SECORFL0                           89
      *
      ** If record is different than read at changing of subfile
      *
     C     FIELD         IFNE      #FIELD
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
      *
      ** Update subfile record (For reversed error fields)
      *
     C                   UPDATE    SE7502S0
      *
      ** Release the record
      *
     C     #1REFN        SETLL     SECORFL0
      *
      ** Goto next read of the subfile changing
      *
     C                   GOTO      TAG4
     C                   ELSE
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
      *
      ** If Date of Announcement changed
      *
     C     #1COAN        IFNE      #2COAN
      *
     C                   MOVE      #1COAN        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MACOAN
     C                   MOVE      #1COAN        #2COAN
      *
     C                   ENDIF
      *
      ** If Ex-Date Changed
      *
     C     #1EXDT        IFNE      #2EXDT
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MACOEX
      *
     C                   MOVE      #1EXDT        #2EXDT
      *
     C                   ENDIF
      *
      ** If Allocation Effective Date Changed
      *
     C     #1ALEF        IFNE      #2ALEF
      *
     C                   MOVE      #1ALEF        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MAALEF
     C                   MOVE      #1ALEF        #2ALEF
     C                   ENDIF
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      'Y'           WRBLD
     C                   MOVE      MAJOBN        WAJOBN           10
     C                   MOVE      MAUSER        WAUSER           10
     C                   Z-ADD     MAJNBR        WAJNBR            6 0
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      WAJOBN        MAJOBN
     C                   MOVE      WAUSER        MAUSER
     C                   Z-ADD     WAJNBR        MAJNBR
     C                   ENDIF
     C                   ENDIF
      *
      ** Execute Commitment Control
      *
     C                   COMMIT
      *
      ** If Action is changed
      *
     C     #1SEL         IFNE      #2SEL
      *
      ** Access Corporate Action Reference with Current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           89
      *
      ** If Record is different than read at changing of subfile
      *
     C     FIELD         IFNE      #FIELD
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00003'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
      *
      ** Update subfile record (For Reversed error fields)
      *
     C                   UPDATE    SE7502S0
      *
      ** Release the record
      *
     C     #1REFN        SETLL     SECORFL0
      *
      ** Goto next read of the subfile changing
      *
     C                   GOTO      TAG4
     C                   ELSE
      *
     C                   MOVE      ##JOB         MAJOBN
     C                   MOVE      ##USR         MAUSER
     C                   Z-ADD     ##JNO         MAJNBR
      *
      ** Update the record in Corporate Action Reference file
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      MAJOBN        WAJOBN           10
     C                   MOVE      MAUSER        WAUSER           10
     C                   Z-ADD     MAJNBR        WAJNBR            6 0
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      WAJOBN        MAJOBN
     C                   MOVE      WAUSER        MAUSER
     C                   Z-ADD     WAJNBR        MAJNBR
      *
      ** Execute the commitment instruction
      *
     C                   COMMIT
      *
      ** Process Action
      *
     C                   EXSR      P009
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is 'I' or 'L' and final ind. 'N'
      ** Non-protect 'Ex-Date' Subfile field (Amend Mode)
      *
     C     #1STAT        IFEQ      'I'
     C     #1STAT        OREQ      'L'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      '0'           *IN59
     C                   ELSE
     C                   MOVE      '1'           *IN59
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is equal to S/X/C/R, protect
      ** Allocation
      *
     C     #1STAT        IFEQ      'S'
     C     #1STAT        OREQ      'X'
     C     #1STAT        OREQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '0'           *IN48
     C                   ELSE
     C                   MOVE      '1'           *IN48
     C                   ENDIF
      *
      ** If 'Corporate Action Status' is 'C' or 'R', protect Date
      ** of Announcement
      *
     C     #1STAT        IFEQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN75
     C                   ELSE
     C                   MOVE      '0'           *IN75
     C                   ENDIF
      *
      ** If 'Locked by User Identifier' is not blank, protect all
      ** Subfile record fields
      *
     C     MAUSER        IFNE      *BLANKS
     C                   MOVE      '1'           *IN63
     C                   ELSE
     C                   MOVE      '0'           *IN63
     C                   ENDIF
      *
      ** If no error message sent
      *
     C     ERMSG         IFEQ      'N'
     C                   MOVE      '0'           *IN84
     C                   UPDATE    SE7502S0
     C                   ELSE
     C                   MOVE      '1'           *IN84
     C                   UPDATE    SE7502S0
     C                   ENDIF
     C                   ENDIF
      *
     C     TAG4          TAG
      *
     C                   WRITE     #MSGCTL
      *
      ** Read changed subfile record
      *
     C                   READC     SE7502S0                               87
     C                   ENDDO
      *
      ** If 'Add Mode' and if no error message is sent
      *
     C     *IN43         IFEQ      '0'
     C     *IN61         ANDEQ     '0'
     C     ERMSG         ANDEQ     'N'
      *
     C                   Z-ADD     1             #1RRN
     C                   MOVE      'Y'           FINSR             1
      *
      ** Read first record of subfile
      *
     C                   READC     SE7502S0                               87
      *
      ** Do while end of subfile is not reached
      *
     C     *IN87         DOWEQ     '0'
      *
      ** Retrieve next available Reference Number
      *
     C                   EXSR      P021
      *
      ** If Security Shortname is left blank
      *
     C     #1SECN        IFNE      *BLANKS
      *
      ** Access to ER Reference file with Current Reference
      *
     C     #1REFN        CHAIN     SECORFL9                           88
      *
      ** If a record is found
      *
     C     *IN88         IFEQ      '0'
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     'CO00002'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
      *
      ** Update subfile record (for reversed error fields)
      *
     C                   UPDATE    SE7502S0
      *
      ** Rollback instruction to reverse all inserts
      *
     C                   ROLBK
      *
      ** Terminate current processing
      *
     C                   GOTO      TAG5
     C                   ELSE
      *
      ** Write a record in Corporate Action Reference file
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'I'           MACHTP
     C                   MOVE      ##USR         MALUID
     C                   MOVE      #1REFN        MACORF
     C                   MOVE      ##JOB         MAJOBN
     C                   MOVE      ##USR         MAUSER
     C                   Z-ADD     ##JNO         MAJNBR
     C                   MOVE      #1SECN        MASESN
     C                   MOVE      #1COAT        MACOAT
      *
     C     #1COAT        CHAIN     SECOATL0                           89
     C                   MOVE      MMPTYP        MAPTYP
      *
     C     #1COAN        IFNE      *BLANKS
      *
     C                   MOVE      #1COAN        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MACOAN
     C                   ELSE
     C                   Z-ADD     *ZEROS        MACOAN
     C                   ENDIF
      *
     C     #1EXDT        IFNE      *BLANKS
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MACOEX
     C                   ELSE
     C                   Z-ADD     *ZEROS        MACOEX
     C                   ENDIF
      *
     C     #1ALEF        IFNE      *BLANKS
      *
     C                   MOVE      #1ALEF        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MAALEF
     C                   ELSE
     C                   Z-ADD     *ZEROS        MAALEF
     C                   ENDIF
      *
     C                   MOVE      #1NBOP        MANBOP
     C                   MOVE      'T'           MATDVD
     C                   Z-ADD     MAALEF        MACOPD
     C                   Z-ADD     MAALEF        MATDDT
     C                   Z-ADD     MACOEX        MAEVDT
     C                   Z-ADD     *ZEROS        MACPNB
     C                   Z-ADD     *ZEROS        MASHMD
     C                   MOVE      'N'           MALTBS
     C                   Z-ADD     *ZEROS        MAOCPV
     C                   Z-ADD     *ZEROS        MANCPV
     C                   Z-ADD     *ZEROS        MAONML
     C                   Z-ADD     *ZEROS        MANNML
      *
     C                   MOVE      MASESN        KSECN
     C                   Z-ADD     MACOEX        KEXDT
      *
     C     KEY7          SETLL     PRICM
     C                   READ      PRICM                                  89
      *
     C     *IN89         IFEQ      '0'
     C     PSSN          ANDEQ     KSECN
     C     PVDT          ANDGE     KEXDT
     C     KEXDT         ANDNE     *ZEROS
     C                   Z-ADD     PPRC          MACUPC
     C                   Z-ADD     PPRC          MAEXPC
     C                   ELSE
      *
     C                   MOVE      'PR'          KTYPE
      *
     C     KEY5          SETLL     SECED
     C                   READ      SECED                                  89
      *
     C     *IN89         IFEQ      '0'
     C     SNSN          ANDEQ     KSECN
     C     SNDT          ANDGE     KEXDT
     C     SNET          ANDEQ     'PR'
     C     KEXDT         ANDNE     *ZEROS
     C                   Z-ADD     SNPR          MACUPC
     C                   Z-ADD     SNPR          MAEXPC
     C                   ELSE
     C     KSECN         CHAIN     SECTYZ1                            89
     C     *IN89         IFEQ      '0'
     C                   Z-ADD     MKPR          MACUPC
     C                   Z-ADD     MKPR          MAEXPC
     C                   ELSE
     C                   Z-ADD     *ZEROS        MACUPC
     C                   Z-ADD     *ZEROS        MAEXPC
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        MACLRD
     C                   Z-ADD     *ZEROS        MACLRT
     C                   Z-ADD     *ZEROS        MADLRD
     C                   Z-ADD     *ZEROS        MADLRT
     C                   MOVE      'N'           MABLOS
     C                   MOVE      'N'           MABLOP
     C                   Z-ADD     *ZEROS        MABFRD
     C                   Z-ADD     *ZEROS        MABEND
      *                                                                                       CGL031
     C                   EVAL      MASETX = *BLANKS                                           CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y' AND                                           CGL031
     C                             #1COAT = 'DI'                                              CGL031
     C                   EVAL      KSECN = #1SECN                                             CGL031
     C     KSECN         CHAIN     SECTYZ1                                                    CGL031
     C                   IF        %FOUND                                                     CGL031
     C                   EVAL      MASETX = SETX                                              CGL031
     C                   ENDIF                                                                CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CGL031
     C                   MOVE      'N'           MAREFO
     C                   MOVE      *BLANKS       MACONR
     C                   MOVE      *BLANKS       MADFNR
     C                   MOVE      *BLANKS       MADFCP
     C                   MOVE      *BLANKS       MADFSP
     C                   MOVE      'N'           MALREQ
     C                   Z-ADD     *ZEROS        MALPRO
     C                   MOVE      'N'           MALTSI
     C                   MOVE      'I'           MASTAT
      *
     C                   WRITE     SECORFD0
      *
     C                   Z-ADD     1             WWOPNB            2 0
     C                   MOVE      #1NBOP        W1NBOP            2 0
      *
      ** Write the record(s) on the Corporate Action Option file
      ** Depending of the processing type
      *
     C     WWOPNB        DOWLE     W1NBOP
     C                   EXSR      P011
     C                   ADD       1             WWOPNB
     C                   ENDDO
      *
      ** Save the first inserted record fields
      *
     C     FINSR         IFEQ      'Y'
     C                   MOVE      MACORF        KREFN
     C                   MOVE      '1'           *IN55
     C                   MOVE      'N'           FINSR
     C                   ENDIF
      *
      ** Update subfile record (for Reversed error fields)
      *
     C                   UPDATE    SE7502S0
      *
      ** Initialise error indicators
      *
     C                   EVAL      *IN07 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN13
     C                   MOVE      '0'           *IN14
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN35
     C                   MOVE      '1'           *IN36
     C                   MOVE      '0'           *IN42
     C                   MOVE      '1'           *IN43
     C                   MOVE      '0'           *IN49
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C                   MOVE      '0'           *IN67
     C                   MOVE      '0'           *IN70
     C                   MOVE      '0'           *IN71
     C                   MOVE      '0'           *IN72
     C                   MOVE      '0'           *IN73
     C                   MOVE      '0'           *IN74
     C                   MOVE      '0'           *IN76
     C                   MOVE      '0'           *IN77
     C                   MOVE      '0'           *IN78
     C                   MOVE      '0'           *IN79
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   MOVE      '0'           *IN85
      *
     C                   MOVE      'N'           #1FINA
     C                   MOVE      'I'           #1STAT
     C                   MOVE      'G'           #1SEL
     C                   MOVE      'Y'           WWINPT            1
     C                   MOVE      'Y'           WRBLD             1
     C                   EXSR      P018
     C                   MOVE      '0'           *IN36
     C                   MOVE      '0'           *IN43
     C                   MOVE      ' '           #1SEL
     C                   MOVE      'N'           WWINPT
      *
     C     #1REFN        CHAIN     SECORFL0                           89
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C     *IN89         IFEQ      '0'
     C                   UPDATE    SECORFD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Read first record of subfile
      *
     C                   READC     SE7502S0                               87
     C                   ENDDO
      *
      ** If at least one record created
      *
     C     W1CORF        IFNE      WWCORF
     C     *LOVAL        SETLL     SECORFPA
     C                   READ      SECORFPA                               89
      *
     C     *IN89         IFEQ      '0'
     C                   MOVE      WWCORF        MXCORF
     C                   UPDATE    SECORFP0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Execute Commitment Control to fix all inserted records
      *
     C                   COMMIT
      *
      ** Set key fields from KLIST to first inserted record
      *
     C                   Z-ADD     0             WWRRN             4 0          Save Rcd.Nbr.
      *
      **   Clear subfile
      *
     C                   EXSR      P004
      *
      ** Set indicator to return to 'Amend Mode'
      *
     C                   MOVE      '1'           *IN43
     C                   MOVEA     TXT(9)        ##CTX1
      *
     C                   MOVE      '0'           *IN57
     C                   MOVE      '1'           *IN58
      *
     C                   MOVE      '0'           WIN45
     C                   MOVE      '0'           *IN30
      *
     C                   EXSR      P006
     C                   MOVE      '1'           WIN45
      *
     C                   ENDIF
      *
     C     TAG5          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P008A  : Validate 'Action' Field                              *
      *****************************************************************
      *
     C     P008A         BEGSR
      *
      ** If it's not the report mode
      *
     C     *IN64         IFEQ      '0'
      *
      ** If it's the Enq. mode, the 'Action' must be eq. to 'E' or 'F'
      *
     C     *IN61         IFEQ      '1'
      *
     C     #1SEL         IFNE      'E'
     C     #1SEL         ANDNE     'F'
     C     #1SEL         ANDNE     'V'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00017'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
      *
     C                   ELSE
      *
      ** 'Action' Code can be 'G','F','A','E','R','Y','P','V','D','C','N'
      *
     C     #1SEL         IFNE      'G'
     C     #1SEL         ANDNE     'F'
     C     #1SEL         ANDNE     'A'
     C     #1SEL         ANDNE     'E'
     C     #1SEL         ANDNE     'R'
     C     #1SEL         ANDNE     'Y'
     C     #1SEL         ANDNE     'P'
     C     #1SEL         ANDNE     'V'
     C     #1SEL         ANDNE     'D'
     C     #1SEL         ANDNE     'C'
     C     #1SEL         ANDNE     'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00018'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** If it's the report mode, the 'Action' must be equal to 'P'
      *
     C                   ELSE
      *
     C     #1SEL         IFNE      'P'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00019'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Ex-Date' is *GE than 'Run Date' and Action is not equal to 'F'
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      KEXDT
      *
     C     #1SEL         IFEQ      'A'
     C     #1SEL         OREQ      'E'
     C     #1SEL         OREQ      'Y'
     C     KEXDT         IFGE      BJRDNB
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00020'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** Access ER Reference file
      *
     C     #1REFN        CHAIN     SECORFL9                           89
      *
      ** If Locked by User Identifier is not blank
      *
     C     MAUSER        IFNE      *BLANKS
     C                   MOVE      MAUSER        WUSER
     C                   MOVE      MAJOBN        WJOBN
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN28                          Reverse image
     C                   MOVE      '1'           *IN29                          Reverse image
     C                   MOVE      '1'           *IN32                          Reverse image
     C                   MOVE      '1'           *IN33                          Reverse image
     C                   MOVE      '1'           *IN34                          Reverse image
     C                   MOVE      '1'           *IN37                          Reverse image
     C                   MOVE      '1'           *IN38                          Reverse image
     C                   MOVE      '1'           *IN39                          Reverse image
     C                   MOVEL     LOCKDS        ZAMSDA
     C                   MOVEL     'CO00021'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
      *
      ** If 'Processing type' is not 'NC' and 'Action' is 'N'
      ** Error message : Action 'N' not allowed
      *
     C     #1PTYP        IFNE      'NC'
     C     #1SEL         ANDEQ     'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00254'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
      *
      ** If 'Action' is 'N' and status different than 'I'
      ** Error message : Action 'N' not allowed
      *
     C     #1SEL         IFEQ      'N'
     C     #1GSTS        ANDNE     'I'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00257'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
      *
      ** If 'CO status' is 'Authorised' and Action is 'G', 'D' 'Y' or N
      ** Error message: ... Not allowed with status 'X' (Authorised)
      *
     C     #1GSTS        IFEQ      'X'
     C     #1SEL         IFEQ      'G'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00023'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'CO Status' is 'Stock Authorised' & Actn is 'G', 'D', 'Y', 'N'
      ** Error message : Not Allowed with Status 'S' (Stock Authorised)
      *
     C     #1GSTS        IFEQ      'S'
     C     #1SEL         IFEQ      'D'
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00098'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'CO STATUS' is 'COMPLETED' & Actn is 'G', 'A', 'D', 'Y', N
      ** Error message : Not allowed with status 'C' (Completed)
      *
     C     #1GSTS        IFEQ      'C'
     C     #1SEL         IFEQ      'G'
     C     #1SEL         OREQ      'A'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'N'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00024'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'CO STATUS' is 'REVERSED' and action is not 'E'
      ** Error message : only 'F' and 'P' allowed when status 'R'
      *
     C     #1GSTS        IFEQ      'R'
     C     #1SEL         ANDNE     'F'
     C     #1SEL         ANDNE     'P'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00025'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
      *
      ** If 'Action' is 'Delete' ('D'), test if it's possible to
      ** Delete.
      *
     C     #1SEL         IFEQ      'D'
      *
      ** If Processing Type = Dividend Events, Rights Issues or Offer  s.
      *
     C     #1PTYP        IFEQ      'DV'
     C     #1PTYP        OREQ      'RG'
     C     #1PTYP        OREQ      'FR'
      *
      ** If there is a linked Exercises and Conversions Corporate.
      *
     C     #1REFN        CHAIN     SECOEXL2                           89
     C     *IN89         IFEQ      '0'
     C     MJCORF        CHAIN     SECORFL9                           89
     C     *IN89         IFEQ      '0'
     C     MASTAT        IFEQ      'R'
      *
      ** If the linked 'EX' Corporate is Reversed, Delete not allowed  ,
      ** only Reverse allowed.
      *
     C                   MOVEL     'CO00599'     ZAMSID                         Message id.
     C                   ELSE
      *
      ** If the linked 'EX' Corporate is not Reversed, Delete not
      ** allowed.
      *
     C                   MOVEL     'CO00597'     ZAMSID                         Message id.
     C                   ENDIF
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL(P)  MJCORF        ZAMSDA
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If 'ACTION' is 'REVERSE' ('R'), test if it's possible to REVERSE
      *
     C     #1SEL         IFEQ      'R'
      *
      ** Access Security details to retrieve Security Maturity Date
      *
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      ** If 'Ex-Date' is not greater than calculated 'Back Value Date'
      ** or if 'Run Date' is not lower than Security 'Maturity datE'
      *
     C     KEXDT         IFLE      WBACKD
     C     KEXDT         ANDNE     *ZEROS
     C     BJRDNB        ORGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00028'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
      *
     C     BJRDNB        SUB       MATDDT        RTNWRF            5 0
      *
     C     RTNWRF        IFGE      RTNPOS
     C     RTNWRF        ORGE      RTNTRD
     C     MASTAT        IFNE      'I'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00556'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
      *
      ** If Processing Type = Dividend Events, Rights Issues or Offer  s.
      *
     C     #1PTYP        IFEQ      'DV'
     C     #1PTYP        OREQ      'RG'
     C     #1PTYP        OREQ      'FR'
      *
      ** If there is a linked Exercises and Conversions Corporate and
      ** this linked Corporate not Reversed, Reverse not allowed.
      *
     C     #1REFN        CHAIN     SECOEXL2                           89
     C     *IN89         IFEQ      '0'
     C     MJCORF        CHAIN     SECORFL9                           89
     C     *IN89         IFEQ      '0'
     C     MASTAT        ANDNE     'R'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00598'     ZAMSID                         Message id.
     C                   MOVEL(P)  MJCORF        ZAMSDA
     C                   EXSR      ZASNMS                                       Send message
     C                   GOTO      TAG2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #1SEL         IFEQ      'R'
     C     #1SEL         OREQ      'D'
     C     #1REFN        CHAIN     SECORFLA                           89
     C     *IN89         IFEQ      *OFF
     C     MASTAT        ANDEQ     'R'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00369'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Action' is 'Reply' and if processing type 'NC' or 'CC'
      *
     C     #1SEL         IFEQ      'Y'
     C     #1PTYP        ANDEQ     'NC'
     C     #1SEL         OREQ      'Y'
     C     #1PTYP        ANDEQ     'CC'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00110'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
     C     #1SEL         IFEQ      'F'
     C     #1SEL         OREQ      'V'
     C     #1SEL         OREQ      'E'
     C                   MOVE      'E'           WLACTN
     C                   ELSE
     C     #1SEL         IFEQ      'N'
     C                   MOVE      'X'           WLACTN
     C                   ELSE
     C                   MOVE      #1SEL         WLACTN
     C                   ENDIF
     C                   ENDIF
      *
     C     #1SEL         IFEQ      'E'
     C     #1SEL         OREQ      'Y'
     C     #1SEL         OREQ      'V'
     C     #1SEL         OREQ      'N'
     C                   EXSR      P025
     C                   ENDIF
      *
      ** Check if user is authorised to the action code
      *
      ** If single branch environment
      *
     C     AGMBIN        IFNE      'Y'
     C                   CALL      'ZVACTU'
     C                   PARM                    WLACTN            1
     C                   PARM                    WLERR             1 0
      *
     C     WLERR         IFNE      *ZERO
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00034'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If multibranching environment
      *
     C                   CALL      'ZVACTBU'
     C                   PARM                    WLACTN            1
     C                   PARM      BVBRCD        WLBRCH            3
     C                   PARM                    WLERR             1 0
      *
     C     WLERR         IFEQ      1
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00035'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ELSE
     C     WLERR         IFEQ      2
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62
     C                   MOVEL     'CO00036'     ZAMSID
     C                   EXSR      ZASNMS
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     TAG2          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P009   : Process 'Action'                                     *
      *****************************************************************
      *
     C     P009          BEGSR
      *
      ** If Action is 'Amend' Call 'Depots Maintenance' Program
      ** or if Action is 'Enquiry' Call 'Depots Enquiry' Program
      *
     C     #1SEL         IFEQ      'A'
     C     #1SEL         OREQ      'E'
      *
     C                   MOVE      *BLANKS       P#RTCD
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
     C                   MOVE      DAYNOOUT      WEXDAT
      *
     C                   MOVE      *BLANKS       WNBOP
     C                   MOVE      #1NBOP        WNBOP             2
      *
     C                   CALL      'SE7512'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1PTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    WNBOP                          Number of Options
     C                   PARM                    #1SEL                          Amend or Enquiry ?
     C                   PARM      *BLANKS       WWGSTS            1            General Status
     C                   PARM                    P#RTCD            1            Return Code
      *
     C     #1SEL         IFEQ      'A'
     C                   MOVE      WWGSTS        #1GSTS
      *
      ** Retrieve the "Higher" Status and final allocation indicator
      *
     C                   MOVE      *BLANKS       #1STAT
     C                   MOVE      *BLANKS       #1FINA
     C                   MOVE      'Y'           WFIRST            1
      *
     C     #1REFN        SETLL     SECODRL1
     C     #1REFN        READE     SECODRL1                               89
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      MASTAT        #1STAT
     C                   ENDIF
      *
     C     *IN89         DOWEQ     '0'
      *
     C     MSRECI        IFEQ      'D'
      *
     C     WFIRST        IFEQ      'Y'
     C                   MOVE      MSFAID        #1FINA
     C                   MOVE      MSCOST        #1STAT
     C                   MOVE      'N'           WFIRST
     C                   ELSE
      *
      ** Retrieve the "Higher" Final allocation indicator
      *
     C     MSFAID        IFEQ      'Y'
     C                   MOVE      MSFAID        #1FINA
     C                   ELSE
     C     MSFAID        IFEQ      'S'
     C     #1FINA        ANDEQ     'N'
     C                   MOVE      MSFAID        #1FINA
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve the "Higher" Status
      *
     C     MSCOST        IFEQ      'C'
     C                   MOVE      MSCOST        #1STAT
     C                   ELSE
     C     MSCOST        IFEQ      'X'
     C     #1STAT        IFEQ      'S'
     C     #1STAT        OREQ      'L'
     C     #1STAT        OREQ      'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF
     C                   ENDIF
      *
     C     MSCOST        IFEQ      'S'
     C     #1STAT        IFEQ      'L'
     C     #1STAT        OREQ      'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF
     C                   ENDIF
      *
     C     MSCOST        IFEQ      'L'
     C     #1STAT        ANDEQ     'I'
     C                   MOVE      MSCOST        #1STAT
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     #1REFN        READE     SECODRL1                               89
     C                   ENDDO
      *
     C     #1FINA        IFEQ      *BLANKS
     C     #1STAT        ANDEQ     *BLANKS
     C                   MOVE      'N'           #1FINA
     C                   MOVE      'I'           #1STAT
     C                   ENDIF
     C                   ENDIF
      *
      ** If error indicator of the program call is on or if return
      ** Code is equal to 'E' (Error), database error
      *
     C     *IN99         IFEQ      '1'
     C     P#RTCD        OREQ      'E'
     C                   MOVEL     '005'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 05 **
     C                   MOVEL     NARR(5)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P#RTCD        IFNE      'M'
     C                   MOVE      *BLANKS       #1SEL
     C                   ENDIF
      *
      ** If Return code is equal to '2', '3' or 'M'
      *
     C     P#RTCD        IFEQ      '2'
     C     P#RTCD        OREQ      '3'
     C     P#RTCD        OREQ      'M'
      *
      ** Access to ER Reference file with current reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
      ** Commitment instruction
      *
     C                   COMMIT
      *
     C     P#RTCD        IFEQ      '3'
     C                   MOVE      '1'           *INKC
     C                   ENDIF
      *
     C     P#RTCD        IFEQ      'M'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00031'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
     C                   GOTO      TAG3
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Action' is print
      *
     C     #1SEL         IFEQ      'P'
      *
     C                   MOVE      *BLANKS       #1SEL
      *
     C                   MOVE      *BLANKS       @PARM           100
     C                   MOVEL     'SE7533'      @RNAM
     C                   MOVEL     'SEC7533B'    @COTT
      *
     C                   CALL      'FC0040X'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    @RNAM            10
     C                   PARM                    @COTT            10
     C                   PARM      '10004'       @CSEQ             5
     C                   PARM      #1REFN        @PARM           100
     C                   PARM      AGMBIN        @MBRC             1
     C                   PARM      'S'           @LVL              1
     C                   PARM      *BLANKS       @ETTY             3
      *
      ** If error indicator of the program call is on or if return
      ** Code is equal to 'E' (Error), database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '006'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 06 **
     C                   MOVEL     NARR(8)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If return code is equal to blank
      *
     C     @RTCD         IFEQ      ' '
      *
      ** Access to ER Reference file with current reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
     C                   MOVEL     'CO00294'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** Commitment instruction
      *
     C                   COMMIT
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Action' is reverse, delete or authorisation
      ** (processing type 'NC')
      *
     C     #1SEL         IFEQ      'R'
     C     #1SEL         OREQ      'D'
     C     #1SEL         OREQ      'N'
      *
      ** Produce confirmation screen
      *
     C                   EXSR      P010
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** If Confirmation indicator returned is not equal to 'Y'
      *
     C     #1CONF        IFNE      'Y'
      *
      ** Access to ER Reference file with current reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
     C                   COMMIT
      *
     C                   MOVE      *BLANKS       #1SEL
      *
      ** Terminate current processing
      *
     C                   GOTO      TAG3
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Action' is reverse
      *
     C     #1SEL         IFEQ      'R'
      *
      ** Access Corporate action Reference with current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'R'           MACHTP
     C                   MOVE      ##USR         MALUID
      *
      ** If Ex-Date changed
      *
     C     #1EXDT        IFNE      #2EXDT
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MACOEX
      *
     C                   MOVE      #1EXDT        #2EXDT
     C                   ENDIF
      *
      ** If Date of Announcement changed
      *
     C     #1COAN        IFNE      #2COAN
     C                   MOVE      #1COAN        DateIn
     C                   EXSR      ZDATE1
      *
     C                   Z-ADD     DAYNOOUT      MACOAN
     C                   MOVE      #1COAN        #2COAN
     C                   ENDIF
      *
      ** If Allocation effective date changed
      *
     C     #1ALEF        IFNE      #2ALEF
     C                   MOVE      #1ALEF        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      MAALEF
      *
     C                   MOVE      #1ALEF        #2ALEF
     C                   ENDIF
      *
     C     #1REFN        SETLL     SECOALL0
     C     #1REFN        READE     SECOALL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MCCORF
      *
     C     MCRECI        IFEQ      '*'
     C                   DELETE    SECOALD0
     C                   ELSE
     C                   MOVE      '*'           MCRECI
     C                   Z-ADD     BJRDNB        MCLCD
     C                   MOVE      'R'           MCCHTP
     C                   MOVE      ##USR         MCLUID
     C                   UPDATE    SECOALD0
     C                   ENDIF
      *
      ** Access next record
      *
     C     #1REFN        READE     SECOALL0                               89
     C                   ENDDO
      *
     C     #1REFN        SETLL     SECODPL0
     C     #1REFN        READE     SECODPL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MBCORF
      *
     C     MBRECI        IFEQ      '*'
     C                   DELETE    SECODPD0
     C                   ELSE
     C                   MOVE      '*'           MBRECI
     C                   Z-ADD     BJRDNB        MBLCD
     C                   MOVE      'R'           MBCHTP
     C                   MOVE      ##USR         MBLUID
     C                   UPDATE    SECODPD0
     C                   ENDIF
      *
      ** Access next record
      *
     C     #1REFN        READE     SECODPL0                               89
     C                   ENDDO
      *
     C     #1REFN        SETLL     SECODRL0
     C     #1REFN        READE     SECODRL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MSCORF
      *
     C                   Z-ADD     BJRDNB        MSLCD
     C                   MOVE      'R'           MSCHTP
     C                   MOVE      ##USR         MSLUID
     C                   MOVE      'R'           MSCOST
     C                   UPDATE    SECODRD0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECODRL0                               89
     C                   ENDDO
      *
      ** Reverse records on Blocking File.
      *
     C     #1REFN        SETLL     SECOBKL1
     C     #1REFN        READE     SECOBKL1                               89
      *
      ** Do while end of file not reached.
      *
     C     *IN89         DOWEQ     '0'
      *
     C     MURECI        IFEQ      '*'
     C                   DELETE    SECOBKD0
     C                   ELSE
     C                   Z-ADD     BJRDNB        MULCD
     C                   MOVE      'R'           MUCHTP
     C                   MOVE      ##USR         MULUID
     C                   MOVE      '*'           MURECI
     C                   UPDATE    SECOBKD0
     C                   ENDIF
      *
      ** Access next record.
      *
     C     #1REFN        READE     SECOBKL1                               89
     C                   ENDDO
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      'R'           MASTAT
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      'Y'           WRBLD             1
     C                   MOVE(P)   FIELD         WWFLD           175
      *
      ** If Exercises and Conversions and 'DV', 'RG' or 'OF' linked
      ** Corporate Action exists.
      *
     C     #1PTYP        IFEQ      'EX'
     C     WWLNKR        ANDNE     *BLANKS
     C     WWLNKR        CHAIN     SECORFL9                           89
      *
      ** If Status of the 'DV', 'RG' or 'FR' linked Corporate Action
      ** neither Stock Autorised, nor Fully Authorised, nor Complete,
      ** set 'Rights' fields to blank or zero (and 'Subscription Rights
      ** Tradable' field if 'DV' to 'N').
      *
     C     *IN89         IFEQ      '0'
     C     MASTAT        IFNE      'S'
     C     MASTAT        ANDNE     'X'
     C     MASTAT        ANDNE     'C'
     C     WWPTYP        IFEQ      'DV'
     C     WWLNKR        CHAIN     SECODVL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      'N'           MDSBRT
     C                   MOVE      *BLANKS       MDSBRS
     C                   Z-ADD     0             MDREPR
     C                   Z-ADD     0             MDREXD
     C                   Z-ADD     0             MDREXA
     C                   MOVE      *BLANKS       MDREAT
     C                   Z-ADD     0             MDRNNS
     C                   Z-ADD     0             MDRNRI
     C                   Z-ADD     0             MDRMLT
     C                   Z-ADD     0             MDRDIV
     C                   Z-ADD     0             MDRTRF
     C                   Z-ADD     0             MDRTRT
     C                   Z-ADD     BJRDNB        MDLCD
     C                   MOVE      'A'           MDCHTP
     C                   MOVE      ##USR         MDLUID
     C                   UPDATE    SECODVD0
     C                   ENDIF
     C                   ELSE
     C     WWPTYP        IFEQ      'RG'
     C     WWLNKR        CHAIN     SECORGL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      *BLANKS       MFSBRS
     C                   Z-ADD     0             MFSBRP
     C                   Z-ADD     0             MFREXD
     C                   Z-ADD     0             MFREXA
     C                   MOVE      *BLANKS       MFREAT
     C                   Z-ADD     0             MFRNNS
     C                   Z-ADD     0             MFRNRI
     C                   Z-ADD     0             MFRMLT
     C                   Z-ADD     0             MFRDIV
     C                   Z-ADD     0             MFRTRF
     C                   Z-ADD     0             MFRTRT
     C                   MOVE      *BLANKS       MFAVOP
     C                   Z-ADD     BJRDNB        MFLCD
     C                   MOVE      'A'           MFCHTP
     C                   MOVE      ##USR         MFLUID
     C                   UPDATE    SECORGD0
     C                   ENDIF
     C                   ELSE
     C     WWLNKR        CHAIN     SECOFRL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      'N'           MESBRT
     C                   MOVE      *BLANKS       MESBRS
     C                   Z-ADD     0             MEREPR
     C                   Z-ADD     0             MEREXD
     C                   Z-ADD     0             MEREXA
     C                   MOVE      *BLANKS       MEREAT
     C                   Z-ADD     0             MERNNS
     C                   Z-ADD     0             MERNRI
     C                   Z-ADD     0             MERMLT
     C                   Z-ADD     0             MERDIV
     C                   Z-ADD     0             MERTRF
     C                   Z-ADD     0             MERTRT
     C                   Z-ADD     BJRDNB        MELCD
     C                   MOVE      'A'           MECHTP
     C                   MOVE      ##USR         MELUID
     C                   UPDATE    SECOFRD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     #1REFN        CHAIN     SECOEXL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      *BLANKS       MJLNKR
     C                   Z-ADD     BJRDNB        MJLCD
     C                   MOVE      'A'           MJCHTP
     C                   MOVE      ##USR         MJLUID
     C                   UPDATE    SECOEXD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      WWFLD         FIELD
     C                   ENDIF
      *
     C     #1PTYP        IFEQ      'CC'
     C     #1REFN        CHAIN     SECOCCL0                           89
      *
     C     *IN89         IFEQ      '0'
     C                   MOVE      '*'           NARECI
     C                   Z-ADD     BJRDNB        NALCD
     C                   MOVE      'R'           NACHTP
     C                   MOVE      ##USR         NALUID
     C                   UPDATE    SECOCCD0
     C                   ENDIF
      *
     C     NABLKR        IFNE      *ZEROS
     C     *IN89         ANDEQ     '0'
     C                   Z-ADD     *ZEROS        WCOUNT
     C                   MOVE      #1REFN        W1REFN
     C     NABLKR        CHAIN     SECORBL0                           89
      *
      ** Reverse all matching records in LF/SECORSL0
      *
     C     NBBLKR        SETLL     SECORSL0
     C     NBBLKR        READE     SECORSL0                               89
      *
     C     *IN89         DOWEQ     '0'
     C     NCRECI        IFEQ      'D'
     C                   ADD       1             WCOUNT
     C                   ENDIF
     C     W1REFN        IFEQ      NCCORF
     C                   MOVE      '*'           NCRECI
     C                   Z-ADD     BJRDNB        NCLCD
     C                   MOVE      'R'           NCCHTP
     C                   MOVE      ##USR         NCLUID
     C                   UPDATE    SECORSD0
     C                   SUB       1             WCOUNT
     C                   ENDIF
     C     NBBLKR        READE     SECORSL0                               89
     C                   ENDDO
      *
      ** Reverse matching record in LF/SECORBL0
      *
     C     WCOUNT        IFEQ      *ZEROS
     C                   MOVE      'R'           NBSTAT
     C                   Z-ADD     BJRDNB        NBLCD
     C                   MOVE      'R'           NBCHTP
     C                   MOVE      ##USR         NBLUID
     C                   UPDATE    SECORBD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update subfile fields
      *
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      'R'           #1STAT
     C                   MOVE      'R'           #1GSTS
      *
      ** Commitment instruction
      *
     C                   COMMIT
     C                   ENDIF
      *
      ** If 'Action' is 'General Information', 'F' - Enquiry or
      ** 'G' - Maintenance
      *
     C     #1SEL         IFEQ      'F'
     C     #1SEL         OREQ      'G'
      *
     C                   MOVE      '0'           *IN35
     C     #1PTYP        IFEQ      'CC'
     C                   MOVE      '1'           *IN35
     C                   ENDIF
      *
     C                   MOVE      *IN61         WIN61             1
     C     #1SEL         IFEQ      'F'
     C                   MOVE      '1'           *IN61
     C                   ENDIF
      *
      ** Initialise error indicators
      *
     C                   EVAL      *IN07 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN13
     C                   MOVE      '0'           *IN14
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN42
     C                   MOVE      '0'           *IN49
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C                   MOVE      '0'           *IN67
     C                   MOVE      '0'           *IN70
     C                   MOVE      '0'           *IN71
     C                   MOVE      '0'           *IN72
     C                   MOVE      '0'           *IN73
     C                   MOVE      '0'           *IN74
     C                   MOVE      '0'           *IN76
     C                   MOVE      '0'           *IN77
     C                   MOVE      '0'           *IN78
     C                   MOVE      '0'           *IN79
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   MOVE      '0'           *IN85
      *
      ** Process 'Full Details' Screen
      *
     C                   EXSR      P018
      *
      ** If F3 or F12 is pressed of if all fields protected
      *
     C     *INKC         IFEQ      '1'
     C     *INKL         OREQ      '1'
     C     *IN61         OREQ      '1'
      *
      ** Access Corporate Action Reference with current reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      ** Update subfile fields
      *
     C                   MOVE      FIELD         #FIELD
      *
      ** Commitment instruction
      *
     C                   COMMIT
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       #1SEL
      *
     C                   MOVE      WIN61         *IN61
      *
     C                   ENDIF
      *
      ** If 'Action' is delete
      *
     C     #1SEL         IFEQ      'D'
      *
      ** Delete records in depot files
      *
     C     #1REFN        SETLL     SECODPL0
     C     #1REFN        READE     SECODPL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MBCORF
      *
     C                   DELETE    SECODPD0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECODPL0                               89
     C                   ENDDO
      *
      ** Delete records in depot files
      *
     C     #1REFN        SETLL     SECODRL0
     C     #1REFN        READE     SECODRL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MSCORF
      *
     C                   DELETE    SECODRD0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECODRL0                               89
     C                   ENDDO
      *
      ** Delete records in allocation files
      *
     C     #1REFN        SETLL     SECOALL0
     C     #1REFN        READE     SECOALL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MCCORF
      *
     C                   DELETE    SECOALD0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECOALL0                               89
     C                   ENDDO
      *
      ** Delete records in Reply Handling files
      *
     C     #1REFN        SETLL     SECOREL0
     C     #1REFN        READE     SECOREL0                               89
      *
      ** Do while end of file not reached and same Reference Number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MQCORF
      *
     C                   DELETE    SECORED0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECOREL0                               89
     C                   ENDDO
      *
      ** Delete records in Historic Reply Handling files
      *
     C     #1REFN        SETLL     SECORHL0
     C     #1REFN        READE     SECORHL0                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MPCORF
      *
     C                   DELETE    SECORHD0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECORHL0                               89
     C                   ENDDO
      *
      ** Delete records in blocking file
      *
     C     #1REFN        SETLL     SECOBKL1
     C     #1REFN        READE     SECOBKL1                               89
      *
      ** Do while end of file not reached and same reference number
      *
     C     *IN89         DOWEQ     '0'
     C     #1REFN        ANDEQ     MUCORF
      *
     C                   DELETE    SECOBKD0
      *
      ** Access next record
      *
     C     #1REFN        READE     SECOBKL1                               89
     C                   ENDDO
      *
      ** Delete all the relative options
      *
     C                   EXSR      P022
      *
      ** Access Corporate action Reference with current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
     C                   DELETE    SECORFD0
     C                   MOVE      'Y'           WRBLD
      *
      ** If Exercises and Conversions and 'DV', 'RG' or 'FR' linked
      ** Corporate Action exists.
      *
     C     #1PTYP        IFEQ      'EX'
     C     WWLNKR        ANDNE     *BLANKS
     C     WWLNKR        CHAIN     SECORFL9                           89
      *
      ** If Status of the 'DV', 'RG' or 'FR' linked Corporate Action
      ** neither Stock Autorised, nor Fully Authorised, nor Complete,
      ** set 'Rights' fields to blank or zero (and 'Subscription Rights
      ** Tradable' field if 'DV' to 'N').
      *
     C     *IN89         IFEQ      '0'
     C     MASTAT        IFNE      'S'
     C     MASTAT        ANDNE     'X'
     C     MASTAT        ANDNE     'C'
     C     WWPTYP        IFEQ      'DV'
     C     WWLNKR        CHAIN     SECODVL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      'N'           MDSBRT
     C                   MOVE      *BLANKS       MDSBRS
     C                   Z-ADD     0             MDREPR
     C                   Z-ADD     0             MDREXD
     C                   Z-ADD     0             MDREXA
     C                   MOVE      *BLANKS       MDREAT
     C                   Z-ADD     0             MDRNNS
     C                   Z-ADD     0             MDRNRI
     C                   Z-ADD     0             MDRMLT
     C                   Z-ADD     0             MDRDIV
     C                   Z-ADD     0             MDRTRF
     C                   Z-ADD     0             MDRTRT
     C                   Z-ADD     BJRDNB        MDLCD
     C                   MOVE      'A'           MDCHTP
     C                   MOVE      ##USR         MDLUID
     C                   UPDATE    SECODVD0
     C                   ENDIF
     C                   ELSE
     C     WWPTYP        IFEQ      'RG'
     C     WWLNKR        CHAIN     SECORGL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      *BLANKS       MFSBRS
     C                   Z-ADD     0             MFSBRP
     C                   Z-ADD     0             MFREXD
     C                   Z-ADD     0             MFREXA
     C                   MOVE      *BLANKS       MFREAT
     C                   Z-ADD     0             MFRNNS
     C                   Z-ADD     0             MFRNRI
     C                   Z-ADD     0             MFRMLT
     C                   Z-ADD     0             MFRDIV
     C                   Z-ADD     0             MFRTRF
     C                   Z-ADD     0             MFRTRT
     C                   MOVE      *BLANKS       MFAVOP
     C                   Z-ADD     BJRDNB        MFLCD
     C                   MOVE      'A'           MFCHTP
     C                   MOVE      ##USR         MFLUID
     C                   UPDATE    SECORGD0
     C                   ENDIF
     C                   ELSE
     C     WWLNKR        CHAIN     SECOFRL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      'N'           MESBRT
     C                   MOVE      *BLANKS       MESBRS
     C                   Z-ADD     0             MEREPR
     C                   Z-ADD     0             MEREXD
     C                   Z-ADD     0             MEREXA
     C                   MOVE      *BLANKS       MEREAT
     C                   Z-ADD     0             MERNNS
     C                   Z-ADD     0             MERNRI
     C                   Z-ADD     0             MERMLT
     C                   Z-ADD     0             MERDIV
     C                   Z-ADD     0             MERTRF
     C                   Z-ADD     0             MERTRT
     C                   Z-ADD     BJRDNB        MELCD
     C                   MOVE      'A'           MECHTP
     C                   MOVE      ##USR         MELUID
     C                   UPDATE    SECOFRD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Commitment instruction
      *
     C                   COMMIT
      *
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      '0'           WIN45
     C                   ENDIF
      *
      ** If 'Action' is Authorisation (Processing type 'NC')
      *
     C     #1SEL         IFEQ      'N'
      *
      ** Access Corporate Action Reference with Current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
     C                   MOVE      'X'           MASTAT
     C                   UPDATE    SECORFD0
     C                   MOVE      'Y'           WRBLD
      *
      ** Update subfile fields
      *
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      'X'           #1GSTS
      *
      ** Commitment Instruction
      *
     C                   COMMIT
     C                   ENDIF
      *
      ** If 'Action' is Customer Reply Handle
      *
     C     #1SEL         IFEQ      'Y'
      *
     C                   MOVE      *BLANKS       P#RTCD
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
     C                   MOVE      DAYNOOUT      WEXDAT
      *
     C                   CALL      'SE7514'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1PTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    NMCY              3            Nominal Currency
     C                   PARM                    P#RTCD            1            Return Code
      *
      ** If error indicator of the program call is on or if return
      ** Code is equal to 'E' (Error), database error
      *
     C     *IN99         IFEQ      '1'
     C     P#RTCD        OREQ      'E'
     C                   MOVEL     '007'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 07 **
     C                   MOVEL     NARR(6)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P#RTCD        IFNE      'M'
     C                   MOVE      *BLANKS       #1SEL
     C                   ENDIF
      *
      ** If Return Code is equal to '2', '3' or 'M'
      *
     C     P#RTCD        IFEQ      '2'
     C     P#RTCD        OREQ      '3'
     C     P#RTCD        OREQ      'M'
      *
      ** Access Corporate Action Reference with Current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      ** Update subfile fields
      *
     C                   MOVE      FIELD         #FIELD
      *
      ** Commitment instruction
      *
     C                   COMMIT
      *
     C     P#RTCD        IFEQ      '3'
     C                   MOVE      '1'           *INKC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       #1SEL
      *
     C                   ENDIF
      *
      ** If 'Action' is view Customer Allocations
      *
     C     #1SEL         IFEQ      'V'
      *
     C                   MOVE      *BLANKS       P#RTCD
     C     *LOCK         IN        LDA
     C                   MOVEL     'SE7502'      PGMNAM
     C                   OUT       LDA
      *
     C                   CALL      'SE7540'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM      *BLANKS       WWOPTN            2            Option number
     C                   PARM      *BLANKS       WWBRCD            3            Branch Code
     C                   PARM      *BLANKS       WWBOOK            2            Book
     C                   PARM      *BLANKS       WWCUST            6            Customer
     C                   PARM      *BLANKS       WWPTFR            4            Portfolio
     C                   PARM      *BLANKS       WWCPGM            6            Calling Pgm
     C                   PARM                    P#RTCD            1            Return Code
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     *BLANKS       PGMNAM
     C                   OUT       LDA
      *
      ** If error indicator of the program call is on or if return
      ** Code is equal to 'E' (Error), database error
      *
     C     *IN99         IFEQ      '1'
     C     P#RTCD        OREQ      'E'
     C                   MOVEL     '008'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 08 **
     C                   MOVEL     NARR(9)       DBKEY            29            *****************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P#RTCD        IFNE      'M'
     C                   MOVE      *BLANKS       #1SEL
     C                   ENDIF
      *
      ** If Return code is equal to '2', '3' or 'M'
      *
     C     P#RTCD        IFEQ      '2'
     C     P#RTCD        OREQ      '3'
     C     P#RTCD        OREQ      'M'
      *
      ** Access Corporate Action Reference with current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      ** Update subfile fields
      *
     C                   MOVE      FIELD         #FIELD
      *
      ** Commitment Instruction
      *
     C                   COMMIT
      *
     C     P#RTCD        IFEQ      '3'
     C                   MOVE      '1'           *INKC
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If 'Action' is Print Correspondence, *** Future use, Phase II ***
      *
     C     #1SEL         IFEQ      'C'
      *
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00258'     ZAMSID
     C                   EXSR      ZASNMS
      *
      ** Access Corporate Action Reference with Current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C                   UPDATE    SECORFD0
      *
      ** Update subfile fields
      *
     C                   MOVE      FIELD         #FIELD
      *
      ** Commitment Instruction
      *
     C                   COMMIT
      *
     C                   ENDIF
      *
     C     TAG3          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P010   : Process 'Confirmation' Screen                        *
      *****************************************************************
      *
     C     P010          BEGSR
      *
     C                   MOVE      *BLANKS       #1CONF
      *
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
      *
     C                   MOVE      '0'           *IN44
     C                   MOVE      '1'           *IN47
      *
      ** If Delete or Reverse of a Corporate Action type Exercises an  d
      ** Conversions, check if there is a linked Corporate Action.
      *
     C                   MOVE      *BLANKS       REFLIN
     C     #1PTYP        IFEQ      'EX'
     C     #1SEL         ANDEQ     'D'
     C     #1PTYP        OREQ      'EX'
     C     #1SEL         ANDEQ     'R'
     C     #1REFN        CHAIN(N)  SECOEXL0                           89
     C     MJLNKR        IFNE      *BLANKS
     C     MJLNKR        CHAIN(N)  SECODVL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      MJLNKR        WWLNKR
     C                   MOVE      'DV'          WWPTYP
     C                   ELSE
     C     MJLNKR        CHAIN(N)  SECORGL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      MJLNKR        WWLNKR
     C                   MOVE      'RG'          WWPTYP
     C                   ELSE
     C     MJLNKR        CHAIN(N)  SECOFRL0                           89
     C     *IN89         IFEQ      '0'
     C                   MOVE      MJLNKR        WWLNKR
     C                   MOVE      'FR'          WWPTYP
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Depending of the 'Action', Set the correct narrative
      **   *** CONFIRM REVERSAL ***
      *
     C     #1SEL         IFEQ      'R'
     C                   MOVE      '1'           *IN40
     C                   MOVE      '0'           *IN41
     C                   ELSE
      *
      **   *** CONFIRM DELETION ***
      *
     C     #1SEL         IFEQ      'D'
     C                   MOVE      '0'           *IN40
     C                   MOVE      '0'           *IN41
     C                   ELSE
      *
      **   *** CONFIRM AUTHORISATION ***
      *
     C     #1SEL         IFEQ      'N'
     C                   MOVE      '0'           *IN40
     C                   MOVE      '1'           *IN41
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEA     TXT(6)        ##CTX1
      *
      ** Do while F3 or F12 not pressed and no error
      *
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C     #1CONF        ANDNE     'Y'
     C     #1CONF        ANDNE     'N'
      *
      ** Setup Screen time
      *
     C                   TIME                    ##TME                          Screen time.
      *
      ** If Delete or Reverse CO type 'EX' linked with CO type 'DV' o  r
      ** 'RG' or 'FR', send warning message.
      *
     C     #1SEL         IFEQ      'D'
     C     WWLNKR        ANDNE     *BLANKS
     C     #1SEL         OREQ      'R'
     C     WWLNKR        ANDNE     *BLANKS
     C                   MOVEL(P)  REFLIN        ZAMSDA
     C                   MOVEL     'CO00600'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** Execute Screen format
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     SE7502F1
     C                   EXFMT     SE7502F2
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           WIN12
     C                   ELSE
     C                   MOVE      '0'           WIN12
     C                   ENDIF
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      '3'           P#RTCD
     C                   ENDIF
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
      ** If 'Confirmation indicator' is not equal to 'Y' or 'N'
      *
     C     #1CONF        IFNE      'N'
     C     #1CONF        ANDNE     'Y'
     C                   MOVE      '1'           *IN44                          Reverse image
     C                   MOVEL     'CO00032'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   MOVE      '0'           *IN44                          Reverse image
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     TXT(9)        ##CTX1
     C                   MOVE      '0'           *IN47
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P011   : Write Option(s) with default Information             *
      *****************************************************************
      *
     C     P011          BEGSR
      *
     C                   MOVEL     NARR(4)       WWOPSH           26
     C                   MOVE      WWOPNB        WWOPSH
      *
     C     MAPTYP        IFEQ      'DV'
     C                   CLEAR                   SECODVD0
     C                   MOVE      'D'           MDRECI
     C                   Z-ADD     BJRDNB        MDLCD
     C                   MOVE      'I'           MDCHTP
     C                   MOVE      ##USR         MDLUID
     C                   MOVE      #1REFN        MDCORF
     C                   Z-ADD     WWOPNB        MDOPTN
     C                   MOVE      #1SECN        MDNSEC
     C                   MOVE      'D'           MDRNDN
     C                   MOVE      'N'           MDRNDS
     C                   MOVE      'N'           MDSBRT
     C                   MOVEL     WWOPSH        MDOPSH
     C                   WRITE     SECODVD0
     C                   ELSE
     C     MAPTYP        IFEQ      'FR'
     C                   CLEAR                   SECOFRD0
     C                   MOVE      'D'           MERECI
     C                   Z-ADD     BJRDNB        MELCD
     C                   MOVE      'I'           MECHTP
     C                   MOVE      ##USR         MELUID
     C                   MOVE      #1REFN        MECORF
     C                   Z-ADD     WWOPNB        MEOPTN
     C                   MOVE      #1SECN        MENSEC
     C                   MOVE      'D'           MERNDN
     C                   MOVE      'N'           MERNDS
     C                   MOVEL     WWOPSH        MEOPSH
     C                   WRITE     SECOFRD0
     C                   ELSE
     C     MAPTYP        IFEQ      'CE'
     C                   CLEAR                   SECOCED0
     C                   MOVE      'D'           MGRECI
     C                   Z-ADD     BJRDNB        MGLCD
     C                   MOVE      'I'           MGCHTP
     C                   MOVE      ##USR         MGLUID
     C                   MOVE      #1REFN        MGCORF
     C                   Z-ADD     WWOPNB        MGOPTN
     C                   MOVEL     WWOPSH        MGOPSH
     C                   WRITE     SECOCED0
     C                   ELSE
     C     MAPTYP        IFEQ      'CR'
     C                   CLEAR                   SECOCRD0
     C                   MOVE      'D'           MHRECI
     C                   Z-ADD     BJRDNB        MHLCD
     C                   MOVE      'I'           MHCHTP
     C                   MOVE      ##USR         MHLUID
     C                   MOVE      #1REFN        MHCORF
     C                   Z-ADD     WWOPNB        MHOPTN
     C                   MOVEL     WWOPSH        MHOPSH
     C                   WRITE     SECOCRD0
     C                   ELSE
     C     MAPTYP        IFEQ      'OF'
     C                   CLEAR                   SECOOFD0
     C                   MOVE      'D'           MIRECI
     C                   Z-ADD     BJRDNB        MILCD
     C                   MOVE      'I'           MICHTP
     C                   MOVE      ##USR         MILUID
     C                   MOVE      #1REFN        MICORF
     C                   MOVE      'D'           MIRNDN
     C                   MOVE      'N'           MIRNDS
     C                   Z-ADD     WWOPNB        MIOPTN
     C                   MOVEL     WWOPSH        MIOPSH
     C                   WRITE     SECOOFD0
     C                   ELSE
     C     MAPTYP        IFEQ      'RG'
     C                   CLEAR                   SECORGD0
     C                   MOVE      'D'           MFRECI
     C                   Z-ADD     BJRDNB        MFLCD
     C                   MOVE      'I'           MFCHTP
     C                   MOVE      ##USR         MFLUID
     C                   MOVE      #1REFN        MFCORF
     C                   Z-ADD     WWOPNB        MFOPTN
     C                   MOVE      #1SECN        MFNSEC
     C                   MOVE      'D'           MFRNDN
     C                   MOVE      'N'           MFRNDS
     C                   MOVEL     WWOPSH        MFOPSH
     C                   WRITE     SECORGD0
     C                   ELSE
     C     MAPTYP        IFEQ      'EX'
     C                   CLEAR                   SECOEXD0
     C                   MOVE      'D'           MJRECI
     C                   Z-ADD     BJRDNB        MJLCD
     C                   MOVE      'I'           MJCHTP
     C                   MOVE      ##USR         MJLUID
     C                   MOVE      #1REFN        MJCORF
     C                   Z-ADD     WWOPNB        MJOPTN
     C                   MOVE      'D'           MJRNDN
     C                   MOVE      'N'           MJRNDS
     C                   MOVE      'N'           MJOPT1
     C                   MOVE      'N'           MJOPT2
     C                   MOVE      'N'           MJOPT3
     C                   MOVE      'N'           MJOPT4
     C                   MOVE      'N'           MJOPT5
     C                   MOVE      'N'           MJOPT6
     C                   MOVE      'N'           MJOPT7
     C                   MOVEL     WWOPSH        MJOPSH
     C                   WRITE     SECOEXD0
     C                   ELSE
     C     MAPTYP        IFEQ      'NF'
     C                   CLEAR                   SECONFD0
     C                   MOVE      'D'           MKRECI
     C                   Z-ADD     BJRDNB        MKLCD
     C                   MOVE      'I'           MKCHTP
     C                   MOVE      ##USR         MKLUID
     C                   MOVE      #1REFN        MKCORF
     C                   Z-ADD     1             MKSEQN
     C                   WRITE     SECONFD0
     C                   ELSE
     C     MAPTYP        IFEQ      'NC'
     C                   CLEAR                   SECONCD0
     C                   MOVE      'D'           MLRECI
     C                   Z-ADD     BJRDNB        MLLCD
     C                   MOVE      'I'           MLCHTP
     C                   MOVE      ##USR         MLLUID
     C                   MOVE      #1REFN        MLCORF
     C                   WRITE     SECONCD0
     C                   ELSE
     C     MAPTYP        IFEQ      'CC'
     C                   CLEAR                   SECOCCD0
     C                   MOVE      'D'           NARECI
     C                   Z-ADD     BJRDNB        NALCD
     C                   MOVE      'I'           NACHTP
     C                   MOVE      ##USR         NALUID
     C                   MOVE      #1REFN        NACORF
     C                   WRITE     SECOCCD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P014   : Reinitialise Indicators                              *
      *****************************************************************
      *
     C     P014          BEGSR
      *
      ** Reinitialise indicators
      *
     C                   MOVE      '0'           *IN28                          Error on Allocation
     C                   MOVE      '0'           *IN29                          Error on Number Opti
     C                   MOVE      '0'           *IN32                          Error on Ex-Date
     C                   MOVE      '0'           *IN33                          Error on Action Type
     C                   MOVE      '0'           *IN34                          Error on Status
     C                   MOVE      '0'           *IN37                          Error on Date Announ
     C                   MOVE      '0'           *IN38                          Error on Reference
     C                   MOVE      '0'           *IN39                          Error on Shortname
     C                   MOVE      '0'           *IN62                          Error on Action
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P015   : Clear Sfl Fields                                     *
      *****************************************************************
      *
     C     P015          BEGSR
      *
      ** Initialise subfile record
      *
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      *BLANKS       #1REFN
     C                   MOVE      *BLANKS       #1SECN
     C                   MOVE      *BLANKS       #1COAT
     C                   MOVE      *BLANKS       #1COAN
     C                   MOVE      *BLANKS       #1EXDT
     C                   MOVE      *BLANKS       #1ALEF
     C                   MOVE      *BLANKS       #1NBOP
     C                   MOVE      *BLANKS       #1GSTS
      *
      ** Initialise hidden subfile fields
      *
     C                   MOVE      *BLANKS       #FIELD
     C                   MOVE      *BLANKS       #1PTYP
     C                   MOVE      *BLANKS       #1TDVD
      *
     C                   MOVE      *BLANKS       #2SEL
     C                   MOVE      *BLANKS       #2COAN
     C                   MOVE      *BLANKS       #2EXDT
     C                   MOVE      *BLANKS       #2ALEF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * P016  : Load Sfl Fields                                       *
      *****************************************************************
      *
     C     P016          BEGSR
      *
      ** Initialise subfile record
      *
     C                   MOVE      *BLANKS       #1SEL
     C                   MOVE      MACORF        #1REFN
     C                   MOVE      MASESN        #1SECN
     C                   MOVE      MACOAT        #1COAT
     C                   MOVE      MAPTYP        #1PTYP
     C                   MOVE      MATDVD        #1TDVD
      *
     C     MACOAN        IFNE      *ZEROS
     C                   Z-ADD     MACOAN        ZDAYNO
     C                   EXSR      ZDATE2
      *
     C                   MOVE      ZDATE         #1COAN
     C                   ELSE
     C                   MOVE      *BLANKS       #1COAN
     C                   ENDIF
      *
     C     MACOEX        IFNE      *ZEROS
     C                   Z-ADD     MACOEX        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1EXDT
     C                   ELSE
     C                   MOVE      *BLANKS       #1EXDT
     C                   ENDIF
      *
     C     MAALEF        IFNE      *ZEROS
     C                   Z-ADD     MAALEF        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1ALEF
     C                   ELSE
     C                   MOVE      *BLANKS       #1ALEF
     C                   ENDIF
      *
     C                   MOVE      MANBOP        #1NBOP
     C                   MOVE      MASTAT        #1GSTS
      *
      ** Initialise hidden subfile fields
      *
     C                   MOVE      MAJOBN        WAJOBN           10
     C                   MOVE      MAUSER        WAUSER           10
     C                   Z-ADD     MAJNBR        WAJNBR            6 0
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   MOVE      FIELD         #FIELD
     C                   MOVE      WAJOBN        MAJOBN
     C                   MOVE      WAUSER        MAUSER
     C                   Z-ADD     WAJNBR        MAJNBR
     C                   MOVE      *BLANKS       #2SEL
     C                   MOVE      #1COAN        #2COAN
     C                   MOVE      #1EXDT        #2EXDT
     C                   MOVE      #1ALEF        #2ALEF
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * P018  : Process 'Full Details' Screen                         *
      *****************************************************************
      *
     C     P018          BEGSR
      *
      ** Setup the display fields
      *
     C                   MOVE      *BLANKS       #1BLKR
     C     MAPTYP        IFEQ      'CC'
     C     #1REFN        CHAIN     SECOCCL0                           89
      *
     C     *IN89         IFEQ      '0'
     C     NABLKR        ANDNE     *ZEROS
     C                   MOVE      NABLKR        #1BLKR
     C                   ENDIF
      *
     C     MAPREF        IFNE      *BLANKS
     C                   MOVE      MAPREF        #PREF
     C                   MOVE      '1'           *IN12
     C                   ELSE
     C                   MOVE      '0'           *IN12
     C                   ENDIF
     C                   MOVE      *IN12         WWIN12            1
      *
     C                   ENDIF
      *
     C                   MOVE      MATDVD        #1TDVD
      *
     C     MACOPD        IFNE      *ZEROS
     C                   Z-ADD     MACOPD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1COPD
     C                   ELSE
     C                   MOVE      #1ALEF        #1COPD
     C                   ENDIF
      *
     C     MATDDT        IFNE      *ZEROS
     C                   Z-ADD     MATDDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1TDDT
     C                   ELSE
     C                   MOVE      #1ALEF        #1TDDT
     C                   ENDIF
      *
     C     MAEVDT        IFNE      *ZEROS
     C                   Z-ADD     MAEVDT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1EVDT
     C                   ELSE
     C                   MOVE      #1EXDT        #1EVDT
     C                   ENDIF
      *
     C     MACPNB        IFEQ      *ZEROS
     C                   MOVE      *BLANKS       #1CPNB
     C                   ELSE
     C                   MOVE      MACPNB        #1CPNB
     C                   ENDIF
      *
     C     MASHMD        IFNE      *ZEROS
     C                   Z-ADD     MASHMD        ZDAYNO
     C                   EXSR      ZDATE2
      *
     C                   MOVE      ZDATE         #1SHMD
     C                   ELSE
     C                   MOVE      *BLANKS       #1SHMD
     C                   ENDIF
      *
     C                   MOVE      MALTBS        #1LTBS
      *
      ** Access Security Details to Retrieve Number of Decimals
      ** on the Security
      *
     C     MASESN        CHAIN     SECTYZ1                            89
      *
     C     MAOCPV        IFNE      *ZEROS
     C                   Z-ADD     *ZEROS        ZFLD15
     C                   Z-ADD     MAOCPV        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   EXSR      ZSEDIT
     C                   MOVEL     *BLANKS       #1OCPV
     C                   MOVE      ZOUT21        WFLD17           17
     C                   MOVEL     WFLD17        #1OCPV
     C                   ELSE
     C                   MOVE      *BLANKS       #1OCPV
     C                   ENDIF
      *
     C     MANCPV        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MANCPV        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   EXSR      ZSEDIT
      *
     C                   MOVEL     *BLANKS       #1NCPV
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1NCPV
     C                   ELSE
     C                   MOVE      *BLANKS       #1NCPV
     C                   ENDIF
      *
     C     MAONML        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAONML        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   EXSR      ZSEDIT
      *
     C                   MOVEL     *BLANKS       #1ONML
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1ONML
     C                   ELSE
     C                   MOVE      *BLANKS       #1ONML
     C                   ENDIF
      *
     C     MANNML        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MANNML        ZFLD15
     C                   Z-ADD     NMDP          ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   EXSR      ZSEDIT
      *
     C                   MOVEL     *BLANKS       #1NNML
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1NNML
     C                   ELSE
     C                   MOVE      *BLANKS       #1NNML
     C                   ENDIF
      *
     C     MACUPC        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MACUPC        ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   EXSR      ZSEDIT
      *
     C                   MOVEL     *BLANKS       #1CUPC
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1CUPC
     C                   ELSE
     C                   MOVE      *BLANKS       #1CUPC
     C                   ENDIF
      *
     C     MAEXPC        IFNE      *ZEROS
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      MAEXPC        ZFLD15
     C                   Z-ADD     8             ZDECS
     C                   MOVE      'L'           ZECODE
      *
     C                   EXSR      ZSEDIT
      *
     C                   MOVEL     *BLANKS       #1EXPC
     C                   MOVE      ZOUT21        WFLD17
     C                   MOVEL     WFLD17        #1EXPC
     C                   ELSE
     C                   MOVE      *BLANKS       #1EXPC
     C                   ENDIF
      *
     C     MACLRD        IFNE      *ZEROS
     C                   Z-ADD     MACLRD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1CLRD
     C                   ELSE
     C                   MOVE      *BLANKS       #1CLRD
     C                   ENDIF
      *
     C     MACLRT        IFNE      *ZEROS
     C                   MOVE      MACLRT        #1CLRT
     C                   ELSE
     C                   MOVE      *BLANKS       #1CLRT
     C                   ENDIF
      *
     C     MADLRD        IFNE      *ZEROS
     C                   Z-ADD     MADLRD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1DLRD
     C                   ELSE
     C                   MOVE      *BLANKS       #1DLRD
     C                   ENDIF
      *
     C     MADLRT        IFNE      *ZEROS
     C                   MOVE      MADLRT        #1DLRT
     C                   ELSE
     C                   MOVE      *BLANKS       #1DLRT
     C                   ENDIF
      *
     C                   MOVE      MABLOP        #1BLOP
     C                   MOVE      MABLOP        #2BLOP
     C                   MOVE      MABLOS        #1BLOS
     C                   MOVE      MABLOS        #2BLOS
      *
     C     MABFRD        IFNE      *ZEROS
     C                   Z-ADD     MABFRD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1BFRD
     C                   ELSE
     C                   MOVE      *BLANKS       #1BFRD
     C                   ENDIF
      *
     C                   MOVE      #1BFRD        #2BFRD
      *
     C     MABEND        IFNE      *ZEROS
     C     MABEND        ANDNE     *HIVAL
     C                   Z-ADD     MABEND        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVE      ZDATE         #1BEND
     C                   ELSE
     C                   MOVE      *BLANKS       #1BEND
     C                   ENDIF
      *
     C                   MOVE      #1BEND        #2BEND
      *                                                                                       CGL031
      ** Move relevant file fields to screen fields if CGL031 is enabled.                     CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      #1SETX = MASETX                                            CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   MOVE      MAREFO        #1REFO
     C                   MOVE      MACONR        #1CONR
     C                   MOVE      MADFNR        #1DFNR
     C                   MOVE      MADFCP        #1DFCP
     C                   MOVE      MADFSP        #1DFSP
      *
      ** Move parent reference field to screen fields.
      *
     C     MAPREF        IFNE      *BLANKS
     C                   MOVE      MAPREF        #1PREF
     C                   MOVE      '1'           *IN12
     C                   ELSE
     C                   MOVE      '0'           *IN12
     C                   ENDIF
     C                   MOVE      *IN12         WWIN12
      *
     C                   MOVE      MANBOP        WNBOP
      *
     C                   MOVE      '1'           *IN47
      *
     C     WWINPT        IFEQ      'Y'
     C                   MOVEA     TXT(6)        ##CTX1
     C                   ELSE
     C     *IN61         IFEQ      '1'
     C                   MOVEA     TXT(4)        ##CTX1
     C                   ELSE
     C                   MOVEA     TXT(5)        ##CTX1
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      'Y'           ERROR             1
     C                   MOVE      '1'           *IN84
      *
      ** Determine fields to protect depending of the Status and the
      ** Final Allocation
      *
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN16
     C                   MOVE      '0'           *IN17
     C                   MOVE      '0'           *IN18
     C                   MOVE      '0'           *IN19
      *
      ** LS=Final Allocation Stock          (*IN15)
      ** LY=Final Allocation Cash and Stock (*IN16)
      ** S =Stock Authorised                (*IN17)
      ** X =Fully Authorised (Cash & Stock) (*IN18)
      ** C =Completed                       (*IN18 + *IN19)
      ** R =Reversed                        (*IN18 + *IN19)
      *
     C     #1STAT        IFEQ      'L'
     C     #1FINA        IFEQ      'S'
     C                   MOVE      '1'           *IN15
     C                   ELSE
     C     #1FINA        IFEQ      'Y'
     C                   MOVE      '1'           *IN16
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     #1STAT        IFEQ      'S'
     C                   MOVE      '1'           *IN17
     C                   ELSE
     C     #1STAT        IFEQ      'X'
     C                   MOVE      '1'           *IN18
     C                   ELSE
     C     #1STAT        IFEQ      'C'
     C     #1STAT        OREQ      'R'
     C                   MOVE      '1'           *IN18
     C                   MOVE      '1'           *IN19
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Do while F12 or F3 is not pressed and no error
      *
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C     ERROR         ANDEQ     'Y'
     C     WIN12         ANDEQ     '0'
      *
      ** If 'Number of Options' is not 01, non protect the fields
      ** 'Accept offer', 'Refuse offer', 'Option Narrative',
      ** 'Default Cash', 'Default Stock', 'Default for'
      *
     C                   MOVE      WNBOP         W1NBOP
      *
     C     W1NBOP        IFNE      1
     C                   MOVE      '0'           *IN26
     C                   ELSE
     C                   MOVE      '1'           *IN26
     C                   ENDIF
     C                   MOVE      WWIN12        *IN12
      *
      ** Setup Screen time
      *
     C                   TIME                    ##TME                          Screen time.
      *
      ** Execute screen format
      *
     C                   WRITE     #MSGCTL
     C                   WRITE     SE7502F1
     C                   EXFMT     SE7502F3
      *
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           WIN12             1
     C                   ELSE
     C                   MOVE      '0'           WIN12
     C                   ENDIF
      *
     C     *INKC         IFEQ      '1'
     C                   MOVE      '3'           P#RTCD
     C                   ENDIF
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   MOVE      'N'           ERROR
      *
      ** If Cmd11 Pressed
      *
     C     *INKK         IFEQ      '1'
     C     *INKC         OREQ      '0'
     C     *INKL         ANDEQ     '0'
     C     WWINPT        ANDEQ     'Y'
      *
      ** Validate details and Update file if no error
      *
     C     *IN61         IFEQ      '0'
     C                   EXSR      P019
     C                   ENDIF
      *
      ** View/Change Option(s)
      *
     C     ERROR         IFEQ      'N'
     C                   EXSR      P023
     C                   ENDIF
     C                   ELSE
      *
      ** If all input fields are not protected
      *
     C     *IN61         IFEQ      '0'
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      ** Validate details and update file if no error
      *
     C                   EXSR      P019
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVE      '0'           *IN15
     C                   MOVE      '0'           *IN16
     C                   MOVE      '0'           *IN17
     C                   MOVE      '0'           *IN18
     C                   MOVE      '0'           *IN19
      *
      ** Setup correctly the command keys Available
      *
     C                   MOVEA     TXT(9)        ##CTX1
      *
     C                   MOVE      '0'           *IN47
      *
      ** Clear messages from program message queue.
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      ##PGM         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL            5
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P019  : Validate 'Full Details' Screen and Update file        *
      *****************************************************************
      *
     C     P019          BEGSR
      *
      ** Access Secutiry details with current Security Shortname
      *
     C     #1SECN        CHAIN     SECTYZ1                            89
      *
      ** Initialise error indicators
      *
     C                   EVAL      *IN07 = *OFF                                               CGL031
     C                   MOVE      '0'           *IN13
     C                   MOVE      '0'           *IN14
     C                   MOVE      '0'           *IN20
     C                   MOVE      '0'           *IN21
     C                   MOVE      '0'           *IN22
     C                   MOVE      '0'           *IN23
     C                   MOVE      '0'           *IN24
     C                   MOVE      '0'           *IN31
     C                   MOVE      '0'           *IN42
     C                   MOVE      '0'           *IN49
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN65
     C                   MOVE      '0'           *IN66
     C                   MOVE      '0'           *IN67
     C                   MOVE      '0'           *IN70
     C                   MOVE      '0'           *IN71
     C                   MOVE      '0'           *IN72
     C                   MOVE      '0'           *IN73
     C                   MOVE      '0'           *IN74
     C                   MOVE      '0'           *IN76
     C                   MOVE      '0'           *IN77
     C                   MOVE      '0'           *IN78
     C                   MOVE      '0'           *IN79
     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83
     C                   MOVE      '0'           *IN85
      *
     C                   Z-ADD     *ZEROS        WCOPD             5 0
     C                   Z-ADD     *ZEROS        WTDDT             5 0
     C                   Z-ADD     *ZEROS        WEVDT             5 0
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      WEXDT             5 0
      *
     C                   MOVE      #1ALEF        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      WALEF             5 0
      *
      ** If 'Payment Date' is not blank
      *
     C     #1COPD        IFNE      *BLANKS
      *
     C                   MOVE      #1COPD        DateIn
     C                   EXSR      ZDATE1
      *
      ** If 'Payment Date is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00038'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WCOPD             5 0
      *
      ** If 'Payment Date' is before the 'Ex-Date'
      *
     C     WCOPD         IFLT      WEXDT
     C     WEXDT         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If 'Payment Date' is before the 'Allocation Effective Date'
      *
     C     WCOPD         IFLT      WALEF
     C     WALEF         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00039'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If 'Payment date' is greater or equal to the Maturity date
      ** of the Security
      *
     C     WCOPD         IFGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00217'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Trade Date' is not blank
      *
     C     #1TDDT        IFNE      *BLANKS
      *
     C                   MOVE      #1TDDT        DateIn
     C                   EXSR      ZDATE1
      *
      ** If 'Trade Date is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00301'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WTDDT             5 0
      *
      ** If 'Trade Date' is greater than the 'Allocation Effective Date'
      *
     C     WTDDT         IFGT      WALEF
     C     WALEF         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00212'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If 'Trade date must be lower than the Maturity date of the
      ** Security
      *
     C     WTDDT         IFGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00218'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If 'Trade Date' must be greater or equal than SE back value
      ** period
      *
     C     WTDDT         IFLT      WBACKD
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN60                          Reverse image
     C                   MOVEL     'CO00219'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Event Date' is not blank
      *
     C     #1EVDT        IFNE      *BLANKS
      *
     C                   MOVE      #1EVDT        DateIn
     C                   EXSR      ZDATE1
      *
      ** If 'Event date is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN49                          Reverse image
     C                   MOVEL     'CO00211'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WEVDT             5 0
      *
      ** If 'Payment Date' is before 'Event Date'
      *
     C     WCOPD         IFLT      WEVDT
     C     WCOPD         ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN65                          Reverse image
     C                   MOVEL     'CO00216'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If 'Event date' must not be before 'Ex-Date'
      *
     C     WEVDT         IFLT      WEXDT
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN49                          Reverse image
     C                   MOVEL     'CO00213'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** If 'Event Date' must be lower than maturity date of the
      ** Security
      *
     C     WEVDT         IFGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN49                          Reverse image
     C                   MOVEL     'CO00220'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Trade/Value Date Position' is entered
      *
     C     #1TDVD        IFNE      *BLANKS
      *
      ** 'Trade/Value date Position' must be equal to 'T' or 'V'
      *
     C     #1TDVD        IFNE      'T'
     C     #1TDVD        ANDNE     'V'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN66                          Reverse image
     C                   MOVEL     'CO00037'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'T'           #1TDVD
     C                   ENDIF
      *
      ** If 'Coupon Number' is entered
      *
     C     #1CPNB        IFNE      *BLANKS
      *
      ** Check it's a valid numeric field
      *
     C     DIGITS        CHECK     #1CPNB:1      N                 1 0    89
      *
      ** If it's not a valid numeric field
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN67                          Reverse image
     C                   MOVEL     'CO00040'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Shareholders meeting date' is entered
      *
     C     #1SHMD        IFNE      *BLANKS
      *
     C                   MOVE      #1SHMD        DateIn
     C                   EXSR      ZDATE1
      *
      ** If 'Shareholders meeting date' is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN70                          Reverse image
     C                   MOVEL     'CO00043'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Letter to be sent' has been entered
      *
     C     #1LTBS        IFNE      *BLANKS
      *
      ** 'Letter to be sent' must be equal to 'Y' or 'N'
      *
     C     #1LTBS        IFNE      'Y'
     C     #1LTBS        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN71                          Reverse image
     C                   MOVEL     'CO00044'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           #1LTBS
     C                   ENDIF
      *
      ** If 'Old Capital Value' has been entered
      *
     C     #1OCPV        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1OCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
      *
     C                   EXSR      ZASIGN
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVEL     'CO00129'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN20
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'New Capital Value' has been entered
      *
     C     #1NCPV        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1NCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
      *
     C                   EXSR      ZASIGN
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVEL     'CO00130'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN21
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Old Nominal Value' has been entered
      *
     C     #1ONML        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1ONML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
      *
     C                   EXSR      ZASIGN
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVEL     'CO00131'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN22
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'New Nominal Value' has been entered
      *
     C     #1NNML        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVE      #1NNML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
      *
     C                   EXSR      ZASIGN
      *
     C     ZASIGNok      IFEQ      'N'
     C                   MOVEL     'CO00132'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN23
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Market Cum Price' has been entered
      *
     C     #1CUPC        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1CUPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
      *
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVEL     'CO00133'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN24
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Market Ex Price' has been entered
      *
     C     #1EXPC        IFNE      *BLANKS
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1EXPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
      *
     C                   EXSR      ZALIGN
      *
     C     ZALIGNok      IFEQ      'N'
     C                   MOVEL     'CO00134'     ZAMSID
     C                   EXSR      ZASNMS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN31
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Customer Last Reply Date' has been entered
      *
     C     #1CLRD        IFNE      *BLANKS
      *
     C                   MOVE      #1CLRD        DateIn
     C                   EXSR      ZDATE1
      *
      ** 'Customer Last Reply Date' must be a valid Date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN83                          Reverse image
     C                   MOVEL     'CO00059'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Customer Last Reply time' has been entered
      *
     C     #1CLRT        IFNE      *BLANKS
      *
      ** No entry allowed when 'Customer LAst Reply Date' is not entered
      *
     C     #1CLRD        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN13                          Reverse image
     C                   MOVEL     'CO00062'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
     C                   MOVEL     #1CLRT        WWHOUR            2 0
     C                   MOVE      #1CLRT        WWMISE            4
     C                   MOVEL     WWMISE        WWMINS            2 0
     C                   MOVE      WWMISE        WWSECS            2 0
      *
      ** 'Customer Last Reply Time' must be a valid time format
      *
     C     WWHOUR        IFGT      23
     C     WWHOUR        ORLT      0
     C     WWMINS        ORGT      59
     C     WWMINS        ORLT      0
     C     WWSECS        ORGT      59
     C     WWSECS        ORLT      0
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN13                          Reverse image
     C                   MOVEL     'CO00061'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Depot Last Reply date' has been entered
      *
     C     #1DLRD        IFNE      *BLANKS
      *
     C                   MOVE      #1DLRD        DateIn
     C                   EXSR      ZDATE1
      *
      ** 'Depot Last Reply Date' must be a valid Date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN85                          Reverse image
     C                   MOVEL     'CO00060'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Depot Last Reply Time' has been entered
      *
     C     #1DLRT        IFNE      *BLANKS
      *
      ** No Entry allowed when 'Depot Last Reply Date' is not entered
      *
     C     #1DLRD        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN14                          Reverse image
     C                   MOVEL     'CO00064'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
     C                   MOVEL     #1DLRT        WWHOUR            2 0
     C                   MOVE      #1DLRT        WWMISE            4
     C                   MOVEL     WWMISE        WWMINS            2 0
     C                   MOVE      WWMISE        WWSECS            2 0
      *
      ** 'Customer Last Reply time' must be a valid time format
      *
     C     WWHOUR        IFGT      23
     C     WWHOUR        ORLT      0
     C     WWMINS        ORGT      59
     C     WWMINS        ORLT      0
     C     WWSECS        ORGT      59
     C     WWSECS        ORLT      0
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN14                          Reverse image
     C                   MOVEL     'CO00063'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Block Security' has been entered
      *
     C     #1BLOS        IFNE      *BLANKS
      *
      ** 'Block Security' must be equal to 'E', 'W' or 'N'
      *
     C     #1BLOS        IFNE      'E'
     C     #1BLOS        ANDNE     'W'
     C     #1BLOS        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN42                          Reverse image
     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           #1BLOS
     C                   ENDIF
      *
      ** If 'Block Position' has been entered
      *
     C     #1BLOP        IFNE      *BLANKS
      *
      ** 'Block Position' must be equal to 'E', 'W' or 'N'
      *
     C     #1BLOP        IFNE      'E'
     C     #1BLOP        ANDNE     'W'
     C     #1BLOP        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN72                          Reverse image
     C                   MOVEL     'CO00045'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           #1BLOP
     C                   ENDIF
      *
     C     #1BLOP        IFEQ      'E'
     C     #1BLOP        ANDEQ     'W'
     C     #1BLOS        OREQ      'E'
     C     #1BLOS        ANDEQ     'W'
      *
     C     #1BFRD        IFEQ      *BLANKS
     C                   MOVE      #1EXDT        #1BFRD
     C                   MOVE      #1EXDT        #2BFRD
     C                   ENDIF
      *
     C     #1BEND        IFEQ      *BLANKS
     C                   MOVE      #1ALEF        #1BEND
     C                   MOVE      #1ALEF        #2BEND
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     *ZEROS        W1BFRD            5 0
      *
      ** If 'Block from Date' has been entered
      *
     C     #1BFRD        IFNE      *BLANKS
      *
      ** 'Block from date' must not be entered if Block indicator= 'N'
      *
     C     #1BLOP        IFEQ      'N'
     C     #1BLOS        ANDEQ     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00046'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
     C                   MOVE      #1BFRD        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      W1BFRD
      *
      ** If 'Block from date' is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00048'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
      ** 'Block from Date' must be greater than run date
      *
     C     DAYNOOUT      IFLE      BJRDNB
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00050'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
      ** 'Block from date' must be entered if block position is 'E' or 'W
      *
     C     #1BLOP        IFEQ      'E'
     C     #1BLOP        OREQ      'W'
     C     #1BLOS        OREQ      'E'
     C     #1BLOS        OREQ      'W'
     C     #1BEND        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN73                          Reverse image
     C                   MOVEL     'CO00243'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'Block End Date' has been entered
      *
     C     #1BEND        IFNE      *BLANKS
      *
      ** 'Block end date' must not be entered if Block Indicators ='N'
      *
     C     #1BLOP        IFEQ      'N'
     C     #1BLOS        ANDEQ     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00047'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
     C                   MOVE      #1BEND        DateIn
     C                   EXSR      ZDATE1
      *
      ** If 'Block end date' is not a valid date format
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00049'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
      *
      ** 'Block End Date' must be greater than Run Date/From Date
      ** and before Maturity Date of the Security
      *
     C     DAYNOOUT      IFLE      BJRDNB
     C     DAYNOOUT      ORLE      W1BFRD
     C     DAYNOOUT      ORGE      MATY
     C     MATY          ANDNE     *ZEROS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00051'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** 'Block End Date' must be entered if Block Position is 'E' or 'W'
      *
     C     #1BLOP        IFEQ      'E'
     C     #1BLOP        OREQ      'W'
     C     #1BLOS        OREQ      'E'
     C     #1BLOS        OREQ      'W'
     C     #1BFRD        IFEQ      *BLANKS
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN74                          Reverse image
     C                   MOVEL     'CO00244'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
                                                                                              CGL031
      ** Validate Subject to European Tax if CGL031 is enabled.                               CGL031
                                                                                              CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
                                                                                              CGL031
     C                   IF        #1SETX = *BLANK                                            CGL031
                                                                                              CGL031
     C                   IF        #1COAT = 'DI'                                              CGL031
     C                   EVAL      #1SETX = SETX                                              CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
      ** Subject to European Tax is mandatory.                                                CGL031
                                                                                              CGL031
     C                   EVAL      ERROR = 'Y'                                                CGL031
     C                   EVAL      *IN07 = *ON                                                CGL031
     C                   EVAL      ZAMSID = 'SEA0907'                                         CGL031
     C                   EXSR      ZASNMS                                                     CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        #1SETX <> 'Y' AND                                          CGL031
     C                             #1SETX <> 'N'                                              CGL031
                                                                                              CGL031
      ** Subject to European Tax must be 'Y' or 'N'.                                          CGL031
                                                                                              CGL031
     C                   EVAL      ERROR = 'Y'                                                CGL031
     C                   EVAL      *IN07 = *ON                                                CGL031
     C                   EVAL      ZAMSID = 'SEA0908'                                         CGL031
     C                   EXSR      ZASNMS                                                     CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *
      ** If 'Number of Options' greater than 1
      *
     C     *IN26         IFEQ      '0'
      *
      ** 'Refuse Offer' must be equal to 'Y' or 'N'
      *
     C     #1REFO        IFNE      'Y'
     C     #1REFO        ANDNE     'N'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN76                          Reverse image
     C                   MOVEL     'CO00053'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
      ** Validate 'Customer Option Narrative'
      *
     C     #1CONR        IFEQ      *BLANKS
      *
      ** 'Customer Option Narrative' mandatory if Refuse Offer 'Y'
      *
     C     #1REFO        IFEQ      'Y'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN77                          Reverse image
     C                   MOVEL     'CO00054'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
     C                   ELSE
      *
      ** 'Customer Option Narrative' must Refer to a Valid live code
      *
     C     #1CONR        CHAIN     SECONAL0                           89
     C     *IN89         IFEQ      '1'
     C     MNRECI        ORNE      'D'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN77                          Reverse image
     C                   MOVEL     'CO00055'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** 'Default for no Reply' must be equal to one of the Customer   OPTIONS
      *
     C     #1DFNR        IFNE      '1'
     C     #1DFNR        ANDNE     '2'
     C     #1DFNR        ANDNE     '3'
     C     #1DFNR        ANDNE     '4'
     C     #1DFNR        ANDNE     '5'
     C     #1DFNR        ANDNE     '6'
     C     #1DFNR        ANDNE     '7'
     C     #1DFNR        ANDNE     '8'
     C     #1DFNR        ANDNE     '9'
     C     #1DFNR        ANDNE     ' '
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN78                          Reverse image
     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   MOVE      #1REFN        KCORF
     C                   Z-ADD     *ZEROS        KOPTN
     C                   MOVE      #1DFNR        KOPTN
      *
     C     #1PTYP        IFNE      'NC'
     C     #1PTYP        ANDNE     'NF'
     C     #1PTYP        ANDNE     'CC'
     C                   EXSR      P024
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
     C     *IN89         IFEQ      '1'
     C     #1PTYP        OREQ      'NC'
     C     #1DFNR        ANDNE     '1'
     C     #1PTYP        OREQ      'NF'
     C     #1DFNR        ANDNE     '1'
     C     #1PTYP        OREQ      'CC'
     C     #1DFNR        ANDNE     '1'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN78                          Reverse image
     C                   MOVEL     'CO00056'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** 'Default for Cash Preferred' must be equal to one of the
      ** Customer Option
      *
     C     #1DFCP        IFNE      '1'
     C     #1DFCP        ANDNE     '2'
     C     #1DFCP        ANDNE     '3'
     C     #1DFCP        ANDNE     '4'
     C     #1DFCP        ANDNE     '5'
     C     #1DFCP        ANDNE     '6'
     C     #1DFCP        ANDNE     '7'
     C     #1DFCP        ANDNE     '8'
     C     #1DFCP        ANDNE     '9'
     C     #1DFCP        ANDNE     ' '
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN79                          Reverse image
     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   MOVE      #1REFN        KCORF
     C                   Z-ADD     *ZEROS        KOPTN
     C                   MOVE      #1DFCP        KOPTN
      *
     C     #1PTYP        IFNE      'NC'
     C     #1PTYP        ANDNE     'NF'
     C     #1PTYP        ANDNE     'CC'
     C                   EXSR      P024
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
     C     *IN89         IFEQ      '1'
     C     #1PTYP        OREQ      'NC'
     C     #1DFCP        ANDNE     '1'
     C     #1PTYP        OREQ      'NF'
     C     #1DFCP        ANDNE     '1'
     C     #1PTYP        OREQ      'CC'
     C     #1DFCP        ANDNE     '1'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN79                          Reverse image
     C                   MOVEL     'CO00057'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
      ** 'Default for Stock Referred' must be equal to one of the      STOMER OP
      ** Customer Option
      *
     C     #1DFSP        IFNE      '1'
     C     #1DFSP        ANDNE     '2'
     C     #1DFSP        ANDNE     '3'
     C     #1DFSP        ANDNE     '4'
     C     #1DFSP        ANDNE     '5'
     C     #1DFSP        ANDNE     '6'
     C     #1DFSP        ANDNE     '7'
     C     #1DFSP        ANDNE     '8'
     C     #1DFSP        ANDNE     '9'
     C     #1DFSP        ANDNE     ' '
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN82                          Reverse image
     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ELSE
     C                   MOVE      #1REFN        KCORF
     C                   Z-ADD     *ZEROS        KOPTN
     C                   MOVE      #1DFSP        KOPTN
      *
     C     #1PTYP        IFNE      'NC'
     C     #1PTYP        ANDNE     'NF'
     C     #1PTYP        ANDNE     'CC'
     C                   EXSR      P024
     C                   ELSE
     C                   MOVE      '0'           *IN89
     C                   ENDIF
      *
     C     *IN89         IFEQ      '1'
     C     #1PTYP        OREQ      'NC'
     C     #1DFSP        ANDNE     '1'
     C     #1PTYP        OREQ      'NF'
     C     #1DFSP        ANDNE     '1'
     C     #1PTYP        OREQ      'CC'
     C     #1DFSP        ANDNE     '1'
     C                   MOVE      'Y'           ERROR
     C                   MOVE      '1'           *IN82                          Reverse image
     C                   MOVEL     'CO00058'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If no error detected
      *
     C     ERROR         IFEQ      'N'
      *
      ** Access to ER Reference file with current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
      *
     C     *INKK         IFEQ      '0'
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
     C                   ENDIF
      *
     C                   Z-ADD     WCOPD         MACOPD
     C                   Z-ADD     WTDDT         MATDDT
     C                   MOVE      #1TDVD        MATDVD
     C                   Z-ADD     WCOPD         MACOPD
     C                   Z-ADD     WTDDT         MATDDT
     C                   Z-ADD     WEVDT         MAEVDT
     C                   MOVE      #1CPNB        MACPNB
      *
     C                   MOVE      #1SHMD        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      MASHMD
      *
     C                   MOVE      #1LTBS        MALTBS
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1OCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
      *
     C                   EXSR      ZASIGN
      *
     C                   MOVE      ZOUT15        WOUT15           15 0
      *
     C     ZFSIGN        IFEQ      '+'
     C                   Z-ADD     WOUT15        MAOCPV
     C                   ELSE
     C                   Z-SUB     WOUT15        MAOCPV
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1NCPV        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        WOUT15
      *
     C     ZFSIGN        IFEQ      '+'
     C                   Z-ADD     WOUT15        MANCPV
     C                   ELSE
     C                   Z-SUB     WOUT15        MANCPV
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1ONML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
     C                   MOVE      ZOUT15        WOUT15
      *
     C     ZFSIGN        IFEQ      '+'
     C                   Z-ADD     WOUT15        MAONML
     C                   ELSE
     C                   Z-SUB     WOUT15        MAONML
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFLD17
     C                   MOVEL     #1NNML        ZFLD17
     C     15            SUB       NMDP          ZSDIG
     C                   Z-ADD     NMDP          ZSDEC
     C                   EXSR      ZASIGN
      *
     C                   MOVE      ZOUT15        WOUT15
      *
     C     ZFSIGN        IFEQ      '+'
     C                   Z-ADD     WOUT15        MANNML
     C                   ELSE
     C                   Z-SUB     WOUT15        MANNML
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     #1CUPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MACUPC
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     #1EXPC        ZFIELD
     C                   Z-ADD     7             ZADIG
     C                   Z-ADD     8             ZADEC
     C                   EXSR      ZALIGN
     C                   MOVE      ZFIELD        MAEXPC
      *
     C                   MOVE      #1CLRD        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      MACLRD
      *
     C                   MOVE      #1CLRT        MACLRT
      *
     C                   MOVE      #1DLRD        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      MADLRD
      *
     C                   MOVE      #1DLRT        MADLRT
     C                   MOVE      #1BLOS        MABLOS
     C                   MOVE      #1BLOP        MABLOP
      *
     C                   MOVE      #1BFRD        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      MABFRD
      *
     C     #1BEND        IFNE      *BLANKS
     C                   MOVE      #1BEND        DateIn
     C                   EXSR      ZDATE1
     C                   Z-ADD     DAYNOOUT      MABEND
     C                   ELSE
     C     #1BLOS        IFEQ      'E'
     C     #1BLOS        OREQ      'W'
     C     #1BLOP        OREQ      'E'
     C     #1BLOP        OREQ      'W'
     C                   Z-ADD     *HIVAL        MABEND
     C                   ELSE
     C                   Z-ADD     *ZEROS        MABEND
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL031
      ** Move relevant screen fields to file fields if CGL031 is enabled.                     CGL031
      *                                                                                       CGL031
     C                   IF        CGL031 = 'Y'                                               CGL031
     C                   EVAL      MASETX = #1SETX                                            CGL031
     C                   ELSE                                                                 CGL031
     C                   EVAL      MASETX = *BLANK                                            CGL031
     C                   ENDIF                                                                CGL031
      *
     C                   MOVE      #1REFO        MAREFO
     C                   MOVE      #1CONR        MACONR
     C                   MOVE      #1DFNR        MADFNR
     C                   MOVE      #1DFCP        MADFCP
     C                   MOVE      #1DFSP        MADFSP
      *
      ** Blocking Processing
      *
     C     #1BLOS        IFNE      #2BLOS
     C     #1BFRD        ORNE      #2BFRD
     C     #1BEND        ORNE      #2BEND
     C                   EXSR      P020
     C                   ENDIF
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
      ** Add commitment instruction
      *
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P020  : Blocking Processing                                   *
      *****************************************************************
      *
     C     P020          BEGSR
      *
      ** Access blocking file with the Corporate Action Reference
      *
     C     MACORF        CHAIN     SECOBKL2                           89
      *
      ** If Block exists, reverse the Current Blocking record
      *
     C     *IN89         IFEQ      '0'
     C                   MOVE      '*'           MURECI
     C                   UPDATE    SECOBKD2
     C                   ENDIF
      *
      ** Access Blocking file with the Corporate Action Reference
      *
     C     MACORF        CHAIN     SECOBKL2                           89
      *
      ** If Block exists, reverse the current blocking record
      *
     C     *IN89         IFEQ      '0'
     C                   MOVE      '*'           MURECI
     C                   UPDATE    SECOBKD2
     C                   ENDIF
      *
      ** Create the new blocking record if Block Position 'E' or'W'
      *
     C     MABLOS        IFEQ      'E'
     C     MABLOS        OREQ      'W'
     C                   MOVE      'D'           MURECI
     C                   Z-ADD     BJRDNB        MULCD
     C                   MOVE      'I'           MUCHTP
     C                   MOVE      ##USR         MULUID
     C                   MOVE      BVBRCD        MUBRCD
     C**********         Z-ADD     *ZEROS        MUCNUM                                       CSD027
     C                   EVAL      MUCNUM = *BLANKS                                           CSD027
     C                   MOVE      *BLANKS       MUPTFR
     C                   MOVE      'P'           MUBLTY
     C                   MOVE      MASESN        MUSESN
     C                   MOVE      MABEND        MUBEDT
     C                   Z-ADD     *ZEROS        MUNOMB
      *
     C                   MOVEL     MACOAT        WWBNAR            9
     C                   MOVE      MACORF        WWBNAR
     C                   MOVEL     WWBNAR        MUBNAR
      *
     C                   Z-ADD     1             MUSEQN
     C                   MOVE      MABFRD        MUBSTT
     C                   MOVE      MABLOS        MUBEWI
     C                   MOVE      MACORF        MUCORF
     C                   WRITE     SECOBKD2
     C                   MOVE      'S'           MUBLTY
     C                   WRITE     SECOBKD2
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P021  : Retrieve next available Reference number              *
      *****************************************************************
      *
     C     P021          BEGSR
      *
      ** Setup "Reference" field with next available number
      *
     C                   MOVE      WWCORF        #1REFN
     C                   ADD       1             WWCORF
      *
      ** Access to ER Reference file with current Reference
      *
     C     #1REFN        CHAIN     SECORFL9                           88
      *
      ** If a record is found
      *
     C     *IN88         DOWEQ     '0'
      *
     C                   MOVE      WWCORF        #1REFN
     C                   ADD       1             WWCORF
      *
      ** Access to ER Reference file with current reference
      *
     C     #1REFN        CHAIN     SECORFL9                           88
     C                   ENDDO
      *
     C                   MOVE      #1BLOS        #2BLOS
     C                   MOVE      #1BEND        #2BEND
     C                   MOVE      #1BFRD        #2BFRD
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P022  : Apply Action to All Options                           *
      *****************************************************************
      *
     C     P022          BEGSR
      *
     C                   SELECT
     C     #1PTYP        WHENEQ    'DV'
     C     #1REFN        SETLL     SECODVL0
     C     #1REFN        READE     SECODVL0                               89
      *
     C     #1PTYP        WHENEQ    'FR'
     C     #1REFN        SETLL     SECOFRL0
     C     #1REFN        READE     SECOFRL0                               89
      *
     C     #1PTYP        WHENEQ    'CE'
     C     #1REFN        SETLL     SECOCEL0
     C     #1REFN        READE     SECOCEL0                               89
      *
     C     #1PTYP        WHENEQ    'CR'
     C     #1REFN        SETLL     SECOCRL0
     C     #1REFN        READE     SECOCRL0                               89
      *
     C     #1PTYP        WHENEQ    'OF'
     C     #1REFN        SETLL     SECOOFL0
     C     #1REFN        READE     SECOOFL0                               89
      *
     C     #1PTYP        WHENEQ    'RG'
     C     #1REFN        SETLL     SECORGL0
     C     #1REFN        READE     SECORGL0                               89
      *
     C     #1PTYP        WHENEQ    'EX'
     C     #1REFN        SETLL     SECOEXL0
     C     #1REFN        READE     SECOEXL0                               89
      *
     C     #1PTYP        WHENEQ    'NC'
     C     #1REFN        SETLL     SECONCL0
     C     #1REFN        READE     SECONCL0                               89
      *
     C     #1PTYP        WHENEQ    'NF'
     C     #1REFN        SETLL     SECONFL0
     C     #1REFN        READE     SECONFL0                               89
      *
     C     #1PTYP        WHENEQ    'CC'
     C     #1REFN        SETLL     SECOCCL0
     C     #1REFN        READE     SECOCCL0                               89
     C                   ENDSL
      *
     C     *IN89         DOWEQ     '0'
      *
     C                   SELECT
     C     #1PTYP        WHENEQ    'DV'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECODVD0
     C                   ENDIF
     C     #1REFN        READE     SECODVL0                               89
      *
     C     #1PTYP        WHENEQ    'FR'
      *
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECOFRD0
     C                   ENDIF
     C     #1REFN        READE     SECOFRL0                               89
      *
     C     #1PTYP        WHENEQ    'CE'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECOCED0
     C                   ENDIF
     C     #1REFN        READE     SECOCEL0                               89
      *
     C     #1PTYP        WHENEQ    'CR'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECOCRD0
     C                   ELSE
     C                   ENDIF
     C     #1REFN        READE     SECOCRL0                               89
      *
     C     #1PTYP        WHENEQ    'OF'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECOOFD0
     C                   ENDIF
     C     #1REFN        READE     SECOOFL0                               89
      *
     C     #1PTYP        WHENEQ    'RG'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECORGD0
     C                   ENDIF
     C     #1REFN        READE     SECORGL0                               89
      *
     C     #1PTYP        WHENEQ    'EX'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECOEXD0
     C                   ENDIF
      *
     C     #1REFN        READE     SECOEXL0                               89
      *
     C     #1PTYP        WHENEQ    'NC'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECONCD0
     C                   ENDIF
     C     #1REFN        READE     SECONCL0                               89
      *
     C     #1PTYP        WHENEQ    'NF'
     C     #1SEL         IFEQ      'D'
     C                   DELETE    SECONFD0
     C                   ENDIF
     C     #1REFN        READE     SECONFL0                               89
      *
     C     #1PTYP        WHENEQ    'CC'
     C     #1SEL         IFEQ      'D'
      *
     C     NABLKR        IFNE      *ZEROS
     C                   Z-ADD     *ZEROS        WCOUNT            5 0
     C                   MOVE      #1REFN        W1REFN            6 0
      *
     C     NABLKR        SETLL     SECORSL0
     C     NABLKR        READE     SECORSL0                               88
     C     *IN88         DOWEQ     '0'
     C                   ADD       1             WCOUNT
     C     W1REFN        IFEQ      NCCORF
     C     NCRECI        ORNE      'D'
     C                   DELETE    SECORSD0
     C                   SUB       1             WCOUNT
     C                   ENDIF
     C     NABLKR        READE     SECORSL0                               88
     C                   ENDDO
      *
     C     WCOUNT        IFEQ      *ZEROS
     C     NABLKR        CHAIN     SECORBL0                           88
     C     *IN88         IFEQ      '0'
     C                   DELETE    SECORBD0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   DELETE    SECOCCD0
     C                   ENDIF
     C     #1REFN        READE     SECOCCL0                               89
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * P023  : View/Change Option(s)                                 *
      *****************************************************************
      *
     C     P023          BEGSR
      *
     C                   MOVE      'Y'           ERROR
      *
     C     #1COAT        CHAIN     SECOATL0                           89
      *
     C                   MOVE      *BLANKS       P#RTCD
      *
     C                   MOVE      #1EXDT        DateIn
     C                   EXSR      ZDATE1
     C                   MOVE      DAYNOOUT      WEXDAT
      *
     C                   MOVE      *BLANKS       WNBOP
     C                   MOVE      #1NBOP        WNBOP             2
     C                   MOVE      #1NBOP        SNBOP             2
      *
     C     MMPTYP        IFEQ      'NF'
     C                   CALL      'SE7510'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1FINA                         Final Allocation Ind
     C                   PARM                    MMPTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    #1SEL                          Action
     C                   PARM                    P#RTCD            1            Return Code
     C                   ELSE
      *
     C     MMPTYP        IFEQ      'NC'
     C                   CALL      'SE7511'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1FINA                         Final Allocation Ind
     C                   PARM                    MMPTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    #1SEL                          Action
     C                   PARM                    P#RTCD            1            Return Code
     C                   ELSE
      *
     C     MMPTYP        IFEQ      'CC'
     C                   CALL      'SE7520'                             99
     C                   PARM                    #1REFN                         Ref.
     C                   PARM                    #1SECN                         Security
     C                   PARM                    #1COAT                         Type
     C                   PARM                    #1STAT                         Status
     C                   PARM                    #1FINA                         Alloc.
     C                   PARM                    MMPTYP                         Proc.
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    #1SEL                          Action
     C                   PARM                    P#RTCD            1            Return
     C                   ELSE
      *
     C                   CALL      'SE7599'                             99
     C                   PARM                    #1REFN                         ER Reference
     C                   PARM                    #1SECN                         Security Shortname
     C                   PARM                    #1COAT                         Corporate Action Typ
     C                   PARM                    #1STAT                         Corporate Action Sta
     C                   PARM                    #1FINA                         Final Allocation Ind
     C                   PARM                    MMPTYP                         Processing Type
     C                   PARM                    WEXDAT            5            Ex-Date
     C                   PARM                    WNBOP                          Number of Options
     C                   PARM                    #1SEL                          Action
     C                   PARM      'E'           WWEVDP            1            Events or Depots
     C                   PARM                    #1TDVD                         Trade/Value Position
     C                   PARM                    P#RTCD            1            Return Code
     C                   PARM      ' '           WWREX             1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If error indicator of the program call is on or if return
      ** code is equal to 'E' (Error), database error
      *
     C     *IN99         IFEQ      '1'
     C     P#RTCD        OREQ      'E'
      *
     C     MMPTYP        IFEQ      'NF'
     C                   MOVEL     NARR(2)       DBKEY            29
     C                   ELSE
     C     MMPTYP        IFEQ      'NC'
     C                   MOVEL     NARR(3)       DBKEY
     C                   ELSE
     C     MMPTYP        IFEQ      'CC'
     C                   MOVEL     NARR(7)       DBKEY
     C                   ELSE
     C                   MOVEL     NARR(1)       DBKEY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVEL     '009'         DBASE             3 0          *****************
     C                   MOVEL     *BLANKS       DBFILE           10            ** DB ERROR 09 **
     C                   EXSR      *PSSR                                        *****************
     C                   ENDIF
      *
      ** If Return code is equal to '2', '3'
      *
     C     P#RTCD        IFEQ      '3'
      *
      ** Access to ER Reference file with current Reference
      *
     C     #1REFN        CHAIN     SECORFL0                           88
      *
     C     *IN88         IFEQ      '0'
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
     C     MACHTP        IFNE      'R'
     C     MASTAT        ANDNE     'R'
     C     MASTAT        ANDNE     'C'
     C                   MOVE      'D'           MARECI
     C                   Z-ADD     BJRDNB        MALCD
     C                   MOVE      'A'           MACHTP
     C                   MOVE      ##USR         MALUID
     C                   ENDIF
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
     C                   ENDIF
      *
      ** Commitment Instruction
      *
     C                   COMMIT
     C                   ENDIF
      *
     C     P#RTCD        IFEQ      '3'
     C                   MOVE      '1'           *INKC
     C                   ELSE
     C     WWINPT        IFEQ      'Y'
     C                   MOVE      '1'           WIN12
     C                   ENDIF
     C                   ENDIF
      *
     C     WNBOP         IFNE      SNBOP
     C                   MOVE      '0'           WIN45
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P024  : Verify if the Option Exists                           *
      *****************************************************************
      *
     C     P024          BEGSR
      *
     C                   MOVE      '0'           *IN89
      *
     C     #1PTYP        IFEQ      'DV'
     C     KEY6          CHAIN     SECODVL0                           89
      *
     C                   ELSE
     C     #1PTYP        IFEQ      'FR'
     C     KEY6          CHAIN     SECOFRL0                           89
      *
     C                   ELSE
     C     #1PTYP        IFEQ      'CE'
     C     KEY6          CHAIN     SECOCEL0                           89
      *
     C                   ELSE
     C     #1PTYP        IFEQ      'CR'
     C     KEY6          CHAIN     SECOCRL0                           89
      *
     C                   ELSE
     C     #1PTYP        IFEQ      'OF'
     C     KEY6          CHAIN     SECOOFL0                           89
      *
     C                   ELSE
     C     #1PTYP        IFEQ      'RG'
     C     KEY6          CHAIN     SECORGL0                           89
      *
     C                   ELSE
     C     #1PTYP        IFEQ      'EX'
     C     KEY6          CHAIN     SECOEXL0                           89
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * P025  : Check that no Position Exists on Depot Positions file *
      *****************************************************************
      *
     C     P025          BEGSR
      *
     C                   MOVE      '0'           *IN89
      *
     C     #1SEL         IFEQ      'E'
     C     #1REFN        CHAIN     SECODPL1                           89
     C                   ELSE
     C     #1SEL         IFEQ      'V'
     C     #1REFN        CHAIN     SECOALL1                           89
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN89         IFEQ      '1'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00256'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
      *
     C     #1SEL         IFEQ      'N'
     C     #1SECN        CHAIN     DPOSS                              89
      *
     C     *IN89         IFEQ      '0'
     C                   MOVE      'Y'           ERMSG
     C                   MOVE      '1'           *IN62                          Reverse image
     C                   MOVEL     'CO00255'     ZAMSID                         Message id.
     C                   EXSR      ZASNMS                                       Send message
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE1   - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     ZDATE1        BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZDATE2 - Format a Date for Screen Output                     *
      *                                                               *
      *****************************************************************
     C     ZDATE2        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLanks       ZADATE
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZALIGN - Validate/Right align numeric field                  *
      *                                                               *
      *****************************************************************
     C     ZALIGN        BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZSEDIT - Format Amount for Display                           *
      *                                                               *
      *****************************************************************
     C     ZSEDIT        BEGSR
      *
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   EVAL      ZFLD15 = *ZEROS
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ZASIGN - Validate/Right align signed numeric fields          *
      *                                                               *
      *****************************************************************
     C     ZASIGN        BEGSR
      *
     C                   CALLB     'ZASIGN'
     C                   PARM      'Y'           ZAsignOk
     C                   PARM                    ZFLD17
     C                   PARM                    ZSDIG
     C                   PARM                    ZSDEC
     C                   PARM                    ZSDCSP
     C                   PARM                    ZOUT15
     C                   PARM                    ZFSIGN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      *  ZASNMS : Send Message to Program's Message Queue            *
      ****************************************************************
      *
     C     ZASNMS        BEGSR
      *
      **   message file specified use PMSGF
      *
     C                   MOVEL     PMSGF         ZAMSGF
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM            10            Program queue
     C                   PARM                    ZAPGRL            5            Rel queue
     C                   PARM                    ZAMSID            7            Message Id.
     C                   PARM                    ZAMSGF           10            Message file.
     C                   PARM                    ZAMSDA          132            Message data.
     C                   PARM                    ZAMSTP            7            Message type.
      *
      ** Clear all fields for default mechanism next time.
      *
     C                   MOVEL     *BLANK        ZAPGM                          Program queue
     C                   MOVEL     *BLANK        ZAPGRL                         Rel queue
     C                   MOVEL     *BLANK        ZAMSDA                         Message data.
     C                   MOVEL     *BLANK        ZAMSTP                         Message type.
     C                   MOVEL     *BLANK        ZAMSGF                         Message file
     C                   MOVEL     *BLANK        ZAMSID                         Message id.
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - TO PROCESS ABNORMAL END OF PROGRAM                    *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Update LDA with error information
      *
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     DBFILE        WWFILE
     C                   MOVEL     DBKEY         WWKEY
     C                   MOVEL     DBPGM         WWPGM
     C                   MOVEL     DBASE         WWASE
     C                   OUT       LDA
      *
      ** Rollback changes, print dump and cancel program
      *
     C                   ROLBK
     C                   DUMP
      *
      ** Try ti release corporate action by access to ER reference file
      ** if current ER Reference is not blank
      *
     C     #1REFN        IFNE      *BLANKS
     C     #1REFN        SETLL     SECORFL0
     C                   READ      SECORFL0                               89
      *
      ** If the record exists
      *
     C     *IN89         IFEQ      '0'
      *
     C                   MOVE      *BLANKS       MAJOBN
     C                   MOVE      *BLANKS       MAUSER
     C                   Z-ADD     *ZEROS        MAJNBR
      *
      ** Update the record
      *
     C                   UPDATE    SECORFD0
     C                   MOVE      FIELD         #FIELD
      *
      ** Commitment instruction
      *
     C                   COMMIT
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   CALL      'DBERRCTL'
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA TXT
F3=Exit  F5=Refresh Screen  F11=View Option(s) Rollup/Rolldown
F3=Exit  F5=Refresh Screen  F9=Go to 'Change' Mode  Rollup/Rolldown
F3=Exit  F5=Refresh Screen  F9=Go to 'Add' Mode  Rollup/Rolldown
F3=Exit  F11=View Option(s)  F12=Previous
F3=Exit  F11=Change Option(s)  F12=Previous
F3=Exit  F12=Previous
F3=Exit  F11=View Option(s)    F12=Previous  F8=Subordinate Action
F3=Exit  F11=Change Option(s)  F12=Previous  F8=Subordinate Action
F3=Exit  F5=Refresh  F9=Go to 'Add' Mode  Rollup/Rolldown  F12=Parent Action
F3=Exit  F5=Refresh  F9=Go to Change Mode  Rollup/Rolldown  F12=Parent Action
F3=Exit  F5=Refresh            F12=Parent Action  Rollup/Rolldown
**CTDATA NARR
ERROR CALL PGM 'SE7599'
ERROR CALL PGM 'SE7510'
ERROR CALL PGM 'SE7511'
OPTION SHORTNAME NUMBER
ERROR CALL PGM 'SE7512'
ERROR CALL PGM 'SE7514'
ERROR CALL PGM 'SE7520'
ERROR CALL PGM 'SE7533'
ERROR CALL PGM 'SE7540'
