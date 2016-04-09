     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Daily events extract - Futures/Options')      *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  BY6001 - Daily Events Extract - Futures/Options              *
      *                                                               *
      *  Function:  This module extracts futs/options Daily Events    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. LLN021             Date 29Dec03               *
      *  Prev Amend No. LLN021             Date 01Dec03               *
      *                 LLN003             Date 01Dec03               *
      *                 CMX003             Date 01Dec03               *
      *                 CMX006             Date 01Dec03               *
      *                 LLN021  *CREATE    Date 13Nov03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN021 - Undefined a/c keys being output                     *
      *  LLN021 - Program uses incorrect name for access to file      *
      *  LLN003 - BoE - facility expiry date for loan maturity        *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *  CMX006 - Meridian Export Enhncmts - Event Category Wildcards *
      *  LLN021 - BoE Profit and Loss return                          *
      *                                                               *
      *****************************************************************
 
     FMXAKFFL1  IP   E           K DISK    RENAME(FOKEYDF:TRFOKEYDF)
     F                                     INFSR(*PSSR)
     FFACKY     IF   E           K DISK    INFSR(*PSSR)
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDEFFTPD O    E             DISK    INFSR(*PSSR)
     FMXDEFFBPD O    E             DISK    INFSR(*PSSR)                                       CMX003
     F*MXDEEXSAU O    E             PRINTER INFSR(*PSSR)  USROPN                              LLN003
     FBY6001AU  O    E             PRINTER INFSR(*PSSR)  USROPN                               LLN003
 
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
 
 
     D                 DS
     D  DGAK                   1     20
     D  DGAK01                 1      1
     D  DGAK02                 2      2
     D  DGAK03                 3      3
     D  DGAK04                 4      4
     D  DGAK05                 5      5
     D  DGAK06                 6      6
     D  DGAK07                 7      7
     D  DGAK08                 8      8
     D  DGAK09                 9      9
     D  DGAK10                10     10
     D  DGAK11                11     11
     D  DGAK12                12     12
     D  DGAK13                13     13
     D  DGAK14                14     14
 
     D                 DS
     D  DEACKY                 1     20                                                       LLN021
     D  DEACKY01               1      1
     D  DEACKY02               2      2
     D  DEACKY03               3      3
     D  DEACKY04               4      4
     D  DEACKY05               5      5
     D  DEACKY06               6      6
     D  DEACKY07               7      7
     D  DEACKY08               8      8
     D  DEACKY09               9      9
     D  DEACKY10              10     10
     D  DEACKY11              11     11
     D  DEACKY12              12     12
     D  DEACKY13              13     13
     D  DEACKY14              14     14
     D  DEACKY15              15     15                                                       LLN021
     D  DEACKY16              16     16                                                       LLN021
     D  DEACKY17              17     17                                                       LLN021
     D  DEACKY18              18     18                                                       LLN021
     D  DEACKY19              19     19                                                       LLN021
     D  DEACKY20              20     20                                                       LLN021
 
 
     D AK              S             20    DIM(99)
     D TG              S              1    DIM(99)
     D CC              S              2    DIM(99)
     D S1              S              4    DIM(99)
     D S2              S              4    DIM(99)
     D WC              S             20    DIM(99)                                            CMX006
 
     D TDAK            S             20    DIM(99)                                            LLN021
     D TDTG            S              1    DIM(99)
     D TDCC            S              2    DIM(99)
     D TDS1            S              4    DIM(99)
     D TDS2            S              4    DIM(99)
     D TDWC            S             20    DIM(99)                              CMX006
 
     D BPAK            S             20    DIM(99)                              CMX003
     D BPTG            S              1    DIM(99)                              CMX003
     D BPCC            S              2    DIM(99)                              CMX003
     D BPS1            S              4    DIM(99)                              CMX003
     D BPS2            S              4    DIM(99)                              CMX003
     D BPWC            S             20    DIM(99)                              CMX006
                                                                                CMX003
 
     D                 DS                                                       CMX006
     D WildAR                  1     20    DIM(20)                              CMX006
     D WildString              1     20                                         CMX006
     D                 DS                                                       CMX006
     D AckyAR                  1     20    DIM(20)                              CMX006
     D AckyString              1     20                                         CMX006
                                                                                CMX006
                                                                                CMX006
     D MXEXPCTL      E DS                  EXTNAME(MXEXPCTL)
      ** Export Control Data
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY details
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
      * Current Branch
     D                 DS
     D Curr_BRCA               1      3
 
 
      * Previous Branch
     D                 DS
     D Prev_BRCA               1      3
 
 
     ITRFOKEYDF     01
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      * Process a trade-based account key
 
     C     *IN01         IFEQ      '1'
     C*****DGAK_FTRD     ANDNE     *BLANK                                       LLN021
     C     DGAK_FTRS     ANDNE     *BLANK                                       LLN021
     C*******************EXSR      FTRD_ACKY                                    LLN021
     C                   EXSR      FTRS_ACKY                                    LLN021
     C                   ENDIF
                                                                                CMX003
      * Process a futures/option book position account key                      CMX003
                                                                                CMX003
     C     *IN01         IFEQ      '1'                                          CMX003
     C     DGAK_FBPS     ANDNE     *BLANK                                       CMX003
     C                   EXSR      FBPS_ACKY                                    CMX003
     C                   ENDIF                                                  CMX003
 
     CLR                 EXSR      TOTALS
 
      /SPACE 5
      ********************************************************************
      * Process a trade-based account key
      ********************************************************************
     C*****FTRD_ACKY     BEGSR                                                 LLN021
     C     FTRS_ACKY     BEGSR                                                 LLN021
 
      * Add 1 to count of records read
 
     C                   add       1             Trec_cnt
 
      * Set up account key
 
     C                   MOVEL     *BLANK        DEACKY
     C*******************MOVEL     ACKY          DEACKY                                       LLN021
     C                   MOVEL     FFKY          DEACKY                                       LLN021
 
      * On change of account key
      * Get the user-defined account key
 
     C*****ACKY          IFNE      Prev_ACKY                                                  LLN021
     C     FFKY          IFNE      Prev_ACKY                                                  LLN021
     C                   EXSR      GET_ACKY
     C*******************MOVEL     ACKY          Prev_ACKY        20                          LLN021
     C                   MOVEL     FFKY          Prev_ACKY        14                          LLN021
     C                   ENDIF
 
      * Ignore this account key if it is not defined
 
     C****************** MOVEL     'Y'           ACKY_Defin                            CMX003 LLN021
     C     ACKY_Defin    IFNE      'Y'
     C                   GOTO      NO_EXPT
     C                   ENDIF
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C                   MOVEL     SEBR          Curr_BRCA
     C************       MOVEL     SEBR          BRHA                         LLN021
     C                   MOVEL     BRCA          BRHA                         LLN021
     C     Curr_BRCA     IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C************       MOVEL     SEBR          I#BRCA                       LLN021
     C                   MOVEL     BRCA          I#BRCA                       LLN021
     C                   EXSR      BRCA_FLT
     C                   MOVEL     Curr_BRCA     Prev_BRCA
     C                   ENDIF
 
      * Other fields
 
     C                   Z-ADD     TNBR          TRFR
     C                   MOVEL     REVI          RVRS
     C                   MOVEL     EDAT          EVDT
     C                   MOVEL     EAMT          EVAM
     C                   MOVEL     CCY           EVCY
 
      * If branch is NOT for export
      * Ignore this account key
 
     C     Exp_BRCA      IFNE      'Y'
     C                   GOTO      NO_EXPT
     C                   ENDIF
 
      * Extract trade daily events
 
     C*******************MOVEL     'FTRD'        DGDTAG                         LLN021
     C                   MOVEL     'FTRS'        DGDTAG                         LLN021
     C****************** EXSR      EXT_FTRD                                     LLN021
     C                   EXSR      EXT_FTRS                                     LLN021
 
     C     NO_EXPT       ENDSR
      ********************************************************************
      /SPACE 5                                                                  CMX003
      ********************************************************************      CMX003
      * Process a futures/options book position account key                     CMX003
      ********************************************************************      CMX003
     C     FBPS_ACKY     BEGSR                                                  CMX003
                                                                                CMX003
      * Add 1 to count of records read                                          CMX003
                                                                                CMX003
     C                   add       1             Brec_cnt                       CMX003
                                                                                CMX003
      * Set up account key                                                      CMX003
                                                                                CMX003
     C                   MOVEL     *BLANK        DEACKY                         CMX003
     C****************** MOVEL     ACKY          DEACKY                                CMX003 LLN021
     C                   MOVEL     FFKY          DEACKY                                       LLN021
                                                                                CMX003
      * Determine position                                                      CMX003
                                                                                CMX003
     C                   MOVEL     BRCA          BHBA                           CMX003
     C                   MOVEL     DEACKY07      BHBK                           CMX003
     C                   MOVE      DEACKY08      BHBK                           CMX003
     C                   Z-ADD     TNBR          TRFR                           CMX003
                                                                                CMX003
      * On change of account key                                                CMX003
      * Get the user-defined account key                                        CMX003
                                                                                CMX003
     C*****ACKY          IFNE      Prev_ACKY                                           CMX003 LLN021
     C     FFKY          IFNE      Prev_ACKY                                                  LLN021
     C                   EXSR      GET_ACKY                                     CMX003
     C*******************MOVEL     ACKY          Prev_ACKY        20                   CMX003 LLN021
     C                   MOVEL     FFKY          Prev_ACKY        14                          LLN021
     C                   ENDIF                                                  CMX003
                                                                                CMX003
      * Ignore this account key if it is not defined                            CMX003
                                                                                CMX003
     C****************   MOVEL     'Y'           ACKY_Defin                            CMX003 LLN021
     C     ACKY_Defin    IFNE      'Y'                                          CMX003
     C                   GOTO      NO_EXTB                                      CMX003
     C                   ENDIF                                                  CMX003
                                                                                CMX003
      * On change of branch                                                     CMX003
      * Determine if branch is to be included in the export                     CMX003
                                                                                CMX003
     C                   MOVEL     BRCA          Curr_BRCA                      CMX003
     C                   MOVEL     BRCA          BHBA
     C     Curr_BRCA     IFNE      Prev_BRCA                                    CMX003
     C                   MOVE      'D'           I#LD                           CMX003
     C                   MOVEL     BRCA          I#BRCA                         CMX003
     C                   EXSR      BRCA_FLT                                     CMX003
     C                   MOVEL     Curr_BRCA     Prev_BRCA                      CMX003
     C                   ENDIF                                                  CMX003
                                                                                CMX003
      * Set up other fields
 
     C                   MOVEL     BOKC          BHBK
     C                   MOVEL     REVI          RVRS
     C                   MOVEL     EDAT          EVDT
     C                   MOVEL     EAMT          EVAM
     C                   MOVEL     CCY           EVCY
 
      * If branch is NOT for export                                             CMX003
      * Ignore this account key                                                 CMX003
                                                                                CMX003
     C     Exp_BRCA      IFNE      'Y'                                          CMX003
     C                   GOTO      NO_EXTB                                      CMX003
     C                   ENDIF                                                  CMX003
                                                                                CMX003
      * Extract futures/options book position daily events                      CMX003
                                                                                CMX003
     C                   MOVEL     'FBPS'        DGDTAG                         CMX003
     C                   EXSR      EXT_FBPS                                     CMX003
                                                                                CMX003
     C     NO_EXTB       ENDSR                                                  CMX003
      ********************************************************************      CMX003
      /SPACE 5
      ********************************************************************
      * Get the user-defined account key
      ********************************************************************
     C     GET_ACKY      BEGSR
 
      * If start of month 'dummy' a/c key
 
     C     DEACKY03      IFEQ      *BLANK
     C     DEACKY02      ANDEQ     *BLANK                                       CMX003
     C     DEACKY01      ANDEQ     *BLANK                                       CMX003
     C                   MOVEL     'Y'           ACKY_Defin        1
     C                   Z-ADD     *ZERO         EADAC1
     C                   Z-ADD     *ZERO         EADAC2
     C                   Z-ADD     *ZERO         EADAC3
     C                   Z-ADD     *ZERO         EACAC1
     C                   Z-ADD     *ZERO         EACAC2
     C                   Z-ADD     *ZERO         EACAC3
     C                   ELSE
 
     C     FFKY          CHAIN     FACKYDF                            99        *
 
     C     *in99         IFEQ      '0'
     C     ACD1          IFNE      *ZERO
     C     ACD2          ORNE      *ZERO
     C     ACD3          ORNE      *ZERO
     C     ACD4          ORNE      *ZERO
     C     ACD5          ORNE      *ZERO
     C     ACD6          ORNE      *ZERO
     C     PRF1          ORNE      *ZERO
     C     PRF2          ORNE      *ZERO
     C     PRF3          ORNE      *ZERO
     C     PRF4          ORNE      *ZERO
     C     PRF5          ORNE      *ZERO
     C     PRF6          ORNE      *ZERO
     C                   MOVEL     'Y'           ACKY_Defin
     C                   Z-ADD     ACD1          EADAC1
     C                   Z-ADD     ACD2          EADAC2
     C                   Z-ADD     ACD3          EADAC3
     C                   Z-ADD     ACD4          EACAC1
     C                   Z-ADD     ACD5          EACAC2
     C                   Z-ADD     ACD6          EACAC3
     C                   ELSE
     C                   MOVEL     'N'           ACKY_Defin
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'N'           ACKY_Defin
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract trade daily events
      ********************************************************************
     C*****EXT_FTRD      BEGSR                                                  LLN021
     C     EXT_FTRS      BEGSR                                                  LLN021
 
      * Set account key template
 
     C*******************MOVEL     DGAK_FTRD     DGAK                           LLN021
     C                   MOVEL     DGAK_FTRS     DGAK                           LLN021
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    TDAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     TDAK          AK                             CMX006
     C                   MOVEA     TDWC          WC                             CMX006
     C                   EXSR      LOOK4WC                                      CMX006
     C                   Z-ADD     WC_Posn       @X                   99        CMX006
     C                   ENDIF                                                  CMX006
 
      * Not defined
     C     *IN99         IFEQ      '0'
 
      * Report if 'DIAGNOSTIC'
 
     C     DIAGEV        IFEQ      'Y'
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ACKNOTD
     C                   ENDIF
 
     C                   ELSE
 
      * Extracted
     C     TDTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     TDCC(@X)      DECATC
     C                   MOVEL     TDS1(@X)      DESNM1
     C                   MOVEL     TDS2(@X)      DESNM2
     C                   add       1             TDevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
     C                   WRITE     MXDEFFTP0
 
      * Not extracted
     C                   ELSE
 
      * Report if 'DIAGNOSTIC'
 
     C     DIAGEV        IFEQ      'Y'
     C                   Z-ADD     1             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ACKNOTX
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5                                                                  CMX003
      ********************************************************************      CMX003
      * Extract futures/options book position daily events                      CMX003
      ********************************************************************      CMX003
     C     EXT_FBPS      BEGSR                                                  CMX003
                                                                                CMX003
      * Set account key template                                                CMX003
                                                                                CMX003
     C                   MOVEL     DGAK_FBPS     DGAK                           CMX003
     C                   EXSR      SET_ACKY_T                                   CMX003
                                                                                CMX003
      * See if account key defined for extraction                               CMX003
                                                                                CMX003
     C                   Z-ADD     1             @X                             CMX003
     C     DEACKY        LOOKUP    BPAK(@X)                               99    CMX003
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     BPAK          AK                             CMX006
     C                   MOVEA     BPWC          WC                             CMX006
     C                   EXSR      LOOK4WC                                      CMX006
     C                   Z-ADD     WC_Posn       @X                   99        CMX006
     C                   ENDIF                                                  CMX006
                                                                                CMX003
      * Not defined                                                             CMX003
     C     *IN99         IFEQ      '0'                                          CMX003
                                                                                CMX003
      * Report if 'DIAGNOSTIC'                                                  CMX003
                                                                                CMX003
     C     DIAGEV        IFEQ      'Y'                                          CMX003
     C                   Z-ADD     1             CHLINE            3 0          CMX003
     C                   EXSR      PAG                                          CMX003
     C                   WRITE     ACKNOTD                                      CMX003
     C                   ENDIF                                                  CMX003
                                                                                CMX003
     C                   ELSE                                                   CMX003
                                                                                CMX003
      * Extracted                                                               CMX003
     C     BPTG(@X)      IFEQ      'Y'                                          CMX003
                                                                                CMX003
     C                   MOVEL     BPCC(@X)      DECATC                         CMX003
     C                   MOVEL     BPS1(@X)      DESNM1                         CMX003
     C                   MOVEL     BPS2(@X)      DESNM2                         CMX003
     C                   add       1             BPevt_cnt                      CMX003
     C                   EXSR      CAL_BSCYEQ                                   CMX003
     C                   ADD       1             EAEVID                         CMX003
     C                   WRITE     MXDEFFBP0                                    CMX003
                                                                                CMX003
      * Not extracted                                                           CMX003
     C                   ELSE                                                   CMX003
                                                                                CMX003
      * Report if 'DIAGNOSTIC'                                                  CMX003
                                                                                CMX003
     C     DIAGEV        IFEQ      'Y'                                          CMX003
     C                   Z-ADD     1             CHLINE                         CMX003
     C                   EXSR      PAG                                          CMX003
     C                   WRITE     ACKNOTX                                      CMX003
     C                   ENDIF                                                  CMX003
                                                                                CMX003
     C                   ENDIF                                                  CMX003
     C                   ENDIF                                                  CMX003
                                                                                CMX003
     C                   ENDSR                                                  CMX003
     C********************************************************************      CMX003
      /SPACE 5
      *****************************************************************
      * Set account key template
      ********************************************************************
     C     SET_ACKY_T    BEGSR
 
     C     DGAK01        IFNE      'Y'
     C                   MOVE      '*'           DEACKY01
     C                   END
     C     DGAK02        IFNE      'Y'
     C                   MOVE      '*'           DEACKY02
     C                   END
     C     DGAK03        IFNE      'Y'
     C                   MOVE      '*'           DEACKY03
     C                   END
     C     DGAK04        IFNE      'Y'
     C                   MOVE      '*'           DEACKY04
     C                   END
     C     DGAK05        IFNE      'Y'
     C                   MOVE      '*'           DEACKY05
     C                   END
     C     DGAK06        IFNE      'Y'
     C                   MOVE      '*'           DEACKY06
     C                   END
     C     DGAK07        IFNE      'Y'
     C                   MOVE      '*'           DEACKY07
     C                   END
     C     DGAK08        IFNE      'Y'
     C                   MOVE      '*'           DEACKY08
     C                   END
     C     DGAK09        IFNE      'Y'
     C                   MOVE      '*'           DEACKY09
     C                   END
     C     DGAK10        IFNE      'Y'
     C                   MOVE      '*'           DEACKY10
     C                   END
     C     DGAK11        IFNE      'Y'
     C                   MOVE      '*'           DEACKY11
     C                   END
     C     DGAK12        IFNE      'Y'
     C                   MOVE      '*'           DEACKY12
     C                   END
     C     DGAK13        IFNE      'Y'
     C                   MOVE      '*'           DEACKY13
     C                   END
     C     DGAK14        IFNE      'Y'
     C                   MOVE      '*'           DEACKY14
     C                   END
     C     DGAK15        IFNE      'Y'                                                        LLN021
     C                   MOVE      '*'           DEACKY15                                     LLN021
     C                   END                                                                  LLN021
     C     DGAK16        IFNE      'Y'                                                        LLN021
     C                   MOVE      '*'           DEACKY16                                     LLN021
     C                   END                                                                  LLN021
     C     DGAK17        IFNE      'Y'                                                        LLN021
     C                   MOVE      '*'           DEACKY17                                     LLN021
     C                   END                                                                  LLN021
     C     DGAK18        IFNE      'Y'                                                        LLN021
     C                   MOVE      '*'           DEACKY18                                     LLN021
     C                   END                                                                  LLN021
     C     DGAK19        IFNE      'Y'                                                        LLN021
     C                   MOVE      '*'           DEACKY19                                     LLN021
     C                   END                                                                  LLN021
     C     DGAK20        IFNE      'Y'                                                        LLN021
     C                   MOVE      '*'           DEACKY20                                     LLN021
     C                   END                                                                  LLN021
                                                                                CMX006
     C                   MOVEL     DEACKY        S_DEACKY         14            CMX006
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                  CMX006
      *****************************************************************         CMX006
      * Look For Wildcards                                                      CMX006
      ********************************************************************      CMX006
     C     LOOK4WC       BEGSR                                                  CMX006
                                                                                CMX006
     C                   Z-ADD     *ZERO         WC_POSN           3 0          CMX006
                                                                                CMX006
     C     WC(1)         CABEQ     *BLANK        ELOOK4WC                       CMX006
                                                                                CMX006
     C                   Z-ADD     1             @W                3 0          CMX006
     C     @W            DOUGT     99                                           CMX006
     C     WC(@W)        OREQ      *BLANK                                       CMX006
     C     WC_POSN       ORNE      *ZERO                                        CMX006
                                                                                CMX006
     C                   MOVEA     WC(@W)        WildAR                         CMX006
     C                   MOVEA     S_DEACKY      AckyAR                         CMX006
                                                                                CMX006
     C                   Z-ADD     1             @Q                3 0          CMX006
     C     *in98         DOUEQ     '0'                                          CMX006
     C     @Q            ORGT      20                                           CMX006
     C     '!'           LOOKUP    WildAR(@Q)                             98    CMX006
     C     *in98         IFEQ      '1'                                          CMX006
     C                   MOVEL     '!'           AckyAR(@Q)                     CMX006
     C                   ADD       1             @Q                             CMX006
     C                   ENDIF                                                  CMX006
     C                   ENDDO                                                  CMX006
                                                                                CMX006
     C     WildString    IFEQ      AckyString                                   CMX006
     C                   Z-ADD     1             WC_POSN                        CMX006
     C     WildString    LOOKUP    AK(WC_POSN)                            98    CMX006
     C                   ELSE                                                   CMX006
     C                   ADD       1             @W                             CMX006
     C                   ENDIF                                                  CMX006
                                                                                CMX006
     C                   ENDDO                                                  CMX006
                                                                                CMX006
     C     ELOOK4WC      ENDSR                                                  CMX006
      *****************************************************************         CMX006
      /SPACE 5
      *********************************************************************
      * PAG - Page change processing
      ********************************************************************
     C     PAG           BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM            3 0
     C     DIAGEV        COMP      'Y'                                    50    *
     C                   WRITE     PAGEHEAD
     C     4             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Output totals
      ********************************************************************
     C     TOTALS        BEGSR
 
      * Output end of report totals
 
     C                   Z-ADD     14            CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      *********************************************************************
      * Load data group event categories for selection (and template)
      ********************************************************************
     C     LOAD_DGEC     BEGSR
 
      * Clear outputs
 
     C                   MOVEL     *BLANK        AK
     C                   MOVEL     *BLANK        TG
     C                   MOVEL     *BLANK        CC
     C                   MOVEL     *BLANK        S1
     C                   MOVEL     *BLANK        S2
     C                   MOVEL     *BLANK        WC                             CMX006
 
      * Get Data Group Details
 
     C     DGDTAG        CHAIN     MXDGDTP0                           99        *
     C     *in99         IFEQ      '1'
     C                   EVAL      I#ERMS = 'NO RECORD ON MXDGDTPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If the data group is not enabled, then blank template
      * and bypass
 
     C     DGENAB        IFNE      'Y'
     C                   MOVEL     *BLANK        DGAK
     C                   GOTO      ELOAD_DGEC
     C                   ENDIF
 
      * Get data group event categories
 
     C                   Z-ADD     0             @X                3 0
     C                   Z-ADD     0             @Y                3 0          CMX006
     C     DGDTAG        SETLL     MXDGECP0
     C     DGDTAG        READE     MXDGECP0                               99    *
     C     *in99         DOWEQ     '0'
     C                   ADD       1             @X
     C                   MOVEL     DEACKY        AK(@X)
     C                   MOVEL     DETRIG        TG(@X)
     C                   MOVEL     DECATC        CC(@X)
     C                   MOVEL     DESNM1        S1(@X)
     C                   MOVEL     DESNM2        S2(@X)
     C     '!'           SCAN      DEACKY                                 98    CMX006
     C     *in98         IFEQ      '1'                                          CMX006
     C                   ADD       1             @Y                             CMX006
     C                   MOVEL     DEACKY        WC(@Y)                         CMX006
     C                   ENDIF                                                  CMX006
     C     DGDTAG        READE     MXDGECP0                               99    *
     C                   ENDDO
 
     C     ELOAD_DGEC    ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * Calculate Base Currency Equivalent Of Posting Amount
      ********************************************************************
     C     CAL_BSCYEQ    BEGSR
 
      * Get event currency details
 
     C                   MOVEL     EVCY          I#LFD1
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the currency code was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID CURRENCY IN MXACSCURR'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      SDCURR = InData
 
      * Set event currency decimal places
 
     C                   Z-ADD     A6NBDP        ECDP
 
      *  Convert the event amount to base currency
 
     C                   CALLB     'ZCONV'
     C                   PARM      EVAM          ZAMTCI           15 0
     C                   PARM      A6SPRT        ZEXCH            13 8
     C                   PARM      A6MDIN        ZMD               1
     C                   PARM      EVCY          ZCCYI             3
     C                   PARM      BJCYCD        ZCCYO             3
     C                   PARM      A6NBDP        ZCDPI             1 0
     C                   PARM      BasCcyDec     ZCDPO             1 0
     C                   PARM      *ZERO         ZAMTCO           15 0
 
     C                   Z-ADD     ZAMTCO        BCEQ
 
      * Set base currency and base currency decimal places
 
     C                   MOVEL     BJCYCD        BCCY
     C                   Z-ADD     BasCcyDec     BCDP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Set up constants
 
     C                   MOVEL     'A'           I#EXTT
 
      **  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Get export control details on data-area
 
     C     *DTAARA       DEFINE                  MXEXPCTL
     C                   IN        MXEXPCTL
 
      * Get base currency details
 
     C                   MOVEL     BJCYCD        I#LFD1
     C                   CALLB     'MXACSCURR'
     C/COPY MXCPYSRC,MXACSPRME
 
      * Error if the base currency was not found
 
     C     ACS_RTCD      IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'INVALID BASE CURRENCY'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Set base currency decimal places
 
     C                   EVAL      SDCURR = InData
     C                   Z-ADD     A6NBDP        BasCcyDec         1 0
 
      * Initialize Event Generation Date & Event ID
 
     C                   Z-ADD     BJRDNB        EAEVGD
     C                   Z-ADD     *ZERO         EAEVID
 
 
      **Load*FTRD*event*categories for selection (and template)                 LLN021
      * Load FTRS event categories for selection (and template)                 LLN021
 
     C*****************  MOVEL     'FTRD'        DGDTAG                         LLN021
     C                   MOVEL     'FTRS'        DGDTAG                         LLN021
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            TDAK
     C                   MOVEA     TG            TDTG
     C                   MOVEA     CC            TDCC
     C                   MOVEA     S1            TDS1
     C                   MOVEA     S2            TDS2
     C                   MOVEA     WC            TDWC                           CMX006
     C****************** MOVEL     DGAK          DGAK_FTRD        20            LLN021
     C                   MOVEL     DGAK          DGAK_FTRS        20            LLN021
                                                                                CMX003
                                                                                CMX003
      * Load FBPS event categories for selection (and template)                 CMX003
                                                                                CMX003
     C                   MOVEL     'FBPS'        DGDTAG                         CMX003
     C                   EXSR      LOAD_DGEC                                    CMX003
     C                   MOVEA     AK            BPAK                           CMX003
     C                   MOVEA     TG            BPTG                           CMX003
     C                   MOVEA     CC            BPCC                           CMX003
     C                   MOVEA     S1            BPS1                           CMX003
     C                   MOVEA     S2            BPS2                           CMX003
     C                   MOVEA     WC            BPWC                           CMX006
     C                   MOVEL     DGAK          DGAK_FBPS        20            CMX003
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Open the printer file
 
     C*******************OPEN      MXDEEXSAU                                                  LLN021
     C                   OPEN      BY6001AU                                                   LLN021
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Zeroize count of records read
      * Zeroize counts of events
 
     C                   Z-ADD     *ZERO         Trec_cnt          6 0
     C                   Z-ADD     *ZERO         TDevt_cnt         6 0
     C                   Z-ADD     *ZERO         BPevt_cnt         6 0                        CMX003
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
