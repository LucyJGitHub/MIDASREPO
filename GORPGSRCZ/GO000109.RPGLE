     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GO Download data control - Lending')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing                                    *
      *                                                               *
      *  GO000109 - Global Processing data dowload, Lending           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD020167           Date 23Apr13               *
      *  Prev Amend No. AR1089839          Date 19Feb13               *
      *                 CCB020A            Date 06Aug12               *
      *                 CCB023             Date 06Aug12               *
      *                 AR318462           Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260346             Date 21May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 248277             Date 13Jun07               *
      *                 247572             Date 31May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9512            Date 05Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CGP002  *CREATE    Date 02Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *  MD020167 - New fields DCUATH not available in LFs (Recompile)*
      *  AR1089839 - COBOP and 2.1 source clashes                     *
      *  CCB020A - COB Restructure - Secondary COB Infrastructure     *
      *  CCB023 - COB Restructure - Input Cycle Termination           *
      *           Restructuring                                       *
      *  AR318462 - Unauthorised PDCLs do not prevent COB start       *
      *             Include PDCLs in the dashboard calculations       *
      *             (Child: AR318463)                                 *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  260346 - Reversed reference to MSWTREF and correct count of  *
      *           unauthorised records for transaction not yet on main*
      *           file. Unauthorised loans, sold and purchased will   *
      *           all be reported under unauthorised loans.           *
      *  248277 - Fix 247572 be applied to all lending events.        *
      *  247572 - Use T_MSWIP in RPSC computation.                    *
      *  BUG9512 - Signal errors to calling program in U7U8.          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CGP002 - Global Processing data download                     *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ Files                                ¦
      ** ¦ =====                                ¦
      ** +--------------------------------------+
      *
     F*LELOANL1  IF   E           K DISK    INFSR(*PSSR)                                      248277
     F*                                     USROPN                                            248277
     F*LELOANL0**IF***E***********K*DISK*** INFSR(*PSSR)                               248277 260346
     F**********                           USROPN                                      248277 260346
     F*LELOAML1  IF   E           K DISK    INFSR(*PSSR)                                      248277
     F*                                     USROPN                                            248277
     F***LELOANL3**IF   E           K DISK    INFSR(*PSSR)                                    CCB023
     F**********                           USROPN                                             CCB023
     FLEGTEEL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*LEFEESL1  IF   E           K DISK    INFSR(*PSSR)                                      248277
     F*                                     USROPN                                            248277
     F*LEFEEAL3  IF   E           K DISK    INFSR(*PSSR)                                      248277
     F*                                     USROPN                                            248277
     F*LEFCLTL1  IF   E           K DISK    INFSR(*PSSR)                                      248277
     F*                                     USROPN                                            248277
     F*LEFCAML2  IF   E           K DISK    INFSR(*PSSR)                                      248277
     F*                                     USROPN                                            248277
     FLEMNFUL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F*GPRSWIPL  IF   E           K DISK    INFSR(*PSSR)                               248277 247572
     F*                                     USROPN                                     248277 247572
     F***GPLEWIPL**IF   E           K DISK    INFSR(*PSSR)                             248277 CCB023
     F**********                           USROPN                                      248277 CCB023
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
     D Loana           S              6                                                       248277
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
      * Get Zone                                                                              248277
     C                   EXSR      SRGPGZ                                                     248277
      *
      **Unauthorised*Loans*********************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthLoans'                                   CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LELOANL1                                                   248277
     C******LOVAL        SETLL     LELOANL1                                                   248277
     C**********         READ      LELOANL1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         OPEN      LELOANL0                                            248277 260346
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   MSWAPI = 'CLIP                          '           248277 260346
     C**********                   MSWAPI = 'CLIP'                                     260346 CCB023
     C**********         EVAL      LOANA = %SUBST(MSWTREF:1:6)                         248277 260346
     C**********         MOVE      LOANA         PLOAN             6 0                 248277 260346
     C*****PLOAN         CHAIN     LELOANL0                           90               248277 260346
     C**********         IF        *IN90 = '0'                                         248277 260346
     C**********         IF        PTYP = 61 or                                               260346
     C**********                   PTYP = 62 or                                               260346
     C**********                   PTYP = 63 or                                               260346
     C**********                   PTYP = 70                                                  260346
     C**********         EVAL      CountN = CountN + 1                                        260346
     C**********         ENDIF                                                                260346
     C**********         ENDIF                                                         248277 260346
     C**********         EVAL      CountN = CountN + 1                                 260346 CCB023
     C**********         ENDIF                                                         248277 CCB023
     C**********         READ      LELOANL1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LELOANL1                                                   248277
     C**********         CLOSE     LELOANL0                                            248277 260346
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *                                                                                     AR318462
      ***Unauthorised*PDCLs*******************************************            AR318462 AR1089839
      *                                                                                     AR318462
     C**********         IF        Key_Desc = 'UnauthPDCL '                       AR318462 AR1089839
      *                                                                                     AR318462
      ***If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank             AR318462 AR1089839
      *                                                                                     AR318462
     C**********         IF        MidasPhase <> 'A'                              AR318462 AR1089839
     C**********         EVAL      VALUE = *BLANKS                                AR318462 AR1089839
     C**********         ELSE                                                     AR318462 AR1089839
      *                                                                                     AR318462
     C**********         EVAL      CountN = 0                                     AR318462 AR1089839
      *                                                                                     AR318462
     C**********         OPEN      GPLEWIPL                                       AR318462 AR1089839
     C******LOVAL        SETLL     GPLEWIPL                                       AR318462 AR1089839
     C**********         READ      GPLEWIPL                               01      AR318462 AR1089839
                                                                                            AR318462
     C**********         DOW       *IN01 = *OFF                                   AR318462 AR1089839
     C**********         IF        MSWZONE = PZZONE AND                           AR318462 AR1089839
     C**********                   MSWAPI = 'PDCL'                                AR318462 AR1089839
     C**********         EVAL      CountN = CountN + 1                            AR318462 AR1089839
     C**********         ENDIF                                                    AR318462 AR1089839
     C**********         READ      GPLEWIPL                               01      AR318462 AR1089839
     C**********         ENDDO                                                    AR318462 AR1089839
      *                                                                                     AR318462
     C**********         CLOSE     GPLEWIPL                                       AR318462 AR1089839
     C**********         EVAL      VALUE = CountA                                 AR318462 AR1089839
      *                                                                                     AR318462
     C**********         ENDIF                                                    AR318462 AR1089839
      *                                                                                     AR318462
     C**********         ENDIF                                                    AR318462 AR1089839
      **********                                                                              260346
      **Unauthorised Participations Purchased                                                 260346
     C**********         IF        Key_Desc = 'UnauthPartsPurch'                              260346
      **********                                                                              260346
      **If*the*Midas phase is not Input Cycle then set data to blank.                         260346
     C**********         IF        MidasPhase <> 'A'                                          260346
     C**********         EVAL      Value = *blanks                                            260346
     C**********         ELSE                                                                 260346
      **********                                                                              260346
     C**********         EVAL      CountN = 0                                                 260346
      **********                                                                              260346
     C**********         OPEN      LELOANL1                                                   248277
     C******LOVAL        SETLL     LELOANL1                                                   248277
     C**********         READ      LELOANL1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 260346
     C******LOVAL        SETLL     GPLEWIPL                                            248277 260346
     C**********         READ      GPLEWIPL                               01           248277 260346
      **********                                                                              260346
     C**********         OPEN      LELOANL0                                            248277 260346
     C**********         DOW       *IN01 = *OFF                                               260346
     C**********         IF        MSWZONE = PZZONE and                                248277 260346
     C**********                   MSWAPI = 'CLIP                          '           248277 260346
     C**********         EVAL      LOANA = %SUBST(MSWTREF:1:6)                         248277 260346
     C**********         MOVE      LOANA         PLOAN             6 0                 248277 260346
     C*****PLOAN         CHAIN     LELOANL0                           90               248277 260346
     C**********         IF        *IN90 = '0'                                         248277 260346
     C**********         IF        PTYP = 64 or                                               260346
     C**********                   PTYP = 65 or                                               260346
     C**********                   PTYP = 68 or                                               260346
     C**********                   PTYP = 71                                                  260346
     C**********         EVAL      CountN = CountN + 1                                        260346
     C**********         ENDIF                                                                260346
     C**********         ENDIF                                                         248277 260346
     C**********         ENDIF                                                         248277 260346
     C**********         READ      LELOANL1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 260346
     C**********         ENDDO                                                                260346
     c**********                                                                              260346
     C**********         CLOSE     LELOANL1                                                   248277
     C**********         CLOSE     LELOANL0                                            248277 260346
     C**********         CLOSE     GPLEWIPL                                            248277 260346
     C**********         EVAL      Value = CountA                                             260346
     c**********                                                                              260346
     C**********         ENDIF                                                                260346
     c**********                                                                              260346
     C**********         ENDIF                                                                260346
      **********                                                                              260346
      **Unauthorised Participations Sold                                                      260346
     C**********         IF        Key_Desc = 'UnauthPartsSold'                               260346
      **********                                                                              260346
      **If*the*Midas phase is not Input Cycle then set data to blank.                         260346
     C**********         IF        MidasPhase <> 'A'                                          260346
     C**********         EVAL      Value = *blanks                                            260346
     C**********         ELSE                                                                 260346
      **********                                                                              260346
     C**********         EVAL      CountN = 0                                                 260346
      **********                                                                              260346
     C**********         OPEN      LELOANL1                                                   248277
     C******LOVAL        SETLL     LELOANL1                                                   248277
     C**********         READ      LELOANL1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 260346
     C******LOVAL        SETLL     GPLEWIPL                                            248277 260346
     C**********         READ      GPLEWIPL                               01           248277 260346
      **********                                                                              260346
     C**********         OPEN      LELOANL0                                            248277 260346
     C**********         DOW       *IN01 = *OFF                                               260346
     C**********         IF        MSWZONE = PZZONE and                                248277 260346
     C**********                   MSWAPI = 'CLIP                          '           248277 260346
     C**********         EVAL      LOANAI==%SUBST(MSWTREF:1:6)             '           248277 260346
     C**********         MOVE      LOANA = %SUBSTPLOANREF:1:6)     6 0                 248277 260346
     C*****PLOAN         CHAIN     LELOANL0      PLOAN             6 090               248277 260346
     C*****PLOAN         IFAIN     *IN90N=0'0'                        90               248277 260346
     C**********         IF        PTYP = 66 or                                               260346
     C**********                   PTYP = 67 or                                               260346
     C**********                   PTYP = 69 or                                               260346
     C**********                   PTYP = 72                                                  260346
     C**********         EVAL      CountN = CountN + 1                                        260346
     C**********         ENDIF                                                                260346
     C**********         ENDIF                                                         248277 260346
     C**********         ENDIF                                                         248277 260346
     C**********         READ      LELOANL1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 260346
     C**********         ENDDO                                                                260346
      **********                                                                              260346
     C**********         CLOSE     LELOANL1                                                   248277
     C**********         CLOSE     LELOANL0                                           2248277 260346
     C**********         CLOSE     GPLEWIPL                                           248277  260346
     C**********         EVAL      Value = CountA                                             260346
      **********                                                                              260346
     C**********         ENDIF                                                                260346
      **********                                                                              260346
     C**********         ENDIF                                                                260346
      *
      **Unauthorised*Loan*Amendments*-*Spread*Change*******************                       CCB023
      *******************************-*Base*Rate*Code*Change***********                       CCB023
      *******************************-*Principal*Increase**************                       CCB023
      *******************************-*Stop/Start*Accruals*************                       CCB023
      *******************************-*Loan*Subtype*Change*************                       CCB023
      *******************************-*Past*Due************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthLoanAmds'                                CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LELOAML1                                                   248277
     C******LOVAL        SETLL     LELOAML1                                                   248277
     C**********         READ      LELOAML1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   (MSWAPI = 'LOAM' or MSWAPI = 'AIAJ' or              248277 CCB023
     C**********                    MSWAPI = 'AMAJ')                                   248277 CCB023
     C**********         IF        AMTP = 'SC' or                                             248277
     C**********                   AMTP = 'BC' or                                             248277
     C**********                   AMTP = 'PI' or                                             248277
     C**********                   AMTP = 'LS' or                                             248277
     C**********                   AMTP = 'PD' or                                             248277
     C**********                   AMTP = 'SA'                                                248277
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      LELOAML1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LELOAML1                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Loan*Amendments*-*Manual*Repayment****************                       CCB023
     C**********         IF        Key_Desc = 'UnauthLoanAmdsMP'                              CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LELOAML1                                                   248277
     C******LOVAL        SETLL     LELOAML1                                                   248277
     C**********         READ      LELOAML1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   MSWAPI = 'MAPY                          '           248277 260346
     C**********                   MSWAPI = 'MAPY'                                     260346 CCB023
     C**********         IF        AMTP = 'MR'                                                248277
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      LELOAML1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LELOAML1                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Loan*Amendments*-*Repayment*Schedule**************                       CCB023
     C**********         IF        Key_Desc = 'UnauthLoanAmdsRS'                              CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LELOAML1                                                   247572
     C******LOVAL        SETLL     LELOAML1                                                   247572
     C**********         READ      LELOAML1                               01                  247572
     C**********         OPEN      GPRSWIPL                                            247572 248277
     C******LOVAL        SETLL     GPRSWIPL                                            247572 248277
     C**********         READ      GPRSWIPL                               01           247572 248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        AMTP = 'RE'                                                247572
     C**********         IF        MSWAPI = 'RPSC'                                     247572 CCB023
     C**********                   and  MSWZONE = PZZONE                               248277 CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      LELOAML1                               01                  247572
     C**********         READ      GPRSWIPL                               01           247572 248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LELOAML1                                                   247572
     C**********         CLOSE     GPRSWIPL                                            247572 248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Loan*Amendments*-*Principal*Transfer*To/From******                       CCB023
     C**********         IF        Key_Desc = 'UnauthLoanAmdsPT'                              CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LELOAML1                                                   248277
     C******LOVAL        SETLL     LELOAML1                                                   248277
     C**********         READ      LELOAML1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWAPI = 'PTPF'                                     247572 CCB023
     C**********                   and  MSWZONE = PZZONE                               248277 CCB023
     C**********         IF        AMTP = 'PT' or                                             248277
     C**********                   AMTP = 'PF'                                                248277
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                                CCB023
     C**********         READ      LELOAML1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LELOAML1                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Rollovers*****************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthRollovers'                               CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LELOANL3                                                   CCB023
     C******LOVAL        SETLL     LELOANL3                                                   CCB023
     C**********         READ      LELOANL3                               01                  CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         READ      LELOANL3                               01                  CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LELOANL3                                                   CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      * Unauthorised Guarantees
     C                   IF        Key_Desc = 'UnauthGuarantees'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                         CCB020A
     C                   IF        MidasPhase = 'C'                                          CCB020A
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      LEGTEEL1
     C     *LOVAL        SETLL     LEGTEEL1
     C                   READ      LEGTEEL1                               01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      LEGTEEL1                               01
     C                   ENDDO
      *
     C                   CLOSE     LEGTEEL1
     C                   EVAL      Value = CountA
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      **Unauthorised*Fees**********************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthFees'                                    CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LEFEESL1                                                   248277
     C******LOVAL        SETLL     LEFEESL1                                                   248277
     C**********         READ      LEFEESL1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   MSWAPI = 'FEEM                          '           248277 260346
     C**********                   MSWAPI = 'FEEM'                                     260346 CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                         248277 CCB023
     C**********         READ      LEFEESL1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LEFEESL1                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Fee*Adjustments***********************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthFeeAdjs'                                 CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LEFEEAL3                                                   248277
     C******LOVAL        SETLL     LEFEEAL3                                                   248277
     C**********         READ      LEFEEAL3                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   (MSWAPI = 'FEAD                          ' or       248277 260346
     C**********                   MSWAPI = 'FEST                          ')          248277 260346
     C**********                   (MSWAPI = 'FEAD' or MSWAPI = 'FEST')                260346 CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                         248277 CCB023
     C**********         READ      LEFEEAL3                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LEFEEAL3                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Facilities****************************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthFacilities'                              CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LEFCLTL1                                                   248277
     C******LOVAL        SETLL     LEFCLTL1                                                   248277
     C**********         READ      LEFCLTL1                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   MSWAPI = 'FCIP                          '           248277 260346
     C**********                   MSWAPI = 'FCIP'                                     260346 CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                         248277 CCB023
     C**********         READ      LEFCLTL1                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LEFCLTL1                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      **Unauthorised*Facility*Amendments*******************************                       CCB023
     C**********         IF        Key_Desc = 'UnauthFcltyAmds'                               CCB023
      *
      **If*the*Midas*phase*is*not*Input*Cycle*then*set*data*to*blank.**                       CCB023
     C**********         IF        MidasPhase <> 'A'                                          CCB023
     C**********         EVAL      Value = *blanks                                            CCB023
     C**********         ELSE                                                                 CCB023
      *
     C**********         EVAL      CountN = 0                                                 CCB023
      *
     C**********         OPEN      LEFCAML2                                                   248277
     C******LOVAL        SETLL     LEFCAML2                                                   248277
     C**********         READ      LEFCAML2                               01                  248277
     C**********         OPEN      GPLEWIPL                                            248277 CCB023
     C******LOVAL        SETLL     GPLEWIPL                                            248277 CCB023
     C**********         READ      GPLEWIPL                               01           248277 CCB023
      *
     C**********         DOW       *IN01 = *OFF                                               CCB023
     C**********         IF        MSWZONE = PZZONE and                                248277 CCB023
     C**********                   MSWAPI = 'FAMD                          '           248277 260346
     C**********                   MSWAPI = 'FAMD'                                     260346 CCB023
     C**********         EVAL      CountN = CountN + 1                                        CCB023
     C**********         ENDIF                                                         248277 CCB023
     C**********         READ      LEFCAML2                               01                  248277
     C**********         READ      GPLEWIPL                               01           248277 CCB023
     C**********         ENDDO                                                                CCB023
      *
     C**********         CLOSE     LEFCAML2                                                   248277
     C**********         CLOSE     GPLEWIPL                                            248277 CCB023
     C**********         EVAL      Value = CountA                                             CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
     C**********         ENDIF                                                                CCB023
      *
      * Unauthorised Utilisations
     C                   IF        Key_Desc = 'UnauthUtilisations'
      *
      * If the Midas phase is not Input Cycle then set data to blank.
     C**********         IF        MidasPhase <> 'A'                                         CCB020A
     C                   IF        MidasPhase = 'C'                                          CCB020A
     C                   EVAL      Value = *blanks
     C                   ELSE
      *
     C                   EVAL      CountN = 0
      *
     C                   OPEN      LEMNFUL2
     C     *LOVAL        SETLL     LEMNFUL2
     C                   READ      LEMNFUL2                               01
      *
     C                   DOW       *IN01 = *OFF
     C                   EVAL      CountN = CountN + 1
     C                   READ      LEMNFUL2                               01
     C                   ENDDO
      *
     C                   CLOSE     LEMNFUL2
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
      /EJECT                                                                                  248277
      *****************************************************************                       248277
      *                                                               *                       248277
      * SRGPGZ - Gets the Zone.                                       *                       248277
      *                                                               *                       248277
      * Called by: (At the beginning)                                 *                       248277
      *                                                               *                       248277
      * Calls: GOGETZONE                                              *                       248277
      *                                                               *                       248277
      *****************************************************************                       248277
     C     SRGPGZ        BEGSR                                                                248277
      *                                                                                       248277
     C                   CALL      'GOGETZONE'                                                248277
     C                   PARM      *BLANKS       PZRTCD            7                          248277
     C                   PARM      *BLANKS       PZERMS           50                          248277
     C                   PARM      'N'           PZFCHK            1                          248277
     C                   PARM      *BLANKS       PZZONE           10                          248277
     C                   PARM      *BLANKS       PZSHTC            4                          248277
     C                   PARM      *ZERO         PZRDNB            5 0                        248277
     C                   PARM      *ZERO         PZDNWD            5 0                        248277
     C                   PARM      *BLANKS       PZBCCY            3                          248277
     C                   PARM      *ZERO         PZNJOB            1 0                        248277
      *                                                                                       248277
     C     PZRTCD        IFEQ      *BLANKS                                                    248277
     C                   MOVE      PZZONE        WZONE            10                          248277
     C                   ELSE                                                                 248277
      *                                                                                       248277
     C     PZRTCD        IFEQ      '*ERROR'                                                   248277
     C                   EXSR      *PSSR                                                      248277
     C                   ENDIF                                                                248277
     C                   ENDIF                                                                248277
      *                                                                                       248277
     C                   ENDSR                                                                248277
      *****************************************************************                       248277
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
