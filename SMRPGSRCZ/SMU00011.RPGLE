     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Migration utility for EMU LE multi-ccy')      *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00011- Migration Utility for EMU LE Multi-ccy Rollover    *
      *                                                               *
      *  Function:  This program initialise new fields of amended     *
      *             Lending Files for EMU LE Multi-ccy Rollover       *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CEU020 *CREATE     Date 13Mar98               *
      *                 Xnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CEU02001.                          *
      *  CEU020  - EMU Lending Multi-currency Rollover                *
      *                                                               *
      *****************************************************************
     FCLOANCK   UF   E             DISK
     FLOAMSDK   UF   E             DISK
     FMCLONCK   UF   E             DISK
     F                                     RENAME(CLOANCKF:MCLONCKF)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   11  - Read Indicator                                        *
      *                                                               *
      *****************************************************************
     D/EJECT
      *
      * Update ECIN Field for CLOANCK.
     C                   READ      CLOANCKF                               11
     C     *IN11         DOWEQ     '0'
     C                   MOVE      'N'           ECIN
     C                   UPDATE    CLOANCKF
     C                   READ      CLOANCKF                               11
     C                   ENDDO
      *
      * Update ECIN Field for LOAMSDK.
     C                   READ      LOAMSDKF                               11
     C     *IN11         DOWEQ     '0'
     C                   MOVE      'N'           ECIN
     C                   UPDATE    LOAMSDKF
     C                   READ      LOAMSDKF                               11
     C                   ENDDO
      *
      * Update ECIN Field for MCLONCK.
     C                   READ      MCLONCKF                               11
     C     *IN11         DOWEQ     '0'
     C                   MOVE      'N'           ECIN
     C                   UPDATE    MCLONCKF
     C                   READ      MCLONCKF                               11
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
     C                   SETON                                        U7U8LR
      *
      * Check to see that *PSSR has not already been called.
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   DUMP
     C                   ENDIF
      *
      * Exit program.
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
