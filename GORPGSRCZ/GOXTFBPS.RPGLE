     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract of F&O Book Positions')               *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXTFBPS - Extract of F&O Book Positions                     *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD032884           Date 09Jun15               *
      *                 CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG3860            Date 11Aug04               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD032884 - Performance enhancement for GOCXCLTS. Recompiled  *
      *             due to change in GOPOSNPD.                        *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG3860 - (recompile)                                        *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FGPPOSNPD  O    E           K DISK    INFSR(*PSSR) USROPN  COMMIT
     F                                     RENAME(GOPOSND0:GPPOSND0)
 
     FGOPOSNPD  O    E           K DISK    INFSR(*PSSR) USROPN
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D FBPS          E DS                  EXTNAME(POSTNKD)
     D MARKTX        E DS                  EXTNAME(MARKTD)  PREFIX(MK_)
     D INTYPX        E DS                  EXTNAME(INTYPD)  PREFIX(IN_)
 
 
      ** T R A N S A C T I O N    D E T A I L S
     D T_TRAP        E DS                  EXTNAME(GPTRAPPD)
      ** P O S I T I O N    D E T A I L S
     D P_POSN        E DS                  EXTNAME(GPPOSNPD)
 
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      * ENTRY PARAMETERS
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    I#LOC             4
     C                   PARM                    I#CCID           10 0
 
     C                   PARM                    I#RDNB            5 0
     C                   PARM                    I#DNWD            5 0
     C                   PARM                    I#PCOD            5 0
 
     C                   PARM                    FBPS
     C                   PARM                    MARKTX
     C                   PARM                    INTYPX
 
      * SETUP TRANSACTION INDEX RECORD
 
     C                   EXSR      SETUP_TRAP
 
      * WRITE TRADE DATE POSITION
 
     C                   MOVEL     'T'           Trade_Value       1
     C                   EXSR      WRITE_BAL
 
      * WRITE VALUE DATE POSITION
 
     C                   MOVEL     'V'           Trade_Value
     C                   EXSR      WRITE_BAL
 
      * WRITE TRANSACTION INDEX RECORD
      * Commitment Cycle ID
     C                   Z-ADD     I#CCID        T_CCID
     C                   EXSR      WRITE_TRAP
 
      * RETURN
 
     C                   RETURN
      *
      *****************************************************************
      * SETUP TRANSACTION INDEX RECORD
      *****************************************************************
     C     SETUP_TRAP    BEGSR
      *
     C                   CALLB     'GOSETFBPS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    BRCA
     C                   PARM                    BOKC
     C                   PARM                    ISTT
     C                   PARM                    YRNO
     C                   PARM                    MTHN
     C                   PARM                    PCAL
     C                   PARM                    STRP
     C                   PARM                    MARKTX
     C                   PARM                    INTYPX
      * OUTPUTS
     C                   PARM                    T_TRAP
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      I#ERMS = 'ERROR IN CALL TO GOSETFBPS'
     C                   EXSR      *PSSR
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * WRITE TRANSACTION INDEX RECORD
      *****************************************************************
     C     WRITE_TRAP    BEGSR
 
     C                   MOVEL     'Y'           I#CUSTDEFLT
 
      /COPY GOCPYSRC,GOWRTTRAP
 
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * WRITE BALANCE
      *****************************************************************
     C     WRITE_BAL     BEGSR
      *
      * Clear Position
      *
     C                   CLEAR                   P_POSN
      * Identifier
     C                   MOVEL     T_ID          P_ID
      * Trade/Value Date
     C                   MOVEL     Trade_Value   P_TVDI
      * Position Type
     C                   MOVEL     'C'           P_PSTP
      * Position Date
     C                   Z-ADD     I#RDNB        P_PDAT
      * Asset/Liability
     C                   MOVEL     'A'           P_ASLI
      *
      * Nominal/Principal
     C     LOPC          SUB       SOPC          NoofContracts     5 0
     C     NoofContracts MULT      IN_CTAM       P_NOML
     C     P_NOML        IFLT      0
     C                   MOVEL     'L'           P_ASLI
     C                   Z-SUB     P_NOML        P_NOML
     C                   ENDIF
      *
      * Currency
     C     IN_ISPT       IFEQ      2
     C     IN_ISPT       OREQ      5
     C                   MOVEL     IN_OTHC       P_CCY
     C                   ELSE
     C                   MOVEL     IN_ISCY       P_CCY
     C                   ENDIF
     C                   MOVEL     P_CCY         @CYCD
     C                   EXSR      ACSCCY
      *
      * Nominal Dec Places
     C                   MOVEL     A6NBDP        P_NMDP
      *
      * Write a position record
      *
     C     I#LOC         IFEQ      'GLOB'
     C                   WRITE     GPPOSND0
     C                   ELSE
     C                   WRITE     GOPOSND0
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR
      ********************************************************************
     C     *INZSR        BEGSR
 
      * Open files
     C     I#LOC         IFEQ      'GLOB'
     C                   OPEN      GPPOSNPD
     C                   ELSE
     C                   OPEN      GOPOSNPD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *********************************************************************
**  CPY@
(c) Finastra International Limited 2003
