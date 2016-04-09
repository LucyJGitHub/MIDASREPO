     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade countervalue calculation')
      *****************************************************************
      *                                                               *
      *    Midas SE - Midas Security Trading validation module.       *
      *                                                               *
      *  SETCVALCAL - Trade Countervalue Calculation                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE075             Date 17Nov05               *
      *  Prev Amend No. 233881             Date 02Jun05               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 214694             Date 10Feb03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 200459             Date 22Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CUT009             Date 05Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP003  *CREATE    Date 18Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
/*    *  214694 - Current factor not considered when backvalued MP.   *
/*    *           Fix is to ensure that the latest current factor is  *
/*    *           used for PROT 8.  Addl test case for 200459.        *
      *  200459 - Current factor not applied to countervalue for 'MP' *
      *           Securities.  Add checking to SEDEV for new current  *
      *           factor and if it exists, use it in calculating the  *
      *           countervalue.  Amended to be consistent with SE0050.*
      *  CUT009 - Core hooks added manually.                          *
      *  CSE023 - Treaty Withholding Tax.                             *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FSECEO     IF   E           K DISK                                                       200459
     F                                     RENAME(SEDEVDF:SEDEVDO)                            200459
 
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
 
     D*   Data structure for CTR
     D                 DS
     D  CTR                    1     21
     D                                     DIM(21)
                                                                                              233881
      ** Switchable Feature Details Data Structure                                            233881
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  233881
                                                                                              233881
      ** Short Access Object Data Structure                                                   233881
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     233881
 
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                         CSE023
      ** Country of treaty                                                      CSE023
     D PCRTT           S              2A                                        CSE023
      *                                                                         CSE023
      ** Country of treaty                                                      CSE023
     D PDRBW           S              2A                                        CSE023
     D CSE023          S              1A                                        CSE023
     D PTDVD           S              5P 0                                      CSE023
     D WTDVD           S              5A                                        CSE023
     D WTax            S             13P 0                                      CSE023
     D WHTX            S             13P 0                                      CSE023
     D DDWHTX          S             15A                                        CSE023
                                                                                              233881
     D PEUTX           S             13P 0                                                    233881
     D PRtCd           S              7A                                                      233881
     D POptn           S              7A                                                      233881
     D PSARD           S              6A                                                      233881
     D CGL031          S              1A                                                      233881
      *                                                                         CSE023
      ** Parameters for AOTXBSR0                                                CSE023
     D PIRTCD          S              7A                                        CSE023
     D PIOPTN          S              7A                                        CSE023
     D PICRTT          S              2A                                        CSE023
     D PITXBS          S              2A                                        CSE023
     D PIDATE          S              5P 0                                      CSE023
     D PINARR          S             15A                                        CSE023
     D PIRATE          S              6P 4                                      CSE023
 
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
      * Initialize outputs
      *
     C                   Z-ADD     *ZERO         TCSR
     C                   Z-ADD     *ZERO         TCTR
     C                   MOVE      *BLANKS       DDTCTR
      *                                                                                       200459
      ** Current factor                                                                       200459
      *                                                                                       200459
     C     PROT          IFEQ      '8'                                                        200459
                                                                                              200459
     C                   MOVE      SESN          SDSN                                         200459
     C                   MOVE      'MP  '        SDET                                         200459
     C                   Z-ADD     TDVD          SDED                                         200459
                                                                                              200459
     C                   MOVE      '0'           *IN44                                        214694
     C                   MOVE      '0'           *IN45                                        214694
     C     KLEVD         SETLL     SEDEVDO                                                    200459
     C     *IN44         DOUEQ     '1'                                                        214694
     C     *IN45         OREQ      '1'                                                        214694
     C                   READ      SEDEVDO                                44                  200459
     C     *IN44         IFEQ      '0'                                                        214694
     C     SDSN          ANDEQ     SESN                                                       214694
     C     SDET          ANDEQ     'MP'                                                       214694
     C     RECI          ANDEQ     'D'                                                        214694
     C     SDED          COMP      TDVD                                 4545                  214694
     C                   ENDIF                                                                214694
     C                   ENDDO                                                                214694
     C     *IN44         IFEQ      '0'                                                        200459
     C     *IN45         ANDEQ     '1'                                                        214694
     C*****SDSN*         ANDEQ     SESN                                                200459 214694
     C*****SDET*         ANDEQ     'MP'                                                200459 214694
     C                   Z-ADD     SDCP          CFCT                                         200459
     C                   ENDIF                                                                200459
                                                                                              200459
     C                   ENDIF                                                                200459
      *
      * Calculate Trade Countervalue
     C/COPY WNCPYSRC,SETCVALC01                                                               CUT009
      *
     C                   EXSR      CVALCAL
      *
     C/COPY WNCPYSRC,SETCVALC02                                                               CUT009
      *
      ** Return
      *
     C                   RETURN
 
      *****************************************************************
      *                                                               *
      * CVALCAL - Calculate Trade Countervalue                        *
      *                                                               *
      *****************************************************************
     C     CVALCAL       BEGSR
      *
      * Calculate trade countervalue (in nominal currency)
      *
     C                   CALLB     'ZCOTR'
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    RALL              9 5
     C                   PARM                    ITRA             13 0
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM      NomCcyDec     ZCDP              1 0
     C                   PARM      *ZERO         ZCONS            15 0
     C                   PARM      *ZERO         ZCTRVL           15 0
 
     C                   Z-ADD     ZCONS         TCSR
      *                                                                         CSE023
      ** If enhancement 'Treaty withholding tax' is switched on.                CSE023
      ** Calculate withholding tax and deduct it from counter value amount.     CSE023
      *                                                                         CSE023
     C                   IF        CustClass = 'S' or CustClass = 'D'           CSE023
      *                                                                         CSE023
     C                   IF        CSE023 = 'Y' AND TDTP ='TP' AND              CSE023
     C                             PCRTT <> *BLANKS AND                         CSE023
     C                             PDRBW <> *BLANKS                             CSE023
     C                   EXSR      SRCalcWHT                                    CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      *BLANKS       DDWHTX                         CSE023
     C                   Z-ADD     *ZEROS        WHTX                           CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C                   ENDIF                                                  CSE023
      *                                                                         CSE023
     C                   Z-ADD     ZCTRVL        TCTR
 
      * Exit if countervalue is zero
 
     C     TCTR          CABEQ     *ZEROS        ECVALCAL
                                                                                              233881
      ** Subtract EU Tax if CGL031 is enabled.                                                233881
                                                                                              233881
     C                   IF        CGL031 = 'Y'                                               233881
     C                   EVAL      TCTR = TCTR - PEUTX                                        233881
     C                   ENDIF                                                                233881
      *
      *  Convert to settlement currency for screen display.
      *
     C                   CALLB     'ZCONV'
     C                   PARM      TCTR          ZAMTCI           15 0
     C                   PARM      TDER          ZEXCH            13 8
     C                   PARM      TDMI          ZMD               1
     C                   PARM      NMCY          ZCCYI             3
     C                   PARM      SETC          ZCCYO             3
     C                   PARM      NomCcyDec     ZCDPI             1 0
     C                   PARM      SetCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
      *
      * Edit countervalue for screen display
      *
     C                   MOVE      ZAMTCO        ZFLD15
     C                   CALLB     'ZSEDITF'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      SetCcyDec     ZDECS             1 0
     C                   PARM      'J'           ZECODE            1
     C                   PARM      '*'           ZECHAR            1
     C                   PARM                    ZOUT21           21
 
     C                   MOVE      ZOUT21        DDTCTR
      *
      * Left align screen countervalue
      *
     C                   EXSR      CNTL
      *
     C     ECVALCAL      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CNTL Sub routine to left align Screen Countervalue.          *
      *                                                               *
      *****************************************************************
      *
     C     CNTL          BEGSR
 
     C                   Z-ADD     0             E                 2 0
     C                   Z-ADD     1             R                 2 0
     C                   MOVE      '*'           SPLAT             1
     C                   Z-ADD     1             F                 2 0
     C                   MOVEA     DDTCTR        CTR
     C     SPLAT         LOOKUP    CTR(F)                                 97
     C     21            SUB       F             E
     C                   MOVE      ' '           CTR(F)
     C                   ADD       1             F
     C                   DO        E
     C                   MOVE      CTR(F)        CTR(R)
     C                   ADD       1             F
     C                   ADD       1             R                 2 0
     C                   END
     C                   ADD       1             E
     C                   MOVEA     *ALL' '       CTR(E)
     C                   MOVEA     CTR           DDTCTR
 
     C     ECNTL         ENDSR
      *****************************************************************
      /EJECT                                                                    CSE023
      *****************************************************************         CSE023
      *                                                               *         CSE023
      * SRCalcWHT - Calculate Withholding Tax                         *         CSE023
      *                                                               *         CSE023
      *****************************************************************         CSE023
     C     SRCalcWHT     BEGSR                                                  CSE023
      *                                                                         CSE023
      ** Using country of treaty + default tax basket for backup withholding,   CSE023
      ** obtain tax rate.                                                       CSE023
      *                                                                         CSE023
     C                   CALL      'AOTXBSR0'                                   CSE023
     C                   PARM      *BLANKS       PIRTCD                         CSE023
     C                   PARM      '*KEY   '     PIOPTN                         CSE023
     C                   PARM      PCRTT         PICRTT                         CSE023
     C                   PARM      PDRBW         PITXBS                         CSE023
     C                   PARM      PTDVD         PIDATE                         CSE023
     C                   PARM      *BLANKS       PINARR                         CSE023
     C                   PARM      *ZEROS        PIRATE                         CSE023
                                                                                CSE023
     C                   IF        PIRTCD <> *BLANKS AND                        CSE023
     C                             PIRTCD <> '*NRF   '                          CSE023
     C                   MOVEL     PTDVD         WTDVD                          CSE023
     C                   EVAL      DBKEY  = PCRTT + PDRBW + WTDVD               CSE023
     C                   EVAL      DBFILE = 'SDTXBSPD'                          CSE023
     C                   EVAL      DBASE  = 002                                 CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   IF        PIRTCD = *BLANKS                             CSE023
     C     ZCTRVL        MULT(H)   PIRATE        WTax                           CSE023
     C     WTax          DIV       100           WTax                           CSE023
     C     ZCTRVL        SUB       WTax          ZCTRVL                         CSE023
     C                   Z-ADD     WTax          WHTX                           CSE023
      *                                                                         CSE023
      ** Format withholding tax for display                                     CSE023
      *                                                                         CSE023
     C                   MOVE      WHTX          ZFLD15                         CSE023
     C                   CALLB     'ZSEDITF'                                    CSE023
     C                   PARM                    ZFLD15                         CSE023
     C                   PARM      SetCcyDec     ZDECS                          CSE023
     C                   PARM      'J'           ZECODE                         CSE023
     C                   PARM      *BLANKS       ZECHAR                         CSE023
     C                   PARM      *BLANKS       ZOUT21                         CSE023
                                                                                CSE023
     C                   MOVE      ZOUT21        DDWHTX                         CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      *BLANKS       DDWHTX                         CSE023
     C                   Z-ADD     *ZEROS        WHTX                           CSE023
     C                   ENDIF                                                  CSE023
                                                                                CSE023
     C                   ENDSR                                                  CSE023
      *                                                                         CSE023
      *****************************************************************         CSE023
      /EJECT
     C/COPY WNCPYSRC,SETCVALC03                                                               CUT009
      /EJECT                                                                                  CUT009
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *                                                                                       200459
      ** Define key list for SECEO Security Diary Events.                                     200459
      *                                                                                       200459
     C     KLEVD         KLIST                                                                200459
     C                   KFLD                    SDSN                                         200459
     C                   KFLD                    SDET                                         200459
     C                   KFLD                    SDED                                         200459
 
     C     *entry        PLIST
 
      * INPUTS
 
      ** Trade details
     C                   PARM                    TDTP              2
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    RALL              9 5
     C                   PARM                    ITRA             13 0
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    TDER             13 8
     C                   PARM                    TDMI              1
     C                   PARM                    SETC              3
     C                   PARM                    TDVD              5 0                        200459
 
      ** Security details
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM                    SESN             10                          200459
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Customer classification
     C                   PARM                    CustClass         1
                                                                                CSE023
      ** Country of treaty from PF/SECTYD                                       CSE023
     C                   PARM                    PCRTT                          CSE023
                                                                                CSE023
      ** Default basket for backup withholding                                  CSE023
     C                   PARM                    PDRBW                          CSE023
                                                                                CSE023
      ** Value date                                                             CSE023
     C                   PARM                    PTDVD                          CSE023
                                                                                              233881
      ** EU Tax                                                                               233881
     C                   PARM                    PEUTX                                        233881
 
      * OUTPUTS
 
      * Trade consideration in nominal currency
      * Trade countervalue in nominal currency
      * Withholding tax                                                         CSE023
      * Trade countervalue in settlement currency in screen format
      * Withholding tax in screen format                                        CSE023
     C                   PARM                    TCSR             15 0
     C                   PARM                    TCTR             15 0
     C                   PARM                    WHTX                           CSE023
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWHTX                         CSE023
 
      *                                                                         CSE023
      ** Check if enhancement 'Treaty withholding tax' is on.                   CSE023
      *                                                                         CSE023
     C                   CALLB     'AOSARDR0'                                   CSE023
     C                   PARM      *BLANKS       @RTCD                          CSE023
     C                   PARM      '*VERIFY'     @OPTN                          CSE023
     C                   PARM      'CSE023'      @SARD                          CSE023
      *                                                                         CSE023
      ** Check for Database error                                               CSE023
      *                                                                         CSE023
     C     @RTCD         IFNE      *BLANKS                                      CSE023
     C     @RTCD         ANDNE     '*NRF   '                                    CSE023
     C                   MOVEL     'CSE023'      DBKEY                          CSE023
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE023
     C                   MOVEL     '001'         DBASE                          CSE023
     C                   EXSR      *PSSR                                        CSE023
     C                   END                                                    CSE023
      *                                                                         CSE023
     C     @RTCD         IFEQ      *BLANK                                       CSE023
     C                   MOVE      'Y'           CSE023                         CSE023
     C                   ELSE                                                   CSE023
     C                   MOVE      'N'           CSE023                         CSE023
     C                   ENDIF                                                  CSE023
                                                                                              233881
      ** Check if CGL031 (Taxation of Savings Income) is enabled.                             233881
                                                                                              233881
     C                   CALLB     'AOSARDR0'                                                 233881
     C                   PARM      *BLANKS       PRtCd                                        233881
     C                   PARM      '*VERIFY'     POptn                                        233881
     C                   PARM      'CGL031'      PSARD                                        233881
     C     SCSARD        PARM      SCSARD        DSFDY                                        233881
                                                                                              233881
     C                   EVAL      CGL031 = 'N'                                               233881
                                                                                              233881
     C                   IF        PRtCd = *BLANKS                                            233881
     C                   EVAL      CGL031 = 'Y'                                               233881
     C                   ELSE                                                                 233881
                                                                                              233881
     C                   IF        PRtCd <> '*NRF   '                                         233881
     C                   EVAL      DBFile = 'SCSARDPD'                                        233881
     C                   EVAL      DBKey = 'CGL031'                                           233881
     C                   EVAL      DBase = 2                                                  233881
     C                   EXSR      *PSSR                                                      233881
     C                   ENDIF                                                                233881
                                                                                              233881
     C                   ENDIF                                                                233881
 
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
(c) Misys International Banking Systems Ltd. 2001
