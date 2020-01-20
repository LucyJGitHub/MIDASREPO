     H DEBUG
      ********************************************************************
/*STD *  RPGBASEBND                                                      *
/*EXI *  TEXT('Midas SD MD-39572 Utility program for SEACKD')            *
      ********************************************************************
      *                                                                  *
      *  Midas - Standing Data Module                                    *
      *                                                                  *
      *    UTSD0819  - SD MD-39572 Utility program for SEACKD            *
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
     FSEACKD    IF   E           K DISK    USROPN
     FUTSD0819P1O    E             PRINTER
      *
      *
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
     C                   OPEN      SEACKD
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
     C     *LOVAL        SETLL     SEACKD
     C                   READ      SEACKD                                 01
     C     *IN01         DOWEQ     *OFF
      *
      ** Scan Narrative Codes fields for leading or trailing blanks
      *
     C     NCDA1         IFNE      *BLANK
     C     ' '           SCAN      NCDA1         LTBLK
     C     LTBLK         IFNE      0
     C                   GOTO      BLANK
     C                   ENDIF
     C                   ENDIF
      *****
     C     NCDA2         IFNE      *BLANK
     C     ' '           SCAN      NCDA2         LTBLK
     C     LTBLK         IFNE      0
     C                   GOTO      BLANK
     C                   ENDIF
     C                   ENDIF
      *****
     C     NCDA3         IFNE      *BLANK
     C     ' '           SCAN      NCDA3         LTBLK
     C     LTBLK         IFNE      0
     C                   GOTO      BLANK
     C                   ENDIF
     C                   ENDIF
      *****
     C     NCDA4         IFNE      *BLANK
     C     ' '           SCAN      NCDA4         LTBLK
     C     LTBLK         IFNE      0
     C                   GOTO      BLANK
     C                   ENDIF
     C                   ENDIF
      *****
     C     NCDA5         IFNE      *BLANK
     C     ' '           SCAN      NCDA5         LTBLK
     C     LTBLK         IFNE      0
     C                   GOTO      BLANK
     C                   ENDIF
     C                   ENDIF
      *****
     C     NCDA6         IFNE      *BLANK
     C     ' '           SCAN      NCDA6         LTBLK
     C                   ENDIF
      *****
     C     BLANK         TAG
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
     C                   MOVE      ACKE          ACKEY
     C                   MOVE      NCDA1         NCD1#
     C                   MOVE      NCDA2         NCD2#
     C                   MOVE      NCDA3         NCD3#
     C                   MOVE      NCDA4         NCD4#
     C                   MOVE      NCDA5         NCD5#
     C                   MOVE      NCDA6         NCD6#
     C                   WRITE     DETAIL
      *****
     C     PRTLNE        IFGE      12
     C                   SETOFF                                           12
     C                   Z-ADD     0             PRTLNE
     C                   WRITE     BREAK
     C                   ENDIF
     C                   ENDIF
      *****
     C                   READ      SEACKD                                 01
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
