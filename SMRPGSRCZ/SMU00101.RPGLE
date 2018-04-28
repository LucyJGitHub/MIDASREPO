     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update ICRF of Spread Changes on HISTSHQ')    *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00101 - Datapatch utility to correct the IRCF field       *
      *             (Interest Rate Change flag) of Spread Change      *
      *             records on PF/HISTSHQ.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 209840  *CREATE    Date 13Jan03               *
      *                 Xnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program S209840R01.                        *
      *  209840  - Utility to update Interest Rate Change Flag (IRCF) *
      *            field of PF/HISTSHQ.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      ** Loan History file
     FHISTSHQ   UF   E             DISK
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    01 - End of File For HISTSHQ                               *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      /TITLE SUBROUTINE INDEX
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  *PSSR  - Database Error Subroutine                           *
      *****************************************************************
      *
      /EJECT
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      INIT
      *
     C                   READ      HISTSHQ                                01
      *
     C     *IN01         DOWEQ     '0'
      *
     C     AMTP          IFEQ      'SC'
     C     IRCF          ANDNE     'Y'
     C     RTSP          ANDNE     0
      *
     C                   MOVE      'Y'           IRCF
      *
      ** Update file
     C                   EXCEPT
      *
     C                   ENDIF
      *
     C                   READ      HISTSHQ                                01
      *
     C                   ENDDO
      *
     C                   MOVE      '1'           *INLR
      *
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      /TITLE SR/SRINIT
      *****************************************************************
      *                                                               *
      *  SRINIT - Subroutine to do Program Initialization             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls: AOBANKR0,                                             *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: INIT                                               *
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
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/ZDATE2
      ********************************************************************
     OHISTSHQF  E
     O                       IRCF
      *
      ********************************************************************
