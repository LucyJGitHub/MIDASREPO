     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update GLHIBLPD - blank assoc cust if 0s')    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00231 - Blank zeros in Assoicated Customer                *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUP039  *CREATE    Date 16Mar11               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUP039 - Set Associated Customer to blank if 000000.         *
      *                                                               *
      *****************************************************************
     FGLHIBLPD  UF   E             DISK
      *
     C     1             SETLL     GLHIBLD0
     C     *IN01         DOWEQ     '0'
     C                   READ      GLHIBLD0                               01
     C     *IN01         IFEQ      '0'
      *
      * If associated customer number field contains zeros ...
     C     HBACNB        IFEQ      '000000'
      * ...  blank the field and update the record.
     C                   MOVE      '      '      HBACNB
     C                   UPDATE    GLHIBLD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
