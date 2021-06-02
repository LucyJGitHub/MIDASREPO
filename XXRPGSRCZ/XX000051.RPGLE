     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('IRS REVALUATION EXTRACT')                              *                       LUC109
     F*****************************************************************
     F*                                                               *
     F*  Midas - FRA/IRS Module                                       *
     F*                                                               *
     F***GLM051*-*IRS*REVALUATION*EXTRACT******************************                       LUC109
      *  XX000051 - IRS REVALUATION EXTRACT                           *                       LUC109
     F*  (Copy of DL1955 - IRS REVALUATION EXTRACT )                  *
      *                                                               *                       LUC109
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1988,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. LUC013             Date 02Jun08               *
      *                 MUI009             Date 16Feb04               *
      *                 EFIXRG             Date 07Mar01               *
      *                 MMI043  *CREATE    Date 17Feb99               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180466             Date 27Jun00               *
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 152016             Date 07Jan99               *
     F*                 146477             DATE 11Nov98               *
     F*                 127751             DATE 17DEC97               *
     F*                 127748             DATE 17DEC97               *
     F*                 110055             DATE 17DEC97               *
     F*                 100317             DATE 13MAR97               *
     F*                 100953             DATE 15MAR97               *
     F*                 100298             DATE 05MAR97               *
     F*                 100288             DATE 04MAR96               *
     F*                 CIR001 *CREATE     DATE 13JUN95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
     F*  LUC013 - Invoke DLLZFWR instead od DLZFWR.                   *
     F*  MUI009 - R4.1 Upgrade: add CAS001 changes                    *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
     F*  EFIXRG - CHANGES NEEDED TO UPGRADE THIS PROGRAM TO DBA3.     *
     F*  MMI043 - Bank of Italy Head Office Reporting                 *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  180466 - Change in program DLZFRQ. Additional parameter      *
      *           ZFRZBD inserted for DLZFRQ.                         *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CSW097 - MT340s and MT360s changes for SWIFT97               *
      *           Removed 146447 as it does not cater for settlement  *
      *           currencies which may be defined differently for     *
      *           RXs.  The call to DLZFRQ wil be changed to          *
      *           add two new parameters to specify settlement ccy    *
      *           and whether Rate Change Date or Interest Payment    *
      *           Date is looked for as these two have different      *
      *           holiday considerations.                             *
     F*  152016 - Previous fix #146477 incorrectly incorporated.      *
     F*  146477 - If the Settlement currency has been entered, use    *
     F*           the value to calculate the Forward Rate.            *
     F*  127751 - Where a rate for a new interest period has fixed but*
     F*           has not yet taken effect (between fix date and rate *
     F*           change date), the system attempts to recalculate the*
     F*           rate for the next period. As the rate is known, it  *
     F*           should be taken from the file.                      *
     F*  127748 - Spread is still being output when before rate change*
     F*           date - extend fix 100953.                           *
     F*  110055 - When revaluing SWAPS with an interest frequency of  *
     F*           'Z' on the floating side, the estimated forward rate*
     F*           for every fixing period after the first is identical*
     F*           and too high. DL1955 is not outputting records for  *
     F*           subsequent fixing periods.                          *
     F*  100317 - The straight-line method of interpolating discount  *
     F*           factors using SR/ZINTPL did not provide satisfatory *
     F*           results. As the discount factors curve is           *
     F*           exponential, an PL1 program (ZEXPIN) is used to     *
     F*           perform an exponential interpolation. This program  *
     F*           amended to pass spot date to PGM/DLZFWR.            *
     F*  100953 - Do not produce a cash flow for Spread if it is      *
     F*           before the rate change date.                        *
     F*  100298 - Do not output any cash-flows dated prior to the     *
     F*           run date.                                           *
     F*  100288 - When building up the deal activity for rate changes *
     F*           from either a schedule (SR/ACRATS) or a frequency   *
     F*           code (SR/ACRATF), the access to the principal       *
     F*           schedule did not work for single-currency swaps. In *
     F*           this case, the Our/Their Indicator should be blank. *
     F*  CIR001 - Interest Rate Calendars                             *
     F*                                                               *
     F*****************************************************************
     F/COPY WNCPYSRC,DL1955F001
     FDEALSDG   IF   E           K DISK    INFSR(*PSSR)
     FDEALALL   UF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     RENAME(DEALSDGF:DEALSUF)
     FDLDTSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLPCSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLCFSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLACTVPD  IF A E           K DISK    INFSR(*PSSR)
     FDLCFEVPD  O    E           K DISK    INFSR(*PSSR)
      * Start MMI043
     F*DL1955AUO   E                    PRINTER      KINFDS SPOOLU
     F***GLM051AU  O    E             PRINTER INFDS(SPOOLU)                                   LUC109
     FXX000051AUO    E             PRINTER INFDS(SPOOLU)                                      LUC109
     F                                     INFSR(*PSSR)
     FSDBANKPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RECNO(WRECNO)
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
     FSDGELRPD  IF   E             DISK    INFSR(*PSSR)
     F                                     RECNO(WRECNO)
      * End MMI043
     F***********                                   KINFSR *PSSR     EFIXRG
      /EJECT
      *----------------------------------------------------------------
      * ID  F  C  H  L    FUNCTION OF INDICATORS
      *       11          INITIAL RATE SET IND ON
      *       90-99       STANDARD SUBROUTINES
      *       U7          DATABASE ERROR
      *----------------------------------------------------------------
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D***/C*PY*ZSRSRC,ZHOLE                                                            100317 LUC109
     D/COPY ZSRSRC,ZHOLELE                                                                    LUC109
     D***/C*PY*ZSRSRC,ZFRQB2Z1                                                         CIR005 LUC109
     D ZFMD            S              2    DIM(12) CTDATA PERRCD(12)                          LUC109
     D***/C*PY*ZSRSRC,ZDATE2Z1                                                         CIR005 LUC109
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 LUC109
     D SPOOLU          DS
      ***  File Information Data Structure for DL1955AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D** External DS for GENERAL LEDGER details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    100317
     D** External DS for CURRENCIES details                               100317
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CIR005
      ** External DS for SAR details                                      CIR005
      *                                                                   CIR005
     D***/C*PY*ZSRSRC,ZHOLI                                                            100317 LUC109
     D***/C*PY*ZSRSRC,ZHOLDS                                                           100317 LUC109
     D/COPY ZSRSRC,ZHOLILE                                                                    LUC109
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     LUC109
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D**   Local data area to hold database error information
     D*
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D PCURR           DS            30                                         CIR005
      ** Data Structure for Payment Convention Currencies                 CIR005
      *                                                                   CIR005
     D  WCYP1                  1      3                                         CIR005
     D  WCYP2                  4      6                                         CIR005
     D  WCYP3                  7      9                                         CIR005
     D  WCYP4                 10     12                                         CIR005
     D  WCYP5                 13     15                                         CIR005
     D  WCYP6                 16     18                                         CIR005
     D  WCYP7                 19     21                                         CIR005
     D  WCYP8                 22     24                                         CIR005
     D  WCYP9                 25     27                                         CIR005
     D  WCYP0                 28     30                                         CIR005
     I**************************************************************************
      /SPACE 5
     C**************************************************************************
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** INITIAL PROCESSING
     C*
     C                   EXSR      INIT
     C*
     C** MAIN PROCESSING
     C*
     C                   READ      DEALSDGF                               99    *
     C     *IN99         DOWEQ     '0'
     C*
     C** DETERMINE IF DEAL TO BE EXTRACTED
     C*
     C                   MOVEL     *BLANK        ##EXT             2
     C                   EXSR      DETIFX
     C*
     C** IF DEAL TO BE EXTRACTED, EXTRACT IT
     C*
     C     ##EXT         IFNE      'NO'
     C                   EXSR      EXTRAC
     C                   END
     C                   READ      DEALSDGF                               99    *
     C                   END
     C*
     C** AUDIT
     C*
     C                   EXSR      AUDIT
     C**************************************************************************
      /EJECT
     C********************************************************************
     C** EXTRACT LIVE SINGLE AND CROSS CURRENCY SWAPS
     C********************************************************************
     C     EXTRAC        BEGSR
     C*
     C*--------------------------------------------------------------------
     C*
     C** D E A L    A C T I V I T Y   U P D A T E
     C*
     C** MOVE 'OUR' DETAILS TO WORK FIELDS
     C*
     C                   EXSR      OUR
     C*
     C** DEAL ACTIVITY UPDATE FOR 'OUR' DETAILS
     C*
     C                   EXSR      DEALAC
     C*
     C** MOVE 'THEIR' DETAILS TO WORK FIELDS
     C*
     C                   EXSR      THEIR
     C*
     C** DEAL ACTIVITY UPDATE FOR 'THEIR' DETAILS
     C*
     C                   EXSR      DEALAC
     C*
     C*--------------------------------------------------------------------
     C*
     C** C A S H    F L O W   E V E N T S    U P D A T E
     C** -   I N T E R E S T   &  C A S H   F L O W S
     C*
     C** MOVE 'OUR' DETAILS TO WORK FIELDS
     C*
     C                   EXSR      OUR
     C*
     C** UPDATE CASH FLOW EVENTS FOR INTEREST & CASH FLOWS - 'OUR' DETAILS
     C*
     C                   EXSR      CFEVIC
     C*
     C** MOVE 'THEIR' DETAILS TO WORK FIELDS
     C*
     C                   EXSR      THEIR
     C*
     C** UPDATE CASH FLOW EVENTS FOR INTEREST & CASH FLOWS - 'THEIR' DETAILS
     C*
     C                   EXSR      CFEVIC
     C*
     C*--------------------------------------------------------------------
     C*
     C** C A S H    F L O W   E V E N T S    U P D A T E
     C** -   S P R E A D    P A Y M E N T S
     C*
     C** MOVE 'OUR' DETAILS TO WORK FIELDS
     C*
     C                   EXSR      OUR
     C*
     C** UPDATE CASH FLOW EVENTS FOR SPREAD PAYMENTS - 'OUR' DETAILS
     C*
     C                   EXSR      CFEVSP
     C*
     C** MOVE 'THEIR' DETAILS TO WORK FIELDS
     C*
     C                   EXSR      THEIR
     C*
     C** UPDATE CASH FLOW EVENTS FOR SPREAD PAYMENTS - 'THEIR' DETAILS
     C*
     C                   EXSR      CFEVSP
     C*
     C/COPY WNCPYSRC,DL1955C003
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C** DEAL ACTIVITY UPDATE
     C********************************************************************
     C     DEALAC        BEGSR
     C*
     C** SET UP VARIABLES USED IN FORWARD RATE CALCULATION
     C*
     C                   MOVE      WCUCY         ZFWCCY
     C                   MOVE      WSTCY         ZSTCY                                         CSW09
     C                   MOVE      WICBS         ZFWINC
     C*
     C** SET UP VARIABLES USED IN FREQUENCY CALCULATION
     C*
     C                   MOVEL     WICFR         ZFRFRQ
     C                   Z-ADD     WICFD         ZFRBAS
     C                   Z-ADD     WSETM         ZFRSET
     C                   MOVEL     WCUCY         ZFRCCY
     C                   MOVEL     WSACC         ZFRNOS
     C                   Z-ADD     MDAT          ZFRMDT
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED INTEREST ACCRUAL CONTROL
     C** DATE WITH PRINCIPAL = CURRENT PRINCIPAL & RATE = CURRENT RATE
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WIACD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
     C*
     C/COPY WNCPYSRC,DL1955C001
     C** CHECK IF INITIAL RATE SET (EFFECTIVE INTEREST RATE SET
     C** FOR FIRST PERIOD OF THE IRS; I.E. STARTING FROM VALUE DATE)
     C*
     C     WBRTT         COMP      *ZERO                                  11    *
     C  N11              TESTB     '0'           WDNSI                    11    *INITIAL RATE SET IN
     C*
     C** IF INITIAL RATE SET USE EFFECTIVE INTEREST RATE
     C*
     C     *IN11         IFEQ      '1'
     C                   Z-ADD     WEINR         ACEINR
     C                   MOVEL     'A'           ACRTTP                         * ACTUAL RATE
     C*
     C** IF INITIAL RATE NOT SET, DETERMINE FORWARD RATE
     C** (FOR VALUE DATE TO NEXT RATE CHANGE DATE)
     C*
     C                   ELSE
     C                   Z-ADD     VDAT          ZFWNDT                         * NEAR DATE
     C                   Z-ADD     WNICD         ZFWFDT                   99    * FAR DATE
     C   99              Z-ADD     MDAT          ZFWFDT                         * FAR DATE
     C                   EXSR      CALFWR
     C                   Z-ADD     ZFWOUT        ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C                   END
     C/COPY WNCPYSRC,DL1955C006
     C*
     C                   WRITE     DLACTVD0
     C*
     C** WRITE RATE CHANGES TO DEAL ACTIVITY FILE
     C*
     C     WBRTT         IFNE      *ZERO
     C     WNICD         ANDNE     *ZERO
     C     WNICD         ANDLT     MDAT
     C*
     C* WRITE RATE CHANGES TO DEAL ACTIVITY FILE - FROM SCHEDULE
     C*
     C     WICFR         IFEQ      'Z'
     C                   EXSR      ACRATS
     C                   ELSE
     C*
     C* WRITE RATE CHANGES TO DEAL ACTIVITY FILE - FROM FREQUENCY CODE
     C*
     C                   EXSR      ACRATF
     C                   END
     C*
     C                   END
     C*
     C** WRITE PRINCIPAL CHANGES TO DEAL ACTIVITY FILE
     C*
     C     WNPCD         IFNE      *ZERO
     C                   EXSR      ACPRIN
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
     C/SPACE 5
     C********************************************************************
     C* WRITE RATE CHANGES TO DEAL ACTIVITY FILE - FROM SCHEDULE
     C********************************************************************
     C     ACRATS        BEGSR
     C*
     C** SET FILE POINTER TO NEXT RATE CHANGE DATE
     C*
     C                   MOVEL     WOTIN         OTIN
     C                   MOVEL     'R'           RCIP
     C                   Z-ADD     WNICD         PRDT
     C     DLDTSK        CHAIN     DLDTSCPD                           99        *
     C*
     C** BYPASS IF NEXT RATE CHANGE DATE NOT FOUND
     C*
     C     *IN99         CABEQ     '1'           EACRTS
     C*
     C** UPDATE LAST INTEREST RATE CHANGE DATE
     C** TO THIS CURRENT RATE CHANGE DATE
     C*
     C                   Z-ADD     WNICD         WLICD             5 0
     C*
     C** GET FOLLOWING RATE CHANGE DATE
     C*
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C*
     C** DO WHILE RATE CHANGES ARE FOUND
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** CALCULATE FORWARD RATE FROM LAST RATE CHANGE DATE
     C** TO THIS CURRENT RATE CHANGE DATE
     C*
     C                   Z-ADD     WLICD         ZFWNDT                         * NEAR DATE
     C                   Z-ADD     PRDT          ZFWFDT                         * FAR DATE
     C                   EXSR      CALFWR
     C*
     C** DETERMINE PRINCIPAL
     C** AS AT THE LAST CURRENT RATE CHANGE DATE
     C*
      *                                                                   100288
      ** If swap is single currency, the Our/Their Indicator on the       100288
      **   principal change records will be blank.                        100288
      *                                                                   100288
     C     DTYP          IFEQ      'RX'                                                        10028
     C                   MOVEL     WOTIN         OTIN                                          10028
     C                   ELSE                                                                  10028
     C                   MOVEL     *BLANK        OTIN                                          10028
     C                   END                                                                   10028
      *                                                                   100288
     C                   Z-ADD     WLICD         PRDT
     C     DLPCSK        SETGT     DLPCSCPD
     C     DLPCSP        READPE    DLPCSCPD                               99    *
     C  N99              Z-ADD     PAMT          WPAMT
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED LAST RATE CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE
     C** & RATE = FORWARD RATE TO NEXT RATE CHANGE DATE
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WLICD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
     C                   Z-ADD     ZFWOUT        ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C     WINFD         IFGT      WLICD                                                       12775
     C                   Z-ADD     WBRTE         ACEINR                         *NEXT BASERATE 12775
     C                   MOVEL     'A'           ACRTTP                                        12775
     C     WSPIN         IFEQ      'A'                                                         12775
     C     ACEINR        ADD       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C     WSPIN         IFEQ      'S'                                                         12775
     C     ACEINR        SUB       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C                   END                                                                   12775
     C     ZFRRTC        IFEQ      '*NRCD'
     C                   MOVEL     '?'           ACRTTP
     C                   END
     C/COPY WNCPYSRC,DL1955C007
     C                   WRITE     DLACTVD0
     C*
     C** UPDATE LAST INTEREST RATE CHANGE DATE
     C** TO THIS CURRENT RATE CHANGE DATE
     C*
     C                   Z-ADD     ZFWFDT        WLICD
     C*
     C** GET NEXT RATE CHANGE DATE
     C*
     C                   SETOFF                                       99                       11005
     C                   MOVEL     WOTIN         OTIN                                          11005
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C                   END
     C*
     C** CALCULATE FORWARD RATE FROM LAST RATE CHANGE DATE
     C** TO MATURITY DATE
     C*
     C                   Z-ADD     WLICD         ZFWNDT                         * NEAR DATE
     C                   Z-ADD     MDAT          ZFWFDT                         * FAR DATE
     C                   EXSR      CALFWR
     C*
     C** DETERMINE PRINCIPAL
     C** AS AT THE LAST CURRENT RATE CHANGE DATE
     C*
      *                                                                   100288
      ** If swap is single currency, the Our/Their Indicator on the       100288
      **   principal change records will be blank.                        100288
      *                                                                   100288
     C     DTYP          IFEQ      'RX'                                                        10028
     C                   MOVEL     WOTIN         OTIN                                          10028
     C                   ELSE                                                                  10028
     C                   MOVEL     *BLANK        OTIN                                          10028
     C                   END                                                                   10028
      *                                                                   100288
     C                   Z-ADD     WLICD         PRDT
     C     DLPCSK        SETGT     DLPCSCPD
     C     DLPCSP        READPE    DLPCSCPD                               99    *
     C  N99              Z-ADD     PAMT          WPAMT
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED LAST RATE CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE
     C** & RATE = FORWARD RATE TO MATURITY DATE
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WLICD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
     C                   Z-ADD     ZFWOUT        ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C     WINFD         IFGT      WLICD                                                       12775
     C                   Z-ADD     WBRTE         ACEINR                         *NEXT BASERATE 12775
     C                   MOVEL     'A'           ACRTTP                                        12775
     C     WSPIN         IFEQ      'A'                                                         12775
     C     ACEINR        ADD       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C     WSPIN         IFEQ      'S'                                                         12775
     C     ACEINR        SUB       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C                   END                                                                   12775
     C     ZFRRTC        IFEQ      '*NRCD'
     C                   MOVEL     '?'           ACRTTP
     C                   END
     C/COPY WNCPYSRC,DL1955C008
     C                   WRITE     DLACTVD0
     C*
     C     EACRTS        ENDSR
     C**************************************************************************
     C/SPACE 5
     C********************************************************************
     C* WRITE RATE CHANGES TO DEAL ACTIVITY FILE - FROM FREQUENCY CODE
     C********************************************************************
     C     ACRATF        BEGSR
     C*
     C** UPDATE LAST INTEREST RATE CHANGE DATE
     C** TO THIS CURRENT RATE CHANGE DATE
     C*
     C                   Z-ADD     WNICD         WLICD
     C*
     C** DETERMINE FOLLOWING RATE CHANGE DATE
     C*
     C                   Z-ADD     WLICD         ZFRDAT
     C                   MOVEL     'R'           ZRCIP                                         CSW09
     C                   EXSR      DETNXD
     C*
     C** DO WHILE NEXT RATE CHANGE DATE < MATURITY DATE
     C*
     C     ZFRNXD        DOWLT     MDAT
     C*
     C** CALCULATE FORWARD RATE FROM LAST RATE CHANGE DATE
     C** TO THIS CURRENT RATE CHANGE DATE
     C*
     C                   Z-ADD     WLICD         ZFWNDT                         * NEAR DATE
     C                   Z-ADD     ZFRNXD        ZFWFDT                         * FAR DATE
     C                   EXSR      CALFWR
     C*
     C** DETERMINE PRINCIPAL
     C** AS AT THE LAST CURRENT RATE CHANGE DATE
     C*
      *                                                                   100288
      ** If swap is single currency, the Our/Their Indicator on the       100288
      **   principal change records will be blank.                        100288
      *                                                                   100288
     C     DTYP          IFEQ      'RX'                                                        10028
     C                   MOVEL     WOTIN         OTIN                                          10028
     C                   ELSE                                                                  10028
     C                   MOVEL     *BLANK        OTIN                                          10028
     C                   END                                                                   10028
      *                                                                   100288
     C                   Z-ADD     WLICD         PRDT
     C     DLPCSK        SETGT     DLPCSCPD
     C     DLPCSP        READPE    DLPCSCPD                               99    *
     C  N99              Z-ADD     PAMT          WPAMT
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED LAST RATE CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE
     C** & RATE = FORWARD RATE TO NEXT RATE CHANGE DATE
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WLICD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
     C                   Z-ADD     ZFWOUT        ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C     WINFD         IFGT      WLICD                                                       12775
     C                   Z-ADD     WBRTE         ACEINR                         *NEXT BASERATE 12775
     C                   MOVEL     'A'           ACRTTP                                        12775
     C     WSPIN         IFEQ      'A'                                                         12775
     C     ACEINR        ADD       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C     WSPIN         IFEQ      'S'                                                         12775
     C     ACEINR        SUB       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C                   END                                                                   12775
     C     ZFRRTC        IFEQ      '*NRCD'
     C                   MOVEL     '?'           ACRTTP
     C                   END
     C/COPY WNCPYSRC,DL1955C009
     C                   WRITE     DLACTVD0
     C*
     C** UPDATE LAST INTEREST RATE CHANGE DATE
     C** TO THIS CURRENT RATE CHANGE DATE
     C*
     C                   Z-ADD     ZFRNXD        WLICD
     C*
     C** DETERMINE NEXT RATE CHANGE DATE
     C*
     C                   Z-ADD     WLICD         ZFRDAT
     C                   MOVEL     'R'           ZRCIP                                         CSW09
     C                   EXSR      DETNXD
     C*
     C                   END
     C*
     C** CALCULATE FORWARD RATE FROM LAST RATE CHANGE DATE
     C** TO MATURITY DATE
     C*
     C                   Z-ADD     WLICD         ZFWNDT                         * NEAR DATE
     C                   Z-ADD     MDAT          ZFWFDT                         * FAR DATE
     C                   EXSR      CALFWR
     C*
     C** DETERMINE PRINCIPAL
     C** AS AT THE LAST CURRENT RATE CHANGE DATE
     C*
      *                                                                   100288
      ** If swap is single currency, the Our/Their Indicator on the       100288
      **   principal change records will be blank.                        100288
      *                                                                   100288
     C     DTYP          IFEQ      'RX'                                                        10028
     C                   MOVEL     WOTIN         OTIN                                          10028
     C                   ELSE                                                                  10028
     C                   MOVEL     *BLANK        OTIN                                          10028
     C                   END                                                                   10028
      *                                                                   100288
     C                   Z-ADD     WLICD         PRDT
     C     DLPCSK        SETGT     DLPCSCPD
     C     DLPCSP        READPE    DLPCSCPD                               99    *
     C  N99              Z-ADD     PAMT          WPAMT
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED LAST RATE CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE
     C** & RATE = FORWARD RATE TO MATURITY DATE
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WLICD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
     C                   Z-ADD     ZFWOUT        ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C     WINFD         IFGT      WLICD                                                       12775
     C                   Z-ADD     WBRTE         ACEINR                         *NEXT BASERATE 12775
     C                   MOVEL     'A'           ACRTTP                                        12775
     C     WSPIN         IFEQ      'A'                                                         12775
     C     ACEINR        ADD       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C     WSPIN         IFEQ      'S'                                                         12775
     C     ACEINR        SUB       WRTSP         ACEINR                                        12775
     C                   END                                                                   12775
     C                   END                                                                   12775
     C     ZFRRTC        IFEQ      '*NRCD'
     C                   MOVEL     '?'           ACRTTP
     C                   END
     C/COPY WNCPYSRC,DL1955C010
     C                   WRITE     DLACTVD0
     C*
     C                   ENDSR
     C**************************************************************************
     C/SPACE 5
     C********************************************************************
     C* WRITE PRINCIPAL CHANGES TO DEAL ACTIVITY FILE
     C********************************************************************
     C     ACPRIN        BEGSR
     C*
     C** GET NEXT PRINCIPAL CHANGE DATE
     C*
     C     DTYP          IFEQ      'RX'
     C                   MOVEL     WOTIN         OTIN
     C                   ELSE
     C                   MOVEL     *BLANK        OTIN
     C                   END
     C                   Z-ADD     WNPCD         PRDT
     C     DLPCSK        CHAIN     DLPCSCPD                           99        *
     C*
     C** DO WHILE PRINCIPAL CHANGES FOUND
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** ONLY ADD TO DEAL ACTIVITY FILE IF DATE NOT REPRESENTED
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVE      WOTIN         ACOTIN
     C                   Z-ADD     PRDT          ACPRDT
     C     DLACTK        CHAIN     DLACTVD0                           99        *
     C     *IN99         IFEQ      '1'
     C*
     C** DETERMINE RATE AS AT PRINCIPAL CHANGE DATE FROM
     C** DEAL ACTIVITY FILE
     C*
     C     DLACTK        SETLL     DLACTVD0
     C     DLACTP        READPE    DLACTVD0                               99    *
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED PRINCIPAL CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE
     C** & RATE = RATE TAKEN FROM DEAL ACTIVITY FILE
     C*
     C                   Z-ADD     PRDT          ACPRDT
     C                   Z-ADD     PAMT          ACPCPL
     C/COPY WNCPYSRC,DL1955C011
     C                   WRITE     DLACTVD0
     C                   END
     C*
     C** GET NEXT PRINCIPAL CHANGE DATE
     C*
     C     DLPCSP        READE     DLPCSCPD                               99    *
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C**************************************************************************
     C* UPDATE CASH FLOW EVENTS FOR INTEREST & CASH FLOWS
     C**************************************************************************
     C     CFEVIC        BEGSR
     C*
     C**  CASHFLOWS DEFINED AS A SCHEDULE
     C*
     C     WIPFR         IFEQ      'C'
     C                   EXSR      CSHFLW
     C                   GOTO      ECFEVI
     C                   END
     C*
     C** IF NEXT INTEREST PAY DATE NOT PRESENT,
     C** DEFAULT IT TO MATURITY DATE
     C*
     C     WNIPD         IFEQ      *ZERO
     C                   Z-ADD     MDAT          WNIPD
     C                   END
     C*
     C** INTEREST PAYABLE UP FRONT (MUST BE PART OF A SCHEDULE)
     C*
     C     WINPM         IFEQ      'D'
     C     WINPM         OREQ      'Y'
     C                   EXSR      INPYUF
     C                   GOTO      ECFEVI
     C                   END
     C*
     C** INTEREST NOT PAYABLE UP FRONT (SCHEDULE OR FREQUENCY)
     C*
     C*
     C**  INTEREST PAYMENTS - FROM INTEREST PAYMENT SCHEDULE
     C*
     C     WIPFR         IFEQ      'Z'
     C                   EXSR      INPYS
     C*
     C**  INTEREST PAYMENTS - FROM INTEREST PAYMENT FREQUENCY CODE
     C*
     C                   ELSE
     C                   EXSR      INPYF
     C                   END
     C     ECFEVI        ENDSR
     C**************************************************************************
      /SPACE 5
     C**************************************************************************
     C* UPDATE CASH FLOW EVENTS FOR SPREAD PAYMENTS
     C**************************************************************************
     C     CFEVSP        BEGSR
     C*
     C** IF A SPREAD ON THE FLOATING SIDE, THE SPREAD CAN BE
     C** REPRESENTED AS A CASH FLOW PAID ON INTEREST PAYMENT DATES
     C*
     C     WSPIN         IFEQ      'S'                                          * SUBTRACT
     C     WSPIN         OREQ      'A'                                          * ADD
     C*
     C** ONLY IF NEXT RATE CHANGE DATE PRESENT AND PRIOR TO MATURITY DATE
     C*
     C     WNICD         IFNE      *ZERO
     C     WNICD         ANDLT     MDAT
     C*
     C** IF NEXT INTEREST PAY DATE NOT PRESENT,
     C** DEFAULT IT TO MATURITY DATE
     C*
     C     WNIPD         IFEQ      *ZERO
     C                   Z-ADD     MDAT          WNIPD
     C                   END
     C*
     C**  SPREAD PAYMENTS - FROM INTEREST PAYMENT SCHEDULE
     C*
     C     WIPFR         IFEQ      'Z'
     C                   EXSR      SPPYS
     C*
     C**  SPREAD PAYMENTS - FROM INTEREST PAYMENT FREQUENCY CODE
     C*
     C                   ELSE
     C                   EXSR      SPPYF
     C                   END
     C                   END
     C                   END
     C     ECFEVS        ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* PROCESS CASHFLOWS
     C********************************************************************
     C     CSHFLW        BEGSR
     C*
     C** GET NEXT CASH FLOW
     C*
     C                   MOVEL     WOTIN         OTIN
     C                   Z-ADD     WNIPD         PRDT
     C     DLCFSK        CHAIN     DLCFSCPD                           99        *
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** WRITE OUT CASH FLOW EVENT FOR DEFINED CASHFLOW
     C*
     C                   Z-ADD     PRDT          CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     CFLA          CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C     CFAMNT        IFNE      *ZERO
     C                   EXSR      WRTCFE
     C                   END
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          WSLIP
     C*
     C** GET NEXT CASH FLOW
     C*
     C     DLCFSP        READE     DLCFSCPD                               99    *
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* PROCESS INTEREST PAYMENTS - UP FRONT
     C********************************************************************
     C     INPYUF        BEGSR
     C*
     C** WRITE OUT CASH FLOW EVENT FOR VALUE DATE IF NOT YET REACHED
     C*
     C     VDAT          IFGE      BJDNWD
     C                   Z-ADD     VDAT          CFPYDT
     C                   Z-ADD     WNIPD         CFNIPD
     C                   Z-ADD     VDAT          CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C                   END
     C*
     C** SET FILE POINTER TO NEXT INTEREST PAYMENT DATE
     C*
     C                   MOVEL     WOTIN         OTIN
     C                   MOVEL     'P'           RCIP
     C                   Z-ADD     WNIPD         PRDT
     C     DLDTSK        CHAIN     DLDTSCPD                           99        *
     C*
     C** BYPASS IF NEXT INTEREST PAYMENT DATE NOT FOUND
     C*
     C     *IN99         CABEQ     '1'           EINPYU
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C** TO THIS CURRENT PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         WSLIP
     C*
     C** GET FOLLOWING INTEREST PAYMENT DATE
     C*
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C*
     C** DO WHILE INTEREST PAYMENTS ARE FOUND
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** WRITE OUT CASH FLOW EVENT FOR LAST INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WSLIP         CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C** TO THIS CURRENT PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          WSLIP
     C*
     C** GET NEXT RATE CHANGE DATE
     C*
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR LAST INTEREST PAYMENT DATE
     C*
     C     WSLIP         IFGT      VDAT
     C     WSLIP         ANDLT     MDAT
     C                   Z-ADD     WSLIP         CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C                   END
     C*
     C     EINPYU        ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* PROCESS INTEREST PAYMENTS - FROM INTEREST PAYMENT SCHEDULE
     C********************************************************************
     C     INPYS         BEGSR
     C*
     C** GET NEXT DATE
     C*
     C                   MOVEL     WOTIN         OTIN
     C                   MOVEL     'P'           RCIP
     C                   Z-ADD     WNIPD         PRDT
     C     DLDTSK        CHAIN     DLDTSCPD                           99        *
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** WRITE OUT CASH FLOW EVENT FOR NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          WSLIP
     C*
     C** GET NEXT DATE
     C*
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR MATURITY DATE
     C*
     C     WSLIP         IFLT      MDAT
     C                   Z-ADD     MDAT          CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* PROCESS INTEREST PAYMENTS - FROM INTEREST PAYMENT FREQUENCY CODE
     C********************************************************************
     C     INPYF         BEGSR
     C*
     C** SET UP VARIABLES USED IN FREQUENCY CALCULATION
     C*
     C                   MOVEL     WIPFR         ZFRFRQ
     C                   Z-ADD     WIPFD         ZFRBAS
     C                   Z-ADD     WSETM         ZFRSET
     C                   MOVEL     WCUCY         ZFRCCY
     C                   MOVEL     WSACC         ZFRNOS
     C                   Z-ADD     MDAT          ZFRMDT
     C*
     C** DO WHILE MATURITY DATE NOT REACHED
     C*
     C     WNIPD         DOWLT     MDAT
     C*
     C** WRITE OUT CASH FLOW EVENT FOR NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         CFPYDT
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WAMCN         ANDEQ     'A'                                                         CIR00
     C     WCYP1         ANDNE     *BLANK                                                      CIR00
     C                   Z-ADD     WIPBD         CFNIPD                                        CIR00
     C                   ELSE                                                                  CIR00
     C                   Z-ADD     WNIPD         CFNIPD
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C*
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WAMCN         ANDEQ     'A'                                                         CIR00
     C     WCYP1         ANDNE     *BLANK                                                      CIR00
     C                   Z-ADD     WIPBD         WSLIP                                         CIR00
     C                   ELSE                                                                  CIR00
     C                   Z-ADD     WNIPD         WSLIP
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C*
     C** DETERMINE NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         ZFRDAT
     C                   MOVEL     'P'           ZRCIP                                         CSW09
     C                   EXSR      DETNXD
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WCYP1         ANDNE     *BLANKS                                                     CIR00
     C     WIPBD         ANDGT     ZFRMDT                                                      CIR00
     C                   Z-ADD     ZFRMDT        ZFRNXD                                        CIR00
     C                   Z-ADD     ZFRMDT        WIPBD                                         CIR00
     C                   ENDIF                                                                 CIR00
     C*
     C** UPDATE NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     ZFRNXD        WNIPD
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR MATURITY DATE
     C*
     C                   Z-ADD     MDAT          CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     *ZERO         CFRTSP                         * SPREAD
     C                   MOVEL     *BLANK        CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* PROCESS SPREAD PAYMENTS - FROM INTEREST PAYMENT SCHEDULE
     C********************************************************************
     C     SPPYS         BEGSR
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C** WITH NEXT RATE CHANGE DATE
     C*
     C                   Z-ADD     WNICD         WSLIP
     C*
     C** GET NEXT INTEREST PAYMENT DATE AFTER THE NEXT RATE CHANGE DATE
     C*
     C                   MOVEL     WOTIN         OTIN
     C                   MOVEL     'P'           RCIP
     C                   Z-ADD     WNICD         PRDT
     C     DLDTSK        SETGT     DLDTSCPD
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C*
     C     *IN99         DOWEQ     '0'
     C*
     C** WRITE OUT CASH FLOW EVENT FOR NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     WRTSP         CFRTSP                         * SPREAD
     C                   MOVEL     WSPIN         CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          WSLIP
     C*
     C** GET NEXT DATE
     C*
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR MATURITY DATE
     C*
     C     WSLIP         IFLT      MDAT
     C                   Z-ADD     MDAT          CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     WRTSP         CFRTSP                         * SPREAD
     C                   MOVEL     WSPIN         CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* PROCESS SPREAD PAYMENTS - FROM INTEREST PAYMENT FREQUENCY CODE
     C********************************************************************
     C     SPPYF         BEGSR
     C*
     C** SET UP VARIABLES USED IN FREQUENCY CALCULATION
     C*
     C                   MOVEL     WIPFR         ZFRFRQ
     C                   Z-ADD     WIPFD         ZFRBAS
     C                   Z-ADD     WSETM         ZFRSET
     C                   MOVEL     WCUCY         ZFRCCY
     C                   MOVEL     WSACC         ZFRNOS
     C                   Z-ADD     MDAT          ZFRMDT
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C** WITH NEXT RATE CHANGE DATE
     C*
     C                   Z-ADD     WNICD         WSLIP
     C*
     C** IF NEXT RATE CHANGE DATE IS > OR EQUAL TO NEXT INTEREST PAYMENT
     C** DATE, CALCULATE THE FIRST INTEREST PAYMENT DATE FOLLOWING IT
     C*
     C********** WNICD     IFGE WNIPD                                     100953
     C     WNICD         DOWGE     WNIPD                                                       10095
     C     WNIPD         ORGT      MDAT                                                        10095
     C                   Z-ADD     WNIPD         ZFRDAT
     C                   EXSR      DETNXD
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WCYP1         ANDNE     *BLANKS                                                     CIR00
     C     WIPBD         ANDGT     ZFRMDT                                                      CIR00
     C                   Z-ADD     ZFRMDT        ZFRNXD                                        CIR00
     C                   Z-ADD     ZFRMDT        WIPBD                                         CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   Z-ADD     ZFRNXD        WNIPD
     C                   END
     C*
     C** DO WHILE MATURITY DATE NOT REACHED
     C*
     C     WNIPD         DOWLT     MDAT
     C*
     C** WRITE OUT CASH FLOW EVENT FOR NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         CFPYDT
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WAMCN         ANDEQ     'A'                                                         CIR00
     C     WCYP1         ANDNE     *BLANK                                                      CIR00
     C                   Z-ADD     WIPBD         CFNIPD                                        CIR00
     C                   ELSE                                                                  CIR00
     C                   Z-ADD     WNIPD         CFNIPD
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     WRTSP         CFRTSP                         * SPREAD
     C                   MOVEL     WSPIN         CFSPIN                         * SPREAD IND
     C*                                                                   127748
     C** Only if the start/last int. date is after the fix date           127748
     C*                                                                   127748
     C     CFSLIP        IFGE      WINFD                                                       12774
     C                   EXSR      WRTCFE
     C                   END                                                                   12774
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C*
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WAMCN         ANDEQ     'A'                                                         CIR00
     C     WCYP1         ANDNE     *BLANK                                                      CIR00
     C                   Z-ADD     WIPBD         WSLIP                                         CIR00
     C                   ELSE                                                                  CIR00
     C                   Z-ADD     WNIPD         WSLIP
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C*
     C** DETERMINE NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         ZFRDAT
     C                   EXSR      DETNXD
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WCYP1         ANDNE     *BLANKS                                                     CIR00
     C     WIPBD         ANDGT     ZFRMDT                                                      CIR00
     C                   Z-ADD     ZFRMDT        ZFRNXD                                        CIR00
     C                   Z-ADD     ZFRMDT        WIPBD                                         CIR00
     C                   ENDIF                                                                 CIR00
     C*
     C** UPDATE NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     ZFRNXD        WNIPD
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR MATURITY DATE
     C*
     C                   Z-ADD     MDAT          CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   Z-ADD     WRTSP         CFRTSP                         * SPREAD
     C                   MOVEL     WSPIN         CFSPIN                         * SPREAD IND
     C                   EXSR      WRTCFE
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* WRITE OUT CASH FLOW EVENTS
     C********************************************************************
     C     WRTCFE        BEGSR
     C*
      ** Do not output any cash-flows dated prior to the run date.        100298
      *                                                                   100298
     C     CFPYDT        IFGE      BJRDNB                                                      10029
      *                                                                   100298
     C                   Z-ADD     DLNO          CFDLNO                         * DEAL NUMBER
     C                   MOVEL     WOTIN         CFOTIN                         * OUR/THEIR
     C     CFSPIN        IFEQ      'S'
     C                   Z-SUB     CFRTSP        CFRTSP                         * SPREAD
     C                   END
     C                   MOVEL     WCUCY         CFCCY                          * DEAL CCY
     C                   MOVEL     WBRTT         CFBRTT                         * BASE RATE
     C                   MOVEL     WICBS         CFINCL                         * INT.CAL.BASIS
     C                   MOVEL     WINPM         CFINPM                         * INT PROC.METH.
     C     DTYP          IFEQ      'RS'
     C                   MOVEL     WCUCY         CFRCCY                         * REPORT CCY
     C                   ELSE
     C                   MOVEL     BJCYCD        CFRCCY                         * BASE CURRENCY
     C                   END
     C                   MOVEL     BOKC          CFBOKC                         * BOOK
     C                   MOVEL     BRCA          CFBRCA                         * BRANCH
      *                                                                                       CAS001
     C     CAS001        IFEQ      'Y'
     C                   MOVEL     WYLDC         CFYLDC
     C                   ENDIF
      *                                                                                       CAS001
     C                   WRITE     DLCFEVD0
      *                                                                   100298
     C                   ENDIF                                                                 10029
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* MOVE 'OUR' DETAILS TO WORK FIELDS
     C********************************************************************
     C     OUR           BEGSR
     C*
     C                   MOVE      UCUCY         WCUCY             3
     C                   MOVE      PSCY          WSTCY             3                           CSW09
     C                   Z-ADD     UPAMT         WPAMT            13 0
     C                   Z-ADD     UBRTT         WBRTT             2 0
     C                   Z-ADD     UBRTE         WBRTE            11 7
     C                   Z-ADD     URTSP         WRTSP            11 7
     C                   Z-ADD     UEINR         WEINR            11 7
     C                   MOVE      USPIN         WSPIN             1
     C                   Z-ADD     UICBS         WICBS             1 0
     C                   Z-ADD     UINFD         WINFD             5 0
     C                   Z-ADD     UNICD         WNICD             5 0
     C                   Z-ADD     UICBD         WICBD             5 0
     C                   MOVE      UICFR         WICFR             1
     C                   Z-ADD     UICFD         WICFD             2 0
     C                   Z-ADD     UNIPD         WNIPD             5 0
     C                   Z-ADD     UIPBD         WIPBD             5 0
     C                   Z-ADD     USLIP         WSLIP             5 0
     C                   MOVE      UIPFR         WIPFR             1
     C                   Z-ADD     UIPFD         WIPFD             2 0
     C                   Z-ADD     UIACD         WIACD             5 0
     C                   Z-ADD     UAITC         WAITC            13 0
     C                   Z-ADD     UAIAN         WAIAN            13 0
     C                   Z-ADD     UAIAP         WAIAP            13 0
     C                   Z-ADD     UIPRD         WIPRD            13 0
     C                   MOVE      UDNSI         WDNSI             1
     C                   MOVE      UDSTI         WDSTI             1
     C                   MOVE      PSETM         WSETM             2 0
     C                   MOVE      UPACC         WSACC            12
     C                   MOVE      UINPM         WINPM             1
     C                   MOVE      UNPCD         WNPCD             5 0
     C                   MOVE      'U'           WOTIN             1
      *                                                                   CIR005
      ** Save Business Day Convention fields                              CIR005
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C                   MOVE      L1AMCN        WAMCN                                         CIR00
     C                   MOVE      L1CYP1        WCYP1                                         CIR00
     C                   MOVE      L1CYP2        WCYP2                                         CIR00
     C                   MOVE      L1CYP3        WCYP3                                         CIR00
     C                   MOVE      L1CYP4        WCYP4                                         CIR00
     C                   MOVE      L1CYP5        WCYP5                                         CIR00
     C                   MOVE      L1CYP6        WCYP6                                         CIR00
     C                   MOVE      L1CYP7        WCYP7                                         CIR00
     C                   MOVE      L1CYP8        WCYP8                                         CIR00
     C                   MOVE      L1CYP9        WCYP9                                         CIR00
     C                   MOVE      L1CYP0        WCYP0                                         CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                   100317
      ** Access the currency details and calculate the spot date.         100317
      *                                                                   100317
      * Start MMI043
     C     WCUCY         CHAIN     SDCURRL0                           50
     C***********          CALL 'AOCURRR0'                                100317
     C***********          PARM '*MSG    '@RTCD                           100317
     C***********          PARM '*KEY    '@OPTN                           100317
     C***********          PARM           WCUCY                           100317
     C***********SDCURR    PARM SDCURR    DSSDY                           100317
     C***********@RTCD     IFNE *BLANK                                    100317
     C     *IN50         IFEQ      *ON                                                         10031
      * End MMI043
     C                   MOVE      'SDCURRPD'    DBFILE                         ***************10031
     C                   Z-ADD     011           DBASE                          * DB ERROR 11 *10031
     C                   MOVEL     WCUCY         DBKEY                          ***************10031
     C                   EXSR      *PSSR                                                       10031
     C                   END                                                                   10031
      *                                                                   100317
      ** Calculate the currency spot date.                                100317
      *                                                                   100317
     C                   MOVE      WCUCY         ZCCY                                          10031
     C                   MOVE      *BLANKS       ZLOC                                          10031
     C                   Z-ADD     BJRDNB        ZDAYNO                                        10031
     C                   Z-ADD     A6SPDY        ZNRDYS                                        10031
     C                   EXSR      ZFWDT                                                       10031
     C                   Z-ADD     ZDYNBR        WSPDT             5 0                         10031
      *                                                                                       CAS001
     C     CAS001        IFEQ      'Y'
     C                   MOVEL     FSOYLC        WYLDC
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* MOVE 'THEIR' DETAILS TO WORK FIELDS
     C********************************************************************
     C     THEIR         BEGSR
     C*
     C                   MOVE      TCUCY         WCUCY             3
     C                   MOVE      RSCY          WSTCY             3                           CSW09
     C                   Z-ADD     TPAMT         WPAMT            13 0
     C                   Z-ADD     TBRTT         WBRTT             2 0
     C                   Z-ADD     TBRTE         WBRTE            11 7
     C                   Z-ADD     TRTSP         WRTSP            11 7
     C                   Z-ADD     TEINR         WEINR            11 7
     C                   MOVE      TSPIN         WSPIN             1
     C                   Z-ADD     TICBS         WICBS             1 0
     C                   Z-ADD     TINFD         WINFD             5 0
     C                   Z-ADD     TNICD         WNICD             5 0
     C                   Z-ADD     TICBD         WICBD             5 0
     C                   MOVE      TICFR         WICFR             1
     C                   Z-ADD     TICFD         WICFD             2 0
     C                   Z-ADD     TNIPD         WNIPD             5 0
     C                   Z-ADD     TIPBD         WIPBD             5 0
     C                   Z-ADD     TSLIP         WSLIP             5 0
     C                   MOVE      TIPFR         WIPFR             1
     C                   Z-ADD     TIPFD         WIPFD             2 0
     C                   Z-ADD     TIACD         WIACD             5 0
     C                   Z-ADD     TAITC         WAITC            13 0
     C                   Z-ADD     TAIAN         WAIAN            13 0
     C                   Z-ADD     TAIAP         WAIAP            13 0
     C                   Z-ADD     TIPRD         WIPRD            13 0
     C                   MOVE      TDNSI         WDNSI             1
     C                   MOVE      TDSTI         WDSTI             1
     C                   MOVE      RSETM         WSETM             2 0
     C                   MOVE      URACC         WSACC            12
     C                   MOVE      TINPM         WINPM             1
     C     DTYP          IFEQ      'RX'
     C                   MOVE      TNPCD         WNPCD             5 0
     C                   ELSE
     C                   MOVE      UNPCD         WNPCD             5 0
     C                   END
     C                   MOVE      'T'           WOTIN             1
      *                                                                   CIR005
      ** Save Business Day Convention fields                              CIR005
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
      *                                                                   CIR005
     C     DTYP          IFEQ      'RX'                                                        CIR00
     C                   MOVE      L2PDCN        WPDCN             2                           CIR00
     C                   MOVE      L2AMCN        WAMCN             2                           CIR00
     C                   MOVE      L2CYP1        WCYP1             3                           CIR00
     C                   MOVE      L2CYP2        WCYP2             3                           CIR00
     C                   MOVE      L2CYP3        WCYP3             3                           CIR00
     C                   MOVE      L2CYP4        WCYP4             3                           CIR00
     C                   MOVE      L2CYP5        WCYP5             3                           CIR00
     C                   MOVE      L2CYP6        WCYP6             3                           CIR00
     C                   MOVE      L2CYP7        WCYP7             3                           CIR00
     C                   MOVE      L2CYP8        WCYP8             3                           CIR00
     C                   MOVE      L2CYP9        WCYP9             3                           CIR00
     C                   MOVE      L2CYP0        WCYP0             3                           CIR00
     C                   ELSE                                                                  CIR00
     C                   MOVE      L1PDCN        WPDCN                                         CIR00
     C                   MOVE      L1AMCN        WAMCN                                         CIR00
     C                   MOVE      L1CYP1        WCYP1                                         CIR00
     C                   MOVE      L1CYP2        WCYP2                                         CIR00
     C                   MOVE      L1CYP3        WCYP3                                         CIR00
     C                   MOVE      L1CYP4        WCYP4                                         CIR00
     C                   MOVE      L1CYP5        WCYP5                                         CIR00
     C                   MOVE      L1CYP6        WCYP6                                         CIR00
     C                   MOVE      L1CYP7        WCYP7                                         CIR00
     C                   MOVE      L1CYP8        WCYP8                                         CIR00
     C                   MOVE      L1CYP9        WCYP9                                         CIR00
     C                   MOVE      L1CYP0        WCYP0                                         CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   ENDIF                                                                 CIR00
      *                                                                   100317
      ** Access the currency details and calculate the spot date.         100317
      *                                                                   100317
      * Start MMI043
     C     WCUCY         CHAIN     SDCURRL0                           50
     C***********          CALL 'AOCURRR0'                                100317
     C***********          PARM '*MSG    '@RTCD                           100317
     C***********          PARM '*KEY    '@OPTN                           100317
     C***********          PARM           WCUCY                           100317
     C***********SDCURR    PARM SDCURR    DSSDY                           100317
     C***********@RTCD     IFNE *BLANK                                    100317
     C     *IN50         IFEQ      *ON                                                         10031
      * End MMI043
     C                   MOVE      'SDCURRPD'    DBFILE                         ***************10031
     C                   Z-ADD     011           DBASE                          * DB ERROR 11 *10031
     C                   MOVEL     WCUCY         DBKEY                          ***************10031
     C                   EXSR      *PSSR                                                       10031
     C                   END                                                                   10031
      *                                                                   100317
      ** Calculate the currency spot date.                                100317
      *                                                                   100317
     C                   MOVE      WCUCY         ZCCY                                          10031
     C                   MOVE      *BLANKS       ZLOC                                          10031
     C                   Z-ADD     BJRDNB        ZDAYNO                                        10031
     C                   Z-ADD     A6SPDY        ZNRDYS                                        10031
     C                   EXSR      ZFWDT                                                       10031
     C                   Z-ADD     ZDYNBR        WSPDT                                         10031
      *                                                                                       CAS001
     C     CAS001        IFEQ      'Y'
     C     DTYP          IFEQ      'RX'
     C                   MOVEL     FSTYLC        WYLDC
     C                   ELSE
     C                   MOVEL     FSOYLC        WYLDC
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* CALCULATE FORWARD RATE
     C********************************************************************
     C     CALFWR        BEGSR
     C*
     C** Use the Settlement currency if it has been entered.                                  146477
     C*                                                                                       146477
     C     RSCY          IFNE      *BLANKS
     C     PSCY          ANDNE     *BLANKS
     C                   MOVEL     RSCY          ZFWCCY
     C                   ENDIF
     C*****                CALL 'DLZFWR'                                    LUC013 LUC109
     C                   CALL      'XXDLLZFWR'                                     LUC109
     C                   PARM      *BLANK        ZFWRTC            5
     C                   PARM                    ZFWCCY            3            * CURRENCY
     C                   PARM                    ZFWINC            1            * INT.CALC.METH.
     C                   PARM      WSPDT         ZFWSDT            5 0          * SPOT DATE    10031
     C                   PARM                    ZFWNDT            5 0          * NEAR DATE
     C                   PARM                    ZFWFDT            5 0          * FAR DATE
     C                   PARM                    ZFWOUT           11 7          * FORWARD RATE
     C                   PARM                    WYLDC             5
     C*
     C/COPY WNCPYSRC,DL1955C002
     C     ZFWRTC        IFEQ      '*ERR*'
     C                   EXSR      *PSSR
     C                   END
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* DETERMINE NEXT DAY
     C********************************************************************
     C     DETNXD        BEGSR
     C*                                                                   146477
     C** Use the Settlement currency if it has been entered.              146477
     C*                                                                   146477
     C     RSCY          IFNE      *BLANKS                                                     14647
     C     PSCY          ANDNE     *BLANKS                                                     14647
     C***********          MOVELRSCY      ZFWCCY                   146477 152016
     C                   MOVEL     RSCY          ZFRCCY                                        15201
     C                   ENDIF                                                                 14647
      *                                                                   CIR005
      ** Determine Next Rate Change Date                                  CIR005
      *                                                                   CIR005
     C     CIR005        IFEQ      'Y'                                                         CIR00
     C     WCYP1         ANDNE     *BLANK                                                      CIR00
      *                                                                   CIR005
     C     ZFRFRQ        IFEQ      *BLANK                                                      CIR00
     C                   Z-ADD     ZFRMDT        ZFRNXD                                        CIR00
     C                   Z-ADD     ZFRMDT        WIPBD                                         CIR00
      *                                                                   CIR005
     C                   ELSE                                                                  CIR00
      *                                                                   CIR005
     C                   MOVEL     ZFRFRQ        ZFREQ                                         CIR00
     C                   Z-ADD     ZFRDAT        ZDAYNO                                        CIR00
     C                   Z-ADD     ZFRBAS        ZMDAY                                         CIR00
     C                   MOVE      BJSLCD        ZLOC                                          CIR00
     C                   EXSR      ZFRQB3                                                      CIR00
      *                                                                   CIR005
      ** Adjust date according to payment convention currencies           CIR005
      *                                                                   CIR005
     C                   CALL      'DLZIRP'                                                    CIR00
     C                   PARM                    ZDAYNO                                        CIR00
     C                   PARM                    PCURR                                         CIR00
     C                   PARM      WPDCN         PPDCN             2                           CIR00
     C                   PARM                    ZLOC                                          CIR00
     C                   PARM                    BJDFIN                                        CIR00
     C                   PARM                    PAJDT             5 0                         CIR00
     C                   PARM                    PBSDT             5 0                         CIR00
      *                                                                   CIR005
     C     PAJDT         IFGE      ZFRMDT                                                      CIR00
     C                   Z-ADD     ZFRMDT        ZFRNXD                                        CIR00
     C                   Z-ADD     ZFRMDT        WIPBD                                         CIR00
     C                   ELSE                                                                  CIR00
     C                   Z-ADD     PAJDT         ZFRNXD                                        CIR00
     C                   Z-ADD     PBSDT         WIPBD                                         CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
      ** Do not return adjusted date if it is equal to or earlier than    CIR005
      ** previous date (only happens for 'previous' date calculations);   CIR005
      ** instead use the base date                                        CIR005
      *                                                                   CIR005
     C     ZFRDAT        IFGE      ZFRNXD                                                      CIR00
     C                   Z-ADD     PBSDT         ZFRNXD                                        CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   ELSE                                                                  CIR00
     C*
     C                   CALL      'DLZFRQ'
     C                   PARM      *BLANK        ZFRRTC            5
     C                   PARM                    ZFRDAT            5 0          * DATE
     C                   PARM                    ZFRFRQ            1            * FREQUENCY
     C                   PARM                    ZFRBAS            2 0          * BASE DAY
     C                   PARM                    ZFRSET            2 0          * SETT.METH.
     C                   PARM                    ZFRCCY            3            * CURRENCY
     C                   PARM                    ZSTCY             3            * Settl Ccy    CSW09
     C                   PARM                    ZRCIP             1            * 'R' or 'P'   CSW09
     C                   PARM                    ZFRNOS            2            * NOSTRO
     C                   PARM                    ZFRMDT            5 0          * MAT.DATE
     C                   PARM                    BKAPDT            5 0
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
     C                   PARM      *ZERO         ZFRZBD            5 0          * BASE DATE    18046
     C                   PARM      *ZERO         ZFRNXD            5 0          * NEXT DATE
     C     ZFRRTC        IFEQ      '*ERR*'
     C                   EXSR      *PSSR
     C                   END
      *                                                                   CIR005
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C** DETERMINE IF DEAL TO BE EXTRACTED
     C********************************************************************
     C     DETIFX        BEGSR
     C*
     C** LIVE DEALS ONLY MAY BE EXTRACTED
     C*
     C     RECI          IFNE      'D'
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** SINGLE OR CROSS CURRENCY DEALS ONLY MAY BE EXTRACTED
     C*
     C     DTYP          IFNE      'RS'
     C     DTYP          ANDNE     'RX'
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** IGNORE IF BOUGHT OUT
     C*
     C     BOAM          IFNE      *ZERO
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** SINGLE OR CROSS CURRENCY SELECTED
     C*
     C     PSXCY         IFEQ      'S'                                          * SINGLE
     C     DTYP          ANDEQ     'RX'
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C     PSXCY         IFNE      'S'                                          * CROSS
     C     DTYP          ANDEQ     'RS'
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** BRANCH SELECTED
     C*
     C     PBRCA         IFNE      *BLANK
     C     PBRCA         ANDNE     BRCA
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** CURRENCY SELECTED - ONLY APPLICABLE IF SINGLE CURRENCY SELECTED
     C*
     C     PSXCY         IFEQ      'S'                                          * SINGLE
     C     PCUCY         ANDNE     *BLANK
     C     PCUCY         ANDNE     UCUCY
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** BOOK SELECTED
     C*
     C     PBOKC         IFNE      *BLANK
     C     PBOKC         ANDNE     BOKC
     C                   MOVEL     'NO'          ##EXT
     C                   GOTO      EDETIF
     C                   END
     C*
     C** COUNT OF DEALS EXTRACTED
     C*
     C                   ADD       1             RNORE
     C*
     C** SET UNREALIZED P/L ON DEAL TO ZERO IF PROGRAM RUN IN COB
     C*
     C     PICCB         IFEQ      'C'
     C     DLNO          CHAIN     DEALSUF                            99        *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'DEALSDG '    DBFILE                         ***************
     C                   MOVEL     '010'         DBASE                          * DB ERROR 10 *
     C                   MOVEL     DLNO          DBKEY                          ***************
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     *ZERO         UNRL
     C                   EXCEPT    UDEAL
     C                   END
     C*
     C     EDETIF        ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* AUDIT
     C********************************************************************
     C     AUDIT         BEGSR
      *
      * Start MMI043
     C***********          Z-ADDSFNUMU    ZSNUM   60
     C***********          CALL 'ZSFILE'
     C***********          PARM           SEQ
     C***********          PARM *BLANKS   WPARM   3
     C***********          PARM           SFILEU
     C***********          PARM           ZSNUM
     C***********          PARM           ZSERR   1
      ***********
     C***********ZSERR     IFEQ 'Y'
     C***********          SETON                     U7U8LR
     C***********          RETRN
     C***********          END
      * End MMI043
      *
      ***  Output Report Header and File Controls.
      *
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
      *
      ***  If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      '1'
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ***  Or, if no valid records read, Output "No Details" message.
      *
     C     RNORE         IFEQ      *ZERO
     C                   WRITE     NODTLS
     C                   END
     C                   END
      *
      ***  End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* INITIAL PROCESSING
     C********************************************************************
     C     INIT          BEGSR
      *
      ***  Receive Parameter List:
      ***   PSXCY - ('S' or 'X'), Single or Cross Currency.
      ***   PICCB - ('I' or 'C'), Input Cycle or Close of Business.
      ***   PBRCA - Branch Code selected. Blank if no Branch selected.
      ***   PCUCY - Currency selected. Blank if no Currency selected.
      ***   PBOKC - Book Code selected. Blank if no Book selected.
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSXCY             1
     C                   PARM                    PICCB             1
     C                   PARM                    PBRCA             3
     C                   PARM                    PCUCY             3
     C                   PARM                    PBOKC             2
      * Start MMI043
     C***********          PARM           SEQ     5
      * End MMI043
      *
      ** CALL ACCESS PROGRAM FOR BANK DETAILS
      *
      * Start MMI043
     C                   Z-ADD     1             WRECNO            5 0
     C     WRECNO        CHAIN     SDBANKPD                           50        Bank details
     C***********          CALL 'AOBANKR0'
     C***********          PARM '*DBERR  '@RTCD   7
     C***********          PARM '*FIRST  '@OPTN   7
     C***********SDBANK    PARM SDBANK    DSFDY
      *
     C***********@RTCD     IFNE *BLANK
     C     *IN50         IFEQ      *ON
      * End MMI043
     C                   MOVEL     'SDBANKPD'    DBFILE                          *************
     C                   MOVEL     '001'         DBASE                           *DBERROR 001*
      * Start MMI043
     C***********          MOVEL@OPTN     DBKEY             *************
     C                   MOVEL     '*FIRST'      DBKEY                           *************
      * End MMI043
     C                   EXSR      *PSSR
     C                   END
      *
      **  Set Date Format Indicator
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   END
      *                                                                   CIR005
      ** Check if switchable feature CIR005 is switched on                CIR005
      *                                                                   CIR005
     C                   CALL      'AOSARDR0'                                                  CIR00
     C***********          PARM *BLANKS   @RTCD                           CIR005
     C                   PARM      *BLANKS       @RTCD             7                           EFIXR
     C***********          PARM '*VERIFY' @OPTN                           CIR005
     C                   PARM      '*VERIFY'     @OPTN             7                           EFIXR
     C                   PARM      'CIR005'      @SARD             6                           CIR00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CIR00
      *                                                                   CIR005
     C     @RTCD         IFNE      *BLANK                                                      CIR00
     C     @RTCD         ANDNE     '*NRF   '                                                   CIR00
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************   CIR00
     C                   Z-ADD     04            DBASE                          * DBERR 04 *   CIR00
     C                   MOVEL     'CIR005'      DBKEY                          ************   CIR00
     C                   EXSR      *PSSR                                                       CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                   CIR005
     C     @RTCD         IFEQ      *BLANKS                                                     CIR00
     C                   MOVE      'Y'           CIR005            1                           CIR00
     C                   ELSE                                                                  CIR00
     C                   MOVE      'N'           CIR005                                        CIR00
     C                   ENDIF                                                                 CIR00
      *                                                                                       CAS001
      ** Check if switchable feature CAS001 is switched on                                    CAS001
      *                                                                                       CAS001
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CAS001'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CAS001
     C     PRTCD         IFNE      *BLANK
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     20            DBASE
     C                   MOVEL     'CAS001'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CAS001
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001            1
     C                   ELSE
     C                   MOVE      'N'           CAS001
     C                   ENDIF
      *
      ** CALL ACCESS PROGRAM FOR GENERAL LEDGER DETAILS
      *
      * Start MMI043
     C                   Z-ADD     1             WRECNO            5 0
     C     WRECNO        CHAIN     SDGELRPD                           50        Bank Extension
     C***********          CALL 'AOGELRR0'
     C***********          PARM '*DBERR  '@RTCD   7
     C***********          PARM '*FIRST  '@OPTN   7
     C***********SDGELR    PARM SDGELR    DSFDY
      *
     C***********@RTCD     IFNE *BLANK
     C     *IN50         IFEQ      *ON
      * End MMI043
     C                   MOVEL     'SDGELRPD'    DBFILE                          *************
     C                   MOVEL     '002'         DBASE                           *DBERROR 002*
      * Start MMI043
     C***********          MOVEL@OPTN     DBKEY             *************
     C                   MOVEL     '*FIRST'      DBKEY                           *************
      * End MMI043
     C                   EXSR      *PSSR
     C                   END
     C*
     C** KEY LISTS FOR ACCESS OF DATE SCHEDULE
     C*
     C     DLDTSK        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C                   KFLD                    PRDT
     C     DLDTSP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    RCIP
     C*
     C** KEY LISTS FOR ACCESS OF CASHFLOWS
     C*
     C     DLCFSK        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
     C     DLCFSP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C*
     C** KEY LISTS FOR ACCESS OF PRINCIPAL CHANGES
     C*
     C     DLPCSK        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C                   KFLD                    PRDT
     C     DLPCSP        KLIST
     C                   KFLD                    DLNO
     C                   KFLD                    OTIN
     C*
     C** KEY LISTS FOR ACCESS OF DEAL ACTIVITY
     C*
     C     DLACTK        KLIST
     C                   KFLD                    ACDLNO
     C                   KFLD                    ACOTIN
     C                   KFLD                    ACPRDT
     C*
     C     DLACTP        KLIST
     C                   KFLD                    ACDLNO
     C                   KFLD                    ACOTIN
     C*
     C** INITIALIZE
     C*
     C                   Z-ADD     *ZERO         RNORE             5 0
     C/COPY WNCPYSRC,DL1955C004
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C***/C*PY*ZSRSRC,ZFWDT                                                            100317 LUC109
     C/COPY ZSRSRC,ZFWDT_ILE                                                                  LUC109
      /SPACE 5                                                            100317
     C***/C*PY*ZSRSRC,ZACCH                                                            100317 LUC109
     C/COPY ZSRSRC,ZACCHLE                                                                    LUC109
     C/COPY WNCPYSRC,DL1955C005
      /SPACE 5                                                            100317
     C**************************************************************************
     C* *PSSR      - Error Subroutine                                 *
     C*****************************************************************
     C     *PSSR         BEGSR
     C*
     C** If not yet run, then do error processing
     C*
     C     WWRUN         IFNE      'Y'
     C                   MOVEL     'Y'           WWRUN             1
      * Start MMI043
     C***********          MOVEL'DL1955'  DBPGM
     C**********         MOVEL     'GLM051'      DBPGM                                        LUC109
     C                   MOVEL     'XX000051'    DBPGM                                        LUC109
      * End MMI043
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
      * Start MMI043
     C***********          SETON                     U7U8
      * Start MMI043
     C                   DUMP
     C                   EXSR      AUDIT
     C                   END
      *
      ***  If *PSSR already run, then just end the program here.
      *
      * Start MMI043
     C***********          SETON                     U7U8LR
     C                   SETON                                        LR
      * End MMI043
     C                   RETURN
     C     PSSR9         ENDSR
     C*****************************************************************
     C/EJECT                                                              CIR005
     C***/C*PY*ZSRSRC,ZFRQB3                                                           CIR005 LUC109
     C/COPY ZSRSRC,ZFRQB3_ILE                                                                 LUC109
     C/EJECT                                                              CIR005
     C***/C*PY*ZSRSRC,ZCHKH                                                            CIR005 LUC109
     C/COPY ZSRSRC,ZCHKHLE                                                                    LUC109
     C/EJECT                                                              CIR005
     C***/C*PY*ZSRSRC,ZDATE1Z2                                                         CIR005 LUC109
     C/COPY ZSRSRC,ZDATE1Z2LE                                                                 LUC109
     C/EJECT                                                              CIR005
     C***/C*PY*ZSRSRC,ZDATE2Z2                                                         CIR005 LUC109
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 LUC109
      /SPACE 5
     ODEALSUF   E            UDEAL
     O                       UNRL
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2016
**   ZFMD  -  NUMBER OF DAYS IN THE MONTH
312831303130313130313031
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
