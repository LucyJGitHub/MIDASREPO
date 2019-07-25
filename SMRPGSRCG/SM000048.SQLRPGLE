     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Report of user / menu / action combi.')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000048 - Report of user / menu / action combination        *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
     FSM000048P1O    E             PRINTER INFSR(*PSSR) INFDS(SpoolData)
      *
     D LastUSER        S             10    INZ('*NONE')
     D RemainLn        S              2  0
     D RqdLn           S              2  0 INZ(2)
     D Recursive       S              1    INZ('N')
      *
     D BFUA          E DS                  EXTNAME(SMBFUAPD)
      *
     D SpoolData       DS
     D  SpoolFile             83     92
     D  SpoolFileNo          123    124B 0
     D  OverFlowLn           188    189B 0
     D  PrintLn              367    368B 0

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   WRITE     FHDR
      *
     C/exec SQL
     C+ declare UAcursor cursor for
     C+ select * from SMBFUAPD
     C+ order by UAUSER, UAINDX
     C/end-exec
      *
     C/exec SQL
     C+ open UAcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from UAcursor
     C+ into: BFUA
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   IF        UAUSER <> LastUSER
     C                   EVAL      LastUSER = UAUSER
     C                   EVAL      PUSER = UAUSER
     C                   ELSE
     C                   EVAL      PUSER = *blanks
     C                   ENDIF
     C                   EVAL      PINDX = UAINDX
     C                   EVAL      PAC01 = UAAC01
     C                   EVAL      PAC02 = UAAC02
     C                   EVAL      PAC03 = UAAC03
     C                   EVAL      PAC04 = UAAC04
     C                   EVAL      PAC05 = UAAC05
     C                   EVAL      PAC06 = UAAC06
     C                   EVAL      PAC07 = UAAC07
     C                   EVAL      PAC08 = UAAC08
     C                   EVAL      PAC09 = UAAC09
     C                   EVAL      PAC10 = UAAC10
     C                   EVAL      PINAR = UAINAR
      *
      ** Check that the report is not going to overflow.
      *
     C                   EXSR      OverFlow
     C                   WRITE     FDTL
      *
     C/exec SQL
     C+ fetch next
     C+ from UAcursor
     C+ into: BFUA
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close UAcursor
     C/end-exec
      *
     C                   EVAL      RqdLn = 1
     C                   EXSR      OverFlow
     C                   WRITE     FTLR
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *
     C     OverFlow      BEGSR
      *
     C                   EVAL      RemainLn = OverFlowLn - PrintLn
     C                   IF        RemainLn < RqdLn
     C                   WRITE     FHDR
     C                   EVAL      PUSER = UAUSER
     C                   ENDIF
      *
     C     OverFlowE     ENDSR
      *
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
