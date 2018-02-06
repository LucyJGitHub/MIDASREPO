     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Book details')
      ********************************************************************
      *                                                                  *
      *  Midas  ACCESS OBJECTS
      *                                                                  *
      *     AOBOOKR1 - READ ACCESS TO BOOK DETAILS FILE                  *
      *                                                                  *
      *  (c) Finastra International Limited 2001                      *
      *                                                                  *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CSE006             Date 23Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002             Date 01May98               *
      *                    CPM004             DATE 07FEB96               *
      *                                                                  *
      ********************************************************************
      *                                                                  *
      *  MD046248 - Finastra Rebranding                               *
      *   CSE006 - Recompilation of file for REPOS enhancement           *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
      *  CPM004 - Bank Portfolios  (NEW PROGRAM)                         *
      *                                                                  *
      ********************************************************************
      *
      * ID F  C  H  L  FUNCTION OF INDICATORS
      *
      *       01       OFF ON THE FIRST RUN
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       94       END OF FILE
      *       95       NO RECORD FOUND
      *       96       OPTION ERROR
      *
      /EJECT
      *FSTART
      ************************************************************
     FSDBOOKL2  IF   E           K DISK    USROPN
      * IN  - @BOOKL2 BOOK DETAILS
      ************************************************************
      /EJECT
      *ESTART
      ************************************************************
      *
      ************************************************************
      /EJECT
      ************************************************************
     D CPYR            DS
      **  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
     D PGMDS          SDS
      * Program Status data structure
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
     D D@FMT         E DS                  EXTNAME(SDBOOKPD)
      * @BOOKL2 - BOOK DETAILS RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * Internal book code data structure.
      *
      ************************************************************
      /EJECT
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##CPY2           80
      *
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C                   PARM                    P@PTFR            4
     C                   PARM                    P@FMT
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       96
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDBOOKL2                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   CLOSE     SDBOOKL2                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   END
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '
     C     *LOVAL        SETLL     @BOOKL2                            9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   END
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '
     C                   READ      @BOOKL2                              9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '
     C     *HIVAL        SETGT     @BOOKL2                              90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   END
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '
     C                   READP     @BOOKL2                              9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@PTFR        CHAIN     @BOOKL2                            9590
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
     C   93              MOVE      '*EMPTY '     P@RTCD
     C   94              MOVE      '*EOF   '     P@RTCD
     C   95              MOVE      '*NRF   '     P@RTCD
     C   96              MOVE      '*OPTION'     P@RTCD
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   94              MOVE      'ACO1005'     P@MGID
     C   95              MOVE      'ACO1006'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANK        W@RTCD            7
     C                   PARM      PGNAME        P@PGNM           10
     C                   PARM      '*PRV'        P@DEST            5
     C                   PARM                    P@MGID            7
     C                   PARM      *BLANK        P@MSGF           10
     C                   PARM      *BLANK        P@MGKY            4
     C                   PARM                    P@MGDA           50
     C                   PARM      '*DIAG'       P@MGTP            7
     C                   END
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
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
**CTDATA @MG
SDBOOKPD  AOBOOKR1  Book Codes
**CTDATA ##CPY
(c) Finastra International Limited 2001
