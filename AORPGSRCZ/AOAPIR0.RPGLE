     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO API ICD access object')
      *****************************************************************
      *                                                               *
      *  Midas  ACCESS OBJECTS                                        *
      *                                                               *
      *  AOAPIR0  - Read access to API ICD
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. CAP032             Date 26Apr99               *
      *  Prev Amend No. CAP011             Date 07Sep99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CAP006             Date 11Feb99               *
      *                 CAP002  *CREATE    Date 01May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs. Recompiled        *
      *           due to changes in physical file SDAPIPD.            *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CAP006 - Recompile over changed version of SDAPIPD           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      /EJECT
      ************************************************************
     FSDAPIL1   IF   E           K DISK    USROPN
 
      /EJECT
      ************************************************************
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
 
     D D@FMT         E DS                  EXTNAME(SDAPIPD)
      * @BTREE4 - API ICD record format data structure
      *
     D P@FMT         E DS                  EXTNAME(DSFDY)
      * External Data structure to hold the outgoing record format of
      * the file
 
      * Description     : Copyright notice for inclusion in all programs
     D A@CPY           DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
 
      /EJECT
 
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      D@FMT         P@FMT                          O:Format
 
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
     C     *IN01         IFEQ      '0'                                            IF2 1'st time
     C                   SETON                                        01
     C                   OPEN      SDAPIL1                              91        Open file
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error
     C     *LOVAL        SETLL     SDAPID0                            9390        Set file
     C  N93              READ      SDAPID0                                93
     C                   CLOSE     SDAPIL1                              92        Close file
     C     *IN93         CABEQ     '1'           T@SKIP                           Empty file
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN92         CABEQ     '1'           T@SKIP                   LR      Close error
     C                   END                                                      FI2
     C                   ELSE
 
     C     P@OPTN        IFEQ      '*FREE  '
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
 
     C                   SETON                                        96          Parm error
     C                   END
     C                   END
 
      * No record found or End of file - return error code :
     C     T@SKIP        TAG                                                    +++ SKIP +++
 
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*EMPTY '     P@RTCD                         Empty file
     C   96              MOVE      '*OPTION'     P@RTCD                         No selection
 
      * Caller requests message sent to program queue :
     C     W@RTCD        IFEQ      '*MSG   '                                    IF 9 SND MSG
     C     P@RTCD        ANDNE     *BLANK                                        AND ERROR
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1004'     P@MGID                           Empty file
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALLB     'ZASNMG'                                       <SND MSG>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Prog name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Msg ID
     C                   PARM      *BLANK        P@MSGF           10              I:Msg file
     C                   PARM      *BLANK        P@MGKY            4              O:Msg key
     C                   PARM                    P@MGDA           50              I:Msg data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Msg type
     C                   END                                                    FI 9
 
      *      CALLER REQUESTS DB HANDLING
     C     W@RTCD        IFEQ      '*DBERR'                                     IF DB ERROR
     C     P@RTCD        ANDNE     *BLANK                                       AND
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END                                                    FI
 
      * Return to caller :
     C                   RETURN
 
**CTDATA @MG
SDAPIPD   AOAPIR0   API ICD
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
