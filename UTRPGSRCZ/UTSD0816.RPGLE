000100191116     H DEBUG
000200200114      ********************************************************************
000300200120/*STD *  RPGBASEBND                                                      *
000400200114/*EXI *  TEXT('Midas SD MD-39572 Utility program for SDNARRPD')          *
000500200114      ********************************************************************
000600200114      *                                                                  *
000700200114      *  Midas - Standing Data Module                                    *
000800200114      *                                                                  *
000900200120      *    UTSD0816 - SD MD-39572 Utility program for SDNARRPD           *
001000200114      *                                                                  *
001100200120      *  (c) Finastra International Limited 2020                         *
001200200114      *                                                                  *
001300200114      *                 MD039572 *CREATE   Date 14Jan20                  *
001400200114      ********************************************************************
001500200114      *                                                                  *
001600200114      *  MD039572 - FAILED COMPONENT DURING COB - COMPONENT DLC0606C     *
001700200114      ********************************************************************
001800191116     F*FSTART                                                            *
001900191116      ********************************************************************
002000191116     FSDNARRL1  IF   E           K DISK    USROPN
002100200120     FUTSD0816P1O    E             PRINTER
002200200110      **
002300200110      **
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
003700191116      ************************************************************
003800191116      *MAIN
003900191116      *****************************************************
004000200110     C                   Z-ADD     0             TOTAL             4 0
004100191120     C                   Z-ADD     0             PRTLNE            2 0
004200191116     C                   OPEN      SDNARRL1
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
005500200110     C                   Z-ADD     0             LTBLK             1 0
005600200110     C                   SETOFF                                           12
005700191116     C     *LOVAL        SETLL     SDNARRL1
005800200110     C                   READ      SDNARRL1                               01
005900191116     C     *IN01         DOWEQ     *OFF
006000200110      *
006100200110      ** Scan Narrative Codes fields for leading or trailing blanks
006200200110      *
006300200110     C     ALNVCD        IFNE      *BLANK
006400200110     C     ' '           SCAN      ALNVCD        LTBLK
006500200110     C                   ENDIF
006600200110      *****
006700200110     C     LTBLK         IFNE      0
006800191120     C     *IN12         IFNE      *ON
006900191120     C                   SETON                                            12
007000200110     C                   WRITE     CPY
007100191120     C                   WRITE     HEADER
007200191120     C                   ENDIF
007300200110      *
007400200110      ** Write Narrative Codes
007500200110      *
007600191120     C                   ADD       1             TOTAL
007700191120     C                   ADD       1             PRTLNE
007800191120     C                   MOVE      ALNVCD        NVCD
007900200110     C                   MOVE      ALDON         NCDE
008000191120     C                   WRITE     DETAIL
008100200110      *****
008200200110     C     PRTLNE        IFGE      12
008300191120     C                   SETOFF                                           12
008400191120     C                   Z-ADD     0             PRTLNE
008500191120     C                   WRITE     BREAK
008600191120     C                   ENDIF
008700200110     C                   ENDIF
008800200110      *****
008900191120     C                   READ      SDNARRL1                               01
009000191116     C                   ENDDO
009100200110      *
009200200110      ** Write Footer if No Record Found
009300200110      *
009400191120     C     TOTAL         IFEQ      0
009500200110     C                   WRITE     CPY
009600200110     C                   WRITE     HEADER
009700191120     C                   SETON                                            13
009800191120     C                   ENDIF
009900191120     C                   WRITE     FOOTER
010000191116     C                   SETON                                        LR
010100191116     C                   RETURN
010200191116      *ENDMAIN
