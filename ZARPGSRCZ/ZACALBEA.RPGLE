     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Calculate Base Ccy Equiv - Accounting')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  ZACALBEA _ Calculate Base Ccy Equivalent - Accounting        *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. CAP002   *CREATE   Date 01Aug97               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
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
 
      ** Include the ZA standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @DC             S              4  0 DIM(4) CTDATA PERRCD(4)              Dec.Plcs Correctn
 
      ** External data structure for currency codes file
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
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
      * Initialize output = base currency for accounting equivalent
      *
     C                   Z-ADD     0             @@BCAE                         base ccy a/cing
      *
      * #ZIB -  Calculate accounting base currency equivalent
      *
     C                   EXSR      #ZIB
      *
      * RETURN
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      * #ZIB -  Calculate accounting base currency equivalent
      *****************************************************************
     C     #ZIB          BEGSR
      *
      *   Calculate base currency equivalent for buy currency.
      *
     C     @@MDF1        IFEQ      'M'
     C     @@DAM1        MULT      @SPOT1        @@BYEQ           15 0
     C                   ELSE
     C     @@DAM1        DIV       @SPOT1        @@BYEQ
     C                   END
      *
      * Adjust for base currency decimal places
      *
     C     @BCDP         SUB       @CDP1         @@WDP             3 0
      *
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@BYEQ
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@BYEQ
     C                   END
      *
      *   Calculate base currency equivalent for sell currency
      *
     C     @@MDF2        IFEQ      'M'
     C     @@DAM2        MULT      @SPOT2        @@SLEQ           15 0
     C                   ELSE
     C     @@DAM2        DIV(H)    @SPOT2        @@SLEQ
     C                   END
      *
      * Adjust for base currency decimal places
      *
     C     @BCDP         SUB       @CDP2         @@WDP
     C     @@WDP         IFLT      *ZERO
     C                   Z-SUB     @@WDP         @@WDP
     C                   ADD       1             @@WDP
     C                   DIV(H)    @DC(@@WDP)    @@SLEQ
     C                   ELSE
     C                   ADD       1             @@WDP
     C                   MULT      @DC(@@WDP)    @@SLEQ
     C                   END
      *
      *   Calculate the mean of the buy and sell base currency
      *   equivalents
      *   If sell amount is negative, subtract it from the buy amount
      *   before calculating the average, otherwise add them together.
     C                   IF        @@SLEQ < 0
     C     @@BYEQ        SUB       @@SLEQ        @@BCAE
     C                   ELSE
     C     @@BYEQ        ADD       @@SLEQ        @@BCAE
     C                   ENDIF
 
     C                   DIV(H)    2             @@BCAE
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Parameters passed into the program
      *
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      * buy currency: amount, spot rate, ccy dec. places, M/D ind
      *
     C                   PARM                    @@DAM1           15 0          amount
     C                   PARM                    @SPOT1           13 8          spot rate
     C                   PARM                    @CDP1             1 0          no of dec places
     C                   PARM                    @@MDF1            1            mult/div ind
      *
      * sell currency: amount, spot rate, ccy dec. places, M/D ind
      *
     C                   PARM                    @@DAM2           15 0          amount
     C                   PARM                    @SPOT2           13 8          spot rate
     C                   PARM                    @CDP2             1 0          no of dec places
     C                   PARM                    @@MDF2            1            mult/div ind
      *
      * ICD
     C                   PARM                    BJCYCD            3            mult/div ind
      *
      * OUTPUTS
      *
      * Base currency for accounting equivalent
     C                   PARM                    @@BCAE           15 0          base ccy a/cing
      *
      ** Get the currency decimal places of accounting base ccy
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** If error occurs...
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   MOVEL     BJCYCD        DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C                   Z-ADD     A6NBDP        @BCDP             1 0
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  DECIMAL PLACES CORRECTION ARRAY   @DC
0001001001001000
