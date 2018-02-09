     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Currency codes access object')
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *     GPAOCURRR0 - CURRENCY CODES                               *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK026             Date 11Jan07               *
      *                 CSD031  *CREATE    Date 10Apr06               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CPK026 - MidasPlus 1.3 packaging.  Remove bound calls.       *
      *         - Call GPZASNMG instead of ZASNMG                     *
      *  CSD031 - Enhanced Centralised Static Data                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *        D F C H L   FUNCTION INDICATOR                         *
      *                                                               *
      *        01     INITIALISATION                                  *
      *        90     FILE ERROR                                      *
      *        91     FILE OPEN ERROR                                 *
      *        92     FILE CLOSE ERROR                                *
      *        93     FILE EMPTY                                      *
      *        94     END OF FILE                                     *
      *        95     NO RECORD FOUND                                 *
      *        96     OPTION ERROR                                    *
      *        97     NO SELECTION                                    *
      *        98     ERROR ON CALL OF SELECTION PROGRAM(SD0020S)     *
      *                                                               *
      *****************************************************************
      /EJECT
      *FSTART
      ************************************************************
     FGPCURRL1  IF   E           K DISK    USROPN
      ************************************************************
      /EJECT
     D*ESTART
      ****************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D********************************************************************
      ****************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D*
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D D@FMT         E DS                  EXTNAME(GPCURRPD)
      * @A6REA3 - Currency record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
     D* External Data structure to hold the outgoing record format
     D* of the file.
      *
      *
     D P@K101          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
     D  W@SL03                 3      3
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM                    P@K101                         I:Key field
     C                   PARM                    P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME   '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
      *
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       939495     ¦ error
     C                   SETOFF                                       969798     ¦ indicators
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'                                          IF 1 FIRST TIME
     C                   SETON                                        01          Set ind.
     C                   OPEN      GPCURRL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C                   END                                                    FI 1
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '                                    IF 2 FREE PGM
     C                   CLOSE     GPCURRL1                             92        Close file
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                    FI 2
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '                                    IF 3 FIRST REC
     C     *LOVAL        SETLL     GPCURRD0                           9390        Set file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*NEXT  '     P@OPTN                           Force *Next
     C                   END                                                    FI 3
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '                                    IF 4 NEXT REC
     C                   READ      GPCURRD0                             9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 4
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '                                    IF 5 LAST REC
     C     *HIVAL        SETGT     GPCURRD0                             90        Set file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   MOVE      '*PREV  '     P@OPTN                           Force *Prev
     C                   END                                                    FI 5
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '                                    IF 6 PREV.REC
     C                   READP     GPCURRD0                             9094      Read record
     C     *IN94         CABEQ     '1'           T@SKIP                           End of file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 6
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '                                    IF 7 KEY ACCESS
     C     P@OPTN        OREQ      '*VERIFY'                                     OR         ESS
     C     W@SL01        IFEQ      '?'                                          IF 8 SELECT
     C     W@SL02        OREQ      '?'                                           OR
     C     W@SL03        OREQ      '?'                                           OR
     C                   CALL      'GP000020S'                          98        <SELECT>
     C                   PARM      *BLANK        P@RTC2            7              B:Return code
     C                   PARM      *BLANK        P@K101                           B:Key
     C     P@RTC2        COMP      *BLANK                             97          No selection
     C     *IN97         CABEQ     '1'           T@SKIP                           No selection
     C     *IN98         CABEQ     '1'           T@SKIP                           Program error
     C                   END                                                    FI 8
     C     P@K101        CHAIN     GPCURRD0                           9590        Get record
     C     *IN95         CABEQ     '1'           T@SKIP                           No rec found
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C                   END                                                    FI 7
      *
     C     P@OPTN        IFNE      '*KEY   '                                    IF 8 NOT KEYED
     C     P@OPTN        ANDNE     '*NEXT  '                                     AND NOT SEQ.
     C     P@OPTN        ANDNE     '*PREV  '                                     AND
     C     P@OPTN        ANDNE     '*VERIFY'                                     AND
     C     P@OPTN        ANDNE     '*SAME  '                                     AND
     C     P@OPTN        ANDNE     '*FREE  '                                     AND
     C                   SETON                                          96        Parm error
     C                   END                                                    FI 8
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
     C   95              MOVE      '*NRF   '     P@RTCD                         No rec found
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
     C   95              MOVE      'ACO1006'     P@MGID                           No rec found
     C   96              MOVE      'ACO1007'     P@MGID                           Option error
     C   97              MOVE      'ACO1009'     P@MGID                           No selection
     C   98              MOVE      'ACO1010'     P@MGID                           Call error
     C*****              CALLB     'ZASNMG'                                       <SEND MSG>  CPK026
     C                   CALL      'GPZASNMG'                                     <SEND MSG>  CPK026
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Pgm name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C*****              CALLB     'DBERRCTL'                                                 CPK026
     C                   CALL      'DBERRCTL'                                                 CPK026
     C                   END
      *
      *
      *
     C     P@OPTN        IFNE      '*VERIFY'
     C     P@OPTN        ANDNE     '*FREE'
     C     P@RTCD        ANDNE     '*OPTION'
     C                   MOVEL     D@FMT         P@FMT
     C                   END
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
GPCURRPD  GPAOCURRR0  Currency Codes
**CTDATA CPY@
(c) Finastra International Limited 2006
