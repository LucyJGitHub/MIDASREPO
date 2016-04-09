     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update GLAVBLPD - blank assoc cust if 0s')    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00230 - Blank zeros in Assoicated Customer                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *   Last Amend No. CUP039  *CREATE       Date 16Mar11           *
      *   Prev Amend No. xxxxxx                Date ddMmmyy           *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUP039 - Set Associated Customer to blank if 000000.         *
      *                                                               *
      *****************************************************************
     FGLAVBLPD  UF   E             DISK
      *
     C     1             SETLL     GLAVBLD0
     C     *IN01         DOWEQ     '0'
     C                   READ      GLAVBLD0                               01
     C     *IN01         IFEQ      '0'
      *
      * If associated customer number field contains zeros ...
     C     ABACNB        IFEQ      '000000'
      * ...  blank the field and update the record.
     C                   MOVE      '      '      ABACNB
     C                   UPDATE    GLAVBLD0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   SETON                                        LR
     C                   RETURN
