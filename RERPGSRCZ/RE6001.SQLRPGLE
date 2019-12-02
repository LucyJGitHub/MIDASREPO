     H DEBUG
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas APR Calculation for Retail')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE6001 - RE APR Calculation                                  *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054698           Date 31Oct19               *
      *  Prev Amend No. MD054017           Date 03Sep19               *
      *                 CER050  *Create    Date 16Jun19               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD054698 - CER050 REC376A 00001 failed during COB            *
      *  MD054017-Change on validation of System Value "APR Formula"  *
      *  CER050 - Annualised Percentage Rate                          *
      *           (including AR583105)                                *
      *                                                               *
      *****************************************************************
     FRECAPML   IF   E           K DISK
     FREHISL    IF   E           K DISK
     FRECOM     IF   E           K DISK
     FACCRACJ   IF   E           K DISK
     FTABTBRE   IF   E             DISK    USROPN
     FSDCURRL0  IF   E           K DISK
     FSDMMODPD  IF   E             DISK
     FREAPRHI0  IF   E           K DISK
     FREAPRHI1  IF   E           K DISK
     F                                     RENAME(REAPRHD0:REAPRHD1)
     FGLAPRCTD  O    E             DISK    USROPN
     FREAPRHTD  O    E             DISK
     F                                     RENAME(REAPRHD0:REAPRHD2)
      *****************************************************************
      *                                                               *
      *   F U N C T I O N   O F   I N D I C A T O R S                 *
      *                                                               *
      *   51  USE WITH REHISL                                         *
      *   52  USE WITH REHISL                                         *
      *   62  SIGNIFIES RECORD WRITTEN TO THE APR WORK FILE           *
      *   63  CONTROLS USE OF APR RATES FILE                          *
      *   64  SIGNIFIES A NON-ZERO RECORD WRITTEN TO APR WORK FILE    *
      *   70  MANAGEMENT STATEMENT PRINT                              *
      *   87  CAPITALISATION TO AN ACCOUNT IN DIFFERENT CURRENCY      *
      *       AND MULTIBRANCH PRESENT                                 *
      *   88  CHARGES FOR MULTIPLE TRANSACTION PRESENT                *
      *   96  CURRENCIES ARRAY IS FULL                                *
      *   97  USE IF CURRENCY EXIST                                   *
      *   98  DATF = M                                                *
      *   99  GENERAL ERROR AND CHAINING                              *
      *                                                               *
      *   U7  DATABASE ERROR                                          *
      *   U8  DATABASE ERROR                                          *
      *   LR  END OF PROGRAM                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *   S U B R O U T I N E   I N D E X                             *
      *                                                               *
      *   CRSR   - Credit only processing                             *
      *   DAYTSR - Prepare and output days total                      *
      *   DBSR   - Database error handling                            *
      *   DETPR  - Detail processing                                  *
      *   DRSR   - Debit only processing                              *
      *   INIT   - First cycle                                        *
      *   ITYPCR - Interest type greater than 2                       *
      *   ITYPDR - Interest type greater than 2                       *
      *   MAIN   - Main processing                                    *
      *   REAPR  - Calculate new APR rate and write to file           *
      *   APROUT - Write a record to the APR calculation work file    *
      *   ZICD   - Find number of days to calculate interest according*
      *            to calculation basis                               *
      *   *PSSR  - Error subroutine for certain access object errors  *
      *****************************************************************
      /EJECT
     D CCYA            S              3    DIM(200)
     D DPA             S              1  0 DIM(200)
     D CMD             S             28    DIM(1) CTDATA PERRCD(1)
     D P@OP01          S             20                                                  MD054017
     D P@VL01          S            200                                                  MD054017
     D P@OP02          S             20                                                  MD054017
     D P@VL02          S            200                                                  MD054017
     D P@OP03          S             20                                                  MD054017
     D P@VL03          S            200                                                  MD054017
     D P@OP04          S             20                                                  MD054017
     D P@VL04          S            200                                                  MD054017
     D P@OP05          S             20                                                  MD054017
     D P@VL05          S            200                                                  MD054017
     D P@OP06          S             20                                                  MD054017
     D P@VL06          S            200                                                  MD054017
     D P@OP07          S             20                                                  MD054017
     D P@VL07          S            200                                                  MD054017
     D P@OP08          S             20                                                  MD054017
     D P@VL08          S            200                                                  MD054017
     D P@OP09          S             20                                                  MD054017
     D P@VL09          S            200                                                  MD054017
     D P@OP10          S             20                                                  MD054017
     D P@VL10          S            200                                                  MD054017
     D SYSVAL1         S              1                                                  MD054017
     D SYSVAL2         S             30                                                  MD054017
     D SYSVAL2A        S             30                                                  MD054017
      *
      * DATA STRUCTURE FOR COMPILATION  - COPYRIGHT INSERTION
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      * EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  DATF         E                     EXTFLD(BJDFIN)
     D  RUNA         E                     EXTFLD(BJMRDT)
     D  RUND         E                     EXTFLD(BJRDNB)
     D  TITL         E                     EXTFLD(BJURPT)
      *
      * EXTERNAL DS FOR RETAIL DETAILS
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  LDAC         E                     EXTFLD(BMLDAI)
      *
      * DATA STRUCTURE FOR BEGINNING DATE
     D                 DS
     D  SRES                   1      6  0
     D  ZISD                   1      2  0
     D  ZISM                   3      4  0
     D  ZISY                   5      6  0
      *
      * DATA STRUCTURE FOR FINISHING DATE
     D                 DS
     D  FRES                   1      6  0
     D  ZIFD                   1      2  0
     D  ZIFM                   3      4  0
     D  ZIFY                   5      6  0
      *
      * DATA STRUCTURE FOR DATE FORMAT DD/MM/YY
     D                 DS
     D  RESULT                 1      6  0
     D  ZDAY                   1      2  0
     D  ZMTH                   3      4  0
     D  ZYEAR                  5      6  0
      *
     D OKEYD           DS
     D  OKEY                   1     24
     D  OBRCA                  1      3
     D  OCNUM                  4      9
     D  OCCY                  10     12
     D  OACOD                 13     22  0
     D  OACSQ                 23     24  0
     D  OLDID                 25     27P 0
      *
     D  ADREF1                 1      8
     D  WRCDT                  1      1
      *
     D RKEY2           DS
     D  RKEY                   1     24
     D  CBRCA                  1      3
     D  CCNUM                  4      9
     D  CCCY                  10     12
     D  CACOD                 13     22  0
     D  CACSQ                 23     24  0
     D  WDATE                 25     29  0
     D  CBRCA2                 1      3
      *
      * LOCAL DATA AREA FOR DATABASE ERROR DETAILS
     D LDA           E DS           256    EXTNAME(LDA)
      *
      * EXTERNAL DATA STRUCTURE FOR BRANCH DETAILS
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BRNM         E                     EXTFLD(A8BRNM)
      *
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)

     D LO              C                   'abcdefghijklmnopqrstuvwxyz'                  MD054017
     D UP              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'                  MD054017

     I/COPY ZSRSRC,ZDATE2Z1LE
      *
      * RENAME REHISPSF FORMAT FIELDS - REHISL  FILE
     IREHISPSF
     I              RECI                        DRECI
     I              BRCA                        SBRCA
     I              CNUM                        SCNUM
     I              CCY                         SCCY
     I              ACOD                        SACOD
     I              ACSQ                        SACSQ
     I              HISD                        DHISD
     I              HISB                        DHISB
     I              MNBL                        SMNBL
     I              PCHGAR                      SCHGAR
     I              TCHGAR                      STHGAR
     I              PCHGAN                      SCHGAN
     I              TCHGAN                      STHGAN
     I              DICT                        DDICT
     I              DRCB                        SDRCB
     I              DRCD                        SDRCD
     I              DAIC                        SDAIC
     I              PMADI                       SPMADI
     I              TMADI                       STMADI
     I              PDID                        SPDID
     I              DMINT                       SDMINT
     I              DRIP                        SDRIP
     I              DRIS                        SDRIS
     I              CICT                        DCICT
     I              CRCB                        SCRCB
     I              CRCD                        SCRCD
     I              CAIC                        SCAIC
     I              PMACI                       SPMACI
     I              TMACI                       STMACI
     I              PCID                        SPCID
     I              CMINT                       SCMINT
     I              CRIP                        SCRIP
     I              CRIS                        SCRIS
     I              STBL                        SSTBL
     I              CHGP                        SCHGP
      *
      * RENAME REHISPPF FORMAT FIELDS - REHISL  FILE
     IREHISPPF
     I              RECI                        DRECI
     I              BRCA                        DBRCA
     I              CNUM                        DCNUM
     I              CCY                         DCCY
     I              ACOD                        DACOD
     I              ACSQ                        DACSQ
     I              HISD                        DHISD
     I              HISB                        DHISB
     I              MNBL                        DMNBL
     I              CHGAR                       DCHGAR
     I              TCHGAR                      DTHGAR
     I              CHGAN                       DCHGAN
     I              TCHGAN                      DTHGAN
     I              DMVT                        DDMVT
     I              DICT                        DDICT
     I              DRCB                        DDRCB
     I              DRCD                        DDRCD
     I              DAID                        DDAID
     I              MADI                        DMADI
     I              TMADI                       DTMADI
     I              PDID                        DPDID
     I              DMINT                       DDMINT
     I              CMVT                        DCMVT
     I              CICT                        DCICT
     I              CRCB                        DCRCB
     I              CRCD                        DCRCD
     I              CAID                        DCAID
     I              MACI                        DMACI
     I              TMACI                       DTMACI
     I              PCID                        DPCID
     I              CMINT                       DCMINT
     I              DICI                        DDICI
     I              CICI                        DCICI
     I              DRCI                        DDRCI
     I              CRCI                        DCRCI
     I              VDTC                        DVDTC
     I              ADTY                        DADTY
     I              ALTI                        DALTI
     I              MNBCP                       DMNBCP
      *
      * RENAME REHISPMF FORMAT FIELDS - REHISL  FILE
     IREHISPMF
     I              RECI                        DRECI
     I              HISD                        MHISD
      *
      *===================================================================
      *
     C                   MOVEA     CPY@          BIS@             80
     C     *DTAARA       DEFINE                  LDA
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER050'      PSARD             6
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      ** Call Access Program for System Value                                            MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL1 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRRetailAccounts'                          MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       PRTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017

      ** Handle Database Error

     C                   If        PRTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 22                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      DBSR                                                  MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL1 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
                                                                                         MD054017
     C                   EVAL      SYSVAL2 = *BLANKS                                     MD054017
     C                   EVAL      P@OP01 = 'APRFormula       '                          MD054017
     C                   Call      'AOSVALR0'                                            MD054017
     C                   Parm      *BLANKS       PRTCD                                   MD054017
     C                   Parm                    P@OP01                                  MD054017
     C                   Parm      *BLANKS       P@VL01                                  MD054017
     C                   Parm                    P@OP02                                  MD054017
     C                   Parm      *BLANKS       P@VL02                                  MD054017
     C                   Parm                    P@OP03                                  MD054017
     C                   Parm      *BLANKS       P@VL03                                  MD054017
     C                   Parm                    P@OP04                                  MD054017
     C                   Parm      *BLANKS       P@VL04                                  MD054017
     C                   Parm                    P@OP05                                  MD054017
     C                   Parm      *BLANKS       P@VL05                                  MD054017
     C                   Parm                    P@OP06                                  MD054017
     C                   Parm      *BLANKS       P@VL06                                  MD054017
     C                   Parm                    P@OP07                                  MD054017
     C                   Parm      *BLANKS       P@VL07                                  MD054017
     C                   Parm                    P@OP08                                  MD054017
     C                   Parm      *BLANKS       P@VL08                                  MD054017
     C                   Parm                    P@OP09                                  MD054017
     C                   Parm      *BLANKS       P@VL09                                  MD054017
     C                   Parm                    P@OP10                                  MD054017
     C                   Parm      *BLANKS       P@VL10                                  MD054017

      ** Handle Database Error

     C                   If        PRTCD <> *BLANKS                                      MD054017
     C                   Eval      DBASE = 23                                            MD054017
     C                   Eval      DBFILE = 'SDSVALPD'                                   MD054017
     C                   Eval      DBKEY = P@OP01                                        MD054017
     C                   Eval      DBPGM = 'AOSVALR0'                                    MD054017
     C                   EXSR      DBSR                                                  MD054017
     C                   ELSE                                                            MD054017
     C                   EVAL      SYSVAL2 = P@VL01                                      MD054017
     C                   ENDIF                                                           MD054017
      *
      * Key lists
      *
      * Klist to chain on RECOM
     C     KLIST0        KLIST
     C                   KFLD                    CBRCA
     C                   KFLD                    CCNUM
     C                   KFLD                    CCCY
     C                   KFLD                    CACOD
     C                   KFLD                    CACSQ
      *
      * Klist to read REHISL and cha
     C     KLIST1        KLIST
     C                   KFLD                    CBRCA
     C                   KFLD                    CCNUM
     C                   KFLD                    CCCY
     C                   KFLD                    CACOD
     C                   KFLD                    CACSQ
      *
      *  Klist to read REHISL for debit
     C     KLIST2        KLIST
     C                   KFLD                    CBRCA
     C                   KFLD                    CCNUM
     C                   KFLD                    CCCY
     C                   KFLD                    CACOD
     C                   KFLD                    CACSQ
     C                   KFLD                    CLDID
      *
      *  Klist to read REHISL for credit
     C     KLIST3        KLIST
     C                   KFLD                    CBRCA
     C                   KFLD                    CCNUM
     C                   KFLD                    CCCY
     C                   KFLD                    CACOD
     C                   KFLD                    CACSQ
     C                   KFLD                    CLCID
      *
      *  Klist to access REAPRHI0 (debits) and REAPRHI1 (credits)
     C     KLIST4        KLIST
     C                   KFLD                    ACNO
     C                   KFLD                    RUND
      *
      * Work fields definition
     C     *LIKE         DEFINE    DDAID         WDAID
     C     *LIKE         DEFINE    DCAID         WCAID
     C     *LIKE         DEFINE    RUND          PVALD
     C     *LIKE         DEFINE    ACNO          WACNO
     C     *LIKE         DEFINE    DCRCB         WCRCB
     C     *LIKE         DEFINE    DDRCB         WDRCB
     C     *LIKE         DEFINE    DHISB         WHISB
     C     *LIKE         DEFINE    DHISD         WHISD
     C     *LIKE         DEFINE    MNBL          WMNBL
     C     *LIKE         DEFINE    CNUM          ZERROR          - 5
     C     *LIKE         DEFINE    RUND          ZIBEG
     C     *LIKE         DEFINE    RUND          ZIBW1
     C     *LIKE         DEFINE    RUND          ZIDREM
     C     *LIKE         DEFINE    CICT          ZIDW1
     C     *LIKE         DEFINE    RUND          ZIDW2
     C     *LIKE         DEFINE    RUND          ZID1
     C     *LIKE         DEFINE    RUND          ZID2
     C     *LIKE         DEFINE    RUND          ZIEND
     C     *LIKE         DEFINE    RUND          ZILPCP
     C     *LIKE         DEFINE    CICT          ZIMAN
     C     *LIKE         DEFINE    CICT          ZIM1
     C     *LIKE         DEFINE    RUND          ZIREM
     C     *LIKE         DEFINE    CICT          ZIY1
      *
     C/EJECT
      *===================================================================
      * P R O G R A M     S T A R T
      *===================================================================
      *
      * First cycle processing
     C                   EXSR      INIT
      *
      * Main processing
     C                   EXSR      MAIN
      *
      *===================================================================
      * P R O G R A M     E N D
      *===================================================================
      ********************************************************************
     C/EJECT
      **************************************************************************
      * CRSR - Credit Output Processing                                        *
      * Called by: DETPR                                                       *
      * Calls....: DBSR, DAYTSR, ITYPCR, ZICD                                  *
      **************************************************************************
      *
     C     CRSR          BEGSR
      *
      * ACCESS REHISL WITH LAST CREDIT CAPITALISATION DATE
     C     KLIST3        SETLL     REHISL                             52
      *
     C     KLIST1        READE     REHISL                                 52
      *
     C     *IN52         IFEQ      '1'                                          - B1
     C                   Z-ADD     CLCID         WDATE
     C                   Z-ADD     5             DBASE
     C                   MOVE      'REHISL'      DBFILE                         ***************
     C                   MOVEL     RKEY2         DBKEY                          **DB ERROR 05**
     C                   EXSR      DBSR                                         ***************
     C                   END                                                    - E1
      *
     C     *IN52         DOWEQ     '0'                                          - B1
     C     DRECI         ANDEQ     'S'
     C     SDICI         ANDNE     *BLANKS
     C     SCICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN52         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DCRCI         ANDEQ     *BLANKS
     C     DDMVT         ANDEQ     *ZERO
     C     DCMVT         ANDEQ     *ZERO
     C     DMACI         ANDEQ     *ZERO
     C     KLIST1        READE     REHISL                                 52
     C                   END                                                    - E1
      *
      *  PREPARE B/F BALANCE
     C     DRECI         IFEQ      'B'                                          - B1
     C     DRECI         OREQ      'D'                                                      MD054698
     C     DRECI         OREQ      'M'                                                      MD054698
     C                   Z-ADD     *ZEROS        HISB0
     C                   ELSE                                                   - X1
     C     DRECI         IFEQ      'S'                                          - B2
     C                   Z-ADD     SSTBL         HISB0
     C                   ELSE                                                   - X2
     C                   Z-ADD     CLCID         WDATE
     C                   Z-ADD     6             DBASE
     C                   MOVE      'REHISL'      DBFILE                         ***************
     C                   MOVEL     RKEY2         DBKEY                          **DB ERROR 06**
     C                   EXSR      DBSR                                         ***************
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
      * PREPARE OPENING BALANCE
     C                   Z-ADD     CLCID         WHISD
     C                   Z-ADD     DHISB         EVAMNT           13 0
     C                   Z-ADD     0             APRDAY
     C                   MOVE      'I'           INOUT             1
      *
      * Save opening balance and start date
     C                   Z-ADD     EVAMNT        WKBAL            13 0
     C                   Z-ADD     DHISD         WKCID             5 0
      *
      * OUTPUT OPENING BALANCE
     C     EVAMNT        IFLT      0                                            - B1
     C                   Z-SUB     EVAMNT        EVAMNT
     C                   EXSR      APROUT
     C                   END
      *
     C     *IN51         DOWEQ     '0'                                          - B1
     C     DHISD         ANDLT     CHISD
      *
      * SAVE REHISL  AS PREVIOUS
     C                   Z-ADD     DHISD         WHISD
     C                   Z-ADD     DHISB         WHISB
     C                   MOVE      DDRCB         WDRCB
     C                   Z-ADD     DCRCB         WCRCB
     C                   Z-ADD     DCAID         WCAID
     C                   Z-ADD     DDAID         WDAID
      *
     C     KLIST1        READE     REHISL                                 51
      *
     C     *IN51         DOWEQ     '0'                                          - B2
     C     DRECI         ANDEQ     'S'
     C     SCICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN51         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DCRCI         ANDEQ     *BLANKS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
     C     DMACI         ANDEQ     *ZERO
      *
     C     KLIST1        READE     REHISL                                 51
     C                   END                                                    - E2
      *
      * OUTPUT SUBTOTAL LINE
     C     *IN51         IFEQ      '0'                                          - B2
     C     DHISD         ANDLT     CHISD
      *
     C     CCICT         IFLT      3                                            - B3
     C                   Z-ADD     WCRCB         ZICALC
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     DHISD         ZIEND
     C                   EXSR      DAYCSR
     C                   ELSE                                                   - X3
     C                   EXSR      ITYPCR
     C                   END                                                    - E3
      *
     C     *IN51         IFEQ      '0'                                          - B3
      *
      * CHECK IF READ RECORD IS A CHANGE RATE
     C     DCRCI         IFEQ      'Y'                                          - B4
     C     DRECI         ANDNE     'B'
      *
      * SAVE REHISL AS PREVIOUS
     C                   Z-ADD     DHISD         WHISD
     C                   Z-ADD     DHISB         WHISB
     C                   MOVE      DDRCB         WDRCB
     C                   Z-ADD     DCRCB         WCRCB
     C                   Z-ADD     DCAID         WCAID
     C                   Z-ADD     DDAID         WDAID
      *
     C     KLIST1        READE     REHISL                                 51
      *
     C     *IN51         DOWEQ     '0'                                          - B5
     C     DRECI         ANDEQ     'S'
     C     SCICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN51         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DCRCI         ANDEQ     *BLANKS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
     C     DMACI         ANDEQ     *ZEROS
      *
     C     KLIST1        READE     REHISL                                 51
     C                   END                                                    - E5
      *
     C     CCICT         IFLT      3                                            - B5
     C                   Z-ADD     WCRCB         ZICALC
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     DHISD         ZIEND
     C                   EXSR      DAYCSR
     C                   ELSE                                                   - X5
     C                   EXSR      ITYPCR
     C                   END                                                    - E5
      *
     C                   END                                                    - E4
      *
     C                   END                                                    - E3
      *
     C                   END                                                    - E2
      *
     C                   END                                                    - E1
      *
     C     KLIST3        SETLL     REHISL                                 52
      *
     C     *IN52         IFEQ      '0'                                          - B1
     C                   Z-ADD     CLCID         WDATE
     C                   Z-ADD     7             DBASE
     C                   MOVE      'REHISL'      DBFILE                         ***************
     C                   MOVEL     RKEY2         DBKEY                          **DB ERROR 07**
     C                   EXSR      DBSR                                         ***************
     C                   END                                                    - E1
      *
     C     KLIST1        READE     REHISL                                 52
      *
     C     *IN52         DOWEQ     '0'                                          - B1
     C     DRECI         ANDEQ     'S'
     C     SCICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN52         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DCRCI         ANDEQ     *BLANKS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
     C     DMACI         ANDEQ     *ZEROS
      *
     C     KLIST1        READE     REHISL                                 52
      *
     C                   END                                                    - E1
      *
     C     DCICT         IFLT      3                                            - B1
     C                   Z-ADD     WCRCB         ZICALC
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     CHISD         ZIEND
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS              4 0
     C                   Z-ADD     WHISB         HISB0
     C     HISB0         MULT      DAYS          NUMB0
      *
     C     WHISB         IFGT      *ZEROS                                       - B1
     C     CDAIC         SUB       WDAID         INTD0
     C                   Z-ADD     *ZEROS        INTC0
     C                   ELSE                                                   - X1
     C     CCAIC         SUB       WCAID         INTC0
     C                   Z-ADD     *ZEROS        INTD0
     C                   END                                                    - E1
     C                   END                                                    - E1
      *
      * PREPARE C/F BALANCE
      * TRANSFER DATE MIDAS INTO DDMMMYY
     C     PVALD         IFNE      CHISD                                        - B1
     C                   MOVE      CHISD         PVALD
     C                   END                                                    - E1
      *
     C                   Z-ADD     CHISB         HISB0
      *
      * OUTPUT BALANCE C/F
     C     CHISB         IFLT      0                                            - B1
     C                   Z-SUB     CHISB         EVAMNT
     C     CHISD         SUB       WKCID         APRDAY
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
     C                   END
      *
      **  PREPARE TOTAL CHARGES, COMMISSION, ETC.
     C                   Z-ADD     *ZERO         TINTC0
     C     CSCCI         IFEQ      'Y'
     C     CSCCI         OREQ      'I'
     C     CSCCI         OREQ      'A'
     C                   Z-SUB     CCAIC         TINTC0
     C                   END
     C     CSCHGI        IFEQ      'Y'
     C     CSCHGI        OREQ      'I'
     C     CSCHGI        OREQ      'A'
     C     CSCHGI        OREQ      'L'
     C     CSCHGI        OREQ      'O'
     C                   ADD       CCHGP         TINTC0
     C                   END
     C                   SUB       CSGACI        TINTC0
      *
      * OUTPUT TOTAL OF CHARGES, COMMISSION ETC.
     C     TINTC0        IFGE      0
     C                   Z-ADD     TINTC0        EVAMNT
     C                   MOVE      'I'           INOUT
     C                   ELSE
     C                   Z-SUB     TINTC0        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   END
     C     CHISD         SUB       WKCID         APRDAY
     C                   EXSR      APROUT
      *
     C                   ENDSR
      **************************************************************************
     C/EJECT
      **************************************************************************
      * DAYCSR subroutine to prepare and output days total                     *
      *                                                                        *
      * Called by: CRSR, DRSR                                                  *
      * Calls....: ZICD                                                        *
      **************************************************************************
      *
     C     DAYCSR        BEGSR
      *
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C                   Z-ADD     WHISB         HISB0
     C     HISB0         MULT      DAYS          NUMB0
     C     DCAID         SUB       WCAID         INTC0
     C                   Z-SUB     INTC0         INTC0
      *
      * OUTPUT SUBTOTAL
      *
      * If present balance is GE 0
     C     DHISB         IFGE      0                                            - B1
      *
      * If previous balance was GE 0 - ignore
     C     WKBAL         IFGE      0                                            - B2
     C                   Z-ADD     DHISB         WKBAL
     C                   ELSE
      *
      * If previous balance was LT 0 - reverse it, reset day
     C                   Z-SUB     WKBAL         EVAMNT
     C     DHISD         SUB       WKCID         APRDAY
     C                   Z-ADD     DHISD         WKCID
     C                   MOVE      'O'           INOUT
     C                   Z-ADD     DHISB         WKBAL
     C                   EXSR      APROUT
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
      * If present balance is LT 0
     C     DHISB         IFLT      0                                            - B1
      *
      * If previous balance was GE 0 - use present, reset day
     C     WKBAL         IFGE      0                                            - B2
     C                   Z-SUB     DHISB         EVAMNT
     C                   Z-ADD     DHISD         WKCID
     C     DHISD         SUB       WKCID         APRDAY
     C                   MOVE      'I'           INOUT
     C                   Z-ADD     DHISB         WKBAL
     C                   EXSR      APROUT
     C                   ELSE
      *
      * If previous balance was LT 0 - calculate difference
     C     WKBAL         SUB       DHISB         EVAMNT
     C     EVAMNT        IFLT      0                                            - B3
     C                   Z-SUB     EVAMNT        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   ELSE                                                   - E3
     C                   MOVE      'I'           INOUT
     C                   END                                                    - E3
     C     DHISD         SUB       WKCID         APRDAY
     C                   Z-ADD     DHISB         WKBAL
     C                   EXSR      APROUT
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
     C                   ENDSR
      **************************************************************************
     C/EJECT
      **************************************************************************
      * DAYDSR subroutine to prepare and output days total                     *
      *                                                                        *
      * Called by: CRSR, DRSR                                                  *
      * Calls....: ZICD                                                        *
      **************************************************************************
      *
     C     DAYDSR        BEGSR                                                  **DAYDSR BEGSR*
      *
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C                   Z-ADD     WHISB         HISB0
     C     HISB0         MULT      DAYS          NUMB0
     C     DDAID         SUB       WDAID         INTD0
      *
      * OUTPUT SUBTOTAL
      *
      * If present balance is LE 0
     C     DHISB         IFLE      0                                            - B1
      *
      * If previous balance was LE 0 - ignore
     C     WKBAL         IFLE      0                                            - B2
     C                   Z-ADD     DHISB         WKBAL
     C                   ELSE
      *
      * If previous balance was GT 0 - use it, reset day
     C                   Z-ADD     WKBAL         EVAMNT
     C     DHISD         SUB       WKCID         APRDAY
     C                   Z-ADD     DHISD         WKCID
     C                   MOVE      'O'           INOUT
     C                   Z-ADD     DHISB         WKBAL
     C                   EXSR      APROUT
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
      * If present balance is GT 0
     C     DHISB         IFGT      0                                            - B1
      *
      * If previous balance was LE 0 - use present, reset day
     C     WKBAL         IFLE      0                                            - B2
     C                   Z-ADD     DHISB         EVAMNT
     C                   Z-ADD     DHISD         WKCID
     C     DHISD         SUB       WKCID         APRDAY
     C                   MOVE      'I'           INOUT
     C                   Z-ADD     DHISB         WKBAL
     C                   EXSR      APROUT
     C                   ELSE
      *
      * If previous balance was GT 0 - calculate difference
     C     WKBAL         SUB       DHISB         EVAMNT
     C     EVAMNT        IFGT      0                                            - B3
     C                   MOVE      'O'           INOUT
     C                   ELSE                                                   - E3
     C                   Z-SUB     EVAMNT        EVAMNT
     C                   MOVE      'I'           INOUT
     C                   END                                                    - E3
     C     DHISD         SUB       WKCID         APRDAY
     C                   Z-ADD     DHISB         WKBAL
     C                   EXSR      APROUT
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
     C                   ENDSR                                                  **DAYDSR ENDSR*
      ********************************************************************
     C/EJECT
      **************************************************************************
      * DBSR subroutine for database error handling                            *
      *                                                                        *
      * Called by: DETPR, DRSR, CRSR, INIT                                     *
      * Calls....:                                                             *
      **************************************************************************
      *
     C     DBSR          BEGSR                                                  **DBSR BEGSR**
      *
     C                   MOVE      'REI001'      DBPGM
     C                   EXSR      *PSSR
      *
     C                   ENDSR                                                  **DBSR ENDSR**
      **************************************************************************
     C/EJECT
      **************************************************************************
      * DRSR subroutine for debit output processing                            *
      *                                                                        *
      * Called by: DETPR                                                       *
      * Calls....: DBSR, DAYTSR, ITYPDR, ZICD                                  *
      **************************************************************************
      *
     C     DRSR          BEGSR                                                  **DRSR BEGSR**
      *
      *  ACCESS REHISL WITH LAST DEBIT CAPITALISATION DATE
     C     KLIST2        SETLL     REHISL                             52
      *
     C     KLIST1        READE     REHISL                                 52
      *
     C     *IN52         IFEQ      '1'                                          - B1
     C                   Z-ADD     CLDID         WDATE
     C                   Z-ADD     8             DBASE
     C                   MOVE      'REHISL'      DBFILE                         ***************
     C                   MOVEL     RKEY2         DBKEY                          **DB ERROR 08**
     C                   EXSR      DBSR                                         ***************
     C                   END                                                    - E1
      *
     C     *IN52         DOWEQ     '0'                                          - B1
     C     DRECI         ANDEQ     'S'
     C     SDICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN52         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DDRCI         ANDEQ     *BLANKS
     C     DMADI         ANDEQ     *ZEROS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
      *
     C     KLIST1        READE     REHISL                                 52
     C                   END                                                    - E1
      *
      * PREPARE B/F BALANCE
     C     DRECI         IFEQ      'B'                                          - B1
     C     DRECI         OREQ      'D'                                                      MD054698
     C     DRECI         OREQ      'M'                                                      MD054698
     C                   Z-ADD     *ZEROS        HISB0
     C                   ELSE                                                   - X1
     C     DRECI         IFEQ      'S'                                          - B2
     C                   Z-ADD     SSTBL         HISB0
     C                   ELSE                                                   - X2
     C                   Z-ADD     CLDID         WDATE
     C                   Z-ADD     9             DBASE
     C                   MOVE      'REHISL'      DBFILE                         ***************
     C                   MOVEL     RKEY2         DBKEY                          **DB ERROR 09**
     C                   EXSR      DBSR                                         ***************
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
     C                   Z-ADD     DHISB         WHISB
      *
      * PREPARE OPENING BALANCE OUTPUT
     C     DRECI         IFEQ      'B'                                          - B1
     C                   Z-ADD     DHISB         WHISB
     C                   ELSE                                                   - X1
     C     DRECI         IFEQ      'S'                                          - B2
     C                   Z-ADD     SSTBL         WHISB
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
      * SAVE IN CASE OF NO POSTING
     C                   Z-ADD     CLDID         WHISD
     C                   Z-ADD     DHISB         EVAMNT
     C                   Z-ADD     0             APRDAY
     C                   MOVE      'I'           INOUT
      *
      * Save opening balance and start date
     C                   Z-ADD     EVAMNT        WKBAL
     C                   Z-ADD     DHISD         WKCID
      *
      * OUTPUT OPENING BALANCE
     C     EVAMNT        IFGT      0                                            - B1
     C                   EXSR      APROUT
     C                   END                                                    - E1
      *
     C     *IN51         DOWEQ     '0'                                          - B1
     C     DHISD         ANDLT     CHISD
      *
      * SAVE REHISL AS PREVIOUS
     C                   Z-ADD     DHISD         WHISD
     C                   Z-ADD     DHISB         WHISB
     C                   MOVE      DDRCB         WDRCB
     C                   Z-ADD     DCRCB         WCRCB
     C                   Z-ADD     DCAID         WCAID
     C                   Z-ADD     DDAID         WDAID
      *
     C     KLIST1        READE     REHISL                                 51
      *
     C     *IN51         DOWEQ     '0'                                          - B2
     C     DRECI         ANDEQ     'S'
     C     SDICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN51         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DDRCI         ANDEQ     *BLANKS
     C     DMADI         ANDEQ     *ZEROS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
      *
     C     KLIST1        READE     REHISL                                 51
     C                   END                                                    - E2
      *
      * OUTPUT SUBTOTAL LINE
     C     *IN51         IFEQ      '0'                                          - B2
     C     DHISD         ANDLT     CHISD
      *
     C     CDICT         IFLT      3                                            - B3
     C                   Z-ADD     WDRCB         ZICALC
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     DHISD         ZIEND
     C                   EXSR      DAYDSR
     C                   ELSE                                                   - X3
     C                   EXSR      ITYPDR
     C                   END                                                    - E3
      *
     C     *IN51         IFEQ      '0'                                          - B3
      *
      * CHECK IF READ RECORD IS A CHANGE RATE
     C     DDRCI         IFEQ      'Y'                                          - B4
     C     DRECI         ANDNE     'B'
      *
      * SAVE REHISL  AS PREVIOUS
     C                   Z-ADD     DHISD         WHISD
     C                   Z-ADD     DHISB         WHISB
     C                   MOVE      DDRCB         WDRCB
     C                   Z-ADD     DCRCB         WCRCB
     C                   Z-ADD     DCAID         WCAID
     C                   Z-ADD     DDAID         WDAID
      *
     C     KLIST1        READE     REHISL                                 51
      *
     C     *IN51         DOWEQ     '0'                                          - B5
     C     DRECI         ANDEQ     'S'
     C     SDICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN51         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DDRCI         ANDEQ     *BLANKS
     C     DMADI         ANDEQ     *ZEROS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
      *
     C     KLIST1        READE     REHISL                                 51
     C                   END                                                    - E5
      *
     C     CDICT         IFLT      3                                            - B5
     C                   Z-ADD     WDRCB         ZICALC
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     DHISD         ZIEND
     C                   EXSR      DAYDSR
     C                   ELSE                                                   - X5
     C                   EXSR      ITYPDR
     C                   END                                                    - E5
      *
     C                   END                                                    - E4
      *
     C                   END                                                    - E3
      *
     C                   END                                                    - E2
      *
     C                   END                                                    - E1
      *
     C     KLIST2        SETLL     REHISL                                 52
      *
     C     *IN52         IFEQ      '0'                                          - B1
     C                   Z-ADD     CLDID         WDATE
     C                   Z-ADD     10            DBASE
     C                   MOVE      'REHISL'      DBFILE                         ***************
     C                   MOVEL     RKEY2         DBKEY                          **DB ERROR 10**
     C                   EXSR      DBSR                                         ***************
     C                   END                                                    - E1
      *
     C     KLIST1        READE     REHISL                                 52
      *
     C     *IN52         DOWEQ     '0'                                          - B1
     C     DRECI         ANDEQ     'S'
     C     SDICI         ANDEQ     *BLANKS
     C     DHISD         ANDLT     CHISD
     C     *IN52         OREQ      '0'
     C     DRECI         ANDEQ     'D'
     C     DDRCI         ANDEQ     *BLANKS
     C     DMADI         ANDEQ     *ZEROS
     C     DDMVT         ANDEQ     *ZEROS
     C     DCMVT         ANDEQ     *ZEROS
      *
     C     KLIST1        READE     REHISL                                 52
     C                   END                                                    - E1
      *
     C     DDICT         IFLT      3                                            - B1
      *
     C                   Z-ADD     WDRCB         ZICALC
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     CHISD         ZIEND
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C                   Z-ADD     WHISB         HISB0
     C     HISB0         MULT      DAYS          NUMB0
      *
     C     WHISB         IFGT      *ZEROS                                       - B1
     C     CDAIC         SUB       WDAID         INTD0
     C                   Z-ADD     *ZEROS        INTC0
     C                   ELSE                                                   - X1
     C     CCAIC         SUB       WCAID         INTC0
     C                   Z-SUB     INTC0         INTC0
     C                   Z-ADD     *ZEROS        INTD0
     C                   END                                                    - E1
     C                   END                                                    - E1
      *
      * PREPARE C/F BALANCE
      * TRANSFER DATE MIDAS INTO DDMMMYY
     C     PVALD         IFNE      CHISD                                        - B1
     C                   MOVE      CHISD         PVALD
     C                   END                                                    - E1
      *
     C                   Z-ADD     CHISB         HISB0
      *
      * OUTPUT BALANCE C/F
     C     CHISB         IFGT      0                                            - B1
     C                   Z-ADD     CHISB         EVAMNT
     C     CHISD         SUB       WKCID         APRDAY
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
     C                   END
      *
      * PREPARE TOTAL OF CHARGES, COMMISSIONS, ETC.
     C                   Z-ADD     *ZERO         TINTD0
     C     CSDCI         IFEQ      'Y'
     C     CSDCI         OREQ      'I'
     C     CSDCI         OREQ      'A'
     C     CDAIC         ADD       FXDC          TINTD0
     C                   ADD       CDICA         TINTD0
     C                   ADD       CHDBC         TINTD0
     C                   ADD       CMBC          TINTD0
     C                   ADD       VATAM         TINTD0
     C                   ADD       CCINST        TINTD0
     C                   END
     C                   ADD       CSGADI        TINTD0
      *
      * OUTPUT TOTAL OF CHARGES, COMMISSION ETC.
     C     TINTD0        IFGE      0
     C                   Z-ADD     TINTD0        EVAMNT
     C                   MOVE      'O'           INOUT
     C                   ELSE
     C                   Z-SUB     TINTD0        EVAMNT
     C                   MOVE      'I'           INOUT
     C                   END
     C     CHISD         SUB       WKCID         APRDAY
     C                   EXSR      APROUT
      *
     C                   ENDSR                                                  **DRSR ENDSR**
      *
      **************************************************************************
     C/EJECT
      **************************************************************************
      * DETPR - Detail Processing                                              *
      *      Called by: MAIN                                                   *
      *      Calls....: DRSR, CRSR, DBSR                                       *
      **************************************************************************
      *
     C     DETPR         BEGSR                                                  **DETPR BEGSR**
      *
      * ACCESS ACCRACJ (ACCNTAB, REIACD, REACRD)
     C     KLIST1        CHAIN     ACCRACJ                            99
     C     *IN99         IFEQ      '1'                                          - B1
     C                   Z-ADD     11            DBASE                          ***************
     C                   MOVE      'ACCRACJ'     DBFILE                         **DB ERROR 11**
     C                   MOVEL     RKEY          DBKEY                          ***************
     C                   EXSR      DBSR
     C                   END                                                    - E1
      *
      * CHECK IF CURRENCY EXISTS
     C                   Z-ADD     1             I                 3 0
     C     CCCY          LOOKUP    CCYA(I)                                97
      *
     C     *IN97         IFEQ      *ZERO                                        - B1
     C                   Z-ADD     14            DBASE                          ***************
     C                   MOVE      'SDCURRPD'    DBFILE                         **DB ERROR 14**
     C                   MOVEL     CCCY          DBKEY                          ***************
     C                   EXSR      DBSR
     C                   END                                                    - E1
      *
     C                   MOVE      ACNO          WACNO
      *
      * DEFINE CAPITALISATION TO BE PROCESSED
      * Credit
     C     CCICI         IFNE      *BLANKS                                      - B1
      *
      * Clear the temporary file & rate calculation indicator
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD1
     C                   PARM      28            MSGLEN           15 5
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN64
      *
      * Clear 'I' & 'O' written flags
     C                   MOVE      '0'           *IN53
     C                   MOVE      '0'           *IN54
      *
     C                   EXSR      CRSR
      *
      * Get new APR rate if required
     C     *IN62         IFEQ      *ON                                          - B2
      *
      * If an amount has been written
     C     *IN64         IFEQ      *ON                                          - B3
     C                   MOVE      'C'           WKDRCR            1
     C                   EXSR      REAPR
     C                   ELSE
     C                   CLOSE     GLAPRCTD
     C                   END                                                    - E3
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
      * Debit
     C     CDICI         IFNE      *BLANKS                                      - B1
      *
      * Clear the temporary file & rate calculation indicator
     C                   CALL      'QCMDEXC'
     C                   PARM                    CMD1
     C                   PARM      28            MSGLEN           15 5
     C                   MOVE      *OFF          *IN62
     C                   MOVE      *OFF          *IN64
      * Clear 'I' & 'O' written flags
     C                   MOVE      '0'           *IN53
     C                   MOVE      '0'           *IN54
      *
     C                   EXSR      DRSR
      *
      * Get new APR rate if required
     C     *IN62         IFEQ      *ON                                          - B2
      *
      * If an amount has been written
     C     *IN64         IFEQ      *ON                                          - B3
     C                   MOVE      'D'           WKDRCR
     C                   EXSR      REAPR
     C                   ELSE
     C                   CLOSE     GLAPRCTD
     C                   END                                                    - E3
     C                   END                                                    - E2
     C                   END                                                    - E1
      *
     C                   ENDSR                                                  **DETPR ENDSR**
      **************************************************************************
     C/EJECT
      **************************************************************************
      * INIT - Initial processing                                              *
      *                                                                        *
      * Called by:                                                             *
      * Calls....: DBSR                                                        *
      **************************************************************************
      *
     C     INIT          BEGSR                                                  **INIT BEGSR**
      *
      * ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY                          ***************
     C                   MOVEL     @OPTN         DBOPTN            7            **DB ERROR 15**
     C                   Z-ADD     15            DBASE                          ***************
     C                   EXSR      DBSR
     C                   GOTO      ENDFST
     C                   END
      *
      * Access Retail Details.
     C                   CALL      'AORETLR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDRETL        PARM      SDRETL        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDRETLPD'    DBFILE                         ***************
     C                   MOVEL     @OPTN         DBKEY                          * DB ERROR 27 *
     C                   MOVEL     @OPTN         DBOPTN            7            ***************
     C                   Z-ADD     027           DBASE
     C                   OUT       LDA
     C                   EXSR      DBSR
     C                   GOTO      ENDFST
     C                   END
      *
      * INITIALISE WORK FIELDS
     C                   Z-ADD     *ZEROS        PVALD
     C                   Z-ADD     *ZEROS        DHISD
     C                   Z-ADD     *ZEROS        WHISD
     C                   Z-ADD     *ZEROS        DAYS
     C                   Z-ADD     *ZEROS        NUMB0            15 0
     C                   Z-ADD     *ZEROS        HISB0            15 0
     C                   Z-ADD     *ZEROS        INTD0            15 0
     C                   Z-ADD     *ZEROS        INTC0            15 0
     C                   Z-ADD     *ZEROS        TINTD0           15 0
     C                   Z-ADD     *ZEROS        TINTC0           15 0
     C                   Z-ADD     *ZEROS        ZICALC            2 0
     C                   Z-ADD     *ZEROS        WDAID
     C                   Z-ADD     *ZEROS        WCAID
      *
      * OPEN ICD TABLE FOR RETAIL
     C                   OPEN      TABTBRE
     C     1             CHAIN     TABTBRE                            99
      *
     C     *IN99         IFEQ      '1'                                          - B1
     C     RECI          ORNE      'D'
     C                   Z-ADD     16            DBASE                          ***************
     C                   MOVE      'TABTBRE'     DBFILE                         **DB ERROR 16**
     C                   MOVEL     *BLANKS       DBKEY                          ***************
     C                   EXSR      DBSR
     C                   END                                                    - E1
      *
      * CHECK IF CHARGES FOR MULTIPLE TRANSACTION IS PRESENT
     C     CMTR          IFEQ      'Y'                                          - B1
     C                   MOVE      '1'           *IN88
     C                   ELSE                                                   - X1
     C                   MOVE      '0'           *IN88
     C                   END                                                    - E1
      *
      * CHECK IF CAPITALISATION TO AN ACCOUNT IN DIFFERENT CURRENCY
      * AND MULTIBRANCH IS PRESENT
     C     CDFC          IFEQ      'Y'                                          - B1
     C                   MOVE      '1'           *IN87
     C                   ELSE                                                   - X1
     C                   MOVE      '0'           *IN87
     C                   END                                                    - E1
      *
     C                   CLOSE     TABTBRE
      *
      * CHECK FOR SWISS TAXES PRESENT
     C     1             SETLL     SDMMODPD
     C                   READ      SDMMODPD                               99
     C     *IN99         IFEQ      '1'                                          - B1
     C                   Z-ADD     17            DBASE                          ***************
     C                   MOVEL     'SDMMODPD'    DBFILE                         **DB ERROR 17**
     C                   MOVEL     'MMOD'        DBKEY                          ***************
     C                   EXSR      DBSR
     C                   END                                                    - E1
      *
      * Check date format
     C     DATF          COMP      'M'                                    98
      *
     C                   EXSR      CCYARR
      *
      * DEFINE CLRPFM COMMAND
     C                   MOVE      CMD(1)        CMD1             28
      *
     C     ENDFST        TAG
      *
     C                   ENDSR                                                  **INIT ENDSR**
     C**************************************************************************
     C/EJECT
     C**************************************************************************
      * ITYPCR - Process Interest Type > 2 - Credit                            *
      *                                                                        *
      *  Called by: CRSR                                                       *
      *  Calls....: ZICD                                                       *
      **************************************************************************
      *
     C     ITYPCR        BEGSR                                                  **ITYPCR BEGSR*
      *
      * CHECK IF END OF MONTH OR RATE CHANGE CREDIT
     C     DRECI         IFEQ      'M'                                          - B1
     C     CSDAT         ANDNE     *ZEROS
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     MHISD         ZIEND
     C                   Z-ADD     WCRCB         ZICALC
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C     MNBL          MULT      DAYS          NUMB0
      *
      * Write GLAPRCTD
     C     DHISD         SUB       MHISD         APRDAY
     C                   Z-ADD     CINT          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
      *
     C                   Z-ADD     MHISD         WHISD
     C                   Z-ADD     MNBL          WMNBL
      *
     C                   END                                                    - E1
      *
     C     DRECI         DOWEQ     'M'                                          - B1
     C     *IN51         ANDEQ     '0'
      *
     C     KLIST1        READE     REHISL                                 51
      *
     C     *IN51         IFNE      '1'                                          - B2
      *
     C     DRECI         IFEQ      'M'                                          - B3
     C     CSDAT         ANDNE     *ZEROS
      *
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     MHISD         ZIEND
     C                   Z-ADD     WCRCB         ZICALC
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C     MNBL          MULT      DAYS          NUMB0
      *
      * Write GLAPRCTD
     C     DHISD         SUB       MHISD         APRDAY
     C                   Z-ADD     CINT          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
      *
     C                   Z-ADD     MHISD         WHISD
     C                   Z-ADD     MNBL          WMNBL
      *
     C                   ELSE                                                   - X3
      *
     C     DRECI         IFEQ      'S'                                          - B4
     C     SCICI         ANDNE     *BLANKS
      *
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     DHISD         ZIEND
     C                   Z-ADD     WCRCB         ZICALC
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C     SMNBL         MULT      DAYS          NUMB0
      *
     C     SMNBL         IFGT      *ZEROS                                       - B5
     C                   Z-ADD     DINT          INTD0
     C                   ELSE                                                   - X5
     C                   Z-SUB     CINT          INTC0
      *                                                                T
      * Write GLAPRCTD
     C     DHISD         SUB       MHISD         APRDAY
     C                   Z-ADD     CINT          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
      *
     C                   END                                                    - E5
      *
     C                   Z-ADD     DHISD         WHISD
      *
     C                   END                                                    - E4
      *
     C                   END                                                    - E3
      *
     C                   END                                                    - E2
      *
     C                   END                                                    - E1
      *
     C                   ENDSR                                                  **ITYPCR ENDSR*
      **************************************************************************
     C/EJECT
      **************************************************************************
      * ITYPDR - Process Interest Type > 2 - Debit
      *
      *  Called by: DRSR
      *  Calls....: ZICD
      **************************************************************************
      *
     C     ITYPDR        BEGSR                                                  **ITYPDR BEGSR*
      *
      * CHECK IF END OF MONTH OR DEBIT RATE CHANGE
     C     DRECI         IFEQ      'M'                                          - B1
     C     DSDAT         ANDNE     *ZEROS
      *
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     MHISD         ZIEND
     C                   Z-ADD     WDRCB         ZICALC
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C     MNBL          MULT      DAYS          NUMB0
      *
     C     MNBL          IFGT      *ZEROS                                       - B2
     C                   Z-ADD     DINT          INTD0
     C                   ELSE                                                   - X2
     C                   Z-SUB     CINT          INTC0
      *
      * Write GLAPRCTD
     C     DHISD         SUB       MHISD         APRDAY
     C                   Z-ADD     DINT          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
      *
     C                   END                                                    - E2
      *
     C                   Z-ADD     MHISD         WHISD
     C                   Z-ADD     MNBL          WMNBL
     C                   END                                                    - E1
      *
     C     DRECI         DOWEQ     'M'                                          - B1
     C     *IN51         ANDEQ     '0'
      *
     C     KLIST1        READE     REHISL                                 51
      *
     C     *IN51         IFNE      '1'                                          - B2
      *
     C     DRECI         IFEQ      'M'                                          - B3
     C     DSDAT         ANDNE     *ZEROS
      *
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     MHISD         ZIEND
     C                   Z-ADD     WDRCB         ZICALC
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C     MNBL          MULT      DAYS          NUMB0
      *
      * Write GLAPRCTD
     C     DHISD         SUB       MHISD         APRDAY
     C                   Z-ADD     DINT          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
      *
     C                   Z-ADD     MHISD         WHISD
     C                   Z-ADD     MNBL          WMNBL
      *
     C                   ELSE                                                   - X3
      *
     C     DRECI         IFEQ      'S'                                          - B4
     C     SDICI         ANDNE     *BLANKS
      *
     C                   Z-ADD     WHISD         ZIBEG
     C                   Z-ADD     DHISD         ZIEND
     C                   Z-ADD     WDRCB         ZICALC
     C                   EXSR      ZICD
     C                   Z-ADD     ZDAYN1        DAYS
     C     SMNBL         MULT      DAYS          NUMB0
      *
      * Write GLAPRCTD
     C     DHISD         SUB       MHISD         APRDAY
     C                   Z-ADD     DINT          EVAMNT
     C                   MOVE      'O'           INOUT
     C                   EXSR      APROUT
      *
     C                   Z-ADD     DHISD         WHISD
     C                   END                                                    - E4
      *
     C                   END                                                    - E3
      *
     C                   END                                                    - E2
      *
     C                   END                                                    - E1
      *
     C                   ENDSR                                                  **ITYPDR ENDSR*
     C**************************************************************************
     C/EJECT
     C**************************************************************************
      * MAIN - Main Processing                                                 *
      *                                                                        *
      *  Called by: MAINLINE                                                   *
      *  Calls....: DETPR                                                      *
      **************************************************************************
      *
     C     MAIN          BEGSR                                                  **MAIN BEGSR**
      *
     C     *INLR         IFEQ      '1'
     C                   GOTO      END
     C                   END
      *
      * ACCESS RECAPM SEQUENTIALY
     C                   READ      RECAPML                                LR
      *
      * SAVE KEY TO CHECK BREAK
     C                   MOVE      RKEY          OKEY
      *
      * EXECUTE UNTIL EOF RECAPM
     C     *INLR         DOWEQ     '0'                                          - B1
      *
     C                   EXSR      PRNO
     C     *IN70         IFEQ      *OFF                                         - B2
      *
      * CHECK IF IT IS THE SAME ACCOUNT
     C     RKEY          IFNE      OKEY                                         - B3
     C                   MOVE      RKEY          OKEY
     C                   END                                                    - E3
      *
     C                   EXSR      DETPR
     C                   END                                                    - E2
      *
      * RESET OVERFLOW INDICATOR AT CHANGE OF ACCOUNT
     C                   MOVE      '0'           *IN51
     C                   Z-ADD     *ZEROS        WDAID
     C                   Z-ADD     *ZEROS        WCAID
     C                   READ      RECAPML                                LR
     C                   END                                                    - E1
      *
     C     END           TAG
      *
     C                   ENDSR                                                  **MAIN ENDSR**
      **************************************************************************
     C/EJECT
      **************************************************************************
      * PRNO - Determine whether or not to process record                      *
      *                                                                        *
      *  Called by: START                                                      *
      *  Calls....:                                                            *
      **************************************************************************
      *
     C     PRNO          BEGSR                                                  **PRNO   BEGSR*
      *
     C                   MOVE      '0'           *IN70
      *
      * DO NOT PROCESS MANAGEMENT STATEMENT REQUESTS
     C     CDICI         IFEQ      'M'                                          - B1
     C     CCICI         OREQ      'M'
     C                   MOVE      '1'           *IN70
     C                   END                                                    - E1
      *
      * ACCESS RECOM FOR COMMISSION DETAILS
     C     KLIST0        CHAIN     RECOM                              99
     C     *IN99         IFEQ      '1'                                          ***************
     C                   Z-ADD     21            DBASE                          **DB ERROR 21**
     C                   MOVE      'RECOM  '     DBFILE                         ***************
     C                   MOVEL     RKEY          DBKEY
     C                   EXSR      DBSR
     C                   END
     C     CDICI         IFEQ      'C'
     C     CDICI         OREQ      ' '
     C                   Z-ADD     *ZERO         FXDC
     C                   END
     C     CDICA         SUB       CCDIC         CDICA
     C     ACCC          SUB       CACCC         ACCC
     C     CHDBC         SUB       CCHDBC        CHDBC
     C     CMBC          SUB       CCMBC         CMBC
      *
     C                   ENDSR                                                  **NOPR   ENDSR*
      /EJECT
      **************************************************************************
      *                                                                        *
      * CCYARR - Set up an array of currencies and an array of decimal         *
      *          places for those currencies                                   *
      *                                                                        *
      **************************************************************************
      *
     C     CCYARR        BEGSR                                                  *** CCYARR  ***
      *
      * SET OFF ERROR INDICATOR
     C                   SETOFF                                       99
      *
      * SET ARRAY INDEX TO ZERO.
     C                   Z-ADD     0             X                 3 0
      *
      * SET UP KEY FOR CURRENCY TABLE.
     C                   MOVE      *BLANKS       W@CKEY            3
      *
      * SET LOWER LIMIT AND READ CURRENCY TABLE HEADER.
     C     W@CKEY        SETLL     SDCURRL0
      *
      * LOOP TO READ CURRENCY DETAIL RECORDS.
     C     XLOOP         TAG                                                    ** XLOOP TAG **
     C                   READ      SDCURRL0                               99
      *
      * END IF ALL CURRENCY RECORDS PROCESSED
     C   99              GOTO      XEND
      *
      * INCREMENT ARRAY INDEX.
     C     X             ADD       1             X
      *
      * MOVE DATA INTO ARRAYS.
     C                   MOVE      A6CYCD        CCYA(X)
     C                   MOVE      A6NBDP        DPA(X)
      *
      * CHECK FOR FULL ARRAY.96 ON IF FULL.
     C     X             COMP      200                                    96
      *
      * GO TO READ NEXT RECORD.
     C  N96              GOTO      XLOOP
      *
     C     XEND          TAG                                                    ** XEND TAG  **
     C                   ENDSR
      *
      **************************************************************************
     C/EJECT
      **************************************************************************
      * ZICD - Find number of days to calculate interest according
      *        to calculation basis
      *
      *  Called by: CRSR, DAYTSR, DRSR, ITYPCR, ITYPDR
      *  Calls....: DBSR
      **************************************************************************
      *
     C     ZICD          BEGSR                                                  **ZICD BEGSR**
      *
      * TO DETERMINE NUMBER OF DAYS INTEREST TO BE CALCULATED
     C     ZIEND         SUB       ZIBEG         ZDAYN1
      *
      * CHECK FOR INTEREST CALCULATION BASIS
     C     ZICALC        IFEQ      3                                            - B1
     C     ZIEND         IFGT      ZIBEG                                        - B2
      *
      * CALCULATING DATE FROM DAY NUMBER (BEGINNING DATE)
     C                   Z-ADD     ZIBEG         ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         SRES
      *
      * CALCULATING DATE FROM DAY NUMBER (FINISHING DATE)
     C                   Z-ADD     ZIEND         ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         FRES
      *
      * IN ORDER FOR THE FINISH YEAR TO BE LESS THAN THE START YEAR IF ZIEND
      * IS GREATER THAN ZIBEG, THEN THE DATE ZIEND MUST BE IN A DIFFERENT
      * CENTURY TO ZIBEG. IF SO ADD 100 YEARS TO IT.
     C     ZIFY          IFLT      ZISY                                         - B3
     C     ZIFY          ADD       100           ZIFY2             3 0
     C                   ELSE                                                   - X3
     C                   Z-ADD     ZIFY          ZIFY2
     C                   END                                                    - E3
     C                   Z-ADD     ZISY          ZISY2             3 0
      *
      * DETERMINE WHETHER START YEAR IS A LEAP YEAR AND IF START MONTH
      * IS FEBRUARY THEN CONSIDER LAST DAY OF FEBRUARY AS DATE 30ND. OF THE
      * MONTH
     C     ZISM          IFEQ      2                                            - B3
     C     ZISY2         ADD       1900          ZLYCHK            4 0
     C     ZLYCHK        DIV       4             ZLYCHK
     C                   MVR                     ZLYREM            2 0
     C     ZLYREM        IFEQ      0                                            - B4
     C     ZISD          IFEQ      29                                           - B5
     C                   Z-ADD     30            ZISD
     C                   END                                                    - E5
     C                   ELSE                                                   - X4
     C     ZISD          IFEQ      28                                           - B5
     C                   Z-ADD     30            ZISD
     C                   END                                                    - E5
     C                   END                                                    - E4
     C                   END                                                    - E3
      *
     C     30            SUB       ZISD          ZID1
      *
     C     ZID1          IFLT      0                                            - B3
     C                   Z-ADD     *ZEROS        ZID1
     C                   END                                                    - E3
      *
     C     ZISM          IFEQ      12                                           - B3
     C                   Z-ADD     *ZEROS        ZISM
     C                   ADD       1             ZISY
     C                   ADD       1             ZISY2
     C                   END                                                    - E3
      *
      * DETERMINE WHETHER END YEAR IS A LEAP YEAR AND IF END MONTH IS FEBRUARY
     C     ZIFM          IFEQ      2                                            - B3
     C     ZIFY2         ADD       1900          ZLYCHK            4 0
     C     ZLYCHK        DIV       4             ZLYCHK
     C                   MVR                     ZLYREM            2 0
     C     ZLYREM        IFEQ      0                                            - B4
     C     ZIFD          IFEQ      29                                           - B5
     C                   Z-ADD     30            ZIFD
     C                   END                                                    - E5
     C                   ELSE                                                   - X4
     C     ZIFD          IFEQ      28                                           - B5
     C                   Z-ADD     30            ZIFD
     C                   END                                                    - E5
     C                   END                                                    - E4
     C                   END                                                    - E3
      *
     C     ZIFD          IFEQ      31                                           - B3
     C                   ADD       30            ZID1
     C                   ELSE                                                   - X3
     C                   ADD       ZIFD          ZID1
     C                   END                                                    - E3
      *
     C                   SUB       1             ZIFM
      *
     C     ZISY          IFEQ      ZIFY                                         - B3
     C     ZIFM          SUB       ZISM          ZINOM             3 0
     C                   ELSE                                                   - X3
     C     12            SUB       ZISM          ZIM1
     C                   Z-ADD     1             ZISM
      *
      * USE ENLARGE FIELDS THAT CAN HANDLE 1999 ONWARDS
     C                   ADD       1             ZISY2
     C     ZIFY2         SUB       ZISY2         ZIY1
     C     ZIY1          MULT      12            ZIM2              3 0
     C     ZIM2          ADD       ZIFM          ZIM2
     C     ZIM2          ADD       ZIM1          ZINOM
      *
     C                   END                                                    - E3
      *
     C     ZINOM         MULT      30            ZID2
     C     ZID2          ADD       ZID1          ZDAYN1
      *
     C                   END                                                    - E2
      *
     C                   END                                                    - E1
      *
     C     ZICALC        IFEQ      4                                            - B1
     C     ZICALC        OREQ      5
      *
      * ONE DAY IS SUBTRACTED FROM ZDAYN1 FOR EACH OCCURANCE OF 29 FEB IN THE
      * THE INTEREST CALCULATION PERIOD INCLUSIVE OF ZIBEG AND ZIEND
      *
      * FIND NO OF FOUR YEAR PERIODS BETWEEN DATES
     C     ZDAYN1        DIV       1461          ZIMAN
     C                   MVR                     ZIREM
      *
      * FIND NEXT 29 FEB DAY NO. ON OR AFTER ZIBEG.
     C     ZIBEG         SUB       60            ZIBW1
     C     ZIBW1         DIV       1461          ZIDW1
     C                   MVR                     ZIDREM
      *
     C     ZIDREM        IFEQ      0                                            - B2
     C                   Z-ADD     ZIBEG         ZIDW2
     C                   END                                                    - E2
      *
      * ROUND UP RESULT
     C     ZIDW1         ADD       1             ZIDW2
      *
      * CALCULATE NEXT 29 FEB.
     C     ZIDW2         MULT      1461          ZIDW2
     C     ZIDW2         ADD       60            ZIDW2
      *
      * IF THIS NEXT 29 FEB. DAYNO - ZIBEG IS GREATER OR EQUAL TO ZIREM THEN
      * ADD 1 TO ZIMAN.
     C     ZIDW2         SUB       ZIBEG         ZILPCP
      *
     C     ZIREM         IFGE      ZILPCP                                       - B2
     C                   ADD       1             ZIMAN
     C                   END                                                    - E2
      *
      * SUBTRACT ZIMAN FROM ZDAYN1 TO GIVE VALUE OF ZDAYN1 REQUIRED FOR THIS
      * INTEREST CALCULATION
     C     ZDAYN1        SUB       ZIMAN         ZDAYN1
      *
     C                   END                                                    - E1
      *
     C                   ENDSR                                                  **ZICD ENDSR**
      **************************************************************************
      * APROUT - Output flow of funds records to file GLAPRCTD                 *
      *                                                                        *
      *  Called by:                                                            *
      *  Calls....:                                                            *
      **************************************************************************
      *
     C     APROUT        BEGSR                                                  **APROUT**
      *
      * Record an 'I' being written
     C     INOUT         IFEQ      'I'
     C                   MOVE      '1'           *IN53
     C                   END
      *
      * Record an 'O' being written after an 'I'
     C     INOUT         IFEQ      'O'
     C     *IN53         ANDEQ     '1'
     C                   MOVE      '1'           *IN54
     C                   END
      *
      * OUTPUT RECORD TO FILE GLAPRCTD IF 'INOUT' NOT BLANK and
      * THE AMOUNT IS NOT ZERO, IF 'O' an 'I' must first be written
     C     INOUT         IFEQ      'I'
     C     EVAMNT        ANDNE     0
     C     INOUT         OREQ      'O'
     C     EVAMNT        ANDNE     0
     C     *IN53         ANDEQ     '1'
      *
      * OPEN THE FILE IF *IN62 IS OFF
     C     *IN62         IFEQ      *OFF
     C                   OPEN      GLAPRCTD
     C                   END
     C                   MOVE      *ON           *IN64
     C                   MOVE      INOUT         APRTYP
     C                   MOVE      EVAMNT        APRAMT
     C                   WRITE     GLAPRCD0
     C                   MOVE      *ON           *IN62
     C                   END
      *
     C                   ENDSR
      **************************************************************************
      * REAPR - Calculate New APR Rate & update file
      *
      *  Called by: DETPR
      *  Calls....:
      **************************************************************************
      *
     C     REAPR         BEGSR                                                  **REAPR **
      *
      * When all data written to GLAPRCTD, call GL000050 to get rate
     C                   CLOSE     GLAPRCTD
      *
      * Only call if both 'I' and 'O' written
     C     *IN53         IFEQ      '1'
     C     *IN54         ANDEQ     '1'
      *
      * Set day number basis
      *
     C     WKDRCR        Ifeq      'D'
     C                   Move      WDRCB         ICBS              1 0
     C                   Else
     C                   Move      WCRCB         ICBS
     C                   Endif
      *
     C     ICBS          Ifeq      1
     C     ICBS          oreq      4
     C                   MOVE      '365'         AEDNB
     C                   Endif
     C     ICBS          Ifeq      2
     C     ICBS          oreq      3
     C     ICBS          oreq      5
     C     ICBS          oreq      7
     C                   MOVE      '360'         AEDNB
     C                   Endif
     C     ICBS          Ifeq      6
     C                   MOVE      '366'         AEDNB
     C                   Endif
      *
     C                   EVAL      AERATE = *BLANKS                                      MD054017
     C                   IF        SYSVAL1 = 'Y' AND SYSVAL2 <> *BLANKS                  MD054017
     C                   EVAL      SYSVAL2A = *BLANKS                                    MD054017
     C                   EVAL      SYSVAL2A = %XLATE(LO:UP:SYSVAL2)                      MD054017
     C                   IF        SYSVAL2A = 'SPAIN'                                    MD054017
      *                                                                                  MD054017
     C                   CALL      'GL000050'
     C                   PARM      *BLANKS       AERATE            6
     C                   PARM                    AEDNB             3
     C                   ENDIF                                                           MD054017
     C                   ENDIF                                                           MD054017
      *
      * Clear 'I' & 'O' written flags
     C                   MOVE      '0'           *IN53
     C                   MOVE      '0'           *IN54
      *
     C                   MOVEL     AERATE        AERATM            1
     C                   MOVE      AERATE        AERATF            5 0
     C     AERATM        IFEQ      '-'                                          -ve rate
     C                   Z-SUB     AERATF        AERATN
     C                   ELSE
     C                   MOVE      AERATE        AERATN            6 0
     C                   END
     C     AERATN        DIV       100           NAERAT            6 2
      *
      * Only write new rate if different to last or no last exists
      * Access rates history file using correct logical
     C     WKDRCR        IFEQ      'D'
     C     KLIST4        SETLL     REAPRHD0
     C                   READ      REAPRHD0                               63
     C                   ELSE
     C     KLIST4        SETLL     REAPRHD1
     C                   READ      REAPRHD1                               63
     C                   END
     C     *IN63         IFNE      '0'                                          if found
     C                   Z-ADD     0             IACNO
     C                   ENDif
     C     *IN63         IFEQ      '1'                                          not found or
     C     *IN63         OREQ      '0'                                          same loan &
     C     ACNO          ANDEQ     IACNO                                        date
     C     RUND          ANDEQ     IAPRD                                        different
     C     NAERAT        ANDNE     IAPRR                                        rate
     C     *IN63         OREQ      '0'
     C     ACNO          ANDEQ     IACNO
     C     RUND          ANDNE     IAPRD
     C     *IN63         OREQ      '0'
     C     ACNO          ANDNE     IACNO
      *
      * Add sequence number
     C     *IN63         IFEQ      '1'
     C     ACNO          ORNE      IACNO
     C     RUND          ORNE      IAPRD
     C                   Z-ADD     1             ITSEQ
     C                   ELSE
     C                   ADD       1             ITSEQ
     C                   END
      *
      * Write new rate
     C                   MOVE      ACNO          IACNO
     C                   Z-ADD     RUND          IAPRD
     C                   Z-ADD     NAERAT        IAPRR
     C                   MOVE      WKDRCR        IDRCR
     C                   WRITE     REAPRHD2
     C                   END
      *
     C                   ENDIF
     C                   ENDSR
      **************************************************************************
      * *PSSR - Subroutine to handle abnormal conditions                       *
      *                                                                        *
      * Called by: ANUYR ABNORNAL OPERATION OCCURS                             *
      * Calls....:                                                             *
      **************************************************************************
      *
     C     *PSSR         BEGSR                                                  ** *PSSR **
      *
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   SETON                                        U7U8LR
      *
     C                   ENDSR                                                  ** *PSSR **
      **************************************************************************
     C/COPY ZSRSRC,ZDATE2Z2LE
**   CMD - COMMAND TO CLEAR WORKFILE
CLRPFM  FILE(QTEMP/GLAPRCTD)
**  CPY@
(c) Copyright Finastra International Limited 2016
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
