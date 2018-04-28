     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Swiss ICD access object')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOSTAXR0 - Access Object for Midas TA Swiss Installation     *
      *             Control Data                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. BUG24574           Date 07Jul09               *
      *                 CER048A *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24574 - Withholding Tax - R4 vs M+ (Recompile)            *
      *  CER048A - German Features - Taxes                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR     - Initialisation Subroutine                       *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Midas TA Swiss Installation Control Data
      *
     FSDSTAXL1  IF   E           K DISK    USROPN
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Copyright Array
      *
     D A@CPY           DS
     D CPY@            S             80A   DIM(1) CTDATA
      *
     D PMsgDa          DS
     D  @MG                    1     50
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ** Program Status Data Structure
      *
     D PGMDS          SDS
     D  PGNAME                 1     10
     D  PGLIBR                81     90
     D  PGJBNM               244    253
     D  PGUSER               254    263
     D  PGJBNO               264    269  0
      *
      ** Midas TA Swiss Installation Control Data Structure
      *
     D SDSTAX        E DS                  EXTNAME(SDSTAXPD)
      *
      ** Short Access Object Data Structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PPgmNm          S             10A
     D PDesti          S              5A
     D PMsgId          S              7A
     D PMsgFl          S             10A
     D PMsgKy          S              4A
     D PMsgTp          S              7A
      *
      ** Program Parameters
      *
     D PRtCd           S              7A
     D POptn           S              7A
     D WRtCd           S              7A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C     *ENTRY        PLIST
     C     WRtCd         PARM                    PRtCd
     C                   PARM                    POptn
     C                   PARM      SDSTAX        DSFDY
      *
      ** Main Processing
      *
     C                   MOVE      '000000'      *IN90
      *
     C                   IF        POptn = '*KEY   ' OR
     C                             POptn = '*LAST  ' OR
     C                             POptn = '*FIRST ' OR
     C                             POptn = '*PREV  ' OR
     C                             POptn = '*NEXT  ' OR
     C                             POptn = '*SAME  ' OR
     C                             POptn = '*VERIFY'
      *
     C                   IF        *IN01 = '0'
      *
     C                   EVAL      *IN01 = *ON
      *
     C                   OPEN      SDSTAXL1                             91
      *
     C     *IN91         CABEQ     '1'           TSKIP                    LR
      *
     C     *LOVAL        SETLL     SDSTAXD0                           9390
     C  N93              READ      SDSTAXD0                               93
     C                   CLOSE     SDSTAXL1                             92
      *
     C     *IN93         CABEQ     '1'           TSKIP
     C     *IN90         CABEQ     '1'           TSKIP                    LR
     C     *IN92         CABEQ     '1'           TSKIP                    LR
     C                   END
      *
     C                   ELSE
      *
     C                   IF        POptn = '*FREE  '
     C                   SETON                                        LR
     C                   RETURN
     C                   ELSE
      *
     C                   EVAL      *IN96 = *ON
     C                   END
     C                   END
      *
      ** No record found or End of file - return error code :
      *
     C     TSKIP         TAG
      *
     C                   MOVE      *BLANK        PRtCd
     C   90              MOVE      '*ERROR '     PRtCd
     C   91              MOVE      '*OPEN  '     PRtCd
     C   92              MOVE      '*CLOSE '     PRtCd
     C   93              MOVE      '*EMPTY '     PRtCd
     C   96              MOVE      '*OPTION'     PRtCd
      *
      ** Caller requests message sent to program queue :
      *
     C                   IF        WRtCd = '*MSG   '
     C                             AND PRtCd <> ' '
     C   90              MOVE      'ACO1001'     PMsgId
     C   91              MOVE      'ACO1002'     PMsgId
     C   92              MOVE      'ACO1003'     PMsgId
     C   93              MOVE      'ACO1004'     PMsgId
     C   96              MOVE      'ACO1007'     PMsgId
      *
     C                   CALLB     'ZASNMG'
     C                   PARM      *BLANK        WRtCd
     C                   PARM      PGNAME        PPgmNm
     C                   PARM      '*PRV'        PDesti
     C                   PARM                    PMsgId
     C                   PARM      *BLANK        PMsgFl
     C                   PARM      *BLANK        PMsgKy
     C                   PARM                    PMsgDa
     C                   PARM      '*DIAG'       PMsgTp
     C                   END
      *
      ** Caller Request DB Error Handling
      *
     C                   IF        WRtCd = '*DBERR'
     C                             AND PRtCd <> ' '
     C                   DUMP
     C                   CALLB     'DBERRCTL'
     C                   END
      *
      ** Return to caller :
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2008
**CTDATA @MG
SDSTAXPD  AOSTAXR0  Swiss Details
