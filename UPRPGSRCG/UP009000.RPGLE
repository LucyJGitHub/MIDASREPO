     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*XBI *  OVRDBF FILE(AFCPL01) TOFILE(UPAFCPL0) SHARE(*NO)             *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Action Files details - browse')               *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP009000 - Action File details - browse                      *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. A1084804           Date 29Jan13               *
      *                 CUP021  *CREATE    Date 11Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  A1084804 - Add 'Go to' option.                               *
      *  CUP021 - Rewrite of Action File processing                   *
      *                                                               *
      *****************************************************************
      *
     FUP009000DFCF   E             WORKSTN
     F                                     SFILE(UP009000F0:SflRrn)
     FUPAFCPL0  IF   E           K DISK
     FAFCPL01   UF   E           K DISK
     F                                     RENAME(UPAFCPD0:U_UPAFCPD0)
     F                                     PREFIX(U_)
      *
     D Idx             S              2  0
     D WINKC           S              1
     D DispBefore      S              1
     D NumPerPag       S              2  0
     D TopFmt          S             10
     D TopNumb         S              6  0
     D SflRrn          S              4  0
     D Recursive       S              1
     D ZAPGMQ          S             10
     D ZAPGRL          S              5
     D ZAMSID          S              7
     D ZAMSGF          S             10    INZ('UTMSGF')
     D ZAMSDA          S            132
     D ZAMSTP          S              7
      *
     D TxtLine         DS
     D  TxtDsp                        1    DIM(50)
      *
      * Display subfile screen until F3 taken.
     C                   EVAL      ATNUMB = 0
     C     *INKC         DOWEQ     '0'
     C                   EXSR      DispScreen
     C                   ENDDO
      *
      * End of program.
     C                   SETON                                        LR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Display subfile screen                                        *
      *                                                               *
      *****************************************************************
     C     DispScreen    BEGSR
      *
      * Fill current subfile page.
     C     *IN05         IFEQ      '1'
     C     *IN06         OREQ      '1'
     C     *IN09         OREQ      '1'                                                      A1084804
     C     SflRrn        OREQ      *ZERO
     C  N50              EXSR      FillSubfile
     C                   ENDIF
      *
      * Write subfile control and foooter
     C                   TIME                    DDTIME
     C                   WRITE     UP009000C2
     C                   WRITE     UP009000F1
      *
      * Read subfile control
     C                   WRITE     UP009000C0
     C                   READ      UP009000C0                             99
      *
      * Clear the message queue and initial error indicators.
     C                   EXSR      ClearMsgQ
      * If F3 was not taken.
     C     *INKC         IFEQ      '0'
      *
      * Rolldown requested.
     C     *IN05         CASEQ     '1'           Rolldown
      *
      * Check for a record selected from the subfile.
     C     *IN(04)       CASEQ     '0'           ChkSubfile
     C                   ENDCS
      *
     C                   ENDIF
      *
     C     DispScreenE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear the message queue & init error indicators.              *
      *                                                               *
      *****************************************************************
     C     ClearMsgQ     BEGSR
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   MOVEA     '0'           *IN(50)
     C                   MOVEA     '0000000000'  *IN(10)
      *
     C     ClearMsgQE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Check for a record selected from the subfile.                 *
      *                                                               *
      *****************************************************************
     C     ChkSubfile    BEGSR
      *
     C                   READC     UP009000F0                             99
      *
      * Do until all records processed
      *
     C     *IN99         DOWEQ     '0'
      *
      * If an action code is specified
      *   Maintain the record in the subfile
 
     C                   EXSR      MaintSflRec
      *
      * Return to top of subfile page.
     C                   MOVEL     TopFmt        ATFILE
     C                   Z-ADD     TopNumb       ATNUMB
     C                   Z-ADD     *ZERO         SflRrn
      *
      * Read next if F3 not requested.
     C     WINKC         IFEQ      '0'
     C                   READC     UP009000F0                             99
     C                   ELSE
     C                   MOVE      '1'           *IN99
     C                   MOVE      WINKC         *INKC
     C                   END
      *
     C                   ENDDO
      *
     C     ChkSubfileE   ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Fill subfile.                                                 *
      *                                                               *
      *****************************************************************
     C     FillSubfile   BEGSR
      *
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   Z-ADD     *ZERO         SflRrn
      *
      * Write subfile control.
     C                   WRITE     UP009000C0
      *
      * Get first record.
     C                   IF        DDFILE <> *blanks                                        A1084804
     C                   EVAL      ATFILE = DDFILE                                          A1084804
     C                   EVAL      ATNUMB = *zeros                                          A1084804
     C                   ENDIF                                                              A1084804
     C     UPAFCPK       SETLL     UPAFCPD0
     C                   READ      UPAFCPD0                               99
      *
      * If not end of file.
     C     *IN99         IFEQ      '0'
     C                   MOVEL     ATFILE        TopFmt
     C                   MOVEL     ATNUMB        TopNumb
     C                   EXSR      GetDetail
     C                   EVAL      DDIGNA = ATIGNA
     C                   ELSE
     C                   MOVEL     *BLANK        TopFmt
     C                   MOVEL     *BLANKS       ATFILE
     C                   MOVEL     *BLANKS       DDDATA
     C                   EVAL      ATNUMB = 0
     C                   EVAL      DDIGNA = *BLANK
      *
      * Else, if end of file issue message.
     C                   MOVEL     'BRG0002'     ZAMSID
     C                   EXSR      SendMsg
     C                   ENDIF
      *
     C                   IF        SflRrn = 0 and *IN99 = '1'
     C                               and DispBefore = 'Y'
     C                   EVAL      *IN04 = '0'
     C                   ENDIF
      *
      * Do while not end of file.
     C     *IN99         DOWEQ     '0'
      *
     C                   ADD       1             SflRrn                   04
      *
      * Write a record to the subfile.
     C                   WRITE     UP009000F0
     C                   MOVE      'Y'           DispBefore
     C     SflRrn        IFEQ      NumPerPag
     C                   READ      UPAFCPD0                               99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        ATFILE
     C                   MOVEL     'BRG0002'     ZAMSID
     C                   EXSR      SendMsg
     C                   ELSE
     C                   SETON                                            99
     C                   EXSR      GetDetail
     C                   EVAL      DDIGNA = ATIGNA
     C                   END
     C                   ELSE
     C                   READ      UPAFCPD0                               99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        ATFILE
     C                   MOVEL     'BRG0002'     ZAMSID
     C                   EXSR      SendMsg
     C                   ELSE
     C                   EXSR      GetDetail
     C                   EVAL      DDIGNA = ATIGNA
     C                   END
     C                   END
      *
     C                   ENDDO
      *
      * Set on subfile control indicators
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   END
      *
     C     FillSubfileE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Maintain a record on the subfile.                             *
      *                                                               *
      ******************************************************************
     C     MaintSflRec   BEGSR
      *
     C     UPAFCPK       CHAIN     U_UPAFCPD0                         65
      *
     C                   IF        *IN65 = '0'
     C                   IF        DDIGNA = 'D'
     C                   DELETE    U_UPAFCPD0
     C                   ELSE
     C                   EVAL      U_ATIGNA = DDIGNA
     C                   UPDATE    U_UPAFCPD0
     C                   ENDIF
     C                   ENDIF
      *
      * Return to top of subfile page
     C                   MOVEL     TopFmt        ATFILE
     C                   Z-ADD     TopNumb       ATNUMB
     C                   Z-ADD     *ZERO         SflRrn
      *
     C     MaintSflRecE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Rolldown.                                                     *
      *                                                               *
      *****************************************************************
     C     Rolldown      BEGSR
      *
     C                   Z-ADD     *ZERO         SflRrn
     C                   MOVEL     TopFmt        ATFILE
     C                   Z-ADD     TopNumb       ATNUMB
      *
     C     UPAFCPK       SETGT     UPAFCPD0
     C                   READP     UPAFCPD0                               99
      *
      * Read previous until count matches count of records previous read.
     C     *IN99         DOWEQ     '0'
     C     SflRrn        ANDLT     NumPerPag
     C                   READP     UPAFCPD0                               99
     C                   EXSR      GetDetail
     C                   EVAL      DDIGNA = ATIGNA
     C                   ADD       1             SflRrn
     C                   ENDDO
      *
      * Issue start of file message.
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        ATFILE
     C                   MOVEL     'BRG0001'     ZAMSID
     C                   EXSR      SendMsg
     C                   END
      *
     C     RolldownE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * Get record detail.                                            *
      *                                                               *
      *****************************************************************
     C     GetDetail     BEGSR
      *
     C                   EVAL      TxtLine = %SUBST(ATDATA:1:50)
      *
      * Replace non-displayable character with *blank.
     C                   EVAL      Idx = 1
     C                   DOU       Idx > 50
     C                   IF        TxtDsp(Idx) < X'40'
     C                   EVAL      TxtDsp(Idx) = *BLANK
     C                   ENDIF
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
      *
     C                   EVAL      DDDATA = TxtLine
      *
     C     GetDetailE    ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * SendMsg - Send a message.                                     *
      *                                                               *
      *****************************************************************
     C     SendMsg       BEGSR
      *
     C                   CALL      'Y2SNMGC'                            0909
     C                   PARM      DDPGM         ZAPGMQ
     C                   PARM                    ZAPGRL
     C                   PARM                    ZAMSID
     C                   PARM                    ZAMSGF
     C                   PARM                    ZAMSDA
     C                   PARM                    ZAMSTP
      *
      * Error encountered.
     C     ZAMSID        IFNE      'BRG0002'
     C     ZAMSID        ANDNE     'BRG0001'
     C                   MOVE      '1'           *IN50
     C                   ENDIF
      *
     C     SendMsgE      ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initial subroutine.                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Initialise program name.
     C                   MOVEL     'UP009000'    DDPGM
      *
      * Set up subfile message queue information.
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
     C                   MOVE      'N'           DispBefore
     C                   MOVE      '0'           WINKC
      *
      * Initialise constants.
     C                   Z-ADD     14            NumPerPag         2 0
      *
      * Key list.
     C     UPAFCPK       KLIST
     C                   KFLD                    ATFILE
     C                   KFLD                    ATNUMB
      *
     C     INZSRE        ENDSR
      /EJECT
      ********************************************************************
     C     *PSSR         BEGSR
      *
     C     Recursive     IFEQ      *blanks
     C                   MOVE      'Y'           Recursive
     C                   DUMP
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
      *
     C     PSSRE         ENDSR
      *********************************************************************
