     H DEBUG
     H COPYRIGHT('(c) Finastra Ltd. 2023')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Base 26 timestamp')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  GL009700    - Create base 26 (alpha) timestamp               *
      *                                                               *
      *  (c) Finastra Ltd. 2023                                       *
      *                                                               *
      *  Last Amend No. CGL200  *CREATE    Date 17Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL200 - Timestamp on Batch Items and Related Postings       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      **********************************************************************
      /EJECT                                                               *
      **********************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D ALPHA           S              1    DIM(26) CTDATA PERRCD(26)

     D TIMESTAR        S              1    DIM(9) INZ('A')

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc
     D IDX             S              3P 0

     D TMZLNG          S              4B 0

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************

     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     C                   Move      *BLANKS       INFMT
     C                   Movel     '*CURRENT'    INFMT
     C                   Move      *BLANKS       INVAR
     C                   Move      *BLANKS       OUTFMT
     C                   Movel     '*YYMD'       OUTFMT
      *
     C                   Call      'QWCCVTDT'
     C                   Parm                    INFMT            10
     C                   Parm                    INVAR             1
     C                   Parm                    OUTFMT           10
     C                   Parm                    OUTDAT           20
     C                   Parm                    QUSEC            32
     C                   Parm      '*SYS    '    ITMZ             10
     C                   Parm      '*SYS    '    OTMZ             10
     C                   Parm                    TMZINF           32
     C                   Parm      0             TMZLNG
     C                   Parm      '1'           PRECIS            1
     C                   Move      OUTDAT        OUTDATN          12 0
      *
     C                   Z-Add     9             IDX
      *
     C     OUTDATN       DowGT     26
      *
     C     OUTDATN       Div       26            VALUE            12 0
     C                   Mvr                     REM              12 0
      *
     C     VALUE         IfGE      26
     C                   Z-Add     VALUE         OUTDATN
     C                   Add       1             REM
     C                   Move      ALPHA(REM)    TIMESTAR(IDX)
     C                   Else
     C                   Add       1             REM
     C                   Move      ALPHA(REM)    TIMESTAR(IDX)
     C                   Sub       1             IDX
     C                   Add       1             VALUE
     C                   Move      ALPHA(VALUE)  TIMESTAR(IDX)
     C                   Leave
     C                   EndIf
      *
     C                   Sub       1             IDX
      *
     C                   EndDo
      *
     C                   MOVEA     TIMESTAR      TIMESTTX          9
      *
     C                   Eval      *INLR = *On
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        Begsr
      *
     C     *ENTRY        Plist
     C                   Parm                    TIMESTTX
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra Ltd. 2023
** Base 26 values
ABCDEFGHIJKLMNOPQRSTUVWXYZ
