     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD Forward Rates Amend module')
      *****************************************************************
      *                                                               *
      *  Midas - Forward Rates                                        *
      *                                                               *
      *  FDFWRTAMD - Forward Rates Amend checking                     *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended deal against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 238467             Date 16Aug06               *
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 BUG6270            Date 23Mar05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 09Mar01               *
      *                 CAP059  *CREATE    Date 09Mar01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  238467 - MMA1157 appears unnecessarily.  Do not validate the *
      *           first rate since it is defaulted to spot rate.      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG6270- Rate validation failing as screen field is left     *
      *           adjusted and file field is right.                   *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP059 - Conversion of Forward Rates into Modular APIs       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
     D PrvFRScnFmt   E DS                  EXTNAME(FDFWRTPD)
     D                                     PREFIX(@P)
      ** Previous Forward Rates Detail in Screen Format
 
     D CurFRScnFmt   E DS                  EXTNAME(FDFWRTPD)
      ** Current Forward Rates Detail in Screen Format
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FDEFWRTPD)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                 BUG6270
      ** EXTERNAL DS FOR DEALING DETAILS                                                     BUG6270
                                                                                             BUG6270
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
                                                                                             BUG6270
     D @@ALPH          S             16A                                                     BUG6270
     D @@IDP           S              3  0                                                   BUG6270
     D @@IINT          S              3  0                                                   BUG6270
     D @@MTID          S              1A                                                     BUG6270
     D @@ERCD          S              1  0                                                   BUG6270
                                                                                             BUG6270
     D @RTCDE          S              1A                                                     BUG6270
                                                                                             BUG6270
      ** Amount returned from ZA0840                                                         BUG6270
     D @@AMT           S             15  0                                                   BUG6270
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Compare fields with amended values.
      *
      *
      * Access currency data
      * (Database error handling done in access program).
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
 
 
     C                   IF        DDACTN = 'A'  AND
     C                             DDCCY <> *BLANKS AND
     C                             @PDDCCY <> *BLANKS AND
     C                             @PDDACTN<> *BLANKS AND
     C                             DDCCY = @PDDCCY  AND
     C                             DDACTN= @PDDACTN
 
     C                             OR
 
     C                             DDACTN = 'I'  AND
     C                             DDCCY <> *BLANKS
     C
     C                   EXSR      COMPFLDS
     C                   ENDIF
      *
      *  If any errors were found:
      *    Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      *  If any errors were found:
      *  - and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLDS
     C                   ENDIF
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMPFLDS  - Compare certain fields on the current deal        *
      *             with those amended.                               *
      *****************************************************************
     C     COMPFLDS      BEGSR
 
      * Screen rates are now left aligned, so right align first before comparing             BUG6270
      * with previous @P* versions.                                                          BUG6270
      *                                                                                      BUG6270
     C                   EXSR      RATEALIGN                                                 BUG6270
                                                                                             BUG6270
      *******************************************************
      * If EMU forward rate changes are on,                 *
      * forward rates maintenance is on and currency is IN  *
      *******************************************************
 
     C                   IF        CEU026 = 'Y' AND
     C                             S01432 = 'Y' AND
     C                             A6INCY = 'Y'
     C
     C
     C                   IF        DDACTN = 'A'
     C                   IF        DDRTE1   <>  @PDDRTE1   OR
     C                             DDSFW1   <>  @PDDSFW1   OR
     C                             DDRTE2   <>  @PDDRTE2   OR
     C                             DDSFW2   <>  @PDDSFW2   OR
     C                             DDRTE3   <>  @PDDRTE3   OR
     C                             DDSFW3   <>  @PDDSFW3   OR
     C                             DDRTE4   <>  @PDDRTE4   OR
     C                             DDSFW4   <>  @PDDSFW4   OR
     C                             DDRTE5   <>  @PDDRTE5   OR
     C                             DDSFW5   <>  @PDDSFW5   OR
     C                             DDRTE6   <>  @PDDRTE6   OR
     C                             DDSFW6   <>  @PDDSFW6   OR
     C                             DDRTE7   <>  @PDDRTE7   OR
     C                             DDSFW7   <>  @PDDSFW7   OR
     C                             DDRTE8   <>  @PDDRTE8   OR
     C                             DDSFW8   <>  @PDDSFW8   OR
     C                             DDRTE9   <>  @PDDRTE9   OR
     C                             DDSFW9   <>  @PDDSFW9   OR
     C                             DDRT10   <>  @PDDRT10   OR
     C                             DDSF10   <>  @PDDSF10   OR
     C                             DDRT11   <>  @PDDRT11   OR
     C                             DDSF11   <>  @PDDSF11   OR
     C                             DDRT12   <>  @PDDRT12   OR
     C                             DDSF12   <>  @PDDSF12   OR
     C                             DDRT13   <>  @PDDRT13   OR
     C                             DDSF13   <>  @PDDSF13   OR
     C                             DDRT14   <>  @PDDRT14   OR
     C                             DDSF14   <>  @PDDSF14   OR
     C                             DDRT15   <>  @PDDRT15   OR
     C                             DDSF15   <>  @PDDSF15   OR
     C                             DDRT16   <>  @PDDRT16   OR
     C                             DDSF16   <>  @PDDSF16   OR
     C                             DDRT17   <>  @PDDRT17   OR
     C                             DDSF17   <>  @PDDSF17   OR
     C                             DDRT18   <>  @PDDRT18   OR
     C                             DDSF18   <>  @PDDSF18   OR
     C                             DDRT19   <>  @PDDRT19   OR
     C                             DDSF19   <>  @PDDSF19   OR
     C                             DDRT20   <>  @PDDRT20   OR
     C                             DDSF20   <>  @PDDSF20   OR
     C                             DDRT21   <>  @PDDRT21   OR
     C                             DDSF21   <>  @PDDSF21   OR
     C                             DDRT22   <>  @PDDRT22   OR
     C                             DDSF22   <>  @PDDSF22   OR
     C                             DDRT23   <>  @PDDRT23   OR
     C                             DDSF23   <>  @PDDSF23   OR
     C                             DDRT24   <>  @PDDRT24   OR
     C                             DDSF24   <>  @PDDSF24   OR
     C                             DDRT25   <>  @PDDRT25   OR
     C                             DDSF25   <>  @PDDSF25
     C
     C
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA1156'
     C                   EVAL      DDACTNOK        = 'N'
     C*
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C
     C                   IF        DDRTE1   <>  @PDDRTE1   OR
     C                             DDSFW1   <>  *BLANKS    OR
     C                             DDRTE2   <>  *BLANKS    OR
     C                             DDSFW2   <>  *BLANKS    OR
     C                             DDRTE3   <>  *BLANKS    OR
     C                             DDSFW3   <>  *BLANKS    OR
     C                             DDRTE4   <>  *BLANKS    OR
     C                             DDSFW4   <>  *BLANKS    OR
     C                             DDRTE5   <>  *BLANKS    OR
     C                             DDSFW5   <>  *BLANKS    OR
     C                             DDRTE6   <>  *BLANKS    OR
     C                             DDSFW6   <>  *BLANKS    OR
     C                             DDRTE7   <>  *BLANKS    OR
     C                             DDSFW7   <>  *BLANKS    OR
     C                             DDRTE8   <>  *BLANKS    OR
     C                             DDSFW8   <>  *BLANKS    OR
     C                             DDRTE9   <>  *BLANKS    OR
     C                             DDSFW9   <>  *BLANKS    OR
     C                             DDRT10   <>  *BLANKS    OR
     C                             DDSF10   <>  *BLANKS    OR
     C                             DDRT11   <>  *BLANKS    OR
     C                             DDSF11   <>  *BLANKS    OR
     C                             DDRT12   <>  *BLANKS    OR
     C                             DDSF12   <>  *BLANKS    OR
     C                             DDRT13   <>  *BLANKS    OR
     C                             DDSF13   <>  *BLANKS    OR
     C                             DDRT14   <>  *BLANKS    OR
     C                             DDSF14   <>  *BLANKS    OR
     C                             DDRT15   <>  *BLANKS    OR
     C                             DDSF15   <>  *BLANKS    OR
     C                             DDRT16   <>  *BLANKS    OR
     C                             DDSF16   <>  *BLANKS    OR
     C                             DDRT17   <>  *BLANKS    OR
     C                             DDSF17   <>  *BLANKS    OR
     C                             DDRT18   <>  *BLANKS    OR
     C                             DDSF18   <>  *BLANKS    OR
     C                             DDRT19   <>  *BLANKS    OR
     C                             DDSF19   <>  *BLANKS    OR
     C                             DDRT20   <>  *BLANKS    OR
     C                             DDSF20   <>  *BLANKS    OR
     C                             DDRT21   <>  *BLANKS    OR
     C                             DDSF21   <>  *BLANKS    OR
     C                             DDRT22   <>  *BLANKS    OR
     C                             DDSF22   <>  *BLANKS    OR
     C                             DDRT23   <>  *BLANKS    OR
     C                             DDSF23   <>  *BLANKS    OR
     C                             DDRT24   <>  *BLANKS    OR
     C                             DDSF24   <>  *BLANKS    OR
     C                             DDRT25   <>  *BLANKS    OR
     C                             DDSF25   <>  *BLANKS
     C
     C
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA1156'
     C                   EVAL      DDACTNOK        = 'N'
     C*
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      *******************************************************
      * If EMU forward rate changes are on,                 *
      * forward rates maintenance is on and currency is OUT *
      *******************************************************
 
     C**********         IF        CEU026 = 'Y' AND                                           238467
     C**********                   S01432 = 'Y' AND                                           238467
     C**********                   A6INCY <> 'Y'                                              238467
      **********                                                                              238467
     C**********         IF        DDRTE1   <>  @PDDRTE1                                      238467
     C**********         ADD       1             Idx                                          238467
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE1'                                 238467
     C**********         EVAL      MsgIDArr(Idx)   = 'MMA1157'                                238467
     C**********         EVAL      DDRTE1OK        = 'N'                                      238467
     C**********                                                                              238467
     C**********         ENDIF                                                                238467
     C**********         ENDIF                                                                238467
 
 
      *******************************************************
      * If EMU forward rate changes are on,                 *
      * forward rates maintenance is off and currency is IN *
      *******************************************************
 
     C                   IF        CEU026 = 'Y' AND
     C                             S01432 = 'N' AND
     C                             A6INCY = 'Y'
     C
     C                   IF        DDACTN = 'A'
     C                   IF        DDRTE1   <>  @PDDRTE1   OR
     C                             DDSFW1   <>  @PDDSFW1   OR
     C                             DDRTE2   <>  @PDDRTE2   OR
     C                             DDSFW2   <>  @PDDSFW2   OR
     C                             DDRTE3   <>  @PDDRTE3   OR
     C                             DDSFW3   <>  @PDDSFW3   OR
     C                             DDRTE4   <>  @PDDRTE4   OR
     C                             DDSFW4   <>  @PDDSFW4   OR
     C                             DDRTE5   <>  @PDDRTE5   OR
     C                             DDSFW5   <>  @PDDSFW5   OR
     C                             DDRTE6   <>  @PDDRTE6   OR
     C                             DDSFW6   <>  @PDDSFW6   OR
     C                             DDRTE7   <>  @PDDRTE7   OR
     C                             DDSFW7   <>  @PDDSFW7   OR
     C                             DDRTE8   <>  @PDDRTE8   OR
     C                             DDSFW8   <>  @PDDSFW8   OR
     C                             DDRTE9   <>  @PDDRTE9   OR
     C                             DDSFW9   <>  @PDDSFW9   OR
     C                             DDRT10   <>  @PDDRT10   OR
     C                             DDSF10   <>  @PDDSF10   OR
     C                             DDRT11   <>  @PDDRT11   OR
     C                             DDSF11   <>  @PDDSF11   OR
     C                             DDRT12   <>  @PDDRT12   OR
     C                             DDSF12   <>  @PDDSF12   OR
     C                             DDRT13   <>  @PDDRT13   OR
     C                             DDSF13   <>  @PDDSF13   OR
     C                             DDRT14   <>  @PDDRT14   OR
     C                             DDSF14   <>  @PDDSF14   OR
     C                             DDRT15   <>  @PDDRT15   OR
     C                             DDSF15   <>  @PDDSF15   OR
     C                             DDRT16   <>  @PDDRT16   OR
     C                             DDSF16   <>  @PDDSF16   OR
     C                             DDRT17   <>  @PDDRT17   OR
     C                             DDSF17   <>  @PDDSF17   OR
     C                             DDRT18   <>  @PDDRT18   OR
     C                             DDSF18   <>  @PDDSF18   OR
     C                             DDRT19   <>  @PDDRT19   OR
     C                             DDSF19   <>  @PDDSF19   OR
     C                             DDRT20   <>  @PDDRT20   OR
     C                             DDSF20   <>  @PDDSF20   OR
     C                             DDRT21   <>  @PDDRT21   OR
     C                             DDSF21   <>  @PDDSF21   OR
     C                             DDRT22   <>  @PDDRT22   OR
     C                             DDSF22   <>  @PDDSF22   OR
     C                             DDRT23   <>  @PDDRT23   OR
     C                             DDSF23   <>  @PDDSF23   OR
     C                             DDRT24   <>  @PDDRT24   OR
     C                             DDSF24   <>  @PDDSF24   OR
     C                             DDRT25   <>  @PDDRT25   OR
     C                             DDSF25   <>  @PDDSF25
     C
     C
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA1156'
     C                   EVAL      DDACTNOK        = 'N'
     C*
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C
     C                   IF        DDRTE1   <>  @PDDRTE1   OR
     C                             DDSFW1   <>  *BLANKS    OR
     C                             DDRTE2   <>  *BLANKS    OR
     C                             DDSFW2   <>  *BLANKS    OR
     C                             DDRTE3   <>  *BLANKS    OR
     C                             DDSFW3   <>  *BLANKS    OR
     C                             DDRTE4   <>  *BLANKS    OR
     C                             DDSFW4   <>  *BLANKS    OR
     C                             DDRTE5   <>  *BLANKS    OR
     C                             DDSFW5   <>  *BLANKS    OR
     C                             DDRTE6   <>  *BLANKS    OR
     C                             DDSFW6   <>  *BLANKS    OR
     C                             DDRTE7   <>  *BLANKS    OR
     C                             DDSFW7   <>  *BLANKS    OR
     C                             DDRTE8   <>  *BLANKS    OR
     C                             DDSFW8   <>  *BLANKS    OR
     C                             DDRTE9   <>  *BLANKS    OR
     C                             DDSFW9   <>  *BLANKS    OR
     C                             DDRT10   <>  *BLANKS    OR
     C                             DDSF10   <>  *BLANKS    OR
     C                             DDRT11   <>  *BLANKS    OR
     C                             DDSF11   <>  *BLANKS    OR
     C                             DDRT12   <>  *BLANKS    OR
     C                             DDSF12   <>  *BLANKS    OR
     C                             DDRT13   <>  *BLANKS    OR
     C                             DDSF13   <>  *BLANKS    OR
     C                             DDRT14   <>  *BLANKS    OR
     C                             DDSF14   <>  *BLANKS    OR
     C                             DDRT15   <>  *BLANKS    OR
     C                             DDSF15   <>  *BLANKS    OR
     C                             DDRT16   <>  *BLANKS    OR
     C                             DDSF16   <>  *BLANKS    OR
     C                             DDRT17   <>  *BLANKS    OR
     C                             DDSF17   <>  *BLANKS    OR
     C                             DDRT18   <>  *BLANKS    OR
     C                             DDSF18   <>  *BLANKS    OR
     C                             DDRT19   <>  *BLANKS    OR
     C                             DDSF19   <>  *BLANKS    OR
     C                             DDRT20   <>  *BLANKS    OR
     C                             DDSF20   <>  *BLANKS    OR
     C                             DDRT21   <>  *BLANKS    OR
     C                             DDSF21   <>  *BLANKS    OR
     C                             DDRT22   <>  *BLANKS    OR
     C                             DDSF22   <>  *BLANKS    OR
     C                             DDRT23   <>  *BLANKS    OR
     C                             DDSF23   <>  *BLANKS    OR
     C                             DDRT24   <>  *BLANKS    OR
     C                             DDSF24   <>  *BLANKS    OR
     C                             DDRT25   <>  *BLANKS    OR
     C                             DDSF25   <>  *BLANKS
     C
     C
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIDArr(Idx)   = 'MMA1156'
     C                   EVAL      DDACTNOK        = 'N'
     C*
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *--------------------------------------------------------------------------------------------
     C**********         IF        CEU026 = 'N' AND                                           238467
     C**********                   S01432 = 'Y' AND                                           238467
     C**********                   A6INCY = 'Y'                                               238467
     C**********                                                                              238467
     C**********         IF        DDRTE1   <>  @PDDRTE1                                      238467
     C**********         ADD       1             Idx                                          238467
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE1'                                 238467
     C**********         EVAL      MsgIDArr(Idx)   = 'MMA1157'                                238467
     C**********         EVAL      DDRTE1OK        = 'N'                                      238467
     C**********                                                                              238467
     C**********         ENDIF                                                                238467
     C**********         ENDIF                                                                238467
      **********                                                                              238467
     C**********         IF        CEU026 = 'N' AND                                           238467
     C**********                   S01432 = 'Y' AND                                           238467
     C**********                   A6INCY <> 'Y'                                              238467
     C**********                                                                              238467
     C**********         IF        DDRTE1   <>  @PDDRTE1                                      238467
     C**********         ADD       1             Idx                                          238467
     C**********         EVAL      FldNameArr(Idx) = 'DDRTE1'                                 238467
     C**********         EVAL      MsgIDArr(Idx)   = 'MMA1157'                                238467
     C**********         EVAL      DDRTE1OK        = 'N'                                      238467
     C**********                                                                              238467
     C**********         ENDIF                                                                238467
     C**********         ENDIF                                                                238467
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLDS - Reset fields in Error                             *
      *****************************************************************
     C     RESETFLDS     BEGSR
      *
      * Reset fields in error to 'current' values
      *
      * CURRENCY
     C                   IF        DDACTNOK= 'N'
     C                   EVAL      DDRTE1   =   @PDDRTE1
     C                   EVAL      DDSFW1   =   @PDDSFW1
     C                   EVAL      DDRTE2   =   @PDDRTE2
     C                   EVAL      DDSFW2   =   @PDDSFW2
     C                   EVAL      DDRTE3   =   @PDDRTE3
     C                   EVAL      DDSFW3   =   @PDDSFW3
     C                   EVAL      DDRTE4   =   @PDDRTE4
     C                   EVAL      DDSFW4   =   @PDDSFW4
     C                   EVAL      DDRTE5   =   @PDDRTE5
     C                   EVAL      DDSFW5   =   @PDDSFW5
     C                   EVAL      DDRTE6   =   @PDDRTE6
     C                   EVAL      DDSFW6   =   @PDDSFW6
     C                   EVAL      DDRTE7   =   @PDDRTE7
     C                   EVAL      DDSFW7   =   @PDDSFW7
     C                   EVAL      DDRTE8   =   @PDDRTE8
     C                   EVAL      DDSFW8   =   @PDDSFW8
     C                   EVAL      DDRTE9   =   @PDDRTE9
     C                   EVAL      DDSFW9   =   @PDDSFW9
     C                   EVAL      DDRT10   =   @PDDRT10
     C                   EVAL      DDSF10   =   @PDDSF10
     C                   EVAL      DDRT11   =   @PDDRT11
     C                   EVAL      DDSF11   =   @PDDSF11
     C                   EVAL      DDRT12   =   @PDDRT12
     C                   EVAL      DDSF12   =   @PDDSF12
     C                   EVAL      DDRT13   =   @PDDRT13
     C                   EVAL      DDSF13   =   @PDDSF13
     C                   EVAL      DDRT14   =   @PDDRT14
     C                   EVAL      DDSF14   =   @PDDSF14
     C                   EVAL      DDRT15   =   @PDDRT15
     C                   EVAL      DDSF15   =   @PDDSF15
     C                   EVAL      DDRT16   =   @PDDRT16
     C                   EVAL      DDSF16   =   @PDDSF16
     C                   EVAL      DDRT17   =   @PDDRT17
     C                   EVAL      DDSF17   =   @PDDSF17
     C                   EVAL      DDRT18   =   @PDDRT18
     C                   EVAL      DDSF18   =   @PDDSF18
     C                   EVAL      DDRT19   =   @PDDRT19
     C                   EVAL      DDSF19   =   @PDDSF19
     C                   EVAL      DDRT20   =   @PDDRT20
     C                   EVAL      DDSF20   =   @PDDSF20
     C                   EVAL      DDRT21   =   @PDDRT21
     C                   EVAL      DDSF21   =   @PDDSF21
     C                   EVAL      DDRT22   =   @PDDRT22
     C                   EVAL      DDSF22   =   @PDDSF22
     C                   EVAL      DDRT23   =   @PDDRT23
     C                   EVAL      DDSF23   =   @PDDSF23
     C                   EVAL      DDRT24   =   @PDDRT24
     C                   EVAL      DDSF24   =   @PDDSF24
     C                   EVAL      DDRT25   =   @PDDRT25
     C                   EVAL      DDSF25   =   @PDDSF25
     C                   ENDIF
 
     C                   IF        DDRTE1OK = 'N'
     C                   EVAL      DDRTE1   =   @PDDRTE1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG6270
      * RATEALIGN - Align screen fields for comparison with           *                      BUG6270
      *             previous rate.                                    *                      BUG6270
      *****************************************************************                      BUG6270
      *                                                                                      BUG6270
     C     RATEALIGN     BEGSR                                                               BUG6270
      *                                                                                      BUG6270
     C                   Z-ADD     8             @@IDP                                       BUG6270
     C                   Z-ADD     5             @@IINT                                      BUG6270
     C                   MOVE      'N'           @@MTID                                      BUG6270
      *                                                                                      BUG6270
      * Right align all existing rates 1 - 25.                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE1 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE1        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE1                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE2 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE2        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE2                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE3 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE3        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE3                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE4 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE4        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE4                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE5 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE5        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE5                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE6 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE6        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE6                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE7 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE7        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE7                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE8 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE8        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE8                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRTE9 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRTE9        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRTE9                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT10 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT10        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT10                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT11 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT11        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT11                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT12 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT12        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT12                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT13 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT13        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT13                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT14 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT14        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT14                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT15 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT15        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT15                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT16 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT16        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT16                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT17 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT17        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT17                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT18 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT18        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT18                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT19 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT19        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT19                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT20 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT20        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT20                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT21 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT21        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT21                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT22 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT22        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT22                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT23 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT23        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT23                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT24 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT24        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT24                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   IF        DDRT25 <> *BLANKS                                         BUG6270
     C                   MOVE      *BLANKS       @@ALPH                                      BUG6270
     C                   MOVE      DDRT25        @@ALPH                                      BUG6270
      *                                                                                      BUG6270
     C                   EXSR      ALIGNFLD                                                  BUG6270
     C                   IF        @@ALPH <> *BLANKS                                         BUG6270
     C                   MOVE      @@ALPH        DDRT25                                      BUG6270
     C                   ENDIF                                                               BUG6270
     C                   ENDIF                                                               BUG6270
      *                                                                                      BUG6270
     C                   ENDSR                                                               BUG6270
      *****************************************************************                      BUG6270
      /EJECT                                                                                 BUG6270
      *****************************************************************                      BUG6270
      * ALIGNFLD  - Align individual field.                           *                      BUG6270
      *****************************************************************                      BUG6270
      *                                                                                      BUG6270
     C     ALIGNFLD      BEGSR                                                               BUG6270
      *                                                                                      BUG6270
     C                   CALLB     'ZA0840'                                                  BUG6270
     C                   PARM                    @Rtcde                                      BUG6270
     C                   PARM                    @@ALPH                                      BUG6270
     C                   PARM                    @@IDP                                       BUG6270
     C                   PARM                    @@IINT                                      BUG6270
     C                   PARM                    @@MTID                                      BUG6270
     C                   PARM                    @@ERCD                                      BUG6270
     C                   PARM                    @@AMT                                       BUG6270
     C                   PARM                    BNDCSP                                      BUG6270
      *                                                                                      BUG6270
     C                   ENDSR                                                               BUG6270
      *****************************************************************                      BUG6270
      /EJECT                                                                                 BUG6270
     C*****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Previous in Screen Format
     C                   PARM                    PrvFRScnFmt
      *
      * Current in Screen Format
     C                   PARM                    CurFRScnFmt
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ** Initialize program name
      *
     C                   MOVEL     'FDFWRTAMD'   DBPGM
      ** Access SAR details file to see if CSD006 is installed.                 CSD006
 
     C                   CALLB     'AOSARDR0'                                   CSD006
     C                   PARM      *BLANKS       @RTCD                          CSD006
     C                   PARM      '*VERIFY'     @OPTN                          CSD006
     C                   PARM      'CSD006'      @SARD                          CSD006
                                                                                CSD006
     C                   IF        @RTCD <> *Blanks AND                         CSD006
     C                             @RTCD <> '*NRF   '                           CSD006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSD006
     C                   Z-ADD     2             DBASE                          CSD006
     C                   MOVEL     'CSD006'      DBKEY                          CSD006
     C                   EXSR      *PSSR                                        CSD006
     C                   ENDIF                                                  CSD006
 
     C                   IF        @RTCD = *Blanks                              CSD006
     C                   MOVEL     'Y'           CSD006            1            CSD006
     C                   ELSE                                                   CSD006
     C                   MOVEL     'N'           CSD006                         CSD006
     C                   ENDIF                                                  CSD006
 
 
      ** Check if switchable feature CEU026 is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU026'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU026'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU026            1
     C                   ELSE
     C                   MOVE      'N'           CEU026
     C                   ENDIF
      ** Check if switchable feature S01432 is switched on.
      ** Forward Ratess Maintenance.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01432'      @SARD             6
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01432'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           S01432            1
     C                   ELSE
     C                   MOVE      'N'           S01432
     C                   ENDIF
      *                                                                                      BUG6270
      ** ACCESS DEALING DETAILS                                                              BUG6270
      *                                                                                      BUG6270
     C                   CALL      'AODEALR1'                                                BUG6270
     C                   PARM      '*DBERR '     @RTCD             7                         BUG6270
     C                   PARM      '*FIRST '     @OPTN             7                         BUG6270
     C     SDDEAL        PARM      SDDEAL        DSSDY                                       BUG6270
      *                                                                                      BUG6270
      * DATABASE ERROR                                                                       BUG6270
      *                                                                                      BUG6270
     C     @RTCD         IFNE      *BLANK                                                    BUG6270
     C                   MOVEL     @OPTN         DBKEY                                       BUG6270
     C                   MOVEL     'SDDEALPD'    DBFILE                                      BUG6270
     C                   MOVEL     '903'         DBASE                                       BUG6270
     C                   EXSR      *PSSR                                                     BUG6270
     C                   END                                                                 BUG6270
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
