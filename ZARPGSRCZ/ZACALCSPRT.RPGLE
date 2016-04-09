     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Calculate Final Spread Rate')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Common Processing                                    *
      *                                                               *
      *  ZACALCSPRT - Midas ZA Calculate Final Spread Rate            *
      *                                                               *
      *  Function:  This program will accept interest rate rounding   *
      *             rules as parameters and return the new spread     *
      *             rate based on the rounding rules passed.          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2010            *
      *                                                               *
      *  Last Amend No. CRE083AU           Date 06Aug12               *
      *  Prev Amend No. AR947093           Date 26Apr12               *
      *                 AR944839           Date 31Mar12               *
      *                 AR943988           Date 29Mar12               *
      *                 AR847249           Date 11Jan12               *
      *                 AR847292           Date 14Oct11               *
      *                 CRE073   *CREATE   Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE083AU - COB Restructure - RE COB Optimisation Phase 1     *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR944839 - Incorrect calculated spread when rate can not be  *
      *             rounded                                           *
      *  AR943988 - Error message that 0 or negative interest rate    *
      *             appears even if the rate should be positive       *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR847292 - Derived at zero interest as a result of rounding  *
      *             process                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
     D RatCod          S              4    DIM(62) CTDATA PERRCD(1)
     D RatVal          S             11    DIM(62) ALT(RatCod)
     D WRatVal         S             11  7 DIM(62)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D PRetCode        S              7
     D PBaserate       S             11  7
     D PConSpread      S             11  7
     D PConInd         S              1
     D PRoundMth       S              7
     D PFracDeci       S              4
     D PNewSpread      S             11  7
     D PFinalRate      S             11  7                                                  AR847249
 
      ** Work variables
     D WRoundRule      S              8
     D WFinRate        S             11  7
     D WUnrounded      S             11  7
     D WRounded        S             11  7
     D WFracRate       S             11  7
     D WholeRate       S             11  0
     D WLowerDiff      S             11  7
     D WUpperDiff      S             11  7
     D WDiffDown       S             11  7
     D WDiffUp         S             11  7
     D WRoundUp        S             11  7
     D WRoundDwn       S             11  7
     D WRun            S              1
     D Ix              S              2  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      ** Main processing to compute rate and spread
      *
     C                   EXSR      SRInit                                                   CRE083AU
     C                   EXSR      SRMain
      *
      ** Return to the calling program
      *
     C**********         EVAL      *INLR = *ON                                              CRE083AU
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main Processing                                     *
      *                                                               *
      *****************************************************************
 
     C     SRMain        BEGSR
      *
      ** When Rounding Method is blank while Rounding Frac/Dec is non-blank
      ** or Rounding Method is non-blank while Rounding Frac/Dec is blank
      *
     C                   IF        ((PRoundMth = 'NONE' OR
     C                             PRoundMth = *BLANKS) AND
     C                             (PFracDeci <> 'NONE' AND
     C                             PFracDeci <> *BLANKS)) OR
     C                             ((PRoundMth <> 'NONE' AND
     C                             PRoundMth <> *BLANKS) AND
     C                             (PFracDeci = 'NONE' OR
     C                             PFracDeci = *BLANKS))
     C                   EVAL      PNewSpread = 0
     C                   EVAL      PRetCode = '*ERROR'
     C**********         EVAL      *INLR = *ON                                              CRE083AU
     C                   RETURN
     C                   ENDIF
      *
      ** When Rounding Method and Rounding Frac/Dec are blanks
      *
     C                   IF        (PRoundMth = 'NONE' OR
     C                             PRoundMth = *BLANKS) AND
     C                             (PFracDeci = 'NONE' OR
     C                             PFracDeci = *BLANKS)
     C                   EVAL      PNewSpread = PConSpread
     C**********         EVAL      *INLR = *ON                                              CRE083AU
     C                   RETURN
     C                   ENDIF
      *
      ** When Base Rate is zero
      *
     C                   IF        PBaserate = *ZERO AND
     C                             PConSpread = *ZERO
     C                   EVAL      PNewSpread = 0
     C                   EVAL      PRetCode = '*ERROR'
     C**********         EVAL      *INLR = *ON                                              CRE083AU
     C                   RETURN
     C                   ENDIF
      *
     C                   IF        PBaserate = *ZERO AND
     C                             PConSpread <> 0 AND
     C                             PConInd    = 'P'
     C                   EVAL      PNewSpread = 0
     C                   EVAL      PRetCode = '*ERROR'
     C**********         EVAL      *INLR = *ON                                              CRE083AU
     C                   RETURN
     C                   ENDIF
      *
      ** Set Rounding Rules
      *
     C                   IF        PFracDeci = '1/32' OR PFracDeci = '1/16'
     C                             OR PFracDeci = '1/8' OR PFracDeci = '1/4'
     C                             OR PFracDeci = '1/2'
     C                   EVAL      WRoundRule = 'FRACTION'
      *
     C                   ELSEIF    PFracDeci = '0' OR PFracDeci = '1' OR
     C                             PFracDeci = '2' OR PFracDeci = '3' OR
     C                             PFracDeci = '4' OR PFracDeci = '5'
     C                   EVAL      WRoundRule = 'DECIMAL '
     C                   ENDIF
      *
      ** Calculate Unrounded Rate
      *
     C                   IF        PConInd = '+' OR PConInd = 'A'
     C                             OR PConInd = ' '
     C                   EVAL      WUnrounded = PBaserate + PConSpread
      *
     C                   ELSEIF    PConInd = '-' OR PConInd = 'S'
     C                   EVAL      WUnrounded = PBaserate - PConSpread
      *
     C                   ELSEIF    PConInd = 'P'
     C**********         EVAL(H)   WUnrounded = PBaserate +                                 AR847249
     C**********                                (PBaserate * PConSpread) / 100              AR847249
     C                   EVAL(H)   WUnrounded = (PBaserate * PConSpread) / 100              AR847249
     C                   ENDIF
      *
      ** Calculate Final Rate for FRACTION rounding rule
      *
     C                   IF        WRoundRule = 'FRACTION'
     C                   EVAL      WFracRate = WUnrounded - %INT(WUnrounded)
     C                   EVAL      WFracRate = %ABS(WFracRate)
     C                   EVAL      WholeRate = %INT(WUnrounded)
     C                   EVAL      WholeRate = %ABS(WholeRate)                              AR947093
     C                   EVAL      WRatVal = %DEC(RatVal : 11 : 7)
     C                   Z-ADD     1             Ix
      *
     C     Ix            DOWLE     62
      *
      ** For range in rate table
      *
     C                   IF        WFracRate >= WRatVal(Ix) AND
     C                             WFracRate <= WRatVal(Ix + 1) AND
     C                             RatCod(Ix) =  PFracDeci
     C                   IF        WFracRate = WRatVal(Ix)
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   LEAVE
     C                   ELSEIF    WFracRate = WRatVal(Ix + 1)
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   LEAVE
     C                   ELSE
     C                   SELECT
     C                   WHEN      PRoundMth = 'UP'
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   WHEN      PRoundMth = 'DOWN'
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   WHEN      PRoundMth = 'NEAREST'
     C                   EVAL      WLowerDiff = WFracRate - WRatVal(Ix)
     C                   EVAL      WUpperDiff = %ABS(WFracRate -
     C                                               WRatVal(Ix + 1))
     C                   IF        WLowerDiff = WUpperDiff
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   ELSEIF    WLowerDiff < WUpperDiff
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   ELSE
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   ENDIF
     C                   ENDSL
     C                   LEAVE
     C                   ENDIF
      *
      ** Check 1: For range not in rate table
      *
     C                   ELSEIF     WFracRate >= WRatVal(Ix + 1) AND
     C                              WFracRate <= WRatVal(Ix + 2) AND
     C                              RatCod(Ix) =  PFracDeci
     C                   IF        WFracRate = WRatVal(Ix + 1)
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   LEAVE
     C                   ELSEIF    WFracRate = WRatVal(Ix + 2)
     C                   EVAL      WRounded = WRatVal(Ix + 2)
     C                   LEAVE
     C                   ELSE
     C                   SELECT
     C                   WHEN      PRoundMth = 'UP'
     C                   EVAL      WRounded = WRatVal(Ix + 2)
     C                   WHEN      PRoundMth = 'DOWN'
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   WHEN      PRoundMth = 'NEAREST'
     C                   EVAL      WLowerDiff = WFracRate - WRatVal(Ix + 1)
     C                   EVAL      WUpperDiff = %ABS(WRatVal(Ix + 2)
     C                                               - WFracRate)
     C                   IF        WLowerDiff = WUpperDiff
     C                   EVAL      WRounded = WRatVal(Ix + 2)
     C                   ELSEIF    WLowerDiff < WUpperDiff
     C                   EVAL      WRounded = WRatVal(Ix + 1)
     C                   ELSE
     C                   EVAL      WRounded = WRatVal(Ix + 2)
     C                   ENDIF
     C                   ENDSL
     C                   LEAVE
     C                   ENDIF
      *
      ** Check 2: For range not in rate table
      *
     C                   ELSEIF     WFracRate >= 0 AND
     C                              WFracRate <= WRatVal(Ix) AND
     C                              RatCod(Ix) =  PFracDeci
     C                   IF        WFracRate = 0
     C                   EVAL      WRounded = 0
     C                   LEAVE
     C                   ELSEIF    WFracRate = WRatVal(Ix)
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   LEAVE
     C                   ELSE
     C                   SELECT
     C                   WHEN      PRoundMth = 'UP'
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   WHEN      PRoundMth = 'DOWN'
     C                   EVAL      WRounded = 0
     C                   WHEN      PRoundMth = 'NEAREST'
     C                   EVAL      WLowerDiff = WFracRate - 0
     C                   EVAL      WUpperDiff = %ABS(WRatVal(Ix)
     C                                               - WFracRate)
     C                   IF        WLowerDiff = WUpperDiff
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   ELSEIF    WLowerDiff < WUpperDiff
     C                   EVAL      WRounded = 0
     C                   ELSE
     C                   EVAL      WRounded = WRatVal(Ix)
     C                   ENDIF
     C                   ENDSL
     C                   LEAVE
     C                   ENDIF
     C
     C                   ENDIF
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
     C                   IF        WUnrounded >= 0
     C                   EVAL      WFinRate = WholeRate + WRounded
     C                   ELSE
     C**********         EVAL      WFinRate = WholeRate - WRounded                          AR947093
     C                   EVAL      WFinRate = (WholeRate + WRounded) * (-1)                 AR947093
     C                   ENDIF
     C                   EVAL      PFinalRate = WFinRate                                    AR847249
      *                                                                                     AR847292
     C**********         IF        WFinRate = 0                                    AR847292 AR847249
     C**********         IF        WFinRate <= 0                                   AR847249 AR947093
     C**********         EVAL      WFinRate = WUnrounded                           AR847292 AR944839
      ** No rounding is done when there is no possible value                                AR944839
     C**********         EVAL      PFinalRate = WUnrounded                         AR944839 AR947093
     C**********         EVAL      PNewSpread = PConSpread                         AR944839 AR947093
     C**********         LEAVESR                                                   AR944839 AR947093
     C**********         ENDIF                                                     AR847292 AR947093
 
     C                   ELSE
      *
      ** Calculate Final Rate for DECIMAL rounding rule
      *
     C                   SELECT
     C                   WHEN      PFracDeci = '0'
     C                   EVAL      WRoundDwn=%DEC(WUnrounded : 11 : 0)
     C                   IF        (WUnrounded - WRoundDwn) = 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 0)
     C                   ELSE
     C                   IF        WUnrounded > 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 0) + 1
     C                   ELSE
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 0) - 1
     C                   ENDIF
     C                   ENDIF
     C                   WHEN      PFracDeci = '1'
     C                   EVAL      WRoundDwn=%DEC(WUnrounded : 11 : 1)
     C                   IF        (WUnrounded - WRoundDwn) = 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 1)
     C                   ELSE
     C                   IF        WUnrounded > 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 1) + 0.1
     C                   ELSE
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 1) - 0.1
     C                   ENDIF
     C                   ENDIF
     C                   WHEN      PFracDeci = '2'
     C                   EVAL      WRoundDwn=%DEC(WUnrounded : 11 : 2)
     C                   IF        (WUnrounded - WRoundDwn) = 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 2)
     C                   ELSE
     C                   IF        WUnrounded > 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 2) + 0.01
     C                   ELSE
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 2) - 0.01
     C                   ENDIF
     C                   ENDIF
     C                   WHEN      PFracDeci = '3'
     C                   EVAL      WRoundDwn=%DEC(WUnrounded : 11 : 3)
     C                   IF        (WUnrounded - WRoundDwn) = 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 3)
     C                   ELSE
     C                   IF        WUnrounded > 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 3) + 0.001
     C                   ELSE
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 3) - 0.001
     C                   ENDIF
     C                   ENDIF
     C                   WHEN      PFracDeci = '4'
     C                   EVAL      WRoundDwn=%DEC(WUnrounded : 11 : 4)
     C                   IF        (WUnrounded - WRoundDwn) = 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 4)
     C                   ELSE
     C                   IF        WUnrounded > 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 4) + 0.0001
     C                   ELSE
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 4) - 0.0001
     C                   ENDIF
     C                   ENDIF
     C                   WHEN      PFracDeci = '5'
     C                   EVAL      WRoundDwn=%DEC(WUnrounded : 11 : 5)
     C                   IF        (WUnrounded - WRoundDwn) = 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 5)
     C                   ELSE
     C                   IF        WUnrounded > 0
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 5) + 0.00001
     C                   ELSE
     C                   EVAL      WRoundUp=%DEC(WUnrounded : 11 : 5) - 0.00001
     C                   ENDIF
     C                   ENDIF
     C                   ENDSL
      *
     C                   IF        PRoundMth = 'UP'
     C                   EVAL      WFinRate = WRoundUp
      *
     C                   ELSEIF    PRoundMth = 'DOWN'
     C                   EVAL      WFinRate = WRoundDwn
      *
     C                   ELSEIF    PRoundMth = 'NEAREST'
     C                   EVAL      WDiffDown = %ABS(WUnrounded - WRoundDwn)
     C                   EVAL      WDiffUp = %ABS(WUnrounded - WRoundUp)
     C                   IF        WDiffDown = WDiffUp
     C                   EVAL      WFinRate = WRoundUp
     C                   ELSEIF    WDiffDown < WDiffUp
     C                   EVAL      WFinRate = WRoundDwn
     C                   ELSE
     C                   EVAL      WFinRate = WRoundUp
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR847249
     C**********         IF        WFinRate <= 0                                   AR847249 AR947093
     C**********         EVAL      PNewSpread = 0                                  AR847249 AR947093
     C**********         ELSE                                                      AR847249 AR947093
      *
      ** Calculate Final Spread
      *
     C                   IF        PConInd = 'P'
     C**********         EVAL(H)   PNewSpread = ((WFinRate - PBaserate) /                   AR847249
     C**********                                 PBaserate) * 100                           AR847249
     C                   EVAL(H)   PNewSpread = (WFinRate/PBaserate) * 100                  AR847249
     C                   ELSEIF    PConInd = 'A' OR PConInd = '+'
     C                   EVAL      PNewSpread = WFinRate - PBaserate
     C                   ELSEIF    PConInd = 'S' OR PConInd = '-'
     C                   EVAL      PNewSpread = PBaserate - WFinRate
     C                   ENDIF
      ** Set Final Rate                                                                     AR943988
     C                   EVAL      PFinalRate = WFinRate                                    AR943988
     C**********         ENDIF                                                     AR847249 AR947093
      *
     C                   ENDSR
      *****************************************************************                     CRE083AU
      /EJECT                                                                                CRE083AU
      *****************************************************************                     CRE083AU
      *                                                               *                     CRE083AU
      * SRInit - SR. for initialisation after program initial call    *                     CRE083AU
      *                                                               *                     CRE083AU
      *****************************************************************                     CRE083AU
                                                                                            CRE083AU
     C     SRInit        BEGSR                                                              CRE083AU
      *                                                                                     CRE083AU
     C                   EVAL       PRetCode   = *BLANKS                                    CRE083AU
     C                   EVAL       PNewSpread = *ZERO                                      CRE083AU
      *                                                                                     CRE083AU
     C                   ENDSR                                                              CRE083AU
                                                                                            CRE083AU
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRetCode
     C                   PARM                    PBaserate
     C                   PARM                    PConSpread
     C                   PARM                    PConInd
     C                   PARM                    PRoundMth
     C                   PARM                    PFracDeci
     C                   PARM                    PNewSpread
     C                   PARM                    PFinalRate                                 AR847249
      *
     C                   EVAL       PRetCode   = *BLANKS
     C                   EVAL       PNewSpread = *ZERO
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANK
     C                   EVAL      PRetCode = '*ERROR'
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CTDTA RatCod/RatVal
1/320.0312500
1/320.0625000
1/320.0937500
1/320.1250000
1/320.1562500
1/320.1875000
1/320.2187500
1/320.2500000
1/320.2812500
1/320.3125000
1/320.3437500
1/320.3750000
1/320.4062500
1/320.4375000
1/320.4687500
1/320.5000000
1/320.5312500
1/320.5625000
1/320.5937500
1/320.6250000
1/320.6562500
1/320.6875000
1/320.7187500
1/320.7500000
1/320.7812500
1/320.8125000
1/320.8437500
1/320.8750000
1/320.9062500
1/320.9375000
1/320.9687500
1/321.0000000
1/160.0625000
1/160.1250000
1/160.1875000
1/160.2500000
1/160.3125000
1/160.3750000
1/160.4375000
1/160.5000000
1/160.5625000
1/160.6250000
1/160.6875000
1/160.7500000
1/160.8125000
1/160.8750000
1/160.9375000
1/161.0000000
1/8 0.1250000
1/8 0.2500000
1/8 0.3750000
1/8 0.5000000
1/8 0.6250000
1/8 0.7500000
1/8 0.8750000
1/8 1.0000000
1/4 0.2500000
1/4 0.5000000
1/4 0.7500000
1/4 1.0000000
1/2 0.5000000
1/2 1.0000000
