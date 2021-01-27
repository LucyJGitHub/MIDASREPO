     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - ADBU Compare Report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4016 - ADBU Compare Report (Reconcile)                     *
      *                                                               *
      *           This program generates report UP4016P1 listing      *
      *           detailled changes resulting form the compare (CMPF).*
      *           This program writes driver files that is used for   *
      *           the update phase.                                   *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050666 *CREATE     Date 17Mar20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050666 - Adaptive Database Upgrade                         *
      *                                                               *
      *****************************************************************
     FUPCLOGPD  IF   E             DISK
     FUP4016P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D FLDA@           S              6    DIM(19) CTDATA PERRCD(1)
     D Dep_Fil         S             10    DIM(999)
     D DepF            S             10
     D S_DepF          S             10
     D Ix              S              5  0
     D Cnt             S              5  0
     D RcdCount        S              5  0

     D S_JOB           S             10
     D S_FILE          S             10
     D Recursive       S              1
     D ObjFlag         S              1
     D SrcFlag         S              1
     D first           S              1
     D X               S              1  0
      *
     D                 DS
     D  DateStamp              1     12
     D  yy                     1      2
     D  mm                     3      4
     D  dd                     5      6
      *
      /SPACE 3
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  R_JOB                244    253
     D  R_USER               254    263

     D UPGDRV        E DS                  EXTNAME(UPGDRVTD)
     D UPZLOG        E DS                  EXTNAME(UPRCLGPD)

     **************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    Lib1              2
     C                   PARM                    Lib2              2
     C                   PARM                    LAYER             7
      *
     C*    *LIKE         DEFINE    SOSRCF        WSRCF
      *
      * Set up main report title.
     C*                  EVAL      @TITLE = WTitle
     C*                  EVAL      @TITLE = %TRIMR(@TITLE) + ' ' + SourceLib

      * Write main page header.
     C                   setoff                                       20
     C                   IF        Layer = '*GLOBAL'
     C                   seton                                        20
     C                   ENDIF

      * Write main page header.
     C                   WRITE     HEADH

      * Read log file and process for each entry
     C                   if        Layer = '*GLOBAL'
     C/exec SQL
     C+ declare CursorRdG cursor for
     C+ select *
     C+ from UPGRCLPD
     C+ order by WJOB, WFILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdG
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPZLOG
     C/end-exec
     C                   else
     C/exec SQL
     C+ declare CursorRdZ cursor for
     C+ select *
     C+ from UPZRCLPD
     C+ order by WJOB, WFILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPZLOG
     C/end-exec
     C                   endif

      * If there are no records at all write 'no records' for all types
      * of mis-matches.
     C                   IF        SQLCODE = 100
     C                   if        Layer = '*GLOBAL'
     C                   eval      R_NORLC = 'Global compared: ' + Lib1
     C                   eval      R_NORLR = 'Global reference: ' + Lib2
     C                   else
     C                   eval      R_NORLC = 'Zone compared: ' + Lib1
     C                   eval      R_NORLR = 'Zone reference: ' + Lib2
     C                   endif
     C                   WRITE     NORECS
     C                   WRITE     TRAILP
     C                   GOTO      ENDPGM
      *
     C                   ENDIF
      *
     C                   eval      DRPRFX = Lib1

     C                   DOW       SQLCODE = 0
      *
      * If records are found print details
     C                   EXSR      Details
      *
      *
      * Read next record.
     C                   if        Layer = '*GLOBAL'
     C/exec SQL
     C+ fetch next
     C+ from CursorRdG
     C+ into :UPZLOG
     C/end-exec
     C                   else
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into :UPZLOG
     C/end-exec
     C                   endif

      *
     C                   ENDDO
      *
      * Write trailer and end program.
     C                   WRITE     TRAILP
      *
     C                   if        Layer = '*GLOBAL'
     C/exec SQL
     C+ close CursorRdG
     C/end-exec
     C                   else
     C/exec SQL
     C+ close CursorRdZ
     C/end-exec
     C                   endif

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * Details -                                                     *
      *                                                               *
      *****************************************************************
     C     Details       BEGSR

     C                   clear                   DETAIL

      * Write header for library
     C                   IF        S_JOB <> WJOB
     C                             and S_JOB <> *BLANKS

      * Now look for dependent files (for the previous file reported) and list them
     C                   IF        S_FILE <> *BLANKS
     C                   exsr      SR_Depend
     C                   ENDIF
     C                   eval      S_FILE = *BLANKS

     C                   eval      R_LIB = WJOB
     C                   eval      DRLIB = WJOB
     C                   eval      R_LIBR = Lib2 + %SUBST(WJOB:3:8)
     C                   WRITE     HEADH
     C                   WRITE     LIBRARY
     C                   ENDIF
     C                   IF        S_JOB = *BLANKS
     C                   eval      R_LIB = WJOB
     C                   eval      DRLIB = WJOB
     C                   eval      R_LIBR = Lib2 + %SUBST(WJOB:3:8)
     C                   WRITE     LIBRARY
     C                   ENDIF
     C                   eval      S_JOB = WJOB

      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     LIBRARY
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
     C                   eval      R_FILE = WFILE
     C                   eval      DRFILE = WFILE

      * If Logical File (WJOB is DV or GV), check that file is not part of dependent files.
      * If yes, it has been reported as 'Affected files' already. Then ignore now.
     C                   If        %subst(WJOB:4:1) = 'V'
     C                   If        LAYER = '*GLOBAL'
     C/exec SQL
     C+ select count(*) into :RcdCount from UPGXRFPD
     C+ where PDEPF = :WFILE
     C/end-exec

     C                   If        RcdCount > 0
     C                   goto      DetailsE
     C                   ENDIF
     C                   ENDIF
     C                   If        LAYER = '*ZONE'
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZXRFPD
     C+ where PDEPF = :WFILE
     C/end-exec

     C                   If        RcdCount > 0
     C                   goto      DetailsE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      * If File is from GMLIB, need to check if file is UDF
      * If yes, 'Rmv field' and other attributes can be ignored.
     C                   If        %subst(WJOB:3:2) = 'GM'
     C/exec SQL
     C+ select count(*) into :RcdCount from SMGNMGPD
     C+ where NCOBJ = :WFILE  and NCETBL = 'Y'
     C/end-exec

     C                   If        RcdCount > 0
     C                             and WDESC = 'Rmv field'
      * also ignore the following attributes: WHDFTL, WHDFT and WHSQLT
     C                             or RcdCount > 0 and WFLDA = 'WHDFTL'
     C                             or RcdCount > 0 and WFLDA = 'WHDFT '
     C                             or RcdCount > 0 and WFLDA = 'WHSQLT'
     C                   goto      DetailsE
     C                   ENDIF
     C                   ENDIF

      * for PF only, the following changes can be ignored in case file has been
      * reported with 'New field' or 'Rmv field' or change in WHFLDB
      *     RFFLDN                        Number of fields and indicato
      *     RFLEN                         Record format length
      *     RFID                          Format level identifier

     C                   If        %subst(WJOB:4:1) <> 'V'
     C                             and (WFLDA = 'RFFLDN' or WFLDA = 'RFLEN'
     C                               or WFLDA = 'RFID')
     C                   If        LAYER = '*GLOBAL'
     C/exec SQL
     C+ select count(*) into :RcdCount from UPGLOGPD
     C+ where WFILE = :WFILE and ((WDESC = 'New field'
     C+ or WDESC = 'Rmv field') or (WFLDA = 'WHFLDB'))
     C/end-exec

     C                   If        RcdCount > 0
     C                   goto      DetailsE
     C                   ENDIF
     C                   ENDIF
     C                   If        LAYER = '*ZONE'
     C/exec SQL
     C+ select count(*) into :RcdCount from UPZRCLPD
     C+ where WFILE = :WFILE and ((WDESC = 'New field'
     C+ or WDESC = 'Rmv field') or (WFLDA = 'WHFLDB'))
     C/end-exec

     C                   If        RcdCount > 0
     C                   goto      DetailsE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF


      * Set Attribute
     C                   SELECT
     C                   WHEN      WDSP = 'DSPFFD1'
     C                   eval      R_ATTR = %TRIMR(WFLD1) +
     C                             '/' + %TRIMR(WFLDA)
     C                   eval      R_DESC = WFDEC
     C                   eval      R_DIFF = WDATA
     C                   eval      DRACTN = 'SQL update'
     C                   eval      DRALLC = 'N'

     C                   WHEN      WDESC= 'New file'
     C                   eval      R_DESC = WDESC
     C                   eval      R_DIFF = 'New file in Reference System'
     C                   eval      DRACTN = 'File will be copied'
     C                   eval      DRALLC = 'N'

     C                   WHEN      WDESC= 'File missing'
     C                   eval      R_DESC = WDESC
     C                   eval      R_DIFF = 'File missing in Reference System'
     C                   eval      DRACTN = 'File will be deleted'
     C                   eval      DRALLC = 'Y'

     C                   WHEN      WDESC= 'New field'
     C                   eval      R_ATTR = WFLD2
     C                   eval      R_DESC = 'Field added'
     C                   eval      R_DIFF = 'New field in Reference System'

     C                   WHEN      WDESC= 'Rmv field'
     C                   eval      R_ATTR = WFLD1
     C                   eval      R_DESC = 'Field removed'
     C                   eval      R_DIFF = 'Field missing in Reference System'

     C                   OTHER
     C                   eval      R_ATTR = WFLDA
     C                   eval      R_DESC = WFDEC
     C                   eval      R_DIFF = WDATA

     C                   endsl

      * If field attribute for DSPFFD1 is not in the array, report error
     C                   setoff                                       70
     C                   IF        WDSP = 'DSPFFD1'
     C                             and WFLDA <> *BLANKS
     C     WFLDA         LOOKUP    FLDA@                                  22
     C                   IF        *IN22 = '0'
     C                   seton                                        70
     C                   ENDIF
     C                   ENDIF

      * Write Detail if file hasn't been reported
      * else write 'same detail' (SDETAIL)
     C                   IF        S_FILE <> WFILE
      * Now look for dependent files (for the previous file reported) and list them
     C                   IF        S_FILE <> *BLANKS
     C                   exsr      SR_Depend
     C                   ENDIF
     C                   WRITE     DETAIL
     C                   ELSE
     C                   WRITE     SDETAIL
     C                   ENDIF
     C                   eval      S_FILE = WFILE


     C     DetailsE      ENDSR


      /EJECT
      *****************************************************************
      *                                                               *
      * *SR_Depend -                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SR_Depend     BEGSR

      * Clear Array
     C                   clear                   Dep_Fil

     C                   If        LAYER = '*GLOBAL'
     C/exec SQL
     C+ declare DepFile cursor for
     C+ select
     C+   PDEPF
     C+ from UPGXRFPD
     C+ where PMFILE = :S_FILE
     C/end-exec
      *
     C/exec SQL
     C+ open DepFile
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DepFile
     C+ into
     C+   :DepF
     C/end-exec

     C                   eval      Ix = 0

     C                   DOW       SQLCODE = 0

      * Fill array if not yet in
     C     DepF          LOOKUP    Dep_Fil                                99
     C     *IN99         IFEQ      '0'
     C                   eval      Ix = Ix + 1
     C                   eval      Dep_Fil(Ix) = DepF
     C                   ENDIF

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from DepFile
     C+ into
     C+   :DepF
     C/end-exec

     C                   END

     C/exec SQL
     C+ close DepFile
     C/end-exec
     C                   ENDIF

     C                   If        LAYER = '*ZONE  '
     C/exec SQL
     C+ declare DepFileZ cursor for
     C+ select
     C+   PDEPF
     C+ from UPZXRFPD
     C+ where PMFILE = :S_FILE
     C/end-exec
      *
     C/exec SQL
     C+ open DepFileZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DepFileZ
     C+ into
     C+   :DepF
     C/end-exec

     C                   eval      Ix = 0

     C                   DOW       SQLCODE = 0

      * Fill array if not yet in
     C     DepF          LOOKUP    Dep_Fil                                99
     C     *IN99         IFEQ      '0'
     C                   eval      Ix = Ix + 1
     C                   eval      Dep_Fil(Ix) = DepF
     C                   ENDIF

      * Get next
     C/exec SQL
     C+ fetch next
     C+ from DepFileZ
     C+ into
     C+   :DepF
     C/end-exec

     C                   END

     C/exec SQL
     C+ close DepFileZ
     C/end-exec
     C                   ENDIF

     C                   if        Ix > 0
     C                   eval      Cnt = 1
     C                   eval      first = 'n'
     C                   dow       Ix >= Cnt
     C                   if        first = 'n'
     C                   eval      first = 'y'
     C                   eval      R_DEP = 'Affected Logical Files: ' +
     C                             Dep_Fil(Cnt) + ' ' + Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' '
     C                   eval      Cnt = Cnt + 8
     C                   WRITE     SDEP
     C                   iter
     C                   else
     C                   eval      R_DEP2 = Dep_Fil(Cnt) + ' ' +
     C                             Dep_Fil(Cnt+1) + ' ' +
     C                             Dep_Fil(Cnt+2) + ' ' + Dep_Fil(Cnt+3) + ' ' +
     C                             Dep_Fil(Cnt+4) + ' ' + Dep_Fil(Cnt+5) + ' ' +
     C                             Dep_Fil(Cnt+6) + ' ' + Dep_Fil(Cnt+7) + ' ' +
     C                             Dep_Fil(Cnt+8) + ' ' + Dep_Fil(Cnt+9)
     C                   eval      Cnt = Cnt + 10
     C                   WRITE     SDEP2
     C                   iter
     C                   endif
     C                   enddo
     C                   ENDIF

     C                   ENDSR

      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     Recursive     IFEQ      *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
** FLDA@
WHFLDD
WHFLDT
WHVARL
WHFLDB
WHCHD1
WHFTXT
WHCHD2
WHCHD3
WHSQLT
WHDFT
WHDFTL
WHNAME
WHFLDP
WHALCH
WHFDSL
WHFLDG
WHPSUD
WHDBLL
WHNULL
