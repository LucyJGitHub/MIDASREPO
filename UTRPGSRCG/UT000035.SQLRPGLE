     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT Check if data area is an SQL sequence')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT000035 - Check if data area is an SQL sequence             *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 05Feb18               *
      *  Prev Amend No. AR796253 *CREATE   Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR796253 - Check if a data area is actually an SQL sequence. *
      *                                                               *
      *****************************************************************
      *
     DPDataarea        S             10
     DPLibrary         S             10
     DPFound           S              1
     DCounter          S             10I 0       INZ
     DRecursive        S              1
      *
     C     *ENTRY        PLIST
     C                   PARM                    PDataarea
     C                   PARM                    PLibrary
     C                   PARM                    PFound
      *
     C/exec SQL
     C+ select count(*) into :Counter
     C+ from SYSSEQ
     C+ where SEQSCHEMA = :PLibrary
     C+ and SEQNAME = :PDataarea
     C/end-exec
      *
     C                   EVAL      PFound = ' '
     C                   IF        Counter > 0
     C                   EVAL      PFound = 'Y'
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
      * Check to see that *PSSR has not already been called.
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
      *
      *****************************************************************
