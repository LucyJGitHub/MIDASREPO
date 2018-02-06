     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MIC Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOMICCR0 - Midas Market Identification Code Access Object    *
      *                                                               *
      *  Function:  This program retrieves the record from file       *
      *             SDMICCL0                                          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW208 - SWIFT 2008 Changes                                  *
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
      *
      ** Market Identification Code File
     FSDMICCL0  IF   E           K DISK    USROPN
      *
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
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
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
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** File information data structure for external file DSFDY
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** File information data structure for external file SDMICCPD
     D SDMICC        E DS                  EXTNAME(SDMICCPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D PRtcd2          S              7A
     D POptn           S              7A
     D PMiccod         S              4A
      *
     D P1Rtcd          S              7A
     D PPgnm           S             10A
     D PDest           S              5A
     D PMsgid          S              7A
     D PMsgf           S             10A
     D PMgky           S              4A
     D PMgda           S             50A
     D PMgtp           S              7A
      *
      ** Variable to determine the potision of "?"
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
      *
      ** Receive entry parameters
     C     *ENTRY        PLIST
     C     P1Rtcd        PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    PMiccod
     C                   PARM                    DSFDY
      *
      ** Initialize Return Parameter
     C                   IF        POptn = '*SAME  '
      *
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      *IN91 = *OFF
     C                   ENDIF
      *
     C                   EXSR      SRReturn
      *
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
     C                   IF        *IN01 = *OFF
      *
     C                   EVAL      *IN01 = *ON
     C                   OPEN      SDMICCL0                             91
      *
     C                   IF        *IN91 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Last call - close file and terminate program :
     C                   IF        POptn = '*FREE  '
      *
     C                   CLOSE     SDMICCL0                             92
      *
     C                   IF        *IN92 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Caller requests first record :
     C                   IF        POptn = '*FIRST '
      *
     C     *LOVAL        SETLL     SDMICCL0                           9390
      *
     C                   IF        (*IN93 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   EVAL      POptn = '*NEXT  '
     C                   ENDIF
      *
      ** Caller requests next record :
     C                   IF        POptn = '*NEXT  '
      *
     C                   READ      SDMICCL0                             9094
      *
     C                   IF        (*IN94 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Caller requests last record :
     C                   IF        POptn = '*LAST  '
      *
     C     *HIVAL        SETGT     SDMICCL0                             90
      *
     C                   IF        *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   EVAL      POptn = '*PREV  '
     C                   ENDIF
      *
      ** Caller requests previous record :
     C                   IF        POptn = '*PREV  '
      *
     C                   READP     SDMICCL0                             9094
      *
     C                   IF        (*IN94 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Caller requests record indicated by key :
     C                   IF        (POptn = '*KEY   ')
     C                             OR (POptn = '*VERIFY')
      *
      ** Call for "?" on main screen
     C                   EVAL      WPos = %SCAN('?':PMiccod)
      *
     C                   IF        WPos <> *ZEROS
     C                   CALL      'SD009802S'                          98
     C                   PARM                    PRtcd2
     C                   PARM                    PMiccod
      *
     C                   IF        PRtcd2 <> *BLANKS
     C                   EVAL      *IN97 = *ON
     C                   ENDIF
      *
     C                   IF        (*IN98 = *ON) OR
     C                             (*IN97 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     PMiccod       CHAIN     SDMICCL0                           9590
      *
     C                   IF        (*IN95 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Caller requests record indicated by invaild option :
     C                   IF        (POptn <> '*KEY   ')
     C                             AND (POptn <>  '*NEXT  ')
     C                             AND (POptn <>  '*PREV  ')
     C                             AND (POptn <>  '*VERIFY')
     C                             AND (POptn <>  '*FREE  ')
     C                             AND (POptn <>  '*SAME  ')
      *
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
      *
     C                   EXSR      SRReturn
      *
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
      *
     C     SRReturn      BEGSR
      *
     C                   EVAL      PRtcd = *BLANKS
      *
     C                   SELECT
      *
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PRtcd = '*ERROR '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN91 = *ON
     C                   EVAL      PRtcd = '*OPEN  '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN92 = *ON
     C                   EVAL      PRtcd = '*CLOSE '
     C                   EVAL      *INLR = *ON
      *
     C                   WHEN      *IN93 = *ON
     C                   EVAL      PRtcd = '*EMPTY '
      *
     C                   WHEN      *IN94 = *ON
     C                   EVAL      PRtcd = '*EOF   '
      *
     C                   WHEN      *IN95 = *ON
     C                   EVAL      PRtcd = '*NRF   '
      *
     C                   WHEN      *IN96 = *ON
     C                   EVAL      PRtcd = '*OPTION'
      *
     C                   WHEN      *IN97 = *ON
     C                   EVAL      PRtcd = '*NOSEL '
      *
     C                   WHEN      *IN98 = *ON
     C                   EVAL      PRtcd = '*CALL  '
      *
     C                   ENDSL
      *
     C                   IF        (P1Rtcd = '*MSG   ')
     C                             AND (PRtcd <> *BLANKS)
      *
     C                   SELECT
      *
     C                   WHEN      *IN90 = *ON
     C                   EVAL      PMsgid = 'ACO1001'
      *
     C                   WHEN      *IN91 = *ON
     C                   EVAL      PMsgid = 'ACO1002'
      *
     C                   WHEN      *IN92 = *ON
     C                   EVAL      PMsgid = 'ACO1003'
      *
     C                   WHEN      *IN93 = *ON
     C                   EVAL      PMsgid = 'ACO1004'
      *
     C                   WHEN      *IN94 = *ON
     C                   EVAL      PMsgid = 'ACO1005'
      *
     C                   WHEN      *IN95 = *ON
     C                   EVAL      PMsgid = 'ACO1006'
      *
     C                   WHEN      *IN96 = *ON
     C                   EVAL      PMsgid = 'ACO1007'
      *
     C                   WHEN      *IN97 = *ON
     C                   EVAL      PMsgid = 'ACO1009'
      *
     C                   WHEN      *IN98 = *ON
     C                   EVAL      PMsgid = 'ACO1010'
      *
     C                   ENDSL
      *
      ** Send the Message to Program Message Queue
     C                   CALLB     'ZASNMG'
      *
     C                   PARM      *BLANKS       P1Rtcd
     C                   PARM      'AOMICCR0'    PPgnm
     C                   PARM      '*PRV '       PDest
     C                   PARM                    PMsgid
     C                   PARM      *BLANKS       PMsgf
     C                   PARM      *BLANKS       PMgky
     C                   PARM      *BLANKS       PMgda
     C                   PARM      '*DIAG  '     PMgtp
      *
     C                   ENDIF
      *
      ** Caller Requests DB Error Handling
     C                   IF        (P1Rtcd = '*DBERR ')
     C                             AND (PRtcd <> *BLANKS)
      *
     C                   DUMP
     C                   CALLB     'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   IF        (POptn <> '*VERIFY')
     C                             AND (POptn <> '*FREE  ')
     C                             AND (PRtcd <> '*OPTION')
      *
     C                   EVAL      DSFDY = SDMICC
      *
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Finastra International Limited 2008
