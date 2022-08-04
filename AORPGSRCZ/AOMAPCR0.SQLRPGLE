     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058085
/*STD *  RPGSQLMOD                                                    *                     MD058085
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058085
/*EXI *  TEXT('Midas AO Market data feed mapping codes access obj')
      *****************************************************************
      *                                                               *
      *     Midas  ACCESS OBJECTS                                     *
      *                                                               *
      *     AOMAPCR0 - Market Data Feed Mapping Codes Access Object   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006  *CREATE    Date 29Sep00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *     CSD006 - Market Data Feeds                                *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     F*SDMAPCL0* IF   E           K DISK    USROPN                                          MD058085
      *
      *****************************************************************
      /EJECT
      ************************************************************
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D*D@FMT***      E DS                  EXTNAME(SDMAPCPD)                                MD058085
     D D@FMT         E DS                  EXTNAME(SDMAPJW0)                                MD058085
     D X@MAPC          S             32A                                                    MD058085
      * SDMAPCD0 - Market Data Feed Mapping Codes Record format data struct.
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      * External Data structure to hold the outgoing record format
      * of the file.
      *
      ************************************************************
      /EJECT
      ************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@MAPC           32            I:Option
     C                   PARM                    P@FMT                          O:FORMAT
      ************************************************************
     C                   eval      X@MAPC = P@MAPC                                          MD058085
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C**********         OPEN      SDMAPCL0                             91        Open file MD058085
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058085
     C                   SETON                                        01          Set ind.
     C*****P@RTCD        CABEQ     '*OPEN  '     T@SKIP                           Open only MD058085
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PROGR
     C**********         CLOSE     SDMAPCL0                             92        Close fileMD058085
     C******IN92         CABEQ     '1'           T@SKIP                   LR      Close erroMD058085
     C**********         SETON                                        LR          Set ind.  MD058085
     C**********         GOTO      T@SKIP                                         Return    MD058085
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST RECORD
     C******LOVAL        SETLL     SDMAPCD0                           9390        Set file  MD058085
     C******IN93         CABEQ     '1'           T@SKIP                           Empty fileMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*NEXT  '     P@OPTN                           Force *NexMD058085
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT RECORD
     C**********         READ      SDMAPCD0                             9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST RECORD
     C******HIVAL        SETGT     SDMAPCD0                             90        Set file  MD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C**********         MOVE      '*PREV  '     P@OPTN                           Force *PreMD058085
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.RE
     C**********         READP     SDMAPCD0                             9094      Read recorMD058085
     C******IN94         CABEQ     '1'           T@SKIP                           End of filMD058085
     C******IN90         CABEQ     '1'           T@SKIP                   LR      File errorMD058085
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*VERIFY'
     C     '?'           SCAN      P@MAPC                                 80
     C     *IN80         IFEQ      *ON
     C                   CALL      'SD1430'                             98
     C                   PARM      *BLANK        P@RTC2            7
     C                   PARM      'S'           P@MODE            1
     C                   PARM      *BLANK        P@MAPC
     C     *IN98         CABEQ     '1'           T@SKIP
     C     P@RTC2        CABNE     *BLANK        T@SKIP               9797
     C                   eval      X@MAPC = P@MAPC                                          MD058085
     C                   END
     C*****P@MAPC        CHAIN     SDMAPCD0                           9590                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :D@FMT                                                                         MD058085
     C+ from SDMAPJW0                                                                       MD058085
     C+ where MCMAPC = :X@MAPC                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9095                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        95                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN95         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
     C     P@OPTN        IFNE      '*KEY   '
     C     P@OPTN        ANDNE     '*NEXT  '
     C     P@OPTN        ANDNE     '*PREV  '
     C     P@OPTN        ANDNE     '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE  '
     C                   SETON                                          96
     C                   END
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD
     C   90              MOVE      '*ERROR '     P@RTCD
     C   91              MOVE      '*OPEN  '     P@RTCD
     C   92              MOVE      '*CLOSE '     P@RTCD
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Call error
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 10 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No rcd found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C                   CALL      'ZASNMG'                             99        <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM      *BLANK        P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C                   END                                                    FI
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
