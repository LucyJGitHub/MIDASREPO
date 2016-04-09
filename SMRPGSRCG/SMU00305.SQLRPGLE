      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  SMU00305 - Update AF to control UTMENUPD records             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUP041  *CREATE    Date 10Mar15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP041 - New Bridge methodology to combine menu options      *
      *                                                               *
      *****************************************************************
      *
     D PMode           S              4A
     D BrgDlvLib       S             10A
     D SQLStr          S            100A
     D Quote           S              1A   INZ('''')
     D Command         S            100A   INZ('ACTIONFILE MODE(*PRC) +
     D                                     FILE(UTMENUPD)')
     D CommandLen      S             15P 5 INZ(100)
      *
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
      *
     C                   IF        PMode = '*BEF'
      ** Retrieve the System Value for the Bridge deliverable data library.
     C/exec SQL
     C+ select
     C+   GIVAL
     C+ into
     C+   :BrgDlvLib
     C+ from GPSVALPD
     C+ where
     C+     GISVAL = 'BrgDeliveredDtaLib'
     C/end-exec
      *
     C                   EVAL      SQLStr = 'update ' + BrgDlvLib + '/UPAFCPPD +
     C                             set ATIGNA = ' + Quote + 'Y' + Quote +
     C                             ' where  ATFILE = ' + Quote + 'UTMENUPD' +
     C                             Quote
      *
      ** Update the 'ignore' field on the Action File for all UTMENUPD records.
     C/exec SQL
     C+ execute immediate :SQLStr
     C/end-exec
      *
      ** Delete a record from UPAFFDPD for file UPACTFPD, field AAORIF if it
      **  already exists ...
     C/exec SQL
     C+ delete from UPAFFDPD where
     C+     AFFILE = 'UPACTFPD'
     C+ and AFFDNM = 'AAORIF'
     C/end-exec
      ** ... and then add it back.
     C/exec SQL
     C+ insert into UPAFFDPD
     C+ (
     C+   AFFILE
     C+ , AFFDNM
     C+ , AFFDTX
     C+ , AFFDTP
     C+ , AFFDLN
     C+ , AFFDPS
     C+ , AFFDND
     C+ , AFFDDP
     C+ , AFKEYF
     C+ , AFIGNC
     C+ , AFDIFF
     C+ , AFIGNU
     C+ , AFCOID
     C+ )
     C+ values
     C+ (
     C+   'UPACTFPD'
     C+ , 'AAORIF'
     C+ , 'Original file'
     C+ , 'A'
     C+ , 10
     C+ , 28
     C+ , 0
     C+ , 0
     C+ , ' '
     C+ , ' '
     C+ , '*'
     C+ , ' '
     C+ , 'N'
     C+ )
     C/end-exec
      *
      *
     C                   ENDIF
      *
     C                   IF        PMode = '*AFT'
      ** Update the Action File (post Take on).
     C/exec SQL
     C+ update UPAFDVPD set
     C+   ATIGNA = ' '
     C+ where
     C+     ATFILE = 'UTMENUPD'
     C+ and ATACT <> 'AB'
     C/end-exec
      *
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command
     C                   PARM                    CommandLen
     C                   ENDIF
      *
     C                   RETURN
