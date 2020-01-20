000100191120     H DEBUG
000200200114      ********************************************************************
000300200120/*STD *  RPGBASEBND                                                      *
000400200114/*EXI *  TEXT('Midas SD MD-39572 Utility program for GLCOAKPD')          *
000500200114      ********************************************************************
000600200114      *                                                                  *
000700200120      *  Midas - Standing Data Module                                    *
000800200114      *                                                                  *
000900200120      *   UTSD0818  - SD MD-39572 Utility program for GLCOAKPD           *
001000200114      *                                                                  *
001100200120      *  (c) Finastra International Limited 2020                         *
001200200114      *                                                                  *
001300200114      *                 MD039572 *CREATE   Date 14Jan20                  *
001400200114      ********************************************************************
001500200114      *                                                                  *
001600200114      *  MD039572 - FAILED COMPONENT DURING COB - COMPONENT DLC0606C     *
001700200114      ********************************************************************
001800191120     F*FSTART                                                            *
001900191120      ********************************************************************
002000191120     FGLCOAKL0  IF   E           K DISK    USROPN
002100200120     FUTSD0818P1O    E             PRINTER
002200200110      *
002300200110      *
002400200110     D SDBANK        E DS                  EXTNAME(SDBANKPD)
002500200110     D DSFDY         E DS                  EXTNAME(DSFDY)
002600200110     D DSRUN           DS
002700200110      **  RUNDAT data area data structure (date format -ddmmmyy)
002800200110     D  RDAT                   1      7
002900200110     D  @DD                    1      2
003000200110     D  @MMM                   3      5
003100200110     D  @YY                    6      7
003200200110     D  RUND                   8     10P 0
003300200110     D  SSF                   11     11
003400200110     D  DATF                  12     12
003500200110     D  MBIN                  13     13
003600200110      **  First data structure for access program, Short data structure
003700191120      ************************************************************
003800191120      *MAIN
003900191120      *****************************************************
004000200110     C                   Z-ADD     0             TOTAL             4 0
004100191120     C                   Z-ADD     0             PRTLNE            2 0
004200191120     C                   OPEN      GLCOAKL0
004300200110      *
004400200110      **  Access sdbankpd (via aobankr0)
004500200110      *
004600200110     C     PLIST1        PLIST
004700200110     C                   PARM      '*DBMSG  '    @RTCD             7
004800200110     C                   PARM      '*FIRST  '    @OPTN             7
004900200110     C     SDBANK        PARM      SDBANK        DSFDY
005000200110     C                   CALL      'AOBANKR0'    PLIST1
005100200110      *
005200200110      *   Retrieve rundate
005300200110     C     *DTAARA       DEFINE    RUNDAT        DSRUN
005400200110     C                   IN        DSRUN
005500191120     C                   Z-ADD     0             LTBLK             1 0
005600191120     C                   SETOFF                                           12
005700191120     C     *LOVAL        SETLL     GLCOAKL0
005800191120     C                   READ      GLCOAKL0                               01
005900191120     C     *IN01         DOWEQ     *OFF
006000191120      *
006100200110      ** Scan Narrative Codes fields for leading or trailing blanks
006200191120      *
006300191120     C     CONCD1        IFNE      *BLANK
006400191120     C     ' '           SCAN      CONCD1        LTBLK
006500191120     C     LTBLK         IFNE      0
006600191120     C                   GOTO      BLANK
006700191120     C                   ENDIF
006800191120     C                   ENDIF
006900191120      *****
007000191120     C     CONCD2        IFNE      *BLANK
007100191120     C     ' '           SCAN      CONCD2        LTBLK
007200191120     C     LTBLK         IFNE      0
007300191120     C                   GOTO      BLANK
007400191120     C                   ENDIF
007500191120     C                   ENDIF
007600191120      *****
007700191120     C     CONCD3        IFNE      *BLANK
007800191120     C     ' '           SCAN      CONCD3        LTBLK
007900191120     C     LTBLK         IFNE      0
008000191120     C                   GOTO      BLANK
008100191120     C                   ENDIF
008200191120     C                   ENDIF
008300191120      *****
008400191120     C     CONCD4        IFNE      *BLANK
008500191120     C     ' '           SCAN      CONCD4        LTBLK
008600191120     C     LTBLK         IFNE      0
008700191120     C                   GOTO      BLANK
008800191120     C                   ENDIF
008900191120     C                   ENDIF
009000191120      *****
009100191120     C     CONCD5        IFNE      *BLANK
009200191120     C     ' '           SCAN      CONCD5        LTBLK
009300191120     C     LTBLK         IFNE      0
009400191120     C                   GOTO      BLANK
009500191120     C                   ENDIF
009600191120     C                   ENDIF
009700191120      *****
009800191120     C     CONCD6        IFNE      *BLANK
009900191120     C     ' '           SCAN      CONCD6        LTBLK
010000191120     C                   ENDIF
010100191120      *****
010200191120     C     BLANK         TAG
010300191120     C     LTBLK         IFNE      0
010400191120     C     *IN12         IFNE      *ON
010500191120     C                   SETON                                            12
010600191120     C                   WRITE     CPY
010700191120     C                   WRITE     HEADER
010800191120     C                   ENDIF
010900191120      *
011000191120      ** Write Narrative Codes
011100191120      *
011200191120     C                   ADD       1             TOTAL
011300191120     C                   ADD       1             PRTLNE
011400191120     C                   MOVE      COAKEY        QAKEY
011500191120     C                   MOVE      CONCD1        NCD1#
011600191120     C                   MOVE      CONCD2        NCD2#
011700191120     C                   MOVE      CONCD3        NCD3#
011800191120     C                   MOVE      CONCD4        NCD4#
011900191120     C                   MOVE      CONCD5        NCD5#
012000191120     C                   MOVE      CONCD6        NCD6#
012100191120     C                   WRITE     DETAIL
012200200110      *****
012300200110     C     PRTLNE        IFGE      12
012400191120     C                   SETOFF                                           12
012500191120     C                   Z-ADD     0             PRTLNE
012600191120     C                   WRITE     BREAK
012700191120     C                   ENDIF
012800191120     C                   ENDIF
012900191120      *****
013000191120     C                   READ      GLCOAKL0                               01
013100191120     C                   ENDDO
013200200110      *
013300200110      ** Write Footer if No Record Found
013400200110      *
013500191120     C     TOTAL         IFEQ      0
013600200110     C                   WRITE     CPY
013700200110     C                   WRITE     HEADER
013800200110     C                   SETON                                            13
013900191120     C                   ENDIF
014000191120     C                   WRITE     FOOTER
014100191120     C                   SETON                                        LR
014200191120     C                   RETURN
014300191120      *ENDMAIN
