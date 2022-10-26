     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056890
/*STD *  RPGSQLBND                                                    *                     MD056890
/*EXI *  TEXT('Midas WN Window manager')                              *
     F********************************************************************
     F*                                                                  *
     F*  Midas - Windows
     F*                                                                  *
     F*   WN0010 - Windows Manager - Interface from Core to Branch       *
     F*                                                                  *
      *  (c) Finastra International Limited 2001                      *
      *
      *  Last Amend No. MD059114           Date 26Oct22               *
      *  Last Amend No. MD056555           Date 31Aug20               *
      *  Prev Amend No. MD057705           Date 21Jan21               *
      *                 MD056890           Date 11Oct20               *
      *                 MD055681           Date 31Jul20               *
      *                 MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK018             Date 19Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 120467             Date 11Jul97               *
      *                     094172           DATE 27FEB97             *
      *                     S01408           DATE 11SEP95                *
     F*                     E20534           DATE 15MAR90                *
     F*                     S01251           DATE 03FEB90                *S01251
     F*                     S01252           DATE 03FEB90                *S01252
     F*                     S01216           DATE 10OCT89                *
     F*                                                                  *
      ********************************************************************
      *                                                                  *
      *  MD059114 - At Fusion SP25 the "N" for extended Narrative        *
      *             function does not work on Account movements          *
      *           - Use the correct parameter on the cursor select       *
      *             statement.  Also mismatch (packed v zoned) on the    *
      *             window dimensions passed to the window program.      *
      *             Applied for MD060624                                 *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD057705 - Deliverable Data Split for SDOREFPD               *
      *  MD056890 - Deliverable Data Split for SDMREFPD               *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  MD046248 - Finastra Rebranding                               *
      *      CPK018 - Change to make windows switchable. Replace use of  *
      *               - Replace use of SDMREFL1 with SDMREFJ0.           *
      *      120467 - Remove change 094172 as it results in core and     *
      *               client specific windows being suppressed.          *
      *      094172 - Use two joins files to select window following     *
      *               the feature installed                              *
      *      S01408 - Addition core hook WN0010CCP1.                     *
      *      E20534 - NEED TO CALL WN0020 TO CLEAR SCREEN BUFFER         *
      *      S01251 - SYNON NAME CHANGES                                 *S01251
      *      S01252 - ADDITIONAL FIELD IN PARM                           *S01252
      *      S01216 - SYNON R1 ENHANCEMENTS.                             *
      *                                                                  *
      ********************************************************************
     F*******SDMREFL1IF  E           K        DISK                        094172
     F*******SDOREFL1IF  E           K        DISK                  UC    094172
     F*******SDMREFJ0IF  E           K        DISK                  094172120467
     F*******SDOREFJ0IF  E           K        DISK                UC094172120467
     F*SDMREFL1IF*E*******    K        DISK                                            120467 CPK018
     F*SDMREFJ0* IF   E           K DISK                                                    MD056890
     F*SDOREFL1* IF   E           K DISK    USROPN                               120467     MD057705
      ********************************************************************
      * PURPOSE OF PROGRAM - This program is called from the core input
      *                      program (in particular Synon generated
      *                      programs) to allow extra screens for display.
      *                      It will only be called if Windows are
      *                      supported.
      *                      If there are mandatory windows for the function
      *                      then the window processing program will be
      *                      called for each mandatory window.
      *                      If an Optional window is required, it will
      *                      call the window processing program for that
      *                      window only.
      ********************************************************************
      *
      *       FUNCTION OF INDICATORS
      *
      *       30       WINDOWS REFERENCE FILES - NO RECORDS FOR CALLING PGM
      *       31       MANDATORY WINDOWS REFERENCE - END OF RECORDS FOR PGM
      *       33          "        "        "      - BEGINNING OF FILE
      *
      ********************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA             DS           256
      *
      ** DATA STRUCTURE FOR DATABASE ERROR
      *
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *
     D DATA            DS          1024
      *
      ** INPUT DATA FIELD FOR PASSING THROUGH TO WINDOW CONTROLLER
      *
     D OWINDS          DS
      *
      ** OPTIONAL WINDOW DATABASE ERROR KEY FIELDS
      *
     D  NAME                   1     10
     D  FUNCKY                11     12
     D SDMREF        E DS                  EXTNAME(SDMRFJW1)                                MD056890
     D NullInds        s              5i 0 dim(17)                                          MD056890
     D SDOREF        E DS                  EXTNAME(SDOREJW0)                                MD057705
      *
     C                   MOVEA     CPY@          BIS@             80
     C*
      ** KEY LIST FOR OPTIONAL WINDOWS
     C*
     C     OWIND         KLIST
     C*********************KFLD           D3CD                            S01251
     C*********************KFLD           EECD                            S01251
     C                   KFLD                    NMCP                                          S0125
     C                   KFLD                    FNKY                                          S0125
     C*
      ** PARAMETERS PASSED FROM CORE PROGRAM
     C*
     C     *ENTRY        PLIST
     C******************** PARM           D3CD                            S01251
     C******************** PARM           EECD                            S01251
     C                   PARM                    NMCP                                          S0125
     C                   PARM                    FNKY                                          S0125
     C                   PARM                    ACTN              1
     C                   PARM                    DATA
     C                   PARM                    P@RTN             7
     C                   PARM                    SPARE           256                           S0125
     C*
     C********** *LIKE     DEFN DMD3CD    D3CD                            S01251
     C********** *LIKE     DEFN DMEECD    EECD                            S01251
     C     *LIKE         DEFINE    DMNMCP        NMCP                                          S0125
     C     *LIKE         DEFINE    DMFNKY        FNKY                                          S0125
     C/COPY WNCPYSRC,WN0010C003
     C*
      ** AN OPTIONAL WINDOW HAS BEEN REQUESTED IF A FUNCTION KEY IS PRESENT
     C*
     C********** EECD      IFEQ *BLANK                                    S01251
     C     FNKY          IFEQ      *BLANK                                                      S0125
     C                   EXSR      MANDTY
     C                   ELSE
     C                   EXSR      OPTION
     C                   END
     C*
      ** END PROGRAM
     C*
     C                   EXSR      END
     C********************************************************************
     C*
     C** S/R MANDTY - PROCESS MANDATORY WINDOWS
     C** CALLED FROM MAIN PROCESSING
     C** CALLS
     C*
     C     MANDTY        BEGSR
     C*
      ** CHECK FOR MANDATORY WINDOWS ON MANDATORY WINDOW REFERENCE FILE
     C*
     C********** D3CD      SETLLSDMREFL1                 30               S01251
     C********** NMCP      SETLLSDMREFL1                 30        S01251 094172
     C********** NMCP      SETLLSDMREFJ0                 30        094172 120467
     C********** NMCP      SETLLSDMREFL1                 30                            120467 CPK018
     C*****NMCP*         SETLL     SDMREFJ0                               30                MD056890
     C                   Z-add     0             COUNT             5 0                      MD056890
     C/EXEC SQL                                                                             MD056890
     C+ declare Cursor insensitive scroll cursor for                                        MD056890
     C+ select *                                                                            MD056890
     C+  from SDMRFJW1 where DLNMCP = :NMCP                                                 MD056890
     C/END-EXEC                                                                             MD056890
                                                                                            MD056890
     C/EXEC SQL                                                                             MD056890
     C+ open Cursor                                                                         MD056890
     C/END-EXEC                                                                             MD056890
                                                                                            MD056890
     C/EXEC SQL                                                                             MD056890
     C+ get diagnostics :Count = DB2_NUMBER_ROWS                                            MD056890
     C/END-EXEC                                                                             MD056890
                                                                                            MD056890
     C/EXEC SQL                                                                             MD056890
     C+ close Cursor                                                                        MD056890
     C/END-EXEC                                                                             MD056890
     C*
      ** IF NO RECORDS ARE FOUND, RETURN TO CALLING PROGRAM
     C*
     C******IN30         IFEQ      '0'                                                      MD056890
     C     Count         IFEQ      0                                                        MD056890
     C                   EXSR      END
     C                   END
     C*
     C********** D3CD      READESDMREFL1                 31               S01251
     C********** NMCP      READESDMREFL1                 31        S01251 094172
     C********** NMCP      READESDMREFJ0                 31        094172 120467
     C********** NMCP      READESDMREFL1                 31                            120467 CPK018
     C*****NMCP*         READE     SDMREFJ0                               31                MD056890
     C**XEC*SQL                                                                    MD056890 MD059114
     C**declare*ACursor*insensitive*scroll*cursor*for                              MD056890 MD059114
     C**select***from*SDMRFJW1                                                     MD056890 MD059114
     C**where*DLNMCP*=*:DLNMCP                                                     MD056890 MD059114
     C**order*by*DLNMCP,*DLSQNB                                                    MD056890 MD059114
     C**ND-EXEC                                                                    MD056890 MD059114
     C/EXEC SQL                                                                             MD059114
     C+ declare ACursor insensitive scroll cursor for                                       MD059114
     C+ select * from SDMRFJW1                                                              MD059114
     C+ where DLNMCP = :NMCP                                                                MD059114
     C+ order by DLNMCP, DLSQNB                                                             MD059114
     C/END-EXEC                                                                             MD059114
                                                                                            MD056890
     C/EXEC SQL                                                                             MD056890
     C+ open ACursor                                                                        MD056890
     C/END-EXEC                                                                             MD056890
                                                                                            MD056890
     C/EXEC SQL                                                                             MD056890
     C+ fetch next from ACursor into :SDMREF :NullInds                                      MD056890
     C/END-EXEC                                                                             MD056890
                                                                                            MD056890
     C*
      ** CALL EACH MANDATORY WINDOW IN TURN
     C*
     C******IN31         DOWEQ     '0'                                                      MD056890
     C     SQLCODE       DOWEQ     0                                                        MD056890
     C******************** CALL DLAKNA                                    S01251
      *                                                                                     MD059114
     C                   Z-ADD     DLLGWD        W_LGWD            3 0                      MD059114
     C                   Z-ADD     DLWDWD        W_WDWD            3 0                      MD059114
     C                   Z-ADD     DLSRWD        W_SRWD            3 0                      MD059114
     C                   Z-ADD     DLSCWD        W_SCWD            3 0                      MD059114
      *                                                                                     MD059114
     C                   CALL      DLWNCN                                                      S0125
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM      *BLANK        W0RTN             7                           S0121
     C******************** PARM           DLM2NB                          S01251
     C******************** PARM           DLM3NB                          S01251
     C******************** PARM           DLNBNB                          S01251
     C******************** PARM           DLNCNB                          S01251
     C******************** PARM           DLALNA                          S01251
     C*******************PARM                    DLLGWD                               S0125 MD059114
     C*******************PARM                    DLWDWD                               S0125 MD059114
     C*******************PARM                    DLSRWD                               S0125 MD059114
     C*******************PARM                    DLSCWD                               S0125 MD059114
     C                   PARM                    W_LGWD                                     MD059114
     C                   PARM                    W_WDWD                                     MD059114
     C                   PARM                    W_SRWD                                     MD059114
     C                   PARM                    W_SCWD                                     MD059114
     C                   PARM                    DLTTWD                                        S0125
     C                   PARM                    SPARE           256                           S0125
     C***********          PARM *BLANK    W0RTN   7                       S01216
     C*
      ** IF RETURN CODE IS NORMAL, READ NEXT MANDATORY WINDOW RECORD
     C/COPY WNCPYSRC,WNH00001
     C*
     C     W0RTN         IFEQ      *BLANK
     C********** D3CD      READESDMREFL1                 31               S01251
     C********** NMCP      READESDMREFL1                 31        S01251 094172
     C********** NMCP      READESDMREFJ0                 31        094172 120467
     C********** NMCP      READESDMREFL1                 31                            120467 CPK018
     C*****NMCP*         READE     SDMREFJ0                               31                MD056890
     C/EXEC SQL                                                                             MD056890
     C+ fetch next from ACursor into :SDMREF                                                MD056890
     C/END-EXEC                                                                             MD056890
     C                   ELSE
     C*
      ** IF RETURN CODE IS 'PREVIOUS SCREEN', READ PREVIOUS RECORD
     C*
     C     W0RTN         IFEQ      'USR0790'
     C**********           READPSDMREFL1                 33               094172
     C**********           READPSDMREFJ0                 33        094172 120467
     C**********           READPSDMREFL1                 33                            120467 CPK018
     C**********         READP     SDMREFJ0                               33                MD056890
     C/EXEC SQL                                                                             MD056890
     C+ fetch prior from ACursor into :SDMREF                                               MD056890
     C/END-EXEC                                                                             MD056890
     C*
      ** IF NO PREVIOUS RECORD, PREVIOUS SCREEN IS CALLING PROGRAM
     C*
     C***********D3CD      IFNE DLD3CD                                    S01251
     C     NMCP          IFNE      DLNMCP                                                      S0125
     C******IN33         OREQ      '1'                                                      MD056890
     C     SQLCODE       OREQ      100                                                      MD056890
     C                   MOVE      W0RTN         P@RTN
     C                   EXSR      END
     C                   END
     C*                                                                   S01408
     C/COPY WNCPYSRC,WN0010CCP1                                           S01408
     C*                                                                   S01408
     C*
      ** IF RETURN CODE IS NON-BLANK, BUT NOT 'PREVIOUS SCREEN', UPDATE
      ** RETURN CODE AND RETURN TO CALLING PROGRAM
     C*
     C                   ELSE
     C                   MOVE      W0RTN         P@RTN
     C                   EXSR      END
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C** S/R OPTION - PROCESS OPTIONAL WINDOW OF REQUEST
     C** CALLED FROM MAIN PROCESSING
     C** CALLS DBERR
     C*
     C     OPTION        BEGSR
     C*
      ** CHECK FOR MANDATORY WINDOWS ON MANDATORY WINDOW REFERENCE FILE
     C*
     C**********           OPEN SDOREFL1                                  094172
     C********** OWIND     CHAINSDOREFL1             30                   094172
     C**********           OPEN SDOREFJ0                           094172 120467
     C********** OWIND     CHAINSDOREFJ0             30            094172 120467
     C**********         OPEN      SDOREFL1                                           12046 MD057705
     C*****OWIND         CHAIN     SDOREFL1                           30              12046 MD057705
     C/EXEC SQL                                                                             MD057705
     C+ SELECT *                                                                            MD057705
     C+ into :SDOREF                                                                        MD057705
     C+ from SDOREJW0                                                                       MD057705
     C+ where DMNMCP = :NMCP and DMFNKY = :FNKY                                             MD057705
     C/END-EXEC                                                                             MD057705
     C                   setoff                                       30                    MD057705
     C                   If        SQLCODE = 100                                            MD057705
     C                   seton                                        30                    MD057705
     C                   Endif                                                              MD057705
                                                                                            MD057705
     C*
      ** IF NO RECORDS ARE FOUND, RETURN TO CALLING PROGRAM
     C*
     C     *IN30         IFEQ      '1'
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVE      'WXXXX'       DBPGM
     C*******************  MOVE D3CD      NAME                            S01251
     C*******************  MOVE EECD      FUNCKY                          S01251
     C                   MOVE      NMCP          NAME                                          S0125
     C                   MOVE      FNKY          FUNCKY                                        S0125
     C                   MOVE      OWINDS        DBKEY                          ***************
     C*******************  MOVE 'SDOREFL1'DBFILE           * DB ERROR 001*094172
     C*******************  MOVE 'SDOREFJ0'DBFILE     * DB ERROR 001*094172120467
     C                   MOVE      'SDOREFL1'    DBFILE                         * DB ERROR 001*12046
     C                   Z-ADD     1             DBASE                          ***************
     C                   OUT       LDA
     C                   EXSR      DBERR
     C                   END
     C*
      ** CALL WINDOW CONTROLLER
     C*
     C*******************  CALL DMAKNA                                    S01251
     C                   CALL      DMWNCN                                                      S0125
     C                   PARM                    ACTN
     C                   PARM                    DATA
     C                   PARM                    P@RTN             7                           S0121
     C******************** PARM           DMM2NB                          S01251
     C******************** PARM           DMM3NB                          S01251
     C******************** PARM           DMNBNB                          S01251
     C******************** PARM           DMNCNB                          S01251
     C******************** PARM           DMALNA                          S01251
     C                   PARM                    DMLGWD                                        S0125
     C                   PARM                    DMWDWD                                        S0125
     C                   PARM                    DMSRWD                                        S0125
     C                   PARM                    DMSCWD                                        S0125
     C                   PARM                    DMTTWD                                        S0125
     C                   PARM                    SPARE           256                           S0125
     C************         PARM           P@RTN   7                       S01216
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C** S/R DBERR - PROCESS DATABASE ERRORS
     C** CALLED FROM OPTION
     C** CALLS END
     C*
     C     DBERR         BEGSR
     C                   MOVE      'Y2U0004'     P@RTN
     C                   EXSR      END
     C                   ENDSR
     C********************************************************************
      /EJECT
     C********************************************************************
     C*
     C** S/R END - TERMINATE PROGRAM
     C** CALLED FROM MAIN, MANDTY, DBERR
     C** CALLS NO OTHER SUBROUTINES
     C*
     C     END           BEGSR
     C*                                                                   E20534
     C*Clear the screen buffer once all the windows have been displayed   E20534
     C*                                                                   E20534
     C/COPY WNCPYSRC,WN0010C001
     C                   CALL      'WN0020'                                                    E2053
     C                   PARM      'Q'           RQDA              1                           E2053
     C                   PARM      *BLANKS       TEXT            256                           E2053
     C                   PARM      *ZERO         WD2               3 0                         E2053
     C                   PARM      *ZERO         SROWW             3 0                         E2053
     C                   PARM      *ZERO         SCOLX             3 0                         E2053
     C                   PARM      *BLANKS       CMDK              1                           E2053
     C                   PARM      *BLANKS       ERR               1                           E2053
     C                   PARM      *BLANKS       FATR              3                           E2053
     C/COPY WNCPYSRC,WN0010C002
     C*                                                                   E20534
     C                   SETON                                        LR
     C                   RETURN
     C                   ENDSR
     C********************************************************************
** CPY@
(c) Finastra International Limited 2001
