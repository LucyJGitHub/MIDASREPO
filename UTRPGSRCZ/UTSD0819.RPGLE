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
001100200114      *  (c) Finastra International Limited 2001                         *
001200200114      *                                                                  *
001300200114      *                 MD039572 *CREATE   Date 14Jan20                  *
001400200114      ********************************************************************
001500200114      *                                                                  *
001600200114      *  MD039572 - FAILED COMPONENT DURING COB - COMPONENT DLC0606C     *
001700200114      ********************************************************************
001800191122     F*FSTART                                                            *
001900191122      ********************************************************************
002000200110     FSEACKD    IF   E           K DISK    USROPN
002100200120     FUTSD0819P1O    E             PRINTER
002200191203      *
002300191203      *
002400191203     D SDBANK        E DS                  EXTNAME(SDBANKPD)
002500191203     D DSFDY         E DS                  EXTNAME(DSFDY)
002600191203     D DSRUN           DS
002700191203      **  RUNDAT data area data structure (date format -ddmmmyy)
002800191203     D  RDAT                   1      7
002900191203     D  @DD                    1      2
003000191203     D  @MMM                   3      5
003100191203     D  @YY                    6      7
003200191203     D  RUND                   8     10P 0
003300191203     D  SSF                   11     11
003400191203     D  DATF                  12     12
003500191203     D  MBIN                  13     13
003600191203      **  First data structure for access program, Short data structure
003700191122      ************************************************************
003800191122      *MAIN
003900191122      *****************************************************
004000200110     C                   Z-ADD     0             TOTAL             4 0
004100191122     C                   Z-ADD     0             PRTLNE            2 0
004200200110     C                   OPEN      SEACKD
004300191203      *
004400191203      **  Access sdbankpd (via aobankr0)
004500191203      *
004600191203     C     PLIST1        PLIST
004700191203     C                   PARM      '*DBMSG  '    @RTCD             7
004800191203     C                   PARM      '*FIRST  '    @OPTN             7
004900191203     C     SDBANK        PARM      SDBANK        DSFDY
005000191203     C                   CALL      'AOBANKR0'    PLIST1
005100191203      *
005200191203      *   Retrieve rundate
005300191203     C     *DTAARA       DEFINE    RUNDAT        DSRUN
005400191203     C                   IN        DSRUN
005500191122     C                   Z-ADD     0             LTBLK             1 0
005600191122     C                   SETOFF                                           12
005700200110     C     *LOVAL        SETLL     SEACKD
005800200110     C                   READ      SEACKD                                 01
005900191122     C     *IN01         DOWEQ     *OFF
006000191122      *
006100200110      ** Scan Narrative Codes fields for leading or trailing blanks
006200191122      *
006300191122     C     NCDA1         IFNE      *BLANK
006400191122     C     ' '           SCAN      NCDA1         LTBLK
006500191122     C     LTBLK         IFNE      0
006600191122     C                   GOTO      BLANK
006700191122     C                   ENDIF
006800191122     C                   ENDIF
006900191122      *****
007000191122     C     NCDA2         IFNE      *BLANK
007100191122     C     ' '           SCAN      NCDA2         LTBLK
007200191122     C     LTBLK         IFNE      0
007300191122     C                   GOTO      BLANK
007400191122     C                   ENDIF
007500191122     C                   ENDIF
007600191122      *****
007700191122     C     NCDA3         IFNE      *BLANK
007800191122     C     ' '           SCAN      NCDA3         LTBLK
007900191122     C     LTBLK         IFNE      0
008000191122     C                   GOTO      BLANK
008100191122     C                   ENDIF
008200191122     C                   ENDIF
008300191122      *****
008400191122     C     NCDA4         IFNE      *BLANK
008500191122     C     ' '           SCAN      NCDA4         LTBLK
008600191122     C     LTBLK         IFNE      0
008700191122     C                   GOTO      BLANK
008800191122     C                   ENDIF
008900191122     C                   ENDIF
009000191122      *****
009100191122     C     NCDA5         IFNE      *BLANK
009200191122     C     ' '           SCAN      NCDA5         LTBLK
009300191122     C     LTBLK         IFNE      0
009400191122     C                   GOTO      BLANK
009500191122     C                   ENDIF
009600191122     C                   ENDIF
009700191122      *****
009800191122     C     NCDA6         IFNE      *BLANK
009900191122     C     ' '           SCAN      NCDA6         LTBLK
010000191122     C                   ENDIF
010100191122      *****
010200191122     C     BLANK         TAG
010300200110     C     LTBLK         IFNE      0
010400191122     C     *IN12         IFNE      *ON
010500191122     C                   SETON                                            12
010600191203     C                   WRITE     CPY
010700191122     C                   WRITE     HEADER
010800191122     C                   ENDIF
010900191122      *
011000191122      ** Write Narrative Codes
011100191122      *
011200191122     C                   ADD       1             TOTAL
011300191122     C                   ADD       1             PRTLNE
011400191122     C                   MOVE      ACKE          ACKEY
011500191122     C                   MOVE      NCDA1         NCD1#
011600191122     C                   MOVE      NCDA2         NCD2#
011700191122     C                   MOVE      NCDA3         NCD3#
011800191122     C                   MOVE      NCDA4         NCD4#
011900191122     C                   MOVE      NCDA5         NCD5#
012000191122     C                   MOVE      NCDA6         NCD6#
012100191122     C                   WRITE     DETAIL
012200200110      *****
012300200110     C     PRTLNE        IFGE      12
012400191122     C                   SETOFF                                           12
012500191122     C                   Z-ADD     0             PRTLNE
012600191122     C                   WRITE     BREAK
012700191122     C                   ENDIF
012800200110     C                   ENDIF
012900191122      *****
013000200110     C                   READ      SEACKD                                 01
013100191122     C                   ENDDO
013200191122      *
013300191122      ** Write Footer if No Record Found
013400191122      *
013500191122     C     TOTAL         IFEQ      0
013600191122     C                   WRITE     CPY
013700200110     C                   WRITE     HEADER
013800191122     C                   SETON                                            13
013900191122     C                   ENDIF
014000191122     C                   WRITE     FOOTER
014100191122     C                   SETON                                        LR
014200191122     C                   RETURN
014300191122      *ENDMAIN
