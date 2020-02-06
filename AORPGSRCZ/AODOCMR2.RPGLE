     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Document Codes')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object                                        *
      *                                                               *
      *  AODOCMR2 - Read Access to Document Codes File                *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD093 *CREATE     Date 01Apr13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD093 - Document Management                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L  FUNCTION OF INDICATORS                         *
      *                                                               *
      *       01       OFF ON THE FIRST RUN                           *
      *       90       FILE ERROR                                     *
      *       91       OPEN ERROR                                     *
      *       92       CLOSE ERROR                                    *
      *       93       EMPTY FILE                                     *
      *       94       END OF FILE                                    *
      *       95       NO RECORD FOUND                                *
      *       96       OPTION ERROR                                   *
      *       97       NO SELECTION                                   *
      *       98       CALL ERROR (SD0350S)                           *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      * Midas SD Document Codes File
     FSDDOCML1  IF   E           K DISK    USROPN
 
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D A@CPY           DS
      *
     D PMGDA           DS
     D  ArrMG                  1     50
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
      ** Midas Document Code Record Format
     D SDDOCM        E DS                  EXTNAME(SDDOCMPD)
 
      ** Outgoing Record Format
     D PFMT          E DS                  EXTNAME(DSFDY)
      *
      * Key slicing data structure (for Record Selection)
     D PDCCD           DS
     D  WSL01                  1      1
     D  WSL02                  2      2
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  CONVERT   - Split Sequence Number and convert to Numeric     *
      *  INCREMENT - Increment Last Digit and cope with overflows     *
      *  INIT      - Initialisation Routine                           *
      *  SEARCH    - Search for 'spaces' within the Character Sequence*
      *                                                               *
      *****************************************************************
     C     *ENTRY        PLIST
     C     WRTCD         PARM                    PRTCD             7
     C                   PARM                    POPTN             7
     C                   PARM                    PDCCD
     C                   PARM                    PFMT
 
      *****************************************************************
      ** Main
      *
     C                   IF        POPTN = '*SAME  '
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN91 = *ON
     C                   ENDIF
     C                   GOTO      TSKIP
     C                   ENDIF
      *
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN98 = *OFF
      *
      ** First call - open file :
      *
     C                   IF        *IN01 = '0'
     C                   EVAL      *IN01 = *ON
     C                   OPEN      SDDOCML1                             91
     C     *IN91         CABEQ     '1'           TSKIP                    LR
     C                   ENDIF
      *
      ** Last call - close file and terminate program :
      *
     C                   IF        POPTN = '*FREE  '
     C                   CLOSE     SDDOCML1                             92
     C     *IN92         CABEQ     '1'           TSKIP                    LR
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Caller requests first record :
      *
     C                   IF        POPTN = '*FIRST '
     C     *LOVAL        SETLL     @ATRECI                            9390
     C     *IN93         CABEQ     '1'           TSKIP
     C     *IN90         CABEQ     '1'           TSKIP                    LR
     C                   EVAL      POPTN = '*NEXT  '
     C                   ENDIF
      *
      ** Caller requests next record :
      *
     C                   IF        POPTN = '*NEXT  '
     C                   READ      @ATRECI                              9094
     C     *IN94         CABEQ     '1'           TSKIP
     C     *IN90         CABEQ     '1'           TSKIP                    LR
     C                   ENDIF
      *
      ** Caller requests last record :
      *
     C                   IF        POPTN = '*LAST  '
     C     *HIVAL        SETGT     @ATRECI                              90
     C     *IN90         CABEQ     '1'           TSKIP                    LR
     C                   EVAL      POPTN = '*PREV  '
     C                   ENDIF
      *
      ** Caller requests previous record :
      *
     C                   IF        POPTN = '*PREV  '
     C                   READP     @ATRECI                              9094
     C     *IN94         CABEQ     '1'           TSKIP
     C     *IN90         CABEQ     '1'           TSKIP                    LR
     C                   ENDIF
      *
      ** Caller requests record indicated by key :
      *
     C                   IF        POPTN = '*KEY   '
     C                             OR POPTN = '*VERIFY'
     C                   IF        WSL01 = '?'
     C                             OR WSL02 = '?'
      *
     C                   CALL      'SD0350S'                            98
     C                   PARM      *BLANK        PRTC2             7
     C                   PARM      *BLANK        PDCCD
     C                   IF        PRTC2 > *BLANK
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
     C     *IN97         CABEQ     '1'           TSKIP
     C     *IN98         CABEQ     '1'           TSKIP
     C                   ENDIF
     C     PDCCD         CHAIN     @ATRECI                            9590
     C     *IN95         CABEQ     '1'           TSKIP
     C     *IN90         CABEQ     '1'           TSKIP                    LR
     C                   ENDIF
      *
     C                   IF        POPTN <> '*KEY   '
     C                             AND POPTN <> '*NEXT  '
     C                             AND POPTN <>  '*PREV  '
     C                             AND POPTN <>  '*VERIFY'
     C                             AND POPTN <>  '*SAME  '
     C                             AND POPTN <>  '*FREE  '
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
      *
      ** No record found or End of file - return error code :
      *
     C     TSKIP         TAG
      *
     C                   EVAL      PRTCD = *BLANK
     C                   IF        *IN90 = *ON
     C                   EVAL      PRTCD = '*ERROR '
     C                   ENDIF
     C                   IF        *IN91 = *ON
     C                   EVAL      PRTCD = '*OPEN  '
     C                   ENDIF
     C                   IF        *IN92 = *ON
     C                   EVAL      PRTCD = '*CLOSE '
     C                   ENDIF
     C                   IF        *IN93 = *ON
     C                   EVAL      PRTCD = '*EMPTY '
     C                   ENDIF
     C                   IF        *IN94 = *ON
     C                   EVAL      PRTCD = '*EOF   '
     C                   ENDIF
     C                   IF        *IN95 = *ON
     C                   EVAL      PRTCD = '*NRF   '
     C                   ENDIF
     C                   IF        *IN96 = *ON
     C                   EVAL      PRTCD = '*OPTION'
     C                   ENDIF
     C                   IF        *IN97 = *ON
     C                   EVAL      PRTCD = '*NOSEL '
     C                   ENDIF
     C                   IF        *IN98 = *ON
     C                   EVAL      PRTCD = '*CALL  '
     C                   ENDIF
      *
      ** Caller requests message sent to program queue :
      *
     C                   IF        WRTCD = '*MSG   '
     C                             AND PRTCD <> *BLANK
     C                   IF        *IN90 = *ON
     C                   EVAL      PMGID = 'ACO1001'
     C                   ENDIF
     C                   IF        *IN91 = *ON
     C                   EVAL      PMGID = 'ACO1002'
     C                   ENDIF
     C                   IF        *IN92 = *ON
     C                   EVAL      PMGID = 'ACO1003'
     C                   ENDIF
     C                   IF        *IN93 = *ON
     C                   EVAL      PMGID = 'ACO1004'
     C                   ENDIF
     C                   IF        *IN94 = *ON
     C                   EVAL      PMGID = 'ACO1005'
     C                   ENDIF
     C                   IF        *IN95 = *ON
     C                   EVAL      PMGID = 'ACO1006'
     C                   ENDIF
     C                   IF        *IN96 = *ON
     C                   EVAL      PMGID = 'ACO1007'
     C                   ENDIF
     C                   IF        *IN97 = *ON
     C                   EVAL      PMGID = 'ACO1009'
     C                   ENDIF
     C                   IF        *IN98 = *ON
     C                   EVAL      PMGID = 'ACO1010'
     C                   ENDIF
      *
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANK        WRTCD             7
     C                   PARM      PGNAME        PPGNM            10
     C                   PARM      '*PRV'        PDEST             5
     C                   PARM                    PMGID             7
     C                   PARM      *BLANK        PMSGF            10
     C                   PARM      *BLANK        PMGKY             4
     C                   PARM                    PMGDA
     C                   PARM      '*DIAG'       PMGTP             7
     C                   ENDIF
      *
      ** Caller requests DB error handling
      *
     C                   IF        WRTCD = '*DBERR '
     C                             AND PRTCD <> *BLANK
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
      *
     C                   IF        POPTN <> '*VERIFY'
     C                             AND POPTN <> '*FREE  '
     C                             AND PRTCD <> '*OPTION'
     C                   MOVEL     SDDOCM        PFMT
     C                   ENDIF
      *
      ** Return to caller :
      *
     C                   RETURN
      *
      *****************************************************
**CTDATA ArrMG
SDDOCML1  AODOCMR0  Document codes
**CTDATA CPY@
(c) Finastra International Limited 2013
