     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Access object for DSPJOBLOG')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UTAOJOBL - Access object for DSPJOBLOG                       *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP003  *CREATE    Date 02Aug10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP003 - New utility                                         *
      *                                                               *
      *****************************************************************
     FUPJOBLTPD IF   E           K DISK    INFSR(*PSSR)
     F
      *
     D PMsgID          S              7
     D PMsgData        S          20000
     D PMode           S              7
     D PReturn         S              7
     D Recursive       S              1
      *
     D JOBL          E DS                  EXTNAME(UPJOBLTPD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMsgID
     C                   PARM                    PMode
     C                   PARM                    PMsgData
     C                   PARM                    PReturn
      *
     C                   EVAL      PReturn = *blanks
     C                   EVAL      PMsgData = *blanks
      *
     C                   IF        PMode = '*FIRST'
     C     PMsgID        SETLL     UPJOBLTPD
     C     PMsgID        READE     UPJOBLTPD
     C                   IF        %EOF
     C                   EVAL      PReturn = '*NRF'
     C                   ELSE
     C                   EVAL      PMsgData = JOBL
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PMode = '*LAST'
     C     PMsgID        SETGT     UPJOBLTPD
     C     PMsgID        READPE    UPJOBLTPD
     C                   IF        %EOF
     C                   EVAL      PReturn = '*NRF'
     C                   ELSE
     C                   EVAL      PMsgData = JOBL
     C                   ENDIF
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   SETON                                        U7U8LR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      PReturn = '*ERROR'
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
