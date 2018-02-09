     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC SoD Data Replication Initialisation Run')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000030 - Data Replication SoD Initialisation Run           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Journal Sequence Number for Batch 0
     FSCJSN0PD  UF A E             DISK    INFSR(*PSSR)
     F                                     PREFIX(J0:2)
 
      ** Journal Sequence Number for Batch 1
     FSCJSN1PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN1D0)
     F                                     PREFIX(J1:2)
 
      ** Journal Sequence Number for Batch 2
     FSCJSN2PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN2D0)
     F                                     PREFIX(J2:2)
 
      ** Journal Sequence Number for Batch 3
     FSCJSN3PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN3D0)
     F                                     PREFIX(J3:2)
 
      ** Journal Sequence Number for Batch 4
     FSCJSN4PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN4D0)
     F                                     PREFIX(J4:2)
 
      ** Journal Sequence Number for Batch 5
     FSCJSN5PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN5D0)
     F                                     PREFIX(J5:2)
 
      ** Journal Sequence Number for Batch 6
     FSCJSN6PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN6D0)
     F                                     PREFIX(J6:2)
 
      ** Journal Sequence Number for Batch 7
     FSCJSN7PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN7D0)
     F                                     PREFIX(J7:2)
 
      ** Journal Sequence Number for Batch 8
     FSCJSN8PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN8D0)
     F                                     PREFIX(J8:2)
 
      ** Journal Sequence Number for Batch 9
     FSCJSN9PD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(SCJSN0D0:SCJSN9D0)
     F                                     PREFIX(J9:2)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D JrnSeqNo        S             10  0
 
     D WRun            S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Update Sequence no. for Batch 0
 
     C     1             SETLL     SCJSN0PD
     C                   READ      SCJSN0PD                               41
 
     C                   MOVE      JrnSeqNo      J0LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN0D0
     C                   ELSE
     C                   WRITE     SCJSN0D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 1
 
     C     1             SETLL     SCJSN1PD
     C                   READ      SCJSN1PD                               41
 
     C                   MOVE      JrnSeqNo      J1LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN1D0
     C                   ELSE
     C                   WRITE     SCJSN1D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 2
 
     C     1             SETLL     SCJSN2PD
     C                   READ      SCJSN2PD                               41
 
     C                   MOVE      JrnSeqNo      J2LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN2D0
     C                   ELSE
     C                   WRITE     SCJSN2D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 3
 
     C     1             SETLL     SCJSN3PD
     C                   READ      SCJSN3PD                               41
 
     C                   MOVE      JrnSeqNo      J3LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN3D0
     C                   ELSE
     C                   WRITE     SCJSN3D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 4
 
     C     1             SETLL     SCJSN4PD
     C                   READ      SCJSN4PD                               41
 
     C                   MOVE      JrnSeqNo      J4LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN4D0
     C                   ELSE
     C                   WRITE     SCJSN4D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 5
 
     C     1             SETLL     SCJSN5PD
     C                   READ      SCJSN5PD                               41
 
     C                   MOVE      JrnSeqNo      J5LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN5D0
     C                   ELSE
     C                   WRITE     SCJSN5D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 6
 
     C     1             SETLL     SCJSN6PD
     C                   READ      SCJSN6PD                               41
 
     C                   MOVE      JrnSeqNo      J6LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN6D0
     C                   ELSE
     C                   WRITE     SCJSN6D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 7
 
     C     1             SETLL     SCJSN7PD
     C                   READ      SCJSN7PD                               41
 
     C                   MOVE      JrnSeqNo      J7LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN7D0
     C                   ELSE
     C                   WRITE     SCJSN7D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 8
 
     C     1             SETLL     SCJSN8PD
     C                   READ      SCJSN8PD                               41
 
     C                   MOVE      JrnSeqNo      J8LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN8D0
     C                   ELSE
     C                   WRITE     SCJSN8D0
     C                   ENDIF
 
      ** Update Sequence no. for Batch 9
 
     C     1             SETLL     SCJSN9PD
     C                   READ      SCJSN9PD                               41
 
     C                   MOVE      JrnSeqNo      J9LSEQ
     C                   IF        *IN41 = *OFF
     C                   UPDATE    SCJSN9D0
     C                   ELSE
     C                   WRITE     SCJSN9D0
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    JrnSeqNo
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
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
**  CPY@
(c) Finastra International Limited 2001
