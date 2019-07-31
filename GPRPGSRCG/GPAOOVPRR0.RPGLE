     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Override Profiles')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  GPAOOVPRR0 - Override Profiles                               *
      *                                                               *
      *  Function:  This program retrieves the records from file      *
      *             GPOVPRL0                                          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *  Prev Amend No. BUG27504           Date 21Apr10               *
      *                 CSD086  *CREATE    Date 17Mar10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27504 - Prevent GP000025S from locking LDA. Also pass     *
      *             the zone as parameters for GP000025S              *
      *  CSD086 - Overridable Errors                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       01       OPEN FILE                                      *
      *       90       FILE ERROR                                     *
      *       91       OPEN ERROR                                     *
      *       92       CLOSE ERROR                                    *
      *       93       EMPTY FILE                                     *
      *       94       END OF FILE                                    *
      *       95       NO RECORD FOUND                                *
      *       96       OPTION ERROR                                   *
      *       97       IF NO SELECTION                                *
      *       98       CALL ERROR                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas GP Override Profiles
     FGPOVPRL0  IF   E           K DISK    USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      *
     D/COPY GPCPYSRCG,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY GPCPYSRCG,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** File information DS for DSFDY
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File information DS for GPOVPRPD
     D GPOVPR        E DS                  EXTNAME(GPOVPRPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D POVPR           S             10A
     D PZONE           S             10A                                                    BUG27504
 
      ** Parameters for GPZASNMG
     D P1Rtcd          S              7A
     D PPgnm           S             10A
     D PDest           S              5A
     D PMsgid          S              7A
     D PMsgf           S             10A
     D PMgky           S              4A
     D PMgda           S             50A
     D PMgtp           S              7A
 
      ** Work variables
     D PRETCOD         S             10A
     D WPos            S              2S 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Receive entry parameters
     C     *ENTRY        PLIST
     C     P1Rtcd        PARM                    PRTCD
     C                   PARM                    POPTN
     C                   PARM                    POVPR
     C                   PARM                    PZONE                                      BUG27504
     C                   PARM                    DSFDY
 
      ** Initialize Return Parameter
     C                   IF        POPTN = '*SAME  '
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      *IN91 = *OFF
     C                   ENDIF
 
     C                   EXSR      SRReturn
 
     C                   ENDIF
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      *IN97 = *OFF
     C                   EVAL      *IN98 = *OFF
 
      ** First call - open file
     C                   IF        *IN01 = *OFF
 
     C                   EVAL      *IN01 = *ON
     C                   OPEN      GPOVPRL0                             91
 
     C                   IF        *IN91 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** Last call - close file and terminate program
     C                   IF        POPTN = '*FREE  '
 
     C                   CLOSE     GPOVPRL0                             92
 
     C                   IF        *IN92 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   ENDIF
 
      ** Caller requests first record
     C                   IF        POPTN = '*FIRST '
 
     C     *LOVAL        SETLL     GPOVPRL0                           9390
 
     C                   IF        (*IN93 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   EVAL      POPTN = '*NEXT  '
     C                   ENDIF
 
      ** Caller requests next record
     C                   IF        POPTN = '*NEXT  '
 
     C                   READ      GPOVPRL0                             9094
 
     C                   IF        (*IN94 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** Caller requests last record
     C                   IF        POPTN = '*LAST  '
 
     C     *HIVAL        SETGT     GPOVPRL0                             90
 
     C                   IF        *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   EVAL      POPTN = '*PREV  '
     C                   ENDIF
 
      ** Caller requests previous record
     C                   IF        POPTN = '*PREV  '
 
     C                   READP     GPOVPRL0                             9094
 
     C                   IF        (*IN94 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** Caller requests record indicated by key
     C                   IF        (POPTN = '*KEY   ')
     C                             OR (POPTN = '*VERIFY')
 
      ** Call for "?" on main screen
     C                   EVAL      WPos = %SCAN('?':POVPR)
 
     C                   IF        WPos <> *ZEROS
     C                   CALL      'GP000025S'                          98
     C                   PARM      *BLANKS       PRETCOD
     C                   PARM      *BLANKS       POVPR
     C                   PARM                    PZONE                                      BUG27504
 
     C                   IF        PRETCOD <> *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
 
     C                   IF        (*IN97 = *ON) OR
     C                             (*IN98 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
     C     POVPR         CHAIN     GPOVPRL0                           9590
 
     C                   IF        (*IN95 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** Caller requests record indicated by invalid option
     C                   IF        (POPTN <> '*KEY   ')
     C                             AND (POPTN <> '*NEXT  ')
     C                             AND (POPTN <> '*PREV  ')
     C                             AND (POPTN <> '*VERIFY')
     C                             AND (POPTN <> '*FREE  ')
     C                             AND (POPTN <> '*SAME  ')
 
     C                   EVAL      *IN96 = *ON
 
     C                   ENDIF
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters Subroutine   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
 
     C     SRReturn      BEGSR
 
     C                   EVAL      PRTCD = *BLANKS
 
      ** Set the return code accordingly
 
     C                   SELECT
 
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PRTCD = '*ERROR '
     C                   EVAL      *INLR = *ON
 
     C                   WHEN      *IN91 = *ON
     C                   EVAL      PRTCD = '*OPEN  '
     C                   EVAL      *INLR = *ON
 
     C                   WHEN      *IN92 = *ON
     C                   EVAL      PRTCD = '*CLOSE '
     C                   EVAL      *INLR = *ON
 
     C                   WHEN      *IN93 = *ON
     C                   EVAL      PRTCD = '*EMPTY '
 
     C                   WHEN      *IN94 = *ON
     C                   EVAL      PRTCD = '*EOF   '
 
     C                   WHEN      *IN95 = *ON
     C                   EVAL      PRTCD = '*NRF   '
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      PRTCD = '*OPTION'
 
     C                   WHEN      *IN97 = *ON
     C                   EVAL      PRTCD = '*NOSEL '
 
     C                   WHEN      *IN98 = *ON
     C                   EVAL      PRTCD = '*CALL  '
 
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        (P1Rtcd = '*MSG   ')
     C                             AND (PRTCD <> *BLANKS)
 
     C                   SELECT
 
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PMSGID = 'ACO1001'
 
     C                   WHEN      *IN91 = *ON
     C                   EVAL      PMSGID = 'ACO1002'
 
     C                   WHEN      *IN92 = *ON
     C                   EVAL      PMSGID = 'ACO1003'
 
     C                   WHEN      *IN93 = *ON
     C                   EVAL      PMSGID = 'ACO1004'
 
     C                   WHEN      *IN94 = *ON
     C                   EVAL      PMSGID = 'ACO1005'
 
     C                   WHEN      *IN95 = *ON
     C                   EVAL      PMSGID = 'ACO1006'
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      PMSGID = 'ACO1007'
 
     C                   WHEN      *IN97 = *ON
     C                   EVAL      PMSGID = 'ACO1009'
 
     C                   WHEN      *IN98 = *ON
     C                   EVAL      PMSGID = 'ACO1010'
 
     C                   ENDSL
 
      ** Send the message to Program Message Queue
 
     C                   CALLB     'GPZASNMG'
 
     C                   PARM      *BLANKS       P1Rtcd
     C                   PARM      'GPAOOVPRR0'  PPgnm
     C                   PARM      '*PRV '       PDest
     C                   PARM                    PMsgid
     C                   PARM      *BLANKS       PMsgf
     C                   PARM      *BLANKS       PMgky
     C                   PARM      *BLANKS       PMgda
     C                   PARM      '*DIAG  '     PMgtp
 
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C                   IF        (P1Rtcd = '*DBERR ')
     C                             AND (PRTCD <> *BLANKS)
 
     C                   DUMP
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   IF        (POPTN <> '*VERIFY')
     C                             AND (POPTN <> '*FREE  ')
     C                             AND (PRTCD <> '*OPTION')
 
     C                   EVAL      DSFDY = GPOVPR
 
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
