     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Report of reference users')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000033 - Report reference users                            *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *                                         Profile               *
      *                                                               *
      *****************************************************************
     FSM000033P1O    E             PRINTER INFSR(*PSSR) INFDS(SpoolData)
      *
     D LastREFU        S             10    INZ('*NONE')
     D RemainLn        S              2  0
     D RqdLn           S              2  0 INZ(2)
     D Recursive       S              1    INZ('N')
      *
     D BFRU          E DS                  EXTNAME(SMBFRUPD)
      *
     D SpoolData       DS
     D  SpoolFile             83     92
     D  SpoolFileNo          123    124B 0
     D  OverFlowLn           188    189B 0
     D  PrintLn              367    368B 0
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
     C                   WRITE     FHDR
      *
     C/exec SQL
     C+ declare RUcursor cursor for
     C+ select * from SMBFRUPD
     C+ order by RUREFU, RUUSER
     C/end-exec
      *
     C/exec SQL
     C+ open RUcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from RUcursor
     C+ into: BFRU
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   IF        RUREFU <> LastREFU
     C                   EVAL      LastREFU = RUREFU
     C                   IF        RUREFU = *blanks
     C                   EVAL      PREFU = '*none'
     C                   ELSE
     C                   EVAL      PREFU = RUREFU
     C                   ENDIF
     C                   ELSE
     C                   EVAL      PREFU = *blanks
     C                   ENDIF
     C                   EVAL      PUSER = RUUSER
     C                   EVAL      PRECI = RURECI
      *
      ** Check that the report is not going to overflow.
      *
     C                   EXSR      OverFlow
     C                   WRITE     FDTL
      *
     C/exec SQL
     C+ fetch next
     C+ from RUcursor
     C+ into: BFRU
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close RUcursor
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
     C                   EVAL      PREFU = RUREFU
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
