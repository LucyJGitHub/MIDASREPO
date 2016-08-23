     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*XBIA*  OVRDBF FILE(UTC131) TOFILE(UPMBRLTPD)                        *
/*XBIB*  OVRDBF FILE(UTC132) TOFILE(UPMBRLTPD)                        *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Check list of members for CHKSRCHEX')         *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT000013 - Check list of members for CHKSRCHEX.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CUT015  *CREATE    Date 15Sep09               *
      *  Prev Amend No. xxxxxx             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CUT015 - New utility.                                        *
      *                                                               *
      *****************************************************************
      *
     FUTC131    IF   E             DISK
     FUTC132    IF   E           K DISK    RENAME(QWHFDML:MBRLIST)
     F                                     PREFIX(X)
      *
      /EJECT
     D PMode           S              1
     D PLibrary        S             10
     D SrcFile         S             10
     D SrcMbr          S             10
     D Write           S              7    INZ('*WRITE ')
     D Program         S             10    INZ('UT000013')
     D ErrorMsg        S            100
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PLibrary
      *
     C     KMember       KLIST
     C                   KFLD                    SrcFile
     C                   KFLD                    SrcMbr
      *
     C     1             SETLL     UTC131
     C                   READ      UTC131
      *
     C                   DOW       NOT(%EOF)
      *
      * See if record exists on second file. */
     C                   EVAL      SrcFile = MLFILE
     C                   EVAL      SrcMbr  = MLNAME
      * If not found then report ...
     C     KMember       CHAIN     UTC132
     C                   IF        NOT(%FOUND)
     C                   EVAL      ErrorMsg = 'Member ' + MLFILE + '/' +
     C                             MLNAME + 'not found in ' + PLibrary
     C                   EXSR      WriteReport
      * ... else check that number of records match but only the first time
      *     program is called.
     C                   ELSE
     C                   IF        PMode = 'O'
     C                   IF        MLNRCD <> XMLNRCD
     C                   EVAL      ErrorMsg = 'Members ' + MLFILE + '/' +
     C                             MLNAME + ' have different number of records'
     C                   EXSR      WriteReport
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      UTC131
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * WriteReport - Write line for UP008010P1                       *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     WriteReport   BEGSR
      *
     C                   CALL      'UP008010'
     C                   PARM                    Write
     C                   PARM                    Program
     C                   PARM                    ErrorMsg
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
      *
     C     WriteReportE  ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
