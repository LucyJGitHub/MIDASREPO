     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SF Copy reference user')                         *
      *****************************************************************
      *                                                               *
      *  Midas-  Security Profile Facility                            *
      *                                                               *
      *  SF000040 - Midas User Maintenance - Copy Reference User      *
      *                                                               *
      *  Function: This program enables a new Midas user to be created*
      *  I/C       by copying another user's details:- security level,*
      *            menus, sign off time etc. The user description may *
      *            be changed.                                        *
      *                                                               *
      *            In a multibranch environment, branch and company   *
      *            codes may be swapped.                              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 241013             Date 12Dec06               *
      *                 235634             Date 31Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CRE026             Date 24May06               *
      *                 241033             Date 25Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 239898             Date 29May06               *
      *                 BUG11032           Date 06Apr06               *
      *                 BUG10744A (Reopen) Date 23May06               *
      *                 BUG10744 (Reopen)  Date 20Mar06               *
      *                 CGP009             Date 22Dec04               *
      *                 BUG2598            Date 12May04               *
      *                 TDA035             Date 02Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSF002             Date 11Aug03               *
      *                 211875             Date 03Feb03               *
      *                 CPK016             Date 01Jul03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 197434             Date 09Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CGL008             Date 03Mar99               *
      *                 CAAA01             Date 08Mar95               *
      *                 S01408             Date 06Mar95               *
      *                 083547             Date 20Feb95               *
      *                 S01486             Date 09Jun94               *
      *                 E40240             Date 01Jun92               *
      *                 S01117             Date 17Feb92               *
      *                 E26592             Date 09Sep91               *
      *                 S01269             Date 24Jun91               *
      *                 RT0148             Date 24Jun91               *
      *                 RT0101             Date 15May91               *
      *                 S01199             Date 18Sep89               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,SFH00218                                 *
      *             WNCPYSRC,SFH00219                                 *
      *             WNCPYSRC,SFH00220                                 *
      *             WNCPYSRC,SFH00221                                 *
      *             WNCPYSRC,SFH00222                                 *
      *             WNCPYSRC,SFH00223                                 *
      *             WNCPYSRC,SFH00224                                 *
      *             WNCPYSRC,SFH00225                                 *
      *             WNCPYSRC,SFH00226                                 *
      *             WNCPYSRC,SFH00227                                 *
      *             WNCPYSRC,SFH00228                                 *
      *             WNCPYSRC,SFH00229                                 *
      *             WNCPYSRC,SFH00230                                 *
      *             WNCPYSRC,SFH00231                                 *
      *             WNCPYSRC,SFH00232                                 *
      *             WNCPYSRC,SFH00233                                 *
      *  241013 - Copy also global rights                             *
      *  235634 - Apply fix BUG11032                                  *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  241033 -  Files for update are not commited when AGMBIN =    *
      *            'Y'.                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  239898 - Applied core fix BUG11032.                          *
      *  BUG11032 - Reporting About Users (Recompile)                 *
      *  BUG10744A - Files for update should be for commitment to     *
      *              avoid locking in User Maintenance. (Reopen)      *
      *  BUG10744- Ensure write on MACBRDD are committed so that they *
      *            will be replicated to the global layer. (Reopen)   *
      *  CGP009 - Local Zone Time Difference (Recompile)              *
      *  BUG2598- Recompile due to changes in SF000040DF. Webfacing   *
      *           changes.                                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSF002 - Global Processing (Recompile)                       *
      *           SF0040 has been converted to ILE and renamed.       *
      *           Commented out program codes have been stripped out  *
      *           for clarity.                                        *
      *  211875 - Immediately update the trailer file as soon as the  *
      *           record is written in MUSERDD instead of doing so at *
      *           the end of the program.                             *
      *  CPK016 - Add default parameter to allow auto create.         *
      *  197434 - Array index error on SF0021. Increase maximum       *
      *           number of branches from 100 to 900.                 *
      *  CGL008 - Security on Journal Entry.                          *
      *  CAAA01 - GUI/400 development                                 *
      *         - recompiled over changed MUSERDD                     *
      *  S01408 - Core hooks added - SF0040CCBU                       *
      *                            - SF0040FFPG                       *
      *  083547 - RECOMPILED OVER MUSERDD                             *
      *  S01486 - RECOMPILED DUE TO CHANGED MUSER FOR PRIVATE BANKING *
      *  E40240 - WHEN SINGLE BRANCH, USER DEFAULT BRANCH IS NOT BLANK*
      *  S01117 - RECOMPILE FOR FT CHANGE TO MUSERDD                  *
      *  E26592 - IF A USER PROFILE IS COPIED AND THE NEW PROFILE     *
      *           ENQUIRED UPON THEN A STRING OF UNPRINTABLE CHARS    *
      *           ARE DISPLAYED.                                      *
      *         - RECOMPILE OVER CHANGED LF/MBRBS                     *
      *  S01269 - RECOMPILE OVER CHANGED LF/MUSER                     *
      *  RT0148 - RECOMPILE OVER CHANGED LF/MITEM                     *
      *  RT0101 - Pgm should not allow a copy to be made to a deleted *
      *           (but not dropped) user.                             *
      *  S01199 - HELP SYSTEM.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    09         GPZONEL2 No Record Found Indicator              *
      *    10         NON-DISPLAY   ERROR MESSAGE                     *
      *    21         ICD RECORD/S NOT FOUND                          *
      *    22         CHAIN TO MUSER/TABLE FILE FAILED                *
      *    23                                                         *
      *    24                                                         *
      *    31         REFERENCE USER IN ERROR                         *
      *    32         NEW USER IN ERROR                               *
      *    33         NEW USER DESCRIPTION BLANK                      *
      *    34         REFERENCE BRANCH CODE IN ERROR                  *
      *    35         'TO' BRANCH CODE IN ERROR                       *
      *    36         REFERENCE COMPANY IN ERROR                      *
      *    37         'TO' COMPANY IN ERROR                           *
      *    55         AGF1ST ON RUNDAT IS NOT EQUAL TO 'Y'            *
      *    U7U8       DATA BASE ERROR                                 *
      *                                                               *
      *****************************************************************
     FSF000040DFCF   E             WORKSTN
     F***MUSER**   UF A E           K DISK                                                  BUG10744
     FMUSER     UF A E           K DISK    COMMIT                                           BUG10744
     FMUSERZZ   UF   E           K DISK    USROPN
     F                                     COMMIT                                           BUG10744
     F***MBRBS**   UF A E           K DISK                                                  BUG10744
     FMBRBS     UF A E           K DISK    COMMIT                                           BUG10744
     F***MBROS**   UF A E           K DISK                                                  BUG10744
     FMBROS     UF A E           K DISK    COMMIT                                           BUG10744
     F***MCMPS**   UF A E           K DISK                                                  BUG10744
     FMCMPS     UF A E           K DISK    COMMIT                                           BUG10744
     FMACBR     IF   E           K DISK
     FMACBRDD   O  A E           K DISK
     F                                     RENAME(MACBRDDF:MACBRDDO)
     F                                     COMMIT                                           BUG10744
     FGPZONEL2  IF   E           K DISK
      *
     F/COPY WNCPYSRC,SFH00218
     D ERR             S             78    DIM(14) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,SFH00219
     D ERC             S              4    DIM(11)
     D ABR             S              3    DIM(900)
     D A2Z             S              1    DIM(26) CTDATA PERRCD(26)
     D TXT             S              1    DIM(10)
      *
      ** RUNDAT data area.
      *
     D RUNDAT          DS
     D  AGMRDT                 1      7
     D  AGRDNB                 8     10P 0
     D  AGSUC                 11     11
     D  AGDFF                 12     12
     D  AGMBIN                13     13
      *
     D SDSTAT          DS           256
     D  LIBR                   6      7
      *
      ** DATA AREA DEFINED FOR ERROR HANDLING.
      *
     D LDA            UDS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D PSDS           SDS
     D  WSID                 244    246
     D  WSID2                245    246
     D  SWSID                244    253
     D  USRID                254    263
      *
      ** DATA STRUCTURES FOR USE WITH ACCESS OBJECTS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
     D SDCOMP        E DS                  EXTNAME(SDCOMPPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     C     *ENTRY        PLIST
     C                   PARM                    REFUSR           10
     C                   PARM                    NEWUSR           10
     C                   PARM                    NEWDSC           25
      *
     C     REFUSR        IFNE      *BLANKS
     C                   MOVE      REFUSR        RFUSR
     C                   ENDIF
     C     NEWUSR        IFNE      *BLANKS
     C                   MOVE      NEWUSR        NWUSR
     C                   ENDIF
     C     NEWDSC        IFNE      *BLANKS
     C                   MOVE      NEWDSC        NWDES
     C                   ENDIF
      *
      ** GET RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      **  GET SDSTAT
      *
     C     *DTAARA       DEFINE                  SDSTAT
     C                   IN        SDSTAT
     C                   UNLOCK    SDSTAT
      *
      ** GET BKOBUV (EQUIVALENT OF OLD OBUV)
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** GET RUN DATE FROM RUNDAT
      *
     C                   MOVE      AGMRDT        SRUNA
      *
      ** Get the zone name.
      *
     C     LIBR          CHAIN     GPZONEL2                           09
     C     *IN09         IFEQ      *OFF
     C                   MOVE      ZOZONE        SZONE
     C                   ENDIF
      *
      **  Access SAR details file to see if CGL008 SAR is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL008'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CGL008            1
     C                   ELSE
     C                   MOVE      'N'           CGL008
     C                   END
     C/COPY WNCPYSRC,SFH00220
      *
      ** Execute START and get required data from the ICD
      ** table files.
      *
     C     MACKEY        KLIST
     C                   KFLD                    RFUSR
     C   U7
     CAN U8              GOTO      ENDPRG
     C                   SETON                                            10
     C     AGMBIN        IFNE      'Y'
     C                   SETON                                        55
     C                   MOVE      'N'           BKOBUV
     C                   ELSE
     C                   SETOFF                                       55
     C                   END
      *
      **       Perform:
      **         a)   If HELP pressed, Execute HELPSR subroutine
      **         b)   If Cmd/12 pressed, Initialise work fields and
      **              redisplay initial screen
      **         c)   If ENTER pressed, validate screen contents;
      **               If ERROR is not zero, redisplay screen with
      **                  error code/s / message
      **               Else,  Execute UPDAT subroutine and
      **                       initialise work fields.
      **       Until Cmd/3 is pressed.
      *
     C     *INKC         DOUEQ     '1'
     C                   EXFMT     SF000040D1
     C     *INKC         CABEQ     '1'           ENDTAG
     C                   SETOFF                                       313233
     C                   SETOFF                                       343536
     C                   SETOFF                                       372038
     C                   SETON                                            10
     C     *INKL         IFEQ      '1'
     C                   EXSR      INIT
     C                   GOTO      ENDTAG
     C                   END
     C                   EXSR      CHECK
     C     ERROR         IFEQ      *ZEROS
     C                   EXSR      UPDAT
     C   U7
     CAN U8              GOTO      ENDPRG
     C                   EXSR      INIT
     C                   END
     C     ENDTAG        TAG
     C                   END
     C     ENDPRG        TAG
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * INIT      - Initialises all the work fields                   *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
     C                   MOVE      *BLANKS       RFUSR
     C                   MOVE      *BLANKS       NWUSR
     C                   MOVE      *BLANKS       NWDES
     C                   MOVE      *BLANKS       NDIRID
     C                   MOVE      *BLANKS       NDIRAD
     C                   MOVE      *BLANKS       FMBRC
     C                   MOVE      *BLANKS       TOBRC
     C                   MOVE      *BLANKS       FMCMP
     C                   MOVE      *BLANKS       TOCMP
     C                   MOVE      *BLANKS       ERMSG
     C                   MOVE      *BLANKS       ERCD
     C                   MOVEA     *BLANKS       ERC
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CHECK     - Validate                                          *
      *                                                               *
      *****************************************************************
     C     CHECK         BEGSR
      *
      **   1.   VALIDATE  USERID  :::
      **
      **        REFERENCE USER MUST EXIST  ON MUSER.
      **        NEW USER MUST BE LEFT ADJUSTED.
      **        NEW USER MUST NOT EXIST  ON MUSER.
      *
     C                   MOVE      *ZEROS        ERROR             2 0
     C                   Z-ADD     0             X                 2 0
     C                   MOVE      *BLANKS       ERMSG
     C                   MOVE      *BLANKS       ERCD
     C                   MOVEA     *BLANKS       ERC
      *
      **        MANDATORY FIELDS :::
      **        REFERENCE USER AND NEW USER
      *
     C/COPY WNCPYSRC,SFH00221
     C     RFUSR         IFEQ      *BLANKS
     C     NWUSR         OREQ      *BLANKS
     C                   MOVEL     ERR(3)        ERMSG
     C                   ADD       1             X
     C                   MOVE      ' 201'        ERC(X)
     C                   SETON                                            20
     C     ERROR         ADD       1             ERROR
     C     RFUSR         COMP      *BLANKS                                31
     C     NWUSR         COMP      *BLANKS                                32
     C                   END
      *
      **        REFERENCE USER MUST EXIST ON FILE :::
      **        AND RECORD ID MUST BE VALID :::
      *
     C     RFUSR         CHAIN     MUSER                              22
     C     *IN22         IFEQ      '1'
     C     RECI          ORNE      'D'
     C  N20              MOVEL     ERR(1)        ERMSG
     C  N20              SETON                                            20
     C     X             ADD       1             X
     C                   MOVE      ' 202'        ERC(X)
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        31
     C                   ELSE
     C                   MOVE      DBRN          DBRNX             3
     C                   END
      *
      **        NEW USER FIELD MUST BEGIN WITH AN ALPHA CHARACTER
      **        NEW USER FIELD MUST BE LEFT ADJUSTED :::
      *
     C     NWUSR         IFNE      *BLANKS
     C                   MOVEL     NWUSR         WORK              1
     C     WORK          LOOKUP    A2Z(1)                                 99
     C     WORK          IFEQ      *BLANKS
     C     *IN99         OREQ      '0'
     C  N20              MOVEL     ERR(9)        ERMSG
     C  N20              SETON                                            20
     C     X             ADD       1             X
     C                   MOVE      ' 201'        ERC(X)
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        32
     C                   END
      *
      **        AND MUST NOT CONTAIN EMBEDDED BLANKS :::
      *
     C                   MOVEA     NWUSR         TXT
     C                   Z-ADD     1             B                 2 0
     C     ' '           LOOKUP    TXT(B)                                 41
     C     *IN41         IFEQ      '1'
     C     B             ANDGT     1
     C     B             DOWLT     11
     C     TXT(B)        IFNE      ' '
     C  N20              MOVEL     ERR(9)        ERMSG
     C  N20              SETON                                            20
     C     X             ADD       1             X
     C                   MOVE      ' 201'        ERC(X)
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        32
     C                   Z-ADD     11            B
     C                   END
     C                   ADD       1             B
     C                   END
     C                   END
     C                   END
      *
      **        NEW USER FIELD MUST NOT EXIST ON FILE :::
      *
     C     NWUSR         IFNE      *BLANKS
     C     NWUSR         CHAIN     MUSER                              22
     C     *IN22         IFEQ      '0'
     C  N20              MOVEL     ERR(2)        ERMSG
     C  N20              SETON                                            20
     C     X             ADD       1             X
     C                   MOVE      ' 203'        ERC(X)
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        32
     C                   END
     C                   END
      *
      **        VALIDATE NEW USER DESCRIPTION
      **        NEW USER DESCRIPTION CANNOT BE BLANK :::
      *
     C     NWDES         IFEQ      *BLANKS
     C  N20              MOVEL     ERR(4)        ERMSG
     C  N20              SETON                                            20
     C     X             ADD       1             X
     C                   MOVE      ' 204'        ERC(X)
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        33
     C                   END
      *
      **   VALIDATE DIRECTORY ID AND ADDRESS AND MONITOR FOR ERRORS
      *
     C     NDIRID        IFNE      *BLANKS
     C     NDIRAD        ANDNE     *BLANKS
     C     NWUSR         ANDNE     *BLANKS
     C     NWDES         ANDNE     *BLANKS
     C     ERROR         ANDEQ     *ZEROS
     C                   MOVE      *BLANKS       ERRCD
     C                   MOVE      'I'           ACTN              1
     C                   MOVE      NWDES         NWDES1           50
      *
     C                   CALL      'SFC0030'
     C                   PARM                    ACTN
     C                   PARM                    ERRCD             1
     C                   PARM                    NWUSR
     C                   PARM                    NWDES1
     C                   PARM                    NDIRID
     C                   PARM                    NDIRAD
      *
     C     ERRCD         IFEQ      '1'
     C                   MOVEL     ERR(12)       ERMSG
     C     X             ADD       1             X
     C                   MOVE      ' 208'        ERC(X)
     C                   SETON                                          3820
     C     ERROR         ADD       1             ERROR
     C                   END
      *
     C     ERRCD         IFEQ      '3'
     C                   MOVEL     ERR(13)       ERMSG
     C     X             ADD       1             X
     C                   MOVE      ' 209'        ERC(X)
     C                   SETON                                          3820
     C     ERROR         ADD       1             ERROR
     C                   END
      *
     C     ERRCD         IFEQ      '4'
     C                   MOVEL     ERR(14)       ERMSG
     C     X             ADD       1             X
     C                   MOVE      ' 210'        ERC(X)
     C                   SETON                                          3820
     C     ERROR         ADD       1             ERROR
     C                   END
      *
     C                   END
      *
      **   2.   VALIDATE  BRANCHES :::
      **
      **        IF   REF BRANCH AND TO BRANCH ARE LEFT BLANK
      **             SKIP VALIDATION :::
      *
     C     FMBRC         IFEQ      *BLANKS
     C     TOBRC         ANDEQ     *BLANKS
     C                   GOTO      CMPTAG
     C                   END
      *
      **        IF   REF BRANCH OR TO BRANCH ARE LEFT BLANK
      **             PUT OUT ERROR :::
      *
     C     FMBRC         IFEQ      *BLANKS
     C     TOBRC         OREQ      *BLANKS
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(5)        ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C     FMBRC         COMP      *BLANKS                                34
     C     TOBRC         COMP      *BLANKS                                35
     C                   END
      *
      **        REFERENCE BRANCH AND TO BRANCH CANNOT HAVE THE
      **        SAME VALUE :::
      *
     C     FMBRC         IFNE      *BLANKS
     C     TOBRC         ANDNE     *BLANKS
     C     FMBRC         IFEQ      TOBRC
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(10)       ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C                   SETON                                          3435
     C                   END
     C                   END
      *
      **        REFERENCE BRANCH ENTERED MUST HAVE A LIVE RECORD
      **        ON THE BRANCH CODES TABLE :::
      *
     C     FMBRC         IFNE      *BLANKS
      *
      ** CALL A/O
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      FMBRC         @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     @OPTN         DBOPTN            7
     C                   MOVEL     FMBRC         DBKEY
     C                   SETON                                            22
     C     *IN22         IFEQ      '1'
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(6)        ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        34
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      A8BRCD        FMBRC
     C                   END
      *
      **        'TO' BRANCH ENTERED MUST HAVE A LIVE RECORD
      **        ON THE BRANCH CODES TABLE :::
      *
     C     TOBRC         IFNE      *BLANKS
      *
      ** CALL A/O
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      TOBRC         @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                            22
     C     *IN22         IFEQ      '1'
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(6)        ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        35
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      A8BRCD        TOBRC
     C                   END
      *
      **   3.   VALIDATE  COMPANIES :::
      **
      **        IF ENTERED, BOTH THE FIELDS MUST HAVE A VALID VALUE
      **                    BUT CANNOT BE EQUAL.
      *
     C     CMPTAG        TAG
     C     FMCMP         IFEQ      *BLANKS
     C     TOCMP         ANDEQ     *BLANKS
     C                   GOTO      CHKEND
     C                   END
     C     FMCMP         IFEQ      *BLANKS
     C     TOCMP         OREQ      *BLANKS
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(7)        ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C     FMCMP         COMP      *BLANKS                                36
     C     TOCMP         COMP      *BLANKS                                37
     C                   END
      *
     C     FMCMP         IFEQ      TOCMP
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(11)       ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C                   SETON                                          3637
     C                   END
      *
      **        REFERENCE COMPANY & 'TO' COMPANY MUST EXIST ON TABLE
      **
      *
      ** CALL A/O
      *
     C                   CALL      'AOCOMPR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      FMCMP         @DSNB             3
     C     SDCOMP        PARM      SDCOMP        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                            22
     C     *IN22         IFEQ      '1'
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(8)        ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        36
     C                   END
     C                   ELSE
     C                   MOVE      APCMCD        FMCMP
     C                   END
      *
      ** CALL A/O
      *
     C                   CALL      'AOCOMPR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      TOCMP         @DSNB             3
     C     SDCOMP        PARM      SDCOMP        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   SETON                                            22
     C     *IN22         IFEQ      '1'
     C     *IN20         IFEQ      '0'
     C                   MOVEL     ERR(8)        ERMSG
     C                   SETON                                            20
     C                   END
     C     ERROR         ADD       1             ERROR
     C                   SETON                                        37
     C                   END
     C                   ELSE
     C                   MOVE      APCMCD        TOCMP
     C                   END
      *
     C     CHKEND        TAG
      *
     C     ERROR         COMP      0                                      10
     C     *IN34         IFEQ      '1'
     C     *IN35         OREQ      '1'
     C     X             ADD       1             X
     C                   MOVE      ' 206'        ERC(X)
     C                   END
     C     *IN36         IFEQ      '1'
     C     *IN37         OREQ      '1'
     C     X             ADD       1             X
     C                   MOVE      ' 207'        ERC(X)
     C                   END
     C     *IN10         IFEQ      '0'
     C                   MOVEA     ERC           ERCD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * UPDAT     - Update Subroutine                                 *
      *                                                               *
      *****************************************************************
     C     UPDAT         BEGSR
      *
      **   1.   MUSER :::
      **        ADD A NEW RECORD TO MUSERDD
      **        UPDATE  TRAILER DETAILS FOR MUSERZZ
      *
     C                   MOVE      *BLANKS       RECI
     C     RFUSR         CHAIN     MUSER                              22
     C     *IN22         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     50            DBASE
     C                   MOVE      'MUSER'       DBFILE
     C                   MOVE      'SF000040'    DBPGM
     C                   MOVEL     RFUSR         DBKEY
     C                   SETON                                        U7U8
     C                   GOTO      UPDEND
     C                   END
      *
      **   IF 'FROM BRANCH' THE SAME AS REF USER'S DEFAULT BRANCH, MAKE
      **   'TO BRANCH' THE NEW USER'S DEFAULT BRANCH AS WELL
      *
     C     FMBRC         IFEQ      DBRNX
     C                   MOVE      TOBRC         DBRN
     C                   END
      *
     C                   MOVE      NWUSR         USRP
     C                   MOVEL     NWDES         USER1
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C                   Z-ADD     0             SOCNT
     C                   MOVE      NDIRID        DIRID
     C                   MOVE      NDIRAD        DIRAD
      *
      ** If feature Security on Journal Entry Input is *ON
      *
     C     CGL008        IFEQ      'Y'
      *
      ** Set-up the new fields on PF/MUSERDD.
      *
     C                   MOVE      'N'           ALACOD
     C                   MOVE      'Z'           USRLVL
     C                   MOVE      'N'           REFFLG
     C                   MOVE      NWUSR         REFUSR
     C                   ENDIF
      *
     C/COPY WNCPYSRC,SFH00222
     C                   WRITE     MUSERDDF
      *
      ** Update the trailer file.
      *
     C/COPY WNCPYSRC,SFH00223
     C                   OPEN      MUSERZZ
     C                   READ      MUSERZZ                                26
     C                   ADD       1             NORE
     C                   UPDATE    MUSERZZF
     C                   CLOSE     MUSERZZ
     C/COPY WNCPYSRC,SFH00224
      *
      **   3.   MBRBS :::      (BOOKING BRANCHES)
      **        ADD A NEW RECORD TO MBRBSDD
      **        SWAP BRANCHES ENTERED
      **        ONLY IF MBIN (AGF1ST) IS Y.
      *
     C     BKBRUP        TAG
     C     AGMBIN        CABNE     'Y'           MACUP
     C     BRBS          CABNE     'Y'           ORBRUP
     C                   Z-ADD     0             FI                3 0
     C                   Z-ADD     0             TI                3 0
     C                   MOVE      *BLANKS       RECI
     C     RFUSR         CHAIN     MBRBS                              22
     C     *IN22         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     70            DBASE
     C                   MOVE      'MBRBS'       DBFILE
     C                   MOVE      'SF000040'    DBPGM
     C                   MOVEL     RFUSR         DBKEY
     C                   SETON                                        U7U8
     C                   GOTO      UPDEND
     C                   END
     C                   MOVEL     NWUSR         USRP
      *
      **        SWAP BRANCHES ONLY IF EITHER BRANCH INPUT IS NOT
      **        ALREADY PRESENT.  SORT ARRAY BEFORE OUTPUT.
      *
     C     FMBRC         IFNE      *BLANKS
     C                   Z-ADD     1             I                 3 0
     C                   MOVEA     VBRX          ABR
     C     FMBRC         LOOKUP    ABR(I)                                 23
     C   23              Z-ADD     I             FI
     C                   Z-ADD     1             I                 3 0
     C     TOBRC         LOOKUP    ABR(I)                                 23
     C   23              Z-ADD     I             TI
     C     FI            IFEQ      *ZEROS
     C     TI            OREQ      *ZEROS
     C     FI            IFNE      *ZEROS
     C                   MOVE      TOBRC         ABR(FI)
     C                   END
     C     TI            IFNE      *ZEROS
     C                   MOVE      FMBRC         ABR(TI)
     C                   END
     C                   SORTA     ABR
     C                   END
     C                   MOVEA     ABR           VBRX
     C                   END
      *
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C/COPY WNCPYSRC,SFH00225
     C                   WRITE     MBRBSDDF
     C/COPY WNCPYSRC,SFH00226
      *
      **   4.   MBROS :::      (ORIGINATING BRANCHES)
      **        ADD A NEW RECORD TO MBROSDD
      **        SWAP BRANCHES ENTERED
      **        ONLY IF MBIN (AGF1ST) IS Y.
      **        AND  ONLY IF OBUV (BKOBUV) IS Y.
      *
     C     ORBRUP        TAG
     C     BKOBUV        CABNE     'Y'           CMPYUP
     C     BROS          CABNE     'Y'           CMPYUP
     C                   Z-ADD     0             FI                3 0
     C                   Z-ADD     0             TI                3 0
     C                   MOVE      *BLANKS       RECI
     C     RFUSR         CHAIN     MBROS                              22
     C     *IN22         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     80            DBASE
     C                   MOVE      'MBROS'       DBFILE
     C                   MOVE      'SF000040'    DBPGM
     C                   MOVEL     RFUSR         DBKEY
     C                   SETON                                        U7U8
     C                   GOTO      UPDEND
     C                   END
     C                   MOVEL     NWUSR         USRP
      *
      **        SWAP BRANCHES ONLY IF EITHER BRANCH INPUT IS NOT
      **        ALREADY PRESENT.  SORT ARRAY BEFORE OUTPUT.
      *
     C     FMBRC         IFNE      *BLANKS
     C                   Z-ADD     1             I                 3 0
     C                   MOVEA     VBRX          ABR
     C     FMBRC         LOOKUP    ABR(I)                                 23
     C   23              Z-ADD     I             FI
     C                   Z-ADD     1             I                 3 0
     C     TOBRC         LOOKUP    ABR(I)                                 23
     C   23              Z-ADD     I             TI
     C     FI            IFEQ      *ZEROS
     C     TI            OREQ      *ZEROS
     C     FI            IFNE      *ZEROS
     C                   MOVE      TOBRC         ABR(FI)
     C                   END
     C     TI            IFNE      *ZEROS
     C                   MOVE      FMBRC         ABR(TI)
     C                   END
     C                   SORTA     ABR
     C                   END
     C                   MOVEA     ABR           VBRX
     C                   END
      *
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C                   WRITE     MBROSDDF
      *
      **   5.   MCMPS :::      (COMPANIES)
      **        ADD A NEW RECORD TO MCMPSDD
      **        SWAP COMPANIES ENTERED
      **        ONLY IF MBIN (AGF1ST) IS Y.
      *
     C     CMPYUP        TAG
     C     CMPS          CABNE     'Y'           MACUP
     C                   Z-ADD     0             FI                3 0
     C                   Z-ADD     0             TI                3 0
     C                   MOVE      *BLANKS       RECI
     C     RFUSR         CHAIN     MCMPS                              22
     C     *IN22         IFEQ      '1'
     C     RECI          ORNE      'D'
     C                   Z-ADD     90            DBASE
     C                   MOVE      'MCMPS'       DBFILE
     C                   MOVE      'SF000040'    DBPGM
     C                   MOVEL     RFUSR         DBKEY
     C                   SETON                                        U7U8
     C                   GOTO      UPDEND
     C                   END
     C                   MOVEL     NWUSR         USRP
      *
      **        SWAP COMPANIES ONLY IF EITHER COMPANY INPUT IS NOT
      **        ALREADY PRESENT.  SORT ARRAY BEFORE OUTPUT.
      *
     C     FMCMP         IFNE      *BLANKS
     C                   Z-ADD     1             I                 3 0
     C                   MOVEA     VCMP          ABR
     C     FMCMP         LOOKUP    ABR(I)                                 23
     C   23              Z-ADD     I             FI
     C                   Z-ADD     1             I                 3 0
     C     TOCMP         LOOKUP    ABR(I)                                 23
     C   23              Z-ADD     I             TI
     C     FI            IFEQ      *ZEROS
     C     TI            OREQ      *ZEROS
     C     FI            IFNE      *ZEROS
     C                   MOVE      TOCMP         ABR(FI)
     C                   END
     C     TI            IFNE      *ZEROS
     C                   MOVE      FMCMP         ABR(TI)
     C                   END
     C                   SORTA     ABR
     C                   END
     C                   MOVEA     ABR           VCMP
     C                   END
      *
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C/COPY WNCPYSRC,SFH00227
     C                   WRITE     MCMPSDDF
     C/COPY WNCPYSRC,SFH00228
      *
      **   6.   MACBR :::      (BRANCH/ACTION CODES)
      **        ADD RECORDS TO MACBRDD AND SWAP BRANCH CODES
      **        IF ENTERED, AND FOUND ON THE RECORD JUST READ,
      **        ONLY IF MBIN (AGF1ST) IS Y.
      *
     C     MACUP         TAG
     C     ACDS          CABNE     'Y'           UPDEND
     C     AGMBIN        CABNE     'Y'           ACTUP
     C     MACKEY        SETLL     MACBR                                  24
     C     MACKEY        READE     MACBR                                  24
     C     *IN24         DOWEQ     '0'
     C                   MOVEL     NWUSR         USRP
     C     FMBRC         IFEQ      BRCB
     C                   MOVE      TOBRC         BRCB
     C                   ELSE
     C     TOBRC         IFEQ      BRCB
     C                   MOVE      FMBRC         BRCB
     C                   END
     C                   END
      *
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C/COPY WNCPYSRC,SFH00229
     C                   WRITE     MACBRDDO
     C/COPY WNCPYSRC,SFH00230
     C     MACKEY        READE     MACBR                                  24
     C                   END
      *
      **   7.   MACBR :::      (ACTION CODES O N L Y)
      **        ADD RECORDS TO MACBRDD AND CHANGE USERID.
      **        ONLY IF MBIN (AGF1ST) IS Y.
      *
     C     ACTUP         TAG
     C*****AGMBIN        CABEQ     'Y'           UPDEND                                       241033
     C     AGMBIN        CABEQ     'Y'           COMEND                                       241033
     C     MACKEY        SETLL     MACBR                                  24
     C     MACKEY        READE     MACBR                                  24
     C     *IN24         DOWEQ     '0'
     C                   MOVEL     NWUSR         USRP
     C                   MOVE      AGRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   TIME                    TIMEP             6 0
     C                   Z-ADD     TIMEP         LCT
     C/COPY WNCPYSRC,SFH00231
     C                   WRITE     MACBRDDO
     C/COPY WNCPYSRC,SFH00232
     C     MACKEY        READE     MACBR                                  24
     C                   END
      *                                                                                       241033
     C     COMEND        TAG                                                                  241033
     C                   CALL      'SF000041'                                                 241013
     C                   PARM                    RFUSR                                        241013
     C                   PARM                    NWUSR                                        241013
     C                   PARM                    NEWDSC                                       241013
      *                                                                                       241013
     C                   COMMIT                                                            BUG10744A
      *
     C     UPDEND        TAG
     C                   ENDSR
      *
     ******************************************************************
**      ERROR MESSAGES
REFERENCE USER PROFILE NOT FOUND
NEW USER PROFILE ALREADY EXISTS
INVALID INPUT
NEW USER PROFILE DESCRIPTION CANNOT BE BLANK
BOTH REFERENCE & 'TO' BRANCHES MUST BE ENTERED
INVALID BRANCH CODE
BOTH REFERENCE & 'TO' COMPANIES MUST BE ENTERED
INVALID COMPANY CODE
NEW USER PROFILE ENTRY NOT VALID
BRANCH VALUES CANNOT BE EQUAL. LEAVE FIELDS BLANK
COMPANY VALUES CANNOT BE EQUAL. LEAVE FIELDS BLANK
*SECADM AUTHORITY REQUIRED FOR DIRECTORY ENTRY. LEAVE FIELDS BLANK
DIRECTORY ID/ADDRESS ALREADY PRESENT. TRY ALTERNATIVE ID/ADDRESS
AN AS/400 USER PROFILE MUST EXIST FOR THE ENTRY OF DIRECTORY FIELDS
     X/COPY WNCPYSRC,SFH00233
**   A2Z  ARRAY!
ABCDEFGHIJKLMNOPQRSTUVWXYZ
