     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas BIC Directory File Desc Initialise')             *
      *****************************************************************
      *                                                               *
      *  Midas - S.W.I.F.T Direct Link                                *
      *                                                               *
      *  MS000001 - MIDAS BIC Directory File Desc Initialise          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD025126           Date 17Feb14               *
      *  Prev Amend No. CMS002  *CREATE    Date 28Sep12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD025126 - PF/MEBICFPD issue with SWIFT 2013/CFT050 -        *
      *             conflict with CMS002 (Recompile)                  *
      *  CMS002 - BIC Directory Details Enquiry                       *
      *                                                               *
      *****************************************************************
      *
     FMEBICFPD  UF   E             DISK
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D WSeqNbr         S              5S 0 INZ(10)
      *
     C     1             SETLL     MEBICFD0
     C                   READ(E)   MEBICFPD
      *
     C                   DOW       NOT %EOF
     C                   EVAL      MEXCL = *BLANKS
     C                   EVAL      MSEQN = WSeqNbr
     C                   UPDATE    MEBICFD0
      *
     C                   EVAL      WSeqNbr = WSeqNbr + 10
     C                   READ(E)   MEBICFPD
     C                   ENDDO
      *
     C                   EVAL      *INLR = *On
     C                   RETURN
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * *PSSR  - Program Exception Error Routine                        *
      *                                                                 *
      ********************************************************************
     C     *PSSR         BEGSR
     C                   DUMP
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
