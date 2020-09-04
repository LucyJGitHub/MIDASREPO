     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Update similarity between users - summary')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000034 - Report similarity between users - summary         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
      *
     D PUser01         S             10
     D PUser02         S             10
     D NbrRcds01       S              7  0
     D NbrRcds02       S              7  0
     D NbrsMatch       S              7  0
     D NbrsNoMatch01   S              7  0
     D NbrsNoMatch02   S              7  0
     D PctMatch01      S              3  0
     D PctMatch02      S              3  0
     D PctMMatch01     S              3  0
     D PctMMatch02     S              3  0
      *
     D Recursive       S              1    INZ('N')
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C     *ENTRY        PLIST
     C                   PARM                    PUser01
     C                   PARM                    PUser02
      *
      ** Count number of records for first user.
      *
     C/exec SQL
     C+ select count(*) into :NbrRcds01
     C+ from SMBFAC01
     C/end-exec
      *
      ** Count number of records for second user.
      *
     C/exec SQL
     C+ select count(*) into :NbrRcds02
     C+ from SMBFAC02
     C/end-exec
      *
      ** Count number of matching records.
      *
     C/exec SQL
     C+ select count(*) into :NbrsMatch
     C+ from SMBFAC01 a where exists
     C+ (select * from SMBFAC02 b where
     C+ a.ACINDX = b.ACINDX and
     C+ a.ACBRCH = b.ACBRCH and
     C+ a.ACAC01 = b.ACAC01 and
     C+ a.ACAC02 = b.ACAC02 and
     C+ a.ACAC03 = b.ACAC03 and
     C+ a.ACAC04 = b.ACAC04 and
     C+ a.ACAC05 = b.ACAC05 and
     C+ a.ACAC06 = b.ACAC06 and
     C+ a.ACAC07 = b.ACAC07 and
     C+ a.ACAC08 = b.ACAC08 and
     C+ a.ACAC09 = b.ACAC09 and
     C+ a.ACAC10 = b.ACAC10)
     C/end-exec
      *
      ** Get number of records found in first file only.
      *
     C                   EVAL      NbrsNoMatch01 = NbrRcds01 - NbrsMatch
      *
      ** Get number of records found in second file only.
      *
     C                   EVAL      NbrsNoMatch02 = NbrRcds02 - NbrsMatch
      *
      ** Work out percentages of matches and mismatches.
      *
     C                   EVAL      PctMatch01 = NbrsMatch / NbrRcds01 * 100
     C                   EVAL      PctMatch02 = NbrsMatch / NbrRcds02 * 100
     C                   EVAL      PctMMatch01 = 100 - PctMatch01
     C                   EVAL      PctMMatch02 = 100 - PctMatch02
      *
      ** Update file with data.
      *
     C/exec SQL
     C+ insert into SMBFPCPD (
     C+ PCUSR1, PCUSR2, PCRCD1, PCRCD2, PCMTCH,
     C+ PCNM01, PCNM02, PCMPC1, PCMPC2, PCNPC1, PCNPC2
     C+ )
     C+ values (
     C+ :PUser01, :PUser02,
     C+ :NbrRcds01, :NbrRcds02,
     C+ :NbrsMatch,
     C+ :NbrsNoMatch01, :NbrsNoMatch02,
     C+ :PctMatch01, :PctMatch02,
     C+ :PctMMatch01, :PctMMatch02
     C+ )
     C/end-exec
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Exception Error Routine                     *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blanks
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
      *
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
