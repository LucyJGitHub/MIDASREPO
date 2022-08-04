     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD058085
/*STD *  RPGSQLMOD                                                    *                     MD058085
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD058085
/*EXI *  TEXT('Midas AO Midas system references access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOSREFR0 - Midas System References Access Object             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD058085           Date 11May21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD014 *CREATE     Date 11Jun03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058085 - Deliverable Data Split for Standing Data          *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD014 - Midas system references project:                    *
      *           - New program.                                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *FSTART
      ************************************************************
     F*SDSREFL0* IF   E           K DISK    USROPN                                          MD058085
      ************************************************************
      /EJECT
      *ISTART
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
     D SDSREF        E DS                  EXTNAME(SDSRFJW0)                                MD058085
     D X@OP01          S             30A                                                    MD058085
     D X@OP02          S             30A                                                    MD058085
     D X@OP03          S             30A                                                    MD058085
     D X@OP04          S             30A                                                    MD058085
     D X@OP05          S             30A                                                    MD058085
     D X@OP06          S             30A                                                    MD058085
     D X@OP07          S             30A                                                    MD058085
     D X@OP08          S             30A                                                    MD058085
     D X@OP09          S             30A                                                    MD058085
     D X@OP10          S             30A                                                    MD058085
      *
      ************************************************************
      /EJECT
      *CSTART
      *****************************************************
      *
      * Get system reference for each record requested
      *
     C     P@OP01        IFNE      *BLANK
     C*****P@OP01        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP01                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL01 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL01 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP02        IFNE      *BLANK
     C*****P@OP02        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP02                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL02 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL02 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP03        IFNE      *BLANK
     C*****P@OP03        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP03                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL03 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL03 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP04        IFNE      *BLANK
     C*****P@OP04        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP04                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL04 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL04 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP05        IFNE      *BLANK
     C*****P@OP05        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP05                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL05 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL05 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP06        IFNE      *BLANK
     C*****P@OP06        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP06                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL06 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL06 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP07        IFNE      *BLANK
     C*****P@OP07        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP07                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL07 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL07 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP08        IFNE      *BLANK
     C*****P@OP08        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP08                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL08 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL08 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP09        IFNE      *BLANK
     C*****P@OP09        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP09                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL09 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL09 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP10        IFNE      *BLANK
     C*****P@OP10        Chain     @SREFL0                            9390                  MD058085
     C/EXEC SQL                                                                             MD058085
     C+ SELECT *                                                                            MD058085
     C+ into :SDSREF                                                                        MD058085
     C+ from SDSRFJW0                                                                       MD058085
     C+ where GKSREF = :X@OP10                                                              MD058085
     C/END-EXEC                                                                             MD058085
     C                   SETOFF                                       9093                  MD058085
     C                   If        SQLCODE = 100                                            MD058085
     C                   SETON                                        93                    MD058085
     C                   ENDIF                                                              MD058085
     C                   If        SQLCODE <> 100 and SQLCODE <> 0                          MD058085
     C                   SETON                                        90                    MD058085
     C                   ENDIF                                                              MD058085
                                                                                            MD058085
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL10 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL10 = GKREF
     C                   ENDIF
     C                   ENDIF
      *
      * No record found or End of file - return error code :
      *          _____________
     C     T@SKIP        TAG                                                    +++ SKIP +++
      *          ~~~~~~~~~~~~~
      * Close file and terminate program :
      *
     C                   SETON                                        LR          Set ind.
     C**********         CLOSE     SDSREFL0                             92        Close fileMD058085
      *
     C   83              MOVE      '1'           *IN93                          No record found
     C                   MOVE      *BLANK        P@RTCD                         No Errors
     C   90              MOVE      '*ERROR '     P@RTCD                         File error
     C   91              MOVE      '*OPEN  '     P@RTCD                         Open error
     C   92              MOVE      '*CLOSE '     P@RTCD                         Close error
     C   93              MOVE      '*NRF   '     P@RTCD                         No record found
      *
      * Caller requests message sent to program queue :
      *
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID                           File error
     C   91              MOVE      'ACO1002'     P@MGID                           Open error
     C   92              MOVE      'ACO1003'     P@MGID                           Close error
     C   93              MOVE      'ACO1006'     P@MGID                           No rcd found
     C                   CALL      'ZASNMG'                             99        <SEND MESSAGE>
     C                   PARM      *BLANK        W@RTCD            7              B:Return code
     C                   PARM      PGNAME        P@PGNM           10              I:Program name
     C                   PARM      '*PRV'        P@DEST            5              I:Destination
     C                   PARM                    P@MGID            7              I:Message ID
     C                   PARM      *BLANK        P@MSGF           10              I:Message file
     C                   PARM      *BLANK        P@MGKY            4              O:Message key
     C                   PARM      *BLANK        P@MGDA           50              I:Message data
     C                   PARM      '*DIAG'       P@MGTP            7              I:Message type
     C                   ENDIF
      *
      * Caller Requests DB Error Handling
      *
     C     W@RTCD        IFEQ      '*DBERR'
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
      * Return to caller :
      *
     C                   RETURN
      *
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
      *  These comprise:
      *  - a general return code, if any errors found
      *  - 10 sets of paired option and reference value fields
      *
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OP01           30
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           30
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           30
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           30
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           30
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           30
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           30
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           30
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           30
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           30
     C                   PARM                    P@VL10          200
      *
      * Reset Error indicators
      *
     C                   SETOFF                                       909192
     C                   SETOFF                                       93
      *
      * Reset return fields
      *
     C                   CLEAR                   P@VL01          200
     C                   CLEAR                   P@VL02          200
     C                   CLEAR                   P@VL03          200
     C                   CLEAR                   P@VL04          200
     C                   CLEAR                   P@VL05          200
     C                   CLEAR                   P@VL06          200
     C                   CLEAR                   P@VL07          200
     C                   CLEAR                   P@VL08          200
     C                   CLEAR                   P@VL09          200
     C                   CLEAR                   P@VL10          200
      *
     C                   eval      X@OP01 = P@OP01                                          MD058085
     C                   eval      X@OP02 = P@OP02                                          MD058085
     C                   eval      X@OP03 = P@OP03                                          MD058085
     C                   eval      X@OP04 = P@OP04                                          MD058085
     C                   eval      X@OP05 = P@OP05                                          MD058085
     C                   eval      X@OP06 = P@OP06                                          MD058085
     C                   eval      X@OP07 = P@OP07                                          MD058085
     C                   eval      X@OP08 = P@OP08                                          MD058085
     C                   eval      X@OP09 = P@OP09                                          MD058085
     C                   eval      X@OP10 = P@OP10                                          MD058085
                                                                                            MD058085
      * Open file
      *
     C**********         OPEN      SDSREFL0                             91        Open file MD058085
     C******IN91         CABEQ     '1'           T@SKIP                   LR      Open errorMD058085

     C                   ENDSR
      *****************************************************************
      *ENDMAIN
**CTDATA @MG
SDSREFL0  AOSREFR0  System references access object
