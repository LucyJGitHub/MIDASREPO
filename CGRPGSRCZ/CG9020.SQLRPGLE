     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Write data to UDC extract files.')
/*OVRF*: OVRDBF  EXUDT1PD  CGUDT1PD  SHARE(*NO) SECURE(*YES)        : *
/*OVRF*: OVRDBF  EXUDT2PD  CGUDT2PD  SHARE(*NO) SECURE(*YES)        : *
/*OVRF*: OVRDBF  EXUDT3PD  CGUDT3PD  SHARE(*NO) SECURE(*YES)        : *
/*OVRF*: OVRDBF  EXUDTAPD  CGUDTAPD  SHARE(*NO) SECURE(*YES)        : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG9020        - Write data to UDC extract files              *
     F*                                                               *
     F*  Function:  This program writes data to one of eight          *
     F*              database files, according to the length          *
     F*              of the data and the commitment flag.             *
     F*                                                               *
     F*  Called By: Many programs, as required.                       *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG2330            Date 29Apr04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 082060             Date 24Jan95               *
      *                 102195             Date 12Jan95               *
     F*                 S01522             DATE 22NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
     F*  BUG2330- CG programs looking at wrong dataarea for CSC022    *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  082060 - Redefine Binary fields as Decimal (9,0 Packed)      *
     F*  102195 - If an element of a path is less than 6 long the     *
     F*           path's data are added onto the new path resulting   *
     F*           in invalid data in ##GET. Clear out ##GSET before   *
     F*           Substring.                                          *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*  90 -- Error detected.                                        *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Subroutine usage                                             *
     F*  ~~~~~~~~~~~~~~~~                                             *
     F*                                                               *
     F*  SROUT  -- Write a record to the appropriate file.            *
     F*  SRAUD  -- Print the audit report.                            *
     F*  SRPATH -- Look for a path; if not found, create it.          *
     F*  SRNGRP -- Find next group.                                   *
     F*  SRBAD  -- Handle an undefined action.                        *
     F*  SRINIT -- Provides initialisation and definitions.           *
     F*                                                               *
     F*  Copied in routines:                                          *
     F*                                                               *
     F*  *PSSR  -- Program error routine.                             *
     F*  SRFILE -- File error routine.                                *
     F*  SRERR  -- Error reporting routine.                           *
     F*                                                               *
     F*****************************************************************
     F/SPACE
     F*-------------------------------------------------------------------
     F* Copied-in file definitions:
     F*
     F/COPY WNCPYSRC,CG9020FPG
     F*-------------------------------------------------------------------
     FEXUDT1PD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDT1PD:@FRM064N)
     F* Not committed,  64 bytes long
     F*-------------------------------------------------------------------
     FEXUDT2PD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDT2PD:@FRM320N)
     F* Not committed, 320 bytes long
     F*-------------------------------------------------------------------
     FEXUDT3PD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDT3PD:@FRM576N)
     F* Not committed, 576 bytes long
     F*-------------------------------------------------------------------
     FEXUDTAPD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDTAPD:@FRM832N)
     F* Not committed, 832 bytes long
     F*-------------------------------------------------------------------
     FCGUDT1PD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDT1PD:@FRM064Y)
     F                                     COMMIT
     F* Under commitment control,  64 bytes long
     F*-------------------------------------------------------------------
     FCGUDT2PD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDT2PD:@FRM320Y)
     F                                     COMMIT
     F* Under commitment control, 320 bytes long
     F*-------------------------------------------------------------------
     FCGUDT3PD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDT3PD:@FRM576Y)
     F                                     COMMIT
     F* Under commitment control, 576 bytes long
     F*-------------------------------------------------------------------
     FCGUDTAPD  O  A E             DISK    INFSR(SRFILE)
     F                                     USROPN
     F                                     RENAME(@UDTAPD:@FRM832Y)
     F                                     COMMIT
     F* Under commitment control, 832 bytes long
     F*-------------------------------------------------------------------
     F*CGGSETL1* IF   E           K DISK    INFSR(SRFILE)                                   MD054955
     F* Group set definition -- retrieval index
     F*-------------------------------------------------------------------
     FCGPATHL2  IF   E           K DISK    INFSR(SRFILE)
     F* Path by group sets:
     F*-------------------------------------------------------------------
     D/EJECT
     D*-------------------------------------------------------------------
     D* Error processing array:
     D*
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D*
     D PTH             S            256    DIM(500)                             Saved paths.
     D NON             S              6    DIM(500)                             Saved non-repeat.
     D REP             S              6    DIM(500)                             Saved repeating.
     D*
     D* Copied-in array definitions:
     D*
     D/COPY WNCPYSRC,CG9020EPG
     D*
     D/COPY WNCPYSRC,CG1010DEPG
      *                                                                                       CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      *                                                                                       CSC022
     D WCMT            S             10    DIM(10)
     D*-------------------------------------------------------------------
     D/EJECT
     D*-------------------------------------------------------------------
     D/COPY WNCPYSRC,CG9020IPG
     D*
     D* Copied-in input specifications
     D*
     D*...................................................................
     D W0FMT         E DS                  EXTNAME(CGUDTAPD)
     D*
     D* Record format of CGUDTAPD as an input parameter
     D*
     D*...................................................................
     D* Error processing data structures:
     D*
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D WDSJOB        E DS                  EXTNAME(SCCMTJOB)
     D  WCMTNO       E                     EXTFLD(COMITNUM)
     D  WJOB01       E                     EXTFLD(COMITJOB1)
     D  WJOB02       E                     EXTFLD(COMITJOB2)
     D  WJOB03       E                     EXTFLD(COMITJOB3)
     D  WJOB04       E                     EXTFLD(COMITJOB4)
     D  WJOB05       E                     EXTFLD(COMITJOB5)
     D  WJOB06       E                     EXTFLD(COMITJOB6)
     D  WJOB07       E                     EXTFLD(COMITJOB7)
     D  WJOB08       E                     EXTFLD(COMITJOB8)
     D  WJOB09       E                     EXTFLD(COMITJOB9)
     D  WJOB10       E                     EXTFLD(COMITJOB10)
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      *                                                                                       CSC022
     D*...................................................................
     D W1DTA           DS           256
     D* ______________________________________________
     D* Data structure for data being sent to CGZAUDIT
     D* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     D* Spool file name (if blank, name unchanged)
     D* N.B. To change name, I#SPLR must be Y
     D*       unless first call of program:
     D  I#SPLN                 1     10
     D* Repeat open and close of spool file:
     D  I#SPLR                11     11
     D* Report reference:
     D  I#REF                 12     21
     D* Report title (uses MSGID on CGUSRMSG):
     D  I#TITL                26     32
     D* Title underline (uses MSGID on CGUSRMSG):
     D  I#TUL                 33     39
     D* Flag to control Report Control Facility:
     D  I#RCF                 40     40
     D* Define fields for line printing:
     D  I#TEXT                41     47
     D  I#FILE                48     57
     D  I#QTY                 58     72  0
     D  I#DECS                73     73  0
     D  I#EDIT                74     74
     D  I#EXT                 75     77  0
     D  I#MORE                78     78
     D  I#SUB                 81    130
     D*...................................................................
     D* Data structure for compilation - Copyright insertion:
     D*
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright
     D*...................................................................
     D* Message translation fields:
     D*
     D DSMTR           DS
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D CGGSET        E DS                  EXTNAME(CGSETJW0)                                MD054955
     D*...................................................................
     D* Named constants holding the message IDs for the audit report:
     D*
     D*   > W#ID1 -- Total count of records written to file &1 ...:
     D*   > W#ID2 -- Total count of records written to all files ... ...:
     D*
     D W#ID1           C                   CONST('CAD1011')
     D W#ID2           C                   CONST('CAD1012')
     D*...................................................................
     D* Named constants identifying the files for error handling:
     D*
     D W#FIL1          C                   CONST('CGUDT1PD  ')
     D W#FIL2          C                   CONST('CGUDT2PD  ')
     D W#FIL3          C                   CONST('CGUDT3PD  ')
     D W#FILA          C                   CONST('CGUDTAPD  ')
     D*
     D X#FIL1          C                   CONST('EXUDT1PD  ')
     D X#FIL2          C                   CONST('EXUDT2PD  ')
     D X#FIL3          C                   CONST('EXUDT3PD  ')
     D X#FILA          C                   CONST('EXUDTAPD  ')
     I********************************************************************
     C/EJECT
     C********************************************************************
     C*                 M A I N L I N E
     C********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0ACT             8
     C                   PARM                    W0PATH          256
     C                   PARM                    W0FMT
     C                   PARM                    W0TITL            7
     C                   PARM                    W0ULIN            7
     C                   PARM                    W0CMT             3
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
     C*
     C* Initialise program:
     C*
     C     W0INIT        IFNE      'Y'
     C                   EXSR      SRINIT
     C                   ENDIF
     C*
     C* Select the appropriate action:
     C*
     C     W0ACT         CASEQ     '*WRITE  '    SROUT
     C     W0ACT         CASEQ     '*AUDIT  '    SRAUD
     C*
     C* Copy in optional action processing:
     C*
     C/COPY WNCPYSRC,CGZAUDACT
     C*
     C                   CAS                     SRBAD
     C                   ENDCS
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C* Return to calling program:
     C*
     C                   RETURN
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SROUT writes a record to the appropriate file.     **
     C********************************************************************
     C     SROUT         BEGSR                                                  * S R O U T   *
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SROUT '      @STK(Q)
     C*
     C* Have the path names been determined already?
     C*
     C                   Z-ADD     1             @P                3 0
     C     W0PATH        LOOKUP    PTH(@P)                                90
     C*
     C* If found, mpve the existing values:
     C*
     C     *IN90         IFEQ      *ON
     C                   MOVE      NON(@P)       DENPTH
     C                   MOVE      REP(@P)       DERPTH
     C                   ELSE
     C*
     C* New path -- determine the path names and move the results:
     C*
     C                   EXSR      SRPATH
     C                   MOVE      W@NPTH        DENPTH
     C                   MOVE      W@RPTH        DERPTH
     C*
     C* Save the results if space in the arrays:
     C*
     C     @Q            IFLT      500
     C                   ADD       1             @Q
     C                   MOVE      W0PATH        PTH(@Q)
     C                   MOVE      W@NPTH        NON(@Q)
     C                   MOVE      W@RPTH        REP(@Q)
     C                   ENDIF
     C                   ENDIF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Write a record --
     C*
     C* Files are under commitment control:
     C*
     C     W0CMT         IFEQ      'YES'
     C* Select file:
     C                   SELECT
     C     DECH04        WHENNE    *BLANKS
     C                   WRITE     @FRM832Y                             90
     C                   MOVE      W#FILA        W#FILE           10
     C                   ADD       1             COUNTA
     C     DECH03        WHENNE    *BLANKS
     C                   WRITE     @FRM576Y                             90
     C                   MOVE      W#FIL3        W#FILE
     C                   ADD       1             COUNT3
     C     DECH02        WHENNE    *BLANKS
     C                   WRITE     @FRM320Y                             90
     C                   MOVE      W#FIL2        W#FILE
     C                   ADD       1             COUNT2
     C                   OTHER
     C                   WRITE     @FRM064Y                             90
     C                   MOVE      W#FIL1        W#FILE
     C                   ADD       1             COUNT1
     C                   ENDSL
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Files are not under commitment control:
     C*
     C                   ELSE
     C* Select file:
     C                   SELECT
     C     DECH04        WHENNE    *BLANKS
     C                   WRITE     @FRM832N                             90
     C                   MOVE      X#FILA        W#FILE           10
     C                   ADD       1             COUNTA
     C     DECH03        WHENNE    *BLANKS
     C                   WRITE     @FRM576N                             90
     C                   MOVE      X#FIL3        W#FILE
     C                   ADD       1             COUNT3
     C     DECH02        WHENNE    *BLANKS
     C                   WRITE     @FRM320N                             90
     C                   MOVE      X#FIL2        W#FILE
     C                   ADD       1             COUNT2
     C                   OTHER
     C                   WRITE     @FRM064N                             90
     C                   MOVE      X#FIL1        W#FILE
     C                   ADD       1             COUNT1
     C                   ENDSL
     C* Endif controlled:
     C                   ENDIF
     C*
     C     *IN90         IFEQ      *ON
     C                   MOVE      W#FILE        W0FILE                         ***************
     C                   MOVEL     '*WRITE  '    W0KEY                          ** Database  **
     C                   Z-ADD     1             W0ERNB                         ** error 1.  **
     C                   MOVE      'MEM5002'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C     EXOUT         TAG                                                    <<<=== EXOUT
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRAUD prints the audit report.                     **
     C********************************************************************
     C     SRAUD         BEGSR                                                  * S R A U D   *
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRAUD '      @STK(Q)
     C*
     C* Prepare parameters for the report:
     C*
     C                   MOVEL     'CG9020  '    I#REF
     C                   MOVE      W0TITL        I#TITL
     C                   MOVE      W0ULIN        I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C*
     C* Determine the file names:
     C*
     C     W0CMT         IFEQ      'YES'
     C                   MOVE      W#FIL1        Z1FIL1           10
     C                   MOVE      W#FIL2        Z1FIL2           10
     C                   MOVE      W#FIL3        Z1FIL3           10
     C                   MOVE      W#FILA        Z1FILA           10
     C                   ELSE
     C                   MOVE      X#FIL1        Z1FIL1
     C                   MOVE      X#FIL2        Z1FIL2
     C                   MOVE      X#FIL3        Z1FIL3
     C                   MOVE      X#FILA        Z1FILA
     C                   ENDIF
     C*
     C                   MOVE      W#ID1         I#TEXT
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Print count 1:
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVEL     Z1FIL1        I#SUB
     C                   Z-ADD     COUNT1        I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVE      '1'           I#EDIT
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN             7
     C                   PARM                    W1ACT             8
     C                   PARM                    W1DTA
     C                   PARM                    W1RSQN            5
     C* Print count 2:
     C                   MOVEL     Z1FIL2        I#SUB
     C                   Z-ADD     COUNT2        I#QTY
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    W1DTA
     C                   PARM                    W1RSQN
     C* Print count 3:
     C                   MOVEL     Z1FIL3        I#SUB
     C                   Z-ADD     COUNT3        I#QTY
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    W1DTA
     C                   PARM                    W1RSQN
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Print count 4:
     C                   MOVEL     Z1FILA        I#SUB
     C                   Z-ADD     COUNTA        I#QTY
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    W1DTA
     C                   PARM                    W1RSQN
     C* Skip a line:
     C                   MOVE      '*SKIP   '    W1ACT
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    W1DTA
     C                   PARM                    W1RSQN
     C* Total:
     C     COUNT1        ADD       COUNT2        COUNTT            9 0
     C                   ADD       COUNT3        COUNTT
     C                   ADD       COUNTA        COUNTT
     C* Print the total:
     C                   MOVE      '*LINE   '    W1ACT
     C                   MOVE      W#ID2         I#TEXT
     C                   Z-ADD     COUNTT        I#QTY
     C*
     C                   CALL      'CGZAUDIT'
     C                   PARM                    W1RTN
     C                   PARM                    W1ACT
     C                   PARM                    W1DTA
     C                   PARM                    W1RSQN
     C* Reset the counters:
     C                   Z-ADD     *ZERO         COUNT1
     C                   Z-ADD     *ZERO         COUNT2
     C                   Z-ADD     *ZERO         COUNT3
     C                   Z-ADD     *ZERO         COUNTA
     C*
     C     EXAUD         TAG                                                    <<<=== EXAUD
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C** SRPATH   : Look for a path; if not found, create it            **
     C**                                                                **
     C** Called by: SROUT                                               **
     C**                                                                **
     C** Calls    : SRERR                                               **
     C********************************************************************
     C     SRPATH        BEGSR                                                  * S R P A T H *
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
     C*
     C* /COPY for subroutine:
     C*
     C/COPY WNCPYSRC,CG1160PATH
     C*
     C* Define key list for path:
     C*
     C     KPGRPS        KLIST
     C                   KFLD                    EPLEV1
     C                   KFLD                    EPLEV2
     C                   KFLD                    EPLEV3
     C                   KFLD                    EPLEV4
     C                   KFLD                    EPLEV5
     C                   KFLD                    EPLEV6
     C                   KFLD                    EPLEV7
     C                   KFLD                    EPLEV8
     C                   KFLD                    EPLEV9
     C                   KFLD                    EPLEV0
     C*
     C* Reset path group set fields:
     C*
     C                   MOVE      *BLANKS       EPLEV1
     C                   MOVE      *BLANKS       EPLEV2
     C                   MOVE      *BLANKS       EPLEV3
     C                   MOVE      *BLANKS       EPLEV4
     C                   MOVE      *BLANKS       EPLEV5
     C                   MOVE      *BLANKS       EPLEV6
     C                   MOVE      *BLANKS       EPLEV7
     C                   MOVE      *BLANKS       EPLEV8
     C                   MOVE      *BLANKS       EPLEV9
     C                   MOVE      *BLANKS       EPLEV0
     C                   MOVE      *BLANKS       W#RTN
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Find repeating path/top group set:
     C*
     C                   Z-ADD     2             Y#                7 0          Start.
     C                   Z-ADD     *ZERO         X#                7 0          Position of "\"
     C                   Z-ADD     1             C#                5 0          Counter.
     C                   MOVE      'N'           ##NONR            1            Get repeating.
     C*
     C* Do until message CGD1087 -- "Last group set in path":
     C*
     C     W#RTN         DOUEQ     'CGD1087'
     C*
     C* Find next group:
     C                   EXSR      SRNGRP
     C*
     C* Check if group set is top or repeating:
     C*
     C*****##GSET        CHAIN     CGGSETL1                           90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :##GSET and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
     C*
     C* If not found, error:
     C*
     C     *IN90         IFEQ      *ON
     C                   MOVEL     'CGGSETL1'    W0FILE                         ***************
     C                   MOVEL     ##GSET        W0KEY                          ** Database  **
     C                   Z-ADD     2             W0ERNB                         ** error 2.  **
     C                   MOVE      'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*
     C* Record is a repeating group:
     C*
     C     GSMREC        IFNE      'N'
     C     ##NONR        ANDEQ     'Y'
     C                   MOVEL     'CGGSETL1'    W0FILE                         ***************
     C                   MOVEL     ##GSET        W0KEY                          ** Database  **
     C                   Z-ADD     3             W0ERNB                         ** error 3.  **
     C                   MOVE      'CGD1088'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C     GSMREC        IFEQ      'N'
     C     GSCSET        ANDNE     'T'
     C     ##NONR        ANDNE     'Y'
     C*
     C* Read path:
     C*
     C     KPGRPS        CHAIN     CGPATHL2                           90
     C*
     C* If path not found, move "NoPath" text:
     C*
     C     *IN90         IFEQ      *ON
     C                   MOVE      ##NOPT        W@RPTH            6
     C                   ELSE
     C                   MOVE      EPPATH        W@RPTH            6
     C                   ENDIF
     C*
     C* Reset Path group set fields:
     C*
     C                   MOVE      *BLANKS       EPLEV1
     C                   MOVE      *BLANKS       EPLEV2
     C                   MOVE      *BLANKS       EPLEV3
     C                   MOVE      *BLANKS       EPLEV4
     C                   MOVE      *BLANKS       EPLEV5
     C                   MOVE      *BLANKS       EPLEV6
     C                   MOVE      *BLANKS       EPLEV7
     C                   MOVE      *BLANKS       EPLEV8
     C                   MOVE      *BLANKS       EPLEV9
     C                   MOVE      *BLANKS       EPLEV0
     C*
     C* Now find non-repeating path:
     C*
     C                   Z-ADD     1             C#
     C                   MOVE      'Y'           ##NONR            1             get non-repeat
     C                   ENDIF
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Set up key to path file by group set:
     C*
     C                   SELECT
     C     C#            WHENEQ    1
     C                   MOVE      ##GSET        EPLEV1
     C     C#            WHENEQ    2
     C                   MOVE      ##GSET        EPLEV2
     C     C#            WHENEQ    3
     C                   MOVE      ##GSET        EPLEV3
     C     C#            WHENEQ    4
     C                   MOVE      ##GSET        EPLEV4
     C     C#            WHENEQ    5
     C                   MOVE      ##GSET        EPLEV5
     C     C#            WHENEQ    6
     C                   MOVE      ##GSET        EPLEV6
     C     C#            WHENEQ    7
     C                   MOVE      ##GSET        EPLEV7
     C     C#            WHENEQ    8
     C                   MOVE      ##GSET        EPLEV8
     C     C#            WHENEQ    9
     C                   MOVE      ##GSET        EPLEV9
     C     C#            WHENEQ    10
     C                   MOVE      ##GSET        EPLEV0
     C                   ENDSL
     C* Step level:
     C                   ADD       1             C#
     C                   ENDDO
     C*
     C* Read path for Non-Repeating Group:
     C*
     C     KPGRPS        CHAIN     CGPATHL2                           90
     C*
     C* If path not found, move "NoPath" text:
     C*
     C     *IN90         IFEQ      *ON
     C                   MOVE      ##NOPT        W@NPTH            6
     C                   ELSE
     C                   MOVE      EPPATH        W@NPTH
     C                   ENDIF
     C*
     C* Unwind subroutine stack:
     C*
     C     EXPATH        TAG                                                    <<<=== EXPATH
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C** SRNGRP   : Find next group                                     **
     C**                                                                **
     C** Called by: SRPATH                                              **
     C**                                                                **
     C** Calls    : SRERR                                               **
     C********************************************************************
     C     SRNGRP        BEGSR                                                  * S R N G R P *
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRNGRP'      @STK(Q)
     C*
     C* /COPY for subroutine:
     C*
     C/COPY WNCPYSRC,CG1160NGRP
     C*
     C* Initialise control code:
     C*
     C                   MOVE      *BLANKS       W#RTN             7
     C     *LIKE         DEFINE    EPLEV1        ##GSET
     C*
     C* Find first delimiter (look for "\"; start at Y#; found at X#):
     C*
     C     '\'           SCAN      W0PATH:Y#     X#                       90
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* If found, find length (position of "\" minus start position):
     C*
     C                   MOVE      *BLANKS       ##GSET                                        10219
     C     *IN90         IFEQ      *ON
     C     X#            SUB       Y#            Z#                5 0
     C     Z#            SUBST     W0PATH:Y#     ##GSET
     C*
     C* Set Y# to next free space (one character after the "\":
     C*
     C     X#            ADD       1             Y#
     C                   ELSE
     C*
     C* Substring has a fixed length of six.
     C* Message CGD1087 is "Last group set in path":
     C*
     C     6             SUBST     W0PATH:Y#     ##GSET
     C                   MOVE      'CGD1087'     W#RTN
     C                   ENDIF
     C*
     C* Unwind subroutine stack:
     C*
     C     EXNGRP        TAG                                                    <<<=== EXNGRP
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRBAD handles an undefined action.                 **
     C********************************************************************
     C     SRBAD         BEGSR                                                  * S R B A D   *
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q
     C                   MOVEL     'SRBAD '      @STK(Q)
     C*
     C* Database error -- undefined action:
     C*
     C                   MOVEL     '*ACTION '    W0FILE                         ***************
     C                   MOVEL     W0ACT         W0KEY                          ** Database  **
     C                   Z-ADD     4             W0ERNB                         ** error 4.  **
     C                   MOVEL     'MEM5006'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C*
     C     EXBAD         TAG                                                    <<<=== EXBAD
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C**  Subroutine SRINIT provides initialisation and definition.     **
     C********************************************************************
     C     SRINIT        BEGSR                                                  * S R I N I T *
     C*
     C* Add subroutine to stack:
     C*
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
     C*
     C* Move copyright statement:
     C*
     C                   MOVE      CPYR@#        ACT@             80
     C*
     C* Tag subroutine as executed:
     C*
     C                   MOVE      'Y'           W0INIT            1
     C*
     C* Open the appropriate set of files, according to
     C*  the commitment control status flag:
     C*
     C     W0CMT         IFEQ      'YES'
     C                   OPEN      CGUDT1PD
     C                   OPEN      CGUDT2PD
     C                   OPEN      CGUDT3PD
     C                   OPEN      CGUDTAPD
     C                   ELSE
     C                   OPEN      EXUDT1PD
     C                   OPEN      EXUDT2PD
     C                   OPEN      EXUDT3PD
     C                   OPEN      EXUDTAPD
     C                   ENDIF
     C*
     C* Initialise the counters:
     C*
     C                   Z-ADD     *ZERO         COUNT1            9 0
     C                   Z-ADD     *ZERO         COUNT2            9 0
     C                   Z-ADD     *ZERO         COUNT3            9 0
     C                   Z-ADD     *ZERO         COUNTA            9 0
     C*...................................................................
     C/EJECT
     C*...................................................................
     C* Get "NoPath" text (message identifier CGD1121):
     C*
     C     *LIKE         DEFINE    EPPATH        ##NOPT
     C*
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1121'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
     C*
     C                   MOVEL     #MSTX1        ##NOPT
     C*
     C* Clear path arrays and reset index:
     C*
     C                   Z-ADD     *ZERO         @Q                3 0
     C                   MOVE      *BLANKS       NON
     C                   MOVE      *BLANKS       REP
     C                   MOVE      *BLANKS       PTH
     C*
     C     EXINIT        TAG                                                    <<<=== EXINIT
     C*
     C* Unwind subroutine stack:
     C*
     C                   MOVE      *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C*
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CSC022'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CSC022
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
     C                   MOVE      'N'           WCMTSK
      *                                                                                       CSC022
     C                   IN        WDSJOB
      *                                                                                       CSC022
     C     WCMTNO        IFGT      0
     C                   MOVEA     WCJOBS        WCMT
     C                   Z-ADD     1             I                 2 0
      *                                                                                       CSC022
     C     ##JOB         LOOKUP    WCMT(I)                                51
     C     *IN51         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CSC022
     C                   ELSE
     C     PRTCD         IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     21            W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                                       CSC022
     C************NAMVAR   DEFN           WDSJOB                                       CSC022BUG2330
     C     *DTAARA       DEFINE    SCCMTJOB      WDSJOB
      *                                                                                       CSC022
     C                   ENDIF
      *                                                                                       CSC022
     C                   ENDSR
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* /Copy point for calculations:
     C*
     C/COPY WNCPYSRC,CG9020CPG
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C** Subroutine *PSSR handles program errors.                       **
     C********************************************************************
     C*
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C*
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* /Copy point for error-handling subroutine:
     C*
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C*
     C********************************************************************
     O/EJECT
     O********************************************************************
     O* /Copy point for output specifications:
     O*
     O/COPY WNCPYSRC,CG9020OPG
     O*
     O********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2001
