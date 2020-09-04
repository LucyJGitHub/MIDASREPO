     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas SM Report of similarity between users - sum.')
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SM000035 - Compare differences betwen users, summary         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF005   *CREATE   Date 04Jul11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF005 - BF Infrastructure: Single Security User Maintenance *
      *           Profile                                             *
      *                                                               *
      *****************************************************************
     FSM000035P1O    E             PRINTER INFSR(*PSSR) INFDS(SpoolData)
      *
     D LastREFU        S             10    INZ('*NONE')
     D RemainLn        S              2  0
     D RqdLn           S              2  0 INZ(2)
     D Recursive       S              1    INZ('N')
      *
     D BFPC          E DS                  EXTNAME(SMBFPCPD)
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
     C+ declare PCcursor cursor for
     C+ select * from SMBFPCPD
     C/end-exec
      *
     C/exec SQL
     C+ open PCcursor
     C/end-exec
      *
     C/exec SQL
     C+ fetch next
     C+ from PCcursor
     C+ into: BFPC
     C/end-exec
      *
     C                   DOW       SQLCODE = 0
      *
     C                   EVAL      PUSR1 = PCUSR1
     C                   EVAL      PUSR2 = PCUSR2
     C                   EVAL      PRCD1 = PCRCD1
     C                   EVAL      PRCD2 = PCRCD2
     C                   EVAL      PMTCH = PCMTCH
     C                   EVAL      PNM01 = PCNM01
     C                   EVAL      PNM02 = PCNM02
     C                   EVAL      PMPC1 = PCMPC1
     C                   EVAL      PMPC2 = PCMPC2
     C                   EVAL      PNPC1 = PCNPC1
     C                   EVAL      PNPC2 = PCNPC2
     C                   EXSR      OverFlow
     C                   WRITE     FDTL
      *
     C/exec SQL
     C+ fetch next
     C+ from PCcursor
     C+ into: BFPC
     C/end-exec
      *
     C                   ENDDO
      *
     C/exec SQL
     C+ close PCcursor
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
