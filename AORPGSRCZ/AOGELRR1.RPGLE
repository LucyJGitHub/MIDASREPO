     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO General ledger details (DSSDY)')              *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *  AOGELRR1 - Read Access to General Ledger Details (DSSDY)     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 220371             Date 31Oct03               *
      *                 CGL029 *CREATE     Date 01Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  220371 - DBASE Error 15 on DL0295, file ACKEY.               *
      *           Include *FREE processing for AOGELRR1.              *
      *  CGL029 - Increase Account Code to 10 digits.                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L  FUNCTION OF INDICATORS                         *
      *                                                               *
      *       01       Off On the first run                           *
      *       90       File Error                                     *
      *       91       Open Error                                     *
      *       92       Close Error                                    *
      *       93       Empty File                                     *
      *       96       Option Error                                   *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
     FSDGELRL1  IF   E           K DISK    USROPN
      * IN  - @BKREEC Generel Ledger Details (BZCD)
      *****************************************************************
      /EJECT
      *****************************************************************
     D P@MGDA          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
 
      ** Program Status data structure
     D PGMDS          SDS
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
 
      ** @BKREEC - General Ledger Record Format Data Structure
     D D@FMT         E DS                  EXTNAME(SDGELRPD)
 
      ** Long Data Structure
     D P@FMT         E DS                  EXTNAME(DSSDY)
 
      ** Declared Variables
     D P@RTCD          S              7
     D P@OPTN          S              7
     D W@RTCD          S              7
     D P@PGNM          S             10
     D P@DEST          S              5
     D P@MGID          S              7
     D P@MSGF          S             10
     D P@MGKY          S              4
     D P@MGTP          S              7
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C     W@RTCD        PARM                    P@RTCD
     C                   PARM                    P@OPTN
     C                   PARM      D@FMT         P@FMT
 
     C                   SETOFF                                       909192
     C                   SETOFF                                       9396
 
     C     P@OPTN        IFEQ      '*KEY   '
     C     P@OPTN        OREQ      '*FIRST '
     C     P@OPTN        OREQ      '*LAST  '
     C     P@OPTN        OREQ      '*NEXT  '
     C     P@OPTN        OREQ      '*PREV  '
     C*****P@OPTN        OREQ      '*FREE  '                                                  220371
     C     P@OPTN        OREQ      '*VERIFY'
     C     P@OPTN        OREQ      '*SAME  '
 
     C     *IN01         IFEQ      '0'
     C                   SETON                                        01
     C                   OPEN      SDGELRL1                             91
     C     *IN91         CABEQ     '1'           T@SKIP                   LR
     C     *LOVAL        SETLL     @BKREEC                            9390
     C  N93              READ      @BKREEC                                93
     C                   CLOSE     SDGELRL1                             92
     C     *IN93         CABEQ     '1'           T@SKIP
     C     *IN90         CABEQ     '1'           T@SKIP                   LR
     C     *IN92         CABEQ     '1'           T@SKIP                   LR
     C                   ENDIF
 
     C                   ELSE
     C                   IF        P@OPTN = '*FREE'                                           220371
     C                   EVAL      *INLR = *ON                                                220371
     C                   RETURN                                                               220371
     C                   ELSE                                                                 220371
     C                   SETON                                        96
     C                   ENDIF                                                                220371
     C                   ENDIF
 
      ** No record found or End of file - return error code :
 
     C     T@SKIP        TAG
 
     C                   MOVE      *BLANK        P@RTCD
     C   90              MOVE      '*ERROR '     P@RTCD
     C   91              MOVE      '*OPEN  '     P@RTCD
     C   92              MOVE      '*CLOSE '     P@RTCD
     C   93              MOVE      '*EMPTY '     P@RTCD
     C   96              MOVE      '*OPTION'     P@RTCD
 
      ** Caller requests message sent to program queue :
 
     C     W@RTCD        IFEQ      '*MSG   '
     C     P@RTCD        ANDNE     *BLANK
     C   90              MOVE      'ACO1001'     P@MGID
     C   91              MOVE      'ACO1002'     P@MGID
     C   92              MOVE      'ACO1003'     P@MGID
     C   93              MOVE      'ACO1004'     P@MGID
     C   96              MOVE      'ACO1007'     P@MGID
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANK        W@RTCD
     C                   PARM      PGNAME        P@PGNM
     C                   PARM      '*PRV'        P@DEST
     C                   PARM                    P@MGID
     C                   PARM      *BLANK        P@MSGF
     C                   PARM      *BLANK        P@MGKY
     C                   PARM                    P@MGDA
     C                   PARM      '*DIAG'       P@MGTP
     C                   ENDIF
 
      ** Caller requests DB error handling :
 
     C     W@RTCD        IFEQ      '*DBERR '
     C     P@RTCD        ANDNE     *BLANK
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
      ** Return to caller :
 
     C                   RETURN
      *****************************************************************
**CTDATA @MG
SDGELRPD  AOGELRR0  General Ledger Details
