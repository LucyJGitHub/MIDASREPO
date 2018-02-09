     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Take on Utility')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD008199 - Midas SD Stamp Tax Take on Utility                *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 15Feb17               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE148             Date 23Jul12               *
      *                 AR853257           Date 04Nov11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR853257 - Account Keys for FT were not generated            *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas DL Money market & loans deals details
     FDEALSDC   IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas LE Customer loans
     FCLOANCL   IF   E           K DISK    INFSR(*PSSR)
 
      * Stamp Tax Historic Details file
     FGLHPMPL0  O    E           K DISK    INFSR(*PSSR) COMMIT
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D @RUN            S              1A
     D WSTYear         S              5P 0
 
      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation Error Array Declarations
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D STAMPDS         DS
     D  TAKEON                 1      5  0
     D  DATRAT                 6     10  0
 
      ** Short Access Object Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SrDealTkOn
     C                   EXSR      SrLoanTkOn
     C                   EXSR      SrEndTkOn
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDealTkOn - Deals Take-on Processing                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrDealTkOn    BEGSR
 
     C                   DOU       %EOF(DEALSDC)
     C                   READ      DEALSDC
 
     C                   IF        NOT(%EOF(DEALSDC))
     C                   CLEAR                   @HPMPV0
 
     C                   IF        ORED <> BJRDNB
     C                   IF        (DTYP='CL' OR DTYP='CD' OR DTYP='IT' OR
     C                              DTYP='IP' OR DTYP='TD' OR DTYP='TI') AND
     C                             (RECI = 'D') AND (ORED <> BJRDNB)
 
     C                   EVAL      T3OPAM = PCPL
     C                   EVAL      T3ECCY = CCY
     C                   EVAL      T3VALD = BJRDNB
     C                   EVAL      T3DLNO = DLNO
     C                   EVAL      T3LCD  = BJRDNB
     C                   EVAL      T3TYLC = 'I'
 
     C                   IF        RECI = 'M'
     C                   EVAL      T3MATD = 'Y'
     C                   ENDIF
 
     C                   WRITE     @HPMPV0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoanTkOn - Loans Take-on Processing                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrLoanTkOn    BEGSR
 
     C                   DOU       %EOF(CLOANCL)
     C                   READ      CLOANCL
 
     C                   IF        NOT(%EOF(CLOANCL))
     C                   CLEAR                   @HPMPV0
 
     C                   IF        (ORED <> BJRDNB)
     C                   IF        (PTYP <> 61 OR PTYP = 62  OR PTYP = 63)
     C                             AND (RECI = 'D')
 
     C                   EVAL      T3OPAM = CPAM
     C                   EVAL      T3ECCY = CCY
     C                   EVAL      T3VALD = BJRDNB
     C**********         EVAL      T3DLNO = LNRF                                            AR853257
     C                   EVAL      T3LNRF = LNRF                                            AR853257
     C                   EVAL      T3LCD  = BJRDNB
     C                   EVAL      T3TYLC = 'I'
 
     C                   IF        RECI = 'M'
     C                   EVAL      T3MATD = 'Y'
     C                   ENDIF
 
     C                   WRITE     @HPMPV0
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndTkOn - Take-on Processing (End)                          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrEndTkOn     BEGSR
 
     C                   CLEAR                   @HPMPV0
     C                   EVAL      T3LCD  = BJRDNB
     C                   EVAL      T3TYLC = 'I'
     C                   EVAL      T3VALD = BJRDNB
     C                   WRITE     @HPMPV0
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG    '    @Rtcd
     C                   PARM      '*FIRST  '    @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKey
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   MOVEL     '001'         DBase
     C                   EXSR      *PSSR
     C                   END
 
     C                   EVAL      WSTYear = BJPEYD + 1
 
     C     *DTAARA       DEFINE    SDSTAMPDA     STAMPDS
 
     C     *LOCK         IN        STAMPDS
     C                   EVAL      TAKEON = BJRDNB
     C                   EVAL      DATRAT = WSTYear
     C                   OUT       STAMPDS
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
**  CPY@
(c) Finastra International Limited 2010
