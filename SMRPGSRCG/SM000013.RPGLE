     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Migration report - not found and failed')     *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SM000013 - Migration report - not found and failed.          *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP003             Date 08Aug10               *
      *                 BUG27793 *CREATE   Date 10Jun10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP003 - Handle unique key problems better.                  *
      *  BUG27793 - Make migration multi-streamed.                    *
      *                                                               *
      *****************************************************************
     FSMCPYDL1  IF   E           K DISK    INFSR(*PSSR)
     FSM000013P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SpoolData)
      *
     D RqdLines        S              1  0 INZ(2)
     D RemainLn        S              2  0
     D Recursive       S              1    INZ(' ')
      *
     D SpoolData       DS
     D  SpoolFile             83     92
     D  SpoolFileNo          123    124B 0
     D  OverFlowLn           188    189B 0
     D  PrintLn              367    368B 0
      *
     C                   WRITE     MAINH
      *
     C     *LOVAL        SETLL     SMCPYDL1
     C                   READ      SMCPYDL1
     C                   IF        %EOF
     C                   WRITE     NORECS
     C                   ELSE
      *
     C**********         DOU       %EOF                                                       CUP003
     C                   DOW       NOT(%EOF)                                                  CUP003
      * Set up standard values for detail line.
     C                   IF        ODDDAT = 'NFOUND'
     C                   EVAL      S13STS = 'Not found'
     C                   ELSE
     C                   IF        ODDDAT = 'FAILED'                                          CUP003
     C                   EVAL      S13STS = 'Failed'
     C                   ELSE                                                                 CUP003
     C                   EVAL      S13STS = 'Unique'                                          CUP003
     C                   ENDIF                                                                CUP003
     C                   ENDIF
     C                   EVAL      S13OBJ = ODOBNM
     C                   EVAL      S13TYP = ODOBTP
     C                   EVAL      S13TXT = ODOBTX
     C                   EXSR      OverFlow
     C                   WRITE     DTL1
      *
     C                   READ      SMCPYDL1
     C                   ENDDO
      *
     C                   ENDIF
      *
      * Write trailer and end program.
     C                   EXSR      OverFlow
     C                   WRITE     TRAILP
      *
     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *
     C     OverFlow      BEGSR
      *
     C                   EVAL      RemainLn = OverFlowLn - PrintLn
     C                   IF        RemainLn < RqdLines
     C                   WRITE     MAINH
     C                   ENDIF
      *
     C     OverFlowE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive <> 'Y'
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      *
      ********************************************************************
