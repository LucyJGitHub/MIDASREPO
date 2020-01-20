000100191122     H DEBUG
000200200114      ********************************************************************
000300200120/*STD *  RPGBASEBND                                                      *
000400200114/*EXI *  TEXT('Midas SD MD-39572 Utility program for SEACKD')            *
000500200114      ********************************************************************
000600200114      *                                                                  *
000700200114      *  Midas - Standing Data Module                                    *
000800200114      *                                                                  *
000900200120      *    UTSD0819  - SD MD-39572 Utility program for SEACKD            *
001000200114      *                                                                  *
001200200120      *  (c) Finastra International Limited 2020                         *
001600200114      *                                                                  *
001700200114      *                 MD039572 *CREATE   Date 14Jan20                  *
001800200114      ********************************************************************
001900200114      *                                                                  *
002000200114      *  MD039572 - FAILED COMPONENT DURING COB - COMPONENT DLC0606C     *
002100200114      ********************************************************************
002200191122     F*FSTART                                                            *
002300191122      ********************************************************************
002400200110     FSEACKD    IF   E           K DISK    USROPN
002500200120     FUTSD0819P1O    E             PRINTER
002600191203      *
002700191203      *
002800191203     D SDBANK        E DS                  EXTNAME(SDBANKPD)
002900191203     D DSFDY         E DS                  EXTNAME(DSFDY)
003000191203     D DSRUN           DS
003100191203      **  RUNDAT data area data structure (date format -ddmmmyy)
003200191203     D  RDAT                   1      7
003300191203     D  @DD                    1      2
003400191203     D  @MMM                   3      5
003500191203     D  @YY                    6      7
003600191203     D  RUND                   8     10P 0
003700191203     D  SSF                   11     11
003800191203     D  DATF                  12     12
003900191203     D  MBIN                  13     13
004000191203      **  First data structure for access program, Short data structure
004100191122      ************************************************************
004200191122      *MAIN
004300191122      *****************************************************
004400200110     C                   Z-ADD     0             TOTAL             4 0
004500191122     C                   Z-ADD     0             PRTLNE            2 0
004600200110     C                   OPEN      SEACKD
004700191203      *
004800191203      **  Access sdbankpd (via aobankr0)
004900191203      *
005000191203     C     PLIST1        PLIST
005100191203     C                   PARM      '*DBMSG  '    @RTCD             7
005200191203     C                   PARM      '*FIRST  '    @OPTN             7
005300191203     C     SDBANK        PARM      SDBANK        DSFDY
005400191203     C                   CALL      'AOBANKR0'    PLIST1
005500191203      *
005600191203      *   Retrieve rundate
005700191203     C     *DTAARA       DEFINE    RUNDAT        DSRUN
005800191203     C                   IN        DSRUN
005900191122     C                   Z-ADD     0             LTBLK             1 0
006000191122     C                   SETOFF                                           12
006100200110     C     *LOVAL        SETLL     SEACKD
006200200110     C                   READ      SEACKD                                 01
006300191122     C     *IN01         DOWEQ     *OFF
006400191122      *
006500200110      ** Scan Narrative Codes fields for leading or trailing blanks
006600191122      *
006700191122     C     NCDA1         IFNE      *BLANK
006800191122     C     ' '           SCAN      NCDA1         LTBLK
006900191122     C     LTBLK         IFNE      0
007000191122     C                   GOTO      BLANK
007100191122     C                   ENDIF
007200191122     C                   ENDIF
007300191122      *****
007400191122     C     NCDA2         IFNE      *BLANK
007500191122     C     ' '           SCAN      NCDA2         LTBLK
007600191122     C     LTBLK         IFNE      0
007700191122     C                   GOTO      BLANK
007800191122     C                   ENDIF
007900191122     C                   ENDIF
008000191122      *****
008100191122     C     NCDA3         IFNE      *BLANK
008200191122     C     ' '           SCAN      NCDA3         LTBLK
008300191122     C     LTBLK         IFNE      0
008400191122     C                   GOTO      BLANK
008500191122     C                   ENDIF
008600191122     C                   ENDIF
008700191122      *****
008800191122     C     NCDA4         IFNE      *BLANK
008900191122     C     ' '           SCAN      NCDA4         LTBLK
009000191122     C     LTBLK         IFNE      0
009100191122     C                   GOTO      BLANK
009200191122     C                   ENDIF
009300191122     C                   ENDIF
009400191122      *****
009500191122     C     NCDA5         IFNE      *BLANK
009600191122     C     ' '           SCAN      NCDA5         LTBLK
009700191122     C     LTBLK         IFNE      0
009800191122     C                   GOTO      BLANK
009900191122     C                   ENDIF
010000191122     C                   ENDIF
010100191122      *****
010200191122     C     NCDA6         IFNE      *BLANK
010300191122     C     ' '           SCAN      NCDA6         LTBLK
010400191122     C                   ENDIF
010500191122      *****
010600191122     C     BLANK         TAG
010700200110     C     LTBLK         IFNE      0
010800191122     C     *IN12         IFNE      *ON
010900191122     C                   SETON                                            12
011000191203     C                   WRITE     CPY
011100191122     C                   WRITE     HEADER
011200191122     C                   ENDIF
011300191122      *
011400191122      ** Write Narrative Codes
011500191122      *
011600191122     C                   ADD       1             TOTAL
011700191122     C                   ADD       1             PRTLNE
011800191122     C                   MOVE      ACKE          ACKEY
011900191122     C                   MOVE      NCDA1         NCD1#
012000191122     C                   MOVE      NCDA2         NCD2#
012100191122     C                   MOVE      NCDA3         NCD3#
012200191122     C                   MOVE      NCDA4         NCD4#
012300191122     C                   MOVE      NCDA5         NCD5#
012400191122     C                   MOVE      NCDA6         NCD6#
012500191122     C                   WRITE     DETAIL
012600200110      *****
012700200110     C     PRTLNE        IFGE      12
012800191122     C                   SETOFF                                           12
012900191122     C                   Z-ADD     0             PRTLNE
013000191122     C                   WRITE     BREAK
013100191122     C                   ENDIF
013200200110     C                   ENDIF
013300191122      *****
013400200110     C                   READ      SEACKD                                 01
013500191122     C                   ENDDO
013600191122      *
013700191122      ** Write Footer if No Record Found
013800191122      *
013900191122     C     TOTAL         IFEQ      0
014000191122     C                   WRITE     CPY
014100200110     C                   WRITE     HEADER
014200191122     C                   SETON                                            13
014300191122     C                   ENDIF
014400191122     C                   WRITE     FOOTER
014500191122     C                   SETON                                        LR
014600191122     C                   RETURN
014700191122      *ENDMAIN
