      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UT ADBU insert UTMENUPD options')
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT004000 - Midas UT ADBU insert UTMENUPD options             *
      *                                                               *
      *  Function:  This program inserts the 4 options used by        *
      *             Adaptive Database Upgrade if not existing         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE   Date 17Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Subroutine index                                             *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     DPSDS            SDS
      * Job name.
     D PSJobName             244    253
      * User name.
     D PSUser                254    263

     D UTMENU        E DS                  EXTNAME(UTMENUPD)
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      /EJECT
      *****************************************************************

      * Check if ADUC for Zone exists
     C/exec SQL
     C+ select * into :UTMENU
     C+ from UTMENUPD
     C+ where MGRP = 801 and ISEQ = 'C0006' and ICDE = 'ADUC'
     C/end-exec
     C                   If        SQLCODE = 100
     C/exec SQL
     C+ insert into UTMENUPD
     C+ (
     C+  RECI,
     C+  MGRP,
     C+  ICDE,
     C+  INAR,
     C+  SECL,
     C+  MODC,
     C+  PCMD,
     C+  PARA,
     C+  HDOC,
     C+  HFLR,
     C+  HLBL,
     C+  ISEQ
     C+ )
     C+ values
     C+ (
     C+  'D',
     C+  801,
     C+  'ADUC',
     C+  'RUN - Adaptive Database Upgrade Compare',
     C+  0,
     C+  ' ',
     C+  'CALL UPC4000',
     C+  '''*ZONE  ''',
     C+  ' ',
     C+  ' ',
     C+  ' ',
     C+  'C006'
     C+ )
     C/end-exec

     C                   EndIf

      * Check if ADUU for Zone exists
     C/exec SQL
     C+ select * into :UTMENU
     C+ from UTMENUPD
     C+ where MGRP = 801 and ISEQ = 'C0007' and ICDE = 'ADUU'
     C/end-exec
     C                   If        SQLCODE = 100
     C/exec SQL
     C+ insert into UTMENUPD
     C+ (
     C+  RECI,
     C+  MGRP,
     C+  ICDE,
     C+  INAR,
     C+  SECL,
     C+  MODC,
     C+  PCMD,
     C+  PARA,
     C+  HDOC,
     C+  HFLR,
     C+  HLBL,
     C+  ISEQ
     C+ )
     C+ values
     C+ (
     C+  'D',
     C+  801,
     C+  'ADUU',
     C+  'RUN - Adaptive Database Upgrade Update',
     C+  0,
     C+  ' ',
     C+  'CALL UPC4010',
     C+  '''*ZONE  ''',
     C+  ' ',
     C+  ' ',
     C+  ' ',
     C+  'C007'
     C+ )
     C/end-exec

     C                   EndIf

      * Check if ADUC for Global exists
     C/exec SQL
     C+ select * into :UTMENU
     C+ from UTMENUPD
     C+ where MGRP = 601 and ISEQ = 'C0006' and ICDE = 'ADUC'
     C/end-exec
     C                   If        SQLCODE = 100
     C/exec SQL
     C+ insert into UTMENUPD
     C+ (
     C+  RECI,
     C+  MGRP,
     C+  ICDE,
     C+  INAR,
     C+  SECL,
     C+  MODC,
     C+  PCMD,
     C+  PARA,
     C+  HDOC,
     C+  HFLR,
     C+  HLBL,
     C+  ISEQ
     C+ )
     C+ values
     C+ (
     C+  'D',
     C+  601,
     C+  'ADUC',
     C+  'RUN - Adaptive Database Upgrade Compare',
     C+  0,
     C+  ' ',
     C+  'CALL UPC4000',
     C+  '''*GLOBAL''',
     C+  ' ',
     C+  ' ',
     C+  ' ',
     C+  'C006'
     C+ )
     C/end-exec

     C                   EndIf

      * Check if ADUU for Global exists
     C/exec SQL
     C+ select * into :UTMENU
     C+ from UTMENUPD
     C+ where MGRP = 601 and ISEQ = 'C0007' and ICDE = 'ADUU'
     C/end-exec
     C                   If        SQLCODE = 100
     C/exec SQL
     C+ insert into UTMENUPD
     C+ (
     C+  RECI,
     C+  MGRP,
     C+  ICDE,
     C+  INAR,
     C+  SECL,
     C+  MODC,
     C+  PCMD,
     C+  PARA,
     C+  HDOC,
     C+  HFLR,
     C+  HLBL,
     C+  ISEQ
     C+ )
     C+ values
     C+ (
     C+  'D',
     C+  601,
     C+  'ADUU',
     C+  'RUN - Adaptive Database Upgrade Update',
     C+  0,
     C+  ' ',
     C+  'CALL UPC4010',
     C+  '''*GLOBAL''',
     C+  ' ',
     C+  ' ',
     C+  ' ',
     C+  'C007'
     C+ )
     C/end-exec

     C                   EndIf

     C     End           Tag
     C                   Seton                                        LR
     C                   Return
      *****************************************************************
