     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT FNDUPDSRC retrieve scan data')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities                                            *
      *                                                               *
      *  UT000053 - Retrieve scan data                                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CUT015   *CREATE   Date 19Apr12               *
      *  Prev Amend No. xxxxxxxx           Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT015 - New utility to replace UPDSRC.                      *
      *                                                               *
      *****************************************************************
      *
     D String          S            100
     D CaseSense       S              7
     D StringLen       S              3
     D OldString       S            100
     D Recursive       S              1
      *
      /EJECT
      *
     C     *ENTRY        PLIST
     C                   PARM                    String
     C                   PARM                    CaseSense
     C                   PARM                    StringLen
      *
      * Get data about the original scan
     C/exec SQL
     C+ select *
     C+ into :OldString, :String
     C+ from UTSTMTPD
     C+ where substr(FUOSTR, 1, 10) = 'FNDUPDSRC '
     C/end-exec
      *
     C                   EVAL      CaseSense = %SUBST(OldString:11:7)
     C                   EVAL      StringLen = %SUBST(OldString:18:3)
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *blank
     C                   EVAL      Recursive = 'Y'
     C                   EVAL      *INU5 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   ENDIF
      *
     C                   RETURN
      *
     C     PSSRE         ENDSR
      *
      *****************************************************************
