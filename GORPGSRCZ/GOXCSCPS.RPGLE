     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Contolller for SE Cust Positions')    *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCSCPS - Extract Controller for Securities                 *
      *             Trading Customer Positions                        *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD045155           Date 17May17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247103             Date 22May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 28Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL035             Date 01Mar05               *
      *                 CSE071             Date 19Jul05               *
      *                 222727             Date 05Nov03               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045155 - Remove the initialization of CP_CSNT and CP_CSNV  *
      *             to make sure that the nominal on CPOSND is equal  *
      *             with the nominal on GPPOSNPD.                     *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247103 - Execute subroutine *PSSR if an error occurs         *
      *           after the call to GOXTSCPS. Patterned fix 242841.   *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL035 - EUSD Upgrade to Midasplus (Recompile)               *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FCPOSN     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CP_)
     FCPOSH     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(CH_)
     F                                     RENAME(CPOSNDF:CPOSHDF)
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SE_)
     FINVTP     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(IN_)
     FTDPBT     IF   E           K DISK    RENAME(TRADSDF:TRADSDF_T)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_T)
     F                                     RENAME(DPTMVDF:DPTMVDF_T)
     F                                     RENAME(DPTMVTF:DPTMVTF_T)
     F                                     IGNORE(SEDVPRD0)
     FTDPBV     IF   E           K DISK    RENAME(TRADSDF:TRADSDF_V)INFSR(*PSSR)
     F                                     RENAME(HSTTRDF:HSTTRDF_V)
     F                                     RENAME(DPTMVDF:DPTMVDF_V)
     F                                     RENAME(DPTMVTF:DPTMVTF_V)
     F                                     IGNORE(SEDVPRD0)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D CPOSNX        E DS                  EXTNAME(CPOSND) PREFIX(CP_)
     D SECTYX        E DS                  EXTNAME(SECTYD) PREFIX(SE_)
     D INVTPX        E DS                  EXTNAME(INVTPD) PREFIX(IN_)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
     IDPTMVDF_T
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPMD                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     IDPTMVTF_T
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPDO                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     IDPTMVDF_V
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPMD                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
     IDPTMVTF_V
     I              DPRN                        TDRF
     I              DPNA                        NOML
     I              DPDO                        TDVD
     I              DPMV                        TDTP
     I              DMTD                        TDDT
 
 
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
      *
      * EXTRACT ALL SECURITIES CUSTOMER POSITIONS
      * OR EXTRACT A SINGLE SECURITY CUSTOMER POSITION
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
      * EXTRACT ALL SECURITIES CUSTOMER POSITIONS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   READ      CPOSNDF                                99    *
      *
      * Whilst positions can be found
      *
     C     *IN99         DOWEQ     '0'
 
      * Access security details
      * Extract trade date position
      * Extract value date position
 
     C                   EXSR      ACS_SECURITY
     C     Extract_POSN  IFEQ      'Y'
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
      * Read the next record
      *
     C                   READ      CPOSNDF                                99    *
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE SECURITY CUSTOMER POSITION
      ********************************************************************
     C     EXTSIN        BEGSR
 
      * Access latest position
 
     C     CPOSNK        CHAIN     CPOSNDF                            99        *
 
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
     C                   Z-ADD     BVDate        CP_CSDA
     C**********         Z-ADD     0             CP_CSNT                                    MD045155
     C**********         Z-ADD     0             CP_CSNV                                    MD045155
 
     C     CPOSHK        SETGT     CPOSH
     C     CPOSHP        READPE    CPOSH                                  99
      *
      *  If a position is present
      *  Set the current position date to its position date
      *
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     CH_CSDA       CP_CSDA
     C                   Z-ADD     CH_CSNT       CP_CSNT
     C                   Z-ADD     CH_CSNV       CP_CSNV
     C                   ENDIF
      *
      *  If no position is present prior to the back-value date the position
      *  date is the day prior to the value date of the first trade or depot
      *  movement present (If none present, set the position date to today)
      *
     C     *IN99         IFEQ      '1'
 
     C     Trade_Value   IFEQ      'T'
     C     TRADK         SETLL     TDPBT
     C                   ELSE
     C     TRADK         SETLL     TDPBV
     C                   ENDIF
 
     C     *IN99         DOUEQ     '1'
     C     RECI          ORNE      '*'
     C     RECI          ANDNE     'C'
     C     RECI          ANDNE     'R'
     C     Trade_Value   IFEQ      'T'
     C     TRADK         READE     TDPBT                                  99    *
     C                   ELSE
     C     TRADK         READE     TDPBV                                  99
     C                   ENDIF
     C  N99TDDT          IFEQ      0
     C                   Z-ADD     TDVD          TDDT
     C                   ENDIF
     C                   ENDDO
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     I#RDNB        CP_CSDA
     C                   ELSE
     C     Trade_Value   IFEQ      'T'
     C     TDDT          SUB       1             CP_CSDA
     C                   ELSE
     C     TDVD          SUB       1             CP_CSDA
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   CALLB     'GOXTSCPS'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           50
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    CPOSNX
     C                   PARM                    SECTYX
     C                   PARM                    INVTPX
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   MOVEL     I#CNUM        W#CNUM            6
     C                   EVAL      BUFFER = 'SCPS' + I#EXTT + I#BRCA
     C                                    + W#CNUM + I#SESN
     C                                    + W#RTCD + W#ERMS + CPOSNX
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   EXSR      *PSSR                                                      247103
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
 
     C     CP_CSSC       CHAIN     SECTYDF                            99        *
 
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
 
     C     CPOSNK        KLIST
     C                   KFLD                    I#BRCA
     C                   KFLD                    I#SESN
     C                   KFLD                    I#CNUM
 
     C     INVTPK        KLIST
     C                   KFLD                    SE_NMCY
     C                   KFLD                    SE_SITP
 
     C     CPOSHK        KLIST
     C                   KFLD                    CP_CSBA
     C                   KFLD                    CP_CSSC
     C                   KFLD                    CP_CSCN
     C                   KFLD                    CP_CSDA
 
     C     CPOSHP        KLIST
     C                   KFLD                    CP_CSBA
     C                   KFLD                    CP_CSSC
     C                   KFLD                    CP_CSCN
 
     C     TRADK         KLIST
     C                   KFLD                    CP_CSBA
     C                   KFLD                    CP_CSCN
     C                   KFLD                    CP_CSSC
     C                   KFLD                    CP_CSDA
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
