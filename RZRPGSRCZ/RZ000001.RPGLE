     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*S*D ***RPGBASEBND****************************************************                       M14UPG
/*STD *  RZBASEBND                                                    *                       M14UPG
/*EXI *  TEXT('Midas RZ Extract A/C Codes by Transaction Type')       *
      *****************************************************************
      *                                                               *
      *  Midas - RZ Developments                                      *
      *                                                               *
      *  RZ000001 - Midas RZ Extract A/C Codes by Transaction Type    *
      *                                                               *
      *  Function:  This program reads through the account key files  *
      *             ACKEYAL and SEACKD. For keys which meet the       *
      *             selection criteria either the DR or CR account    *
      *             codes are checked against corresponding account   *
      *             section. Where more than one account code exists, *
      *             the one with the matching account section is      *
      *             extracted. If none match, the first account code  *
      *             is extracted.                                     *
      *             For LE/MM/FX/FRA/IRS the Deal type and sub-type   *
      *             are also extracted.                               *
      *             For SE, the Investment type and trade type are    *
      *             also extracted.                                   *
      *                                                               *
      *  Called By: RZC000001 - Extract A/C Codes by Transaction Type *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. M14UPG             Date 29Jan13               *
      *  Prev Amend No. ERZ054A            Date 29Jan13               *
      *                 ERZ054   *CREATE   Date 29Jan13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  M14UPG - Upgrade to MidasPlus 1.4                            *
      *  ERZ054A - If LE asset value date key has no account codes,   *
      *            try corresponding deal date key.                   *
      *  ERZ054 - RZB Data Warehouse Extraction Requirements          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    50         General Purpose Indicator for DOW** loops       *
      *    60         Lookup PSoldAr                                  *
      *    61         Lookup MMAssetAr                                *
      *    62         Lookup MMLiablAr                                *
      *    63         Lookup AcodAr                                   *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * ACCKEY   -  Process records on ACKEYAL                        *
      * SEACK    -  Process records on SEACKD                         *
      * AKEYOUT  -  Output Account Key details to RZACTRPP            *
      * *INZSR   -  Program initialisation routine                    *
      * *PSSR    -  Exception error processing                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Account Keys for DL/FT/LE
     FACKEYAL   IF   E           K DISK    INFSR(*PSSR)
                                                                                             ERZ054A
      ** Account Keys for                                                                    ERZ054A
     FACKEY     IF   E           K DISK    IGNORE(ACKEYAKF)                                  ERZ054A
     F                                     RENAME(ACKEYALF:ACKEYF)                           ERZ054A
     F                                     INFSR(*PSSR)                                      ERZ054A
 
      ** Account Keys for SE
     FSEACKD    IF   E           K DISK    INFSR(*PSSR)
 
      ** Account Codes
     FSDACODL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Loan Types
     FSDLOANL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Account Codes by Transaction Type
     FRZACTRPP  O    E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Array for Account Code
     D*AcCodAr******** S              4    DIM(9999)                                          M14UPG
     D AcCodAr         S             10    DIM(9999)                                          M14UPG
 
      ** Array for Account Section
     D AcSecAr         S              2    DIM(9999)
 
      ** Array for Loan Type/Sub Types for Part Sold Loans
     D PSoldAr         S              4    DIM(1000)
 
      ** Loan Type/Sub-Type DS
     D LNTYST          DS
     D   AYLNTY                1      2
     D   AYLNST                3      4
 
      ** Account Key
     D AKEY            DS
     D   AKEY1                 1      1
     D   AKEY2                 2      2
     D   AKEY1_2               1      2
     D   AKEY3                 3      3
     D   AKEY4_5               4      5
     D   AKEY10               10     10
     D   AKEY9_10              9     10
 
      ** SE Account Key
     D ACKE            DS
     D   SKEY1_3               1      3
     D   SKEY4                 4      4
     D   SKEY5                 5      5
     D   SKEY19_20            19     20
 
      ** Account Codes 1 - 3
     D ACD1_3          DS
     D***ACD1*********         1      4  0                                                    M14UPG
     D***ACD2*********         5      8  0                                                    M14UPG
     D***ACD3*********         9     12  0                                                    M14UPG
     D   ACD1                  1     10  0                                                    M14UPG
     D   ACD2                 11     20  0                                                    M14UPG
     D   ACD3                 21     30  0                                                    M14UPG
 
      ** Account Codes 4 - 6
     D ACD4_6          DS
     D***ACD4*********         1      4  0                                                    M14UPG
     D***ACD5*********         5      8  0                                                    M14UPG
     D***ACD6*********         9     12  0                                                    M14UPG
     D   ACD4                  1     10  0                                                    M14UPG
     D   ACD5                 11     20  0                                                    M14UPG
     D   ACD6                 21     30  0                                                    M14UPG
 
      ** Numeric/alpha Account Codes
     D                 DS
     D*ACODA**********         1      4                                                       M14UPG
     D*ACODN**********         1      4S 0                                                    M14UPG
     D ACODA                   1     10                                                       M14UPG
     D ACODN                   1     10S 0                                                    M14UPG
 
      ** Array of account codes
     D AcCodes         DS
     D***Codes********                4S 0 DIM(3)                                             M14UPG
     D   Codes                       10S 0 DIM(3)                                             M14UPG
 
      ** MM Deal Types, Asset and Liability
     D MMAssetAr       S              2    DIM(11) CTDATA PERRCD(11)
     D MMLiablAr       S              2    DIM(9)  CTDATA PERRCD(9)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Account Section
     D WAcSect         S              2
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Process records  in ACKEYAL
 
     C                   EXSR      ACCKEY
 
      ** If Securities Trading module on, process records  in SEACKD
 
     C     BGSECS        IFEQ      'Y'
     C                   EXSR      SEACK
     C                   ENDIF
 
     C                   SETON                                        LR
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** ACCKEY - PROCESS RECORDS FROM ACKEYAL
      *****************************************************************
     C     ACCKEY        BEGSR
 
      ** Read through ACKEYAL
 
     C                   READ      ACKEYAL                                50
     C     *IN50         DOWEQ     '0'
 
      ** Only process live records
 
     C     RECI          IFEQ      'D'
 
      ** Initialise work values for passing to ACKEYOUT
 
     C                   Z-ADD     0             Codes
     C                   MOVE      *BLANKS       WAcSect
 
      ** Select according to first positions of account key
 
     C                   SELECT
 
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      ** Lending Keys                                                 *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
     C     AKEY1         WHENEQ    'H'
     C     AKEY1         OREQ      'J'
     C     AKEY1         OREQ      'K'
 
      ** Lending module active
 
     C     BGCSLN        IFEQ      'Y'
 
      ** Required keys
 
     C     AKEY3         IFEQ      'V'
     C     AKEY9_10      ANDEQ     ' A'
 
      ** Check loan type subtype against array of Part Sold and set indicators
 
     C                   MOVE      AKEY1_2       AYLNTY
     C                   MOVE      AKEY4_5       AYLNST
 
     C     LNTYST        LOOKUP    PSoldAr                                60
     C  N60              MOVE      ACD1_3        AcCodes
     C  N60              MOVE      'AS'          WAcSect
                                                                                             ERZ054A
      ** If Account Codes of value date account key are zero, try deal date key.             ERZ054A
                                                                                             ERZ054A
     C                   IF        *IN60 = '0' AND AcCodes = *ZEROS                          ERZ054A
     C                   MOVE      'D'           AKEY3                                       ERZ054A
     C     AKEY          CHAIN     ACKEY                                                     ERZ054A
     C                   IF        %FOUND(ACKEY)                                             ERZ054A
     C                   MOVE      ACD1_3        AcCodes                                     ERZ054A
     C                   ELSE                                                                ERZ054A
     C                   MOVE      'V'           AKEY3                                       ERZ054A
     C                   ENDIF                                                               ERZ054A
     C                   ENDIF                                                               ERZ054A
                                                                                             ERZ054A
     C   60              MOVE      ACD4_6        AcCodes
     C   60              MOVE      'LI'          WAcSect
     C                   EXSR      AKEYOUT
 
     C                   ENDIF
     C                   ENDIF
 
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      ** FX Swap/Option Keys                                          *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
     C     AKEY1_2       WHENEQ    'SW'
     C     AKEY1_2       OREQ      'OP'
 
      ** FX Dealing module active
 
     C     BGDLFX        IFEQ      'Y'
 
      ** Required keys
 
     C     AKEY3         IFEQ      'D'
     C     AKEY9_10      ANDEQ     'FB'
 
     C                   MOVE      ACD1_3        AcCodes
     C                   MOVE      'CN'          WAcSect
     C                   EXSR      AKEYOUT
 
     C                   ENDIF
     C                   ENDIF
 
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      ** FX Swap/Option Keys                                          *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
     C     AKEY1_2       WHENEQ    'CX'
     C     AKEY1_2       OREQ      'FP'
     C     AKEY1_2       OREQ      'FS'
 
      ** FX Dealing module active
 
     C     BGDLFX        IFEQ      'Y'
 
      ** Required keys
 
     C     AKEY3         IFEQ      'V'
     C     AKEY9_10      ANDEQ     'FB'
 
     C                   MOVE      ACD4_6        AcCodes
     C                   MOVE      'CN'          WAcSect
     C                   EXSR      AKEYOUT
 
     C                   ENDIF
     C                   ENDIF
 
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      ** IRS Keys                                                     *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
     C     AKEY1_2       WHENEQ    'RS'
     C     AKEY1_2       OREQ      'RX'
     C     AKEY1_2       OREQ      'RP'
     C     AKEY1_2       OREQ      'RR'
     C     AKEY1_2       OREQ      'RF'
 
      ** FRA/IRS module active
 
     C     BGFIIN        IFEQ      'Y'
 
      ** Required keys
 
     C     AKEY3         IFEQ      'D'
     C     AKEY9_10      ANDEQ     ' A'
 
     C                   MOVE      ACD1_3        AcCodes
     C                   EXSR      AKEYOUT
 
     C                   ENDIF
     C                   ENDIF
 
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      ** FRA Keys                                                     *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
     C     AKEY1_2       WHENEQ    'FR'
 
      ** FRA/IRS module active
 
     C     BGFIIN        IFEQ      'Y'
 
      ** Required keys
 
     C     AKEY3         IFEQ      'V'
     C     AKEY9_10      ANDEQ     ' A'
 
     C                   MOVE      ACD1_3        AcCodes
     C                   MOVE      'CN'          WAcSect
     C                   EXSR      AKEYOUT
 
     C                   ENDIF
     C                   ENDIF
 
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
      ** MM Keys                                                      *
      * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 
     C                   OTHER
 
      ** MM Dealing module active
 
     C     BGDLMM        IFEQ      'Y'
 
      ** Search for MM Asset and Liability Deal Types
 
     C     AKEY1_2       LOOKUP    MMAssetAr                              61
     C     AKEY1_2       LOOKUP    MMLiablAr                              62
 
      ** MM Deal Type found
 
     C     *IN61         IFEQ      '1'
     C     *IN62         OREQ      '1'
 
      ** Required keys
 
     C     AKEY3         IFEQ      'V'
     C     AKEY9_10      ANDEQ     ' A'
 
     C   61              MOVE      ACD1_3        AcCodes
     C   61              MOVE      'AS'          WAcSect
     C   62              MOVE      ACD4_6        AcCodes
     C   62              MOVE      'LI'          WAcSect
 
     C                   EXSR      AKEYOUT
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   READ      ACKEYAL                                50
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SEACK - PROCESS RECORDS FROM SEACKD
      *****************************************************************
     C     SEACK         BEGSR
 
      ** Read through SEACKD
 
     C                   READ      SEACKD                                 50
     C     *IN50         DOWEQ     '0'
 
      ** Only process live records
 
     C     RECI          IFEQ      'D'
 
      ** Required keys
 
     C     SKEY4         IFEQ      'V'
     C     SKEY19_20     ANDEQ     'FV'
 
     C     SKEY5         IFEQ      'P'
     C     SKEY5         OREQ      'S'
 
      ** Set output fields
 
     C                   MOVEL     SKEY1_3       RZTTYP
     C     SKEY5         IFEQ      'P'
     C                   MOVE      'TP'          RZTSTP
     C                   MOVE      ACD1_3        AcCodes
     C                   MOVE      'AS'          WAcSect
     C                   ELSE
     C                   MOVE      'TS'          RZTSTP
     C                   MOVE      ACD4_6        AcCodes
     C                   MOVE      'LI'          WAcSect
     C                   ENDIF
 
      ** Check Account Section of Account Codes
 
     C                   EXSR      CHKACSC
 
      ** Write detail to file
 
     C                   WRITE     RZACTRP0
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   READ      SEACKD                                 50
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AKEYOUT - Output Account Key Detail
      *****************************************************************
     C     AKEYOUT       BEGSR
 
      ** Set output fields
 
     C                   MOVEL(P)  AKEY1_2       RZTTYP
     C                   MOVEL     AKEY4_5       RZTSTP
 
      ** Check Account Section of Account Codes
 
     C                   EXSR      CHKACSC
 
      ** Write detail to file
 
     C                   WRITE     RZACTRP0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHKACSC - Check Account Section
      *****************************************************************
     C     CHKACSC       BEGSR
 
      ** Check each of the 3 Account Codes in AcCodes for Account Section
 
     C                   Z-ADD     0             RZACOD
     C                   Z-ADD     0             Y                 1 0
 
     C                   DO        3
     C                   ADD       1             Y
     C                   MOVEA     Codes(Y)      ACODN
 
      ** Determine corresponding Account Section
 
     C     ACODN         IFNE      0
 
      ** Set extract Account Code if current value is blank
 
     C     RZACOD        IFEQ      0
     C                   MOVE      ACODN         RZACOD
     C                   ENDIF
 
     C                   Z-ADD     1             X
     C     ACODA         LOOKUP    AcCodAr(X)                             63
 
     C     *IN63         IFEQ      '1'
     C                   MOVEA     AcSecAr(X)    A5ACSC
 
      ** If work Account Section matches or is blank, set Account Code
      ** and leave
 
     C     WAcSect       IFEQ      A5ACSC
     C     WAcSect       OREQ      *BLANKS
     C                   MOVE      ACODN         RZACOD
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initialize program name
 
     C                   MOVEL     'RZ000001'    DBPGM
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      * Database Error
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         ******************
     C                   MOVEL     '001'         DBASE                          ** DB ERROR 001 **
     C                   MOVEL     @OPTN         DBKEY                          ******************
     C                   EXSR      *PSSR
     C                   END
 
      ** Load arrays of Account Codes and Account Sections
 
     C                   Z-ADD     0             X                 4 0
     C     *LOVAL        SETLL     SDACODL1
     C                   READ      SDACODL1                               50
     C     *IN50         DOWEQ     '0'
 
     C                   ADD       1             X
     C                   EVAL      AcCodAr(X) = A5ACCD
     C                   EVAL      AcSecAr(X) = A5ACSC
 
     C                   READ      SDACODL1                               50
     C                   END
 
      ** If Lending on, load array of Part Sold Loan Processing Type
 
     C     BGCSLN        IFEQ      'Y'
     C                   Z-ADD     0             X                 4 0
     C     *LOVAL        SETLL     SDLOANL1
     C                   READ      SDLOANL1                               50
     C     *IN50         DOWEQ     '0'
 
     C     AYLNPT        IFEQ      66
     C     AYLNPT        OREQ      67
     C     AYLNPT        OREQ      69
     C     AYLNPT        OREQ      72
     C                   ADD       1             X
     C                   EVAL      PSoldAr(X) = LNTYST
     C                   END
 
     C                   READ      SDLOANL1                               50
     C                   END
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - PROGRAM EXCEPTION ERROR ROUTINE
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   OUT       LDA
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2013
**  MMAssetAr
IPTICLDLC1C2BPBDTBDATA
**  MMLiablAr
ITTDCDCSBSBRTSRATR
