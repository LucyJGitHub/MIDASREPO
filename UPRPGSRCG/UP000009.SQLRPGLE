     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Access of Bridge menu options')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000009 - Access Bridge menu options                        *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CUP041   *CREATE   Date 15Aug14               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PMode           S              4
     D PMain           S             20
     D PSub            S             20
     D PLayer          S              7
     D PStatus         S              1
     D Recursive       S              1    INZ('N')
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PMain
     C                   PARM                    PSub
     C                   PARM                    PLayer
     C                   PARM                    PStatus
      *
     C                   IF        PMode = '*CHK'
     C/exec SQL
     C+ select MUSTS into :PStatus
     C+ from UPMNUXTD
     C+ where
     C+     MUMAIN = :PMain
     C+ and MUSUB  = :PSub
     C+ and MULAYR = :PLayer
     C/end-exec
     C                   ENDIF
      *
     C                   IF        PMode = '*UPD'
     C/exec SQL
     C+ update UPMNUXTD
     C+ set MUSTS = :PStatus
     C+ where
     C+     MUMAIN = :PMain
     C+ and MUSUB  = :PSub
     C+ and MULAYR = :PLayer
     C/end-exec
     C                   ENDIF
      *
     C                   IF        PMode = '*RST'
     C                   EVAL      PStatus = *blank
     C/exec SQL
     C+ update UPMNUXTD
     C+ set MUSTS = ' '
     C/end-exec
     C                   ENDIF
      *
     C                   IF        SQLCODE <> 0
     C                   EVAL      PStatus = 'E'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
