     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD055681
/*STD *  RPGSQLMOD                                                                          MD055681
/*EXI *  TEXT('Midas GP Global switchable features access object')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Access Objects                                *
      *                                                               *
      *  GPAOSARDR0 - Global Switchable Features Access Object        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *   Last Amend No. MD056765         Date 16Sep20                *
      *   Prev Amend No. MD055681         Date 31Jul20                *
      *                  BUG1950          Date 21May04                *
      *                  CGP002 *CREATE   Date 18Sep03                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD056765 - Redeliver module and recompile program.           *
      *             Applied for MD056917                              *
      *  MD055681 - Deliverable Data Split for SAR                    *
      *  BUG1950- Use GPZASNMSG.                                      *
      *  CGP002 - Global Processing Switchability.                    *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L    FUNCTION OF INDICATORS                       *
      *                                                               *
      *       01      OFF 1ST TIME ROUND                              *
      *       90      FILE ERROR                                      *
      *       91      FILE OPEN ERROR                                 *
      *       92      ERROR ON FILE CLOSE                             *
      *       93      FILE EMPTY                                      *
      *       94      EOF                                             *
      *       95      NO RECORD FOUND                                 *
      *       96      PARAMETER ERROR                                 *
      *       97      IF NO SELECTION                                 *
      *       98      ERROR ON PROGRAM CALL (SDFPSRB)                 *
      *       LR      LAST RECORD                                     *
      *                                                               *
      *****************************************************************
      /EJECT
      ************************************************************
     F*GPSARDL1* IF   E           K DISK                                                    MD055681
      * IN  - @SARDL1  Switchable features
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D D@FMT         E DS                  EXTNAME(GPSARDPD)
      * GPSARDD0 - Switchable features record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * External Data structure to hold the outgoing record format
      * of the file.
      *
     D GPSARD        E DS                  EXTNAME(GPSRDJW0)                                MD055681
     D                                     PREFIX(X)                                        MD055681
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@SARD            6            I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
      *
      * Access Option *SAME input
      *
     C     P@OPTN        IFEQ      '*SAME  '
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C******LOVAL        SETLL     @SARDL1                            9390        Set file  MD055681
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C**********         READ      @SARDL1                              9094      Read recorMD055681
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C******HIVAL        SETGT     @SARDL1                              90        Set file  MD055681
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C**********         READP     @SARDL1                              9094      Read recorMD055681
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEYED ACC
     C     P@OPTN        OREQ      '*VERIFY'                                    OR
     C*****P@SARD        CHAIN     @SARDL1                            9590        Get recordMD055681
     C/EXEC SQL                                                                             MD055681
     C+ SELECT *                                                                            MD055681
     C+ into :GPSARD                                                                        MD055681
     C+ from GPSRDJW0                                                                       MD055681
     C+ where SARN = :P@SARD                                                                MD055681
     C/END-EXEC                                                                             MD055681
     C                   SETOFF                                       9095                  MD055681
     C                   IF        SQLCODE = 100                                            MD055681
     C                   SETON                                          95                  MD055681
     C                   ENDIF                                                              MD055681
     C                   IF        SQLCODE <> 100 and SQLCODE <> 0                          MD055681
     C                   SETON                                          90                  MD055681
     C                   ENDIF                                                              MD055681
                                                                                            MD055681
     C     *IN95         CABEQ     '1'           T@SKIP                           No record fnd
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      'V'           MODE
     C                   CALL      'GP3100'
      *  blank field
     C                   PARM                    PASS             16
      *  Passed as blank from AOSARDR0, returns error message,
      *  or blanks if no error found.
     C                   PARM                    RTNCDE            7
      *  Switchable feature number
     C                   PARM                    P@SARD            6
      *  MODE: 'V'  Verify is only option from AOSARDR0
     C                   PARM                    MODE              1
      *  blank field
     C                   PARM                    CORE              2
     C     RTNCDE        IFNE      *BLANKS
     C                   MOVE      *ON           *IN95
     C                   GOTO      T@SKIP
     C                   ENDIF
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parameter err
     C                   END                                                    FI 8
      *
      * Caller requests record verification: in the special case of this
      * access program, close the file.
      *
     C     P@OPTN        IFEQ      '*VERIFY'
     C                   SETON                                        LR
     C                   END
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   94              MOVE      '*EOF   '     P@RTCD                         End of file
     C   95              MOVE      '*NRF   '     P@RTCD                         No record found
     C   96              MOVE      '*OPTION'     P@RTCD                         Option error
     C   97              MOVE      '*NOSEL '     P@RTCD                         No selection
     C   98              MOVE      '*CALL  '     P@RTCD                         Called Pgm.err.
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SEND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   94              MOVE      'ACO1005'     P@MGID                           End of file
     C   95              MOVE      'ACO1006'     P@MGID                           No record fnd
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C**********         CALLB     'ZASNMG'                                       <SEND MSG>
     C                   CALL      'GPZASNMG'                                     <SEND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program nm
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message fle
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Message dta
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message tpe
     C                   END                                                    FI 9
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C**********         CALLB     'DBERRCTL'                                                 BG1950
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                    IF 13
     C     P@OPTN        ANDNE     '*FREE  '                                      AND
     C     P@RTCD        ANDNE     '*OPTION'                                      AND
     C                   eval      D@FMT = GPSARD                                           MD055681
     C                   MOVEL     D@FMT         P@FMT                          FI 13
     C                   END
      *
      * Return to caller :
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
GPSARDPD  GPAOSARDR0  Global switchable features
