     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO SWIFT ISO Country Codes Access Object')       *
      *****************************************************************
      *                                                               *
      *  Midas - Access Object Module                                 *
      *                                                               *
      *  AOMSOCR0 - Midas AO SWIFT ISO Country Codes Access Object    *
      *                                                               *
      *  Function:  This program retrieves the record from file       *
      *             MEISOCPD                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       01       Open File                                      *
      *       90       File Error                                     *
      *       91       Open Error                                     *
      *       92       Close Error                                    *
      *       93       Empty File                                     *
      *       94       End of File                                    *
      *       95       No Record Found                                *
      *       96       Option Error                                   *
      *       97       If No Selection                                *
      *       98       Call Error                                     *
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
      ** ISO Country Codes File
     FMEISOCL1  IF   E           K DISK    USROPN
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
      ** File information data structure for external file MEISOCPD
     D MEISOC        E DS                  EXTNAME(MEISOCPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7A
     D POptn           S              7A
     D PIsoc           S              2A
      *
     D WRtcd           S              7A
     D WPgnm           S             10A
     D WDest           S              5A
     D WMsgid          S              7A
     D WMsgf           S             10A
     D WMgky           S              4A
     D WMgda           S             50A
     D WMgtp           S              7A
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
      *
     C     *ENTRY        PLIST
     C     WRtcd         PARM                    PRtcd
     C                   PARM                    POptn
     C                   PARM                    PIsoc
     C                   PARM      MEISOC        DSFDY
      *
      ** Initialize Return Parameter
      *
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
      *
     C                   IF        *IN01 = *OFF
      *
     C                   EVAL      *IN01 = *ON
     C                   OPEN      MEISOCL1                             91
      *
     C                   IF        *IN91 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Last call - close file and terminate program :
      *
     C                   IF        POptn = '*FREE  '
      *
     C                   CLOSE     MEISOCL1                             92
      *
     C                   IF        *IN92 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      ** Caller requests first record :
      *
     C                   IF        POptn = '*FIRST '
      *
     C     *LOVAL        SETLL     MEISOCL1                           9390
      *
     C                   IF        (*IN93 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   EVAL      POptn = '*NEXT  '
     C                   ENDIF
      *
      ** Caller requests next record :
      *
     C                   IF        POptn = '*NEXT  '
      *
     C                   READ      MEISOCL1                             9094
      *
     C                   IF        (*IN94 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Caller requests last record :
      *
     C                   IF        POptn = '*LAST  '
      *
     C     *HIVAL        SETGT     MEISOCL1                             90
      *
     C                   IF        *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   EVAL      POptn = '*PREV  '
     C                   ENDIF
      *
      ** Caller requests previous record :
      *
     C                   IF        POptn = '*PREV  '
      *
     C                   READP     MEISOCL1                             9094
      *
     C                   IF        (*IN94 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Caller requests record indicated by key :
      *
     C                   IF        (POptn = '*KEY   ')
     C                             OR (POptn = '*VERIFY')
      *
     C     PIsoc         CHAIN     MEISOCL1                           9590
      *
     C                   IF        (*IN95 = *ON) OR (*IN90 = *ON)
     C                   EXSR      SRReturn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Caller requests record indicated by invaild option :
      *
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
     C                   IF        (WRtcd  = '*MSG   ')
     C                             AND (PRtcd <> *BLANKS)
      *
     C                   SELECT
      *
     C                   WHEN      *IN90 = *ON
     C                   EVAL      WMsgid = 'ACO1001'
      *
     C                   WHEN      *IN91 = *ON
     C                   EVAL      WMsgid = 'ACO1002'
      *
     C                   WHEN      *IN92 = *ON
     C                   EVAL      WMsgid = 'ACO1003'
      *
     C                   WHEN      *IN93 = *ON
     C                   EVAL      WMsgid = 'ACO1004'
      *
     C                   WHEN      *IN94 = *ON
     C                   EVAL      WMsgid = 'ACO1005'
      *
     C                   WHEN      *IN95 = *ON
     C                   EVAL      WMsgid = 'ACO1006'
      *
     C                   WHEN      *IN96 = *ON
     C                   EVAL      WMsgid = 'ACO1007'
      *
     C                   WHEN      *IN97 = *ON
     C                   EVAL      WMsgid = 'ACO1009'
      *
     C                   WHEN      *IN98 = *ON
     C                   EVAL      WMsgid = 'ACO1010'
      *
     C                   ENDSL
      *
      ** Send the Message to Program Message Queue
      *
     C                   CALLB     'ZASNMG'
      *
     C                   PARM      *BLANKS       WRtcd
     C                   PARM      'AOMSOCR0'    WPgnm
     C                   PARM      '*PRV '       WDest
     C                   PARM                    WMsgid
     C                   PARM      *BLANKS       WMsgf
     C                   PARM      *BLANKS       WMgky
     C                   PARM      *BLANKS       WMgda
     C                   PARM      '*DIAG  '     WMgtp
      *
     C                   ENDIF
      *
      ** Caller Requests DB Error Handling
      *
     C                   IF        (WRtcd  = '*DBERR ')
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
     C                   EVAL      DSFDY = MEISOC
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
