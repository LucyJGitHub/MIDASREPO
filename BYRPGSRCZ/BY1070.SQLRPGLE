     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Futures & Options Extract Criteria Maint')   *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY1070 - BoE Futures and Options Extract Criteria Maintenance*
      *                                                               *
      *  Function:  This program allows the user to display, amend,   *
      *  insert or delete the Product Code after entering certain     *
      *  parameters (Processing Type, Book Code, Market Centre Code,  *
      *  Instrument Type and Industry Code)
      *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022             Date 24Jan05               *
      *                 LLN012             Date 23Oct03               *
      *                 LLN021  *Create    Date 23OCT03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  LLN012 - Additional BoE Changes (Patch B)                    *
      *  LLN021 - *Create                                             *
      *                                                               *
      *****************************************************************
      *  Indicators Used:                                             *
      *                                                               *
      *  03 - F3,  exit program                                       *
      *  10 - F10, delete                                             *
      *  12 - F12, previous screen                                    *
      *  31 - For action code 'I' (Insert)                            *
      *  32 - For action code 'A' (Amend)                             *
      *  33 - For action code 'D' (Delete)                            *
      *  34 - For action code 'E' (Enquire)                           *
      *  50 to 56 - Error highlighter for invalid screen fields       *
      *  61 - Error indicator for Invalid 'Fee Type' (credit)         *
      *  62 - Error indicator for Null entry in 'Fee Type' fld (credit*
      *  63 - Error indicator for Invalid 'Fee Type' (Debit)          *
      *  64 - Error indicator for Null entry in 'Fee Type' fld (debit)*
      *  90 - General work indicator                                 *
      *****************************************************************
      *
      * Futures & Options Extract
     F***BYFFEXPPUF  E           K        DISK         KINFSR *PSSR A                         LLN022
     FBYFFEXPP  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(BYFFEXD0:BYFFEXD1)
     FBYFFEXV0  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
      *
     FBY1070DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(INFDS#)
      *
     FBYBOOKY0  IF   E           K DISK    INFSR(*PSSR)
      * Book Codes
      *
     F*BYINSTV0* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
      * Institution Codes
      *
     FINTYP2    IF   E           K DISK    INFSR(*PSSR)
      * Instrument Types
      *
     F*BYINDRV0* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
      * Industry Codes File
      *
     FMARKT     IF   E           K DISK    INFSR(*PSSR)
      * Market Centres File
      *
      /EJECT
      *
      *  Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D*COPY*ZSRSRC,ZALIGNZ1                                                                 MD058068
     D/COPY ZSRSRC,ZALIGNZ1LE                                                               MD058068
      *
      /SPACE 3
      *
      *  Constant name for message file
     D ULMGFN          C                   CONST('GBBYUSRMSG')
      *
      *  Constant name for all allowable characters.                      LLN021
     D W#DGTS          C                   CONST('0123456789')                  LLN021
      *
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Data Structure using Bank file format
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  ULPGM            *PROC
     D  ULWSID               244    253
     D  ULUSER               254    263
      *
      * File information data structure (for database files only)
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      *
      * Display file information data structure  (for display files only)
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
      *
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D BYINDR        E DS                  EXTNAME(BYINRJW0)                                MD058068
     D BYINST        E DS                  EXTNAME(BYINTJW0)                                MD058068
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Main Processing                                               *
      *                                                               *
      * Calls: SR/#LMAIN - Detail Processing                          *
      *        SR/#LTERM - Termination Processing                     *
      *                                                               *
      *****************************************************************
      *
      *
      *  Main Processing
     C                   EXSR      #LMAIN
      *
      *
      *  Termination Processing
     C                   EXSR      #LTERM
      *
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * #LMAIN - Main Detail Processing                               *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LMAIN        BEGSR                                                  ** SR/#LDETL**
      *
      *  Process initial screen until CF03 is pressed
     C     *IN03         DOWEQ     *OFF
      *
      *   Display screen
     C                   WRITE     #MSGCTL
     C                   EXFMT     BY1070F1
      *
      *   Clear message subfile
     C                   EXSR      #LCLMG
      *
      *   CF03 - Exit program
     C     *IN03         IFEQ      *ON
     C                   EXSR      #LTERM
     C                   ENDIF
      *
      *   Validate initial screen details
     C                   EXSR      #LVALI
      *
      *   Initial screen valid
     C     ULVALI        IFEQ      'Y'
      *
      *    Display and validate detail screen
     C                   EXSR      #LDETL
      *
      *    Detail screen valid
     C     ULVALD        IFEQ      'Y'
      *
      *    Update database
     C                   EXSR      #LUPDT
      *
      *    Reset initial screen if update sucessful
     C     ULUPDI        IFEQ      'Y'
     C                   EXSR      #LRSET
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LRSET - Reset Screen Fields and Indicators                   *
      *                                                               *
      * Called by: SR/#LMAIN - Main Detail Processing                 *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     #LRSET        BEGSR
      *
      ** Reset error indicators
     C                   MOVEA     '0000'        *IN(50)
     C                   MOVEA     '000000'      *IN(58)
     C                   MOVE      *OFF          *IN(66)
      *
      ** Reset fields
     C                   MOVE      *BLANKS       L#ACTN
     C                   MOVE      *BLANKS       L#PROC
     C                   MOVE      *BLANKS       L#BOOK
     C                   MOVE      *BLANKS       L#MKCC
     C                   MOVE      *BLANKS       L#INST
     C                   MOVE      *BLANKS       L#LINS
     C                   MOVE      *BLANKS       L#MIND
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LVALI - Validate Initial Screen                              *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Detail Processing                *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LVALI        BEGSR                                                  ** SR/#LVALI**
      *
      *   Reset work fields and indicators
     C                   MOVE      'Y'           ULVALI
     C                   MOVEA     '00000'       *IN(31)
     C                   MOVEA     '000000'      *IN(50)
     C                   MOVEA     '0000'        *IN(56)
      *
      ** Validate Action Code
     C     L#ACTN        IFNE      'I'
     C     L#ACTN        ANDNE     'A'
     C     L#ACTN        ANDNE     'D'
     C     L#ACTN        ANDNE     'E'
     C                   MOVE      'BYM0051'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN50
     C                   MOVE      'N'           ULVALI
     C                   ELSE
     C     L#ACTN        IFEQ      'E'
     C     L#ACTN        OREQ      'D'
     C                   MOVE      *ON           *IN66
     C                   ELSE
     C                   MOVE      *OFF          *IN66
     C                   ENDIF
     C                   ENDIF
      *
      ** If Entered then Validate Processing Code
     C     L#PROC        IFNE      *BLANKS
     C     L#PROC        IFLT      '1'
     C     L#PROC        ORGT      '8'
     C                   MOVE      'BYM0125'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN51
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Book Code if entered
     C     L#BOOK        IFNE      *BLANKS
     C     L#BOOK        CHAIN     BYBOOKY0                           90
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0122'     ULMSID
     C                   MOVE      *ON           *IN52
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Market Centre code if entered
     C     L#MKCC        IFNE      *BLANKS
     C     L#MKCC        CHAIN     MARKT                              90
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0123'     ULMSID
     C                   MOVE      *ON           *IN53
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate Instrument Type code if entered
     C     L#INST        IFEQ      '?  '
     C     L#INST        OREQ      ' ? '
     C     L#INST        OREQ      '  ?'
     C                   MOVE      'N'           ULVALI
     C                   CALL      'BY9250'
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C     L#INST        PARM      *BLANKS       ULINST
     C                   ELSE
      *
     C     L#INST        IFNE      *BLANKS
     C     L#MKCC        CAT       L#INST        INSTKY            5
     C     INSTKY        CHAIN     INTYP2                             90
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0124'     ULMSID
     C                   MOVE      *ON           *IN54
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Institution Code
      **    Call institution code selection screen
     C     L#LINS        IFEQ      '? '
     C     L#LINS        OREQ      ' ?'
     C                   CALL      'BY9230'
     C                   PARM                    P@RTCD
     C     L#LINS        PARM      *BLANKS       ULLINS
     C                   MOVE      'N'           ULVALI
     C                   ELSE
      *
      **    If entered, check Institution code is numeric and                       LLN021
      **    Check institution code exists on Master File
     C     L#LINS        IFNE      *BLANKS
      *
     C     W#DGTS        CHECK     L#LINS                                 90
     C     *IN90         IFEQ      *OFF
     C                   MOVE      L#LINS        LAINSC                         Inst Code in BYINSTV
     C*****LAINSC        CHAIN     BYINSTV0                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYINST                                                                        MD058068
     C+ from BYINTJW0                                                                       MD058068
     C+ where LAINSC = :LAINSC                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C                   SETOFF                                       90                    MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   SETON                                        90                    MD058068
     C                   ENDIF                                                              MD058068
     C                   ENDIF
      *
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0053'     ULMSID
     C                   MOVE      *ON           *IN55
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Industry Code
      **    Call industry code selection screen
     C     L#MIND        IFEQ      '?  '
     C     L#MIND        OREQ      ' ? '
     C     L#MIND        OREQ      '  ?'
     C                   MOVE      'N'           ULVALI
     C                   CALL      'BY9240'
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C     L#MIND        PARM      *BLANKS       ULMIND
     C                   ELSE
      *
      **    Check industry code exists on Master File
     C     L#MIND        IFNE      *BLANKS
     C                   MOVE      L#MIND        L9MIND
     C*****L9MIND        CHAIN     BYINDRV0                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYINDR                                                                        MD058068
     C+ from BYINRJW0                                                                       MD058068
     C+ where LCMIND = :L9MIND                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0073'     ULMSID
     C                   MOVE      *ON           *IN56
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     L#LINS        IFEQ      *BLANKS
     C     L#MIND        ANDNE     *BLANKS
     C                   MOVE      'BYM0154'     ULMSID
     C                   MOVE      *ON           *IN53
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      *
      *
      *   If screen details are valid then check whether records exists
      *   on BYFFEXPP according to action code
     C     ULVALI        IFEQ      'Y'
     C                   MOVE      L#PROC        K1PROC
     C                   MOVE      L#BOOK        K1BOOK
     C                   MOVE      L#MKCC        K1MKCC
     C                   MOVE      L#INST        K1INST
     C                   MOVE      L#LINS        K1LINS
     C                   MOVE      L#MIND        K1MIND
     C     KEY1          CHAIN(N)  BYFFEXPP                           90
     C     *IN90         DOWEQ     '0'
     C     L9RECI        ANDNE     'D'
     C     KEY1          READE     BYFFEXPP                               90
     C     *IN90         IFEQ      '1'
     C                   SETOFF                                       90
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
      *    If action is Insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
     C     L9RECI        ANDEQ     'D'
     C                   MOVE      'BYM0075'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      *    If action is not Insert record must exist
     C     L#ACTN        IFNE      'I'
     C     *IN90         ANDEQ     *ON
     C                   MOVE      'BYM0076'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      **   If action is not Insert, record must be live
     C     L#ACTN        IFNE      'I'
     C     *IN90         ANDEQ     *OFF
     C     L9RECI        ANDNE     'D'
     C                   MOVE      'BYM0086'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      ** If initial screen is valid
     C     ULVALI        IFEQ      'Y'
      *
      **  Load screen fields for display
     C     L#ACTN        IFEQ      'A'
     C     L#ACTN        OREQ      'E'
     C     L#ACTN        OREQ      'D'
     C                   Z-ADD     L9ACIR        L#ACIR
     C                   Z-ADD     L9ACIP        L#ACIP                                        LLN01
     C                   Z-ADD     L9PRLS        L#PRLS                                        LLN01
     C***                  Z-ADDL9CHRG    L#CHRG                          LLN012
     C***                  MOVELL9FTYP    L#FTYP                          LLN012
     C                   Z-ADD     L9CCHG        L#CCHG                         Credit Chrg    LLN01
     C                   MOVEL     L9CFEE        L#CFEE                         Credit Fee Typ LLN01
     C                   Z-ADD     L9DCHG        L#DCHG                         Debit Charge   LLN01
     C                   MOVEL     L9DFEE        L#DFEE                         Debit Fee Type LLN01
      *
      ** Save details of Last Change Time and Date to compare against later
     C                   MOVE      L9LCD         ULLCD             5 0
     C                   MOVE      L9UTIM        ULUTIM            6 0
     C                   ENDIF
      *
      *   Set screen conditioning indicator
     C                   SELECT
     C     L#ACTN        WHENEQ    'I'                                          Insert
     C                   MOVE      *ON           *IN31
     C     L#ACTN        WHENEQ    'A'                                          Amend
     C                   MOVE      *ON           *IN32
     C     L#ACTN        WHENEQ    'D'                                          Delete
     C                   MOVE      *ON           *IN33
     C     L#ACTN        WHENEQ    'E'                                          Enquire
     C                   MOVE      *ON           *IN34
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LDETL - Display and Validate Detail Screen                   *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls: #LVALD, #LCLMG                                        *
      *                                                               *
      *****************************************************************
      *
     C     #LDETL        BEGSR                                                  ** SR/#LDETL**
      *
      *  Reset work indicators and indicators
     C                   MOVE      'N'           ULVALD
     C                   MOVE      *OFF          *IN54
     C                   MOVE      *OFF          *IN55                                         LLN01
     C                   MOVE      *OFF          *IN56                                         LLN01
      *
      *  Reset function key indicators
     C                   MOVE      *OFF          *IN10
     C                   MOVE      *OFF          *IN12
      *
      *  Process detail until valid  or previous screen requested
     C     ULVALD        DOWEQ     'N'
     C     *IN03         ANDEQ     *OFF
     C     *IN12         ANDEQ     *OFF
      *
      *
      *   Display detail screen
     C                   WRITE     #MSGCTL
     C                   EXFMT     BY1070F2
      *
      *   Clear message subfile
     C                   EXSR      #LCLMG
      *
      **  CF03 - Exit program
     C     *IN03         IFEQ      *ON
     C                   EXSR      #LTERM
     C                   ENDIF
      *
      **  CF12 - Previous screen requested
      **         Clear initial screen for redisplay
     C     *IN12         IFEQ      *ON
     C                   EXSR      #LRSET
     C                   ENDIF
      *
      ** CF10 - Delete details. Enter update subroutine without
      ** entering validation subroutine
     C     *IN10         IFEQ      *ON
     C                   MOVE      'Y'           ULVALD
     C                   ENDIF
      *
      ** Validate detail screen if action is either 'I - Insert'
      ** or 'A - Amend'
     C     L#ACTN        IFEQ      'I'
     C     L#ACTN        OREQ      'A'
     C                   EXSR      #LVALD
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LVALD - Validate Detail Screen                              *
      *                                                               *
      * Called by:  SR/#LDETL - Display Detail Screen                 *
      *                                                               *
      * Calls: #LSNMG                                                 *
      *                                                               *
      *****************************************************************
      *
     C     #LVALD        BEGSR                                                  ** SR/#LVALD**
      *
      ** Reset work fields and indicators
     C                   MOVE      'Y'           ULVALD
     C                   MOVE      *OFF          *IN61
     C                   MOVE      *OFF          *IN62                                         LLN01
     C                   MOVE      *OFF          *IN63
     C                   MOVE      *OFF          *IN64                                         LLN01
      *
      *
      *   Validate Credit Fee Type
     C     L#CFEE        IFNE      'NI'
     C     L#CFEE        ANDNE     'IS'
     C     L#CFEE        ANDNE     'CB'
     C     L#CFEE        ANDNE     'CU'
     C     L#CFEE        ANDNE     'DV'
     C     L#CFEE        ANDNE     'FX'
     C     L#CFEE        ANDNE     'BC'
     C     L#CFEE        ANDNE     'OT'
     C     L#CFEE        ANDNE     '  '
     C                   MOVE      'BYM0152'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN61
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *   Validate Debit Fee Type
     C     L#DFEE        IFNE      'NI'
     C     L#DFEE        ANDNE     'IS'
     C     L#DFEE        ANDNE     'CB'
     C     L#DFEE        ANDNE     'CU'
     C     L#DFEE        ANDNE     'DV'
     C     L#DFEE        ANDNE     'FX'
     C     L#DFEE        ANDNE     'BC'
     C     L#DFEE        ANDNE     'OT'
     C     L#DFEE        ANDNE     '  '
     C                   MOVE      'BYM0152'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN63
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *
      *   If Credit Charges entered, the Credit Fee is mandatory
     C     L#CCHG        IFNE      0
     C     L#CFEE        ANDEQ     *BLANKS
     C                   MOVE      'BYM0156'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN62
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *   If Debit Charges entered, the Debit Fee is mandatory
     C     L#DCHG        IFNE      0
     C     L#DFEE        ANDEQ     *BLANKS
     C                   MOVE      'BYM0156'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN64
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LUPDT - Update Database                                      *
      *                                                               *
      * Called by:  SR/#LMAIN - Main Processing                       *
      *                                                               *
      * Calls: #LSNMG,                                                *
      *                                                               *
      *****************************************************************
      *
     C     #LUPDT        BEGSR                                                  ** SR/#LDETL**
      *
      *   Reset work fields
     C                   MOVE      'Y'           ULUPDI                         Update flag
      *
      *   Read record from BYFFEXPP
     C********** KEY1      CHAINBYFFEXPP             90                                       LLN022
     C     KEY1          CHAIN     BYFFEXV0                           90
      *
      *  If action is insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
     C                   MOVE      'BYM0077'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULUPDI                         Update flag
     C                   ENDIF
      *
      *  If action is not insert record must exist
     C     L#ACTN        IFNE      'I'
     C     *IN90         ANDEQ     *ON
     C                   MOVE      'BYM0079'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULUPDI                         Update flag
     C                   ENDIF
      *
      ** Check if file has been updated by another user
     C     L#ACTN        IFNE      'I'
     C     *IN90         ANDEQ     *OFF
     C     ULLCD         IFNE      L9LCD
     C     ULUTIM        ORNE      L9UTIM
     C                   MOVE      'BYM0078'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULUPDI
     C                   ENDIF
     C                   ENDIF
      *
      *  If valid for update then move values to file fields
     C     ULUPDI        IFEQ      'Y'
      *
     C     L#ACTN        IFEQ      'D'
     C                   MOVE      '*'           L9RECI
     C                   ELSE
     C                   MOVE      'D'           L9RECI
     C                   MOVE      L#PROC        L9PROC
     C                   MOVE      L#BOOK        L9BOOK
     C                   MOVE      L#MKCC        L9MKCC
     C                   MOVEL     L#INST        L9INST
     C                   MOVE      L#LINS        L9LINS
     C                   MOVE      L#MIND        L9MIND
     C                   Z-ADD     L#ACIR        L9ACIR
     C                   Z-ADD     L#ACIP        L9ACIP
     C                   Z-ADD     L#PRLS        L9PRLS
     C****                 Z-ADDL#CHRG    L9CHRG
     C****                 MOVELL#FTYP    L9FTYP
     C                   Z-ADD     L#CCHG        L9CCHG                         Credit Chg
     C                   MOVEL     L#CFEE        L9CFEE                         Credit Fee
     C                   Z-ADD     L#DCHG        L9DCHG                         Debit Chg
     C                   MOVEL     L#DFEE        L9DFEE                         Debit Fee
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      L#ACTN        L9CHTP
     C                   MOVE      BJRDNB        L9LCD
     C                   TIME                    L9UTIM
      *
      ** Write or update file
     C     L#ACTN        IFEQ      'I'
     C                   WRITE     BYFFEXD0
     C                   ELSE
     C                   UPDATE    BYFFEXD0
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LTERM - Termination Processing                               *
      *                                                               *
      * Called by:  Main Processing                                   *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #LTERM        BEGSR                                                  ** SR/#LTERM**
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      /EJECT
      **************************************************************************
      *                                                               *
      * #LSNMG - Send Message to Program Message Queue                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      **************************************************************************
      *
     C     #LSNMG        BEGSR
      *
     C                   CALL      'Y2SNMGC'
     C                   PARM                    ULPGNM
     C                   PARM      '*SAME'       ULPGRL
     C                   PARM                    ULMSID
     C                   PARM                    ULMSGF
     C                   PARM                    ULMSDA
     C                   PARM                    ULMSTP
      *
     C                   ENDSR
      *
      /EJECT
      **************************************************************************
      *                                                               *
      * #LCLMG - Clear Program Message Queue                          *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      **************************************************************************
     C     #LCLMG        BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ULPGNM
     C                   PARM      '*SAME'       ULPGRL
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * #LDEFN - Field Definition Routine                             *
      *                                                               *
      * Called by:  None - Contains definitions only                  *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     #LDEFN        BEGSR                                                  ** SR/#LDEFN**
      *
      ** Define external data areas
     C     *DTAARA       DEFINE                  LDA
      *
      ** Define and initialise work fields
     C                   MOVE      *BLANK        ULRTCD            7            Return code
     C                   MOVE      *BLANK        ULINST            3            Instrument code
     C                   MOVE      *BLANK        ULLINS            2            Institution code
     C                   MOVE      *BLANK        ULMIND            3            Industry code
     C                   MOVE      *BLANK        ULERRI            1            Pgm error indicator
     C                   MOVE      *BLANK        P@RTCD            7
     C                   MOVE      *BLANK        P@OPTN            7
     C                   MOVEL     ULPGM         ULPGNM           10            PGM Q Name
     C                   MOVE      *BLANKS       ULPGRL            5
     C                   MOVE      ULMGFN        ULMSGF           10            Message File
     C                   MOVE      *BLANKS       ULMSID            7            Message Id
     C                   MOVE      *BLANKS       ULMSDA          132            Message Data
     C                   MOVE      *BLANKS       ULMSTP            7            Message Type
     C                   MOVE      'N'           ULVALI            1            Initial screen valid
     C                   MOVE      'N'           ULVALD            1            Detail screen valid?
     C                   MOVE      'N'           ULUPDI            1            Valid for update?
     C                   MOVE      *BLANKS       ULPCOD            4
     C                   MOVEA     CPY@          ULCPY@           80            Copyright
      *
      ** Redefine fields for use as a key list
     C     *LIKE         DEFINE    L9PROC        K1PROC
     C     *LIKE         DEFINE    L9BOOK        K1BOOK
     C     *LIKE         DEFINE    L9MKCC        K1MKCC
     C     *LIKE         DEFINE    L9INST        K1INST
     C     *LIKE         DEFINE    L9LINS        K1LINS
     C     *LIKE         DEFINE    L9MIND        K1MIND
      *
      ** Set up a key list based on fields from BYFFEXPP
     C     KEY1          KLIST
     C                   KFLD                    K1PROC                         Process type
     C                   KFLD                    K1BOOK                         Book Code
     C                   KFLD                    K1MKCC                         Mkt Centre Code
     C                   KFLD                    K1INST                         Instrument-Type
     C                   KFLD                    K1LINS                         Institution Code
     C                   KFLD                    K1MIND                         Industry Code
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
      *  Check if error has previously been reported
     C     ULERRI        IFEQ      *BLANK
     C                   MOVE      'Y'           ULERRI
     C                   MOVE      'Y'           ULRTCD
     C                   DUMP
     C                   ENDIF
      *
      *  Set on external indicators
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
      *
      *  Terminate program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      * Called by:  At program initialisation                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR                                                  ** *INZSR SR**
      *
     C     *ENTRY        PLIST
     C                   PARM                    ULRTCD
      *
      *  Get Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check Return Code
     C     P@RTCD        IFNE      *BLANKS
     C     BJTYLC        OREQ      'D'                                          ON-DELETED
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGM         DBPGM                          ************
     C                   MOVEL     '*NONE'       DBKEY                          * DBERR 01 *
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C                   END
      *
      *  Initialise work fields
     C                   EXSR      #LDEFN
      *
      *  Initial fields for display file
     C                   MOVEL     ULPGM         L#PGMQ           10
     C                   MOVEL     ULPGM         L#PGM
     C                   MOVEL     ULWSID        L#WSID
      *
      **  LLN021 check
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*VERIFY'     P@OPTN
     C                   PARM      'LLN021'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           LLN021            1
     C                   MOVE      *ON           *IN70
     C                   ELSE
     C                   MOVE      'N'           LLN021
     C                   MOVE      *OFF          *IN70
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
     C*COPY*ZSRSRC,ZALIGNZ2L                                                                MD058068
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058068
**  CPY@
(c) Finastra International Limited 1997
