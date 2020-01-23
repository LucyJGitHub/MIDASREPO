     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(CLOANCLXX) TOFILE(CLOAN) SHARE(*NO)              *
/*XBIB*: OVRDBF FILE(FCLTYFMXX) TOFILE(FCLTY) SHARE(*NO)              *
/*XBIC*: OVRDBF FILE(LEAGFMPDXX) TOFILE(LEAGFCL0) SHARE(*NO)          *                       CLE041
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Global updates - LE')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOGLOBLE - Global Updates - LE                               *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CLE070             Date 19Jun19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CLE071             Date 18Jul18               *
      *                 CLE168             Date 26Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 CER073B            Date 25Sep17               *
      *                 CER073A            Date 05Sep17               *
      *                 CER073             Date 10Jul17               *
      *                 CLE068             Date 02Aug16               *
      *                 CLE164             Date 18Aug14               *
      *                 MD021528           Date 01Aug13               *
      *                 CGP017             Date 06Aug12               *
      *                 263108             Date 23Nov12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257576             Date 13Nov08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE041             Date 11Oct04               *
      *                 BUG3286            Date 17Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE070 - Manual Diary                                        *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CLE071 - Value Dating of Rate Changes to Fees                *
      *  CLE168 - Allow Debit of Blocked Account (Recompile)          *
      *  MD046248 - Finastra Rebranding                               *
      *  CER073B - CER073 Change Control 2 (Recompile)                *
      *  CER073A - CER073 Change Control 1 (Recompile)                *
      *  CER073 - AnaCredit Reporting                                 *
      *  CLE068 - Loan Event Modeller                                 *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD021528 - Missing facility after authorization (Recompile)  *
      *  CGP017 - Global Layer - GOC0100 Task Split (Recompile)       *
      *  263108 - GOC0100 must not post to global facility listview.  *
      *           This will prevent duplicate records from posting.   *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  257576 - Performance: Facilities Input (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *  BUG3286 - Replication of extension files should not be       *
      *            conditioned on CLE025                              *
      *  CLE025 - Credit Lines                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
     FCLOANCLXX IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(CL_)
     F                                     INCLUDE(CLOANCLF)
     FFCLTYFMXX IF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(FM_)
     F                                     INCLUDE(FCLTYFMF)
     FLEAGFMPDXXIF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(AGFM_)                  CLE041
     F                                     INCLUDE(FCLTYFMF)                                  CLE041
     F                                     RENAME(FCLTYFMF:LEAGFMPDF)                         CLE041

     D/COPY ZACPYSRC,STD_D_SPEC


     D LOANCK        E DS                  EXTNAME(CLOANCK) PREFIX(CK_)
     D FCLTFN        E DS                  EXTNAME(FCLTYFN) PREFIX(FN_)
     D AGFCLTFN      E DS                  EXTNAME(LEAGFNPD) PREFIX(AGFN_)                    CLE041


     D PARM1           DS
      * Physical file name
     D  PFLNAME                1     10
      * Member name
     D  MBRNAME               21     30
      * Trigger event
     D  TRGEVENT              31     31
      * Offset to the before image of the record
     D  BOFF                  49     52B 0
      * Length of the before image of the record
     D  BLEN                  53     56B 0
      * Offset to the after image of the record
     D  AOFF                  65     68B 0
      * Length of the after image of the record
     D  ALEN                  69     72B 0
     D  EntryData            117  10117A


     D PARM2           DS
     D  LENG                   1      4B 0

     D CLE025          S              1                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     DFILE             S                   LIKE(PFLNAME)                                      263108

      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV2           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV3           S              1    DIM(60) CTDATA PERRCD(60)                          CLE041


      * ENTRY PARAMETERS

     C     *ENTRY        PLIST
     C                   PARM                    PARM1
     C                   PARM                    PARM2

      * Recover before and after image

     C     BOFF          ADD       1             OffSet            5 0
     C     BLen          SUBST     PARM1:OffSet  I#BIMG         4000

     C     AOFF          ADD       1             OffSet
     C     ALen          SUBST     PARM1:OffSet  I#AIMG         4000


      * Global Updates - BEFORE/AFTER image
      * TRGEVENT: '1'=INSERT, '2'=DELETE, '3'=UPDATE
     C     TRGEVENT      IFEQ      '1'
     C                   MOVEL     *BLANK        I#BIMG
     C                   ENDIF
     C     TRGEVENT      IFEQ      '2'
     C                   MOVEL     *BLANK        I#AIMG
     C                   ENDIF

     C                   MOVEL     O#ZONE        I#ZONE                         * ERROR MESSAGE
     C                   MOVEL     'Y'           I#TRAP

      * Determine updates

     C                   EXSR      DET_UPDATES

     C                   MOVEL     'B'           I#BFAF
     C                   DO        2

     C     P_Before      IFEQ      'Y'
     C     I#BFAF        ANDEQ     'B'
     C     P_After       OREQ      'Y'
     C     I#BFAF        ANDEQ     'A'
     C     PFLNAME       CASEQ     'CLOANCK'     GLOB_CLOANCK
     C     PFLNAME       CASEQ     'CLOANCL'     GLOB_CLOANCL
     C     PFLNAME       CASEQ     'FCLTYFM'     GLOB_FCLTYFM
     C     PFLNAME       CASEQ     'FCLTYFN'     GLOB_FCLTYFN
     C     PFLNAME       CASEQ     'LEADINPD'    GLOB_LEADINPD                                CLE106
     C     PFLNAME       CASEQ     'LEFCAMPD'    GLOB_LEFCAMPD
     C     PFLNAME       CASEQ     'LEFEEAD'     GLOB_LEFEEAD
     C     PFLNAME       CASEQ     'LEFEED'      GLOB_LEFEED
     C     PFLNAME       CASEQ     'LEFERCPD'    GLOB_LEFERCPD                                CLE071
     C     PFLNAME       CASEQ     'LEFERCQD'    GLOB_LEFERCQD                                CLE071
     C     PFLNAME       CASEQ     'LEPARTPD'    GLOB_LEPARTPD
     C     PFLNAME       CASEQ     'LETREFPD'    GLOB_LETREFPD                                CLE106
     C     PFLNAME       CASEQ     'LOAMSDK'     GLOB_LOAMSDK
     C     PFLNAME       CASEQ     'LEFCLTQD'    GLOB_LEFCLTQD                               BUG3286
     C     PFLNAME       CASEQ     'LEAGFMPD'    GLOB_LEAGFMPD                                CLE041
     C     PFLNAME       CASEQ     'LEAGFNPD'    GLOB_LEAGFNPD                                CLE041
     C     PFLNAME       CASEQ     'LEAGFTQD'    GLOB_LEAGFTQD                                CLE041
     C     PFLNAME       CASEQ     'LEAGAMPD'    GLOB_LEAGAMPD                                CLE041
     C     PFLNAME       CASEQ     'LEFCGRPD'    GLOB_LEFCGRPD                                CLE041
     C     PFLNAME       CASEQ     'LEFCHRPD'    GLOB_LEFCHRPD                                CLE041
     C     PFLNAME       CASEQ     'LEFCLNPD'    GLOB_LEFCLNPD                                CLE041
     C     PFLNAME       CASEQ     'MTRAND'      GLOB_MTRAND                                  CLE106
     C     PFLNAME       CASEQ     'CLOAMSQD'    GLOB_CLOAMSQD                                CRE073
     C     PFLNAME       CASEQ     'LEFEEDQD'    GLOB_LEFEEDQD                                CER049
     C     PFLNAME       CASEQ     'CLONCLQD'    GLOB_CLONCLQD                                CER049
     C     PFLNAME       CASEQ     'CLOANZTD'    GLOB_CLOANZTD                                CLE164
     C     PFLNAME       CASEQ     'LEFEEZTD'    GLOB_LEFEEZTD                                CLE164
     C     PFLNAME       CASEQ     'LELEMRWPD'   GLOB_LELEMRWPD                               CLE068
     C     PFLNAME       CASEQ     'LEANACQD'    GLOB_LEANACQD                                CER073
     C     PFLNAME       CASEQ     'LEDIAMPD'    GLOB_LEDIAMPD                                CLE070
     C     PFLNAME       CASEQ     'LEDIAMQD'    GLOB_LEDIAMQD                                CLE070
     C                   ENDCS
     C*****CLE025        IFEQ      'Y'                                                CLE025 BUG3286
     C*****PFLNAME       ANDEQ     'LEFCLTQD'                                         CLE025 BUG3286
     C**********         EXSR      GLOB_LEFCLTQD                                      CLE025 BUG3286
     C**********         ENDIF                                                        CLE025 BUG3286
     C                   ENDIF

     C                   MOVEL     'A'           I#BFAF
     C                   ENDDO

     C                   RETURN

      /SPACE 5
      *****************************************************************
      * Global Updates - Loan B record
      *****************************************************************
     C     GLOB_CLOANCK  BEGSR

     C     LoanFileOpen  IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   OPEN      CLOANCLXX
     C                   MOVEL     'Y'           LoanFileOpen      1
     C                   ENDIF

      * Get branch from 'A' record

     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     I#AIMG        LOANCK
     C     CK_LNRF       CHAIN     CLOANCLF                           99        *
     C  N99              MOVEL     CL_BRCA       CK_RDCH
     C  N99              MOVEL     LOANCK        I#AIMG
     C                   ENDIF
     C     I#BIMG        IFNE      *BLANK
     C                   MOVEL     I#BIMG        LOANCK
     C     CK_LNRF       CHAIN     CLOANCLF                           99        *
     C  N99              MOVEL     CL_BRCA       CK_RDCH
     C  N99              MOVEL     LOANCK        I#BIMG
     C                   ENDIF
      /COPY GPCPYSRCG,GPCLOANCK
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Loan A record
      *****************************************************************
     C     GLOB_CLOANCL  BEGSR
      /COPY GPCPYSRCG,GPCLOANCL
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Facility A record
      *****************************************************************
     C     GLOB_FCLTYFM  BEGSR
      /COPY GPCPYSRCG,GPFCLTYFM
     C                   EVAL      FILE = PFLNAME                                             263108
     C                   EXSR      GLOB_FCLTLVPD                                              263108
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility A record                                          CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEAGFMPD BEGSR                                                                CLE041
      /COPY GPCPYSRCG,GPLEAGFMPD                                                              CLE041
     C                   EVAL      FILE = PFLNAME                                             263108
     C                   EXSR      GLOB_FCLTLVPD                                              263108
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5
      *****************************************************************
      * Global Updates - Facility B record
      *****************************************************************
     C     GLOB_FCLTYFN  BEGSR

     C     FcltFileOpen  IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      FCLTYFMXX
     C                   MOVEL     'Y'           FcltFileOpen      1
     C                   ENDIF

      * Get branch from 'A' record

     C     I#AIMG        IFNE      *BLANK
     C                   MOVEL     I#AIMG        FCLTFN
     C     FCLTYK        CHAIN     FCLTYFMF                           99        *
     C  N99              MOVEL     FM_BRCA       FN_ZZ003
     C  N99              MOVEL     FCLTFN        I#AIMG
     C                   ENDIF
     C     I#BIMG        IFNE      *BLANK
     C                   MOVEL     I#BIMG        FCLTFN
     C     FCLTYK        CHAIN     FCLTYFMF                           99        *
     C  N99              MOVEL     FM_BRCA       FN_ZZ003
     C  N99              MOVEL     FCLTFN        I#BIMG
     C                   ENDIF
      /COPY GPCPYSRCG,GPFCLTYFN
     C                   EVAL      FILE = PFLNAME                                             263108
     C                   EXSR      GLOB_FCLTLVPD                                              263108
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CLE106
      *****************************************************************                       CLE106
      * Global Updates - Adjustments to Accrued Interest                                      CLE106
      *****************************************************************                       CLE106
     C     GLOB_LEADINPD BEGSR                                                                CLE106
      /COPY GPCPYSRCG,GPLEADINPD                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility B record                                          CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEAGFNPD BEGSR                                                                CLE041
                                                                                              CLE041
     C     AgFctyFilOpn  IFNE      'Y'                                                        CLE041
     C                   CALL      'QCMDEXC'     OV3_Parm                                     CLE041
     C                   OPEN      LEAGFMPDXX                                                 CLE041
     C                   MOVEL     'Y'           AgFctyFilOpn      1                          CLE041
     C                   ENDIF                                                                CLE041
                                                                                              CLE041
      * Get branch from 'A' record                                                            CLE041
                                                                                              CLE041
     C     I#AIMG        IFNE      *BLANK                                                     CLE041
     C                   MOVEL     I#AIMG        AGFCLTFN                                     CLE041
     C     AGFCLTYK      CHAIN     LEAGFMPDF                          99                      CLE041
     C  N99              MOVEL     AGFM_BRCA     AGFN_ZZ003                                   CLE041
     C  N99              MOVEL     AGFCLTFN      I#AIMG                                       CLE041
     C                   ENDIF                                                                CLE041
     C     I#BIMG        IFNE      *BLANK                                                     CLE041
     C                   MOVEL     I#BIMG        AGFCLTFN                                     CLE041
     C     AGFCLTYK      CHAIN     LEAGFMPDF                          99                      CLE041
     C  N99              MOVEL     AGFM_BRCA     AGFN_ZZ003                                   CLE041
     C  N99              MOVEL     AGFCLTFN      I#BIMG                                       CLE041
     C                   ENDIF                                                                CLE041
      /COPY GPCPYSRCG,GPLEAGFNPD                                                              CLE041
     C                   EVAL      FILE = PFLNAME                                             263108
     C                   EXSR      GLOB_FCLTLVPD                                              263108
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5
      *****************************************************************
      * Global Updates - Facility Amendment
      *****************************************************************
     C     GLOB_LEFCAMPD BEGSR
      /COPY GPCPYSRCG,GPLEFCAMPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility Amendment                                         CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEAGAMPD BEGSR                                                                CLE041
      /COPY GPCPYSRCG,GPLEAGAMPD                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5
      *****************************************************************
      * Global Updates - Fee Settlement/Adjustment Detail
      *****************************************************************
     C     GLOB_LEFEEAD  BEGSR
      /COPY GPCPYSRCG,GPLEFEEAD
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Global Updates - Fee
      *****************************************************************
     C     GLOB_LEFEED   BEGSR
      /COPY GPCPYSRCG,GPLEFEED
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************                       CLE071
      * Global Updates - Fee Rate Change Amendment Details                                    CLE071
      *****************************************************************                       CLE071
     C     GLOB_LEFERCPD BEGSR                                                                CLE071
      /COPY GPCPYSRCG,GPLEFERCPD                                                              CLE071
     C                   ENDSR                                                                CLE071
      *****************************************************************                       CLE071
      /SPACE 5                                                                                CLE071
      *****************************************************************                       CLE071
      * Global Updates - Fee Rate Change Amendment Extension File                             CLE071
      *****************************************************************                       CLE071
     C     GLOB_LEFERCQD BEGSR                                                                CLE071
      /COPY GPCPYSRCG,GPLEFERCQD                                                              CLE071
     C                   ENDSR                                                                CLE071
      *****************************************************************                       CLE071
      /SPACE 5                                                                                CLE071
      *****************************************************************
      * Global Updates - Participant Details
      *****************************************************************
     C     GLOB_LEPARTPD BEGSR
      /COPY GPCPYSRCG,GPLEPARTPD
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CLE106
      *****************************************************************                       CLE106
      * Global Updates - Transaction Reference                                                CLE106
      *****************************************************************                       CLE106
     C     GLOB_LETREFPD BEGSR                                                                CLE106
      /COPY GPCPYSRCG,GPLETREFPD                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /SPACE 5
      *****************************************************************
      * Global Updates - Loan Amendment
      *****************************************************************
     C     GLOB_LOAMSDK  BEGSR
      /COPY GPCPYSRCG,GPLOAMSDK
     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CLE068
      *****************************************************************                       CLE068
      * Global Updates - Loan Event Modeller                                                  CLE068
      *****************************************************************                       CLE068
     C     GLOB_LELEMRWPDBEGSR                                                                CLE068
      /COPY GPCPYSRCG,GPLELEMRPD                                                              CLE068
     C                   ENDSR                                                                CLE068
      *****************************************************************                       CLE068
      /SPACE 5                                                                                CER073
      *****************************************************************                       CER073
      * Global Updates - AnaCredit Reporting                                                  CER073
      *****************************************************************                       CER073
     C     GLOB_LEANACQD BEGSR                                                                CER073
      /COPY GPCPYSRCG,GPLEANACQD                                                              CER073
     C                   ENDSR                                                                CER073
      *****************************************************************                       CER073
      /SPACE 5
      *****************************************************************
      * Determine Updates
      *****************************************************************
     C     DET_UPDATES   BEGSR

     C                   CALL      'GPDETGUPD'
     C                   PARM                    I#ZONE           10
     C                   PARM      PFLNAME       I#FILE           10
     C                   PARM                    I#BIMG
     C                   PARM                    I#AIMG
     C                   PARM      'N'           P_Before          1
     C                   PARM      'N'           P_After           1

     C                   ENDSR
      *****************************************************************
      /SPACE 5                                                                                CLE025
      *****************************************************************                       CLE025
      * Global Updates - Facility Extension file                                              CLE025
      *****************************************************************                       CLE025
     C     GLOB_LEFCLTQD BEGSR                                                                CLE025
      /COPY GPCPYSRCG,GPLEFCLTQD                                                              CLE025
     C                   EVAL      FILE = PFLNAME                                             263108
     C                   EXSR      GLOB_FCLTLVPD                                              263108
     C                   ENDSR                                                                CLE025
      *****************************************************************                       CLE025
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility Extension file                                    CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEAGFTQD BEGSR                                                                CLE041
      /COPY GPCPYSRCG,GPLEAGFTQD                                                              CLE041
     C                   EVAL      FILE = PFLNAME                                             263108
     C                   EXSR      GLOB_FCLTLVPD                                              263108
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility Groups                                            CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEFCGRPD BEGSR                                                                CLE041
      /COPY GPCPYSRCG,GPLEFCGRPD                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility Hierchy                                           CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEFCHRPD BEGSR                                                                CLE041
      /COPY GPCPYSRCG,GPLEFCHRPD                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE041
      *****************************************************************                       CLE041
      * Global Updates - Aggregate Facility Links                                             CLE041
      *****************************************************************                       CLE041
     C     GLOB_LEFCLNPD BEGSR                                                                CLE041
      /COPY GPCPYSRCG,GPLEFCLNPD                                                              CLE041
     C                   ENDSR                                                                CLE041
      *****************************************************************                       CLE041
      /SPACE 5                                                                                CLE106
      *****************************************************************                       CLE106
      * Global Updates - Accrued Margin Adj. Header                                           CLE106
      *****************************************************************                       CLE106
     C     GLOB_MTRAND   BEGSR                                                                CLE106
      /COPY GPCPYSRCG,GPMTRAND                                                                CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /SPACE 5                                                                                263108
      *****************************************************************                       263108
      * Global Updates - Global facility list view.                                           263108
      *****************************************************************                       263108
     C     GLOB_FCLTLVPD BEGSR                                                                263108
      /COPY GPCPYSRCG,GPV_FCLTY                                                               263108
     C                   ENDSR                                                                263108
      *****************************************************************                       263108
     C/SPACE 5
      *****************************************************************                       CRE073
      * Global Updates - Loan Amendments Extension File                                       CRE073
      *****************************************************************                       CRE073
     C     GLOB_CLOAMSQD BEGSR                                                                CRE073
      /COPY GPCPYSRCG,GPCLOAMSQD                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
     C/SPACE 5                                                                                CRE073
      *****************************************************************                       CER049
      * Global Updates - Loan Amendments Extension File                                       CER049
      *****************************************************************                       CER049
     C     GLOB_LEFEEDQD BEGSR                                                                CER049
      /COPY GPCPYSRCG,GPLEFEEDQD                                                              CER049
     C                   ENDSR                                                                CER049
      *****************************************************************                       CER049
     C/SPACE 5                                                                                CER049
      *****************************************************************                       CER049
      * Global Updates - Customer Loans Extension File                                        CER049
      *****************************************************************                       CER049
     C     GLOB_CLONCLQD BEGSR                                                                CER049
      /COPY GPCPYSRCG,GPCLONCLQD                                                              CER049
     C                   ENDSR                                                                CER049
      *****************************************************************                       CLE164
      * Global Updates - Loans Repayment Priority File                                        CLE164
      *****************************************************************                       CLE164
     C     GLOB_CLOANZTD BEGSR                                                                CLE164
      /COPY GPCPYSRCG,GPCLOANZTD                                                              CLE164
     C                   EVAL      FILE = PFLNAME                                             CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      * Global Updates - Fees Repayment Priority File                                         CLE164
      *****************************************************************                       CLE164
     C     GLOB_LEFEEZTD BEGSR                                                                CLE164
      /COPY GPCPYSRCG,GPLEFEEZTD                                                              CLE164
     C                   EVAL      FILE = PFLNAME                                             CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE070
      * Global Updates - Manual Diary File                                                    CLE070
      *****************************************************************                       CLE070
     C     GLOB_LEDIAMPD BEGSR                                                                CLE070
      /COPY GPCPYSRCG,GPLEDIAMPD                                                              CLE070
     C                   EVAL      FILE = PFLNAME                                             CLE070
     C                   ENDSR                                                                CLE070
      *****************************************************************                       CER049
      *****************************************************************                       CLE070
      * Global Updates - Manual Diary File                                                    CLE070
      *****************************************************************                       CLE070
     C     GLOB_LEDIAMQD BEGSR                                                                CLE070
      /COPY GPCPYSRCG,GPLEDIAMQD                                                              CLE070
     C                   EVAL      FILE = PFLNAME                                             CLE070
     C                   ENDSR                                                                CLE070
      *****************************************************************                       CER049
     C/SPACE 5                                                                                CER049
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
                                                                                              CLE025
      ** Determine if CLE025 is switched on                                                   CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVE      'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025

     C                   MOVEL     *BLANK        I#RTCD            7
     C                   MOVEL     *BLANK        I#ERMS           50

      * Get Zone

      /COPY GOCPYSRC,GOGETZONE


      * Key lists

     C     FCLTYK        KLIST
     C                   KFLD                    FN_CNUM
     C                   KFLD                    FN_FACT
     C                   KFLD                    FN_FCNO

     C     AGFCLTYK      KLIST                                                                CLE041
     C                   KFLD                    AGFN_CNUM                                    CLE041
     C                   KFLD                    AGFN_FACT                                    CLE041
     C                   KFLD                    AGFN_FCNO                                    CLE041
                                                                                              CLE041
     C                   Z-ADD     60            MESLEN           15 5

      * Parameter lists

     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
     C     OV2_Parm      PLIST
     C                   PARM                    ##OV2
     C                   PARM                    MESLEN
     C     OV3_Parm      PLIST                                                                CLE041
     C                   PARM                    ##OV3                                        CLE041
     C                   PARM                    MESLEN                                       CLE041
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OV1
OVRDBF FILE(CLOANCLXX) TOFILE(CLOAN) SHARE(*NO)
** ##OV2
OVRDBF FILE(FCLTYFMXX) TOFILE(FCLTY) SHARE(*NO)
** ##OV3                                                                                      CLE041
OVRDBF FILE(LEAGFMPDXX) TOFILE(LEAGFCL0) SHARE(*NO)                                           CLE041
