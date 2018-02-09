     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Compare members after RMVSRCHEX')             *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities module                                     *
      *                                                               *
      *  UT000012 - Remove invalid hex values from source.            *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CUT015  *CREATE    Date 10May07               *
      *                 XXXXXX             Date DDMmmYY               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CUT015 - New utility.  Part of take on of ClearCase.         *
      *                                                               *
      *****************************************************************
      *
     FSRCO      IF   F  112        DISK
     FSRCN      IF   F  112        DISK
      *
      /EJECT
     D PMember         S             10
     D PSourceFile     S             10
     D Counter         S              3  0 INZ(1)
     D Hex             S              2  0
     D WorkField       S              1
     D EFlag           S              1    INZ('N')
     D ErrorMsg        S            100
     D Write           S              7    INZ('*WRITE ')
     D Program         S             10    INZ('UT000014')
      *
     D                 DS
     D  SrcSeq                 1      6  2
     D  SrcSeqA                1      6
     ISRCO      NS
      * Fields from the source member.
     I                                  1    6 2OSRCSEQ
     I                                 13   92  OSRCDAT
     I                                 13  112  OSRCDTA
     ISRCN      NS
      * Fields from the source member.
     I                                  1    6 2NSRCSEQ
     I                                 13   92  NSRCDAT
     I                                 13  112  NSRCDTA
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMember
     C                   PARM                    PSourceFile
      *
     C     1             SETLL     SRCO
     C     1             SETLL     SRCN
     C                   READ      SRCO
      *
     C                   DOW       NOT(%EOF)
      *
     C                   READ      SRCN
     C                   IF        OSRCDTA <> NSRCDTA
     C                   DOU       Counter = 100 or
     C                             EFlag = 'Y'
     C                   IF        %SUBST(OSRCDTA:Counter:1) <>
     C                             %SUBST(NSRCDTA:Counter:1)
     C                   IF        %SUBST(NSRCDTA:Counter:1) <> *blank
     C                   EVAL      SrcSeq = NSRCSEQ
     C                   EVAL      ErrorMsg = SrcSeqA + ' New' + ' ' + PMember +
     C                             PSourceFile + ' in error'
     C                   EXSR      WriteReport
     C                   ENDIF
      * Check old version.
     C                   EVAL      WorkField = %SUBST(OSRCDTA:Counter:1)
     C                   EXSR      CheckHex
     C                   ENDIF
     C                   EVAL      Counter = Counter + 1
     C                   ENDDO
      *
     C                   EVAL      Counter = 1
     C                   EVAL      EFlag = 'N'
     C                   ENDIF
     C                   READ      SRCO
     C                   ENDDO
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * CheckHex - Check position for invalid hex value.              *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     CheckHex      BEGSR
      *
      * Test the bits of the character. Only check the first part as anything with a
      *  hex value of greater the 'X'40 is allowed.
     C                   TESTB     '0'           WorkField                08
     C                   TESTB     '1'           WorkField                04
     C                   TESTB     '2'           WorkField                02
     C                   TESTB     '3'           WorkField                01
      * Work out first part of hex representation.
     C                   EVAL      Hex = 0
     C                   IF        *IN08 = *ON
     C                   EVAL      Hex = Hex + 8
     C                   ENDIF
     C                   IF        *IN04 = *ON
     C                   EVAL      Hex = Hex + 4
     C                   ENDIF
     C                   IF        *IN02 = *ON
     C                   EVAL      Hex = Hex + 2
     C                   ENDIF
     C                   IF        *IN01 = *ON
     C                   EVAL      Hex = Hex + 1
     C                   ENDIF
      *
     C                   IF        Hex >= 4
     C                   EVAL      SrcSeq = NSRCSEQ
     C                   EVAL      ErrorMsg = SrcSeqA + ' Old' + ' ' + PMember +
     C                             PSourceFile + ' in error'
     C                   EXSR      WriteReport
     C                   ENDIF
      *
     C     CheckHexE     ENDSR
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
     C                   EVAL      EFlag = 'Y'
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
