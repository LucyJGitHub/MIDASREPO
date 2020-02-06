     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Funds transfer details      *RDR')
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *     AOFTFRR0 - READ ACCESS TO FUNDS TRANSFER DETAILS          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CFT017             Date 12Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 19Jun00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT006             Date 06Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                    S01230             DATE 23/11/89           *   S01230
      *                    S01230             DATE 06/11/89           *   S01230
      *                    S01230             DATE 24/10/89           *   S01230
      *                    E01168             DATE 21/02/89           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT017 - Multilateral Inter-bank Exchange Fee.(Recompile)    *
      *     CFT009 - Funds Transfer Fees and Charges                  *
      *              - Converted to ILE.                              *
      *     CFT006 - Addition of RFT and CCT id to SDFTFRPD (recompile*
      *     S01230 - STANDARDISE ACCESS PROGRAM & COPYRIGHT ADDED     *   S01230
      *****************************************************************   S01230
     F* ID F  C  H  L  FUNCTION OF INDICATORS
     F*
     F*       01       OFF ON THE FIRST RUN
     F*       90       FILE ERROR
     F*       91       OPEN ERROR
     F*       92       CLOSE ERROR
     F*       93       EMPTY FILE
     F*       96       OPTION ERROR
     F*
      /EJECT
     F*FSTART
      ************************************************************
     FSDFTFRL1  IF   E           K DISK    USROPN
      * IN  - @BTREE4 FUNDS TRANSFER DETAILS (FTD)
      ************************************************************
      /EJECT
     D*ESTART
      ************************************************************
     D*                                                                   S01230
     D* Description     : Copyright notice for inclusion in all progra    S01230
     D********************************************************************S01230
      ************************************************************
      /EJECT
     D*ISTART
      ************************************************************
     D* Description     : Copyright notice for inclusion in all programs  S01230
     D*                                                                   S01230
     D A@CPY           DS                                                       S01230
      * Copyright array                                                   S01230
     D  CPY@                   1     80                                         S01230
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright     arrS01
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
     D D@FMT         E DS                  EXTNAME(SDFTFRPD)                    S01230
     D*D@FMT     E DSSDFTFRD0                                             S01230
      * @BTREE4 - FUNDS TRANSFER RECORD FORMAT DATA STRUCTURE
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)                       S01230
     I*                                                                   S01230
     I* EXTERNAL DATA STRUCTURE TO HOLD THE OUTGOING RECORD FORMAT OF     S01230
     I* THE FILE                                                          S01230
     I******P@FMT       DS                                                S01230
     I******                                  1  16 P@DMMY                S01230
      *
      ************************************************************
      /EJECT
     C*CSTART
      *****************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:Format
      *****************************************************
      *MAIN
     C     P@OPTN        IFEQ      '*SAME  '                                                   S0123
     C     *IN01         COMP      '0'                                    91                   S0123
     C                   GOTO      T@SKIP                                                      S0123
     C                   END                                                                   S0123
     C                   SETOFF                                       909192     ¦ Reset
     C                   SETOFF                                       93         ¦ error
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C     P@OPTN        OREQ      '*FREE  '
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@OPTN        OREQ      '*SAME  '
     C     *IN01         IFEQ      '0'                                            IF2
     C                   SETON                                        01
     C                   OPEN      SDFTFRL1                             91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     @BTREE4                            9390        Set file
     C  N93              READ      @BTREE4                                93
     C                   CLOSE     SDFTFRL1                             92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   SETON                                        LR          Set ind.
     C                   END                                                      FI2
     C                   ELSE
     C                   SETON                                        96          Parm error
     C                   END
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
     C                   CALL      'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
      *
      * Caller requests DB error handling :
      *
     C     W@RTCD        IFEQ      '*DBERR '                                    IF
     C     P@RTCD        ANDNE     *BLANK                                         AND
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   END                                                    FI
      *
     C     P@OPTN        IFNE      '*VERIFY'                                                   S0123
     C     P@OPTN        ANDNE     '*FREE'                                                     S0123
     C     P@RTCD        ANDNE     '*OPTION'                                                   S0123
     C                   MOVEL     D@FMT         P@FMT                                         S0123
     C                   END                                                                   S0123
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
      *ENDMAIN
**CTDATA @MG
SDFTFRPD  AOFTFRR0  Funds Transfer Details                                E01168
**CTDATA CPY@
(c) Finastra International Limited 2001
