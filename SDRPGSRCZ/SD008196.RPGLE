     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas - Stamp Tax: Loans Take On')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD008196 - Portugese Stamp Tax: Loans Take On                *
      *                                                               *
      *  (C) Copyright Finastra International Limited 2010            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR940910           Date 26Feb12               *
      *                 AR909846           Date 09Feb12               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR940910 - Demand Loan did not calculate and post Stamp Tax  *
      *             on Average Balance during month end COB           *
      *  AR909846 - LEC06A 10015 failed,CLONCLL1 Key 000012 DBerr 029 *
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
 
      ** Midas LE Customer loans
     FCLOANCL   IF   E           K DISK
 
      ** Midas GL Account details - retail key
     FACCNTL1   IF   E           K DISK
 
      ** Midas LE Stamp Tax Loans Extension File
     FCLONCLL1  UF A E           K DISK
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D WriteFlag       S              1N
     D @RUN            S              1A
     D RONSK           S             10S 0
     D L#LNRF          S                   Like(LQLNRF)
     D L#TAX           S                   Like(LQTAX)
     D L#LTYP          S                   Like(LQLTYP)
     D L#LSTP          S                   Like(LQLSTP)
     D L#CDTE          S                   Like(LQCDTE)
     D L#DCST          S                   Like(LQDCST)
     D L#DCCY          S                   Like(LQDCCY)
     D L#DACD          S                   Like(LQDACD)
     D L#DASC          S                   Like(LQDASC)
     D L#DBRC          S                   Like(LQDBRC)
     D L#AVBL          S                   Like(LQAVBL)
     D L#PRIN          S                   Like(LQPRIN)
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   DOU       %EOF(CLOANCL)
     C                   READ      CLOANCL
 
     C                   IF        NOT(%EOF(CLOANCL))
     C                   IF        (PTYP = 61 OR PTYP = 62 OR PTYP = 63 OR
     C                              PTYP = 70)
     C                   EVAL      L#LNRF = LNRF
     C                   EVAL      L#TAX  = 'N'
     C                   EVAL      L#LTYP = LTYP
     C                   EVAL      L#LSTP = SUTP
     C                   EVAL      L#LNRF = LNRF
     C                   EVAL      L#CDTE = DDAT
 
     C                   IF        RSTM = 14
     C                   MOVEL     RONS          RONSK
 
     C     KACCTL1       CHAIN     ACCNTL1
 
     C                   IF        %FOUND(ACCNTL1) AND
     C                             RECI = 'D'
 
     C                   EVAL      L#TAX  = 'Y'
     C                   EVAL      L#DBRC = BRCA
     C                   EVAL      L#DCST = CNUM
     C                   EVAL      L#DCCY = CCY
     C                   EVAL      L#DACD = ACOD
     C                   EVAL      L#DASC = ACSQ
     C                   IF        DACO > LQCDTE
     C                   EVAL      LQCDTE = DACO
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        PTYP = 61
     C                   EVAL      LQAVBL   = 'Y'
     C                   ELSE
     C                   EVAL      LQPRIN   = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C     KCLONQD       CHAIN     CLONCLL1
 
     C                   IF        %FOUND(CLONCLL1)
                                                                                            AR940910
     C                   IF        LQTAX = *BLANK                                           AR940910
     C                   EVAL      LQTAX    = L#TAX
     C                   EVAL      LQDBRC   = L#DBRC
     C                   EVAL      LQDCST   = L#DCST
     C                   EVAL      LQDCCY   = L#DCCY
     C                   EVAL      LQDACD   = L#DACD
     C                   EVAL      LQDASC   = L#DASC
     C                   EVAL      LQLTYP   = L#LTYP
     C                   EVAL      LQLSTP   = L#LSTP
     C                   EVAL      LQCDTE   = L#CDTE
     C                   EVAL      LQAVBL   = L#AVBL
     C                   EVAL      LQPRIN   = L#PRIN
     C                   EVAL      LQLNRF   = L#LNRF
     C                   UPDATE    CLONLQD0
     C                   ENDIF                                                              AR940910
                                                                                            AR940910
     C                   ELSE
     C                   CLEAR                   CLONLQD0
     C                   EVAL      LQLNRF   = L#LNRF
     C                   EVAL      LQTAX    = L#TAX
     C                   EVAL      LQDBRC   = L#DBRC
     C                   EVAL      LQDCST   = L#DCST
     C                   EVAL      LQDCCY   = L#DCCY
     C                   EVAL      LQDACD   = L#DACD
     C                   EVAL      LQDASC   = L#DASC
     C                   EVAL      LQLTYP   = L#LTYP
     C                   EVAL      LQLSTP   = L#LSTP
     C                   EVAL      LQCDTE   = L#CDTE
     C                   EVAL      LQAVBL   = L#AVBL
     C                   EVAL      LQPRIN   = L#PRIN
     C                   WRITE     CLONLQD0                                                 AR909846
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
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
 
     C     KCLONQD       KLIST
     C                   KFLD                    LNRF
 
     C     KACCTL1       KLIST
     C                   KFLD                    RONSK
      *
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
**  CPY@
(C) Copyright Finastra International Limited 2010
