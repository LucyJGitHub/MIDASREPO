     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UT Check source for invalid hex values')         *
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
     FCHECKSRC  UF   F  112        DISK
      *
      /EJECT
     D Counter         S              3  0
     D Hex             S              2  0
     D WorkField       S              1
     D UpdateFlag      S              1    INZ('N')
     D SSource         S            100
     D Mode            S              7    INZ('*WRITE ')
     D Program         S             10    INZ('UT000012')
     D PMember         S             10
     D PSourceFile     S             10
     D PReport         S              4
      *
     D                 DS
     D MemberDtls              1    100
     D Member                  1     10
     D SourceFile             16     35
      *
     ICHECKSRC  NS
      * Fields from the source member.
     I                                  1    6 2SRCSEQ
     I                                 13   92  SRCDAT
     I                                 13  112  SRCDTA
      *
     C     *ENTRY        PLIST
     C                   PARM                    PMember
     C                   PARM                    PSourceFile
     C                   PARM                    PReport
      *
     C                   EVAL      Member = PMember
     C                   EVAL      SourceFile = PSourceFile
      *
     C     1             SETLL     CHECKSRC
     C                   READ      CHECKSRC
      *
     C                   DOW       NOT(%EOF)
      *
     C                   EVAL      SSource = SRCDTA
     C                   EVAL      Counter = 1
      *
     C                   DO        100
     C                   EVAL      WorkField = %SUBST(SRCDTA:Counter:1)
     C                   EXSR      CheckHex
     C                   EVAL      Counter = Counter + 1
     C                   ENDDO
      *
      * If one or more invalid hex fields have been changed then update record.
     C                   IF        UpdateFlag = 'Y'
     C                   EXCEPT    CHGSRC
     C                   IF        PReport = '*YES'
     C                   EXSR      ReportChg
     C                   ENDIF
     C                   EVAL      UpdateFlag = 'N'
     C                   ENDIF
      *
     C                   READ      CHECKSRC
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
     C                   ELSE
     C                   EVAL      %SUBST(SRCDTA:Counter:1) = *blank
     C                   EVAL      UpdateFlag = 'Y'
     C                   ENDIF
      *
     C     CheckHexE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * ReportChg - Report changes using standard error report.      *
      *                                                               *
      * Called by: None                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     ReportChg     BEGSR
      *
      * Only report if there is a discernable difference.  If there is then 3
      *  lines will be reported.  The first line details the member and source
      *  while the second and third report the before and after source lines.
     C                   IF         SSource <> SRCDTA
     C                   CALL      'UP008010'
     C                   PARM                    Mode
     C                   PARM                    Program
     C                   PARM                    MemberDtls
      *
     C                   CALL      'UP008010'
     C                   PARM                    Mode
     C                   PARM                    Program
     C                   PARM                    SSource
      *
     C                   CALL      'UP008010'
     C                   PARM                    Mode
     C                   PARM                    Program
     C                   PARM                    SRCDTA
     C                   ENDIF
      *
     C     ReportChgE    ENDSR
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
      *
      /EJECT
     OCHECKSRC  E            CHGSRC
     O                       SRCDTA             112
