     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for Loans/Deposits')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCLDNI - Extract Controller for Money Market               *
      *             Loans, Deposits and Negotiable Assets Issued      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 AR644662           Date 19Aug14               *
      *                 AR582204           Date 11Apr12               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL014             Date 20Oct03               *
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
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR644662 - Exclude deals that matured during the holidays.   *
      *             (Child: AR644663)                                 *
      *  AR582204 - Exclude deleted deals. Applied fix 258723.        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Churh Tax (Recompile)             *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Do not extract matured transactions into GPTRAPPD *
      *    Fix was also applied to MP121 via 246296 bug               *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL014 - Collaterals Processing (Recompile)                  *
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
 
     FMMDEALLL  IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(MMDELDP0)
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(DEALSDCF)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D MMDELD        E DS                  EXTNAME(MMDELDPP)
     D DEALDC        E DS                  EXTNAME(DEALSDC)
 
 
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL LOANS/DEPOSITS
      * OR EXTRACT A SINGLE LOAN/DEPOSIT
      *
     C     I#EXTT        IFEQ      '*ALL'
     C                   EXSR      EXTALL
     C                   SETON                                        LR
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL LOANS/DEPOSITS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      MMDELDP0                               99    *
      *
      * Whilst deals can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      **Extract*any*live*or*matured*MM*loans/deposits*                                      BUG13562
      * Extract any live MM loans/deposits                                                  BUG13562
      *
     C     HKDDLT        IFEQ      *BLANK                                                   AR582204
     C     HKDSTS        IFEQ      'C'
     C     HKDSTS        OREQ      'A'
     C     HKDSTS        OREQ      'R'
     C*****HKDSTS        OREQ      'M'                                                      BUG13562
     C                   EXSR      ACS_OTHER_DTLS
     C     RECI          IFNE      'M'                                                      AR644662
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF                                                              AR644662
     C                   END
     C                   ENDIF                                                              AR582204
      *
      * Read the next record
      *
     C                   READ      MMDELDP0                               99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE LOAN/DEPOSIT
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#DLNO            6 0
     C     W#DLNO        CHAIN     MMDELDP0                           99        *
      *
      * If the deal is found
      * access other details
      * extract it
      * if not matured                                                                      BUG13562
      *
     C     *IN99         IFEQ      '0'
     C     HKDSTS        ANDNE     'M'                                                      BUG13562
     C     HKDDLT        ANDEQ     *BLANK                                                   AR582204
     C                   EXSR      ACS_OTHER_DTLS
     C     RECI          IFNE      'M'                                                      AR644662
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF                                                              AR644662
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT
      ********************************************************************
     C     EXTRCT        BEGSR
      *
     C                   CALLB     'GOXTLDNI'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    MMDELD
     C                   PARM                    DEALDC
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'LDNI' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + MMDELD
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Access other details
      ********************************************************************
     C     ACS_OTHER_DTLSBEGSR
      *
      * Get further deal details needed from DEALSDC
      *
     C                   CLEAR                   DEALDC
     C     HKDN38        CHAIN     DEALSDCF                           99        *
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get Extract control information
 
      /COPY GOCPYSRC,GOGETEXCT
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
