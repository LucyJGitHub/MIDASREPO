     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Private banking ICD access object')           *
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *  AOTOFR0 - Read Access to Private Banking Details             *
      *            I.C.D Access Object                                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. 207288             Date 10Jun03               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSD011             Date 04Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001   *CREATE   Date 9Jun99                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  207288 - Recompile over changes in SDTOFPD                   *
      *           Applied for AR999664 (Child: AR999668)              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD011 - Performance Incentive Fees. Recompile over changed  *
      *           SDTOFPD.                                            *
      *  CPB001 -  'Private Banking' Module                           *
      *                                                               *
      *****************************************************************
      * ID F  C  H  L  FUNCTION OF INDICATORS
      *
      *       01       OFF ON THE FIRST RUN
      *       90       FILE ERROR
      *       91       OPEN ERROR
      *       92       CLOSE ERROR
      *       93       EMPTY FILE
      *       96       OPTION ERROR
      *
      /EJECT
      *FSTART
      ************************************************************
     FSDTOFL0   IF   E           K DISK    USROPN
      * IN  - SDTODPF PRIVATE BANKING DETAILS
      ************************************************************
      /EJECT
      *ESTART
      ************************************************************
      * Description     : Copyright notice for inclusion in all ACT progra
      *
      ********************************************************************
      /EJECT
      *ISTART
      ************************************************************
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
     D D@FMT         E DS                  EXTNAME(SDTOFPD)
      * @BTREE4 - BANK RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
     D* External Data structure to hold the outgoing record format of
     D* the file
      *
      ************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all ACT program
     D*
     D A@CPY           DS
     D* ACT Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              ACT Copyright arrS01
      ************************************************************
      /EJECT
      *CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:Format
      *****************************************************
      *MAIN
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       9396       ¦ error
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C     P@OPTN        OREQ      '*SAME  '
     C     P@OPTN        OREQ      '*VERIFY'
      *
     C     *IN01         IFEQ      '0'                                            IF2 1'st time
     C                   SETON                                        01
     C                   OPEN      SDTOFL0                              91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
      *
     C     *LOVAL        SETLL     SDTODPF                            9390        Set file
     C  N93              READ      SDTODPF                                93
      *
     C                   CLOSE     SDTOFL0                              92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   END                                                      FI2
     C                   ELSE
      *
     C     P@OPTN        IFEQ      '*FREE  '
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
     C                   SETON                                        96          Parm error
     C                   ENDIF
     C                   ENDIF
      *
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
     C   96              MOVE      '*OPTION'     P@RTCD                         No selection
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID
      *
     C                   CALLB     'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   ENDIF                                                  FI 9
      *
      *      CALLER REQUESTS DB HANDLING
      *
     C     W@RTCD        IFEQ      '*DBERR'                                     IF DB ERROR
     C     P@RTCD        ANDNE     *BLANK                                       AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF                                                  FI
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDTOFPD   AOTOFR0 Private Banking Details
**CTDATA CPY@
(c) Finastra International Limited 2001
