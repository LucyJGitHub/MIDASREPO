     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/***D ***RPG***********************************************************
/*OVRF*: OVRDBF DLPCSCRX DLPCSCPD                                     *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL IR determine deal actvty for O-L updates')    *
     F*****************************************************************
     F*                                                               *
     F*  Midas - FRA/IRS Module                                       *
     F*                                                               *
     F*  DL2901 - DETERMINE DEAL ACTIVITY FOR ON-LINE UPDATES         *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 AR743357 *CREATE   Date 06Jul17               *
      *                 AR812349           Date 23Oct12               *
      *                 AR746335           Date 17Oct12               *
      *                 CLE134             Date 01Aug12               *
      *                 CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 05Jul06               *
      *                 BUG11267           Date 04May06               *
      *                 232411             Date 31Mar05               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
     F*                 BUG6373            Date 24Mar05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180466             Date 27Jun00               *
      *                 177837             Date 22Jun99               *
      *                 CIR005             Date 21Jan00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 152469             Date 06Jan99               *
      *                 CAP003             Date 14Jul98               *
     F*                 CSW005             DATE 26JUL96               *
     F*                 105692             Date 11Jul96               *
     F*                 CIR001  *CREATE    DATE 13JUN95               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  AR743357 - Clone of DL2900 where it will use DLPCSCRX        *
      *             instead of DLPCSCPD.                              *
      *           - Applied for MD033602                              *
      *           - Added OVRF compilation parameter to enable compi- *
      *             lation even if DLPCSCRX file is missing.          *
      *           - Applied for MDSC-24664                            *
      *  AR812349 - Wrong rate being written on RF,RP and RR deals.   *
      *             Make sure that the side not in use will have 0    *
      *             rate. (Child: AR812350)                           *
      *  AR746335 - Wrong projection for cap deals.  Ensure correct   *
      *             rate is written to file (Child: AR746336)         *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CCB020 - COB Restructure - Secondary COB Infrastracture      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  BUG11267 - Back-valued IRS deals do not correctly generate   *
      *             MT362 for the current interest period.            *
      *  232411 - MT362 has missing sequence C/E. Ensure that the     *
      *           Effective Interest Rate is properly set for the     *
      *           initial period. Partially applied fix 214629.       *
      *           Part of 11267.                                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
     F*  BUG6373- Include a SETON LR so that DLOLACPD is not locked   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  180466 - Change in program DLZFRQ. Additional parameter      *
      *           ZFRZBD inserted for DLZFRQ.                         *
      *  177837 - If a rate fix advice has been produced yesterday    *
      *           (e.g., initial period advice for bacvalued deals)   *
      *           allow a new one to be produced today (if due)       *
      *           for the current period.                             *
      *           Also, update DEALSDG/Base Rate so it appears on     *
      *           MT362.                                              *
      *  CIR005 - FRA/IRS Business Day Conventions                    *
      *  CSW097 - MT340s and MT360s SWIFT97 changes                   *
      *           Here, the call DLZFRQ wil be changed to             *
      *           add two new parameters to specify settlement ccy    *
      *           and whether Rate Change Date or Interest Payment    *
      *           Date is looked for as these two have different      *
      *           holiday considerations.                             *
     F*  152469 - Incorrect CCY used causing DBERR in DLZFRQ.         *
      *  CAP003 - Conversion of inputs into modular structure to      *
      *           use as APIs.                                        *
     F*  CSW005 - MT34n and MT36n Message Generation for FRA/IRSs.   .*
     F*           Condition the rate fixing on the new rate fixing   .*
     F*           indicator.                                         .*
     F*  105692 - Output extra activity record if rate has been fixed.*
     F*  CIR001 - Interest Rate Calendars                             *
     F*                                                               *
     F*****************************************************************
     FDEALS     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     F                                     RENAME(DEALSDGF:DEALSOL)
     FDLDTSCPD  IF   E           K DISK    INFSR(*PSSR)
     F***DLPCSCPD  IF   E           K DISK    INFSR(*PSSR)                                  AR743357
     FDLPCSCRX  IF   E           K DISK    INFSR(*PSSR)                                     AR743357
     FDLCFSCPD  IF   E           K DISK    INFSR(*PSSR)
     FDLOLACPD  UF A E           K DISK    INFSR(*PSSR)
     FDLOLCFPD  UF A E           K DISK    INFSR(*PSSR)
     F/COPY WNCPYSRC,DL2900F001
      /EJECT
      *----------------------------------------------------------------
      * ID  F  C  H  L    FUNCTION OF INDICATORS
      *       11          INITIAL RATE SET IND ON
      *       90-99       STANDARD SUBROUTINES
      *       U7          DATABASE ERROR
      *----------------------------------------------------------------
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D/COPY WNCPYSRC,DL2900D001
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** External DS for BANK details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D** External DS for GENERAL LEDGER details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CSW005
     D** SAR Details Accessed via access program                          CSW005
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                BUG11267
     D** External DS for Base Rates file                                                    BUG11267
     D*                                                                   CSW005
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D*
     D**   Local data area to hold database error information
     D*
     D DBERR           DS           256
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
      *                                                                                     BUG11267
     D                 DS                                                                   BUG11267
     D  DBOPTN                 1     28                                                     BUG11267
     D  DBKEY1                10     15                                                     BUG11267
     D  DBKEY2                16     20                                                     BUG11267
      *                                                                                     BUG11267
     D PCURR           DS            30                                         CIR005
      ** Data Structure for Payment Convention Currencies                       CIR005
      *                                                                         CIR005
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
     D/COPY WNCPYSRC,DL2900D002
      *                                                                                       CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      *                                                                                       CGL029
     I**************************************************************************
      /SPACE 5
     C**************************************************************************
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** INITIAL PROCESSING
     C*
     C                   EXSR      INIT
     C*
     C** ON-LINE UPDATES
     C*
     C     PRTCD         IFNE      '*CLOSE'
     C                   MOVEL     PDLNO         DLNO
     C     DLNO          CHAIN     DEALSOL                            99        *
     C     *IN99         IFEQ      '0'
     C                   EXSR      EXTRAC
     C                   END
     C                   SETON                                        LR                     BUG6373
     C                   RETURN
     C                   END
     C*
     C** CLOSE PROGRAM
     C*
     C     PRTCD         IFEQ      '*CLOSE'
     C                   SETON                                        LR
     C                   RETURN
     C                   END
     C**************************************************************************
      /EJECT
     C********************************************************************
     C** EXTRACT LIVE SINGLE AND CROSS CURRENCY SWAPS
     C********************************************************************
     C     EXTRAC        BEGSR
     C*
     C** CLEAR DOWN ANY EXISTING DETAILS
     C** ON THE ON-LINE ACTIVITY AND CASHFLOW FILES
     C*
     C                   MOVEL     PBEAF         ACBEAF
     C                   MOVEL     PDLNO         DLNO                                          CSW00
     C***********ACBEAF    SETLLDLOLACD0                                  CSW005
     C***********ACBEAF    READEDLOLACD0                 99*              CSW005
     C     KDELET        SETLL     DLOLACD0                                                    CSW00
     C     KDELET        READE     DLOLACD0                               99                   CSW00
     C     *IN99         DOWEQ     '0'
     C                   DELETE    DLOLACD0
     C***********ACBEAF    READEDLOLACD0                 99*              CSW005
     C     KDELET        READE     DLOLACD0                               99                   CSW00
     C                   END
     C*
     C                   MOVEL     PBEAF         CFBEAF
     C                   MOVEL     PDLNO         DLNO                                          CSW00
     C***********CFBEAF    SETLLDLOLCFD0                                  CSW005
     C***********CFBEAF    READEDLOLCFD0                 99*              CSW005
     C     KDELET        SETLL     DLOLCFD0                                                    CSW00
     C     KDELET        READE     DLOLCFD0                               99                   CSW00
     C     *IN99         DOWEQ     '0'
     C                   DELETE    DLOLCFD0
     C***********CFBEAF    READEDLOLCFD0                 99*              CSW005
     C     KDELET        READE     DLOLCFD0                               99                   CSW00
     C                   END
     C*
     C/COPY WNCPYSRC,DL2900C001
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
     C                   ENDSR
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C** DEAL ACTIVITY UPDATE
     C********************************************************************
     C     DEALAC        BEGSR
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
     C**********         Z-ADD     WIACD         ACPRDT                                     BUG11267
     C                   Z-ADD     WSLIP         ACPRDT                                     BUG11267
     C                   Z-ADD     WPAMT         ACPCPL
     C*
     C** CHECK IF INITIAL RATE SET (EFFECTIVE INTEREST RATE SET
     C** FOR FIRST PERIOD OF THE IRS; I.E. STARTING FROM VALUE DATE)
     C*
     C*****WBRTT         COMP      *ZERO                                  11    *             CSD103
     C     WBRTT         COMP      *BLANKS                                11    *             CSD103
     C  N11              TESTB     '0'           WDNSI                    11    *INITIAL RATE SET IN
     C*
     C** IF INITIAL RATE SET USE EFFECTIVE INTEREST RATE
     C*
     C     *IN11         IFEQ      '1'
      *                                                                                     BUG11267
      ** If effective interest rate is still zero, rate may have been                       BUG11267
      ** fixed in I/C.  In which case, get the applicable rate.                             BUG11267
      *                                                                                     BUG11267
     C     WEINR         IFEQ      0                                                        BUG11267
     C     WRFIN         ANDEQ     'F'                                                      BUG11267
     C                   EXSR      DETRAT                                                   BUG11267
     C                   Z-ADD     WFXRT         ACEINR                                     BUG11267
     C                   Z-ADD     WFXRT         XEINR                                      AR812349
     C                   ELSE                                                               BUG11267
     C                   Z-ADD     WEINR         ACEINR
     C                   Z-ADD     WEINR         XEINR                                      AR812349
     C                   ENDIF                                                              BUG11267
      *                                                                                     BUG11267
     C                   MOVEL     'A'           ACRTTP                         * ACTUAL RATE
     C*
     C** IF INITIAL RATE NOT SET, SET FORWARD RATE TO ZERO
     C** (FOR VALUE DATE TO NEXT RATE CHANGE DATE)
     C*
     C                   ELSE
      *                                                                                     BUG11267
      ** If initial rate is not set but rate fix date is equal to                           BUG11267
      ** Rundate, get the applicable rate.                                                  BUG11267
      *                                                                                     BUG11267
     C     WINFD         IFEQ      BJRDNB                                                   BUG11267
     C                   EXSR      DETRTX                                                   BUG11267
     C                   Z-ADD     WFXRT         ACEINR                                     BUG11267
     C                   Z-ADD     WFXRT         XEINR                                      AR812349
     C                   MOVEL     'A'           ACRTTP                                     BUG11267
     C                   ELSE                                                               BUG11267
     C                   Z-ADD     *ZERO         ACEINR
     C                   Z-ADD     *ZERO         XEINR                                      AR812349
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C                   ENDIF                                                              BUG11267
      *                                                                                     BUG11267
     C                   END
     C*
     C     ACRTTP        IFEQ      'A'                                                      AR746335
     C                   EXSR      CHKRAT                                                   AR746335
     C                   ENDIF                                                              AR746335
     C                   WRITE     DLOLACD0
     C*
     C** WRITE NEXT RATE CHANGE DATE TO DEAL ACTIVITY FILE
     C*
     C*****WBRTT         IFNE      *ZERO                                                      CSD103
     C     WBRTT         IFNE      *BLANKS                                                    CSD103
     C     WNICD         ANDNE     *ZERO
     C     WNICD         ANDLT     MDAT
     C*
     C* WRITE NEXT RATE CHANGE TO DEAL ACTIVITY FILE - FROM SCHEDULE
     C*
     C     WICFR         IFEQ      'Z'
     C                   EXSR      ACRATS
     C                   ELSE
     C*
     C* WRITE NEXT RATE CHANGE TO DEAL ACTIVITY FILE - FROM FREQUENCY CODE
     C*
     C                   EXSR      ACRATF
     C                   END
     C*
     C                   END
     C*
     C** WRITE PRINCIPAL CHANGES TO DEAL ACTIVITY FILE
     C*
     C/COPY WNCPYSRC,DL2900C002
     C     WNPCD         IFNE      *ZERO
     C                   EXSR      ACPRIN
     C                   END
     C/COPY WNCPYSRC,DL2900C003
     C*
     C                   ENDSR
     C**************************************************************************
     C/SPACE 5
     C********************************************************************
     C* WRITE NEXT RATE CHANGE TO DEAL ACTIVITY FILE - FROM SCHEDULE
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
     C** DETERMINE PRINCIPAL
     C** AS AT THE NEXT RATE CHANGE DATE
     C*
     C/COPY WNCPYSRC,DL2900C004
     C     DTYP          IFEQ      'RX'
     C                   MOVEL     WOTIN         OTIN
     C                   ELSE
     C                   MOVEL     *BLANK        OTIN
     C                   END
     C*****DLPCSK        SETGT     DLPCSCPD                                                 AR743357
     C*****DLPCSP        READPE    DLPCSCPD                               99    *           AR743357
     C     DLPCSK        SETGT     DLPCSCRX                                                 AR743357
     C     DLPCSP        READPE    DLPCSCRX                               99    *           AR743357
     C  N99              Z-ADD     PAMT          WPAMT
     C/COPY WNCPYSRC,DL2900C005
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED NEXT RATE CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE & 'FORWARD' RATE = 0
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WNICD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
      *                                                                   105692
      **  If the rate has been fixed, output that rate for the next       105692
      **    rate change date. Then access the next rate on the schedule   105692
      **    and output a record with a zero rate.                         105692
      *                                                                   105692
     C                   MOVEL     '0'           *IN85                                         10569
     C     CSW005        IFNE      'Y'                                                         CSW00
     C     WOTIN         IFEQ      'U'                                                         10569
     C                   TESTB     '4'           CNFI                     85                   10569
     C                   ELSE                                                                  10569
     C                   TESTB     '5'           CNFI                     85                   10569
     C                   ENDIF                                                                 10569
     C                   ENDIF                                                                 CSW00
      *                                                                   105692
     C********** *IN85     IFEQ '1'                                 105692CSW005
      *                                                                   CSW005
      ** If CSW005 is installed, use the rate fixing indicator to check   CSW005
      **   whether the rate has been fixed or not.                        CSW005
      ** Also check if the fixed rate is for initial interest period.                       BUG11267
      ** In which case, next period should have zero rate.                                  BUG11267
      *                                                                   CSW005
     C     CSW005        IFEQ      'Y'                                                         CSW00
     C     WRFIN         ANDNE     *BLANKS                                                     CSW00
     C     WEINR         ANDNE     0                                                        BUG11267
      *                                                                         177837
      ** Or not fixed in input cycle but fixed in COB (as called by             177837
      ** DL6330 in COB)                                                         177837
     C     CSW005        OREQ      'Y'                                          177837
     C     WRFIN         ANDEQ     *BLANKS                                      177837
     C*****WPHAS         ANDNE     'A'                                                 177837 CCB020
     C     @RTPHS        ANDEQ     '*YES'                                                     CCB020
     C     *IN11         ANDEQ     '1'                                                      BUG11267
      *                                                                   CSW005
     C     CSW005        ORNE      'Y'                                                         CSW00
     C     *IN85         ANDEQ     '1'                                                         CSW00
      *                                                                   105692
     C**********         EXSR      DETRAT                                            105692 BUG11267
     C                   EXSR      DETRTX                                                   BUG11267
     C                   Z-ADD     WFXRT         ACEINR                                        10569
     C                   Z-ADD     WFXRT         XEINR                                      AR812349
     C                   MOVEL     'A'           ACRTTP                                        10569
     C                   EXSR      CHKRAT                                                   AR746335
     C                   WRITE     DLOLACD0                                                    10569
      *                                                                   105692
      **  Access the following rate change record.                        105692
      *                                                                   105692
     C                   MOVEL     WOTIN         OTIN                                          10569
     C                   MOVEL     'R'           RCIP                                          10569
     C                   Z-ADD     ACPRDT        PRDT                                          10569
     C     DLDTSK        SETGT     DLDTSCPD                                                    10569
     C     DLDTSP        READE     DLDTSCPD                               99    *              10569
      *                                                                   105692
      **  If a record exists, write an activity record.                   105692
      *                                                                   105692
     C     *IN99         IFEQ      '0'                                                         10569
      *                                                                   105692
     C                   Z-ADD     PRDT          ACPRDT                                        10569
      *                                                                   105692
     C/COPY WNCPYSRC,DL2900C006
     C*****DLPCSK        SETGT     DLPCSCPD                                           10569 AR743357
     C*****DLPCSP        READPE    DLPCSCPD                               99    *     10569 AR743357
     C     DLPCSK        SETGT     DLPCSCRX                                                 AR743357
     C     DLPCSP        READPE    DLPCSCRX                               99    *           AR743357
     C  N99              Z-ADD     PAMT          WPAMT                                         10569
     C/COPY WNCPYSRC,DL2900C007
      *                                                                   105692
     C                   Z-ADD     *ZERO         ACEINR                                        10569
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE 10569
     C                   WRITE     DLOLACD0                                                    10569
      *                                                                   105692
     C                   ENDIF                                                                 10569
      *                                                                   105692
     C                   ELSE                                                                  10569
      *                                                                   105692
     C                   Z-ADD     *ZERO         ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C                   WRITE     DLOLACD0
      *                                                                   105692
     C                   ENDIF                                                                 10569
     C*
     C     EACRTS        ENDSR
     C**************************************************************************
     C/SPACE 5
     C********************************************************************
     C* WRITE RATE CHANGES TO DEAL ACTIVITY FILE - FROM FREQUENCY CODE
     C********************************************************************
     C     ACRATF        BEGSR
     C*
     C** DETERMINE PRINCIPAL
     C** AS AT THE NEXT CURRENT RATE CHANGE DATE
     C*
     C/COPY WNCPYSRC,DL2900C008
     C     DTYP          IFEQ      'RX'
     C                   MOVEL     WOTIN         OTIN
     C                   ELSE
     C                   MOVEL     *BLANK        OTIN
     C                   END
     C                   Z-ADD     WNICD         PRDT
     C*****DLPCSK        SETGT     DLPCSCPD                                                 AR743357
     C*****DLPCSP        READPE    DLPCSCPD                               99    *           AR743357
     C     DLPCSK        SETGT     DLPCSCRX                                                 AR743357
     C     DLPCSP        READPE    DLPCSCRX                               99    *           AR743357
     C  N99              Z-ADD     PAMT          WPAMT
     C/COPY WNCPYSRC,DL2900C009
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED NEXT RATE CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE & 'FORWARD' RATE = 0
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVEL     WOTIN         ACOTIN
     C                   Z-ADD     WNICD         ACPRDT
     C                   Z-ADD     WPAMT         ACPCPL
      *                                                                   105692
      **  If the rate has been fixed, output that rate for the next       105692
      **    rate change date. Then calculate the next rate change date    105692
      **    and output a record with a zero rate.                         105692
      *                                                                   105692
     C                   MOVEL     '0'           *IN85                                         10569
     C     CSW005        IFNE      'Y'                                                         CSW00
     C     WOTIN         IFEQ      'U'                                                         10569
     C                   TESTB     '4'           CNFI                     85                   10569
     C                   ELSE                                                                  10569
     C                   TESTB     '5'           CNFI                     85                   10569
     C                   ENDIF                                                                 10569
     C                   ENDIF                                                                 CSW00
      *                                                                   105692
     C********** *IN85     IFEQ '1'                                 105692CSW005
      *                                                                   CSW005
      ** If CSW005 is installed, use the rate fixing indicator to check   CSW005
      **   whether the rate has been fixed or not.                        CSW005
      ** Also check if the fixed rate is for initial interest period.                       BUG11267
      ** In which case, next period should have zero rate.                                  BUG11267
      *                                                                   CSW005
     C     CSW005        IFEQ      'Y'                                                         CSW00
     C     WRFIN         ANDNE     *BLANKS                                                     CSW00
     C     WEINR         ANDNE     0                                                        BUG11267
      *                                                                         177837
      ** Or not fixed in input cycle but fixed in COB (as called by             177837
      ** DL6330 in COB)                                                         177837
     C     CSW005        OREQ      'Y'                                          177837
     C     WRFIN         ANDEQ     *BLANKS                                      177837
     C*****WPHAS         ANDNE     'A'                                                 177837 CCB020
     C     @RTPHS        ANDEQ     '*YES'                                                     CCB020
     C     *IN11         ANDEQ     '1'                                                      BUG11267
      *                                                                   CSW005
     C     CSW005        ORNE      'Y'                                                         CSW00
     C     *IN85         ANDEQ     '1'                                                         CSW00
      *                                                                   CSW005
     C**********         EXSR      DETRAT                                            105692 BUG11267
     C                   EXSR      DETRTX                                                   BUG11267
     C                   Z-ADD     WFXRT         ACEINR                                        10569
     C                   Z-ADD     WFXRT         XEINR                                      AR812349
     C                   MOVEL     'A'           ACRTTP                                        10569
     C                   EXSR      CHKRAT                                                   AR746335
     C                   WRITE     DLOLACD0                                                    10569
      *                                                                   105692
      **  Calculate the next rate change date.                            105692
      *                                                                   105692
     C                   Z-ADD     WNICD         ZFRDAT                                        10569
     C                   MOVEL     WICFR         ZFRFRQ                                        10569
     C                   Z-ADD     WICFD         ZFRBAS                                        10569
     C                   Z-ADD     WSETM         ZFRSET                                        10569
     C*****              MOVEL     WCUCY         ZFRCCY                         CSW097         10569
     C                   MOVEL     WDCCY         ZFRCCY                         CSW097
     C                   MOVEL     WSTCY         ZSTCY                          CSW097
     C                   MOVEL     'R'           ZRCIP                          CSW097
     C                   MOVEL     WSACC         ZFRNOS                                        10569
     C                   Z-ADD     MDAT          ZFRMDT                                        10569
     C                   EXSR      DETNXD                                                      10569
     C                   Z-ADD     ZFRNXD        ACPRDT                                        10569
      *                                                                   105692
      **  If a record exists, write an activity record.                   105692
      *                                                                   105692
     C     ACPRDT        IFLT      MDAT                                                        10569
      *                                                                   105692
     C                   Z-ADD     ACPRDT        PRDT                                          10569
     C/COPY WNCPYSRC,DL2900C012
     C*****DLPCSK        SETGT     DLPCSCPD                                           10569 AR743357
     C*****DLPCSP        READPE    DLPCSCPD                               99    *     10569 AR743357
     C     DLPCSK        SETGT     DLPCSCRX                                                 AR743357
     C     DLPCSP        READPE    DLPCSCRX                               99    *           AR743357
     C  N99              Z-ADD     PAMT          WPAMT                                         10569
     C/COPY WNCPYSRC,DL2900C013
      *                                                                   105692
     C                   Z-ADD     *ZERO         ACEINR                                        10569
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE 10569
     C                   WRITE     DLOLACD0                                                    10569
      *                                                                   105692
     C                   ENDIF                                                                 10569
      *                                                                   105692
     C                   ELSE                                                                  10569
      *                                                                   105692
     C                   Z-ADD     *ZERO         ACEINR
     C                   MOVEL     'F'           ACRTTP                         * FORWARD RATE
     C                   WRITE     DLOLACD0
      *                                                                   105692
     C                   ENDIF                                                                 10569
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
     C*****DLPCSK        CHAIN     DLPCSCPD                           99        *           AR743357
     C     DLPCSK        CHAIN     DLPCSCRX                           99        *           AR743357
     C*
     C** DO WHILE PRINCIPAL CHANGES FOUND
     C*
     C     *IN99         DOWEQ     '0'
     C     PRDT          ANDLE     WENDD
     C*
     C** ONLY ADD TO DEAL ACTIVITY FILE IF DATE NOT REPRESENTED
     C*
     C                   Z-ADD     DLNO          ACDLNO
     C                   MOVE      WOTIN         ACOTIN
     C                   Z-ADD     PRDT          ACPRDT
     C     DLOLAK        CHAIN     DLOLACD0                           99        *
     C     *IN99         IFEQ      '1'
     C*
     C** DETERMINE RATE AS AT PRINCIPAL CHANGE DATE FROM
     C** DEAL ACTIVITY FILE
     C*
     C     DLOLAK        SETLL     DLOLACD0
     C     DLOLAP        READPE    DLOLACD0                               99    *
     C*
     C** WRITE RECORD TO DEAL ACTIVITY FILE DATED PRINCIPAL CHANGE DATE
     C** WITH PRINCIPAL = PRINCIPAL AS AT THIS DATE
     C** & RATE = RATE TAKEN FROM DEAL ACTIVITY FILE
     C*
     C                   Z-ADD     PRDT          ACPRDT
     C                   Z-ADD     PAMT          ACPCPL
     C                   EXSR      CHKRAT                                                   AR746335
     C                   WRITE     DLOLACD0
     C                   END
     C*
     C** GET NEXT PRINCIPAL CHANGE DATE
     C*
     C*****DLPCSP        READE     DLPCSCPD                               99    *           AR743357
     C     DLPCSP        READE     DLPCSCRX                               99    *           AR743357
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
     C/COPY WNCPYSRC,DL2900C010
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
     C     PRDT          ANDLE     WENDD
     C*
     C** WRITE OUT CASH FLOW EVENT FOR DEFINED CASHFLOW
     C*
     C                   Z-ADD     PRDT          CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     CFLA          CFAMNT                         * CASH FLOW AMT
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
     C** WRITE OUT CASH FLOW EVENT FOR VALUE DATE
     C** IF VALUE DATE = LAST INTEREST PAYMENT DATE
     C*
     C     VDAT          IFEQ      WSLIP
     C     VDAT          ANDLE     WENDD
     C                   Z-ADD     VDAT          CFPYDT
     C                   Z-ADD     WNIPD         CFNIPD
     C                   Z-ADD     VDAT          CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
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
     C     WSLIP         ANDLE     WENDD
     C*
     C** WRITE OUT CASH FLOW EVENT FOR LAST INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WSLIP         CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   EXSR      WRTCFE
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C** TO THIS CURRENT PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          WSLIP
     C*
     C** GET NEXT INTEREST PAYMENT DATE
     C*
     C     DLDTSP        READE     DLDTSCPD                               99    *
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR LAST INTEREST PAYMENT DATE
     C*
     C     WSLIP         IFGT      VDAT
     C     WSLIP         ANDLT     MDAT
     C     WSLIP         ANDLE     WENDD
     C                   Z-ADD     WSLIP         CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
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
     C     PRDT          ANDLE     WENDD
     C*
     C** WRITE OUT CASH FLOW EVENT FOR NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     PRDT          CFPYDT
     C                   Z-ADD     PRDT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
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
     C     MDAT          ANDLE     WENDD
     C                   Z-ADD     MDAT          CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
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
     C*****              MOVEL     WCUCY         ZFRCCY                         CSW097
     C                   MOVEL     WDCCY         ZFRCCY                         CSW097
     C                   MOVEL     WSTCY         ZSTCY                          CSW097
     C                   MOVEL     'P'           ZRCIP                          CSW097
     C                   MOVEL     WSACC         ZFRNOS
     C                   Z-ADD     MDAT          ZFRMDT
     C*
     C** DO WHILE MATURITY DATE NOT REACHED
     C*
     C     WNIPD         DOWLT     MDAT
     C     WNIPD         ANDLE     WENDD
     C*
     C** WRITE OUT CASH FLOW EVENT FOR NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         CFPYDT
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     WAMCN         ANDEQ     'A'                                          CIR005
     C     WCYP1         ANDNE     *BLANK                                       CIR005
     C                   Z-ADD     WIPBD         CFNIPD                         CIR005
     C                   ELSE                                                   CIR005
     C                   Z-ADD     WNIPD         CFNIPD
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   EXSR      WRTCFE
     C*
     C** UPDATE LAST INTEREST PAYMENT DATE
     C*
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     WAMCN         ANDEQ     'A'                                          CIR005
     C     WCYP1         ANDNE     *BLANK                                       CIR005
     C                   Z-ADD     WIPBD         WSLIP                          CIR005
     C                   ELSE                                                   CIR005
     C                   Z-ADD     WNIPD         WSLIP
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C*
     C** DETERMINE NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     WNIPD         ZFRDAT
     C                   EXSR      DETNXD
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     WCYP1         ANDNE     *BLANKS                                      CIR005
     C     WIPBD         ANDGT     ZFRMDT                                       CIR005
     C                   Z-ADD     ZFRMDT        ZFRNXD                         CIR005
     C                   Z-ADD     ZFRMDT        WIPBD                          CIR005
     C                   ENDIF                                                  CIR005
     C*
     C** UPDATE NEXT INTEREST PAYMENT DATE
     C*
     C                   Z-ADD     ZFRNXD        WNIPD
     C                   END
     C*
     C** WRITE OUT CASH FLOW EVENT FOR MATURITY DATE
     C*
     C     MDAT          IFLE      WENDD
     C                   Z-ADD     MDAT          CFPYDT
     C                   Z-ADD     MDAT          CFNIPD
     C                   Z-ADD     WSLIP         CFSLIP
     C                   Z-ADD     0             CFAMNT                         * CASH FLOW AMT
     C                   EXSR      WRTCFE
     C                   END
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* WRITE OUT CASH FLOW EVENTS
     C********************************************************************
     C     WRTCFE        BEGSR
     C*
     C                   Z-ADD     DLNO          CFDLNO                         * DEAL NUMBER
     C                   MOVEL     WOTIN         CFOTIN                         * OUR/THEIR
     C                   MOVEL     WCUCY         CFCCY                          * DEAL CCY
     C                   MOVEL     WICBS         CFINCL                         * INT.CAL.BASIS
     C                   MOVEL     WINPM         CFINPM                         * INT PROC.METH.
     C                   WRITE     DLOLCFD0
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* MOVE 'OUR' DETAILS TO WORK FIELDS
     C********************************************************************
     C     OUR           BEGSR
     C*
      ** If 'Our Settlement Currency' set up use that to chain to               CAP003
      ** Nostro file, else use Deal Currency.                                   CAP003
     C                                                                          CAP003
     C     PSCY          IFNE      *BLANKS                                      CAP003
     C                   MOVE      PSCY          WCUCY                          CAP003
     C                   ELSE                                                   CAP003
     C                   MOVE      UCUCY         WCUCY             3
     C                   END                                                    CAP003
      *                                                                         CSW097
     C                   MOVE      UCUCY         WDCCY             3            CSW097
     C                   MOVE      PSCY          WSTCY             3            CSW097
      *
     C                   Z-ADD     UPAMT         WPAMT            13 0
     C**********         Z-ADD     UBRTT         WBRTT             2 0                        CSD103
     C                   MOVE      UBRTT         WBRTT             2                          CSD103
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
     C**********         MOVE      UPACC         WSACC            12                          CGL029
     C                   MOVE      UPACC         WSACC            18                          CGL029
     C                   MOVE      UINPM         WINPM             1
     C                   MOVE      UNPCD         WNPCD             5 0
     C                   MOVE      'U'           WOTIN             1
     C                   MOVEL     URFIN         WRFIN             1                           10569
      *                                                                         CIR005
      ** Save Business Day Convention Details                                   CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C                   MOVEL     L1PDCN        WPDCN             2            CIR005
     C                   MOVEL     L1AMCN        WAMCN             2            CIR005
     C                   MOVEL     L1CYP1        WCYP1                          CIR005
     C                   MOVEL     L1CYP2        WCYP2                          CIR005
     C                   MOVEL     L1CYP3        WCYP3                          CIR005
     C                   MOVEL     L1CYP4        WCYP4                          CIR005
     C                   MOVEL     L1CYP5        WCYP5                          CIR005
     C                   MOVEL     L1CYP6        WCYP6                          CIR005
     C                   MOVEL     L1CYP7        WCYP7                          CIR005
     C                   MOVEL     L1CYP8        WCYP8                          CIR005
     C                   MOVEL     L1CYP9        WCYP9                          CIR005
     C                   MOVEL     L1CYP0        WCYP0                          CIR005
     C                   ENDIF                                                  CIR005
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* MOVE 'THEIR' DETAILS TO WORK FIELDS
     C********************************************************************
     C     THEIR         BEGSR
     C*
      ** If 'Their Settlement Currency' set up use that to chain to            CAP003
      ** Nostro file, else use Deal Currency.                                  CAP003
     C*                                                                        CAP003
     C     RSCY          IFNE      *BLANKS                                     CAP003
     C****************** MOVE      PSCY          WCUCY                  CAP003 152469
     C                   MOVE      RSCY          WCUCY                         152469
     C                   ELSE                                                  CAP003
     C                   MOVE      TCUCY         WCUCY             3
     C                   END                                                   CAP003
      *                                                                         CSW097
     C                   MOVE      TCUCY         WDCCY             3            CSW097
     C                   MOVE      RSCY          WSTCY             3            CSW097
      *
     C                   Z-ADD     TPAMT         WPAMT            13 0
     C**********         Z-ADD     TBRTT         WBRTT             2 0                        CSD103
     C                   MOVE      TBRTT         WBRTT             2                          CSD103
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
     C**********         MOVE      URACC         WSACC            12                          CGL029
     C                   MOVE      URACC         WSACC            18                          CGL029
     C                   MOVE      TINPM         WINPM             1
     C     DTYP          IFEQ      'RX'
     C                   MOVE      TNPCD         WNPCD             5 0
     C                   ELSE
     C                   MOVE      UNPCD         WNPCD             5 0
     C                   END
     C                   MOVE      'T'           WOTIN             1
     C                   MOVEL     TRFIN         WRFIN                                         10569
      *                                                                         CIR005
      ** Save Business Day Convention Details                                   CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     DTYP          IFEQ      'RX'                                         CIR005
     C                   MOVEL     L2PDCN        WPDCN                          CIR005
     C                   MOVEL     L2AMCN        WAMCN                          CIR005
     C                   MOVEL     L2CYP1        WCYP1                          CIR005
     C                   MOVEL     L2CYP2        WCYP2                          CIR005
     C                   MOVEL     L2CYP3        WCYP3                          CIR005
     C                   MOVEL     L2CYP4        WCYP4                          CIR005
     C                   MOVEL     L2CYP5        WCYP5                          CIR005
     C                   MOVEL     L2CYP6        WCYP6                          CIR005
     C                   MOVEL     L2CYP7        WCYP7                          CIR005
     C                   MOVEL     L2CYP8        WCYP8                          CIR005
     C                   MOVEL     L2CYP9        WCYP9                          CIR005
     C                   MOVEL     L2CYP0        WCYP0                          CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     L1PDCN        WPDCN                          CIR005
     C                   MOVEL     L1AMCN        WAMCN                          CIR005
     C                   MOVEL     L1CYP1        WCYP1                          CIR005
     C                   MOVEL     L1CYP2        WCYP2                          CIR005
     C                   MOVEL     L1CYP3        WCYP3                          CIR005
     C                   MOVEL     L1CYP4        WCYP4                          CIR005
     C                   MOVEL     L1CYP5        WCYP5                          CIR005
     C                   MOVEL     L1CYP6        WCYP6                          CIR005
     C                   MOVEL     L1CYP7        WCYP7                          CIR005
     C                   MOVEL     L1CYP8        WCYP8                          CIR005
     C                   MOVEL     L1CYP9        WCYP9                          CIR005
     C                   MOVEL     L1CYP0        WCYP0                          CIR005
     C                   ENDIF                                                  CIR005
     C                   ENDIF                                                  CIR005
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5
     C********************************************************************
     C* DETERMINE NEXT DAY
     C********************************************************************
     C     DETNXD        BEGSR
      *                                                                         CIR005
      ** Determine Next Rate Change Date for Business Day Conventions           CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     WCYP1         ANDNE     *BLANK                                       CIR005
      *                                                                         CIR005
     C     ZFRFRQ        IFEQ      *BLANK                                       CIR005
     C                   Z-ADD     ZFRMDT        ZFRNXD                         CIR005
     C                   Z-ADD     ZFRMDT        WIPBD                          CIR005
     C                   ELSE                                                   CIR005
     C                   MOVE      ZFRFRQ        ZFREQ                          CIR005
     C                   Z-ADD     ZFRDAT        ZDAYNO                         CIR005
     C                   Z-ADD     ZFRBAS        ZMDAY                          CIR005
      *                                                                         CIR005
      ** Increment day number by a period value                                 CIR005
      *                                                                         CIR005
     C                   CALLB     'ZFRQB3'                                     CIR005
     C                   PARM                    ZFREQ             1            CIR005
     C                   PARM                    ZDAYNO            5 0          CIR005
     C                   PARM                    ZMDAY             2 0          CIR005
     C                   PARM                    ZCCY              3            CIR005
     C                   PARM                    BJSLCD                         CIR005
     C                   PARM                    ZERR              7            CIR005
      *                                                                         CIR005
      ** Adjust date according to payment date convention currencies            CIR005
      *                                                                         CIR005
     C                   CALL      'DLZIRP'                                     CIR005
     C                   PARM                    ZDAYNO                         CIR005
     C                   PARM                    PCURR                          CIR005
     C                   PARM      WPDCN         PPDCN             2            CIR005
     C                   PARM                    BJSLCD                         CIR005
     C                   PARM                    BJDFIN                         CIR005
     C                   PARM                    PAJDT             5 0          CIR005
     C                   PARM                    PBSDT             5 0          CIR005
      *                                                                         CIR005
     C     PAJDT         IFGE      ZFRMDT                                       CIR005
     C                   Z-ADD     ZFRMDT        ZFRNXD                         CIR005
     C                   Z-ADD     ZFRMDT        WIPBD                          CIR005
     C                   ELSE                                                   CIR005
     C                   Z-ADD     PAJDT         ZFRNXD                         CIR005
     C                   Z-ADD     PBSDT         WIPBD                          CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** Do not return adjusted date if it is equal to or earlier than          CIR005
      ** previous date (only happens for 'previous' date calculations);         CIR005
      ** instead use the base date                                              CIR005
      *                                                                         CIR005
     C     ZFRDAT        IFGE      ZFRNXD                                       CIR005
     C                   Z-ADD     WIPBD         ZFRNXD                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   ELSE                                                   CIR005
     C*
     C                   CALL      'DLZFRQ'
     C                   PARM      *BLANK        ZFRRTC            5
     C                   PARM                    ZFRDAT            5 0          * DATE
     C                   PARM                    ZFRFRQ            1            * FREQUENCY
     C                   PARM                    ZFRBAS            2 0          * BASE DAY
     C                   PARM                    ZFRSET            2 0          * SETT.METH.
     C                   PARM                    ZFRCCY            3            * CURRENCY
     C                   PARM                    ZSTCY             3            CSW097
     C                   PARM                    ZRCIP             1            CSW097
     C                   PARM                    ZFRNOS            2            * NOSTRO
     C                   PARM                    ZFRMDT            5 0          * MAT.DATE
     C                   PARM                    BKAPDT            5 0
     C                   PARM                    BJSLCD            3
     C                   PARM                    BJLCCY            3
     C                   PARM      *ZERO         ZFRZBD            5 0          180466
     C                   PARM      *ZERO         ZFRNXD            5 0          * NEXT DATE
     C     ZFRRTC        IFEQ      '*ERR*'
     C                   EXSR      *PSSR
     C                   END
      *                                                                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   ENDSR
     C**************************************************************************
      /SPACE 5                                                            105692
     C********************************************************************105692
     C* DETERMINE NEXT RATE                                               105692
     C********************************************************************105692
     C     DETRAT        BEGSR                                                                 10569
      *                                                                   105692
      ** Take into account the spread when calculating new rate.          105692
      *                                                                   105692
     C                   Z-ADD     WBRTE         WFXRT                                         10569
     C                   SELECT                                                                10569
     C     WSPIN         WHENEQ    'A'                                                         10569
     C     WBRTE         ADD       WRTSP         WFXRT                                         10569
     C     WSPIN         WHENEQ    'S'                                                         10569
     C     WBRTE         SUB       WRTSP         WFXRT                                         10569
     C     WSPIN         WHENEQ    'P'                                                         10569
     C     WBRTE         DIV(H)    100           WWK01            13 9                         10569
     C     WWK01         MULT(H)   WRTSP         WWK01                                         10569
     C     WBRTE         ADD       WWK01         WFXRT            11 7                         10569
     C                   ENDSL                                                                 10569
     C*                                                                   105692
     C                   ENDSR                                                                 10569
     C**************************************************************************
      /SPACE 5                                                                              BUG11267
      *****************************************************************                     BUG11267
      *                                                               *                     BUG11267
      * SR/DERTX - Determine Interest Rate from Base Rates file.      *                     BUG11267
      *                                                               *                     BUG11267
      *****************************************************************                     BUG11267
      *                                                                                     BUG11267
     C     DETRTX        BEGSR                                                              BUG11267
      *                                                                                     BUG11267
      ** Convert Numeric Base Rate Code to alpha                                            BUG11267
      *                                                                                     BUG11267
     C                   MOVEL     WBRTT         @DWNB                                      BUG11267
      *                                                                                     BUG11267
      ** Access Base Rates details via Access Program                                       BUG11267
      *                                                                                     BUG11267
     C                   CALL      'AOBSRTR0'                                               BUG11267
     C                   PARM      '*MSG   '     @RTCD             7                        BUG11267
     C                   PARM      '*KEY   '     @OPTN             7                        BUG11267
     C                   PARM      WDCCY         @AJCD             3                        BUG11267
     C                   PARM                    @DWNB             2                        BUG11267
     C     SDBSRT        PARM      SDBSRT        DSFDY                                      BUG11267
     C     @RTCD         IFNE      *BLANKS                                                  BUG11267
     C                   MOVEL     'SDBSRTPD'    DBFILE                                     BUG11267
     C                   MOVEL     '005'         DBASE                                      BUG11267
     C                   MOVE      *BLANKS       DBOPTN                                     BUG11267
     C                   MOVEL     @OPTN         DBOPTN                                     BUG11267
     C                   MOVEL     @AJCD         DBKEY1                                     BUG11267
     C                   MOVEL     @DWNB         DBKEY2                                     BUG11267
     C                   MOVEL     DBOPTN        DBKEY                                      BUG11267
     C                   EXSR      *PSSR                                                    BUG11267
     C                   END                                                                BUG11267
      *                                                                                     BUG11267
     C     WINFD         IFGE      BAVDNR                                                   BUG11267
     C                   Z-ADD     BANBRT        WFXRT                                      BUG11267
     C                   ELSE                                                               BUG11267
     C                   Z-ADD     BACBSR        WFXRT                                      BUG11267
     C                   ENDIF                                                              BUG11267
      *                                                                                     BUG11267
     C                   SELECT                                                             BUG11267
     C     WSPIN         WHENEQ    'A'                                                      BUG11267
     C     WBRTE         ADD       WRTSP         WFXRT                                      BUG11267
     C     WSPIN         WHENEQ    'S'                                                      BUG11267
     C     WBRTE         SUB       WRTSP         WFXRT                                      BUG11267
     C     WSPIN         WHENEQ    'P'                                                      BUG11267
     C     WBRTE         DIV(H)    100           WWK01            13 9                      BUG11267
     C     WWK01         MULT(H)   WRTSP         WWK01                                      BUG11267
     C     WBRTE         ADD       WWK01         WFXRT            11 7                      BUG11267
     C                   ENDSL                                                              BUG11267
      *                                                                                     BUG11267
     C                   ENDSR                                                              BUG11267
      *                                                                                     BUG11267
      *****************************************************************                     BUG11267
      /SPACE 5
     C********************************************************************
     C* INITIAL PROCESSING
     C********************************************************************
     C     INIT          BEGSR
      *
      ***  Receive Parameter List:
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD             7
     C                   PARM                    PDLNO             6
     C                   PARM                    PBEAF             1
      *                                                                         177837
     C******DTAARA       DEFINE    MPHAS         @PHAS             1                   177837 CCB020
     C******LOCK         IN        @PHAS                                               177837 CCB020
     C*********          MOVEL     @PHAS         WPHAS             1                   177837 CCB020
     C*********          OUT       @PHAS                                               177837 CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM      *BLANKS       @RTPHS            4                          CCB020
      *
      ** CALL ACCESS PROGRAM FOR BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE                          *************
     C                   MOVEL     '001'         DBASE                           *DBERROR 001*
     C                   MOVEL     @OPTN         DBKEY                           *************
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,DL2900C011
      *
      **  Set Date Format Indicator
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      '1'           *IN98
     C                   END
      *
      ** CALL ACCESS PROGRAM FOR GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDGELRPD'    DBFILE                          *************
     C                   MOVEL     '002'         DBASE                           *DBERROR 002*
     C                   MOVEL     @OPTN         DBKEY                           *************
     C                   EXSR      *PSSR
     C                   END
      *                                                                   CSW005
      ** Access AO/AOSARDR0 to determine if Compounding of Interest       CSW005
      **   required.                                                      CSW005
      *                                                                   CSW005
     C                   CALLB     'AOSARDR0'                                                  CSW00
     C                   PARM      *BLANKS       @RTCD                                         CSW00
     C                   PARM      '*VERIFY'     @OPTN                                         CSW00
     C                   PARM      'CSW005'      @SARD             6                           CSW00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSW00
      *                                                                   CSW005
     C     @RTCD         IFNE      *BLANKS                                                     CSW00
     C     @RTCD         ANDNE     '*NRF   '                                                   CSW00
     C                   MOVEL     'SCSARDPD'    DBFILE                          ************* CSW00
     C                   MOVEL     '003'         DBASE                           *DBERROR 003* CSW00
     C                   MOVEL     @OPTN         DBKEY                           ************* CSW00
     C                   EXSR      *PSSR                                                       CSW00
     C                   END                                                                   CSW00
      *                                                                   CSW005
     C     @RTCD         IFEQ      *BLANKS                                                     CSW00
     C                   MOVEL     'Y'           CSW005            1                           CSW00
     C                   ELSE                                                                  CSW00
     C                   MOVEL     'N'           CSW005                                        CSW00
     C                   END                                                                   CSW00
      *                                                                         CIR005
      ** Check if switchable feature CIR005 is switched on                      CIR005
      *                                                                         CIR005
     C                   CALLB     'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
     C     @RTCD         IFNE      *BLANK                                       CIR005
     C     @RTCD         ANDNE     '*NRF   '                                    CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   MOVEL     '004'         DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C     @RTCD         IFEQ      *BLANKS                                      CIR005
     C                   MOVE      'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVE      'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
     C*
     C** SET UP VARIABLES USED IN FREQUENCY CALCULATION TO GET END DATE
     C**   OF ONE YEAR FROM RUN DATE FOR CASH FLOW OUTPUTS.
     C*
     C                   MOVEL     'Y'           ZFRFRQ
     C                   Z-ADD     31            ZFRBAS
     C                   Z-ADD     0             ZFRSET
     C                   MOVEL     BJLCCY        ZFRCCY
     C                   MOVEL     *BLANKS       ZFRNOS
     C                   Z-ADD     99999         ZFRMDT
     C                   Z-ADD     BJRDNB        ZFRDAT
     C                   MOVEL     'R'           ZRCIP                          CSW097
     C                   EXSR      DETNXD
     C                   Z-ADD     ZFRNXD        WENDD             5 0
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
     C     DLOLAK        KLIST
     C                   KFLD                    ACBEAF
     C                   KFLD                    ACDLNO
     C                   KFLD                    ACOTIN
     C                   KFLD                    ACPRDT
     C*
     C     DLOLAP        KLIST
     C                   KFLD                    ACBEAF
     C                   KFLD                    ACDLNO
     C                   KFLD                    ACOTIN
     C*                                                                   CSW005
     C     KDELET        KLIST                                                                 CSW00
     C                   KFLD                    PBEAF                                         CSW00
     C                   KFLD                    DLNO                                          CSW00
      *
     C     *LIKE         DEFINE    ACEINR        XEINR                                      AR812349
     C*
     C                   ENDSR
     C**************************************************************************
      /SPACE 5                                                                              AR746335
      *****************************************************************                     AR746335
      * CHKRAT     - Check rate                                       *                     AR746335
      *****************************************************************                     AR746335
     C     CHKRAT        BEGSR                                                              AR746335
     C     DTYP          IFEQ      'RR'                                                     AR746335
     C     DTYP          OREQ      'RP'                                                     AR746335
     C     DTYP          OREQ      'RF'                                                     AR746335
     C                   SELECT                                                             AR746335
      *                                                                                     AR746335
     C     DTYP          WHENEQ    'RP'                                                     AR746335
     C*****ACEINR        IFGT      CLRAT                                           AR746335 AR812349
     C**********         SUB       CLRAT         ACEINR                            AR746335 AR812349
     C     XEINR         IFGT      CLRAT                                                    AR812349
     C     XEINR         ANDNE     0                                                        AR812349
     C     XEINR         SUB       CLRAT         ACEINR                                     AR812349
     C                   ELSE                                                               AR746335
     C                   Z-ADD     *ZERO         ACEINR                                     AR746335
     C                   ENDIF                                                              AR746335
      *                                                                                     AR746335
     C     DTYP          WHENEQ    'RF'                                                     AR746335
     C*****ACEINR        IFLT      FLRAT                                           AR746335 AR812349
     C*****FLRAT         SUB       ACEINR        ACEINR                            AR746335 AR812349
     C     XEINR         IFLT      FLRAT                                                    AR812349
     C     XEINR         ANDNE     0                                                        AR812349
     C     FLRAT         SUB       XEINR         ACEINR                                     AR812349
     C                   ELSE                                                               AR746335
     C                   Z-ADD     *ZERO         ACEINR                                     AR746335
     C                   ENDIF                                                              AR746335
      *                                                                                     AR746335
     C     DTYP          WHENEQ    'RR'                                                     AR746335
     C*****ACEINR        IFGT      CLRAT                                           AR746335 AR812349
     C*****ACEINR        ORLT      FLRAT                                           AR746335 AR812349
     C     XEINR         IFGT      CLRAT                                                    AR812349
     C     XEINR         ANDNE     0                                                        AR812349
     C     XEINR         ORLT      FLRAT                                                    AR812349
     C     XEINR         ANDNE     0                                                        AR812349
     C*****ACEINR        IFGT      CLRAT                                           AR746335 AR812349
     C**********         SUB       CLRAT         ACEINR                            AR746335 AR812349
     C     XEINR         IFGT      CLRAT                                                    AR812349
     C     XEINR         SUB       CLRAT         ACEINR                                     AR812349
     C                   ELSE                                                               AR746335
     C*****FLRAT         SUB       ACEINR        ACEINR                            AR746335 AR812349
     C     FLRAT         SUB       XEINR         ACEINR                                     AR812349
     C                   ENDIF                                                              AR746335
     C                   ELSE                                                               AR746335
     C                   Z-ADD     *ZERO         ACEINR                                     AR746335
     C                   ENDIF                                                              AR746335
     C                   ENDSL                                                              AR746335
     C                   ENDIF                                                              AR746335
      *                                                                                     AR746335
     C                   ENDSR                                                              AR746335
      *****************************************************************                     AR746335
      /SPACE 5
     C**************************************************************************
     C* *PSSR      - Error Subroutine                                 *
     C*****************************************************************
     C     *PSSR         BEGSR
     C*
     C** If not yet run, then do error processing
     C*
     C     WWRUN         IFNE      'Y'
     C                   MOVEL     'Y'           WWRUN             1
     C                   MOVEL     'DL2900'      DBPGM
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVEL     DBERR         @LDA
     C                   OUT       @LDA
     C                   SETON                                        U7U8
     C                   MOVEL     '*ERROR'      PRTCD
     C                   DUMP
     C                   END
      *
      ***  If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
     C     PSSR9         ENDSR
     C*****************************************************************
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2001
