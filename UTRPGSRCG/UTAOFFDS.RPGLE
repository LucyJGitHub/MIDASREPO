     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Access object for file field desc.')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UTAOFFDS - Access object for file field description          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27790 *CREATE   Date 18Jun10               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27790 - New utility                                       *
      *                                                               *
      *****************************************************************
     FUPFFDSTPD IF   E           K DISK    INFSR(*PSSR)
     F
      *
     D PFile           S             10
     D PFmt            S             10
     D PField          S             10
     D PMode           S              7
     D PReturn         S              7
     D PFieldData      S           2000
     D KFile           S             10
     D KFmt            S             10
     D KField          S             10
     D Recursive       S              1
      *
     D FFDS          E DS                  EXTNAME(UPFFDSTPD)
      *
     C     *ENTRY        PLIST
     C                   PARM                    PFile
     C                   PARM                    PFmt
     C                   PARM                    PField
     C                   PARM                    PMode
     C                   PARM                    PReturn
     C                   PARM                    PFieldData
      *
     C     KFileFld      KLIST
     C                   KFLD                    KFile
     C                   KFLD                    KFmt
     C                   KFLD                    KField
      *
     C                   EVAL      PReturn = *blanks
     C                   EVAL      PFieldData = *blanks
      *
     C                   IF        PMode = '*FIRST'
     C     *LOVAL        SETLL     UPFFDSTPD
     C                   READ      UPFFDSTPD
     C                   IF        %EOF
     C                   EVAL      PReturn = '*NRF'
     C                   ELSE
     C                   EVAL      PFieldData = FFDS
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        PMode = '*RTV'
     C                   EVAL      KFile  = PFile
     C                   EVAL      KFmt   = PFmt
     C                   EVAL      KField = PField
     C     KFileFld      CHAIN     UPFFDSTPD
     C                   IF        %FOUND
     C                   EVAL      PFieldData = FFDS
     C                   ELSE
     C                   EVAL      PReturn = '*NRF'
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
