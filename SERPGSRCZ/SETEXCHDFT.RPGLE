     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade exchange rates defaulting')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETEXCHDFT - Trade Exchange Rates Defaulting                 *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 193697             Date 02Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 149242             Date 8DEc98                *
      *                 CAP003  *CREATE    Date 18Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  193697 - Exchange rate/base rate not caluculated after       *
      *           after amendment of settlement currency.   Applied   *
      *           fix 181076 to recalculate exchange rate/base rate   *
      *           if settlement currency is change.                   *
      *  149242 - Incorrect multiply/divide indicator was being used  *
      *           when EURO currency was involved. Fix is to reverse  *
      *           the M/D indicator if Nominal currency is equal to   *
      *           the EURO currency. (Fixed under 140984 in non-API   *
      *           version)                                            *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
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
 
      ** Trade Exchange Rates in screen format
     D TrExch        E DS                  EXTNAME(SETREXPD)
 
 
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     ** Working variables
 
     D  ZDECS          S              1P 0
     D  ZECODE         S              1A
     D  ZFLD15         S             15P 0
     D  ZMDIX          S              1A
     D  ZOUT21         S             21A
     D  ZRATEX         S             13P 8
     D  ZRATE1         S             13P 8
     D  ZRATE2         S             13P 8
 
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
      ** Default Exchange Rate (Nominal to Settlement)
      *
     C*****DDTDER        IFEQ      *BLANKS                                                    193697
     C                   EXSR      DefExRate
     C**********         END                                                                  193697
      *
      ** Default Base Currency Rate
      *
     C*****DDBRTE        IFEQ      *BLANKS                                                    193697
     C                   EXSR      DefBseRte
     C**********         END                                                                  193697
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DefExRate - Defaulting Routine for Exchange Rate (Nom to Set) *
      *                                                               *
      *****************************************************************
     C     DefExRate     BEGSR
 
      * If settlement currency is nominal currency, rate is 1.
 
     C     DDSETC        IFEQ      NMCY
 
     C                   Z-ADD     1             TDER
     C                   MOVE      'M'           TMDI
 
     C                   ELSE
      *
     C                   SELECT
      *
      * If CEU005 is switched on, Settlement Currency is
      * Euros, and Nominal Currency is an 'in' currency
      * use its Euro rate and multiply/divide ind.
      *
     C     CEU005        WHENEQ    'Y'
     C     DDSETC        ANDEQ     BKEURO
     C     NomCcyINCY    ANDEQ     'Y'
     C                   Z-ADD     NomCcyEUER    TDER
     C                   MOVEL     NomCcyEUMD    TMDI                           149242
     C*****NomCcyEUMD    IFEQ      'M'                                          149242
     C*******            MOVEL     'D'           TMDI                           149242
     C*******            ELSE                                                   149242
     C*******            MOVEL     'M'           TMDI                           149242
     C*******            ENDIF                                                  149242
      *
      * If CEU005 is switched on, Nominal Currency is
      * Euros, and Settlement Currency is an 'in' currency
      * use its Euro rate and multiply/divide ind.
      * (Reverse M/D indicator)                                                 149242
      *
     C     CEU005        WHENEQ    'Y'
     C     NMCY          ANDEQ     BKEURO
     C     SetCcyINCY    ANDEQ     'Y'
     C                   Z-ADD     SetCcyEUER    TDER
     C*******            MOVEL     SetCcyEUMD    TMDI                           149242
     C     SetCcyEUMD    IFEQ      'M'                                          149242
     C                   MOVEL     'D'           TMDI                           149242
     C                   ELSE                                                   149242
     C                   MOVEL     'M'           TMDI                           149242
     C                   ENDIF                                                  149242
      *
     C                   OTHER
 
      * Set nominal currency details
 
     C                   Z-ADD     NomCcySPRT    ZRATE1
     C                   MOVE      NomCcyMDIN    ZMDI1             1
 
      * Set settlement currency details
 
     C                   Z-ADD     SetCcySPRT    ZRATE2
     C                   MOVE      SetCcyMDIN    ZMDI2             1
 
      * Determine cross rate between nominal and settlement currency
 
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
 
     C                   Z-ADD     ZRATEX        TDER
     C                   MOVE      ZMDIX         TMDI
 
     C                   ENDSL
 
     C                   ENDIF
 
      * Edit for display
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TDER          ZFLD15
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM      8             ZDECS
     C                   PARM      *BLANK        ZECODE
     C                   PARM      *BLANKS       ZOUT21
 
     C                   MOVE      ZOUT21        DDTDER
     C                   MOVE      TMDI          DDSMDI
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DefBseRte - Defaulting Routine for Base Rate                  *
      *                                                               *
      *****************************************************************
     C     DefBseRte     BEGSR
 
      * Default settlement currency spot rate as base rate
 
     C                   Z-ADD     SetCcySPRT    TBCR
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      TBCR          ZFLD15
 
      * Edit for display
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      8             ZDECS             1 0
     C                   PARM      *BLANK        ZECODE            1
     C                   PARM      *BLANKS       ZOUT21           21
 
     C                   MOVE      ZOUT21        DDBRTE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
 
      * INPUTS
      *
      ** Nominal Currency
      ** Settlement Currency
     C                   PARM                    NMCY              3
     C                   PARM                    DDSETC            3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      ** ICD
      ** Euro Currency
      ** EMU SE Settlement Ccy Conv.
     C                   PARM                    BKEURO            3
     C                   PARM                    CEU005            1            ULX003
 
      * OUTPUTS
 
      ** Trade Exchange Rate screen fields
 
     C                   PARM                    TrExch
 
      ** Trade Exchange Rate file fields
 
     C                   PARM                    TDER             13 8
     C                   PARM                    TMDI              1
     C                   PARM                    TBCR             13 8
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
