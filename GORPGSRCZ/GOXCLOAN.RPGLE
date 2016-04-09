     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(CLOANX) TOFILE(CLOAN) SHARE(*NO)                 *
/*XBIB*  OVRDBF FILE(CLOANS) TOFILE(CLOAN) SHARE(*NO)                 *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO Extract Controller for Customer Loans')       *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOXCLOAN - Extract Controller for Customer                   *
      *             Lending Loans                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR1056838          Date 15Nov12               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CGO001AC           Date 06Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CGP014             Date 27Mar09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG13562           Date 16Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CGP001  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR1056838 - Task Split's driver file use 6numeric for LNRF.  *
      *              Change LNRF from 6S0 to 6A to comply w/ Alpha    *
      *              Loan Reference Enhancement                       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CGO001AC - COB Restructure - GO COB Optimisation Phase 1     *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CGP014 - Task split of Extract Controller, Customer Loans    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG13562 - Do not extract matured transactions into GPTRAPPD *
      *     Fix was also applied to MP121 via 246296 bug              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CGP001 - Global Processing                                   *
      *                                                               *
      *****************************************************************
 
     FXCLNDVPD  IF   E           K DISK    INFSR(*PSSR)                                       CGP014
     F**********                           RENAME(CLOANCLF: DRIVERF)                 CGP014 CGO001AC
     F                                     RENAME(XCLNDVD0:DRIVERF)                         CGO001AC
     F                                     PREFIX(CL_)                                        CGP014
     F                                     USROPN                                             CGP014
     FCLOANX    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF)
     F                                     PREFIX(CL_)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCKF)
     F                                     PREFIX(CK_)
     FCLOANS    IF   E           K DISK    INFSR(*PSSR)
     F                                     INCLUDE(CLOANCLF)
     F                                     RENAME(CLOANCLF:CLOANCLS)
     F                                     PREFIX(SL_)
 
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
 
     D LOANCL        E DS                  EXTNAME(CLOANCL) PREFIX(CL_)
     D LOANCK        E DS                  EXTNAME(CLOANCK) PREFIX(CK_)
 
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D***OLNOAlpha               1      6                                              CSD027 CLE148
     D***OLNONum                 1      6  0                                           CSD027 CLE148
 
      ** Data Structure for the end record key                                              CGO001AC
     D                 DS                                                                   CGO001AC
     D ENDKEY                  1      7                                                     CGO001AC
     D***ELNRF**                 1      6  0                                      CGO001AC AR1056838
     D ELNRF                   1      6                                                    AR1056838
     D ERCDT                   7      7                                                     CGO001AC
                                                                                            CGO001AC
      ** Data Structure for the next record key                                             CGO001AC
     D                 DS                                                                   CGO001AC
     D NXTKEY                  1      7                                                     CGO001AC
     D***NLNRF**                 1      6  0                                      CGO001AC AR1056838
     D NLNRF                   1      6                                                    AR1056838
     D NRCDT                   7      7                                                     CGO001AC
                                                                                            CGO001AC
     D IXCKEY          S              1A                                                    CGO001AC
                                                                                            CGO001AC
     C     *ENTRY        PLIST
      /COPY GOCPYSRC,GOXCEPARM
                                                                                            CGO001AC
      ** Key field for CLOAN file                                                           CGO001AC
                                                                                            CGO001AC
     C     CLOANKEY      KLIST                                                              CGO001AC
     C                   KFLD                    CL_LNRF                                    CGO001AC
     C                   KFLD                    CL_RCDT                                    CGO001AC
      *
      * EXTRACT ALL LOANS
      * OR EXTRACT A SINGLE LOAN
      *
     C     I#EXTT        IFEQ      '*ALL'
     C     I#EXTT        OREQ      '*TSK'                                                     CGP014
     C                   EXSR      EXTALL
                                                                                            CGO001AC
     C                   IF        I#EXTT <> '*TSK'                                         CGO001AC
     C                   SETON                                        LR
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C                   ELSE
     C                   EXSR      EXTSIN
     C                   ENDIF
      *
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * EXTRACT ALL LOANS
      ********************************************************************
     C     EXTALL        BEGSR
      *
     C                   IF        I#EXTT = '*TSK'                                          CGO001AC
     C                   OPEN      XCLNDVPD                                                 CGO001AC
                                                                                            CGO001AC
      ** Read END record key from XCLNDVPD                                                  CGO001AC
                                                                                            CGO001AC
     C                   EVAL      IXCKEY = 'Z'                                             CGO001AC
     C     IXCKEY        CHAIN     XCLNDVPD                           38                    CGO001AC
     C                   IF        *IN38 = '0'                                              CGO001AC
     C                   EVAL      ELNRF = CL_LNRF                                          CGO001AC
     C                   EVAL      ERCDT = CL_RCDT                                          CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
      ** Read START record key form XCLNDVPD                                                CGO001AC
                                                                                            CGO001AC
     C                   IF        *IN38 = '0'                                              CGO001AC
     C                   EVAL      IXCKEY = 'A'                                             CGO001AC
     C     IXCKEY        CHAIN     XCLNDVPD                           38                    CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C                   IF        *IN38 = '0'                                              CGO001AC
     C                   EVAL      NLNRF = CL_LNRF                                          CGO001AC
     C                   EVAL      NRCDT = CL_RCDT                                          CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C                   IF        *IN38 = '1'                                              CGO001AC
     C                   EXSR      *PSSR                                                    CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
      ** Set up pointer to the first record for process                                     CGO001AC
                                                                                            CGO001AC
     C                   EVAL      *IN99 = '0'                                              CGO001AC
     C                   IF        NXTKEY > ENDKEY                                          CGO001AC
     C                   EVAL      *IN99 = '1'                                              CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C                   IF        *IN99 = '0'                                              CGO001AC
     C     CLOANKEY      SETLL     CLOANCLF                                                 CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C                   CLOSE     XCLNDVPD                                                 CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C*****I#EXTT        IFEQ      '*TSK'                                            CGP014 CGO001AC
     C**********         READ      DRIVERF                                99         CGP014 CGO001AC
     C**********         ELSE                                                        CGP014 CGO001AC
     C                   READ      CLOANCLF                               99    *
     C**********         ENDIF                                                       CGP014 CGO001AC
      *
      * Whilst loans can be found
      *
     C     *IN99         DOWEQ     '0'
      *
      **Extract*any*live*or*matured*loans*                                                  BUG13562
      * Extract any live loans                                                              BUG13562
      *
     C     CL_RECI       IFEQ      'D'
     C*****CL_RECI       OREQ      'M'                                                      BUG13562
     C                   EXSR      ACS_OTHER_DTLS
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
     C                   ENDIF
      *
      * Read the next record
      *
     C*****I#EXTT        IFEQ      '*TSK'                                            CGP014 CGO001AC
     C**********         READ      DRIVERF                                99         CGP014 CGO001AC
     C**********         ELSE                                                        CGP014 CGO001AC
     C                   READ      CLOANCLF                               99    *
     C**********         ENDIF                                                       CGP014 CGO001AC
                                                                                            CGO001AC
      ** Check if end record is read                                                        CGO001AC
                                                                                            CGO001AC
     C                   IF        I#EXTT = '*TSK' and *IN99 = '0'                          CGO001AC
     C                   EVAL      NLNRF = CL_LNRF                                          CGO001AC
     C                   EVAL      NRCDT = CL_RCDT                                          CGO001AC
     C                   IF        NXTKEY > ENDKEY                                          CGO001AC
     C                   EVAL      *IN99 = '1'                                              CGO001AC
     C                   ENDIF                                                              CGO001AC
     C                   ENDIF                                                              CGO001AC
                                                                                            CGO001AC
     C                   ENDDO
      *
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * EXTRACT A SINGLE LOAN
      ********************************************************************
     C     EXTSIN        BEGSR
      *
     C**********         MOVEL     I#TREF        W#LNRF            6 0                        CLE148
     C                   MOVEL     I#TREF        W#LNRF            6                          CLE148
     C     W#LNRF        CHAIN     CLOANCLF                           99        *
      *
      * If the loan is found
      * access other details
      * extract it
      * if not matured                                                                      BUG13562
      *
     C     *IN99         IFEQ      '0'
     C     CL_RECI       ANDNE     'M'                                                      BUG13562
     C                   EXSR      ACS_OTHER_DTLS
     C                   MOVEL     'V'           Trade_Value       1
     C                   EXSR      EXTRCT
     C                   MOVEL     'T'           Trade_Value
     C                   EXSR      EXTRCT
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
     C                   CALLB     'GOXTLOAN'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      I#LOC         W#LOC             4
     C                   PARM      I#CCID        W#CCID           10 0
 
     C                   PARM      I#RDNB        W#RDNB            5 0
     C                   PARM      I#DNWD        W#DNWD            5 0
     C                   PARM      I#PCOD        W#PCOD            5 0
     C                   PARM      Trade_Value   W#TVDI            1
     C                   PARM                    LOANCL
     C                   PARM                    LOANCK
     C                   PARM                    SL_CNUM
     C                   PARM                    SL_MLNR
     C                   PARM                    SL_OLNO
 
      * If data error encountered, log error
 
     C     W#RTCD        IFEQ      '*ERROR '
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = 'LOAN' + I#EXTT + I#TREF
     C                             + W#RTCD + W#ERMS + LOANCL
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
      * Get further loan details needed from CLOANCK
      *
     C                   CLEAR                   LOANCK
     C     CL_LNRF       CHAIN     CLOANCKF                           99        *
      *
      * For parts sold, get sale of loan number details
      *
     C**********         Z-ADD     0             SL_MLNR                                      CLE148
     C                   MOVEL     *BLANK        SL_MLNR                                      CLE148
     C**********         Z-ADD     0             SL_OLNO                                      CSD027
     C**********         Z-ADD     0             SL_CNUM                                      CSD027
     C                   EVAL      SL_OLNO = *BLANKS                                          CSD027
     C                   EVAL      SL_CNUM = *BLANKS                                          CSD027
     C     CL_PTYP       IFEQ      66                                           *
     C     CL_PTYP       OREQ      67                                           *
     C     CL_PTYP       OREQ      69                                           *
     C     CL_PTYP       OREQ      72                                           *
     C*****CL_OLNO       CHAIN     CLOANCLS                           99        *             CSD027
     C**********         EVAL      OLNOALpha = CL_OLNO                                 CSD027 CLE148
     C*****OLNONum       CHAIN     CLOANCLS                           99        *      CSD027 CLE148
     C     CL_OLNO       CHAIN     CLOANCLS                           99                      CLE148
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
 
     C*****I#EXTT        IFEQ      '*TSK'                                            CGP014 CGCGP014
     C**********         OPEN      XCLNDVPD                                          CGP014 CGCGP014
     C**********         ENDIF                                                       CGP014 CGCGP014
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
