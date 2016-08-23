     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*XBIA*  OVRDBF FILE(DEFXDL) TOFILE(MXDEDLPD)                         *
/*XBIB*  OVRDBF FILE(DELDNI) TOFILE(MXDEDLPD)                         *
/*XBIC*  OVRDBF FILE(DENASP) TOFILE(MXDEDLPD)                         *
/*XBID*  OVRDBF FILE(DENASS) TOFILE(MXDEDLPD)                         *
/*XBIE*  OVRDBF FILE(DEFRAS) TOFILE(MXDEDLPD)                         *
/*XBIF*  OVRDBF FILE(DESIRS) TOFILE(MXDEDLPD)                         *
/*XBIG*  OVRDBF FILE(DECIRS) TOFILE(MXDEDLPD)                         *
/*XBIH*  OVRDBF FILE(DECFCO) TOFILE(MXDEDLPD)                         *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Daily events extract - dealing')
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDEEXDL - Daily Events Extract - Dealing Module             *
      *                                                               *
      *  Function:  This module extracts dealing daily events.        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. LLN022             Date 03Jun15               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 241970             Data 05Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CPK025             Date 16May06               *
      *                 240744             Date 06Jun06               *
      *                 240728             Date 06Jun06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CMX006             Date 10May01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Core hooks added:MXDEEXDLD1,MXDEEXDLD2,MXDEEXDL01   *
      *                            MXDEEXDL02                         *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPK025 - MidasPlus 1.3 packaging.                            *
      *  240744 - Correct coding in GET_AKEY routine.                 *
      *  240728 - Update of shortcode 2 with fee code                 *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CMX006 - Event Category Wildcards                            *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXAKDLL1  IP   E           K DISK    INFSR(*PSSR)
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     FDEFXDL    O    E             DISK    RENAME(MXDEDLP0:DEFXDLP0)INFSR(*PSSR)
     FDELDNI    O    E             DISK    RENAME(MXDEDLP0:DELDNIP0)INFSR(*PSSR)
     FDENASP    O    E             DISK    RENAME(MXDEDLP0:DENASPP0)INFSR(*PSSR)
     FDENASS    O    E             DISK    RENAME(MXDEDLP0:DENASSP0)INFSR(*PSSR)
     FDEFRAS    O    E             DISK    RENAME(MXDEDLP0:DEFRASP0)INFSR(*PSSR)
     FDESIRS    O    E             DISK    RENAME(MXDEDLP0:DESIRSP0)INFSR(*PSSR)
     FDECIRS    O    E             DISK    RENAME(MXDEDLP0:DECIRSP0)INFSR(*PSSR)
     FDECFCO    O    E             DISK    RENAME(MXDEDLP0:DECFCOP0)INFSR(*PSSR)
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDEEXDAU O    E             PRINTER INFSR(*PSSR)  USROPN
 
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
 
     D                 DS                                                       240728
     D  Dsc2                   1      4                                         240728
     D  Dsc21                  1      1                                         240728
     D  Dsc22                  2      2                                         240728
     D  Dsc23                  3      3                                         240728
     D  Dsc24                  4      4                                         240728
 
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
     D  DGAK15                15     15
     D  DGAK16                16     16
     D  DGAK17                17     17
     D  DGAK18                18     18
     D  DGAK19                19     19
     D  DGAK20                20     20
 
     D                 DS
     D  DEACKY                 1     20
     D  DTYP                   1      2
     D  DLST                   4      5
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
     D  DEACKY15              15     15
     D  DEACKY16              16     16
     D  DEACKY17              17     17
     D  DEACKY18              18     18
     D  DEACKY19              19     19
     D  DEACKY20              20     20
 
 
     D AK              S             20    DIM(99)
     D TG              S              1    DIM(99)
     D CC              S              2    DIM(99)
     D S1              S              4    DIM(99)
     D S2              S              4    DIM(99)
     D WC              S             20    DIM(99)                              CMX006
 
     D FXDT            S              2    DIM(8) CTDATA PERRCD(1)
     D FXAK            S             20    DIM(99)
     D FXTG            S              1    DIM(99)
     D FXCC            S              2    DIM(99)
     D FXS1            S              4    DIM(99)
     D FXS2            S              4    DIM(99)
     D FXWC            S             20    DIM(99)                              CMX006
 
      /COPY WNCPYSRC,MXDEEXDLD1                                                               LLN022
     D LDDT            S              2    DIM(11) CTDATA PERRCD(1)
      /COPY WNCPYSRC,MXDEEXDLD2                                                               LLN022
     D LDAK            S             20    DIM(99)
     D LDTG            S              1    DIM(99)
     D LDCC            S              2    DIM(99)
     D LDS1            S              4    DIM(99)
     D LDS2            S              4    DIM(99)
     D LDWC            S             20    DIM(99)                              CMX006
 
     D NPDT            S              2    DIM(7) CTDATA PERRCD(1)
     D NPAK            S             20    DIM(99)
     D NPTG            S              1    DIM(99)
     D NPCC            S              2    DIM(99)
     D NPS1            S              4    DIM(99)
     D NPS2            S              4    DIM(99)
     D NPWC            S             20    DIM(99)                              CMX006
 
     D NSDT            S              2    DIM(6) CTDATA PERRCD(1)
     D NSAK            S             20    DIM(99)
     D NSTG            S              1    DIM(99)
     D NSCC            S              2    DIM(99)
     D NSS1            S              4    DIM(99)
     D NSS2            S              4    DIM(99)
     D NSWC            S             20    DIM(99)                              CMX006
 
     D FRDT            S              2    DIM(1) CTDATA PERRCD(1)
     D FRAK            S             20    DIM(99)
     D FRTG            S              1    DIM(99)
     D FRCC            S              2    DIM(99)
     D FRS1            S              4    DIM(99)
     D FRS2            S              4    DIM(99)
     D FRWC            S             20    DIM(99)                              CMX006
 
     D SIDT            S              2    DIM(1) CTDATA PERRCD(1)
     D SIAK            S             20    DIM(99)
     D SITG            S              1    DIM(99)
     D SICC            S              2    DIM(99)
     D SIS1            S              4    DIM(99)
     D SIS2            S              4    DIM(99)
     D SIWC            S             20    DIM(99)                              CMX006
 
     D CIDT            S              2    DIM(1) CTDATA PERRCD(1)
     D CIAK            S             20    DIM(99)
     D CITG            S              1    DIM(99)
     D CICC            S              2    DIM(99)
     D CIS1            S              4    DIM(99)
     D CIS2            S              4    DIM(99)
     D CIWC            S             20    DIM(99)                              CMX006
 
     D CODT            S              2    DIM(3) CTDATA PERRCD(1)
     D COAK            S             20    DIM(99)
     D COTG            S              1    DIM(99)
     D COCC            S              2    DIM(99)
     D COS1            S              4    DIM(99)
     D COS2            S              4    DIM(99)
     D COWC            S             20    DIM(99)                              CMX006
 
 
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
      * Current Deal Type/Sub Type
     D                 DS
     D Curr_DTST               1      4
     D Curr_DTYP               1      2
     D Curr_DLST               3      4
 
 
      * Previous Branch
     D                 DS
     D Prev_BRCA               1      3
      * Previous Deal Type/Sub Type
     D                 DS
     D Prev_DTST               1      4
     D Prev_DTYP               1      2
     D Prev_DLST               3      4
 
 
     D                 DS                                                                     CDL038
     D EXAKEY                  1     14                                                       CDL038
     D AKEY                    1     10                                                       CDL038
                                                                                              CDL038
                                                                                              CDL038
     IDKEYSDPF                                                                                CDL038
     I              AKEY                        EXAKEY                                        CDL038
     IACKEYAKF                                                                                CDL038
     I              AKEY                        EXAKEY                                        CDL038
     IACKEYALF                                                                                CDL038
     I              AKEY                        EXAKEY                                        CDL038
                                                                                              CDL038
                                                                                              CDL038
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
      * Add 1 to count of records read
 
     C                   add       1             rec_cnt
 
      * Set up account key
 
     C                   MOVEL     *BLANK        DEACKY
     C                   MOVEL     AKEY          DEACKY
 
      * On change of account key
      * Get the user-defined account key
 
     C     AKEY          IFNE      Prev_AKEY
     C                   EXSR      GET_AKEY
     C*****              MOVEL     AKEY          Prev_AKEY        10                          CPK025
     C                   MOVEL     AKEY          Prev_AKEY        14                          CPK025
     C                   ENDIF
 
      * Ignore this account key if it is not defined
 
     C     AKEY_Defin    IFNE      'Y'
     C                   GOTO      NO_EXP
     C                   ENDIF
 
      * On change of branch
      * Determine if branch is to be included in the export
 
     C                   MOVEL     BRCA          Curr_BRCA
     C     Curr_BRCA     IFNE      Prev_BRCA
     C                   MOVE      'D'           I#LD
     C                   MOVEL     BRCA          I#BRCA
     C                   EXSR      BRCA_FLT
     C                   MOVEL     Curr_BRCA     Prev_BRCA
     C                   ENDIF
 
      * On change of deal type/sub type
      * Determine if deal type/sub type is to be included in the export
 
     C                   MOVEL     DTYP          Curr_DTYP
     C                   MOVEL     DLST          Curr_DLST
     C     Curr_DTST     IFNE      Prev_DTST
     C                   MOVE      'D'           I#LD
     C                   MOVEL     DTYP          I#DTYP
     C                   MOVEL     DLST          I#DLST
     C                   EXSR      DTST_FLT
     C                   MOVEL     Curr_DTST     Prev_DTST
     C                   ENDIF
 
      * If branch is NOT for export
      * or if deal type/sub type is NOT for export
      * Ignore this account key
 
     C     Exp_BRCA      IFNE      'Y'
     C     Exp_DTST      ORNE      'Y'
     C                   GOTO      NO_EXP
     C                   ENDIF
 
      * Extract foreign exchange daily events
 
     C     DTYP          LOOKUP    FXDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_FXDL     ANDNE     *BLANK
     C                   MOVEL     'FXDL'        DGDTAG
     C                   EXSR      EXT_FXDL
     C                   ELSE
 
      * Extract loan/deposit daily events
 
     C     DTYP          LOOKUP    LDDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_LDNI     ANDNE     *BLANK
     C                   MOVEL     'LDNI'        DGDTAG
     C                   EXSR      EXT_LDNI
     C                   ELSE
 
      * Extract NAs purchased daily events
 
     C     DTYP          LOOKUP    NPDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_NASP     ANDNE     *BLANK
     C                   MOVEL     'NASP'        DGDTAG
     C                   EXSR      EXT_NASP
     C                   ELSE
 
      * Extract NAs sold daily events
 
     C     DTYP          LOOKUP    NSDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_NASS     ANDNE     *BLANK
     C                   MOVEL     'NASS'        DGDTAG
     C                   EXSR      EXT_NASS
     C                   ELSE
 
      * Extract forward rate agreement daily events
 
     C     DTYP          LOOKUP    FRDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_FRAS     ANDNE     *BLANK
     C                   MOVEL     'FRAS'        DGDTAG
     C                   EXSR      EXT_FRAS
     C                   ELSE
 
      * Extract single currency interest rate swap daily events
 
     C     DTYP          LOOKUP    SIDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_SIRS     ANDNE     *BLANK
     C                   MOVEL     'SIRS'        DGDTAG
     C                   EXSR      EXT_SIRS
     C                   ELSE
 
      * Extract cross currency interest rate swap daily events
 
     C     DTYP          LOOKUP    CIDT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_CIRS     ANDNE     *BLANK
     C                   MOVEL     'CIRS'        DGDTAG
     C                   EXSR      EXT_CIRS
     C                   ELSE
 
      * Extract cap, collar floor option daily events
 
     C     DTYP          LOOKUP    CODT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_CFCO     ANDNE     *BLANK
     C                   MOVEL     'CFCO'        DGDTAG
     C                   EXSR      EXT_CFCO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     NO_EXP        TAG
 
     CLR                 EXSR      TOTALS
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Get the user-defined account key
      ********************************************************************
     C     GET_AKEY      BEGSR
 
      * If start of month 'dummy' a/c key
 
     C     DEACKY03      IFEQ      *BLANK
     C                   MOVEL     'Y'           AKEY_Defin        1
     C                   Z-ADD     *ZERO         EADAC1
     C                   Z-ADD     *ZERO         EADAC2
     C                   Z-ADD     *ZERO         EADAC3
     C                   Z-ADD     *ZERO         EACAC1
     C                   Z-ADD     *ZERO         EACAC2
     C                   Z-ADD     *ZERO         EACAC3
     C                   ELSE
 
     C     EXAKEY        CHAIN     ACKEYALF                           99        *             CDL038
     C*****AKEY**********CHAIN     ACKEYALF                           99        *             CDL038
 
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
     C*****PRF6***       OREQ      *ZERO                                        RUBBISH       240744
     C                   MOVEL     'Y'           AKEY_Defin
     C                   Z-ADD     ACD1          EADAC1
     C                   Z-ADD     ACD2          EADAC2
     C                   Z-ADD     ACD3          EADAC3
     C                   Z-ADD     ACD4          EACAC1
     C                   Z-ADD     ACD5          EACAC2
     C                   Z-ADD     ACD6          EACAC3
     C                   ELSE
     C************       MOVEL     'Y'           AKEY_Defin                                   240744
     C                   MOVEL     'N'           AKEY_Defin                                   240744
     C                   ENDIF
     C                   ELSE
      /COPY WNCPYSRC,MXDEEXDL01                                                               LLN022
     C************       MOVEL     'Y'           AKEY_Defin                                   240744
     C                   MOVEL     'N'           AKEY_Defin                                   240744
                                                                                              LLN022
      /COPY WNCPYSRC,MXDEEXDL02                                                               LLN022
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract foreign exchange daily events
      ********************************************************************
     C     EXT_FXDL      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_FXDL     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    FXAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     FXAK          AK                             CMX006
     C                   MOVEA     FXWC          WC                             CMX006
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
     C     FXTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     FXCC(@X)      DECATC
     C                   MOVEL     FXS1(@X)      DESNM1
     C                   MOVEL     FXS2(@X)      DESNM2
     C                   add       1             FXevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DEFXDLP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract loan/deposit daily events
      ********************************************************************
     C     EXT_LDNI      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_LDNI     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    LDAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     LDAK          AK                             CMX006
     C                   MOVEA     LDWC          WC                             CMX006
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
     C     LDTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     LDCC(@X)      DECATC
     C                   MOVEL     LDS1(@X)      DESNM1
     C                   MOVEL     LDS2(@X)      DESNM2
     C                   add       1             LDevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DELDNIP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract NAs purchased daily events
      ********************************************************************
     C     EXT_NASP      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_NASP     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    NPAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     NPAK          AK                             CMX006
     C                   MOVEA     NPWC          WC                             CMX006
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
     C     NPTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     NPCC(@X)      DECATC
     C                   MOVEL     NPS1(@X)      DESNM1
     C                   MOVEL     NPS2(@X)      DESNM2
     C                   add       1             NPevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DENASPP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract NAs sold daily events
      ********************************************************************
     C     EXT_NASS      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_NASS     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    NSAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     NSAK          AK                             CMX006
     C                   MOVEA     NSWC          WC                             CMX006
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
     C     NSTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     NSCC(@X)      DECATC
     C                   MOVEL     NSS1(@X)      DESNM1
     C                   MOVEL     NSS2(@X)      DESNM2
     C                   add       1             NSevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DENASSP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract forward rate agreement daily events
      ********************************************************************
     C     EXT_FRAS      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_FRAS     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    FRAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     FRAK          AK                             CMX006
     C                   MOVEA     FRWC          WC                             CMX006
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
     C     FRTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     FRCC(@X)      DECATC
     C                   MOVEL     FRS1(@X)      DESNM1
     C                   MOVEL     FRS2(@X)      DESNM2
     C                   add       1             FRevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DEFRASP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract single currency interest rate swap daily events
      ********************************************************************
     C     EXT_SIRS      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_SIRS     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    SIAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     SIAK          AK                             CMX006
     C                   MOVEA     SIWC          WC                             CMX006
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
     C     SITG(@X)      IFEQ      'Y'
 
     C                   MOVEL     SICC(@X)      DECATC
     C                   MOVEL     SIS1(@X)      DESNM1
     C                   MOVEL     SIS2(@X)      DESNM2
     C                   add       1             SIevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DESIRSP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract cross currency interest rate swap daily events
      ********************************************************************
     C     EXT_CIRS      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_CIRS     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    CIAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     CIAK          AK                             CMX006
     C                   MOVEA     CIWC          WC                             CMX006
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
     C     CITG(@X)      IFEQ      'Y'
 
     C                   MOVEL     CICC(@X)      DECATC
     C                   MOVEL     CIS1(@X)      DESNM1
     C                   MOVEL     CIS2(@X)      DESNM2
     C                   add       1             CIevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DECIRSP0
 
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
      /SPACE 5
      ********************************************************************
      * Extract cap, collar floor option daily events
      ********************************************************************
     C     EXT_CFCO      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_CFCO     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    COAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     COAK          AK                             CMX006
     C                   MOVEA     COWC          WC                             CMX006
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
     C     COTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     COCC(@X)      DECATC
     C                   MOVEL     COS1(@X)      DESNM1
     C                   MOVEL     COS2(@X)      DESNM2
     C                   add       1             COevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DECFCOP0
 
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
     C     DGAK15        IFNE      'Y'
     C                   MOVE      '*'           DEACKY15
     C                   END
     C     DGAK16        IFNE      'Y'
     C                   MOVE      '*'           DEACKY16
     C                   END
     C     DGAK17        IFNE      'Y'
     C                   MOVE      '*'           DEACKY17
     C                   END
     C     DGAK18        IFNE      'Y'
     C                   MOVE      '*'           DEACKY18
     C                   END
     C     DGAK19        IFNE      'Y'
     C                   MOVE      '*'           DEACKY19
     C                   END
     C     DGAK20        IFNE      'Y'
     C                   MOVE      '*'           DEACKY20
     C                   END
                                                                                CMX006
     C                   MOVEL     DEACKY        S_DEACKY         20            CMX006
 
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
 
     C                   Z-ADD     24            CHLINE            3 0
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
      * Calculate Base Currency Equivalent Of Event Amount
      ********************************************************************
     C     CAL_BSCYEQ    BEGSR
 
      * Get event currency details
 
     C                   MOVEL     ECCY          I#LFD1
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
     C                   PARM      EAMT          ZAMTCI           15 0
     C                   PARM      A6SPRT        ZEXCH            13 8
     C                   PARM      A6MDIN        ZMD               1
     C                   PARM      ECCY          ZCCYI             3
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
 
      * Load FXDL event categories for selection (and template)
 
     C                   MOVEL     'FXDL'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            FXAK
     C                   MOVEA     TG            FXTG
     C                   MOVEA     CC            FXCC
     C                   MOVEA     S1            FXS1
     C                   MOVEA     S2            FXS2
     C                   MOVEA     WC            FXWC                           CMX006
     C                   MOVEL     DGAK          DGAK_FXDL        20
 
 
      * Load LDNI event categories for selection (and template)
 
     C                   MOVEL     'LDNI'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            LDAK
     C                   MOVEA     TG            LDTG
     C                   MOVEA     CC            LDCC
     C                   MOVEA     S1            LDS1
     C                   MOVEA     S2            LDS2
     C                   MOVEA     WC            LDWC                           CMX006
     C                   MOVEL     DGAK          DGAK_LDNI        20
 
      * Load NASP event categories for selection (and template)
 
     C                   MOVEL     'NASP'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            NPAK
     C                   MOVEA     TG            NPTG
     C                   MOVEA     CC            NPCC
     C                   MOVEA     S1            NPS1
     C                   MOVEA     S2            NPS2
     C                   MOVEA     WC            NPWC                           CMX006
     C                   MOVEL     DGAK          DGAK_NASP        20
 
      * Load NASS event categories for selection (and template)
 
     C                   MOVEL     'NASS'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            NSAK
     C                   MOVEA     TG            NSTG
     C                   MOVEA     CC            NSCC
     C                   MOVEA     S1            NSS1
     C                   MOVEA     S2            NSS2
     C                   MOVEA     WC            NSWC                           CMX006
     C                   MOVEL     DGAK          DGAK_NASS        20
 
      * Load FRAS event categories for selection (and template)
 
     C                   MOVEL     'FRAS'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            FRAK
     C                   MOVEA     TG            FRTG
     C                   MOVEA     CC            FRCC
     C                   MOVEA     S1            FRS1
     C                   MOVEA     S2            FRS2
     C                   MOVEA     WC            FRWC                           CMX006
     C                   MOVEL     DGAK          DGAK_FRAS        20
 
      * Load SIRS event categories for selection (and template)
 
     C                   MOVEL     'SIRS'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            SIAK
     C                   MOVEA     TG            SITG
     C                   MOVEA     CC            SICC
     C                   MOVEA     S1            SIS1
     C                   MOVEA     S2            SIS2
     C                   MOVEA     WC            SIWC                           CMX006
     C                   MOVEL     DGAK          DGAK_SIRS        20
 
      * Load CIRS event categories for selection (and template)
 
     C                   MOVEL     'CIRS'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            CIAK
     C                   MOVEA     TG            CITG
     C                   MOVEA     CC            CICC
     C                   MOVEA     S1            CIS1
     C                   MOVEA     S2            CIS2
     C                   MOVEA     WC            CIWC                           CMX006
     C                   MOVEL     DGAK          DGAK_CIRS        20
 
      * Load CFCO event categories for selection (and template)
 
     C                   MOVEL     'CFCO'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            COAK
     C                   MOVEA     TG            COTG
     C                   MOVEA     CC            COCC
     C                   MOVEA     S1            COS1
     C                   MOVEA     S2            COS2
     C                   MOVEA     WC            COWC                           CMX006
     C                   MOVEL     DGAK          DGAK_CFCO        20
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Load deal type/sub types for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      DTST_FLT
 
      * Open the printer file
 
     C                   OPEN      MXDEEXDAU
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Zeroize count of records read
      * Zeroize counts of events
 
     C                   Z-ADD     *ZERO         rec_cnt           6 0
     C                   Z-ADD     *ZERO         FXevt_cnt         6 0
     C                   Z-ADD     *ZERO         LDevt_cnt         6 0
     C                   Z-ADD     *ZERO         NPevt_cnt         6 0
     C                   Z-ADD     *ZERO         NSevt_cnt         6 0
     C                   Z-ADD     *ZERO         FRevt_cnt         6 0
     C                   Z-ADD     *ZERO         SIevt_cnt         6 0
     C                   Z-ADD     *ZERO         CIevt_cnt         6 0
     C                   Z-ADD     *ZERO         COevt_cnt         6 0
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *********************************************************************     240728
      * FEE_UPD- Update Short Code 2 with fee code when 'FNN'                   240728
      ********************************************************************      240728
     C     FEE_UPD       BEGSR                                                  240728
                                                                                240728
      * Move Fee Code to Short Name 2                                           240728
                                                                                240728
     C                   MOVEL     *BLANKS       DSC2                           240728
     C                   MOVEL     DESNM2        DSC2                           240728
     C                   MOVEL     DEACKY08      DSC22                          240728
     C                   MOVEL     DEACKY09      DSC23                          240728
     C                   MOVEL     DSC2          DESNM2                         240728
                                                                                240728
     C                   ENDSR                                                  240728
      ********************************************************************      240728
      /SPACE 5                                                                  240728
      *********************************************************************
      * B R A N C H   F I L T E R
      /COPY MXCPYSRC,MXFLTBRCA
      ********************************************************************
      /SPACE 5
      *********************************************************************
      * D E A L  T Y P E  / S U B   T Y P E   F I L T E R
      /COPY MXCPYSRC,MXFLTDTST
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** FXDT - FXDL Deal Types
FP
FS
CX
PI
SI
SW
OP
OT
** LDDT - LDNI Deal Types
IP
TI
CL
LN
DL
IT
TD
CD
CI
ID
IL
** NPDT - NASP Deal Types
C1
C2
BP
BD
TB
DA
TA
** NSDT - NASS Deal Types
CS
BS
BR
TS
RA
TR
** FRDT - FRAS Deal Types
FR
** SIDT - SIRS Deal Types
RS
** CIDT - CIRS Deal Types
RX
** CODT - CFCO Deal Types
RP
RF
RR
