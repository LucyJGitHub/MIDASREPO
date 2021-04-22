     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities screen 1 defaulting')              *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECS1DT - Securities Screen 1 Defaulting                   *
      *                                                               *
      *  Function: This module defaults Security fields from          *
      *            first screen.                                      *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                SESECSCTL                                      *
      *                SESECSRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 12Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information (Recompile)       *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE037 - Countervalue rounding - recompile only for INVTP    *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CSD006 - Market Data Feed (recompile)                        *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(SECTYD)
      *
      ** Securities screen 1 details retrieved from file - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Investment type details
     D PINVTPD       E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(F1)
      *
      ** Externally described DS for Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** DS for Access Objects - Very long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
     D WADNM           S              1    DIM(7)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameter list for AOCUSTR1
     D PKeyC           S             10A
     D PKySt           S              7A
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Index for arrays of error message ids etc.
     D IDx             S              3P 0
     D PReDsp          S              1A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Default first screen fields.
      *
     C                   EXSR      SRDefault
      *
      ** Return.
      *
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Default first screen fields                      *
      *                                                               *
      *****************************************************************
     C     SRDefault     BEGSR
      *
      ** Access Issuer details.
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      DDISSR        PKeyC
     C                   PARM      *BLANKS       PKySt
     C     SDCUST        PARM      SDCUST        DSLDY
      *
      ** Industry Code
      *
     C                   IF        DDSIDY = *BLANKS OR DDSIDY = *ZEROS
     C                   IF        F1DIND = *BLANKS AND PRtcd = *BLANKS
     C                   EVAL      DDSIDY = BBLICD
     C                   ELSE
     C                   EVAL      DDSIDY = F1DIND
     C                   ENDIF
     C                   ENDIF
      *
      ** Value Currency
      *
     C                   IF        DDVLCY = *BLANKS AND PReDsp <> 'Y'
     C                   IF        F1DVCY = *BLANKS
     C                   EVAL      DDVLCY = DDNMCY
     C                   ELSE
     C                   EVAL      DDVLCY = F1DVCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Multi-Currency Indicator
      *
     C                   IF        DDMLTI = *BLANKS
     C                   IF        F1DMCY = *BLANKS
     C                   EVAL      DDMLTI = 'N'
     C                   ELSE
     C                   EVAL      DDMLTI = F1DMCY
     C                   ENDIF
     C                   ENDIF
      *
      ** Sector Code
      *
     C                   IF        DDSSEC = *BLANKS
     C                   IF        (DDINCS = 'C' AND INCS = 'I') OR
     C                             (DDINCS = 'C' AND DDACTN = 'I')
     C                   EVAL      DDSSEC = F1DSEC
     C                   ENDIF
     C                   ENDIF
      *
      ** Rating
      *
     C                   IF        DDQLTY = *BLANKS
     C                   IF        (DDINCS = 'C' AND INCS = 'I') OR
     C                             (DDINCS = 'C' AND DDACTN = 'I')
     C                   EVAL      DDQLTY = F1DRAT
     C                   ENDIF
     C                   ENDIF
      *
      ** Market Indicator
      *
     C                   IF        DDMKTI = *BLANKS
     C                   EVAL      DDMKTI = F1DMAR
     C                   ENDIF
      *
      ** Default Country of Risk just once.
      *
     C                   IF        DDSCOR = *BLANKS  AND PReDsp <> 'Y'
     C                   IF        F1DCYR = *BLANKS AND PRtcd = *BLANKS
     C                   EVAL      DDSCOR = BBCNCZ
     C                   ELSE
     C                   EVAL      DDSCOR = F1DCYR
     C                   ENDIF
     C                   ENDIF
      *
      ** Trade Denomination
      *
     C                   IF        DDSDNM = *BLANKS
     C                   IF        (DDINCS = 'C' AND INCS = 'I') OR
     C                             (DDINCS = 'C' AND DDACTN = 'I')

     C                   IF        F1DTRD <> 0
     C                   MOVE      F1DTRD        DDSDNM
     C                   MOVEA     DDSDNM        WADNM
      *
      ** Exclude leading zeros
     C                   Z-ADD     1             Idx
     C                   DOW       Idx < 8 AND (WADNM(Idx) =  ' ' OR
     C                             WADNM(Idx) =  '0')
     C                   EVAL      WADNM(Idx) = ' '
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO

     C                   MOVEA     WADNM         DDSDNM

     C                   ELSE
     C                   EVAL      DDSDNM = *BLANKS
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
      ** Value Date
      *
     C                   IF        DDVDFT = *BLANKS
     C                   IF        (DDINCS = 'C' AND INCS = 'I') OR
     C                             (DDINCS = 'C' AND DDACTN = 'I')
     C                   EVAL      DDVDFT = F1DVDT
     C                   ENDIF
     C                   ENDIF
      *
      ** Ex Date
      *
     C                   IF        DDEDFT = *BLANKS
     C                   IF        (DDINCS = 'C' AND INCS = 'I') OR
     C                             (DDINCS = 'C' AND DDACTN = 'I')
     C                   EVAL      DDEDFT = F1DEXD
     C                   ENDIF
     C                   ENDIF
      *
      ** Default zero to Nominal Decimal Places if no entry is made
      ** unless PROT = 7 or 8.
      *
     C                   IF        DDNMDP = ' ' AND F1PROT <> '7' AND
     C                             F1PROT <> '8'
     C                   EVAL      DDNMDP = '0'
     C                   ENDIF
      *
      ** Set Default for Plato Report Group and Pricing Group.
      *
     C                   IF        F1PLDPCD <> *BLANKS AND
     C                             DDPGCD = *BLANKS AND DDACTN = 'I'
     C                   EVAL      DDPGCD = F1PLDPCD
     C                   ENDIF

     C                   IF        F1PLDRCD <> *BLANKS AND
     C                             DDRGCD = *BLANKS AND DDACTN = 'I'
     C                   EVAL      DDRGCD = F1PLDRCD
     C                   ENDIF
      *
      ** Set Default for Plato Debt/Equity Instrument Code
      *
     C                   IF        DDICCD = *BLANKS AND DDACTN = 'I'
     C                   EVAL      DDICCD = DDNMCY + ' ' + DDSESN
     C                   ENDIF
      *
      ** Set Default for Plato Debt (security)/Equity Name
      *
     C                   IF        DDDINM = *BLANKS AND DDACTN = 'I'
     C                   EVAL      DDDINM = DDSESN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
      *
      ** Investment type details
     C                   PARM                    PINVTPD
      *
      ** Redisplay screen
     C                   PARM                    PReDsp
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
