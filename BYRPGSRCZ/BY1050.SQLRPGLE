     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD058068
/*STD *  RPGSQLBND                                                    *                     MD058068
/*EXI *  TEXT('Midas BoE Securities Extract Criteria Maintenance')    *
      *****************************************************************
      *                                                               *
      *  Midas - Bank of England                                      *
      *                                                               *
      *  BY1050 - Securities Extract Details Maintenance              *
      *                                                               *
      *  Function:  This program allows the user to assign rules      *
      *  for each Security Shortname, Investment Type and Institution *
      *  Code combination. These rules are then used to extract and   *
      *  categorise Securities Details for the Bank of England returns*
      *                                                               *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 1997                      *
      *                                                               *
      *  Last Amend No. MD058068           Date 11May21               *
      *  Prev Amend No. MD058285           Date 22Jun21               *
      *                 MD046248           Date 27Oct17               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 LLN022             Date 24Jan05               *
      *                 LLN021             Date 03Oct97               *
      *                 122382             Date 03OCT97               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058068 - Deliverable Data Split for Bank of England        *
      *  MD058285 - Change base rate code to alphanumeric (Recompile) *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
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
      *  50 to 53 - Error highlighters for initial screen fields      *
      *  54 - Error highlighter for 'Prod Code' on detail screen      *
      *  90 - General work indicator                                  *
      *****************************************************************
      *
      * File description for files defined
     FBYSEEXPP  UF A E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS1)
     FBY1050DF  CF   E             WORKSTN INFSR(*PSSR)
     F                                     INFDS(INFDS#)
     FBYSEEXV0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(BYSEEXD0:BYSEEXD1)
     F*BYPRODPP* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
     F*BYINSTV0* IF   E           K DISK    INFSR(*PSSR)                                    MD058068
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     FINVTO     IF   E           K DISK    INFSR(*PSSR)
      *                                                                   LLN021
     F*BYINDRV0* IF   E           K DISK    INFSR(*PSSR)                         LLN021     MD058068
     F**********                           USROPN                                           MD058068
     FBYSEEXV1  UF   E           K DISK    INFSR(*PSSR)                         LLN021
     F                                     USROPN
     F                                     RENAME(BYSEEXD0:BYSEEXD2)            LLN021
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
     C                   EXFMT     BY1050F1
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
     C                   MOVEA     '0000000'     *IN(59)                                       LLN02
     C                   MOVEA     '00'          *IN(68)                                       LLN02
      *
      ** Reset fields
     C                   MOVE      *BLANKS       L#ACTN
     C                   MOVE      *BLANKS       L#SESN
     C                   MOVE      *BLANKS       L#INVT
     C                   MOVE      *BLANKS       L#LINS
     C                   MOVE      *BLANKS       L#PCOD
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      *BLANKS       L#MIND                                        LLN02
     C                   MOVE      *BLANKS       L#PLIR                                        LLN02
     C                   MOVE      *BLANKS       L#PLIP                                        LLN02
     C                   MOVE      *BLANKS       L#PLPL                                        LLN02
     C                   MOVE      *BLANKS       L#PLTX                                        LLN02
     C****                 MOVE *BLANKS   L#PLCG                          LLN021
     C****                 MOVE *BLANKS   L#PLFT                          LLN021
     C                   MOVE      *BLANKS       L#CCHG                                        LLN02
     C                   MOVE      *BLANKS       L#CFTP                                        LLN02
     C                   MOVE      *BLANKS       L#DCHG                                        LLN02
     C                   MOVE      *BLANKS       L#DFTP                                        LLN02
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
     C                   MOVEA     '00000'       *IN(31)
     C                   MOVEA     '0000'        *IN(50)
     C                   MOVEA     '0000000'     *IN(59)                                       LLN02
     C                   MOVEA     '00'          *IN(68)                                       LLN02
     C                   MOVE      'N'           ULVALC
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
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
     C                   MOVE      *OFF          *IN67                                         LLN02
      *                                                                   LLN021
     C     L#SESN        IFNE      *BLANKS                                                     LLN02
     C     L#INVT        ANDEQ     *BLANKS                                                     LLN02
     C     L#LINS        ANDEQ     *BLANKS                                                     LLN02
     C     L#MIND        ANDEQ     *BLANKS                                                     LLN02
     C     L#SESN        ORNE      *BLANKS                                                     LLN02
     C     L#INVT        ANDEQ     *BLANKS                                                     LLN02
     C     L#LINS        ANDNE     *BLANKS                                                     LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C     L#SESN        OREQ      *BLANKS                                                     LLN02
     C     L#INVT        ANDNE     *BLANKS                                                     LLN02
     C     L#LINS        ANDNE     *BLANKS                                                     LLN02
     C     L#MIND        ANDEQ     *BLANKS                                                     LLN02
     C     L#SESN        OREQ      *BLANKS                                                     LLN02
     C     L#INVT        ANDNE     *BLANKS                                                     LLN02
     C     L#LINS        ANDEQ     *BLANKS                                                     LLN02
     C     L#MIND        ANDEQ     *BLANKS                                                     LLN02
     C                   MOVE      *ON           *IN67                                         LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      'BYM0062'     ULMSID                                        LLN02
     C                   MOVEA     '111'         *IN(51)                                       LLN02
     C                   MOVEA     '1'           *IN(59)                                       LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      ** Validate 1st possible combination of input data.
     C     L#SESN        IFNE      *BLANKS
     C********** L#INVT    ANDEQ*BLANKS                                                       LLN022
     C********** L#LINS    ANDEQ*BLANKS                                                       LLN022
      *
      ** Validate Security Shortname
     C                   MOVEL     L#SESN        SESN                           Field in SECTY
     C     SESN          CHAIN     SECTY                              90
      *
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0060'     ULMSID
     C                   MOVE      *ON           *IN51
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
     C     L#INVT        IFEQ      *BLANKS
     C     L#LINS        ANDEQ     *BLANKS
     C     *IN51         ANDEQ     *OFF
     C                   MOVE      'Y'           ULVALC
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate 2nd combination of input data.
     C********** L#SESN    IFEQ *BLANKS                                                       LLN022
      *
      ** Validate Investment Type
     C     L#INVT        IFNE      *BLANK
     C                   MOVE      L#INVT        INVT                           Field in INVTO
     C     INVT          CHAIN     INVTO                              90
      *
     C     *IN90         IFEQ      *ON
     C                   MOVE      'BYM0061'     ULMSID
     C                   MOVE      *ON           *IN52
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
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
     C                   MOVE      *ON           *IN53
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate 2nd combination of input data.                                              LLN022
      *                                                                                       LLN022
     C     L#SESN        IFEQ      *BLANKS
     C     L#INVT        ANDNE     *BLANKS
     C     *IN52         ANDEQ     *OFF
     C     L#LINS        ANDNE     *BLANKS
     C     *IN53         ANDEQ     *OFF
     C                   MOVE      'Y'           ULVALC
     C                   ENDIF
      *
     C     ULVALC        IFEQ      'N'
     C     LLN021        ANDEQ     'N'                                                         LLN02
     C     ULVALC        OREQ      'N'                                                         LLN02
     C     LLN021        ANDEQ     'Y'                                                         LLN02
     C     *IN67         ANDEQ     *OFF                                                        LLN02
     C                   MOVE      'BYM0062'     ULMSID
     C                   MOVEA     '111'         *IN(51)
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVEA     '1'           *IN(59)                                       LLN02
     C                   ENDIF                                                                 LLN02
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
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
     C                   MOVE      L#MIND        L5MIND                         Inst Code in BYLLN02
     C*****L5MIND        CHAIN     BYINDRV0                           90              LLN02 MD058068
     C/EXEC SQL                                                                             MD058068
     C+ SELECT *                                                                            MD058068
     C+ into :BYINDR                                                                        MD058068
     C+ from BYINRJW0                                                                       MD058068
     C+ where LCMIND = :L5MIND                                                              MD058068
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
     C     L#SESN        IFEQ      *BLANKS                                                     LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C                   MOVE      'BYM0160'     ULMSID                                        LLN02
     C                   MOVE      *ON           *IN51                                         LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C     L#INVT        IFNE      *BLANKS                                                     LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C                   MOVE      'BYM0161'     ULMSID                                        LLN02
     C                   MOVE      *ON           *IN52                                         LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      'N'           ULVALI                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *
      *   If screen details are valid then check whether records exists
      *   on BYSEEXPP according to action code
     C     ULVALI        IFEQ      'Y'
      *
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C                   MOVEL     L#SESN        L5SESN                                        LLN02
     C                   MOVE      L#LINS        K5LINS                                        LLN02
     C                   MOVE      L#MIND        K5MIND                                        LLN02
     C     KEY2          CHAIN(N)  BYSEEXD2                           90                       LLN02
     C                   ELSE                                                                  LLN02
     C     L#SESN        IFEQ      *BLANKS
     C                   MOVE      L#INVT        K5INVT
     C                   MOVE      L#LINS        K5LINS
     C     KEY1          CHAIN(N)  BYSEEXPP                           90
     C                   ELSE
     C                   MOVEL     L#SESN        L5SESN
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      *BLANKS       K5INVT                                        LLN02
     C                   MOVE      *BLANKS       K5LINS                                        LLN02
     C                   MOVE      *BLANKS       K5MIND                                        LLN02
     C     KEY3          CHAIN(N)  BYSEEXD1                           90                       LLN02
     C                   ELSE                                                                  LLN02
     C     L5SESN        CHAIN(N)  BYSEEXD1                           90
     C                   ENDIF                                                                 LLN02
     C                   ENDIF
     C                   ENDIF                                                                 LLN02
      *
      *    If action is Insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
     C     L5RECI        ANDEQ     'D'
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
     C     L5CHTP        ANDEQ     'D'
     C                   MOVE      'BYM0086'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      'N'           ULVALI
     C                   ENDIF
      *
      **   If initial screen is valid
     C     ULVALI        IFEQ      'Y'
      *
      **   Load screen fields for display
     C     L#ACTN        IFEQ      'A'
     C     L#ACTN        OREQ      'E'
     C     L#ACTN        OREQ      'D'
     C                   MOVE      L5PCOD        L#PCOD
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L5PLIR        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLIR                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L5PLIR        L#PLIR                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     L5PLIP        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLIP                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L5PLIP        L#PLIP                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     L5PLPL        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLPL                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L5PLPL        L#PLPL                                        LLN02
     C                   ENDIF                                                                 LLN02
     C     L5PLTX        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#PLTX                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L5PLTX        L#PLTX                                        LLN02
     C                   ENDIF                                                                 LLN02
      **
     C     L5CCHG        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#CCHG                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L5CCHG        L#CCHG                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      L5CFEE        L#CFTP                                        LLN02
     C     L5DCHG        IFEQ      0                                                           LLN02
     C                   MOVE      *BLANKS       L#DCHG                                        LLN02
     C                   ELSE                                                                  LLN02
     C                   MOVE      L5DCHG        L#DCHG                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   MOVE      L5DFEE        L#DFTP                                        LLN02
      **                                                                  LLN021
     C                   ENDIF                                                                 LLN02
      *
      ** Save details of Last Change Time and Date
     C                   MOVE      L5LCD         ULLCD             5 0
     C                   MOVE      L5UTIM        ULUTIM            6 0
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
      * #LDETL - Display Detail Screen                                *
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
     C                   MOVEA     '0000000'     *IN(59)                                       LLN02
     C                   MOVEA     '00'          *IN(68)                                       LLN02
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
     C                   EXFMT     BY1050F2
      *
      *   Clear message subfile
     C                   EXSR      #LCLMG
      *
      *   CF03 - Exit program
     C     *IN03         IFEQ      *ON
     C                   EXSR      #LTERM
     C                   ENDIF
      *
      *   CF12 - Previous screen requested
      *          Clear initial screen for redisplay
     C     *IN12         IFEQ      *ON
     C                   EXSR      #LRSET
     C                   ENDIF
      *
      *  CF10 - Delete details. Enter update subroutine without
      *  entering validation subroutine
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
     C                   MOVE      *OFF          *IN54
     C                   MOVEA     '0000000'     *IN(59)                                       LLN02
     C                   MOVEA     '00'          *IN(68)                                       LLN02
      *
      ** Validate Product Code
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
      **    Product code must be entered
     C     L#PCOD        IFEQ      *BLANKS
     C                   MOVE      'BYM0045'     ULMSID
     C                   EXSR      #LSNMG
     C                   MOVE      *ON           *IN54
     C                   MOVE      'N'           ULVALD
     C                   ELSE
      *
      **    Check if product code exists in Master File
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
     C                   MOVE      *ON           *IN54
     C                   MOVE      'N'           ULVALD
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                   LLN021
      *                                                                   LLN021
     C     LLN021        IFEQ      'Y'                                                         LLN02
      *                                                                   LLN021
      ** Receive field, Payable field and Profit & Loss fields are        LLN021
      ** all Mandatory.
     C     L#PLIR        IFEQ      *BLANKS                                                     LLN02
     C     L#PLIP        OREQ      *BLANKS                                                     LLN02
     C     L#PLPL        OREQ      *BLANKS                                                     LLN02
     C                   MOVE      'BYM0132'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN60                                         LLN02
     C                   MOVE      *ON           *IN61                                         LLN02
     C                   MOVE      *ON           *IN62                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      ** Validate PL product code - Accrued Interest Receivable           LLN021
      **    Call product code selection screen                            LLN021
     C     L#PLIR        IFEQ      '?   '                                                      LLN02
     C     L#PLIR        OREQ      ' ?  '                                                      LLN02
     C     L#PLIR        OREQ      '  ? '                                                      LLN02
     C     L#PLIR        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#PLIR        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#PLIR        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLIR        LDPCOD                         Prod Code in BYLLN02
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
     C                   MOVE      'BYM0157'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN60                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      ** Validate PL product code - Accrued Interest Payable              LLN021
      **    Call product code selection screen                            LLN021
     C     L#PLIP        IFEQ      '?   '                                                      LLN02
     C     L#PLIP        OREQ      ' ?  '                                                      LLN02
     C     L#PLIP        OREQ      '  ? '                                                      LLN02
     C     L#PLIP        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#PLIP        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#PLIP        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLIP        LDPCOD                         Prod Code in BYLLN02
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
     C                   MOVE      'BYM0158'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN61                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      ** Validate PL product code - Profit/Loss                           LLN021
      **    Call product code selection screen                            LLN021
     C     L#PLPL        IFEQ      '?   '                                                      LLN02
     C     L#PLPL        OREQ      ' ?  '                                                      LLN02
     C     L#PLPL        OREQ      '  ? '                                                      LLN02
     C     L#PLPL        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#PLPL        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#PLPL        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLPL        LDPCOD                         Prod Code in BYLLN02
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
     C                   MOVE      'BYM0159'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN62                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      ** Validate PL product code - Tax                                   LLN021
      **    Call product code selection screen                            LLN021
     C     L#PLTX        IFEQ      '?   '                                                      LLN02
     C     L#PLTX        OREQ      ' ?  '                                                      LLN02
     C     L#PLTX        OREQ      '  ? '                                                      LLN02
     C     L#PLTX        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#PLTX        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#PLTX        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#PLTX        LDPCOD                         Prod Code in BYLLN02
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
     C                   MOVE      'BYM0153'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN63                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      ** Validate PL product code - CREDIT Charges                        LLN021
      **    Call product code selection screen                            LLN021
     C     L#CCHG        IFEQ      '?   '                                                      LLN02
     C     L#CCHG        OREQ      ' ?  '                                                      LLN02
     C     L#CCHG        OREQ      '  ? '                                                      LLN02
     C     L#CCHG        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#CCHG        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#CCHG        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#CCHG        LDPCOD                         Prod Code in BYLLN02
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
     C                   MOVE      *ON           *IN64                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      *   Validate Credit Fee Type                                        LLN021
     C     L#CFTP        IFNE      *BLANKS                                                     LLN02
      *                                                                   LLN021
     C     L#CFTP        IFNE      'NI'                                                        LLN02
     C     L#CFTP        ANDNE     'IS'                                                        LLN02
     C     L#CFTP        ANDNE     'CB'                                                        LLN02
     C     L#CFTP        ANDNE     'CU'                                                        LLN02
     C     L#CFTP        ANDNE     'DV'                                                        LLN02
     C     L#CFTP        ANDNE     'FX'                                                        LLN02
     C     L#CFTP        ANDNE     'BC'                                                        LLN02
     C     L#CFTP        ANDNE     'OT'                                                        LLN02
     C                   MOVE      'BYM0152'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN65                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      *   If Credit Charges entered, the Credit Fee type is mandatory     LLN021
     C     L#CCHG        IFNE      *BLANKS                                                     LLN02
     C     L#CFTP        ANDEQ     *BLANKS                                                     LLN02
     C                   MOVE      'BYM0156'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN65                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      **
      ** Validate PL product code - DEBIT Charges                         LLN021
      **    Call product code selection screen                            LLN021
     C     L#DCHG        IFEQ      '?   '                                                      LLN02
     C     L#DCHG        OREQ      ' ?  '                                                      LLN02
     C     L#DCHG        OREQ      '  ? '                                                      LLN02
     C     L#DCHG        OREQ      '   ?'                                                      LLN02
     C                   CALL      'BY9220'                                                    LLN02
     C                   PARM      *BLANKS       P@RTCD                                        LLN02
     C     L#DCHG        PARM      *BLANKS       ULPCOD                                        LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      **    Check if product code exists in Master File                   LLN021
     C     L#DCHG        IFNE      *BLANKS                                                     LLN02
     C                   MOVE      L#DCHG        LDPCOD                         Prod Code in BYLLN02
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
     C                   MOVE      *ON           *IN68                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      *   Validate Debit Fee Type                                         LLN021
     C     L#DFTP        IFNE      *BLANKS                                                     LLN02
      *                                                                   LLN021
     C     L#DFTP        IFNE      'NI'                                                        LLN02
     C     L#DFTP        ANDNE     'IS'                                                        LLN02
     C     L#DFTP        ANDNE     'CB'                                                        LLN02
     C     L#DFTP        ANDNE     'CU'                                                        LLN02
     C     L#DFTP        ANDNE     'DV'                                                        LLN02
     C     L#DFTP        ANDNE     'FX'                                                        LLN02
     C     L#DFTP        ANDNE     'BC'                                                        LLN02
     C     L#DFTP        ANDNE     'OT'                                                        LLN02
     C                   MOVE      'BYM0152'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN69                                         LLN02
     C                   MOVE      'N'           ULVALD                                        LLN02
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
     C                   ENDIF                                                                 LLN02
      *                                                                   LLN021
      *                                                                   LLN021
      *   If Charges entered, the Fee is mandatory                        LLN021
     C     L#DCHG        IFNE      *BLANKS                                                     LLN02
     C     L#DFTP        ANDEQ     *BLANKS                                                     LLN02
     C                   MOVE      'BYM0156'     ULMSID                                        LLN02
     C                   EXSR      #LSNMG                                                      LLN02
     C                   MOVE      *ON           *IN69                                         LLN02
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
      *   Read record from BYSEEXPP
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C     KEY2          CHAIN     BYSEEXD2                           90                       LLN02
     C                   ELSE                                                                  LLN02
     C     L#SESN        IFEQ      *BLANKS
     C     KEY1          CHAIN     BYSEEXPP                           90
     C                   ELSE
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVE      *BLANKS       K5INVT                                        LLN02
     C                   MOVE      *BLANKS       K5LINS                                        LLN02
     C                   MOVE      *BLANKS       K5MIND                                        LLN02
     C     KEY3          CHAIN     BYSEEXD1                           90                       LLN02
     C                   ELSE                                                                  LLN02
     C     L5SESN        CHAIN     BYSEEXD1                           90
     C                   ENDIF                                                                 LLN02
     C                   ENDIF
     C                   ENDIF                                                                 LLN02
      *
      *  If action is insert record must not exist
     C     L#ACTN        IFEQ      'I'
     C     *IN90         ANDEQ     *OFF
     C     L5RECI        ANDEQ     'D'
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
     C     ULLCD         IFNE      L5LCD
     C     ULUTIM        ORNE      L5UTIM
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
     C                   MOVE      '*'           L5RECI
     C                   ELSE
     C                   MOVE      'D'           L5RECI
     C                   MOVE      L#SESN        L5SESN
     C                   MOVE      L#INVT        L5INVT
     C                   MOVE      L#LINS        L5LINS
     C                   MOVE      L#PCOD        L5PCOD
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C                   MOVEL     L#MIND        L5MIND                                        LLN02
     C                   MOVEL     L#PLIR        L5PLIR                                        LLN02
     C                   MOVEL     L#PLIP        L5PLIP                                        LLN02
     C                   MOVEL     L#PLPL        L5PLPL                                        LLN02
     C                   MOVEL     L#PLTX        L5PLTX                                        LLN02
     C                   MOVEL     L#CCHG        L5CCHG                                        LLN02
     C                   MOVEL     L#CFTP        L5CFEE                                        LLN02
     C                   MOVEL     L#DCHG        L5DCHG                                        LLN02
     C                   MOVEL     L#DFTP        L5DFEE                                        LLN02
     C                   ENDIF                                                                 LLN02
     C                   ENDIF
     C                   MOVE      L#ACTN        L5CHTP
     C                   MOVE      BJRDNB        L5LCD
     C                   TIME                    L5UTIM
      *
      ** Write or update file
     C********** L#ACTN    IFEQ 'I'                                                           LLN022
     C     *IN90         IFEQ      *ON
     C                   WRITE     BYSEEXD0
     C                   ELSE
      *
     C     LLN021        IFEQ      'Y'                                                         LLN02
     C     L#MIND        ANDNE     *BLANKS                                                     LLN02
     C                   UPDATE    BYSEEXD2                                                    LLN02
     C                   ELSE                                                                  LLN02
     C     L#SESN        IFEQ      *BLANKS
     C                   UPDATE    BYSEEXD0
     C                   ELSE
     C                   UPDATE    BYSEEXD1
     C                   ENDIF
     C                   ENDIF                                                                 LLN02
      *
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
     C                   MOVE      *BLANK        ULLINS            2            Institution code
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
     C                   MOVE      'N'           ULVALC            1            Combination valid
     C                   MOVE      'N'           ULVALD            1            Detail screen valid
     C                   MOVE      'N'           ULUPDI            1            Valid for update
     C                   MOVEA     CPY@          ULCPY@           80            Copyright
      *
      ** Redefine fields for use in KLIST
     C     *LIKE         DEFINE    L5INVT        K5INVT
     C     *LIKE         DEFINE    L5LINS        K5LINS
     C     *LIKE         DEFINE    L5MIND        K5MIND                                        LLN02
      *
      ** Set up a key list based on fields from BYSEEXPP
     C     KEY1          KLIST
     C                   KFLD                    K5INVT                         Loan Sub-Type
     C                   KFLD                    K5LINS                         Institution Code
      *
     C     KEY2          KLIST                                                                 LLN02
     C                   KFLD                    L#SESN                         Security Name  LLN02
     C                   KFLD                    K5LINS                         Institution CodLLN02
     C                   KFLD                    K5MIND                         Industry Code  LLN02
      *                                                                   LLN021
     C     KEY3          KLIST                                                                 LLN02
     C                   KFLD                    SESN                           Security Name  LLN02
     C                   KFLD                    K5INVT                         Institution CodLLN02
     C                   KFLD                    K5LINS                         Institution CodLLN02
     C                   KFLD                    K5MIND                         Industry Code  LLN02
      *                                                                   LLN021
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
     C                   PARM      '*VERIFY'     P@OPTN                                        LLN02
     C                   PARM      'LLN021'      @SARD             6                           LLN02
      *                                                                   LLN021
     C     @RTCD         IFEQ      *BLANK                                                      LLN02
     C                   MOVE      'Y'           LLN021            1                           LLN02
     C                   MOVE      *ON           *IN66                                         LLN02
     C**********         OPEN      BYINDRV0                                           LLN02 MD058068
     C                   OPEN      BYSEEXV1                                                    LLN02
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
