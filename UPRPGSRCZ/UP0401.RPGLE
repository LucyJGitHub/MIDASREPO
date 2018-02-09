     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  CRTPF FILE(QTEMP/UPCMPSOF) RCDLEN(220)                       *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Report on differences on spool files')        *
      *****************************************************************
      *                                                               *
      *  Midas - Upgrade Module                                       *
      *                                                               *
      *  UP0401 - Report on differences between spool files           *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP039             Date 25Mar11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CUP009  *CREATE    Date 14Aug00               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD046248 - Finastra Rebranding                               *
      *  CUP039 - Spool file number changed from length 4 to 6.       *
      *  CUP009 - Creation of CMPOUTQ command.  This is a re-write    *
      *            of CMPCOB.                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         At least one record written                     *
      *    40         Difference found on first output queue          *
      *    50         Difference found on second output queue         *
      *    60         Reformatted line found                          *
      *    70         Moved line found                                *
      *    98         File handling error                             *
      *    99         End of file                                     *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Database version of spool file
     FUPCMPSOF  IF   E             DISK    RENAME(UPCMPSOF:UPCMPSF0)
     F                                     PREFIX(A)
 
     FUP0401P1  O    E             PRINTER USROPN INFDS(SPOOL)
      **
     D UPCMPS          DS
     D  AUPCMPSOF
     D  NumberOf               2     10A
     D  Change                 2      4A
     D  ReportLine             5    136A
 
     D RUNDAT          DS            13
     D  BJMRDT                 1      7
 
     DSPOOL            DS
     D SFILE                  83     92
     D SFNUM                 123    124B 0
     D OFLLN                 188    189B 0
     D PRTLN                 367    368B 0
 
     D cpy@            S             80    dim(1) ctdata perrcd(1)
      ** Array containing Copyright statement
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    PTITL
     C                   PARM                    PDESC
     C                   PARM                    ColDif            4
     C                   PARM                    MovLin            4
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C                   DOU       *IN99 = *ON                                  D01
      ** Read first record;
     C                   READ      UPCMPSOF                             9899
     C     *IN99         IFEQ      *ON                                          I01
     C                   GOTO      EndProgram
     C                   ENDIF                                                  E01
     C     *IN98         IFEQ      *ON                                          I01
     C                   EXSR      Error
     C                   ENDIF                                                  E01
 
      ** If record contains 'NUMBER OF ...' then it means that any differences
      **  found have finished.
     C     NumberOf      IFEQ      'NUMBER OF'                                  I01
     C                   GOTO      EndProgram
     C                   ENDIF                                                  E01
 
      ** If there is a line difference then write to report (handling page headers, etc.)
     C     Change        IFEQ      'I -'                                        I01
     C                   SETON                                        40
     C                   Z-ADD     3             LinesNeeded       1 0
     C                   ENDIF                                                  E01
     C     Change        IFEQ      'D -'                                        I01
     C                   SETON                                        50
     C                   Z-ADD     3             LinesNeeded
     C                   ENDIF                                                  E01
 
      * If column differences requested then check for these
     C     ColDif        IFEQ      '*YES'                                       I01
     C     Change        IFEQ      'RN-'                                        I02
     C                   SETON                                        60
     C                   Z-ADD     4             LinesNeeded
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
 
      * If moved lines requested then check for these
     C     MovLin        IFEQ      '*YES'                                       I01
     C     Change        IFEQ      'DM-'                                        I02
     C     Change        OREQ      'IM-'                                         02
     C                   SETON                                        70
     C                   Z-ADD     3             LinesNeeded
     C                   ENDIF                                                  E02
     C                   ENDIF                                                  E01
      * If any of the indicators are set on then write to report; if this is the
      *  first time through then open spool file
     C     *IN40         IFEQ      *ON                                          I01
     C     *IN50         OREQ      *ON                                           01
     C     *IN60         OREQ      *ON                                           01
     C     *IN70         OREQ      *ON                                           01
     C     *IN01         IFEQ      *OFF                                         I02
     C                   OPEN      UP0401P1
     C                   WRITE     HEADER                               98
     C     *IN98         IFEQ      *ON                                          I03
     C                   EXSR      Error
     C                   ENDIF                                                  E03
     C                   SETON                                        01
     C                   SETON                                        U1                      CUP039
     C                   ELSE                                                   X02
      * Check that enough lines are remaining
     C     OFLLN         SUB       PRTLN         LinesLeft         2 0
     C     LinesLeft     IFLE      LinesNeeded                                  I03
     C                   WRITE     HEADER                               98
     C     *IN98         IFEQ      *ON                                          I04
     C                   EXSR      Error
     C                   ENDIF                                                  E04
     C                   ENDIF                                                  E03
     C                   ENDIF                                                  E02
     C                   MOVEL     ReportLine    PDTL
     C                   WRITE     DETAIL                               98
     C     *IN98         IFEQ      *ON                                          I02
     C                   EXSR      Error
     C                   ENDIF                                                  E02
      ** If a reformat was found then write second line
     C     *IN60         IFEQ      *ON                                          I02
     C                   SETOFF                                       60
     C                   READ      UPCMPSOF                             9899
     C     *IN98         IFEQ      *ON                                          I03
     C                   EXSR      Error
     C                   ENDIF                                                  E03
     C                   MOVEL     ReportLine    PDTL
     C                   WRITE     DETAIL                               98
     C                   WRITE     BLANK                                98
     C     *IN98         IFEQ      *ON                                          I03
     C                   EXSR      Error
     C                   ENDIF                                                  E03
     C                   ELSE                                                   X02
     C                   WRITE     BLANK
     C     *IN98         IFEQ      *ON                                          I03
     C                   EXSR      Error
     C                   ENDIF                                                  E03
     C                   ENDIF                                                  E02
     C                   SETOFF                                       4050
 
     C                   ENDIF                                                  E01
 
     C                   ENDDO                                                  ED01
 
     C     EndProgram    TAG
     C     *IN01         IFEQ      *ON                                          I01
     C                   CLOSE     UP0401P1
     C                   SETON                                        0137      E01
     C                   ENDIF
     C                   SETON                                        LR
     C                   RETURN
 
      **************************************************************************
      * Error Subroutine                                                       *
      **************************************************************************
     C     Error         BEGSR
 
     C                   SETON                                        U7U8
     C                   GOTO      EndProgram
 
     C                   ENDSR
      **************************************************************************
**CTDATA cpy@
(c) Finastra International Limited 2001
