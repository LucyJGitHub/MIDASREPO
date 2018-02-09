     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - General Ledger')      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000105 - Global Processing data dowload, GLJENHPD          *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL182             Date 11May17               *
      *                 MD020167           Date 23Apr13               *
      *                 CCB020A            Date 06Aug12               *
      *                 CCB023             Date 06Aug12               *
      *                 AR1042967          Date 16Oct12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG9512            Date 05Dec05               *
      *                 BUG4017            Date 24Aug04               *
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL182 - Journal Entry via the Interface File - Java Version *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  CCB020A - COB Restructure - Secondary COB Infrastructure     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring (Recompile)                           *
      *  AR1042967 - Corrective batch waiting authorisation not       *
      *              accessible from dashboard (Child:AR1042968)      *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9512 - Signal errors to calling program in U7U8.          *
      *            Make input files user open to prevent message wait *
      * BUG4017 - Recompile due to MIDASSTS                           *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FGLJENHPD  IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
     FGLCOLLLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
     FGLJENQL0  IF   E           K DISK    INFSR(*PSSR)                                    AR1042967
     F                                     USROPN                                          AR1042967
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D                 DS
     D  CountN                 1      5  0
     D  CountA                 1      5
      *
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *
      * Midas Local Data Area for database error reporting
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      * The following fields are defined in the external file:
      *                                     134 141 DBFile
      *                                     142 170 DBKey
      *                                     171 180 DBPgm
      *                                     181 1830DBase
      *                                     184 193 DBMod
      *                                     194 203 DBProc
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D @RUN            S              1
     D KBRBTNB         S              3A                                                   AR1042967
     D Value           S             50
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C/COPY GOCPYSRC,GOUPD_PARM
      *
      * Batches not accepted?
     C                   IF        Key_Desc = 'BatchesNotAccepted'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                         CCB020A
     C                   IF        MidasPhase = 'C'                                          CCB020A
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
     C                   Open      GLJENHPD
      *
     C     1             SETLL     GLJENHPD
     C                   READ      GLJENHPD                               01
     C                   OPEN      GLJENQL0                                                AR1042967
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      KBRBTNB = BRBTNB                                        AR1042967
     C     KBRBTNB       CHAIN     GLJENQL0                           02                   AR1042967
     C                   IF        *IN02 = *OFF                                            AR1042967
     C                   IF        BRBTSF = 'H' AND                                        AR1042967
     C                             HQJETP <> 'C'                                           AR1042967
     C                             OR BRBTSF = 'P'                                            CGL182
     C                             AND HQJETP <> 'C'                                          CGL182
     C                   EVAL      CountN = CountN + 1                                     AR1042967
     C                   ENDIF                                                             AR1042967
     C                   ELSE                                                              AR1042967
     C                   IF        BRBTSF = 'H'
     C                             OR BRBTSF = 'P'                                            CGL182
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   ENDIF                                                             AR1042967
     C                   READ      GLJENHPD                               01
     C                   ENDDO
      *
     C                   EVAL      Value = CountA
     C                   CLOSE     GLJENQL0                                                AR1042967
     C                   Close     GLJENHPD
      *
     C                   ENDIF
      *
     C                   ENDIF
                                                                                           AR1042967
     C                   IF        Key_Desc = 'CorectBatchNotAceptd'                       AR1042967
      *                                                                                    AR1042967
      ** If the Midas phase is not Input Cycle then set data to blank                      AR1042967
      *                                                                                    AR1042967
     C                   IF        MidasPhase <> 'A'                                       AR1042967
     C                   EVAL      Value = *BLANKS                                         AR1042967
     C                   ELSE                                                              AR1042967
                                                                                           AR1042967
     C                   EVAL      CountN = 0                                              AR1042967
     C                   OPEN      GLJENHPD                                                AR1042967
                                                                                           AR1042967
     C     1             SETLL     GLJENHPD                                                AR1042967
     C                   READ      GLJENHPD                               01               AR1042967
     C                   OPEN      GLJENQL0                                                AR1042967
                                                                                           AR1042967
     C                   DOW       *IN01 = *OFF                                            AR1042967
     C                   EVAL      KBRBTNB = BRBTNB                                        AR1042967
     C     KBRBTNB       CHAIN     GLJENQL0                           02                   AR1042967
     C                   IF        *IN02 = *OFF                                            AR1042967
     C                   IF        BRBTSF = 'H' AND                                        AR1042967
     C                             HQJETP = 'C'                                            AR1042967
     C                   EVAL      CountN = CountN + 1                                     AR1042967
     C                   ENDIF                                                             AR1042967
     C                   ENDIF                                                             AR1042967
                                                                                           AR1042967
     C                   READ      GLJENHPD                               01               AR1042967
     C                   ENDDO                                                             AR1042967
                                                                                           AR1042967
     C                   EVAL      Value = CountA                                          AR1042967
     C                   CLOSE     GLJENQL0                                                AR1042967
     C                   CLOSE     GLJENHPD                                                AR1042967
                                                                                           AR1042967
     C                   ENDIF                                                             AR1042967
                                                                                           AR1042967
     C                   ENDIF                                                             AR1042967
                                                                                           AR1042967
      *
      * Unauthorised Collateral Details
     C                   IF        Key_Desc = 'UnauthCollateralDtls'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                         CCB020A
     C                   IF        MidasPhase = 'C'                                          CCB020A
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
     C                   Open      GLCOLLLA
      *
     C     *LOVAL        SETLL     GLCOLLLA
     C                   READ      GLCOLLLA                               01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      GLCOLLLA                               01
     C                   ENDDO
      *
     C                   EVAL      Value = CountA
     C                   Close     GLCOLLLA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C/COPY GOCPYSRC,GOUPD_DWNL
      *
     C     ENDPGM        TAG
     C                   SETON                                        LR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INLR = *ON
     C                   SetOn                                        U7U8                   BUG9512
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
