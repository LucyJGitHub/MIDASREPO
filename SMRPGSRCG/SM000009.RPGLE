     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Work out statuses for database migration')    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000009 - Work out statuses of database migration           *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP003             Date 08Aug10               *
      *                 BUG27793 *CREATE   Date 07Jun10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP003 - Handle unique key problems better.                  *
      *  BUG27793 - Make migration multi-streamed.                    *
      *                                                               *
      *****************************************************************
      *
     FSMCPYDPD  IF   E           K DISK
      *
     D PTotal          S              6
     D PSubmit         S              6
     D PActive         S              6
     D PPassed         S              6
     D PFailed         S              6
     D PUnique         S              6                                                       CUP003
     D PSkip           S              6
     D PNotFound       S              6
     D PWait           S              6
     D TotalN          S              5  0
     D SubmitN         S              5  0
     D ActiveN         S              5  0
     D PassedN         S              5  0
     D FailedN         S              5  0
     D UniqueN         S              5  0                                                    CUP003
     D SkipN           S              5  0
     D NotFoundN       S              5  0
     D WaitN           S              5  0
     D Recursive       S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PTotal
     C                   PARM                    PSubmit
     C                   PARM                    PActive
     C                   PARM                    PPassed
     C                   PARM                    PFailed
     C                   PARM                    PUnique                                      CUP003
     C                   PARM                    PSkip
     C                   PARM                    PNotFound
     C                   PARM                    PWait
      *
     C     *LOVAL        SETLL     SMCPYDPD
     C                   READ      SMCPYDPD
      *
     C**********         DOU       %EOF                                                       CUP003
     C                   DOW       NOT(%EOF)                                                  CUP003
      *
     C                   SELECT
      *
     C                   WHEN      ODDDAT = 'SUBMIT'
     C                   EVAL      SubmitN = SubmitN + 1
      *
     C                   WHEN      ODDDAT = 'ACTIVE'
     C                   EVAL      ActiveN = ActiveN + 1
      *
     C                   WHEN      ODDDAT = 'PASSED'
     C                   EVAL      PassedN = PassedN + 1
      *
     C                   WHEN      ODDDAT = 'FAILED'
     C                   EVAL      FailedN = FailedN + 1
      *
     C                   WHEN      ODDDAT = 'UNIQUE'                                          CUP003
     C                   EVAL      UniqueN = UniqueN + 1                                      CUP003
      *
     C                   WHEN      ODDDAT = 'SKIP  '
     C                   EVAL      SkipN = SkipN + 1
      *
     C                   WHEN      ODDDAT = 'NFOUND'
     C                   EVAL      NotFoundN = NotFoundN + 1
      *
     C                   OTHER
     C                   EVAL      WaitN =WaitN + 1
      *
     C                   ENDSL
      *
     C                   EVAL      TotalN = TotalN + 1
      *
     C                   READ      SMCPYDPD
      *
     C                   ENDDO
      *
     C                   EVAL      PTotal = %EDITC(TotalN:'1')
     C                   EVAL      PSubmit = %EDITC(SubmitN:'1')
     C                   EVAL      PActive = %EDITC(ActiveN:'1')
     C                   EVAL      PPassed = %EDITC(PassedN:'1')
     C                   EVAL      PFailed = %EDITC(FailedN:'1')
     C                   EVAL      PUnique = %EDITC(UniqueN:'1')                              CUP003
     C                   EVAL      PSkip = %EDITC(SkipN:'1')
     C                   EVAL      PNotFound = %EDITC(NotFoundN:'1')
     C                   EVAL      PWait = %EDITC(WaitN:'1')
      *
      * If there are failures or files not found then report.
     C                   IF        FailedN <> 0 or
     C                             UniqueN <> 0 or                                            CUP003
     C                             NotFoundN <> 0
     C                   CALL      'SM000013'
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
