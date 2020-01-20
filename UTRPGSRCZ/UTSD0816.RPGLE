     H DEBUG
      ********************************************************************
/*STD *  RPGBASEBND                                                      *
/*EXI *  TEXT('Midas SD MD-39572 Utility program for SDNARRPD')          *
      ********************************************************************
      *                                                                  *
      *  Midas - Standing Data Module                                    *
      *                                                                  *
      *    UTSD0816 - SD MD-39572 Utility program for SDNARRPD           *
      *                                                                  *
      *  (c) Finastra International Limited 2020                         *
      *                                                                  *
      *                 MD039572 *CREATE   Date 14Jan20                  *
      ********************************************************************
      *                                                                  *
      *  MD039572 - FAILED COMPONENT DURING COB - COMPONENT DLC0606C     *
      ********************************************************************
     F*FSTART                                                            *
      ********************************************************************
     FSDNARRL1  IF   E           K DISK    USROPN
     FUTSD0816P1O    E             PRINTER
      **
      **
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSRUN           DS
      **  RUNDAT data area data structure (date format -ddmmmyy)
     D  RDAT                   1      7
     D  @DD                    1      2
     D  @MMM                   3      5
     D  @YY                    6      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
      **  First data structure for access program, Short data structure
      ************************************************************
      *MAIN
      *****************************************************
     C                   Z-ADD     0             TOTAL             4 0
     C                   Z-ADD     0             PRTLNE            2 0
     C                   OPEN      SDNARRL1
      *
      **  Access sdbankpd (via aobankr0)
      *
     C     PLIST1        PLIST
     C                   PARM      '*DBMSG  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   CALL      'AOBANKR0'    PLIST1
      *
      *   Retrieve rundate
     C     *DTAARA       DEFINE    RUNDAT        DSRUN
     C                   IN        DSRUN
     C                   Z-ADD     0             LTBLK             1 0
     C                   SETOFF                                           12
     C     *LOVAL        SETLL     SDNARRL1
     C                   READ      SDNARRL1                               01
     C     *IN01         DOWEQ     *OFF
      *
      ** Scan Narrative Codes fields for leading or trailing blanks
      *
     C     ALNVCD        IFNE      *BLANK
     C     ' '           SCAN      ALNVCD        LTBLK
     C                   ENDIF
      *****
     C     LTBLK         IFNE      0
     C     *IN12         IFNE      *ON
     C                   SETON                                            12
     C                   WRITE     CPY
     C                   WRITE     HEADER
     C                   ENDIF
      *
      ** Write Narrative Codes
      *
     C                   ADD       1             TOTAL
     C                   ADD       1             PRTLNE
     C                   MOVE      ALNVCD        NVCD
     C                   MOVE      ALDON         NCDE
     C                   WRITE     DETAIL
      *****
     C     PRTLNE        IFGE      12
     C                   SETOFF                                           12
     C                   Z-ADD     0             PRTLNE
     C                   WRITE     BREAK
     C                   ENDIF
     C                   ENDIF
      *****
     C                   READ      SDNARRL1                               01
     C                   ENDDO
      *
      ** Write Footer if No Record Found
      *
     C     TOTAL         IFEQ      0
     C                   WRITE     CPY
     C                   WRITE     HEADER
     C                   SETON                                            13
     C                   ENDIF
     C                   WRITE     FOOTER
     C                   SETON                                        LR
     C                   RETURN
      *ENDMAIN
