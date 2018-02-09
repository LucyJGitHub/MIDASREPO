     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for securities trades')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCSTRD - Extract Controller for Securities Trades          *
      *                                                               *
      *  Function:  This module processes all SE (non-internal) trades*
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246780             Date 29Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BG3512 *CREATE     Date 29Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246780 - Do not extract cancelled trades                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BG3512 - Extract of SE Trades was missing                    *
      *                                                               *
      *****************************************************************
 
     FTRADS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(TR_)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)
 
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D TRADSX        E DS                  EXTNAME(TRADSD) PREFIX(TR_)
     D SECTYX        E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTPX        E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
     DSDSECS         E DS                  EXTNAME(SDSECSPD)
      ** SECURITY CLIENT DETAILS
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CDE005
     DDSSDY          E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL SECURITIES TRADES
      * OR EXTRACT A SINGLE SECURITY TRADE
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
      * EXTRACT ALL SECURITIES TRADES
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      TRADSDF                                99    *
      *
      * Whilst trades can be found
      *
     C     *IN99         DOWEQ     '0'
 
      * Access security details
     C                   EXSR      ACS_SECURITY
      *
      **Extract*any*unsettled*or*newly*deleted*trades                                         246780
      * Extract any unsettled live (non-cancelled) trades                                     246780
      ** RECI= D & L => inserted & inserted not authorized
      ** RECI= A & P => changed  & changed not authorized
      ***RECI=*C*&*R*=>*deleted**&*deleted*not*authorized                                     246780
      *
     C     TR_RECI       IFEQ      'D'
     C     TR_RECI       OREQ      'L'
     C     TR_RECI       OREQ      'A'
     C     TR_RECI       OREQ      'P'
     C*****TR_RECI*******OREQ      'C'                                                        246780
     C*****TR_RECI*******OREQ      'R'                                                        246780
      * Extract trade date position
      * Extract value date position
 
     C     Extract_POSN  IFEQ      'Y'
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF
     C                   END
      *
      * Read the next record
      *
     C                   READ      TRADSDF                                99    *
     C                   END
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE SECURITIES TRADE
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C                   MOVEL     I#TREF        W#TDRF            6
     C     W#TDRF        CHAIN     TRADSDF                            99        *
      *
      * If the trade is found
      * extract it
      * if it is unsettled and not cancelled                                                  246780
      *
     C     *IN99         IFEQ      '0'
      *                                                                                       246780
     C     TR_RECI       IFEQ      'D'                                                        246780
     C     TR_RECI       OREQ      'L'                                                        246780
     C     TR_RECI       OREQ      'A'                                                        246780
     C     TR_RECI       OREQ      'P'                                                        246780
 
      * Access security details
      * Extract trade date position
      * Extract value date position
 
     C                   EXSR      ACS_SECURITY
     C     Extract_POSN  IFEQ      'Y'
     C                   MOVEL     'V'           Trade_Value
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF
      *                                                                                       246780
     C                   ENDIF                                                                246780
      *                                                                                       246780
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
     C                   CALLB     'GOXTSTRD'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    TRADSX
     C                   PARM                    SECTYX
     C                   PARM                    INVTPX
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'STRD' + I#EXTT + I#BRCA
     C                              + I#TREF + W#RTCD + W#ERMS + TRADSX
     C
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
      *
     C     EEXTRCT       ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Access security details
      ********************************************************************
     C     ACS_SECURITY  BEGSR
 
      * Extract position
 
     C                   MOVEL     'Y'           Extract_POSN      1
 
      * Get security details
 
     C     TR_TDSS       CHAIN     SECTYDF                            99        *
 
      * Do not extract position if security not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     SE_RECI       OREQ      '*'
     C                   MOVEL     'N'           Extract_POSN
     C                   ELSE
 
      * Get investment type details
 
     C     INVTPK        CHAIN     INVTPDF                            99        *
 
      * Do not extract position if investment type not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     IN_RECI       OREQ      '*'
     C                   MOVEL     'N'           Extract_POSN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Get Extract control information
 
      /COPY GOCPYSRC,GOGETEXCT
 
     C     INVTPK        KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2004
