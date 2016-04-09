     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                       CCB023
/*STD *  RPGBASEBND                                                   *                     MD024491
/*EXI *  TEXT('Midas GO Download data control - Funds Transfer')      *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000110 - Global Processing data dowload, Funds Transfer    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CAP212             Date 15Sep14               *
      *  Prev Amend No. MD024491*REINSTATE Date 03Feb14               *
      *                 CCB023  *REDUNDANT Date 06Aug12               *
      *                 AR701209           Date 28Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 BUG9512            Date 05Dec05               *
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP212 - FT Nostro Transfer API (Recompile)                  *
      *  MD022491 - Outgoing payment not authorized are not shown in  *
      *             the BFM Dashboard                                 *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *  AR701209 - Unauthorize FT WIP not in Midas dashboard         *
      *             (Child: AR701210)                                 *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG9512 - Signal errors to calling program in U7U8.          *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     FNOTPYBB   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FNINPYBB   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FNNTRNBB   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FCQCODDD   IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     FCQPACDD   IF   E             DISK    INFSR(*PSSR)
     F                                     USROPN
     FFT101HLA  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FFT102HL9  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     PREFIX(X)
     F***GPFTWIPF  IF   E           K DISK    INFSR(*PSSR)                         AR701209 MD022491
     F**********                              USROPN                               AR701209 MD022491
     F***GPZONEL2  IF   E           K DISK    INFSR(*PSSR)                         AR701209 MD022491
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                            BUG9512
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
      **********                                                                   AR701209 MD022491
      ***Get*Zone*Name*from*system*ID**********************************            AR701209 MD022491
      **********                                                                   AR701209 MD022491
     C*****System_ID     CHAIN     GPZONED0                           90           AR701209 MD022491
      *
      * Unauthorised Outgoing Payments
     C                   IF        Key_Desc = 'UnauthOutPayments'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      NOTPYBB
     C     *LOVAL        SETLL     NOTPYBB
     C                   READ      NOTPYBB                                01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      NOTPYBB                                01
     C                   ENDDO
      *
     C                   CLOSE     NOTPYBB
      **********                                                                   AR701209 MD024491
     C**********         OPEN      GPFTWIPF                                        AR701209 MD024491
     C******LOVAL        SETLL     GPFTWIPF                                        AR701209 MD024491
     C**********         READ      GPFTWIPF                               01       AR701209 MD024491
      **********                                                                   AR701209 MD024491
     C**********         DOW       *IN01 = *OFF                                    AR701209 MD024491
     C**********         IF        MSWZONE = ZOZONE AND                            AR701209 MD024491
     C**********                   MSWAPI = 'OPAY                          '       AR701209 MD024491
     C**********         EVAL      CountN = CountN + 1                             AR701209 MD024491
     C**********         ENDIF                                                     AR701209 MD024491
     C**********         READ      GPFTWIPF                               01       AR701209 MD024491
     C**********         ENDDO                                                     AR701209 MD024491
     C**********         CLOSE     GPFTWIPF                                        AR701209 MD024491
      **********                                                                   AR701209 MD024491
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Unauthorised Incoming Payments
     C                   IF        Key_Desc = 'UnauthInPayments'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      NINPYBB
     C     *LOVAL        SETLL     NINPYBB
     C                   READ      NINPYBB                                01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      NINPYBB                                01
     C                   ENDDO
      *
     C                   CLOSE     NINPYBB
      **********                                                                   AR701209 MD024491
     C**********         OPEN      GPFTWIPF                                        AR701209 MD024491
     C******LOVAL        SETLL     GPFTWIPF                                        AR701209 MD024491
     C**********         READ      GPFTWIPF                               01       AR701209 MD024491
      **********                                                                   AR701209 MD024491
     C**********         DOW       *IN01 = *OFF                                    AR701209 MD024491
     C**********         IF        MSWZONE = ZOZONE AND                            AR701209 MD024491
     C**********                   MSWAPI = 'IPAY                          '       AR701209 MD024491
     C**********         EVAL      CountN = CountN + 1                             AR701209 MD024491
     C**********         ENDIF                                                     AR701209 MD024491
     C**********         READ      GPFTWIPF                               01       AR701209 MD024491
     C**********         ENDDO                                                     AR701209 MD024491
     C**********         CLOSE     GPFTWIPF                                        AR701209 MD024491
      **********                                                                   AR701209 MD024491
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Unauthorised Nostro Transfers
     C                   IF        Key_Desc = 'UnauthNostroTfrs'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      NNTRNBB
     C     *LOVAL        SETLL     NNTRNBB
     C                   READ      NNTRNBB                                01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      NNTRNBB                                01
     C                   ENDDO
      *
     C                   CLOSE     NNTRNBB
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Unauthorised Cheques for Collection
     C                   IF        Key_Desc = 'UnauthChqsForColl'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      CQCODDD
     C     1             SETLL     CQCODDD
     C                   READ      CQCODDD                                01
      *
     C                   DOW       *IN01 = *OFF
     C                   IF        RECI = 'D' and
     C                             AUIN <> 'Y'
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   READ      CQCODDD                                01
     C                   ENDDO
      *
     C                   CLOSE     CQCODDD
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Unauthorised Cheques to be Paid
     C                   IF        Key_Desc = 'UnauthChqsToBePaid'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      CQPACDD
     C     1             SETLL     CQPACDD
     C                   READ      CQPACDD                                01
      *
     C                   DOW       *IN01 = *OFF
     C                   IF        RECI = 'D' and
     C                             AUIN <> 'Y'
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   READ      CQPACDD                                01
     C                   ENDDO
      *
     C                   CLOSE     CQPACDD
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Unauthorised Requests For Transfer
     C                   IF        Key_Desc = 'UnauthRFTs'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      FT101HLA
     C     *LOVAL        SETLL     FT101HLA
     C                   READ      FT101HLA                               01
      *
     C                   DOW       *IN01 = *OFF
     C                   IF        AUIN = *blanks
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   READ      FT101HLA                               01
     C                   ENDDO
      *
     C                   CLOSE     FT101HLA
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Unauthorised Customer Credit Transfers
     C                   IF        Key_Desc = 'UnauthCCTs'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                        MD024491
     C                   IF        MidasPhase = 'C'                                         MD024491
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      FT102HL9
     C     *LOVAL        SETLL     FT102HL9
     C                   READ      FT102HL9                               01
      *
     C                   DOW       *IN01 = *OFF
     C                   IF        XAUIN = *blanks
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C                   READ      FT102HL9                               01
     C                   ENDDO
      *
     C                   CLOSE     FT102HL9
     C                   EVAL      Value = CountA
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
