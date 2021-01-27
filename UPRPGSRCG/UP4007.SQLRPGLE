     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas UP - ADBU Summary Compare Report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP4007 - ADBU Summary Compare Report                         *
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
     FUP4007P1  O    E             PRINTER OFLIND(*IN37)
      /EJECT

     D XLib            S             10
     D RdFile          S             10
     D RcdCount        S              5  0
     D Dep_Fil         S             10    DIM(999)
     D DepF            S             10
     D S_DepF          S             10
     D Ix              S              3  0

     D S_JOB           S             10
     D S_FILE          S             10
     D Recursive       S              1
     D ObjFlag         S              1
     D SrcFlag         S              1
     D MatFlag         S              1
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
      *
     C     *ENTRY        PLIST
     C                   PARM                    Lib1              2
     C                   PARM                    Lib2              2
     C                   PARM                    Layer             7


      * Write main page header.
     C                   setoff                                       20
     C                   IF        Layer = '*GLOBAL'
     C                   seton                                        20
     C                   ENDIF
     C                   WRITE     HEADH
      *
     C     1             SETLL     UPCLOGD0
     C                   READ      UPCLOGD0
      *
      * If there are no records at all write 'no records' for all types
      * of mis-matches.
     C                   IF        %EOF
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

     C                   ENDIF

      * Set report fields
     C                   eval      R_SYS = Lib1
     C                   eval      R_SYSR = Lib2

      * Get details from MLIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = LIB1 + 'GMLIB'
     C                   eval      R_MLIB = LIB1 + 'GMLIB'
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_M_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_M_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_M_MIS = %char(RcdCount)

     C                   else
     C                   eval      XLib = LIB1 + 'DMLIB'
     C                   eval      R_MLIB = LIB1 + 'DMLIB'

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_M_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_M_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_M_MIS = %char(RcdCount)
     C                   endif

      * Get details from PLIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = LIB1 + 'GPLIB'
     C                   eval      R_PLIB = LIB1 + 'GPLIB'
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_P_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_P_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_P_MIS = %char(RcdCount)

     C                   else
     C                   eval      XLib = LIB1 + 'DPLIB'
     C                   eval      R_PLIB = LIB1 + 'DPLIB'

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_P_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_P_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_P_MIS = %char(RcdCount)

     C                   endif

      * Get details from TALIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = LIB1 + 'GTALIB'
     C                   eval      R_TLIB = LIB1 + 'GTALIB'
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_T_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_T_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_T_MIS = %char(RcdCount)

     C                   else

     C                   eval      XLib = LIB1 + 'DTALIB'
     C                   eval      R_TLIB = LIB1 + 'DTALIB'
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_T_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_T_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_T_MIS = %char(RcdCount)

     C                   endif

      * Get details from VLIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = LIB1 + 'GVLIB'
     C                   eval      R_VLIB = LIB1 + 'GVLIB'
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_V_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_V_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_V_MIS = %char(RcdCount)

     C                   else

     C                   eval      XLib = LIB1 + 'DVLIB'
     C                   eval      R_VLIB = LIB1 + 'DVLIB'
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'New file'
     C/end-exec

     C                   eval      R_V_NEW = %char(RcdCount)

     C/exec SQL
     C+ select count(distinct wfile) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC <> 'File missing' and WDESC <> 'New file'
     C/end-exec

     C                   eval      R_V_AMD = %char(RcdCount)

     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WDESC = 'File missing'
     C/end-exec

     C                   eval      R_V_MIS = %char(RcdCount)

     C                   endif

      * Write SUMMARY
     C                   write     SUMMARY

      * for MLIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = Lib1 + 'GMLIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'GMLIB'
     C                   else
     C                   eval      XLib = Lib1 + 'DMLIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'DMLIB'
     C                   endif
      * Write Overview
     C                   WRITE     HEADH
     C                   WRITE     OVERVIEWH

     C                   if        Layer = '*GLOBAL'
     C                   exsr      SR_ReadG
     C                   else
     C                   exsr      SR_ReadZ
     C                   endif

      * for PLIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = Lib1 + 'GPLIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'GPLIB'
     C                   else
     C                   eval      XLib = Lib1 + 'DPLIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'DPLIB'
     C                   endif
      * Write Overview
     C                   WRITE     HEADH
     C                   WRITE     OVERVIEWH

     C                   if        Layer = '*GLOBAL'
     C                   exsr      SR_ReadG
     C                   else
     C                   exsr      SR_ReadZ
     C                   endif

      * for TALIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = Lib1 + 'GTALIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'GTALIB'
     C                   else
     C                   eval      XLib = Lib1 + 'DTALIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'DTALIB'
     C                   endif
      * Write Overview
     C                   WRITE     HEADH
     C                   WRITE     OVERVIEWH

     C                   if        Layer = '*GLOBAL'
     C                   exsr      SR_ReadG
     C                   else
     C                   exsr      SR_ReadZ
     C                   endif

      * for VLIB
     C                   if        Layer = '*GLOBAL'
     C                   eval      XLib = Lib1 + 'GVLIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'GVLIB'
     C                   else
     C                   eval      XLib = Lib1 + 'DVLIB'
     C                   eval      R_LIB = XLib
     C                   eval      R_LIBR = Lib2 + 'DVLIB'
     C                   endif
      * Write Overview
     C                   WRITE     HEADH
     C                   WRITE     OVERVIEWH

     C                   if        Layer = '*GLOBAL'
     C                   exsr      SR_ReadG
     C                   else
     C                   exsr      SR_ReadZ
     C                   endif

      * Write 'End of report'
     C                   write     TRAILP

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN

      /EJECT
      *****************************************************************
      *                                                               *
      * SR_ReadG                                                      *
      *                                                               *
      *****************************************************************
     C     SR_ReadG      BEGSR

     C/exec SQL
     C+ declare CursorRd cursor for
     C+ select distinct(WFILE)
     C+ from UPGLOGPD
     C+ where WJOB = :XLib order by WFILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRd
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRd
     C+ into
     C+   :RdFile
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   exsr      SR_DetailsG
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from CursorRd
     C+ into
     C+   :RdFile
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close CursorRd
     C/end-exec
     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * SR_DetailsG                                                   *
      *                                                               *
      *****************************************************************
     C     SR_DetailsG   BEGSR

      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     OVERVIEWH
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF

     C                   clear                   OVERVIEWD
     C                   eval      R_OFILE = RdFile

      * New file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'New file'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_ONWF = 'Y'
     C                   Endif

      * Field added?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'New field'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFAD = %Char(RcdCount)
     C                   Endif

      * Field attributes changed
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WFLDA <> '      '
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFAC = %Char(RcdCount)
     C                   Endif

      * Field removed?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'Rmv field'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFRM = %Char(RcdCount)
     C                   Endif

      * New file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPGLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'File missing'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFMS = 'Y'
     C                   Endif

     C                   WRITE     OVERVIEWD
     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * SR_ReadG                                                      *
      *                                                               *
      *****************************************************************
     C     SR_ReadZ      BEGSR

     C/exec SQL
     C+ declare CursorRdZ cursor for
     C+ select distinct(WFILE)
     C+ from UPZLOGPD
     C+ where WJOB = :XLib order by WFILE
     C/end-exec
      *
     C/exec SQL
     C+ open CursorRdZ
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into
     C+   :RdFile
     C/end-exec

     C                   DOW       SQLCODE = 0
     C                   exsr      SR_DetailsZ
      * Get next
     C/exec SQL
     C+ fetch next
     C+ from CursorRdZ
     C+ into
     C+   :RdFile
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close CursorRdZ
     C/end-exec
     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * SR_DetailsG                                                   *
      *                                                               *
      *****************************************************************
     C     SR_DetailsZ   BEGSR

      * If overflow on then write header.
     C                   IF        *IN37 = *ON
     C                   WRITE     HEADH
     C                   WRITE     OVERVIEWH
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF

     C                   clear                   OVERVIEWD
     C                   eval      R_OFILE = RdFile

      * New file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'New file'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_ONWF = 'Y'
     C                   Endif

      * Field added?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'New field'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFAD = %Char(RcdCount)
     C                   Endif

      * Field attributes changed
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WFLDA <> '      '
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFAC = %Char(RcdCount)
     C                   Endif

      * Field removed?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'Rmv field'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFRM = %Char(RcdCount)
     C                   Endif

      * New file?
     C/exec SQL
     C+ select count(*) into :RcdCount
     C+ from UPZLOGPD
     C+ where
     C+     WJOB = :XLib and WFile = :RdFile and WDESC = 'File missing'
     C/end-exec

     C                   If        SQLCODE = 0 and RcdCount > 0
     C                   evalr     R_OFMS = 'Y'
     C                   Endif

     C                   WRITE     OVERVIEWD
     C                   ENDSR

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
