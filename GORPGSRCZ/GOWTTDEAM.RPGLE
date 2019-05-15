     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*: OVRDBF FILE(MMDELDL2XX) TOFILE(MMDELDL2) SHARE(*NO)          *
/*XBIB*: OVRDBF FILE(MMDELDL7XX) TOFILE(MMDELDL7) SHARE(*NO)          *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Write to TRAP - Deal Amendments')             *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOWTTDEAM - Write to TRAP - Deal Amendments                  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG3860 - (recompile)                                        *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic rollover of Fixed Term Loans/Deposits     *
      *           (Recompile)                                         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FMMDELDL2XXIF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(LN_)
     FMMDELDL7XXIF   E           K DISK    INFSR(*PSSR) USROPN PREFIX(NA_)
     F                                     INCLUDE(MMDENBP0)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
 
 
     D MMDEAM        E DS                  EXTNAME(MMDEAMPP)
     D MMDELD        E DS                  EXTNAME(MMDELDPP) PREFIX(LN_)
     D MMDENB        E DS                  EXTNAME(MMDENBPP) PREFIX(NA_)
 
 
      ** Overrides
     D ##OV1           S              1    DIM(60) CTDATA PERRCD(60)
     D ##OV2           S              1    DIM(60) CTDATA PERRCD(60)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
     C                   PARM                    I#BIMG         4000
     C                   PARM                    I#AIMG         4000
 
      * Override/open files
 
     C     DeldFileOpen  IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV1_Parm
     C                   OPEN      MMDELDL2XX
     C                   MOVEL     'Y'           DeldFileOpen      1
     C                   ENDIF
 
      * Universal Transaction Updates
 
     C                   EXSR      TRAP_DEAM
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Universal Transaction Updates - Deal Amendments
      ********************************************************************
     C     TRAP_DEAM     BEGSR
 
     C                   MOVEL     I#AIMG        MMDEAM
 
      * Get original loan/deposit
 
     C     HNDA38        CHAIN     MMDELDD0                           99        *
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SETUP_TRAPLDNI
     C                   EXSR      WRITE_TRAP
     C                   ELSE
 
     C     DenbFileOpen  IFNE      'Y'
     C                   CALL      'QCMDEXC'     OV2_Parm
     C                   OPEN      MMDELDL7XX
     C                   MOVEL     'Y'           DenbFileOpen      1
     C                   ENDIF
 
      * Get original NA purchased
 
     C     HNDA38        CHAIN     MMDENBP0                           99        *
 
      * SETUP TRANSACTION INDEX RECORD
      * WRITE TRANSACTION INDEX RECORD
 
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SETUP_TRAPNASP
     C                   EXSR      WRITE_TRAP
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPLDNIBEGSR
      *
     C                   CALLB     'GOSETLDNI'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    MMDELD
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    MaturityDate      5 0            Midas day no.
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETLDNI'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * SETUP TRANSACTION INDEX RECORD
      ********************************************************************
     C     SETUP_TRAPNASPBEGSR
      *
     C                   CALLB     'GOSETNASP'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    MMDENB
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C                   PARM                    DealDate          5 0            Midas day no.
     C                   PARM                    ValueDate         5 0            Midas day no.
     C                   PARM                    MaturityDate      5 0            Midas day no.
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETNASP'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
      * Commitment Cycle ID
     C                   Z-ADD     0             T_CCID
 
     C                   MOVEL     'GLOB'        I#LOC
     C                   MOVEL     'Y'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR - Initial subroutine called automatically at program start
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     60            MESLEN           15 5
 
      * Parameter lists
 
     C     OV1_Parm      PLIST
     C                   PARM                    ##OV1
     C                   PARM                    MESLEN
     C     OV2_Parm      PLIST
     C                   PARM                    ##OV2
     C                   PARM                    MESLEN
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
OVRDBF FILE(MMDELDL2XX) TOFILE(MMDELDL2) SHARE(*NO)
** ##OV2
OVRDBF FILE(MMDELDL7XX) TOFILE(MMDELDL7) SHARE(*NO)
