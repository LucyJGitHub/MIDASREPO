     H DEBUG
      *****************************************************************
/***D ***RPG***********************************************************   CAP002
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Book details')
     F********************************************************************
     F*                                                                  *
     F*  Midas  ACCESS OBJECTS
     F*                                                                  *
     F*     AOBOOKR0 - READ ACCESS TO BOOK DETAILS FILE                  *
     F*                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                                  *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
     F*     Last Amend No. CSE006             DATE 23APR99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *     Prev Amend No. CAP002             Date 01May98            *
     F*                    CPM004             DATE 07FEB96               *
     F*                    S01230             DATE 04/01/90              *S01229
     F*                    S01229             DATE 04/01/90              *S01229
     F*                    S01230             DATE 23/11/89              *S01230
     F*                    S01230             DATE 06/11/89              *S01230
     F*                    S01230             DATE 24/10/89              *S01230
     F*                    E01168             DATE 21/02/89              *S01230
     F*                                                                  *
     F********************************************************************
     F*                                                               *  *
     F*     CSE006 - Recompilation of file for REPOS enhancement      *
      *  CAP002 - Member converted from an OPM program to an ILE      *
      *           module and an ILE *PGM member of the same name has  *
      *           been created (in AOPGMSRC).                         *
      *           ILE modules can make a bound call to the module.    *
      *           OPM programs can make a dynamic call to the *PGM.   *
     F*     CPM004 - Bank Portfolios  (RECOMPILED)                    *
     F*     S01229 - FIELD NAME CHANGES                               *  *S01229
     F*     S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED     *  *S01230
     F*                                                               *  *
     F********************************************************************
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       94       END OF FILE
     F*       95       NO RECORD FOUND
     F*       96       OPTION ERROR
     F*       97       NO SELECTION
     F*       98       CALL ERROR (SDMDSRR)
     F*       99       CALL ERROR (ZASNMG)
     F*
      /EJECT
     F*FSTART
      ************************************************************
     FSDBOOKL1  IF   E           K DISK    USROPN
      * IN  - @BDREDK BOOK DETAILS    (BKCD)                              S01230
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D*                                                                   S01230
      * Description     : Copyright notice for inclusion in all programs
     D********************************************************************S01230
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all programs
     D*                                                                   S01230
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D*                                                                   S01230
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
     D*D@FMT     E DSSDBOOKD0                                             S01230
     D D@FMT         E DS                  EXTNAME(SDBOOKPD)
      * @BDREDK - BOOK DETAILS RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D*****P@FMT       DS                             44                  S01230
      * Internal book code data structure.
      *
     D*****                                   1   1 P@DMMY                S01230
     D*P@A1CD      DS                                                     S01229
     D P@BKCD          DS
      * Key slicing data structure (for Record Selection)
     D  W@SL01                 1      1
     D  W@SL02                 2      2
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OPTN            7
     C*********************PARM           P@A1CD  2        I:Key field    S01229
     C                   PARM                    P@BKCD            2
     C                   PARM                    P@FMT
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '
     C     *IN01         COMP      '0'                                    91
     C                   GOTO      T@SKIP
     C                   END
     C                   SETOFF                                       909192
     C                   SETOFF                                       939495
     C                   SETOFF                                       969798
      *
      * First call - open file :
      *
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDBOOKL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Last call - close file and terminate program :
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   CLOSE     SDBOOKL1                             92
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   SETON                                        LR
     C                   END
      *
      * Caller requests first record :
      *
     C     P@OPTN        IFEQ      '*FIRST '
     C     *LOVAL        SETLL     @BDREDK                            9390
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*NEXT  '     P@OPTN
     C                   END
      *
      * Caller requests next record :
      *
     C     P@OPTN        IFEQ      '*NEXT  '
     C                   READ      @BDREDK                              9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Caller requests last record :
      *
     C     P@OPTN        IFEQ      '*LAST  '
     C     *HIVAL        SETGT     @BDREDK                              90
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   MOVE      '*PREV  '     P@OPTN
     C                   END
      *
      * Caller requests previous record :
      *
     C     P@OPTN        IFEQ      '*PREV  '
     C                   READP     @BDREDK                              9094
     C     *IN94         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C                   END
      *
      * Caller requests record indicated by key :
      *
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*VERIFY'
     C     W@SL01        IFEQ      '?'
     C     W@SL02        OREQ      '?'
     C*********************CALL 'SDFNSRR'              98    <SELECT>     S01230
     C                   CALL      'SD0310S'                            98
     C                   PARM      *BLANK        P@RTC2            7
     C*********************PARM *BLANK    P@A1CD             B:Key        S01229
     C                   PARM      *BLANK        P@BKCD
     C     P@RTC2        COMP      *BLANK                             97
     C     *IN97         CABEQ     '1'           T@SKIP
     C     *IN98         CABEQ     '1'           T@SKIP
     C                   END
     C***********P@A1CD    CHAIN@BDREDK              9590    Get record   S01229
     C     P@BKCD        CHAIN     @BDREDK                            9590
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
     C   97              MOVE      '*NOSEL '     P@RTCD
     C   98              MOVE      '*CALL  '     P@RTCD
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
     C   97              MOVE      'ACO1009'     P@MGID
     C   98              MOVE      'ACO1010'     P@MGID
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
      *ENDMAIN
**CTDATA @MG
SDBOOKPD  AOBOOKR0  Book Codes                                            E01168
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
