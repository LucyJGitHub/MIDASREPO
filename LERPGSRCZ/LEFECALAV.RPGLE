     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Calculate fees based on average balances')    *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module.                             *
      *                                                               *
      *  LEFECALAV -  Calculate fees based on average balances        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR674226           Date 04Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 239961             Date 19Jun06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG6944            Date 27Jun05               *
      *                 222373             Date 30Oct03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP072             Date 02Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR674226 - Manual transaction reached 999. Increase the size *
      *             of utilisation sequence no. and transaction       *
      *             sequence. (Child: AR674227)                       *
      *           - Applied for MD054782.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  239961 - Accrued to date is one day excess because end date  *
      *           used is run date not last fee accrual control date  *
      *           or fee start date whichever is applicable. Applied  *
      *           fix 237745.                                         *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG6944- Incorrect total accrued to date for newly inserted  *
      *           fees based on actual amounts when there is a        *
      *           movement for the facility in PF/FACHISA.            *
      *  222373 - Parameter Mismatch                                  *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFCLTYL1   IF   E           K DISK    INFSR(*PSSR)
     FFACHISH   IF   E           K DISK    INFSR(*PSSR)
     FFACHSAL1  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
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
      /SPACE 5
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
 
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWER ARRAY
     D TABCAL          S              1  0 DIM(6) CTDATA PERRCD(6)              CALC.BASES
     D TABCBS          S              5  0 DIM(6) ALT(TABCAL)
 
     D FAM             S             13  0 DIM(5) ASCEND                        FEE AMOUNTS
     D FPC             S              6  3 DIM(5) ASCEND                        FEE PERCENTAGE
 
      * Fee amounts data structure
     D  @FEAMA         DS
     D  FEAMT1                 1     11  0
     D  FEAMT2                12     22  0
     D  FEAMT3                23     33  0
     D  FEAMT4                34     44  0
     D  FEAMT5                45     55  0
     D  FEAM                   1     55  0
     D                                     DIM(5) ASCEND                        FEE AMOUNTS
 
      * Fee rates data structure
     D  @FRTA          DS
     D  FEFRT1                 1      7  5
     D  FEFRT2                 8     14  5
     D  FEFRT3                15     21  5
     D  FEFRT4                22     28  5
     D  FEFRT5                29     35  5
     D  FRT                    1     35  5
     D                                     DIM(5) ASCEND                        FEE RATES
 
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      * Key fields
 
     C                   MOVEL     FcbrBranch    K#BRCA
     C                   MOVEL     S#CSSN        K#CNUM
     C                   MOVEL     S#FACT        K#FACT
     C                   MOVEL     S#FCNO        K#FCNO
 
     C                   MOVEL     S#FACT        K#FACL            5 0
     C                   MOVE      S#FCNO        K#FACL
 
     C**********         MOVE      S#FSEQ        STFSEQ            3 0                      AR674226
     C                   MOVE      S#FSEQ        STFSEQ            4 0                      AR674226
 
      * Initialise outputs
 
     C                   Z-ADD     *ZERO         W#FEE
 
      * Determine whether the facility has been entered today
      * (Exit if the facility is not found)
 
     C     KFCLTY        CHAIN     FCLTYFMF                           80
     C     *IN80         IFEQ      *ON
     C                   RETURN
     C                   ENDIF
 
     C     ORED          IFNE      BJRDNB
     C                   SETON                                        43
     C                   ELSE
     C                   SETOFF                                       43
     C                   ENDIF
 
      * If the facility was not entered today
      * get the original facility details from facility history header.
      * (Exit if the facility history header is not found)
 
     C     *IN43         IFEQ      *ON
     C     FACHISHK      CHAIN     FACHISH                            80
     C     *IN80         IFEQ      *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     0             W#AMT            13 0
     C                   Z-ADD     0             W#PCT             6 3
 
      *  Set up Start and End dates
 
     C                   Z-ADD     FELPDT        STDATE            5 0    46
     C   46              Z-ADD     FEPSTD        STDATE
     C**********         Z-ADD     BJRDNB        ENDATE            5 0                        239961
      *                                                                                       239961
      ** If fee has started accruing, use fee's last accrual date, else                       239961
      ** use fee start date, i.e. no accrued to date yet.                                     239961
      *                                                                                       239961
     C     FELADT        Ifgt      *Zeros                                                     239961
     C                   Z-add     FELADT        ENDATE            5 0                        239961
     C                   Else                                                                 239961
     C                   Z-add     FEPSTD        ENDATE                                       239961
     C                   Endif                                                                239961
      *                                                                                       239961
     C*****FEPEND        IFLE      BJRDNB                                                     239961
     C**********         Z-ADD     FEPEND        ENDATE                                       239961
     C**********         END                                                                  239961
 
      *  For Actual amount fees, need to accrue for today to add to
      *  accrued to date amount on file.
 
     C     BJRDNB        IFNE      FEPEND
     C     BJRDNB        ANDNE     FELPDT
     C     FECALT        IFEQ      '04'
     C     FECALT        OREQ      '05'
     C     FECALT        OREQ      '06'
     C     FECALT        OREQ      '14'
     C     FECALT        OREQ      '15'
     C     FECALT        OREQ      '16'
     C     FECALT        OREQ      '22'
     C                   Z-ADD     FELADT        STDATE
     C     STDATE        IFEQ      0
     C                   Z-ADD     FEPSTD        STDATE
     C                   END
     C                   END
     C                   END
 
      * Obtain number of days to use.
 
     C                   Z-ADD     STDATE        ZZBEG
     C                   Z-ADD     ENDATE        ZZEND
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      ZINTDY
     C                   Z-ADD     ZZINDY        W#DAYS            5 0
 
      * Get starting amount from facility history file
 
     C**********         Z-ADD     *ZERO         FACNUM                                       CSD027
     C                   EVAL      FACNUM = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         FAFCTY
     C                   Z-ADD     *ZERO         FADATE
     C                   Z-ADD     *ZERO         FAFSEQ
     C     FACHSAKF      SETGT     FACHSAL1                           47
     C                   READP     FACHSAL1                               45
     C     K#CNUM        IFEQ      FACNUM
     C     K#FACL        ANDEQ     FAFCTY
     C*****STDATE        ANDEQ     FADATE                                                    BUG6944
     C*****STFSEQ        ANDEQ     FATSEQ                                                    BUG6944
 
      * Set up current facility amount from file.
 
      * Set up amount for accrual according to calculation type.
      * Calculation types 01 to 06 use available facility amount,
      * types 11 to 16 use outstanding facility amount and
      * types 21 and 22 use the current facility amount.
 
     C     FECALT        IFEQ      '01'
     C     FECALT        OREQ      '02'
     C     FECALT        OREQ      '03'
     C     FECALT        OREQ      '04'
     C     FECALT        OREQ      '05'
     C     FECALT        OREQ      '06'
     C     FAUNDR        IFGE      0
     C                   Z-ADD     FAUNDR        AAMT             13 0
     C                   ELSE
     C                   Z-ADD     0             AAMT
     C                   END
     C                   ELSE
     C     FECALT        IFEQ      '11'
     C     FECALT        OREQ      '12'
     C     FECALT        OREQ      '13'
     C     FECALT        OREQ      '14'
     C     FECALT        OREQ      '15'
     C     FECALT        OREQ      '16'
     C                   Z-ADD     FADRAM        AAMT
     C                   ELSE
     C     FECALT        IFEQ      '21'
     C     FECALT        OREQ      '22'
     C                   Z-ADD     FACFAM        AAMT
     C                   END
     C                   END
     C                   END
     C                   ELSE
     C                   Z-ADD     FAMT          AAMT
     C                   ENDIF
     C*                                                                                      BUG6944
     C** Initialise work fee field.                                                          BUG6944
     C*                                                                                      BUG6944
     C                   Z-ADD     0             W#FEE                                       BUG6944
     C                   Z-ADD     0             W#TOT                                       BUG6944
     C                   MOVE      '0'           *IN19             1                         BUG6944
 
      * Read file until date read is greater than date of end of this
      * accrual period. NDAYS is the number of days in this accrual.
 
     C                   MOVE      '0'           *IN48
     C     *IN48         DOWEQ     '0'
     C     FACHSAKP      READE     FACHSAL1                               48
 
     C     *IN48         IFEQ      '1'
     C     FADATE        ORGT      ENDATE
     C                   Z-ADD     ENDATE        FADATE
     C                   MOVE      '1'           *IN48
     C                   END
 
     C                   Z-ADD     STDATE        ZZBEG
     C                   Z-ADD     FADATE        ZZEND
     C                   MOVE      FECALC        ZZCALC
     C                   EXSR      ZINTDY
     C                   Z-ADD     ZZINDY        NDAYS             5 0
 
     C     NDAYS         IFGT      0
 
      * Average amount used (only does accrual once)
 
      *                                                                                      BUG6944
      ** limit the processing for fees based on average amount                               BUG6944
      *                                                                                      BUG6944
     C     FECALT        IFEQ      '01'                                                      BUG6944
     C     FECALT        OREQ      '02'                                                      BUG6944
     C     FECALT        OREQ      '03'                                                      BUG6944
     C     FECALT        OREQ      '11'                                                      BUG6944
     C     FECALT        OREQ      '12'                                                      BUG6944
     C     FECALT        OREQ      '13'                                                      BUG6944
     C     FECALT        OREQ      '21'                                                      BUG6944
     C                   MULT      NDAYS         AAMT
     C                   DIV(H)    W#DAYS        AAMT
     C                   ADD       AAMT          W#AMT
     C                   ELSE                                                                BUG6944
     C                   Z-ADD     AAMT          W#AMT                                       BUG6944
     C                   ENDIF                                                               BUG6944
     C                   Z-ADD     FADATE        STDATE
     C                   END
 
      * Reset amount to accrue - comes from next record on amounts file
 
     C     FECALT        IFEQ      '01'
     C     FECALT        OREQ      '02'
     C     FECALT        OREQ      '03'
     C     FECALT        OREQ      '04'                                                      BUG6944
     C     FECALT        OREQ      '05'                                                      BUG6944
     C     FECALT        OREQ      '06'                                                      BUG6944
     C     FAUNDR        IFGE      0
     C                   Z-ADD     FAUNDR        AAMT
     C                   ELSE
     C                   Z-ADD     0             AAMT
     C                   END
     C                   ELSE
     C     FECALT        IFEQ      '11'
     C     FECALT        OREQ      '12'
     C     FECALT        OREQ      '13'
     C     FECALT        OREQ      '14'                                                      BUG6944
     C     FECALT        OREQ      '15'                                                      BUG6944
     C     FECALT        OREQ      '16'                                                      BUG6944
     C                   Z-ADD     FADRAM        AAMT
     C                   ELSE
     C     FECALT        IFEQ      '21'
     C     FECALT        OREQ      '22'                                                      BUG6944
     C                   Z-ADD     FACFAM        AAMT
     C                   END
     C                   END
     C                   END
      *                                                                                      BUG6944
     C     FECALT        IFEQ      '04'                                                      BUG6944
     C     FECALT        OREQ      '05'                                                      BUG6944
     C     FECALT        OREQ      '06'                                                      BUG6944
     C     FECALT        OREQ      '14'                                                      BUG6944
     C     FECALT        OREQ      '15'                                                      BUG6944
     C     FECALT        OREQ      '16'                                                      BUG6944
     C     FECALT        OREQ      '22'                                                      BUG6944
     C                   EXSR      ACCRUE                                                    BUG6944
     C                   ADD       W#TOT         W#FEE                                       BUG6944
     C                   ENDIF                                                               BUG6944
      *                                                                                      BUG6944
     C                   END
 
     C     FECALT        IFEQ      '01'                                                      BUG6944
     C     FECALT        OREQ      '02'                                                      BUG6944
     C     FECALT        OREQ      '03'                                                      BUG6944
     C     FECALT        OREQ      '11'                                                      BUG6944
     C     FECALT        OREQ      '12'                                                      BUG6944
     C     FECALT        OREQ      '13'                                                      BUG6944
     C     FECALT        OREQ      '21'                                                      BUG6944
     C                   MOVE      '1'           *IN19                                       BUG6944
     C                   EXSR      ACCRUE
     C                   Z-ADD     W#TOT         W#FEE
     C                   ENDIF                                                               BUG6944
 
      * Forward valued fees should have zero total accrued amount
 
     C     FEPSTD        IFGT      BJRDNB
     C                   Z-ADD     0             W#FEE
     C                   END
 
      * Return
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *  CALCULATE ACCRUAL AMOUNT
      *****************************************************************
     C     ACCRUE        BEGSR
 
     C                   Z-ADD     0             W#TOT            13 0
 
      ** Calculate percentage if required.
      ** Use original facility amount for average.
 
     C     FEPIND        IFNE      'A'
     C   43W#AMT         DIV(H)    FHOFAM        WRK155           15 5
     C  N43W#AMT         DIV(H)    FAMT          WRK155
     C     WRK155        MULT      100           W#PCT
     C   43              Z-ADD     FHOFAM        W#AMT
     C  N43              Z-ADD     FAMT          W#AMT
     C     W#PCT         IFGT      100
     C                   Z-ADD     100           W#PCT
     C                   END
     C                   END
 
      * Convert from facility to fee currency if required.
      * If exchange rate field on fees master file is blank
      * obtain cross-currency exchange rate for these
      * two currencies from the standing data files otherwise use
      * exchange rate on fees master file.
 
     C     FHFCCY        IFNE      FEFCCY
     C     *IN43         ANDEQ     *ON
     C     FCCY          ORNE      FEFCCY
     C     *IN43         ANDEQ     *OFF
     C                   Z-ADD     W#AMT         W#CAMT           13 0
     C     FEERAT        IFEQ      0
     C   43              MOVE      FHFCCY        INCCY             3
     C  N43              MOVE      FCCY          INCCY
     C                   MOVE      FEFCCY        OUTCCY            3
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      INCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   Z-ADD     A6NBDP        ZNBDP1            1 0
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      OUTCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   MOVE      A6MDIN        ZMDI2
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   Z-ADD     A6NBDP        ZNBDP2            1 0
 
      * Obtain cross exchange rate & cross multiply/divide indicator.
 
     C                   EXSR      ZXRATE
 
      * Set up input fields for conversion subroutine.
 
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   Z-ADD     W#CAMT        ZAMTCI
     C                   MOVE      INCCY         ZCCYI
     C                   MOVE      OUTCCY        ZCCYO
     C                   Z-ADD     ZNBDP1        ZCDPI
     C                   Z-ADD     ZNBDP2        ZCDPO
 
     C                   EXSR      ZCONV
 
     C                   Z-ADD     ZAMTCO        W#CAMT
 
      * Exchange rate not blank
 
     C                   ELSE
 
      * Facility history currency decimal places + 4.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FHFCCY        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     A6NBDP        ADD       4             FD                1 0
 
      * Fee currency decimal places + 4.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FEFCCY        @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     A6NBDP        ADD       4             TD                1 0
 
      * Adjust incoming amount for from CCY decimal places.
 
     C     W#CAMT        DIV       POWER(FD)     WRK153           15 3
 
      * Exchange rate conversion.
 
     C     FEMDIN        IFEQ      'M'
     C                   MULT      FEERAT        WRK153
     C                   ELSE
     C                   DIV(H)    FEERAT        WRK153
     C                   END
 
      * Adjust calculated amount for to currency decimal places.
 
     C     WRK153        MULT      POWER(TD)     W#CAMT
 
     C                   END
     C                   Z-ADD     W#CAMT        W#AMT
     C                   END
 
      * Look up factor for division corresponding to calc. basis
 
     C     FECALC        LOOKUP    TABCAL        TABCBS                   54
     C                   MOVE      TABCBS        W#CLBS            5 0
 
      * Fee currency decimal places + 4.
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FEFCCY        @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     A6NBDP        ADD       4             FeeCDP            1 0
 
      * TIERED CALCULATION:
      * ------------------
 
     C     FECALT        IFEQ      '01'
     C     FECALT        OREQ      '04'
     C     FECALT        OREQ      '11'
     C     FECALT        OREQ      '14'
 
      * Amount (not percentage)
 
     C     FEPIND        IFEQ      'A'
 
      * Convert limit amounts for fee decimal places.
 
     C     FEAM          MULT      POWER(FeeCDP) FAM
     C                   Z-ADD     0             W#FAM            13 0
     C                   Z-ADD     W#AMT         W#OAMT           13 0
     C                   Z-ADD     1             X                 3 0
     C     W#AMT         DOWGT     0
     C     X             ANDLT     6
 
     C     W#OAMT        IFLT      FAM(X)
     C     FAM(X)        OREQ      0
     C     W#AMT         MULT      FRT(X)        WRK15
     C                   ELSE
     C     FAM(X)        SUB       W#FAM         WRK15
     C                   MULT      FRT(X)        WRK15
     C                   END
     C                   ADD       WRK15         W#TOT
     C                   SUB       FAM(X)        W#AMT
     C                   ADD       W#FAM         W#AMT
     C                   Z-ADD     FAM(X)        W#FAM
 
     C                   ADD       1             X
 
     C                   END
 
      * Calculate final accrual amount.
 
     C     *IN19         IFEQ      '1'                                                       BUG6944
      *                                                                                      BUG6944
      ** if based on average use WDAYS                                                       BUG6944
      *                                                                                      BUG6944
     C                   MULT      W#DAYS        W#TOT
     C                   ELSE                                                                BUG6944
     C                   MULT      NDAYS         W#TOT                                       BUG6944
     C                   ENDIF                                                               BUG6944
     C                   DIV(H)    W#CLBS        W#TOT
 
     C                   ELSE
 
      * - PERCENTAGE:
 
     C     FEAM          DIV       1000          FPC
 
     C                   Z-ADD     0             W#FPC             6 3
     C                   Z-ADD     W#PCT         W#OPCT            6 3
     C                   Z-ADD     1             X
     C     W#PCT         DOWGT     0
     C     X             ANDLT     6
 
     C     W#OPCT        IFLT      FPC(X)
     C     FPC(X)        OREQ      0
     C     W#AMT         MULT      W#PCT         WRK15
     C                   ELSE
     C     FPC(X)        SUB       W#FPC         WRK63             6 3
     C     W#AMT         MULT      WRK63         WRK15            15 0
     C                   END
     C                   MULT      FRT(X)        WRK15
     C                   DIV(H)    100           WRK15
     C                   ADD       WRK15         W#TOT
     C                   SUB       FPC(X)        W#PCT
     C                   ADD       W#FPC         W#PCT
     C                   Z-ADD     FPC(X)        W#FPC
 
     C                   ADD       1             X
 
     C                   END
 
      * Calculate final accrual amount.
 
     C     *IN19         IFEQ      '1'                                                       BUG6944
      *                                                                                      BUG6944
     C                   MULT      W#DAYS        W#TOT
     C                   ELSE                                                                BUG6944
     C                   MULT      NDAYS         W#TOT                                       BUG6944
     C                   ENDIF                                                               BUG6944
     C                   DIV(H)    W#CLBS        W#TOT
 
     C                   END
 
     C                   END
 
      * THRESHOLD CALCULATION:
      * ---------------------
 
     C     FECALT        IFEQ      '02'
     C     FECALT        OREQ      '05'
     C     FECALT        OREQ      '12'
     C     FECALT        OREQ      '15'
 
      * - AMOUNT:
 
     C     FEPIND        IFEQ      'A'
 
      * Convert limit amounts for fee decimal places.
 
     C     FEAM          MULT      POWER(FeeCDP) FAM
 
      * Search amount array to find value larger or equal.
 
     C                   Z-ADD     1             X
 
     C     W#AMT         LOOKUP    FAM(X)                             54  54
     C     *IN54         IFEQ      '0'
     C                   EXSR      LSTRAT
     C                   END
 
     C     *IN54         IFEQ      '0'
     C     Y             ANDEQ     0
     C                   MULT      0             W#AMT
     C                   ELSE
     C                   MULT      FRT(X)        W#AMT
     C                   END
 
     C     *IN19         IFEQ      '1'                                                       BUG6944
      *                                                                                      BUG6944
     C     W#AMT         MULT      W#DAYS        W#TOT
     C                   ELSE                                                                BUG6944
     C     W#AMT         MULT      NDAYS         W#TOT                                       BUG6944
     C                   ENDIF                                                               BUG6944
     C                   DIV(H)    W#CLBS        W#TOT
 
     C                   ELSE
 
      * - PERCENTAGE:
 
     C     FEAM          DIV       1000          FPC
 
      * Search percentage array to find value larger or equal.
 
     C                   Z-ADD     1             X
     C     W#PCT         LOOKUP    FPC(X)                             54  54
     C     *IN54         IFEQ      '0'
     C                   EXSR      LSTRAT
     C                   END
     C                   MULT      W#PCT         W#AMT
 
     C     *IN54         IFEQ      '0'
     C     Y             ANDEQ     0
     C                   MULT      0             W#AMT
     C                   ELSE
     C                   MULT      FRT(X)        W#AMT
     C                   END
 
     C                   DIV(H)    100           W#AMT
     C     *IN19         IFEQ      '1'                                                       BUG6944
      *                                                                                      BUG6944
     C     W#AMT         MULT      W#DAYS        W#TOT
     C                   ELSE                                                                BUG6944
     C     W#AMT         MULT      NDAYS         W#TOT                                       BUG6944
     C                   ENDIF                                                               BUG6944
     C                   DIV(H)    W#CLBS        W#TOT
 
     C                   END
 
     C                   END
 
      * SINGLE CALCULATION:
      * ------------------
 
     C     FECALT        IFEQ      '03'
     C     FECALT        OREQ      '06'
     C     FECALT        OREQ      '13'
     C     FECALT        OREQ      '16'
     C     FECALT        OREQ      '21'
     C     FECALT        OREQ      '22'
 
     C     W#AMT         MULT      FRT(1)        W#TOT
     C     *IN19         IFEQ      '1'                                                       BUG6944
      *                                                                                      BUG6944
     C                   MULT      W#DAYS        W#TOT
     C                   ELSE                                                                BUG6944
     C                   MULT      NDAYS         W#TOT                                       BUG6944
     C                   ENDIF                                                               BUG6944
     C                   DIV(H)    W#CLBS        W#TOT
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * FIND LAST RATE
      *****************************************************************
     C     LSTRAT        BEGSR
     C                   Z-ADD     5             Y                 2 0
     C     Y             DOWGT     0
     C     FEAM(Y)       IFEQ      0
     C     FRT(Y)        ANDNE     0
     C                   Z-ADD     Y             X
     C                   Z-ADD     0             Y
     C                   END
     C                   SUB       1             Y
     C                   END
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZINTDY        BEGSR
     C                   CALLB     'ZINTDY'
     C                   PARM                    RetCodeOut       10
     C                   PARM                    ZZINDY            5 0
     C                   PARM                    ZZBEG             5 0
     C                   PARM                    ZZEND             5 0
     C                   PARM                    ZZCALC            1
     C**********         PARM                    INT6DY           15 7                 222373 242286
     C                   PARM                    INT6DY           15 9                        242286
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZXRATE        BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM      *ZEROS        ZRATEX           13 8
     C                   PARM      *BLANKS       ZMDIX             1
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
     C     ZCONV         BEGSR
     C                   CALLB     'ZCONV'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
 
      * Branch, customer, facility type, facility number
      * and fee sequence number
     C                   PARM                    FcbrBranch        3
     C                   PARM                    S#CSSN           10
     C                   PARM                    S#FACT            3
     C                   PARM                    S#FCNO            2
     C                   PARM                    S#FSEQ            2
 
      * Fee details
      * -----------
      * Last Payment Date
      * Last Accrual Date
      * Period Start Date
      * Period End Date
      * Fee Calculation type
      * Calculation basis
      * Percent Indicator
      * Fee currency
      * Exchange rate
      * Multiply/Divide indicator
      * Fee amounts x 5
      * Fee rates x 5
     C                   PARM                    FELPDT            5 0
     C                   PARM                    FELADT            5 0
     C                   PARM                    FEPSTD            5 0
     C                   PARM                    FEPEND            5 0
     C                   PARM                    FECALT            2
     C                   PARM                    FECALC            1 0
     C                   PARM                    FEPIND            1
     C                   PARM                    FEFCCY            3
     C                   PARM                    FEERAT           13 8
     C                   PARM                    FEMDIN            1
     C                   PARM                    @FEAMA
     C                   PARM                    @FRTA
      *
      * OUTPUTS
      *
      * Fee amount
     C                   PARM                    W#FEE            13 0
 
      *
      ** Access Bank Detailes
      *  ~~~~~~~~~~~~~~~~~~~~
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     *LIKE         DEFINE    BRCA          K#BRCA
     C     *LIKE         DEFINE    CNUM          K#CNUM
     C     *LIKE         DEFINE    FACT          K#FACT
     C     *LIKE         DEFINE    FCNO          K#FCNO
     C     *LIKE         DEFINE    FAFCTY        K#FACL
 
      ** Key lists
 
     C     KFCLTY        KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C     FACHISHK      KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACT
     C                   KFLD                    K#FCNO
     C     FACHSAKF      KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
     C                   KFLD                    STDATE
     C                   KFLD                    STFSEQ
     C     FACHSAKP      KLIST
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#FACL
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**   TABCAL/TABCBS - CALCULATION BASES.
136500236000336000436500536000636600
