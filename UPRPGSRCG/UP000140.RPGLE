     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas UP Generate module & program X-check report')
      *****************************************************************
      *                                                               *
      *  Midas - Bridge                                               *
      *                                                               *
      *  UP000140 - Generate module and program cross check report    *
      *                                                               *
      *  Function : The report consists of 4 sections:
      *             1. Modules do not have any matched program nor in *
      *                any service program.                           *
      *             2. Programs do not have matched modules delivered.*
      *             3. Modules duplicated in service program.         *
      *             4. If full delivery, modules in service programs  *
      *                have not been delivered.                       *
      *                                                               *
      *  Called By: UPC000135                                         *
      *                                                               *
      *  Calls:     UPC000141                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CPK025             Date 10Oct05               *
      *  Prev Amend No. CPK022             Date 29Jul05               *
      *                 CUP029  *CREATE    Date 30Sep04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CPK025 - Added exception file UPMPXCPD                       *
      *  CPK022 - Should not use zone /COPYs.                         *
      *  CUP029 - Utility to cross check module and program sources   *
      *           in a library.                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *       10      End of file.                                    *
      *       20      Record not found.                               *
      *       25      Print source file name.                         *
      *       26      Print file member name.                         *
      *       27      Print module.                                   *
      *       30      New page indicator.                             *
      *       37      Report overflow indicator.                      *
      *       41      Output unmatched module report (ie, section 1)  *
      *       42      Output unmatched program report (ie, section 2) *
      *       43      Output duplicated modules in service program    *
      *               (ie, section 3)                                 *
      *       44      Output modules in service program not delivered *
      *               report (ie, section 4)                          *
      *       50      Duplicated module reported.                     *
      *       72      There is record to report.                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FUPMODSL1  IF   E           K DISK    INFSR(*PSSR) Prefix(M_)
      * RTV : Midsa UP Modules by source file, module
      *
     FUPMODSL2  IF   E           K DISK    INFSR(*PSSR) Prefix(M_)
     F                                     RENAME(UPMODSD0:ModByMF)
      * RTV : Midsa UP Modules by module
      *
     FUPPGMSL1  IF   E           K DISK    INFSR(*PSSR) Prefix(P_)
      * RTV : Midsa UP Programs by program
      *
     FUPPGMSL2  IF   E           K DISK    INFSR(*PSSR) Prefix(P_)
     F                                     RENAME(UPPGMSD0:PgmByPF)
      * RTV : Midsa UP Program file by program
      *
     FUPSVPSML1 IF   E           K DISK    INFSR(*PSSR)  USROPN
      * RTV : Midsa UP Service pgm by source file, pgm, module
      *
     FUPSVPSML2 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(UPSVPSMD0:SVPSMByMF)
      * RTV : Midsa UP Service pgm by module, source file, pgm
      *
     FUPMPXCPD  IF   E           K DISK    INFSR(*PSSR) Prefix(P_)                            CPK025
     F                                     RENAME(UPMPXCP0:PgmModF)                           CPK025
      * RTV : Midas UP Exception file - List of Programs and Modules name                     CPK025
      *
     FUPMPXCL0  IF   E           K DISK    INFSR(*PSSR) Prefix(M_)                            CPK025
      * RTV : Midas UP Exception file by module and program                                   CPK025
      *
     FUP000140P1O    E             PRINTER INFSR(*PSSR)
     F                                     OFLIND(*IN37)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D***/COPY*ZACPYSRC,PSDS*                                                                 CPK022
     D/COPY GPCPYSRCG,PSDS                                                                    CPK022
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D PrevSVFile      S                   LIKE(SVFILE)                         Previous source file
     D PrevSVPgm       S                   LIKE(SVPGM)                          Previous service pgm
     D PrevSVLMod      S                   LIKE(SVLMOD)                         Previous module
 
     D PrevPrtFile     S                   LIKE(@SRCFILE)                       Prev. printed file
     D PrevPrtMbr      S                   LIKE(@MBRNAME)                       Prev. printed member
     D PrevPrtLMod     S                   LIKE(@MODULE)                        Prev. printed module
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *                                                               *
      * Calls: UnmatchModRpt                                          *
      *        UnmatchPgmRpt                                          *
      *        DupModuleRpt                                           *
      *        UnmatSVPModRpt                                         *
      *                                                               *
      *****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    SourceLib        10
     C                   PARM                    Layer             7
     C                   PARM                    FullDelivery      4
      *
      * Set report header according to input parameters:
      *  Layer
      *  =====
     C                   SELECT
     C                   WHEN      Layer    = '*GLOBAL' OR
     C                             Layer    = '*ZONE'
     C                   EVAL      @LIBLYR  = %TRIM(SourceLib) + ' - ' +
     C                                        %TRIM(%SUBST(Layer:2:6)) +
     C                                        ' Layer'
      *
     C                   WHEN      Layer    = '*NONE'
     C                   EVAL      @LIBLYR  = %TRIM(SourceLib) +
     C                                        ' - Pre MidasPlus'
     C                   ENDSL
      *
      *  FullDelivery
      *  ============
     C                   SELECT
     C                   WHEN      FullDelivery = '*YES'
     C                   EVAL      @DELV    = '- Full Delivery'
      *
     C                   WHEN      FullDelivery = '*NO'
     C                   EVAL      @DELV    = '- Partial Delivery'
     C                   ENDSL
      *
      * Output report - Modules do not have any matched program nor in
      *                 any service program.
     C                   EXSR      UnmatchModRpt
      *
      * Output report - Programs do not have matched modules delivered.
     C                   EXSR      UnmatchPgmRpt
      *
      * Output report - Modules duplicated in service program.
     C                   EXSR      DupModuleRpt
      *
      * Output report - If full delivery, modules in service programs
     C                   IF        FullDelivery = '*YES'
     C                   EXSR      UnmatSVPModR
     C                   ENDIF
      *
     C                   WRITE     TRAILP
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      * UnmatchModRpt - Output modules that do not have any matched   *
      *                 program nor in any service program.           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:     WrtRptLine                                         *
      *                                                               *
      *****************************************************************
      *
     C     UnmatchModRpt BEGSR
      *
      * Set on/off indicators for the section of report to be output.
     C                   SETON                                        41
     C                   SETOFF                                       424344
      *
      * Set off 'record to report' and overflow indicators
     C                   SETOFF                                       7237
      *
     C                   EVAL      PrevPrtFile = *BLANK
     C                   EVAL      PrevPrtMbr  = *BLANK
      *
      * Write report headers
     C                   WRITE     HEAD
      *
      * Set on New page indicator.
     C                   SETON                                        30
      *
     C     *LOVAL        SETLL     UPMODSL1
     C                   READ      UPMODSL1                               10    EOF
      *
     C                   DOW       *IN10 = '0'
      *
     C                   MOVE      'N'           @EXIST            1                          CPK025
     C     M_MLNAME      CHAIN     UPMPXCL0                           21                      CPK025
     C                   IF        *IN21 = '0'                                                CPK025
     C     M_XCPGM       CHAIN     UPPGMSL2                           22                      CPK025
     C                   IF        *IN22 = '0'                                                CPK025
     C                   MOVE      'Y'           @EXIST                                       CPK025
     C                   ENDIF                                                     *IN22 = '0'CPK025
      *                                                                                       CPK025
     C                   ENDIF                                                     *IN21 = '0'CPK025
      * Check if there is any program in UPPGMSL2 with same name as the
      * the module.
     C     M_MLNAME      CHAIN     UPPGMSL2                           20        record not found
      *
      * If not found in UPPGMSL2, check if found in UPSVPSML2.
     C   20M_MLNAME      CHAIN     UPSVPSML2                          20        record not found
      *
      * If still not found in UPSVPSML2, output to report.
     C                   IF        *IN20 = '1' AND                                            CPK025
     C                             @EXIST = 'N'                                               CPK025
      *
     C                   EVAL      @SRCFILE = M_MLFILE
     C                   EVAL      @MBRNAME = M_MLNAME
     C                   EXSR      WrtRptLine
      *
     C                   ENDIF                                                  FI *IN20 = '1'
      *
     C                   READ      UPMODSL1                               10    EOF
      *
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to UP000140P1,  write 'no records' to UP000140P1.
     C                   IF        *IN72 = '0'
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C     UnmatchModRptEENDSR
      *
      *****************************************************************
      *                                                               *
      * UnmatchPgmRpt - Output programs that do not have any matched  *
      *                 modules delivered.                            *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:     WrtRptLine                                         *
      *                                                               *
      *****************************************************************
      *
     C     UnmatchPgmRpt BEGSR
      *
      * Set on/off indicators for the section of report to be output.
     C                   SETON                                        42
     C                   SETOFF                                       414344
      *
      * Set off 'record to report' and overflow indicators.
     C                   SETOFF                                       7237
      *
     C                   EVAL      PrevPrtFile = *BLANK
     C                   EVAL      PrevPrtMbr  = *BLANK
      *
      * Write report headers
     C                   WRITE     HEAD
      *
      * Set on New page indicator.
     C                   SETON                                        30
      *
     C     *LOVAL        SETLL     UPPGMSL1
     C                   READ      UPPGMSL1                               10    EOF
      *
     C                   DOW       *IN10 = '0'
      *                                                                                       CPK025
     C                   MOVE      'N'           @EXIST                                       CPK025
     C     P_MLNAME      CHAIN     UPMPXCPD                           21                      CPK025
     C                   IF        *IN21 = '0'                                                CPK025
     C     M_XCMOD       CHAIN     UPMODSL2                           22                      CPK025
     C                   IF        *IN22 = '0'                                                CPK025
     C                   MOVE      'Y'           @EXIST                                       CPK025
     C                   ENDIF                                                     *IN22 = '0'CPK025
      *                                                                                       CPK025
     C                   ENDIF                                                     *IN21 = '0'CPK025
      *
      * Check if there is any module in UPMODSL2 with same name as the
      * the program.
     C     P_MLNAME      CHAIN     UPMODSL2                           20        record not found
      *
      * If not found in UPMODSL2, output to report.
     C                   IF        *IN20 = '1' AND                                            CPK025
     C                             @EXIST = 'N'                                               CPK025
      *
     C                   EVAL      @SRCFILE = P_MLFILE
     C                   EVAL      @MBRNAME = P_MLNAME
     C                   EXSR      WrtRptLine
      *
     C                   ENDIF                                                  FI *IN20 = '1'
      *
     C                   READ      UPPGMSL1                               10    EOF
      *
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to UP000140P1,  write 'no records' to UP000140P1.
     C                   IF        *IN72 = '0'
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C     UnmatchPgmRptEENDSR
      *
      *****************************************************************
      *                                                               *
      * DupModuleRpt  - Output modules which are duplicated in service*
      *                 programs.                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:     WrtRptLine                                         *
      *                                                               *
      *****************************************************************
      *
     C     DupModuleRpt  BEGSR
      *
      * Set on/off indicators for the section of report to be output.
     C                   SETON                                        43
     C                   SETOFF                                       414244
      *
      * Set off 'Record to report' and overflow indicators.
     C                   SETOFF                                       7237
      * Set off 'Duplicated module reported' indicator
     C                   SETOFF                                       50
      *
     C                   EVAL      PrevPrtLMod = *BLANK
      *
      * Write report headers
     C                   WRITE     HEAD
      *
      * Set on New page indicator.
     C                   SETON                                        30
      *
     C                   EVAL      PrevSVFile = *BLANK
     C                   EVAL      PrevSVPgm  = *BLANK
     C                   EVAL      PrevSVLMod = *BLANK
      *
     C     *LOVAL        SETLL     UPSVPSML2
     C                   READ      UPSVPSML2                              10    EOF
      *
     C                   DOW       *IN10 = '0'
      *
      * If module is same as previous, output report.
     C                   IF        PrevSVLMod = SVLMOD
      *
      *    and the duplication not reported yet, report the previous module.
     C                   IF        *IN50 = '0'
     C                   EVAL      @SRCFILE   = PrevSVFile
     C                   EVAL      @MBRNAME   = PrevSVPgm
     C                   EVAL      @MODULE    = PrevSVLMod
     C                   EXSR      WrtRptLine
     C                   SETON                                        50
     C                   ENDIF                                                  FI *IN50 ='0'
      *
      *    Then report this duplicated module.
     C                   EVAL      @SRCFILE   = SVFILE
     C                   EVAL      @MBRNAME   = SVPGM
     C                   EVAL      @MODULE    = SVLMOD
     C                   EXSR      WrtRptLine
      *
      * else (ie, different modules), set off 'duplicated module reported' indicator.
     C                   ELSE
     C                   SETOFF                                       50
     C                   ENDIF                                                  FI PrevSVLMod=SVLMOD
      *
     C                   EVAL      PrevSVFile = SVFILE
     C                   EVAL      PrevSVPgm  = SVPGM
     C                   EVAL      PrevSVLMod = SVLMOD
      *
     C                   READ      UPSVPSML2                              10    EOF
      *
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to UP000140P1,  write 'no records' to UP000140P1.
     C                   IF        *IN72 = '0'
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C     DupModuleRptE ENDSR
      *
      *****************************************************************
      *                                                               *
      * UnmatSVPModR   - Output modules listed in service programs    *
      *                  but not delivered.                           *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls:     WrtRptLine                                         *
      *                                                               *
      *****************************************************************
      *
     C     UnmatSVPModR  BEGSR
      *
      * Set on/off indicators for the section of report to be output.
     C                   SETON                                        44
     C                   SETOFF                                       414243
      *
      * Set off 'Record to report' and overflow indicators.
     C                   SETOFF                                       7237
      *
      * Write report headers
     C                   WRITE     HEAD
      *
      * Set on New page indicator.
     C                   SETON                                        30
      *
     C                   EVAL      PrevSVLMod = *BLANK
      *
     C                   OPEN      UPSVPSML1
      *
     C     *LOVAL        SETLL     UPSVPSML1
     C                   READ      UPSVPSML1                              10    EOF
      *
     C                   DOW       *IN10 = '0'
      *
      * If module is same as previous and not reported yet, output report.
     C                   IF        PrevSVLMod <> SVLMOD
      *
      * Check if there is any module in UPMODSL2 with same name as the
      * the program.
     C     SVLMOD        CHAIN     UPMODSL2                           20        record not found
      *
      * If not found in UPMODSL2, output to report.
     C                   IF        *IN20 = '1'
      *
     C                   EVAL      @SRCFILE = SVFILE
     C                   EVAL      @MBRNAME = SVPGM
     C                   EVAL      @MODULE  = SVLMOD
     C                   EXSR      WrtRptLine
      *
     C                   ENDIF                                                  FI *IN20 = '1'
      *
     C                   EVAL      PrevSVLMod = SVLMOD
     C                   ENDIF                                                  FI PrevSVLMod<>
      *                                                                            SVLMOD
      *
     C                   READ      UPSVPSML1                              10    EOF
      *
     C                   ENDDO                                                  WO *IN10 = '0'
      *
      * If no items written to UP000140P1,  write 'no records' to UP000140P1.
     C                   IF        *IN72 = '0'
     C                   WRITE     NORECS
     C                   ENDIF
      *
     C                   CLOSE     UPSVPSML1
      *
     C     UnmatSVPModRE ENDSR
      *
      *****************************************************************
      *                                                               *
      * WrtRptLine - Write a detail line to report. If overflow, write*
      *              headers before detail line.                      *
      *                                                               *
      * Called by: UnmatchModRpt                                      *
      *            UnmatchPgmRpt                                      *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     WrtRptLine    BEGSR
      *
      * If for unmatched module OR unmatch program report, get member text.
     C                   IF        (*IN41 = '1') OR
     C                             (*IN42 = '1')
     C                   CALL      'UPC000141'
     C                   PARM                    @MBRNAME         10
     C                   PARM                    @SRCFILE         10
     C                   PARM                    SourceLib
     C                   PARM      *BLANK        @MBRTXT
     C                   PARM      *BLANK        RtnCode          10
     C                   IF        RtnCode  <> *Blank                           Error on RTVMBRD
     C                   EVAL      @MBRTXT = *Blank
     C                   ENDIF
      *
     C                   ENDIF                                                  FI *IN41 or *IN42 ON
      *
      * If overflow on, write headers before writing the details and set on
      *    new page indicator.
     C                   IF        *IN37 = '1'
     C                   WRITE     HEAD
     C                   SETOFF                                       37        Overflow indicator
     C                   SETON                                        30
     C                   ENDIF
      *
      * Set indicators to display source file, file member:
      *   IF new page, set on indicators to print file, file member.
     C                   IF        *IN30 = '1'
     C                   SETON                                        2526
     C   43              SETON                                        2725
      *
      *   Else (ie, not new page) check difference of file, file member:
     C                   ELSE
     C                   IF        *IN43  =  '0'                                not printing dup mod
      *
     C                   IF        PrevPrtFile <> @SRCFILE
     C                   SETON                                        2526
     C                   ELSE                                                   same source file
     C                   IF        PrevPrtMbr  <> @MBRNAME
     C                   SETON                                        26
     C                   SETOFF                                       25
     C                   ELSE                                                   same file, SV pgm
     C                   SETOFF                                       2526
     C                   ENDIF                                                  FI diff file mbr
     C                   ENDIF                                                  FI diff source file
      *
      * else (printing duplicated module)
     C                   ELSE
      *
      * Set indicator to print
     C                   IF        PrevPrtLMod <> @MODULE
     C                   SETON                                        27
     C                   ELSE
     C                   SETOFF                                       27
     C                   EVAL      @MBRNAM1  = @MBRNAME                         for SPACEA(1)
     C                   ENDIF                                                  FI diff module
      *
     C                   IF        PrevPrtFile <> @SRCFILE
     C                   SETON                                        25
     C                   ELSE
     C                   SETOFF                                       25
     C                   ENDIF                                                  FI diff source file
      *
     C                   ENDIF                                                  FI *IN43 <> '0'
      *
     C                   ENDIF                                                  FI *IN30  = '1'
      *
     C  N43              WRITE     DETAIL
     C   43              WRITE     DETAILDM
      *
      * Set on 'Record to Report' indicator.
     C  N72              SETON                                        72
      *
      * Set off 'New Page' indicator.
     C   30              SETOFF                                       30
      *
      * Save the reported file, file member and if printing dup mod, save module.
     C                   EVAL      PrevPrtFile = @SRCFILE
     C                   EVAL      PrevPrtMbr  = @MBRNAME
     C   43              EVAL      PrevPrtLMod = @MODULE
      *
     C     WrtRptLineE   ENDSR
      *
      *****************************************************************
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
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
