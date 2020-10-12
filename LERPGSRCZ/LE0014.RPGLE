     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Reset CLE003 fields in HISTSHM')              *
      *****************************************************************
      *                                                               *
      *  Midas -  Customer Lending Module                             *
      *                                                               *
      *  LE0014 - Reset CLE003 fields in LE History File HISTSHM      *
      *                                                               *
      *  Function: This program initialises the HISTSHM fields CPAM   *
      *            and INTR to zero                                   *
      *                                                               *
      *  Called By: LEC0014                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 208836  *CREATE    Date 17Sep02               *
      *                 Xnnnnn             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  208836 - Fields CPAM and INTR in HISTSHM are being updated   *
      *           even when feature CLE003 is disabled.               *
      *                                                               *
      *****************************************************************
      *
     FHISTSHM   UF   E             DISK
      *
     C                   READ      HISTSHMF
      *
     C                   DOW       %EOF = '0'
     C                   EVAL      CPAM = 0
     C                   EVAL      INTR = 0
     C                   EXCEPT    UPDHM
     C                   READ      HISTSHMF
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
      *
     OHISTSHMF  E            UPDHM
     O                       CPAM
     O                       INTR
