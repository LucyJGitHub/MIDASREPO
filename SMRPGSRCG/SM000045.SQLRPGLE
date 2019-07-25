     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Report of similarity between users - dtl.')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000045 - Compare differences betwen users, detail          *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      * CBF005 - BF Infrastructure: Single Security User Maintenance  *
      *          Profile                                              *
      *                                                               *
      *****************************************************************
     FSM000045P1O    E             PRINTER INFSR(*PSSR) INFDS(SpoolData)
      *
     D LastType        S             10    INZ(*blanks)
     D RemainLn        S              2  0
     D RqdLn           S              2  0 INZ(2)
     D Recursive       S              1    INZ('N')
      *
     D SpoolData       DS
     D  SpoolFile             83     92
     D  SpoolFileNo          123    124B 0
     D  OverFlowLn           188    189B 0
     D  PrintLn              367    368B 0
      *
     D BFDT          E DS                  EXTNAME(SMBFDTPD)

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

     C                   WRITE     FHDR
      *
     C/exec SQL
     C+ declare DTcursor cursor for
     C+ select * from SMBFDTPD
     C/end-exec
      *
     C/exec SQL
     C+ open DTcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from DTcursor
     C+ into: BFDT
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   IF        DTTYPE <> LastType
     C                   EVAL      PTYPE = DTTYPE
     C                   EVAL      PUSRS = DTUSRS
     C                   EVAL      LastType = DTTYPE
     C                   ELSE
     C                   EVAL      PTYPE = *blanks
     C                   EVAL      PUSRS = *blanks
     C                   ENDIF
     C                   EVAL      PINDX = DTINDX
     C                   EVAL      PINAR = DTINAR
     C                   EVAL      PBRCH = DTBRCH
     C                   EVAL      PAC01 = DTAC01
     C                   EVAL      PAC02 = DTAC02
     C                   EVAL      PAC03 = DTAC03
     C                   EVAL      PAC04 = DTAC04
     C                   EVAL      PAC05 = DTAC05
     C                   EVAL      PAC06 = DTAC06
     C                   EVAL      PAC07 = DTAC07
     C                   EVAL      PAC08 = DTAC08
     C                   EVAL      PAC09 = DTAC09
     C                   EVAL      PAC10 = DTAC10
     C                   EXSR      OverFlow
     C                   WRITE     FDTL
      *
     C/exec SQL
     C+ fetch next
     C+ from DTcursor
     C+ into: BFDT
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close DTcursor
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
     C                   EVAL      PTYPE = DTTYPE
     C                   EVAL      PUSRS = DTUSRS
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
