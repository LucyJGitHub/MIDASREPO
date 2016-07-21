     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************            CCB023 AR1089839
      ***RPGSQLBND*****************************************************            CCB023 AR1089839
/*STD *  RPGSQLBND                                                    *                   AR1089839
/*EXI *  TEXT('Midas GO Download data control - Securities')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000112 - Global Processing data dowload, Securities        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. MD039545           Date 20Jul16               *
      *  Prev Amend No. MD020167           Date 23Apr13               *
      *                 AR1092057          Date 28Feb13               *
      *                 AR1089839          Date 20Feb13               *
      *                 CCB023             Date 06Aug12               *
      *                 AR1040629          Date 16Oct12               *
      *                 AR701114 *CREATE   Date 27Jan11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039545 - MIDASSTS - Decimal Data Error                     *
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  AR1092057 - GO000112 Error encountered before starting GN EN *
      *              zone COB                                         *
      *  AR1089839 - COBOP and 2.1 source clashes                     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *  AR1040629 - SE Trades are not in Dashboard (Child:AR1043033) *
      *  AR701114 - Apply fix 263135 (Child: AR701115)                *
      *  263135 - SE Details and Trades are not in Dashboard          *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     F***GPSEWIPL  IF   E           K DISK    INFSR(*PSSR)                                    CCB023
     F**********                           USROPN                                             CCB023
     FGPDPMVL0  IF   E           K DISK    INFSR(*PSSR)                                    AR1040629
     F                                     PREFIX(D)                                       AR1040629
     F                                     USROPN                                          AR1040629
     FGPZONEL2  IF   E           K DISK    INFSR(*PSSR)
     FGPDWNLL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
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
     D Zone            S             10                                                       CCB023
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
      /COPY GOCPYSRC,GOUPD_PARM
      *
      ** Get Zone Name from system ID.
      *
     C     System_ID     CHAIN     GPZONED0                           90
     C                   EVAL      Zone = ZOZONE                                              CCB023
      *****************************************************************                       CCB023
      ***Unauthorised*Securities*Trade*********************************                       CCB023
      *****************************************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthSETrades'                                CCB023
      *
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.*                       CCB023
      *
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      GPSEWIPL                                                   CCB023
     C******LOVAL        SETLL     GPSEWIPL                                                   CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = ZOZONE AND                                       CCB023
     C**********                   MSWAPI = 'TRAD                          '                  CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
     C**********         ENDDO                                                                CCB023
     C**********         CLOSE     GPSEWIPL                                                   CCB023
      *
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *****************************************************************                       CCB023
      ***Unauthorised*Securities*Details*******************************                       CCB023
      *****************************************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthSEDetails'                               CCB023
      *
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.*                       CCB023
      *
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      GPSEWIPL                                                   CCB023
     C******LOVAL        SETLL     GPSEWIPL                                                   CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = ZOZONE AND                                       CCB023
     C**********                   MSWAPI = 'SECS                          '                  CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
     C**********         ENDDO                                                                CCB023
     C**********         CLOSE     GPSEWIPL                                                   CCB023
      *
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *****************************************************************                       CCB023
      ***Unauthorised*Depot*Movement***********************************                       CCB023
      *****************************************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthDepotMovement'                           CCB023
      *
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.*                       CCB023
      *
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      GPSEWIPL                                                AR1040629
     C******LOVAL        SETLL     GPSEWIPL                                                AR1040629
     C**********         READ      GPSEWIPL                               01               AR1040629
     C                   EVAL      CountN = 0                                               MD039545
     C                   OPEN      GPDPMVL0                                                AR1040629
     C     *LOVAL        SETLL     GPDPMVL0                                                AR1040629
     C                   READ      GPDPMVL0                               01               AR1040629
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C                   DOW       *IN01 = *OFF                                            AR1089839
     C**********         IF        MSWZONE = ZOZONE AND                                    AR1040629
     C**********                   MSWAPI = 'DPMV                          ' AND           AR1040629
     C**********                   MSWNAVP = 'INPDPMVRP                     '              AR1040629
     C                   IF        DMSWZONE= ZOZONE AND                                    AR1040629
     C                             DMSWAPI= 'DPMV                          ' AND           AR1040629
     C                             DMSWNAVP= 'INPDPMVRP                     '              AR1040629
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C**********         READ      GPSEWIPL                               01               AR1040629
     C                   READ      GPDPMVL0                               01               AR1040629
     C                   ENDDO
     C**********         READ      GPSEWIPL                               01               AR1040629
     C**********         READ      GPDPMVL0                               01     AR1040629 AR1092057
     C                   CLOSE     GPDPMVL0                                                AR1092057
      *
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *****************************************************************                       CCB023
      ***Unauthorised*Repurchase*Agreement*****************************                       CCB023
      *****************************************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthRepo'                                    CCB023
      *
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.*                       CCB023
      *
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      GPSEWIPL                                                   CCB023
     C******LOVAL        SETLL     GPSEWIPL                                                   CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = ZOZONE AND                                       CCB023
     C**********                   MSWAPI = 'REPO                          '                  CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
     C**********         ENDDO                                                                CCB023
     C**********         CLOSE     GPSEWIPL                                                   CCB023
      *
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *****************************************************************                       CCB023
      ***Unauthorised*Buy/Sell*Back************************************                       CCB023
      *****************************************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthBuySell'                                 CCB023
      *
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.*                       CCB023
      *
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      GPSEWIPL                                                   CCB023
     C******LOVAL        SETLL     GPSEWIPL                                                   CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = ZOZONE AND                                       CCB023
     C**********                   MSWAPI = 'BUYSELL                       '                  CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
     C**********         ENDDO                                                                CCB023
     C**********         CLOSE     GPSEWIPL                                                   CCB023
      *
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      ** Unauthorised Depot Walk-In
      *
     C                   IF        Key_Desc = 'UnauthDepotWalkIn'
      *
      ** If the Midas phase is not Input Cycle then set data to blank.
      *
     C                   IF        MidasPhase <> 'A'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C**********         OPEN      GPSEWIPL                                                AR1040629
     C******LOVAL        SETLL     GPSEWIPL                                                AR1040629
     C**********         READ      GPSEWIPL                               01               AR1040629
     C                   OPEN      GPDPMVL0                                                AR1040629
     C     *LOVAL        SETLL     GPDPMVL0                                                AR1040629
     C                   READ      GPDPMVL0                               01               AR1040629
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C                   DOW       *IN01 = *OFF                                            AR1089839
     C**********         IF        MSWZONE = ZOZONE AND                                    AR1040629
     C**********                   MSWAPI = 'DPMV                          ' AND           AR1040629
     C**********                   MSWNAVP = 'INPDPMVWI                     '              AR1040629
     C                   IF        DMSWZONE= ZOZONE AND                                    AR1040629
     C                             DMSWAPI= 'DPMV                          ' AND           AR1040629
     C                             DMSWNAVP= 'INPDPMVWI                     '              AR1040629
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C**********         READ      GPSEWIPL                               01               AR1040629
     C                   READ      GPDPMVL0                               01               AR1040629
     C                   ENDDO
     C**********         CLOSE     GPSEWIPL                                                AR1040629
     C                   CLOSE     GPDPMVL0                                                AR1040629
      *
     C/EXEC SQL                                                                               CCB023
     C+  select count(*) into :COUNTN from T_MSWIP where                                      CCB023
     C+  MSWZONE = :Zone and MSWAPI = 'DPMV' and MSWNAVP = 'INPDPMVWI'                        CCB023
     C+  and MSWSTAT not in ('AUTHORISED', 'REJECTED',                                        CCB023
     C+  'NOT_APPROVED', 'INCOMPLETE')                                                        CCB023
     C/END-EXEC                                                                               CCB023
                                                                                              CCB023
      ** Check for successful completion                                                      CCB023
                                                                                              CCB023
     C                   IF        SQLCOD <> 0                                                CCB023
     C                   EXSR      *PSSR                                                      CCB023
     C                   ENDIF                                                                CCB023
                                                                                              CCB023
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Unauthorised Depot Walk-Out
      *
     C                   IF        Key_Desc = 'UnauthDepotWalkOut'
      *
      ** If the Midas phase is not Input Cycle then set data to blank.
      *
     C                   IF        MidasPhase <> 'A'
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C**********         OPEN      GPSEWIPL                                                AR1040629
     C******LOVAL        SETLL     GPSEWIPL                                                AR1040629
     C**********         READ      GPSEWIPL                               01               AR1040629
     C                   OPEN      GPDPMVL0                                                AR1040629
     C     *LOVAL        SETLL     GPDPMVL0                                                AR1040629
     C                   READ      GPDPMVL0                               01               AR1040629
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C                   DOW       *IN01 = *OFF                                            AR1089839
     C**********         IF        MSWZONE = ZOZONE AND                                    AR1040629
     C**********                   MSWAPI = 'DPMV                          ' AND           AR1040629
     C**********                   MSWNAVP = 'INPDPMVWO                     '              AR1040629
     C                   IF        DMSWZONE= ZOZONE AND                                    AR1040629
     C                             DMSWAPI= 'DPMV                          ' AND           AR1040629
     C                             DMSWNAVP= 'INPDPMVWO                     '              AR1040629
     C                   EVAL      CountN = CountN + 1
     C                   ENDIF
     C**********         READ      GPSEWIPL                               01               AR1040629
     C                   READ      GPDPMVL0                               01               AR1040629
     C                   ENDDO
     C**********         CLOSE     GPSEWIPL                                                AR1040629
     C                   CLOSE     GPDPMVL0                                                AR1040629
      *
     C/EXEC SQL                                                                               CCB023
     C+  select count(*) into :COUNTN from T_MSWIP where                                      CCB023
     C+  MSWZONE = :Zone and MSWAPI = 'DPMV' and MSWNAVP = 'INPDPMVWO'                        CCB023
     C+  and MSWSTAT not in ('AUTHORISED', 'REJECTED',                                        CCB023
     C+  'NOT_APPROVED', 'INCOMPLETE')                                                        CCB023
     C/END-EXEC                                                                               CCB023
                                                                                              CCB023
      ** Check for successful completion                                                      CCB023
                                                                                              CCB023
     C                   IF        SQLCOD <> 0                                                CCB023
     C                   EXSR      *PSSR                                                      CCB023
     C                   ENDIF                                                                CCB023
                                                                                              CCB023
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *****************************************************************                       CCB023
      ***Unauthorised*Security*Prices**********************************                       CCB023
      *****************************************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthSEPrices'                                CCB023
      *
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.*                       CCB023
      *
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      GPSEWIPL                                                   CCB023
     C******LOVAL        SETLL     GPSEWIPL                                                   CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = ZOZONE AND                                       CCB023
     C**********                   MSWAPI = 'PRCS                          '                  CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      GPSEWIPL                               01                  CCB023
     C**********         ENDDO                                                                CCB023
     C**********         CLOSE     GPSEWIPL                                                   CCB023
      *
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
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
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
