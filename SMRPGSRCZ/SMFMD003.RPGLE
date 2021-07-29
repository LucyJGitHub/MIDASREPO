     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update Account & Reporting Codes FMD003')     *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation Module                                *
      *                                                               *
      *  SMFMD003 - Update Account and Reporting codes on MCAVBLX0    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. EML108             Date 24Jan20               *
      *  Prev Amend No. UMD001  *CREATE    Date 12Jan09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML108 - Upgrade FMD003 to FB2.1SP21 (Recompile)             *
      *  UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19             *
      *           Convert Account and Reporting codes                 *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FMCAVBLX0  UF   E             DISK    INFSR(*PSSR)
      ** MC Daily balances and movements file
      *
     FMCWORKX0  UF   E             DISK    INFSR(*PSSR)
      ** MC Daily balances and movements work file
      *
     FSMAC10PD  IF   E           K DISK
      * Account code cross-reference file.
      *
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Program Parameters
     D PRtCd           S              7A
      *
      ** Working Variables
     D WRK4            S              4A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Read MCAVBLX0 file.
      *
     C     *IN01         DOWEQ     *OFF
      *
     C                   READ      MCAVBLX0                               01
      *
     C     *IN01         IFEQ      *OFF
      *
      *  Move 4-digit code into work field WRK4.
      *
     C                   MOVEL     M1RSCD        WRK4              4
     C                   MOVE      *BLANKS       M1RSCD
      *
      *  If reporting code is '****',
      *
     C     WRK4          IFEQ      '****'
      *
      *  Move asterisks into the first 6 positions.
      *
     C                   MOVEL     '******'      M1RSCD
      *
      *  If reporting code is not asterisks,
      *
     C                   ELSE
      *
      *  Move leading zeros into the first 6 positions.
      *
     C                   MOVEL     '000000'      M1RSCD
      *
     C                   ENDIF
      *
      *  Move the reporting code into the right 4 postions.
      *
     C                   MOVE      WRK4          M1RSCD

      *
      *  Move input account code to numeric field.
      *
     C                   MOVEL     M1ACOD        AC4N              4 0
      *
     C     AC4N          CHAIN     SMAC10PD
     C                   IF        %FOUND
      *
      *  Return 10-digit account code.
      *
     C                   MOVE      ACOD10        M1ACOD
     C                   ENDIF
      *
      *  Update the record.
      *
     C                   UPDATE    MCAVBLD0
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Read MCWORKX0 file.
      *
     C     *IN02         DOWEQ     *OFF
      *
     C                   READ      MCWORKX0                               02
      *
     C     *IN02         IFEQ      *OFF
      *
      *  Move 4-digit code into work field WRK4.
      *
     C                   MOVEL     M1RSCD        WRK4              4
     C                   MOVE      *BLANKS       M1RSCD
      *
      *  If reporting code is '****',
      *
     C     WRK4          IFEQ      '****'
      *
      *  Move asterisks into the first 6 positions.
      *
     C                   MOVEL     '******'      M1RSCD
      *
      *  If reporting code is not asterisks,
      *
     C                   ELSE
      *
      *  Move leading zeros into the first 6 positions.
      *
     C                   MOVEL     '000000'      M1RSCD
      *
     C                   ENDIF
      *
      *  Move the reporting code into the right 4 postions.
      *
     C                   MOVE      WRK4          M1RSCD

      *
      *  Move input account code to numeric field.
      *
     C                   MOVEL     M1ACOD        AC4N              4 0
      *
     C     AC4N          CHAIN     SMAC10PD
     C                   IF        %FOUND
      *
      *  Return 10-digit account code.
      *
     C                   MOVE      ACOD10        M1ACOD
     C                   ENDIF
      *
      *  Update the record.
      *
     C                   UPDATE    MCWORKD0
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
      *
     C                   EVAL      PRtCd = '       '
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Subroutine                         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      PRtCd = '*ERROR '
      *
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
