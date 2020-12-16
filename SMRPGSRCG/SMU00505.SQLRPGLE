     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Delete Midas Views Dependent to BFLIB')       *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMU00505 - Delete Midas Views Dependent to FBP Schema Lib    *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD050405  *CREATE  Date 03Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD050405 - Fusion Midas 2.1 Platform Upgrade                 *
      *                                                               *
      *****************************************************************

      ** Program entry parameters
     D PLayer          S              7A
     D PBackupLib      S             10A
     D PReturn         S              1A

      ** Program work variables
     D ViewName        S             10A
     D WRun            S              1A

     D/COPY GPCPYSRCG,PSDS

     C     *ENTRY        PLIST
     C                   PARM                    PLayer
     C                   PARM                    PBackupLib
     C                   PARM                    PReturn

      ** Select all Midas Views dependent to BFLIB from UPDLVCPD
      ** These views reside in HISQLSRCGV source-pf
     C/exec SQL
     C+ declare DLVC cursor for
     C+ select
     C+   AUMBNM
     C+ from UPDLVCPD
     C+ where
     C+     AUDTLB = :PLayer
     C+ and AUSRCF = 'HISQLSRCGV'
     C+ and AUMBTP = 'SQLVIEW'
     C+ order by
     C+   AUIPTY desc
     C/end-exec
      *
     C/exec SQL
     C+ open DLVC
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DLVC
     C+ into
     C+   :ViewName
     C/end-exec

     C                   DOW       SQLCOD <> 100

     C                   IF        SQLCOD <> 0 and SQLCOD <> 100
     C                   EVAL      PReturn = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   CALL      'UPC000042'
     C                   PARM                    PBackupLib
     C                   PARM                    ViewName
     C                   PARM      *BLANK        PReturn

     C                   IF        PReturn = 'F'
     C                   EVAL      PReturn = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF

     C/exec SQL
     C+ fetch next
     C+ from DLVC
     C+ into
     C+   :ViewName
     C/end-exec

     C                   ENDDO

     C/exec SQL
     C+ close DLVC
     C/end-exec

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
