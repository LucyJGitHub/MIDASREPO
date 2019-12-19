     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD054605
/*STD *  RPGSQLMOD                                                    *                     MD054605
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD054605
/*EXI *  TEXT('Midas AO Midas system values access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOSVALR0 - Midas System Values Access Object                 *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *                 213557             Date 23Jul02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 CSD013 *C *CREATE  Date 23Jul02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  213557 - Change driving file to one that shows all records   *
      *           regardless of whether the module or associated      *
      *           feature is present in the system.                   *
      *  CSD013 - Generic ICD system project:                         *
      *           - New program.                                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *FSTART
      ************************************************************
     F*SDSVALJ0*IF***E***        K DISK    USROPN                                             213557
     F*SDSVALL0* IF   E           K DISK    USROPN                                   213557 MD054605
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
     D SDSVAL        E DS                  EXTNAME(SDSVLJW0)                                MD054605
     D NullInds        s              5i 0 dim(21)                                          MD054605
      *
      ************************************************************
      /EJECT
      *CSTART
      *****************************************************
      *
      * Get system values for each record requested
      *
     C     P@OP01        IFNE      *BLANK
     C*****P@OP01        Chain     @SVALJ0                            9390                    213557
     C*****P@OP01        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor1 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP01                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor1                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor1 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor1                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL01 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL01 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP02        IFNE      *BLANK
     C*****P@OP02        Chain     @SVALJ0                            9390                    213557
     C*****P@OP02        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor2 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP02                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor2                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor2 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor2                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL02 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL02 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP03        IFNE      *BLANK
     C*****P@OP03        Chain     @SVALJ0                            9390                    213557
     C*****P@OP03        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor3 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP03                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor3                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor3 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor3                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL03 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL03 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP04        IFNE      *BLANK
     C*****P@OP04        Chain     @SVALJ0                            9390                    213557
     C*****P@OP04        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor4 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP04                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor4                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor4 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor4                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL04 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL04 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP05        IFNE      *BLANK
     C*****P@OP05        Chain     @SVALJ0                            9390                    213557
     C*****P@OP05        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor5 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP05                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor5                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor5 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor5                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL05 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL05 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP06        IFNE      *BLANK
     C*****P@OP06        Chain     @SVALJ0                            9390                    213557
     C*****P@OP06        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor6 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP06                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor6                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor6 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor6                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL06 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL06 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP07        IFNE      *BLANK
     C*****P@OP07        Chain     @SVALJ0                            9390                    213557
     C*****P@OP07        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor7 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP07                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor7                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor7 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor7                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL07 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL07 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP08        IFNE      *BLANK
     C*****P@OP08        Chain     @SVALJ0                            9390                    213557
     C*****P@OP08        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor8 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP08                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor8                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor8 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor8                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL08 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL08 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP09        IFNE      *BLANK
     C*****P@OP09        Chain     @SVALJ0                            9390                    213557
     C*****P@OP09        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor9 Insensitive scroll cursor for                                       MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP09                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor9                                                                        MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor9 INTO :SDSVAL :NullInds                                      MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor9                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL09 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL09 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP10        IFNE      *BLANK
     C*****P@OP10        Chain     @SVALJ0                            9390                    213557
     C*****P@OP10        Chain     @SVALL0                            9390           213557 MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor10 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP10                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor10                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor10 INTO :SDSVAL :NullInds                                     MD054605
     C/END-EXEC                                                                             MD054605
     C                   SETOFF                                       9093                  MD054605
     C                   If        SQLCODE = 100                                            MD054605
     C                   SETON                                        93                    MD054605
     C                   Else                                                               MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        90                    MD054605
     C                   Endif                                                              MD054605
     C                   Endif                                                              MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Close Cursor10                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL10 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL10 = GIVAL
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
     C**********         CLOSE     SDSVALJ0                             92        Close file  213557
     C**********         CLOSE     SDSVALL0                             92        Clo213557 MD054605
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
      *  - 10 sets of paired option and value fields
      *
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD            7
     C                   PARM                    P@OP01           20
     C                   PARM                    P@VL01          200
     C                   PARM                    P@OP02           20
     C                   PARM                    P@VL02          200
     C                   PARM                    P@OP03           20
     C                   PARM                    P@VL03          200
     C                   PARM                    P@OP04           20
     C                   PARM                    P@VL04          200
     C                   PARM                    P@OP05           20
     C                   PARM                    P@VL05          200
     C                   PARM                    P@OP06           20
     C                   PARM                    P@VL06          200
     C                   PARM                    P@OP07           20
     C                   PARM                    P@VL07          200
     C                   PARM                    P@OP08           20
     C                   PARM                    P@VL08          200
     C                   PARM                    P@OP09           20
     C                   PARM                    P@VL09          200
     C                   PARM                    P@OP10           20
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
      * Open file
      *
     C**********         OPEN      SDSVALJ0                             91        Open file   213557
     C**********         OPEN      SDSVALL0                             91        Ope213557 MD054605
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error

     C                   ENDSR
      *****************************************************************
      *ENDMAIN
**CTDATA @MG
SDSVALL0  AOSVALR0  System values access object
