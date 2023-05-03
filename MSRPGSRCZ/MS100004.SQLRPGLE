     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('MIR and MOR Sequence Generator')                       *
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT Module                                         *
      *                                                               *
      *  MS100004 - Reset MIR and MOR Sequence Generator              *
      *                                                               *
      *  Function:  This program will generate sequences for MIR and  *
      *             MOR                                               *
      *                                                               *
      *  Called By: Various SWIFT Interfaces                          *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060326 *CREATE    Date 20Mar23              *
      *                                                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060326 - MIR and MOR Sequence Generator                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  USE OF INDICATORS                                            *
      *                                                               *
      *    U7         Database error                                  *
      *    U8         Database error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                                                               *
      *****************************************************************
      *
      ** Files
      *
      *****************************************************************
       /EJECT
      *****************************************************************
     DSeqDS            DS
     DDSMIRSeq                       10P 0
     DDSMORSeq                       10P 0

       /EJECT
      *****************************************************************
      * MAIN PROCESSING                                               *
      *****************************************************************

      ** Declare Cursors
      *
     C                   EXSR      DecCur
     C                   EXSR      OpnCur
     C                   EXSR      FetCur
     C                   EXSR      UpdCur
     C                   EXSR      CloCur

      ** End Program
     C                   COMMIT
     C
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DecCur  - Declare Cursors                                     *
      *                                                               *
      *****************************************************************
     C     DecCur        BEGSR
      *
     C/exec SQL
     C+ declare SeqCur Cursor for
     C+ select
     C+   MIRSEQ,
     C+   MORSEQ
     C+ from MSMIRGTD
     C+ for update of
     C+   MIRSEQ,
     C+   MORSEQ
     C/end-exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UpdCur  - Update Cursors                                      *
      *                                                               *
      *****************************************************************
     C     UpdCur        BEGSR
      *
      ** Update sequences
      *
     C/exec SQL
     C+ update MSMIRGTD
     C+ set MIRSEQ = 0,
     C+     MORSEQ = 0
     C+ where current of SeqCur
     C/end-exec
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * OpnCur  - Open Cursor                                         *
      *                                                               *
      *****************************************************************
     C     OpnCur        BEGSR
     C/exec SQL
     C+ open SeqCur
     C/end-exec
      *

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * FetCur  - Fetch Cursor                                        *
      *                                                               *
      *****************************************************************
     C     FetCur        BEGSR
     C/exec SQL
     C+ fetch next from SeqCur into :SeqDS
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CloCur  - Close Cursor                                        *
      *                                                               *
      *****************************************************************
     C     CloCur        BEGSR
     C/exec SQL
     C+ close SeqCur
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT

