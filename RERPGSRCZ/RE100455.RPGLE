     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Cash Management Posting Details Enquiry')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100455 - Cash Management Posting Details Enquiry           *
      *                                                               *
      *  Function: This module allows enquiry into Cash Management    *
      *            Posting Extension Details.                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FRE100455DFCF   E             WORKSTN INFSR(*PSSR)
     FGLAPSGAL0 IF   E           K DISK    INFSR(*PSSR)
     FGLAPSZSL0 IF   E           K DISK    INFSR(*PSSR)
     FGLPSTZSL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPZSD0: GLPSTZSD0)
     FGLPSTGAL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPGAD0: GLPSTGAD0)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
     D #_INF           S             70    DIM(7)  CTDATA PERRCD(1)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      /SPACE 5
 
 
      * Account
      * Retail A/c Number
      * Account Name
     C                   MOVEL     I_ACC         DDACC
     C                   MOVEL     I_RAN         DDRAN
     C                   MOVEL     I_ANAM        DDANAM
 
      * Customer Report Name
      * Customer Report Town
     C                   MOVEL     I_CRNM        DDCRNM
     C                   MOVEL     I_CRTN        DDCRTN
      * Posting Date
      * Value Date
      * Posting Narrative
      * Posting amount
     C                   MOVEL     I_PSTD        DDPSTD
     C                   MOVEL     I_VALD        DDVALD
     C                   MOVEL     I_PNAR        DDPNAR
     C                   MOVEL     I_PSTA        DDPSTA
 
      * Access Posting Extension
 
     C                   EXSR      ACS_EXTSN
 
      * If Zero Balancing/Sweeping entry
      *    Edit Zero Balancing/Sweeping Fields
      * Otherwise (if Group A/c Hierarchy posting)
      *    Edit Group A/c Hierarchy Fields
      *    If Zero Balancing/Sweeping extension exists
      *       Edit Zero Balancing/Sweeping Fields
 
     C     I_XRFI        IFEQ      'ZS'
     C                   MOVE      'Z'           GA_ZS             1
     C                   EXSR      EDIT_ZS
     C                   ELSE
     C                   MOVE      'G'           GA_ZS
     C                   EXSR      EDIT_GA
     C     ZSExtn2GA     IFEQ      'Y'
     C                   EXSR      EDIT_ZS
     C                   ENDIF
     C                   ENDIF
 
      * Display screen until F3, or F12 taken
 
     C     *INKC         DOWEQ     '0'
     C     *INKL         ANDEQ     '0'
     C                   EXSR      DSPLAY_SCN
     C                   END
 
      * Pass back function keys taken
 
     C                   MOVE      *INKC         @INKC
     C                   MOVE      *INKL         @INKL
 
      * End of program
 
     C                   SETON                                        LR
 
      /SPACE 5
      *****************************************************************
      * Display screen
      *****************************************************************
     C     DSPLAY_SCN    BEGSR
 
      * Write and read screen
 
     C                   TIME                    DDTIME
     C                   WRITE     MSGSUBCT
 
      * Enable F16
 
     C     ZSExtn2GA     COMP      'Y'                                    20
 
     C     GA_ZS         IFEQ      'G'
     C                   EXFMT     GROUPAC
     C                   ELSE
     C                   EXFMT     ZEROBLSWEP
     C                   ENDIF
 
      * Toggle group a/c or zero balancing/sweeping details
 
     C     *INKQ         IFEQ      '1'
     C     GA_ZS         IFEQ      'G'
     C                   MOVE      'Z'           GA_ZS
     C                   ELSE
     C                   MOVE      'G'           GA_ZS
     C                   ENDIF
     C                   ENDIF
 
      ** Clear the message queue & init error indicators
 
     C                   EXSR      CLR_MSGQ
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      ** Clear the message queue & init error indicators
      *****************************************************************
     C     CLR_MSGQ      BEGSR
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      DDPGM         ZAPGMQ           10
     C                   PARM      '*SAME'       ZAPGRL            5
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Access Posting Extension
      ********************************************************************
     C     ACS_EXTSN     BEGSR
 
      * Zero Balancing/Sweeping extension to Group a/c extension details
 
     C                   MOVE      'N'           ZSExtn2GA         1
 
     C     I_XRFI        IFEQ      'ZS'
     C     EXTSNK        CHAIN     GLAPZSD0                           60        *
     C   60EXTSNK        CHAIN     GLPSTZSD0                          60        *
     C                   ELSE
     C     EXTSNK        CHAIN     GLAPGAD0                           60        *
     C   60EXTSNK        CHAIN     GLPSTGAD0                          60        *
     C     *IN60         IFEQ      '0'
     C     AGZSXR        ANDNE     *ZERO
     C     ZSEXTSNK      CHAIN     GLAPZSD0                           70        *
     C   70ZSEXTSNK      CHAIN     GLPSTZSD0                          70        *
     C  N70              MOVE      'Y'           ZSExtn2GA
     C                   ENDIF
     C                   ENDIF
 
      * If no record found, then end
 
     C     *IN60         IFEQ      '1'
     C                   MOVE      *ON           *INKL
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Edit Zero Balancing/Sweeping Fields
      ********************************************************************
     C     EDIT_ZS       BEGSR
 
      * Account
 
     C                   MOVEL     *BLANK        W_ACC            22
     C                   MOVE      AZACUS        WrkCUS            6
     C**********         MOVE      AZAACD        WrkACD            4                          CGL029
     C                   MOVE      AZAACD        WrkACD           10                          CGL029
     C                   MOVE      AZAASN        WrkASN            2
     C                   EVAL      W_ACC = AZABRC + '-' + WrkCUS
     C                                     + '-' + AZACCY + '-' + WrkACD
     C                                     + '-' + WrkASN
 
      * Account retail number
 
     C                   MOVEL     AZARNO        W_RAN            10
 
      * External account number
 
     C                   Z-ADD     0             S1                3 0
     C                   Z-ADD     0             S2                3 0
     C                   Z-ADD     0             X                 3 0
     C                   MOVEL     *BLANK        W_EXTA           25
     C                   EVAL      S1 = %scan('/' : AZF861 : 1)
     C                   IF        S1 > 0
     C                   EVAL      S2 = %scan('/' : AZF861 : S1 + 2)
     C                   IF        S2 > 0
     C                   EVAL      W_EXTA = %subst(AZF861: S1 + 1 : S2-S1-1)
     C                   ELSE
     C                   EVAL      W_EXTA = %subst(AZF861: S1 + 1 : 25)
     C                   ENDIF
     C                   ENDIF
 
      * Text
 
     C                   SELECT
     C     AZASDA        WHENEQ    'S'
     C     AZTPSW        ANDEQ     'T'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      DDTEXT = 'TOP TO ' + W_EXTA
     C                   ELSE
     C                   EVAL      DDTEXT = 'TOP TO ' + W_ACC + ' ' + W_RAN
     C                   ENDIF
     C     AZASDA        WHENEQ    'S'
     C     AZTPSW        ANDEQ     'S'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      DDTEXT = 'SWEEP FROM ' + W_EXTA
     C                   ELSE
     C                   EVAL      DDTEXT = 'SWEEP FROM ' + W_ACC + ' ' + W_RAN
     C                   ENDIF
     C     AZASDA        WHENEQ    'D'
     C     AZTPSW        ANDEQ     'T'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      DDTEXT = 'TOP FROM ' + W_EXTA
     C                   ELSE
     C                   EVAL      DDTEXT = 'TOP FROM ' + W_ACC + ' ' + W_RAN
     C                   ENDIF
     C     AZASDA        WHENEQ    'D'
     C     AZTPSW        ANDEQ     'S'
     C     W_EXTA        IFNE      *BLANK
     C                   EVAL      DDTEXT = 'SWEEP TO ' + W_EXTA
     C                   ELSE
     C                   EVAL      DDTEXT = 'SWEEP TO ' + W_ACC + ' ' + W_RAN
     C                   ENDIF
     C                   ENDSL
 
      * Target Balance
 
     C     AZTBAL        IFEQ      'Y'
     C                   EVAL      DDTBAL = 'YES'
     C                   ELSE
     C                   EVAL      DDTBAL = 'NO '
     C                   ENDIF
 
      * Assocation Date
 
     C     AZCBSA        IFEQ      'Y'
     C                   EVAL      DDCBSA = 'YES'
     C                   ELSE
     C                   EVAL      DDCBSA = 'NO '
     C                   ENDIF
 
      * MT94X Field 86 components
 
     C                   MOVEL     AZF861        DDF861
     C                   MOVEL     AZF862        DDF862
     C                   MOVEL     AZF863        DDF863
     C                   MOVEL     AZF864        DDF864
     C                   MOVEL     AZF865        DDF865
 
      * When generated
 
     C                   Z-ADD     AZDATG        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDZDATG
     C                   SELECT
     C     AZMODO        WHENEQ    'PUR'
     C                   MOVEL     #_INF(1)      DDZMODEN
     C     AZMODO        WHENEQ    'ASC'
     C                   MOVEL     #_INF(2)      DDZMODEN
     C     AZMODO        WHENEQ    '1  '
     C                   MOVEL     #_INF(3)      DDZMODEN
     C     AZMODO        WHENEQ    '1PC'
     C                   MOVEL     #_INF(4)      DDZMODEN
     C     AZMODO        WHENEQ    '5  '
     C                   MOVEL     #_INF(5)      DDZMODEN
     C     AZMODO        WHENEQ    '5PC'
     C                   MOVEL     #_INF(6)      DDZMODEN
     C     AZMODO        WHENEQ    'I/C'
     C                   MOVEL     #_INF(7)      DDZMODEN
     C                   ENDSL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Edit Group A/c Hierarchy Fields
      ********************************************************************
     C     EDIT_GA       BEGSR
 
      * Source account
 
     C                   MOVE      AGSCUS        WrkCUS            6
     C**********         MOVE      AGSACD        WrkACD            4                          CGL029
     C                   MOVE      AGSACD        WrkACD                                       CGL029
     C                   MOVE      AGSASN        WrkASN            2
     C                   EVAL      DDSACC = AGSBRC +  '-'  +  WrkCUS  +  '-'
     C                                      +  AGSCCY +  '-'  +  WrkACD   +
     C                                      '-'  +  WrkASN
 
      * Source account retail number
 
     C                   MOVEL     AGSRNO        DDSRAN
 
      * When generated
 
     C                   Z-ADD     AGDATG        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        DDGDATG
     C                   SELECT
     C     AGMODO        WHENEQ    'PUR'
     C                   MOVEL     #_INF(1)      DDGMODEN
     C     AGMODO        WHENEQ    'ASC'
     C                   MOVEL     #_INF(2)      DDGMODEN
     C     AGMODO        WHENEQ    '1  '
     C                   MOVEL     #_INF(3)      DDGMODEN
     C     AGMODO        WHENEQ    '1PC'
     C                   MOVEL     #_INF(4)      DDGMODEN
     C     AGMODO        WHENEQ    '5  '
     C                   MOVEL     #_INF(5)      DDGMODEN
     C     AGMODO        WHENEQ    '5PC'
     C                   MOVEL     #_INF(6)      DDGMODEN
     C     AGMODO        WHENEQ    'I/C'
     C                   MOVEL     #_INF(7)      DDGMODEN
     C                   ENDSL
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *****************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * Account
      * Retail A/c Number
      * Account Name
     C                   PARM                    I_ACC            22
     C                   PARM                    I_RAN            10
     C                   PARM                    I_ANAM           20
      * Customer Report Name
      * Customer Report Town
     C                   PARM                    I_CRNM           20
     C                   PARM                    I_CRTN           10
      * Posting Date
      * Value Date
      * Posting Narrative
      * Posting amount
     C                   PARM                    I_PSTD            7
     C                   PARM                    I_VALD            7
     C                   PARM                    I_PNAR           30
     C                   PARM                    I_PSTA           18
      * Reference ID
      * Reference Number
     C                   PARM                    I_XRFI            3
     C                   PARM                    I_XRFN           10 0
 
      * Command keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
 
      * Initialize program name
 
     C                   MOVEL     'RE100455 '   DDPGM
 
      * Set up subfile message queue information
 
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
 
      * Set up standard screen fields.
 
     C                   MOVEL     PsJobName     DDJOB
     C                   MOVEL     PsUser        DDUSR
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   MOVE      'ZS '         W_XRFI            3
 
      * key lists
 
     C     EXTSNK        KLIST
     C                   KFLD                    I_XRFI
     C                   KFLD                    I_XRFN
     C     ZSEXTSNK      KLIST                                                  *
     C                   KFLD                    W_XRFI
     C                   KFLD                    AGZSXR
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_INF
* PURGE OF VALUE DATE BALANCES *
* NEW ACCOUNT ASSOCIATIONS *
* DAILY *
* DAILY - POST CAPITALIZATION *
* ANWD *
* ANWD - POST CAPITALIZATION *
* INPUT CYCLE *
