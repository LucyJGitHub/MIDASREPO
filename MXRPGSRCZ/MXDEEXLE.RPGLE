     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(DECLLN) TOFILE(MXDELELPD)                        *
/*XBIB*  OVRDBF FILE(DECLPS) TOFILE(MXDELELPD)                        *
/*XBIC*  OVRDBF FILE(DECLGU) TOFILE(MXDELELPD)                        *
/*XBID*  OVRDBF FILE(DEFCLT) TOFILE(MXDELEFPD)                        *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MX Daily events extract - lending')              *
      *****************************************************************
      *                                                               *
      *  Midas - Meridian Export Module                               *
      *                                                               *
      *  MXDEEXLE - Daily Events Extract - Lending Module             *
      *                                                               *
      *  Function:  This module extracts lending daily events         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1056323          Date 14Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CPK027             Date 18Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243499             Date 08Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241970             Data 05Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 240728             Date 06Jun06               *
      *                 CLE042             Date 06Sep05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CMX006             Date 10May01               *
      *                 CMX003             Date 05Nov00               *
      *                 CMX001  *CREATE    Data 01Jan00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1056323 - Revert back changes of CLE134 for LKEY1DP and    *
      *              LKEYFED (Recompile)                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CPK027 - Error in 243499 - LKOLNO should now be 6A (recomp.) *
      *  243499 - Recompile for change to file LKEYFED.               *
      *  241970 - Recompiled due to change in MXACSPRME.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  240728 - Update of shortcode 2 with fee code                 *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CMX006 - Event Category Wildcards                            *
      *  CMX003 - Meridian Export Enhancements - Phase 2              *
      *           (RE-COMPILE OVER CHANGED /COPY)                     *
      *  CMX001 - Meridian Export                                     *
      *                                                               *
      *****************************************************************
 
     FMXAKLNL1  IP   E           K DISK    INFSR(*PSSR)
     FMXAKLFL1  IS   E           K DISK    INFSR(*PSSR)
     FACKEY     IF   E           K DISK    INFSR(*PSSR)
     FDECLLN    O    E             DISK    RENAME(MXDELELP0:DECLLNP0)
     F                                     INFSR(*PSSR)
     FDECLPS    O    E             DISK    RENAME(MXDELELP0:DECLPSP0)
     F                                     INFSR(*PSSR)
     FDECLGU    O    E             DISK    RENAME(MXDELELP0:DECLGUP0)
     F                                     INFSR(*PSSR)
     FDEFCLT    O    E             DISK    RENAME(MXDELEFP0:DEFCLTP0)
     F                                     INFSR(*PSSR)
     FMXDGDTPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDGECPD  IF   E           K DISK    INFSR(*PSSR)
     FMXDEEXLAU O    E             PRINTER INFSR(*PSSR)  USROPN
 
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
     D  LNTY                   1      2
     D  LNST                   4      5
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
 
     D LNPT            S              2    DIM(10) CTDATA PERRCD(1)
     D LNAK            S             20    DIM(99)
     D LNTG            S              1    DIM(99)
     D LNCC            S              2    DIM(99)
     D LNS1            S              4    DIM(99)
     D LNS2            S              4    DIM(99)
     D LNWC            S             20    DIM(99)                              CMX006
 
     D PSPT            S              2    DIM(10) CTDATA PERRCD(1)
     D PSAK            S             20    DIM(99)
     D PSTG            S              1    DIM(99)
     D PSCC            S              2    DIM(99)
     D PSS1            S              4    DIM(99)
     D PSS2            S              4    DIM(99)
     D PSWC            S             20    DIM(99)                              CMX006
 
     D GUPT            S              2    DIM(10) CTDATA PERRCD(1)
     D GUAK            S             20    DIM(99)
     D GUTG            S              1    DIM(99)
     D GUCC            S              2    DIM(99)
     D GUS1            S              4    DIM(99)
     D GUS2            S              4    DIM(99)
     D GUWC            S             20    DIM(99)                              CMX006
 
     D FAAK            S             20    DIM(99)
     D FATG            S              1    DIM(99)
     D FACC            S              2    DIM(99)
     D FAS1            S              4    DIM(99)
     D FAS2            S              4    DIM(99)
     D FAWC            S             20    DIM(99)                              CMX006
 
 
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
      * Current Loan Type/Sub Type
     D                 DS
     D Curr_LTST               1      4
     D Curr_LNTY               1      2
     D Curr_LNST               3      4
 
 
      * Previous Branch
     D                 DS
     D Prev_BRCA               1      3
      * Previous Loan Type/Sub Type
     D                 DS
     D Prev_LTST               1      4
     D Prev_LNTY               1      2
     D Prev_LNST               3      4
 
 
     D                 DS                                                                     CDL038
     D EXAKEY                  1     14                                                       CDL038
     D AKEY                    1     10                                                       CDL038
                                                                                              CDL038
                                                                                              CDL038
     IACKEYAKF                                                                                CDL038
     I              AKEY                        EXAKEY                                        CDL038
     IACKEYALF                                                                                CDL038
     I              AKEY                        EXAKEY                                        CDL038
                                                                                              CDL038
                                                                                              CDL038
     ILKEY1DPF      01
     I              AKEY                        EXAKEY                                        CLE042
     ILKEYFEDF      02
     I              LKRECI                      RECI
     I**************LKAKEY                      AKEY                                          CLE042
     I              LKAKEY                      EXAKEY                                        CLE042
     I              LKLNNO                      LNNO
     I              LKCNUM                      CNUM
     I              LKBRCD                      BRCA
     I              LKACSQ                      ACSQ
     I              LKEDAT                      EDAT
     I              LKEAMT                      EAMT
     I              LKECCY                      ECCY
     I              LKSETP                      SETP
     I              LKOSAC                      OSAC
     I              LKREVI                      REVI
     I              LKOTHA                      OTHA
     I              LKOTHC                      OTHC
     I              LKEXRT                      EXRT
     I              LKSTDT                      STDT
     I              LKSLID                      SLID
     I              LKMDAT                      MDAT
     I              LKBRTT                      FEFSEQ
     I              LKBRTE                      BRTE
     I              LKRTSP                      RTSP
     I              LKINTR                      INTR
     I              LKSSEQ                      SSEQ
     I              LKCPAM                      CPAM
     I              LKPACD                      PACD
     I              LKPRFC                      PRFC
     I              LKOSBR                      OSBR
     I              LKBOKC                      BOKC
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
 
     C   01              Z-ADD     *ZERO         FEFSEQ
 
      * Process a loan-based account key
 
     C     *IN01         IFEQ      '1'
     C     *IN02         OREQ      '1'
     C     RECI          ANDEQ     'L'
     C                   EXSR      LOAN_AKEY
     C                   ELSE
 
      * Process a facility-based account key
 
     C     *IN02         IFEQ      '1'
     C     RECI          ANDEQ     'F'
     C                   EXSR      FCLT_AKEY
     C                   ENDIF
     C                   ENDIF
 
     CLR                 EXSR      TOTALS
 
      /SPACE 5
      ********************************************************************
      * Process a loan-based account key
      ********************************************************************
     C     LOAN_AKEY     BEGSR
 
      * Add 1 to count of records read
 
     C                   add       1             Lrec_cnt
 
      * Set up account key
 
     C                   MOVEL     *BLANK        DEACKY
     C                   MOVEL     AKEY          DEACKY
 
      * On change of account key
      * Get the user-defined account key
 
     C     AKEY          IFNE      Prev_AKEY
     C                   EXSR      GET_AKEY
     C                   MOVEL     AKEY          Prev_AKEY        10
     C                   ENDIF
 
      * Ignore this account key if it is not defined
 
     C     AKEY_Defin    IFNE      'Y'
     C                   GOTO      NO_EXPL
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
 
      * On change of loan type/sub type
      * Determine if loan type/sub type is to be included in the export
 
     C                   MOVEL     LNTY          Curr_LNTY
     C                   MOVEL     LNST          Curr_LNST
     C     Curr_LTST     IFNE      Prev_LTST
     C                   MOVE      'D'           I#LD
     C                   MOVEL     LNTY          I#LTYP
     C                   MOVEL     LNST          I#SUTP
     C                   EXSR      LTST_FLT
     C                   MOVEL     Curr_LTST     Prev_LTST
     C                   ENDIF
 
      * If branch is NOT for export
      * or if loan type/sub type is NOT for export
      * Ignore this account key
 
     C     Exp_BRCA      IFNE      'Y'
     C     Exp_LTST      ORNE      'Y'
     C                   GOTO      NO_EXPL
     C                   ENDIF
 
      * Extract loans and parts purchased daily events
 
     C     Proc_Type     LOOKUP    LNPT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_CLLN     ANDNE     *BLANK
     C                   MOVEL     'CLLN'        DGDTAG
     C                   EXSR      EXT_CLLN
     C                   ELSE
 
      * Extract parts sold daily events
 
     C     Proc_Type     LOOKUP    PSPT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_CLPS     ANDNE     *BLANK
     C                   MOVEL     'CLPS'        DGDTAG
     C                   EXSR      EXT_CLPS
     C                   ELSE
 
      * Extract guarantees daily events
 
     C     Proc_Type     LOOKUP    GUPT                                   99    *
     C     *IN99         IFEQ      '1'
     C     DGAK_CLGU     ANDNE     *BLANK
     C                   MOVEL     'CLGU'        DGDTAG
     C                   EXSR      EXT_CLGU
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     NO_EXPL       ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * Process a facility-based account key
      ********************************************************************
     C     FCLT_AKEY     BEGSR
 
      * Add 1 to count of records read
 
     C                   add       1             Frec_cnt
 
      * Set up account key
 
     C                   MOVEL     *BLANK        DEACKY
     C                   MOVEL     AKEY          DEACKY
 
      * On change of account key
      * Get the user-defined account key
 
     C     AKEY          IFNE      Prev_AKEY
     C                   EXSR      GET_AKEY
     C                   MOVEL     AKEY          Prev_AKEY        10
     C                   ENDIF
 
      * Ignore this account key if it is not defined
 
     C     AKEY_Defin    IFNE      'Y'
     C                   GOTO      NO_EXPF
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
 
      * If branch is NOT for export
      * Ignore this account key
 
     C     Exp_BRCA      IFNE      'Y'
     C                   GOTO      NO_EXPF
     C                   ENDIF
 
      * Extract facility daily events
 
     C     DGAK_FCLT     IFNE      *BLANK
     C                   MOVEL     'FCLT'        DGDTAG
     C                   EXSR      EXT_FCLT
     C                   ENDIF
 
     C     NO_EXPF       ENDSR
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
     C     DEACKY03      OREQ      'V'
     C                   MOVEL     'Y'           AKEY_Defin        1
     C                   Z-ADD     ACD1          EADAC1
     C                   Z-ADD     ACD2          EADAC2
     C                   Z-ADD     ACD3          EADAC3
     C                   Z-ADD     ACD4          EACAC1
     C                   Z-ADD     ACD5          EACAC2
     C                   Z-ADD     ACD6          EACAC3
     C                   ELSE
     C                   MOVEL     'N'           AKEY_Defin
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'N'           AKEY_Defin
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Extract loans and parts purchased daily events
      ********************************************************************
     C     EXT_CLLN      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_CLLN     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    LNAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     LNAK          AK                             CMX006
     C                   MOVEA     LNWC          WC                             CMX006
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
     C     LNTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     LNCC(@X)      DECATC
     C                   MOVEL     LNS1(@X)      DESNM1
     C                   MOVEL     LNS2(@X)      DESNM2
     C                   add       1             LNevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DECLLNP0
 
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
      * Extract parts sold daily events
      ********************************************************************
     C     EXT_CLPS      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_CLPS     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    PSAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     PSAK          AK                             CMX006
     C                   MOVEA     PSWC          WC                             CMX006
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
     C     PSTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     PSCC(@X)      DECATC
     C                   MOVEL     PSS1(@X)      DESNM1
     C                   MOVEL     PSS2(@X)      DESNM2
     C                   add       1             PSevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DECLPSP0
 
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
      * Extract guarantees daily events
      ********************************************************************
     C     EXT_CLGU      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_CLGU     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    GUAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     GUAK          AK                             CMX006
     C                   MOVEA     GUWC          WC                             CMX006
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
     C     GUTG(@X)      IFEQ      'Y'
 
     C                   MOVEL     GUCC(@X)      DECATC
     C                   MOVEL     GUS1(@X)      DESNM1
     C                   MOVEL     GUS2(@X)      DESNM2
     C                   add       1             GUevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DECLGUP0
 
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
      * Extract facility daily events
      ********************************************************************
     C     EXT_FCLT      BEGSR
 
      * Set account key template
 
     C                   MOVEL     DGAK_FCLT     DGAK
     C                   EXSR      SET_ACKY_T
 
      * See if account key defined for extraction
 
     C                   Z-ADD     1             @X
     C     DEACKY        LOOKUP    FAAK(@X)                               99    *
                                                                                CMX006
      * Not defined - look for wildcards                                        CMX006
     C     *IN99         IFEQ      '0'                                          CMX006
     C                   MOVEA     FAAK          AK                             CMX006
     C                   MOVEA     FAWC          WC                             CMX006
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
     C     FATG(@X)      IFEQ      'Y'
 
     C                   MOVEL     FACC(@X)      DECATC
     C                   MOVEL     FAS1(@X)      DESNM1
     C                   MOVEL     FAS2(@X)      DESNM2
 
      * Facility type, facility number
 
     C                   MOVE      LNNO          FACT_FCNO         5
     C                   MOVEL     FACT_FCNO     FACT
     C                   MOVE      FACT_FCNO     FCNO
 
     C                   add       1             FAevt_cnt
     C                   EXSR      CAL_BSCYEQ
     C                   ADD       1             EAEVID
      *                                                                         240728
     C     DEACKY10      IFEQ      'F'                                          240728
     C     DESNM2        ANDEQ     'FNN'                                        240728
     C                   EXSR      FEE_UPD                                      240728
     C                   ENDIF                                                  240728
      *                                                                         240728
     C                   WRITE     DEFCLTP0
 
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
 
     C                   Z-ADD     16            CHLINE            3 0
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
 
 
      * Load CLLN event categories for selection (and template)
 
     C                   MOVEL     'CLLN'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            LNAK
     C                   MOVEA     TG            LNTG
     C                   MOVEA     CC            LNCC
     C                   MOVEA     S1            LNS1
     C                   MOVEA     S2            LNS2
     C                   MOVEA     WC            LNWC                           CMX006
     C                   MOVEL     DGAK          DGAK_CLLN        20
 
 
      * Load CLPS event categories for selection (and template)
 
     C                   MOVEL     'CLPS'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            PSAK
     C                   MOVEA     TG            PSTG
     C                   MOVEA     CC            PSCC
     C                   MOVEA     S1            PSS1
     C                   MOVEA     S2            PSS2
     C                   MOVEA     WC            PSWC                           CMX006
     C                   MOVEL     DGAK          DGAK_CLPS        20
 
      * Load CLGU event categories for selection (and template)
 
     C                   MOVEL     'CLGU'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            GUAK
     C                   MOVEA     TG            GUTG
     C                   MOVEA     CC            GUCC
     C                   MOVEA     S1            GUS1
     C                   MOVEA     S2            GUS2
     C                   MOVEA     WC            GUWC                           CMX006
     C                   MOVEL     DGAK          DGAK_CLGU        20
 
 
      * Load FCLT event categories for selection (and template)
 
     C                   MOVEL     'FCLT'        DGDTAG
     C                   EXSR      LOAD_DGEC
     C                   MOVEA     AK            FAAK
     C                   MOVEA     TG            FATG
     C                   MOVEA     CC            FACC
     C                   MOVEA     S1            FAS1
     C                   MOVEA     S2            FAS2
     C                   MOVEA     WC            FAWC                           CMX006
     C                   MOVEL     DGAK          DGAK_FCLT        20
 
      * Load branches for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      BRCA_FLT
 
      * Load loan type/sub types for export
 
     C                   MOVE      'L'           I#LD
     C                   EXSR      LTST_FLT
 
      * Open the printer file
 
     C                   OPEN      MXDEEXLAU
 
      * Output audit report page headings
 
     C                   Z-ADD     *ZERO         CHLINE
     C                   Z-ADD     99            LINENO
     C                   EXSR      PAG
 
      * Zeroize count of records read
      * Zeroize counts of events
 
     C                   Z-ADD     *ZERO         Lrec_cnt          6 0
     C                   Z-ADD     *ZERO         Frec_cnt          6 0
     C                   Z-ADD     *ZERO         LNevt_cnt         6 0
     C                   Z-ADD     *ZERO         PSevt_cnt         6 0
     C                   Z-ADD     *ZERO         GUevt_cnt         6 0
     C                   Z-ADD     *ZERO         FAevt_cnt         6 0
 
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
      * L O A N  T Y P E  / S U B   T Y P E   F I L T E R
      /COPY MXCPYSRC,MXFLTLTST
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY MXCPYSRC,MXPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** LNPT - Loan and Parts Purchased Processing Types
61
62
63
64
65
68
 
 
 
 
** PSPT - Parts Sold Processing Types
66
67
69
 
 
 
 
 
 
 
** GUPT - Guarantees Processing Types
70
71
72
 
 
 
 
 
 
 
