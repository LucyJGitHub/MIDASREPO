     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Contoller for SE Book Positions')     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCSBPS - Extract Controller for Securities                 *
      *             Trading Book Positions                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD036598           Date 07Jan16               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 242841             Date 28Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 28Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE071             Date 19Jul05               *
      *                 CGP001   *CREATE   Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD036598 - Component GOC0020 failed                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  242841 - Execute subroutine *PSSR if an error occurs         *
      *           after the call to GOXTSBPS.                         *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(BH_)
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(BP_)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)
     FTRDMTHT   IF   E           K DISK    RENAME(TRADSDF:TRADSDF_T)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_T)
     FTRDMTH    IF   E           K DISK    RENAME(TRADSDF:TRADSDF_V)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_V)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D BKPHDX        E DS                  EXTNAME(BKPHDD) PREFIX(BH_)
     D BKPOSX        E DS                  EXTNAME(BKPOSD) PREFIX(BP_)
     D SECTYX        E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTPX        E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
 
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL SECURITIES BOOK POSITIONS
      * OR EXTRACT A SINGLE SECURITY BOOK POSITION
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
      * EXTRACT ALL SECURITIES BOOK POSITIONS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      BKPHDDF                                99    *
      *
      * Whilst positions can be found
      *
     C     *IN99         DOWEQ     '0'
 
      * If the position is a trade date position
 
     C     BH_BHTV       IFEQ      'T'
 
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
     C                   ENDIF
      *
      * Read the next record
      *
     C                   READ      BKPHDDF                                99    *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE SECURITY BOOK POSITION
      ********************************************************************
     C     EXTSIN        BEGSR
 
      * Access trade date position
 
     C                   MOVEL     'T'           Trade_Value
     C     BKPHDK        CHAIN     BKPHDDF                            99        *
 
      * If the position is found
 
     C     *IN99         IFEQ      '0'
 
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
      *  Obtain the position prior to the back-value date
      *
     C                   CLEAR                   BKPOSX
     C                   Z-ADD     BVDate        BP_BPPD
 
     C     BKPOSK        SETGT     BKPOS
     C     BKPOSP        READPE    BKPOS                                  99
      *
      *  If a position is present
      *  Set the latest position date to its position date
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     BP_BPPD       BH_LPSD
     C                   ENDIF
      *
      *  If no position is present prior to the back-value date the position
      *  date is the day prior to the value date of the first trade present
      *  (If no trades, set the position date to today)
      *
     C     *IN99         IFEQ      '1'
 
     C     Trade_Value   IFEQ      'T'
     C     TRADK         SETLL     TRDMTHT
     C                   ELSE
     C     TRADK         SETLL     TRDMTH
     C                   ENDIF
 
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     Trade_Value   IFEQ      'T'
     C     TRADK         READE     TRDMTHT                                99    *
     C                   ELSE
     C     TRADK         READE     TRDMTH                                 99
     C                   ENDIF
     C                   ENDDO
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     I#RDNB        BH_LPSD
     C                   ELSE
     C     Trade_Value   IFEQ      'T'
     C     TDDT          SUB       1             BH_LPSD
     C                   ELSE
     C     TDVD          SUB       1             BH_LPSD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   CALLB     'GOXTSBPS'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    BKPHDX
     C                   PARM                    BKPOSX
     C                   PARM                    SECTYX
     C                   PARM                    INVTPX
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'SBPS' + I#EXTT + I#BRCA
     C                                    + I#BOOK + I#SESN + I#MKTI
     C                                    + W#RTCD + W#ERMS + BKPHDX
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   EXSR      *PSSR                                                      242841
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Access security details
      ********************************************************************
     C     ACS_SECURITY  BEGSR
 
      * Extract position
 
     C                   MOVEL     'Y'           Extract_POSN      1
 
      * Get security details
 
     C     BH_BHSC       CHAIN     SECTYDF                            99        *
 
      * Do not extract position if security not found or if deleted
 
     C     *IN99         IFEQ      '1'
     C     SE_RECI       OREQ      '*'
     C     SE_RECI       OREQ      'C'                                                      MD036598
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
 
      *  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      *  Access Securities Trading details
 
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
     C     I#RDNB        SUB       BVBVP         BVDate            5 0
 
      * Key lists
 
     C     BKPHDK        KLIST
     C                   KFLD                    I#SESN
     C                   KFLD                    I#BRCA
     C                   KFLD                    I#BOOK
     C                   KFLD                    I#MKTI
     C                   KFLD                    Trade_Value       1
 
     C     INVTPK        KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
 
     C     BKPOSK        KLIST
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHMK
     C                   KFLD                    Trade_Value
     C                   KFLD                    BP_BPPD
 
     C     BKPOSP        KLIST
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHMK
     C                   KFLD                    Trade_Value
 
     C     TRADK         KLIST
     C                   KFLD                    BH_BHBA
     C                   KFLD                    BH_BHBK
     C                   KFLD                    BH_BHSC
     C                   KFLD                    BH_BHMK
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
