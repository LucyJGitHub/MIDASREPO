     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Account Extract Criteria Maintenance')       *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY1010 - Account Extract Details Maintenance                 *
      *                                                               *
      *  Function:  This program allows the user to assign rules for  *
      *  each Account and Institution Code combination. These rules   *
      *  are then used to extract and categorise Accoutn details for  *
      *  the Bank of England returns                                  *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022             Date 24Jan05               *
      *                 LLN021             Date 03Oct97               *
      *                 122382             Date 03Oct97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE upgrade to MidasPlus                            *
      *  LLN021 - BoE Profit and Loss return                          *
      *  122382 - Message Subfile Indicator for end of subfile        *
      *           is displayed - **RECOMPILED** since change made     *
      *           to DSPF                                             *
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
      *  35 - Position cursor on Institution Code                     *
      *  50 to 52 - Error highlighter for initial screen fields       *
      *  53 to 58 - Error highlighters for detail screen fields       *
      *  90 - General work indicator                                  *
      *****************************************************************
      *
      * File description for files defined
     FBYACEXPP  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
      *
      * File description for files defined
     FBY1010DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(INFDS#)
     F*BYPRODPP* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
     F*BYINSTV0* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
      *                                                                   LLN021
     F*BYINDRV0* IF   E           K DISK    INFSR(*PSSR)                         LLN021     MD058068
     F**********                           USROPN                                           MD058068
      *
      /EJECT
      *
      *  Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      /SPACE 3
      *
      *  Constant name for message file
     D ULMGFN          C                   CONST('GBBYUSRMSG')
      *
      *  Constant name for all allowable characters.                      LLN021
     D W#DGTS          C                   CONST('0123456789')                  LLN021
      *
      ** Constants for account code field                                                     LLN022
     D C#ACD1          C                   CONST('?         ')
     D C#ACD2          C                   CONST(' ?        ')
     D C#ACD3          C                   CONST('  ?       ')
     D C#ACD4          C                   CONST('   ?      ')
     D C#ACD5          C                   CONST('    ?     ')
     D C#ACD6          C                   CONST('     ?    ')
     D C#ACD7          C                   CONST('      ?   ')
     D C#ACD8          C                   CONST('       ?  ')
     D C#ACD9          C                   CONST('        ? ')
     D C#ACD0          C                   CONST('         ?')
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
     D BYPROD        E DS                  EXTNAME(BYPRDJW0)                                MD058068
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
      *  If no errors, position cursor at first field
     C     *IN(50)       IFEQ      '000'
     C     LLN021        OREQ      'Y'                                                         LLN02
     C     *IN(50)       ANDEQ     '000'                                                       LLN02
     C     *IN59         ANDEQ     '0'                                                         LLN02
     C                   MOVE      *ON           *IN49
     C                   ELSE
     C                   MOVE      *OFF          *IN49
     C                   ENDIF
      *
      *   Display screen
     C                   WRITE     #MSGCTL
     C                   EXFMT     BY1010F1
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
      *    Reset screens if update sucessful
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
     C*****                MOVEA'000'     *IN,50                          LLN021
     C                   MOVEA     '00000000'    *IN(50)                                       LLN02
     C*****                MOVEA'00000'   *IN,58                          LLN021
     C                   MOVEA     '000000'      *IN(58)                                       LLN02
      *
      ** Reset fields
     C                   MOVE      *BLANKS       L#ACTN
     C                   MOVE      *BLANKS       L#ACOD
     C                   MOVE      *BLANKS       L#LINS
     C                   MOVE      *BLANKS       L#PCDR
     C                   MOVE      *BLANKS       L#PCCR
     C                   MOVE      *BLANKS       L#PCSP
     C                   MOVE      *BLANKS       L#ODIN
     C                   MOVE      *BLANKS       L#CCYI
     C                   MOVE      *BLANKS       L#MCAT
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      *BLANKS       L#MIND                                        LLN02
     C                   MOVE      *BLANKS       L#PLDR                                        LLN02
     C                   MOVE      *BLANKS       L#PLCR                                        LLN02
     C                   MOVE      *BLANKS       L#PLFT                                        LLN02
     C                   MOVE      *BLANKS       L#PLTP                                        LLN02
     C                   ENDIF                                                                 LLN02
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
     C                   MOVEA     '0000'        *IN(31)
     C*****                MOVEA'000'     *IN,50                          LLN021
     C                   MOVEA     '00000000'    *IN(50)                                       LLN02
     C                   MOVEA     '00000'       *IN(58)                                       LLN02
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
     C                   ENDIF
      *
      ** If selection screen is called, do not display detail screen
      ** this cycle. This allows the optional entry of Inst. code
     C********** L#ACOD    IFEQ '?   '                                                        LLN022
     C********** L#ACOD    OREQ ' ?  '                                                        LLN022
     C********** L#ACOD    OREQ '  ? '                                                        LLN022
     C********** L#ACOD    OREQ '   ?'                                                        LLN022
      ** Use constants to compare against L#ACOD since factor 2 in RPG                        LLN022
      ** can only accommodate 8 characters.                                                   LLN022
     C     L#ACOD        IFEQ      C#ACD1
     C     L#ACOD        OREQ      C#ACD2
     C     L#ACOD        OREQ      C#ACD3
     C     L#ACOD        OREQ      C#ACD4
     C     L#ACOD        OREQ      C#ACD5
     C     L#ACOD        OREQ      C#ACD6
     C     L#ACOD        OREQ      C#ACD7
     C     L#ACOD        OREQ      C#ACD8
     C     L#ACOD        OREQ      C#ACD9
     C     L#ACOD        OREQ      C#ACD0
     C                   MOVE      *ON           *IN35
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      ** Validate Account Code
     C                   CALL      'AOACODR0'                                   Access Program
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C                   PARM      '*KEY   '     @OPTN             7            Option
     C                   PARM                    L#ACOD                         Account code
     C                   PARM                    DSFDY                          Format
      *
      ** If *NRF is passed back through the return code, that Account Code
      ** does not exist
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'BYM0052'     ULMSID
     C                   MOVE      *ON           *IN51
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      ** Database error
     C     @RTCD         IFEQ      '*ERROR'
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGM         DBPGM                          ************
     C                   MOVEL(P)  L#ACOD        DBKEY                          * DBERR 02 *
     C                   MOVEL     'SDLOANL1'    DBFILE                         ************
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Account code must be entered
     C     L#ACOD        IFEQ      *BLANKS
     C                   MOVE      'BYM0111'     ULMSID
     C                   MOVE      *ON           *IN51
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      ** Validate Institution Code
      **    Call institution code selection screen
     C     L#LINS        IFEQ      '? '
     C     L#LINS        OREQ      ' ?'
     C                   MOVE      'N'           ULVALI
     C                   CALL      'BY9230'
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C     L#LINS        PARM      *BLANKS       ULLINS
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
     C                   MOVE      *ON           *IN52
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
      ** Validate Industry Code                                           LLN021
      **    Call industry code selection screen                           LLN021
     C     L#MIND        IFEQ      '?  '                                                       LLN02
     C     L#MIND        OREQ      ' ? '                                                       LLN02
     C     L#MIND        OREQ      '  ?'                                                       LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   CALL      'BY9240'                                                    LLN02
     C                   PARM      *BLANKS       @RTCD             7            Return Code    LLN02
     C     L#MIND        PARM      *BLANKS       ULMIND                                        LLN02
     C                   ELSE                                                                  LLN02
      *                                                                   LLN021
      **    Check industry code exists on Master File                     LLN021
     C     L#MIND        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#MIND        L1MIND                         Inst Code in BYLLN02
     C*****L1MIND        CHAIN     BYINDRV0                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYINDR                                                                        MD058068
     C+ from BYINRJW0                                                                       MD058068
     C+ where LCMIND = :L1MIND                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0073'     ULMSID                                        LLN02
     C                   MOVE      *ON           *IN59                                         LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C     L#LINS        IFEQ      *BLANKS                                                     LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C                   MOVE      'BYM0154'     ULMSID                                        LLN02
     C                   MOVE      *ON           *IN52                                         LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *
      *   If screen details are valid then check whether records exists
      *   on BYACEXPP according to action code
     C     ULVALI        IFEQ      'Y'
     C                   MOVE      L#ACOD        K1ACOD
     C                   MOVE      L#LINS        K1LINS
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      L#MIND        K1MIND                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     KEY1          CHAIN(N)  BYACEXPP                           90
      *
      *    If action is Insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
     C     L1RECI        ANDEQ     'D'
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
      **   If action is not Insert, Record must be live
     C     L#ACTN        IFNE      'I'
     C     *IN90         ANDEQ     *OFF
     C     L1RECI        ANDNE     'D'
     C                   MOVE      'BYM0086'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      **  If initial screen is valid
     C     ULVALI        IFEQ      'Y'
      *
      **   Load screen fields for display
     C     L#ACTN        IFEQ      'A'
     C     L#ACTN        OREQ      'E'
     C     L#ACTN        OREQ      'D'
     C                   MOVE      L1PCDR        L#PCDR
     C                   MOVE      L1PCCR        L#PCCR
      *
     C     L1PCSP        IFEQ      0
     C                   MOVE      *BLANKS       L#PCSP
     C                   ELSE
     C                   MOVE      L1PCSP        L#PCSP
     C                   ENDIF
      *
     C                   MOVE      L1ODIN        L#ODIN
     C                   MOVE      L1CCYI        L#CCYI
     C                   MOVE      L1MCAT        L#MCAT
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L1PLDR        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLDR                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L1PLDR        L#PLDR                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     L1PLCR        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLCR                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L1PLCR        L#PLCR                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      L1PLFT        L#PLFT                                        LLN02
     C                   MOVE      L1PLTP        L#PLTP                                        LLN02
     C                   ENDIF                                                                 LLN02
      *
      ** Save details of Last Change Time and Date
     C                   MOVE      L1LCD         ULLCD             5 0
     C                   MOVE      L1UTIM        ULUTIM            6 0
     C                   ENDIF
      *
      **  Default maturity category if blank
     C     L#MCAT        IFEQ      *BLANK
     C                   MOVE      'A'           L#MCAT
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
     C                   MOVEA     '000000'      *IN(53)
     C                   MOVEA     '0000'        *IN(59)                                       LLN02
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
     C                   EXFMT     BY1010F2
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
      *   Reset work fields and indicators
     C                   MOVE      'Y'           ULVALD
     C                   MOVEA     '000000'      *IN(53)
     C                   MOVEA     '0000'        *IN(59)                                       LLN02
      *
      *
      ** Validate Product Code - Debit
      **    Selection screen called for Product Code: Debit
     C     L#PCDR        IFEQ      '?   '
     C     L#PCDR        OREQ      ' ?  '
     C     L#PCDR        OREQ      '  ? '
     C     L#PCDR        OREQ      '   ?'
     C                   CALL      'BY9220'
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C     L#PCDR        PARM      *BLANKS       ULPCOD
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      **    Product code (debit) must be entered
     C     L#PCDR        IFEQ      *BLANKS
     C                   MOVE      'BYM0080'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN53
     C                   MOVE      'N'           ULVALD
     C                   ELSE
      *
      **    If entered must be valid product code
     C                   MOVE      L#PCDR        LDPCOD                         Prod Code in BYPRODP
     C*****LDPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0083'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN53
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
      **  Validate Product Code - Credit
      **    Selection screen called for Product Code: Credit
     C     L#PCCR        IFEQ      '?   '
     C     L#PCCR        OREQ      ' ?  '
     C     L#PCCR        OREQ      '  ? '
     C     L#PCCR        OREQ      '   ?'
     C                   CALL      'BY9220'
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C     L#PCCR        PARM      *BLANKS       ULPCOD
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *
      **    Default to Debit Product Code if not entered
     C     L#PCCR        IFEQ      *BLANKS
     C     *IN53         ANDEQ     *OFF
     C                   MOVE      L#PCDR        L#PCCR
     C                   MOVE      'N'           ULVALD
     C                   ELSE
      *
      **    Credit product code must be entered
     C     L#PCCR        IFEQ      *BLANKS
     C                   MOVE      'BYM0081'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN54
     C                   MOVE      'N'           ULVALD
     C                   ELSE
      *
      **    If entered must be valid product code
     C                   MOVE      L#PCCR        LDPCOD                         Prod Code in BYPRODP
     C*****LDPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0084'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN54
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Validate Product Code - Supplementary
      **    Selection screen called for Product Code: Supplementary
     C     L#PCSP        IFEQ      '?   '
     C     L#PCSP        OREQ      ' ?  '
     C     L#PCSP        OREQ      '  ? '
     C     L#PCSP        OREQ      '   ?'
     C                   CALL      'BY9220'
     C                   PARM      *BLANKS       @RTCD             7            Return Code
     C     L#PCSP        PARM      *BLANKS       ULPCOD
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      **   Must be valid product code if entered
     C     L#PCSP        IFNE      *BLANKS
     C                   MOVE      L#PCSP        LDPCOD                         Prod Code in BYPRODP
     C*****LDPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0085'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN55
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
     C                   ENDIF
      *
      *
      *   Validate Overdue Indicator
     C     L#ODIN        IFNE      *BLANKS
     C     L#ODIN        ANDNE     'Y'
     C                   MOVE      'BYM0047'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN56
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *
      *   Validate Currency Override
     C     L#CCYI        IFNE      'S'
     C     L#CCYI        ANDNE     'E'
     C     L#CCYI        ANDNE     'O'
     C     L#CCYI        ANDNE     ' '
     C                   MOVE      'BYM0049'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN57
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      *
      *   Validate Maturity Category
     C     L#MCAT        IFEQ      *BLANKS
     C                   MOVE      'A'           L#MCAT                         Default
     C                   ELSE
     C     L#MCAT        IFLT      'A'
     C     L#MCAT        ORGT      'J'
     C                   MOVE      'BYM0050'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN58
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
     C                   ENDIF
      *                                                                   LLN021
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
      ** Validate PL Product Code - Debit Entries                         LLN021
      **    Selection screen called for Product Code: Debit Entries       LLN021
     C     L#PLDR        IFEQ      '?   '                                                      LLN02
     C     L#PLDR        OREQ      ' ?  '                                                      LLN02
     C     L#PLDR        OREQ      '  ? '                                                      LLN02
     C     L#PLDR        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       @RTCD             7            Return Code    LLN02
     C     L#PLDR        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **   Must be valid product code if entered                          LLN021
     C     L#PLDR        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLDR        LDPCOD                         Prod Code in BYLLN02
     C*****LDPCOD        CHAIN     BYPRODPP                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0150'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN60                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      ** Validate PL Product Code - Credit Entries                        LLN021
      **    Selection screen called for Product Code: Credit Entries      LLN021
     C     L#PLCR        IFEQ      '?   '                                                      LLN02
     C     L#PLCR        OREQ      ' ?  '                                                      LLN02
     C     L#PLCR        OREQ      '  ? '                                                      LLN02
     C     L#PLCR        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       @RTCD             7            Return Code    LLN02
     C     L#PLCR        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **   Must be valid product code if entered                          LLN021
     C     L#PLCR        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLCR        LDPCOD                         Prod Code in BYLLN02
     C*****LDPCOD        CHAIN     BYPRODPP                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0151'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN61                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      *   Validate Fee Type                                               LLN021
     C     L#PLFT        IFNE      *BLANKS                                                     LLN02
      *                                                                   LLN021
     C     L#PLFT        IFNE      'NI'                                                        LLN02
     C     L#PLFT        ANDNE     'IS'                                                        LLN02
     C     L#PLFT        ANDNE     'CB'                                                        LLN02
     C     L#PLFT        ANDNE     'CU'                                                        LLN02
     C     L#PLFT        ANDNE     'DV'                                                        LLN02
     C     L#PLFT        ANDNE     'FX'                                                        LLN02
     C     L#PLFT        ANDNE     'BC'                                                        LLN02
     C     L#PLFT        ANDNE     'OT'                                                        LLN02
     C                   MOVE      'BYM0152'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN62                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *   Validate Type of Provision                                      LLN021
     C     L#PLTP        IFNE      *BLANKS                                                     LLN02
      *                                                                   LLN021
     C     L#PLTP        IFNE      'S'                                                         LLN02
     C     L#PLTP        ANDNE     'G'                                                         LLN02
     C                   MOVE      'BYM0162'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN63                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
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
     C     #LUPDT        BEGSR                                                  ** SR/#LUPDT**
      *
      *   Reset work fields
     C                   MOVE      'Y'           ULUPDI                         Update flag
      *
      *   Read record from BYACEXPP
     C     KEY1          CHAIN     BYACEXPP                           90
      *
      *  If action is insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
     C     L1RECI        ANDEQ     'D'
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
     C     ULLCD         IFNE      L1LCD
     C     ULUTIM        ORNE      L1UTIM
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
     C                   MOVE      '*'           L1RECI
     C                   ELSE
     C                   MOVE      'D'           L1RECI
     C                   MOVE      L#ACOD        L1ACOD
     C                   MOVE      L#LINS        L1LINS
     C                   MOVE      L#PCDR        L1PCDR
     C                   MOVE      L#PCCR        L1PCCR
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVEL     L#MIND        L1MIND                                        LLN02
     C                   MOVEL     L#PLDR        L1PLDR                                        LLN02
     C                   MOVEL     L#PLCR        L1PLCR                                        LLN02
     C                   MOVEL     L#PLFT        L1PLFT                                        LLN02
     C                   MOVE      L#PLTP        L1PLTP                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     L#PCSP        IFEQ      *BLANKS
     C                   Z-ADD     0             L1PCSP
     C                   ELSE
     C                   MOVE      L#PCSP        L1PCSP
     C                   ENDIF
     C                   MOVE      L#ODIN        L1ODIN
     C                   MOVE      L#CCYI        L1CCYI
     C                   MOVE      L#MCAT        L1MCAT
     C                   ENDIF
     C                   MOVE      L#ACTN        L1CHTP
     C                   MOVE      BJRDNB        L1LCD
     C                   TIME                    L1UTIM
      *
      ** Write or update file
     C********** L#ACTN    IFEQ 'I'                                                           LLN022
     C     *IN90         IFEQ      *ON
     C                   WRITE     BYACEXD0
     C                   ELSE
     C                   UPDATE    BYACEXD0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
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
     C                   MOVE      *BLANK        ULLINS            7            Institution code
     C                   MOVE      *BLANK        ULMIND            3            Industry code  LLN02
     C                   MOVE      *BLANK        ULPCOD            4            Product code
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
     C                   MOVEA     CPY@          ULCPY@           80            Copyright
      *
      ** Redefine fields for use as a key list
     C     *LIKE         DEFINE    L1ACOD        K1ACOD
     C     *LIKE         DEFINE    L1LINS        K1LINS
     C     *LIKE         DEFINE    L1MIND        K1MIND                                        LLN02
      *
      ** Set up a key list based on fields from BYACEXPP
     C     KEY1          KLIST
     C                   KFLD                    K1ACOD                         Account code
     C                   KFLD                    K1LINS                         Institution Code
     C                   KFLD                    K1MIND                         Industry Code  LLN02
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
      *                                                                   LLN021
      **  LLN021 check                                                    LLN021
     C                   CALL      'AOSARDR0'                                                  LLN02
     C                   PARM      *BLANK        @RTCD                                         LLN02
     C                   PARM      '*VERIFY'     @OPTN                                         LLN02
     C                   PARM      'LLN021'      @SARD             6                           LLN02
      *                                                                   LLN021
     C     @RTCD         IFEQ      *BLANK                                                      LLN02
     C                   MOVE      'Y'           LLN021            1                           LLN02
     C                   MOVE      *ON           *IN66                                         LLN02
     C**********         OPEN      BYINDRV0                                           LLN02 MD058068
     C                   ELSE                                                                  LLN02
     C                   MOVE      'N'           LLN021                                        LLN02
     C                   MOVE      *OFF          *IN66                                         LLN02
     C                   ENDIF                                                                 LLN02
      *
     C                   ENDSR
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 1997
