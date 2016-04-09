     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP Generic program to update UPMNU*')            *
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  SMU90000 - Generic program to update UPMNU*                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP042 *CREATE     Date 08Jun15               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP042 - Simplification of deliverables list.                *
      *                                                               *
      *****************************************************************
      *
     D PMenuOpt        S             20
     D PSubTask        S             20
      *
     D SysValK         S             20    INZ('BrgDeliveredDtaLib')
     D SysValKey       S             20
     D SysVal          S            200
     D SysValV         S            200
     D SQLStr          S            300
     D ReturnCode      S              7
     D Quote           S              1    INZ('''')
     D DlvDtaLib       S             10
     D File            S             10
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMenuOpt
     C                   PARM                    PSubTask
      *
     C/exec SQL
     C+ whenever SQLERROR goto ERROR
     C/end-exec
      *
      ** Find the delivered data library
     C                   CALL      'GPAOSVALR0'
     C                   PARM                    ReturnCode
     C                   PARM                    SysValK
     C     SysValV       PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   PARM      *blanks       SysValKey
     C                   PARM                    SysVal
     C                   IF        ReturnCode <> *blank
     C                   GOTO      ERROR
     C                   ENDIF
     C                   EVAL      DlvDtaLib = %SUBST(SysValV:1:10)
      *
     C/exec SQL
     C+ delete from UPMNUCTD
     C+ where
     C+     MUMAIN = :PMenuOpt
     C+ and MUSUB  = :PSubTask
     C/end-exec
      *
     C                   EVAL      SQLStr = 'insert into UPMNUCTD select * +
     C                             from ' + %TRIMR(DlvDtaLib) + '/UPMNUCTD d +
     C                             where not exists (select s.MUMAIN from +
     C                             UPMNUCTD s where d.MUMAIN = s.MUMAIN and +
     C                             d.MUSUB = s.MUSUB and d.MULAYR = s.MULAYR) +
     C                             and d.MUMAIN = ' + Quote +
     C                             %TRIMR(PMenuOpt) + Quote +
     C                             ' and d.MUSUB = ' + Quote +
     C                             %TRIMR(PSubTask) + Quote
      *
     C/exec SQL
     C+ execute immediate: SQLStr
     C/end-exec
      *
     C                   CALL      'UP009016'
     C                   PARM      'UPMNUCTD'    File
      *
     C     ERROR         TAG
     C                   IF        SQLCODE < 0
     C                             or ReturnCode <> *blank
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
