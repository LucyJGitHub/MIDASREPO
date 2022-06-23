     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Facility Extract Criteria Maintenance')      *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY1040 - Facility Extract Details Maintenance               *
      *                                                               *
      *  Function:  This program allows the user to assign rules for  *
      *  each Facility and Institution Code combination. These rules  *
      *  are then used to extract and categorise facility details for *
      *  the Bank of England returns                                  *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *  Last Amend No. CLE138             Date 02Nov21               *
      *  Prev Amend No. MD058068           Date 11May21               *
      *                 MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN021             Date 03Oct97               *
      *                 122382             Date 03Oct97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE138 - Class Code for Facilities                           *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN021 - BoE Industry Type                                   *
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
      *  50 to 52 - Error highlighter for initial screen fields       *
      *  53 - Error highlighter for 'Prod Code' on detail screen      *
      *  90 - General work indicator                                  *
      *****************************************************************
      *
      * File description for files defined
     FBYFCEXPP  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
      *
      * File description for files defined
     FBY1040DF  CF   E             WORKSTN INFSR(*PSSR)
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
     D*COPY*ZSRSRC,ZALIGNZ1                                               LLN021            MD058068
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
      *   Display screen
     C                   WRITE     #MSGCTL
     C                   EXFMT     BY1040F1
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
     C                   MOVEA     '000'         *IN(50)
     C                   MOVEA     '00'          *IN(61)                                       LLN02
     C                   MOVEA     '0'           *IN(59)                                       LLN02
      *
      ** Reset fields
     C                   MOVE      *BLANKS       L#ACTN
     C                   MOVE      *BLANKS       L#FCTP
     C                   MOVE      *BLANKS       L#LINS
     C                   MOVE      *BLANKS       L#PCOD
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      *BLANKS       L#MIND                                        LLN02
     C                   MOVE      *BLANKS       L#PLCG                                        LLN02
     C                   MOVE      *BLANKS       L#PLFT                                        LLN02
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
     C*******              MOVEA'00000'   *IN,31                          LLN021
     C                   MOVEA     '000000'      *IN(31)                                       LLN02
     C                   MOVEA     '000'         *IN(50)
     C                   MOVEA     '00'          *IN(61)                                       LLN02
     C                   MOVEA     '0'           *IN(59)                                       LLN02
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
     C     L#FCTP        IFEQ      '?  '
     C     L#FCTP        OREQ      ' ? '
     C     L#FCTP        OREQ      '  ?'
     C******               MOVE *ON       *IN35
     C                   MOVE      'N'           ULVALI
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
      ******If*entered,*check*code*exists*on*Master*File*******                     LLN021
      **    If entered, check Institution code is numeric and                       LLN021
      **    it exists on Master File.                                               LLN021
     C     L#LINS        IFNE      *BLANKS
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
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0053'     ULMSID
     C                   MOVE      *ON           *IN52
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ELSE
     C                   MOVE      *OFF          *IN35
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate Facility Type
     C                   CALL      'AOFACTR0'                                   Access Program
     C                   PARM      '*BLANKS'     @RTCD             7            Return Code
     C                   PARM      '*KEY   '     @OPTN             7            Option
     C                   PARM                    L#FCTP                         Facility type
     C                   PARM      '*BLANKS'     L#FCLS            4            CLE138
     C                   PARM                    DSFDY                          Format
      *
      ** If *NRF is passed back through the return code, that combination of
      ** details do not exist.
     C     @RTCD         IFEQ      '*NRF'
     C                   MOVE      'BYM0059'     ULMSID
     C                   MOVE      *ON           *IN51
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      ** Database error
     C     @RTCD         IFEQ      '*ERROR'
     C     *LOCK         IN        LDA
     C                   MOVEL     ULPGM         DBPGM                          ************
     C                   MOVE(P)   L#FCTP        DBKEY                          * DBERR 02 *
     C                   MOVEL     'SDLOANL1'    DBFILE                         ************
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Facility type must be entered
     C     L#FCTP        IFEQ      *BLANKS
     C                   MOVE      'BYM0110'     ULMSID
     C                   MOVE      *ON           *IN51
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   MOVE      *ON           *IN35
     C                   ENDIF
      *
      *
      *   If screen details are valid then check whether records exists
      *   on BYFCEXPP according to action code
     C     ULVALI        IFEQ      'Y'
     C                   MOVE      L#FCTP        K1FCTP
     C                   MOVE      L#LINS        K1LINS
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      L#MIND        K1MIND                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     KEY1          CHAIN(N)  BYFCEXPP                           90
      *
      *    If action is Insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
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
     C     L4RECI        ANDNE     'D'
     C                   MOVE      'BYM0086'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
     C*
     C                   ENDIF
      **
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
      ** Validate Industry Code                                           LLN021
      **    Call industry code selection screen                           LLN021
     C     L#MIND        IFEQ      '?  '                                                       LLN02
     C     L#MIND        OREQ      ' ? '                                                       LLN02
     C     L#MIND        OREQ      '  ?'                                                       LLN02
     C                   MOVE      *ON           *IN36
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   CALL      'BY9240'                                                    LLN02
     C                   PARM      *BLANKS       @RTCD             7            Return Code    LLN02
     C     L#MIND        PARM      *BLANKS       ULMIND                                        LLN02
     C                   ELSE                                                                  LLN02
      *                                                                   LLN021
      **    Check industry code exists on Master File                     LLN021
     C     L#MIND        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#MIND        L4MIND                         Inst Code in BYLLN02
     C*****L4MIND        CHAIN     BYINDRV0                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYINDR                                                                        MD058068
     C+ from BYINRJW0                                                                       MD058068
     C+ where LCMIND = :L4MIND                                                              MD058068
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
     C                   MOVE      *ON           *IN53                                         LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      *   If screen details are valid then check whether records exists   LLN021
      *   on BYFCEXPP according to action code                            LLN021
     C     ULVALI        IFEQ      'Y'                                                         LLN02
     C                   MOVE      L#FCTP        K1FCTP                                        LLN02
     C                   MOVE      L#LINS        K1LINS                                        LLN02
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      L#MIND        K1MIND                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     KEY1          CHAIN(N)  BYFCEXPP                           90                       LLN02
      *                                                                   LLN021
      *    If action is Insert record must not exist                      LLN021
     C     L#ACTN        IFEQ      'I'                                                         LLN02
     C     *IN90         ANDEQ     *OFF                                                        LLN02
     C                   MOVE      'BYM0075'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *    If action is not Insert record must exist                      LLN021
     C     L#ACTN        IFNE      'I'                                                         LLN02
     C     *IN90         ANDEQ     *ON                                                         LLN02
     C                   MOVE      'BYM0076'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **   If action is not Insert, record must be live                   LLN021
     C     L#ACTN        IFNE      'I'                                                         LLN02
     C     *IN90         ANDEQ     *OFF                                                        LLN02
     C     L4RECI        ANDNE     'D'                                                         LLN02
     C                   MOVE      'BYM0086'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *
      **   If initial screen is valid
     C     ULVALI        IFEQ      'Y'
      *
      **   Load screen fields for display
     C     L#ACTN        IFEQ      'A'
     C     L#ACTN        OREQ      'E'
     C     L#ACTN        OREQ      'D'
     C                   MOVE      L4PCOD        L#PCOD
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L4PLCG        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLCG                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L4PLCG        L#PLCG                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      L4PLFT        L#PLFT                                        LLN02
     C                   ENDIF                                                                 LLN02
      *
      ** Save details of Last Change Time and Date
     C                   MOVE      L4LCD         ULLCD             5 0
     C                   MOVE      L4UTIM        ULUTIM            6 0
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
     C                   MOVEA     '0'           *IN(51)
     C                   MOVEA     '00'          *IN(61)                                       LLN02
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
     C                   EXFMT     BY1040F2
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
     C                   MOVEA     '0'           *IN(53)
     C                   MOVEA     '00'          *IN(61)                                       LLN02
      *
      ** Validate product code
      **    Call product code selection screen
     C     L#PCOD        IFEQ      '?   '
     C     L#PCOD        OREQ      ' ?  '
     C     L#PCOD        OREQ      '  ? '
     C     L#PCOD        OREQ      '   ?'
     C                   CALL      'BY9220'
     C                   PARM      *BLANKS       P@RTCD
     C     L#PCOD        PARM      *BLANKS       ULPCOD
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
      **   Product code must be entered
     C     L#PCOD        IFEQ      *BLANKS
     C                   MOVE      'BYM0045'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN53
     C                   MOVE      'N'           ULVALD
     C                   ELSE
      *
      **   Check if product code exists in Master File
     C                   MOVE      L#PCOD        LDPCOD                         Prod Code in BYPRODP
     C*****LDPCOD        CHAIN     BYPRODPP                           90                    MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0046'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN53
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
      ** Validate PL product code - Charges Code                          LLN021
      **    Call product code selection screen                            LLN021
     C     L#PLCG        IFEQ      '?   '                                                      LLN02
     C     L#PLCG        OREQ      ' ?  '                                                      LLN02
     C     L#PLCG        OREQ      '  ? '                                                      LLN02
     C     L#PLCG        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#PLCG        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#PLCG        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLCG        LDPCOD                         Prod Code in BYLLN02
     C*****LDPCOD        CHAIN     BYPRODPP                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYPROD                                                                        MD058068
     C+ from BYPRDJW0                                                                       MD058068
     C+ where LDPCOD = :LDPCOD                                                              MD058068
     C/END-EXEC                                                                             MD058068
      *                                                                   LLN021
     C******IN90         IFEQ      *ON                                                      MD058068
     C     SQLCODE       IFEQ      100                                                      MD058068
     C                   MOVE      'BYM0155'     ULMSID                                        LLN02
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
      *   If Charges entered, the Fee is mandatory                        LLN021
     C     L#PLCG        IFNE      *BLANKS                                                     LLN02
     C     L#PLFT        ANDEQ     *BLANKS                                                     LLN02
     C                   MOVE      'BYM0156'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN62                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
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
      *   Read record from BYFCEXPP
     C     KEY1          CHAIN     BYFCEXPP                           90
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
     C     ULLCD         IFNE      L4LCD
     C     ULUTIM        ORNE      L4UTIM
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
     C                   MOVE      '*'           L4RECI
     C                   ELSE
     C                   MOVE      'D'           L4RECI
     C                   MOVE      L#PCOD        L4PCOD
     C                   MOVE      L#FCTP        L4FCTP
     C                   MOVE      L#LINS        L4LINS
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVEL     L#PLCG        L4PLCG                                        LLN02
     C                   MOVEL     L#PLFT        L4PLFT                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF
     C                   MOVE      L#ACTN        L4CHTP
     C                   MOVE      BJRDNB        L4LCD
     C                   TIME                    L4UTIM
      *
      ** Write or update file
     C     L#ACTN        IFEQ      'I'
     C                   WRITE     BYFCEXD0
     C                   ELSE
     C                   UPDATE    BYFCEXD0
     C                   ENDIF
      *
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
      *
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
     C                   MOVE      *BLANK        ULLINS            2            Institution code
     C                   MOVE      *BLANK        ULMIND            3            Industry code  LLN02
     C                   MOVE      *BLANK        ULPCOD            4
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
     C     *LIKE         DEFINE    L4FCTP        K1FCTP
     C     *LIKE         DEFINE    L4LINS        K1LINS
     C     *LIKE         DEFINE    L4MIND        K1MIND                                        LLN02
      *
      ** Set up a key list based on fields from BYFCEXPP
     C     KEY1          KLIST
     C                   KFLD                    K1FCTP                         Loan Type
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
      ** Initial fields for display file
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
     C*COPY*ZSRSRC,ZALIGNZ2L                                              LLN021            MD058068
     C/COPY ZSRSRC,ZALIGNZ2LE                                                               MD058068
**  CPY@
(c) Finastra International Limited 1997
