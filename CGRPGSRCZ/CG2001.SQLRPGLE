     H DEBUG
     H CVTOPT (*GRAPHIC)                                                                    MD054955
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG COB Print Date Update Processing')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG2001 - Update of Print date on Correspondence              *
      *                                                               *
      *  Function:  This program runs daily in COB. Depending on      *
      *             the frequency the processing includes searching   *
      *             through the correspondents for those with a       *
      *             print date in the past and updating the print     *
      *             date for the next scheduled date. Also works out  *
      *             the next posting date.                            *
      *                                                               *
      *  Called By: mmCnnnn - (program name)                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 093197             Date 01Dec95               *
      *                 091826             Date 10Aug95               *
      *                 083780             DATE 16FEB95               *
      *                 S01522             DATE 24NOV94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
      *  093197 - Update print scheduled date if lower than next      *
      *           working day rather than run date. Otherwise update  *
      *           done one day after week end if date is on Sunday.   *
      *  091826 - Various print generator errors                      *
      *  083780 - Correct DB error and set up Primary reference       *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  90   -    ROLBK indicator                                    *
      *                                                               *
      *  99   -    General work indicator                             *
      *                                                               *
      *****************************************************************
     FCGCORRL1  UP   E           K DISK    INFSR(SRFILE)
     F*CGCSCHL1* UF   E           K DISK    INFSR(SRFILE)                                   MD054955
     FCGPSCHL0  IF   E           K DISK    INFSR(SRFILE)
      *
      **  Copyright array.
      *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      **  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  First DS for access programs, short data structure
      *
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D JBDTTM          DS
      * Job date/time
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
      *
      *  Defined Constants
      *
      *
     D ##HOLD          C                   CONST('HOLDMAIL')
     D ##SPRS          C                   CONST('SUPPRESS')
     D ##IMED          C                   CONST('IMMEDIATE')
      *COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D/SPACE 5
      *
     I*@CSCHL1**
     I**********    CPPSCH                      CDDPRT                          S01117
     I**********    CPNPDT                      CDDPDT                          S01117
     I**********    CPSFDY                      CDDYNB                          S01117
     I**********    CPNTDT                      CDNTDT                          S01117
     I**********    CPCFRQ                      CDCFRQ                          S01117
     I**********    CPPDAY                      CDPDAY                          S01117
     I**********    CPCITM                      CDCITM                          S01117
     I**********    CPBSNB                      CDBSNB                          S01117
     I**********    CPCACC                      CDCACC                          S01117
     I**********    CPACHG                      CDACHG                          S01117
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
     I*COPY*CGCPYSRC,SRERRI                                                                 MD054955
      *
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRINIT - Initial processing - On First Call                 *
      *   SRINZ  - Initialise Fields on Each Invocation               *
      *   *PSSR  - Exception/Error Handling                           *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRINZ  - Initialise Fields on Each Invocation  *
      *                SRFREQ - FREQUENCY PROCESSING                  *
      *****************************************************************
      *
      **  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      * field
      *................................................................
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
      *
      **  Initial processing - Once Only
      *
     C     *IN20         IFEQ      *OFF                                         B1
     C                   EXSR      SRINIT                                        1
     C                   MOVE      *ON           *IN20                           1
     C                   ENDIF                                                  E1
      *                                                                   083780
      **  Set up Primary Reference to be Correspondent Key                083780
      *                                                                   083780
     C                   MOVEL     CDCORR        W0PREF                                        08378
      *
      *  Must be Within Activation Period
      *
     C     CDATDT        IFLE      BJRDNB                                       B1
     C     CDDADT        ANDGE     BJRDNB                                        1
     C     CDATDT        ORLE      BJRDNB                                       O1
     C     CDDADT        ANDEQ     0                                             1
     C                   EXSR      SRFREQ                                        1
     C                   ENDIF                                                  E1
      *................................................................
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRFREQ                                         *
      * Function    :  Calculate Next PRINT DATE, POSTING DATE        *
      *                                                               *
      * Called by   :                                                 *
      * Calls       :  SRDATE - DATE CALCULATION                      *
      *****************************************************************
     C     SRFREQ        BEGSR
      *
      **  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFREQ'      @STK(Q)
      *
      *................................................................
      *
      *          Reset Schedule flag field
      *
     C                   MOVEL     'N'           ##CSCH            1            Schedule read
      *
      *          Calculate dates for primary correspondent
      *
     C                   EXSR      SRDATE
     C     ##UPDT        IFEQ      'Y'                                          B1
     C                   MOVEL     ##JOB         CDAJOB                         Job name
     C                   MOVEL     ##USR         CDAUSR                         User name
     C                   TIME                    ##JTM
     C                   Z-ADD     ##JTM         CDATIM                         Action Time
     C                   MOVEL     BJMRDT        CDARDT                         Action Date
     C                   MOVEL     'A'           CDAACT                         Action Type
     C                   Z-ADD     BJRDNB        CDRDNB                         Run day number
     C                   UPDATE    @CORRL1                                       1
     C                   ENDIF                                                  E1
      *
     C*****CDCORR        SETLL     @CSCHL1                                79                MD054955
     C******IN79         IFEQ      *ON                                          B1          MD054955
     C*****CDCORR        READE     @CSCHL1                                79     1          MD054955
     C******IN79         DOWEQ     *OFF                                         B2          MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPCORR = :CDCORR and CPRECI = 'D'                                             MD054955
     C+ order by CPCORR, CPPTYP, CPPSTP, CPSEQN                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   DOW       SQLCODE = 0                                              MD054955
      *
      *          Set Schedule flag field
      *
     C                   MOVEL     'Y'           ##CSCH                         Schedule read
      *
     C                   EVAL      CDDPDT = CPNPDT                                          MD054955
     C                   EVAL      CDDPRT = CPPSCH                                          MD054955
     C                   EVAL      CDDYNB = CPSFDY                                          MD054955
     C                   EVAL      CDNTDT = CPNTDT                                          MD054955
     C                   EVAL      CDCFRQ = CPCFRQ                                          MD054955
     C                   EVAL      CDPDAY = CPPDAY                                          MD054955
     C                   EVAL      CDCITM = CPCITM                                          MD054955
     C                   EVAL      CDBSNB = CPBSNB                                          MD054955
     C                   EVAL      CDCACC = CPCACC                                          MD054955
     C                   EVAL      CDACHG = CPACHG                                          MD054955
                                                                                            MD054955
      *          Calculate dates for all related schedules
      *
     C                   EXSR      SRDATE                                        2
     C     ##UPDT        IFEQ      'Y'                                          B3
     C                   MOVEL     ##JOB         CPAJOB                         Job name
     C                   MOVEL     ##USR         CPAUSR                         User name
     C                   TIME                    ##JTM
     C                   Z-ADD     ##JTM         CPATIM                         Action Time
     C                   MOVEL     BJMRDT        CPARDT                         Action Date
     C                   MOVEL     'A'           CPAACT                         Action Type
     C                   Z-ADD     BJRDNB        CPRDNB                         Run day number
     C**********         UPDATE    @CSCHL1                                       3          MD054955
     C/EXEC SQL                                                                             MD054955
     C+ update CGCSHXTD set                                                                 MD054955
     C+   CPAJOB = :CPAJOB                                                                  MD054955
     C+ , CPAUSR = :CPAUSR                                                                  MD054955
     C+ , CPATIM = :CPATIM                                                                  MD054955
     C+ , CPARDT = :CPARDT                                                                  MD054955
     C+ , CPAACT = :CPAACT                                                                  MD054955
     C+ , CPRDNB = :CPRDNB                                                                  MD054955
     C+ where CPPCOR = :CPCORR and CPPTYP = :CPPTYP and CPPSTP = :CPPSTP                    MD054955
     C+ and CPSEQN = :CPSEQN                                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDIF                                                  E3
     C*****CDCORR        READE     @CSCHL1                                79     2          MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ENDDO                                                  E2
     C**********         ENDIF                                                  E1          MD054955
      *
      *................................................................
      *
     C     EXFREQ        TAG
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRDATE                                         *
      * Function    :  Calculate Next PRINT DATE, POSTING DATE        *
      *                                                               *
      * Called by   :  SRFREQ                                         *
      * Calls       :  SRERR  - Database Error                        *
      *                CG99FREQ - Frequency Processing                *
      *****************************************************************
     C     SRDATE        BEGSR
      *
      **  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDATE'      @STK(Q)
      *
      *................................................................
      *
     C                   MOVE      'N'           ##UPDT            1
     C***********CDDPDT    IFLE BJRDNB                     B1             093197
     C     CDDPDT        IFLT      BJDNWD                                       B1             09319
     C     CDDPDT        ANDNE     0                                             1
      *
      *          Fetch frequency
      *
     C     CDDPRT        CHAIN     CGPSCHL0                           79         1
     C     *IN79         IFEQ      *ON                                          B2
     C                   MOVEL     'CGPSCHL0'    W0PREF                                        08378
     C**********           MOVEL'CG99FREQ'W0FILE           ***************083780
     C                   MOVEL     CDDPRT        W0KEY                          * DB ERROR 2  *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD                          2
     C                   MOVEL     'MIDAS  '     W0MSGF                          2
     C                   EXSR      SRERR                                         2
     C                   ENDIF                                                  E2
      *
     C     STFREQ        IFNE      ##HOLD                                       B2
     C     STFREQ        ANDNE     ##SPRS                                        2
     C     STFREQ        ANDNE     ##IMED                                        2
      *
      *  Loop till valid date
      *
     C                   Z-ADD     1             ##005N            5 0
     C     CDDPDT        DOUGT     BJRDNB                                       D1
     C     ##005N        ORGT      1000
     C                   ADD       1             ##005N
      *
     C                   MOVEL     *BLANKS       W0FREQ
      *
      *          Calculate Print Date
      *
     C                   CALL      'CG99FREQ'                                    2
     C                   PARM      *BLANKS       ##RTCD                          2
     C                   PARM      '*NEWDATE'    W0ACT             8             2
     C                   PARM      STFREQ        W0FREQ           10             2
     C                   PARM      CDDPDT        W0RDNB            5 0           2
     C                   PARM      CDDYNB        W0MDAY            2 0           2
     C                   PARM      BJLCCY        W0CCY             3             2
     C                   PARM      BJSLCD        W0LOC             3             2
     C                   PARM                    W0EXT           256             2
     C                   MOVE      'Y'           ##UPDT                          2
      *
      **  Error in called program.
      *
     C     ##RTCD        IFNE      *BLANK                                       B3
      *
     C                   MOVEL     'CG99FREQ'    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 1  *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD                          3
     C                   MOVEL     'MIDAS  '     W0MSGF                          3
     C                   EXSR      SRERR                                         3
     C                   ENDIF                                                  E3
      *
     C                   Z-ADD     W0RDNB        CDDPDT                          2
     C                   ENDDO                                                  D1
      *
     C                   ENDIF                                                  E2
     C                   ENDIF                                                  E1
      *
     C     CDNTDT        IFLE      BJRDNB                                       B1
     C     CDNTDT        ANDNE     0                                             1
      *
      *  Loop till valid date
      *
     C                   Z-ADD     1             ##005N
     C     CDNTDT        DOUGT     BJRDNB                                       D1
     C     ##005N        ORGT      1000
     C                   ADD       1             ##005N
      *
     C                   MOVEL     *BLANKS       W0FREQ
      *
      *          Calculate Next Posting date
      *
     C                   CALL      'CG99FREQ'                                    1
     C                   PARM      *BLANKS       ##RTCD                          1
     C                   PARM      '*NEWDATE'    W0ACT             8             1
     C                   PARM      CDCFRQ        W0FREQ           10             1
     C                   PARM      CDNTDT        W0RDNB            5 0           1
     C                   PARM      CDPDAY        W0MDAY            2 0           1
     C                   PARM      BJLCCY        W0CCY             3             1
     C                   PARM      BJSLCD        W0LOC             3             1
     C                   PARM                    W0EXT           256             1
     C                   MOVE      'Y'           ##UPDT                          1
      *
      **  Error in called program.
      *
     C     ##RTCD        IFNE      *BLANK                                       B2
      *
     C                   MOVEL     'CG99FREQ'    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 1  *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD                          2
     C                   MOVEL     'MIDAS  '     W0MSGF                          2
     C                   EXSR      SRERR                                         2
     C                   ENDIF                                                  E2
      *
     C                   Z-ADD     W0RDNB        CDNTDT
      *
     C                   ENDDO                                                  D1
      *
      * If Apply charge yes then do not zero or accumulate
      *
     C     CDACHG        IFNE      'Y'                                          B2
     C                   ADD       CDBSNB        CDCACC                          2
     C                   Z-ADD     0             CDBSNB                          2
     C                   ENDIF                                                  E2
      *
      * If Apply charge on schedule turnover then add in Item Charge
      *
     C***********CDACHG    IFNE 'S'                        B2             091826
     C     CDACHG        IFEQ      'S'                                          B2             09182
     C                   Z-ADD     CDCITM        CDBSNB                          2
     C                   ENDIF                                                  E2
     C                   ENDIF                                                  E1
      *
     C     ##CSCH        IFEQ      'Y'                                          B1
     C     CPRDTE        ANDLE     BJRDNB                                        1
     C     CPRDTE        ANDNE     0                                             1
      *
      *  Loop till valid date
      *
     C                   Z-ADD     1             ##005N
     C     CPRDTE        DOUGT     BJRDNB                                       D1
     C     ##005N        ORGT      1000
     C                   ADD       1             ##005N
      *
     C                   MOVEL     *BLANKS       W0FREQ
      *
      *          Calculate Next Reset Date
      *
     C                   CALL      'CG99FREQ'                                    1
     C                   PARM      *BLANKS       ##RTCD                          1
     C                   PARM      '*NEWDATE'    W0ACT             8             1
     C                   PARM      CPRFRQ        W0FREQ           10             1
     C                   PARM      CPRDTE        W0RDNB            5 0           1
     C                   PARM      CPRSDN        W0MDAY            2 0           1
     C                   PARM      BJLCCY        W0CCY             3             1
     C                   PARM      BJSLCD        W0LOC             3             1
     C                   PARM                    W0EXT           256             1
     C                   MOVE      'Y'           ##UPDT                          1
      *
      **  Error in called program.
      *
     C     ##RTCD        IFNE      *BLANK                                       B2
      *
     C                   MOVEL     'CG99FREQ'    W0FILE                         ***************
     C                   MOVEL     ##RTCD        W0KEY                          * DB ERROR 1  *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD                          2
     C                   MOVEL     'MIDAS  '     W0MSGF                          2
     C                   EXSR      SRERR                                         2
     C                   ENDIF                                                  E2
      *
     C                   Z-ADD     W0RDNB        CPRDTE
     C                   ENDDO                                                  D1
      *
     C                   Z-ADD     0             CPOSQN
     C                   Z-ADD     0             CPNPAG
     C                   Z-ADD     0             CPTPAG
     C                   ENDIF                                                  E1
      *
      *................................................................
      *
     C     EXDATE        TAG
      *
      **  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOBANKR0 - Obtain Bank details                 *
      *                AOGELRR0 - Obtain General Ledger Details       *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      **  Call access program for Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM      '*FIRST  '    ##OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Database error
     C     ##RTCD        IFNE      *BLANK
      *
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     01            W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *................................................................
      *
      **  Define Fields
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##ACT            80
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C/SPACE 5
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
**CTDATA ##CPY
(c) Finastra International Limited 2001
