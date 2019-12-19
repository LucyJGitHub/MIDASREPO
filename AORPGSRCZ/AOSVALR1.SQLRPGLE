     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD054605
/*STD *  RPGSQLMOD                                                    *                     MD054605
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD054605
/*EXI *  TEXT('Midas AO Midas system values access obj (20 vals)')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOSVALR1 - Midas System Values Access Object (20 Values)     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CPK016 *CREATE     Date 17Jun03               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054605 - Deliverable Data Split for SDSVALPD               *
      *  CPK016 - Release 5 Packaging.                                *
      *           - New program.                                      *
      *                                                               *
      *****************************************************************
      /EJECT
      *FSTART
      ************************************************************
     F*SDSVALL0* IF   E           K DISK    USROPN                                          MD054605
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
     C*****P@OP01        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP02        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP03        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP04        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP05        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP06        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP07        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP08        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP09        Chain     @SVALL0                            9390                  MD054605
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
     C*****P@OP10        Chain     @SVALL0                            9390                  MD054605
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
     C     P@OP11        IFNE      *BLANK
     C*****P@OP11        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor11 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP11                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor11                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor11 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor11                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL11 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL11 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP12        IFNE      *BLANK
     C*****P@OP12        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor12 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP12                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor12                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor12 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor12                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL12 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL12 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP13        IFNE      *BLANK
     C*****P@OP13        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor13 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP13                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor13                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor13 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor13                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL13 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL13 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP14        IFNE      *BLANK
     C*****P@OP14        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor14 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP14                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor14                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor14 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor14                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL14 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL14 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP15        IFNE      *BLANK
     C*****P@OP15        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor15 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP15                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor15                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor15 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor15                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL15 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL15 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP16        IFNE      *BLANK
     C*****P@OP16        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor16 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP16                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor16                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor16 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor16                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL16 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL16 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP17        IFNE      *BLANK
     C*****P@OP17        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor17 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP17                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor17                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor17 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor17                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL17 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL17 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP18        IFNE      *BLANK
     C*****P@OP18        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor18 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP18                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor18                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor18 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor18                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL18 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL18 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP19        IFNE      *BLANK
     C*****P@OP19        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor19 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP19                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor19                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor19 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor19                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL19 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL19 = GIVAL
     C                   ENDIF
     C                   ENDIF
      *
     C     P@OP20        IFNE      *BLANK
     C*****P@OP20        Chain     @SVALL0                            9390                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Declare Cursor20 Insensitive scroll cursor for                                      MD054605
     C+ SELECT *                                                                            MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :P@OP20                                                              MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ Open Cursor20                                                                       MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C/EXEC SQL                                                                             MD054605
     C+ FETCH NEXT FROM Cursor20 INTO :SDSVAL :NullInds                                     MD054605
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
     C+ Close Cursor20                                                                      MD054605
     C/END-EXEC                                                                             MD054605
                                                                                            MD054605
     C     *IN90         CABEQ     '1'           T@SKIP                   LR      File error
     C     *IN93         Ifeq      '1'
     C                   Eval      P@VL20 = '*NRF'
     C                   Eval      *IN83 = *ON
     C                   Else
     C                   Eval      P@VL20 = GIVAL
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
     C**********         CLOSE     SDSVALL0                             92        Close fileMD054605
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
     C                   PARM                    P@OP11           20
     C                   PARM                    P@VL11          200
     C                   PARM                    P@OP12           20
     C                   PARM                    P@VL12          200
     C                   PARM                    P@OP13           20
     C                   PARM                    P@VL13          200
     C                   PARM                    P@OP14           20
     C                   PARM                    P@VL14          200
     C                   PARM                    P@OP15           20
     C                   PARM                    P@VL15          200
     C                   PARM                    P@OP16           20
     C                   PARM                    P@VL16          200
     C                   PARM                    P@OP17           20
     C                   PARM                    P@VL17          200
     C                   PARM                    P@OP18           20
     C                   PARM                    P@VL18          200
     C                   PARM                    P@OP19           20
     C                   PARM                    P@VL19          200
     C                   PARM                    P@OP20           20
     C                   PARM                    P@VL20          200
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
     C                   CLEAR                   P@VL11          200
     C                   CLEAR                   P@VL12          200
     C                   CLEAR                   P@VL13          200
     C                   CLEAR                   P@VL14          200
     C                   CLEAR                   P@VL15          200
     C                   CLEAR                   P@VL16          200
     C                   CLEAR                   P@VL17          200
     C                   CLEAR                   P@VL18          200
     C                   CLEAR                   P@VL19          200
     C                   CLEAR                   P@VL20          200
      *
      * Open file
      *
     C**********         OPEN      SDSVALL0                             91        Open file MD054605
      *
     C     *IN91         CABEQ     '1'           T@SKIP                   LR      Open error

     C                   ENDSR
      *****************************************************************
      *ENDMAIN
**CTDATA @MG
SDSVALL0  AOSVALR1  System values access object (20 values)
