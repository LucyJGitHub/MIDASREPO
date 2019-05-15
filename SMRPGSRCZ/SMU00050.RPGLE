     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2007')
      *****************************************************************
/*XBI *  OVRDBF FILE(STRANTEMP) TOFILE(STRAN)                         *
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SM Update LEADINPD from STRAN')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Implementation module                                *
      *                                                               *
      *  SMU00050 - Update LEADINPD from STRAN                        *
      *                                                               *
      *  (c) Finastra International Limited 2007                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BG26993            Date 26Jan10               *
      *                 CSD026             Date 30Apr07               *
      *                 CPK025  *CREATE    Date 12Apr07               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  BG26993 - Delivery of upgrade programs to core.              *
      *          - Renamed program CPK025R01.                         *
      *  CSD026  - Changes for alphanumeric customer numbers.         *
      *  CPK025  - MidasPlus 1.3 packaging.                           *
      *                                                               *
      *****************************************************************
     FLEADINL1  UF A E           K DISK    INFSR(*PSSR)
     FSTRANTEMP IF   E             DISK    INFSR(*PSSR) PREFIX(YY)
     FSDCUSTL0  IF   E           K DISK    INFSR(*PSSR)
     FCLOAN     IF   E           K DISK    INFSR(*PSSR) PREFIX(XX)
     F                                     IGNORE(CLOANHHF:CLOANCKF:CLOANZ1F)
      *
      /EJECT
     D                 DS
     D STRANLayout             1    210
     D  RecordId               1      1
     D  Loan                   2      7
     D**LoanN***               2      7  0                                                    CLE148
     D  LoanN                  2      7                                                       CLE148
     D  Customer               8     13
     D  CustomerN              8     13  0
     D  Currency              14     16
     D  AdjAmount             17     23P 0
     D  AdjSign               24     24
     D  Branch                25     27
     D  FacilityCust          28     33
     D  FacilityCustN         28     33  0
     D  FacilitySeq           34     36
     D  AdjtoAccCoF           69     75P 0
     D  AdjtoAccCoFS          76     76
     D  AdjfNetTRate          77     83P 0
     D  AdjfNetTRateS         84     84
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
     D WorkADJA        S                   LIKE(AdjAmount)
     D WorkACAJ        S                   LIKE(AdjtoAccCoF)
     D WorkMAAN        S                   LIKE(AdjfNetTRate)
     D RelRecNo        S              5  0 INZ(1)
     D RelRecNo2       S                   LIKE(RelRecNo)
     D CurrentLoan     S                   LIKE(LoanN)
     D KLoan           S                   LIKE(LoanN)
     D KRecType        S              1    INZ('A')
     D Recursive       S              1    INZ('N')
      *
     C     CLOANKey      KLIST
     C                   KFLD                    KLoan
     C                   KFLD                    KRecType
      *
      * Populate LEADINPD fields that will be the same for all records.
     C                   EVAL      RECI = 'D'
     C                   EVAL      ASTS = 'A'
     C                   EVAL      CHTP = 'I'
     C                   EVAL      AMTP = 'MI'
      *
     C     RelRecNo      SETLL     STRANF
     C                   READ      STRANF
      *
     C                   DOW       NOT %EOF
      *
     C                   EVAL      STRANLayout = YYRECI + YYZZ199
     C     LoanN         CHAIN     LEADINL1
     C                   IF        NOT(%FOUND)
     C                   EXSR      FindSameLoans
     C                   ENDIF
      *
     C                   EVAL      RelRecNo = RelRecNo + 1
     C     RelRecNo      SETLL     STRANF
     C                   READ      STRANF
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  FindSameLoans - Find records with the same loan number.      *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     FindSameLoans BEGSR
      *
     C                   EVAL      WorkADJA = 0
     C                   EVAL      WorkACAJ = 0
     C                   EVAL      WorkMAAN = 0
      *
      *  Build up data to be written.
     C                   EVAL      LNRF = LoanN
     C**********         EVAL      CNUM = CustomerN                                           CSD026
     C                   EVAL      CNUM = Customer                                            CSD026
     C                   EVAL      CCY  = Currency
      * Identify customer details.
     C                   EXSR      CustomerDtls
      * Identify loan details.
     C                   EXSR      LoanDtls
      *
      * Put amounts into work fields.
     C                   IF        AdjSign = '+'
     C                   EVAL      WorkADJA = WorkADJA + AdjAmount
     C                   ELSE
     C                   EVAL      WorkADJA = WorkADJA - AdjAmount
     C                   ENDIF
     C                   IF        AdjtoAccCoFS = '+'
     C                   EVAL      WorkACAJ = WorkACAJ + AdjtoAccCoF
     C                   ELSE
     C                   EVAL      WorkACAJ = WorkACAJ - AdjtoAccCoF
     C                   ENDIF
     C                   IF        AdjfNetTRateS = '+'
     C                   EVAL      WorkMAAN = WorkMAAN + AdjfNetTRate
     C                   ELSE
     C                   EVAL      WorkMAAN = WorkMAAN - AdjfNetTRate
     C                   ENDIF
      *
      * Loop through the rest of STRAN looking for identical loan and
      *  calculate amounts.
     C                   EVAL      RelRecNo2 = RelRecNo + 1
     C     RelRecNo2     SETLL     STRANF
     C                   READ      STRANF
      *
     C                   DOU       %EOF
      *
     C                   EVAL      STRANLayout = YYRECI + YYZZ199
     C                   IF        LoanN = LNRF
     C                   IF        AdjSign = '+'
     C                   EVAL      WorkADJA = WorkADJA + AdjAmount
     C                   ELSE
     C                   EVAL      WorkADJA = WorkADJA - AdjAmount
     C                   ENDIF
     C                   IF        AdjtoAccCoFS = '+'
     C                   EVAL      WorkACAJ = WorkACAJ + AdjtoAccCoF
     C                   ELSE
     C                   EVAL      WorkACAJ = WorkACAJ - AdjtoAccCoF
     C                   ENDIF
     C                   IF        AdjfNetTRateS = '+'
     C                   EVAL      WorkMAAN = WorkMAAN + AdjfNetTRate
     C                   ELSE
     C                   EVAL      WorkMAAN = WorkMAAN - AdjfNetTRate
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      STRANF
     C                   ENDDO
      *
     C                   EXSR      WriteLEADINPD
      *
     C     FindSameLoansEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  WriteLEADINPD - Write record to LEADINPD                     *
      *                                                               *
      *  Called by: FindSameLoans                                     *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     WriteLEADINPD BEGSR
      *
      * Write final amounts.
     C                   IF        WorkADJA < 0
     C                   EVAL      ADJA = WorkADJA * -1
     C                   EVAL      ADJS = '-'
     C                   ELSE
     C                   EVAL      ADJA = WorkADJA
     C                   EVAL      ADJS = '+'
     C                   ENDIF
     C                   IF        WorkACAJ < 0
     C                   EVAL      ACAJ = WorkACAJ * -1
     C                   EVAL      CASN = '-'
     C                   ELSE
     C                   EVAL      ACAJ = WorkACAJ
     C                   EVAL      CASN = '+'
     C                   ENDIF
     C                   IF        WorkMAAN < 0
     C                   EVAL      MAAN = WorkMAAN * -1
     C                   EVAL      MASN = '-'
     C                   ELSE
     C                   EVAL      MAAN = WorkMAAN
     C                   EVAL      MASN = '+'
     C                   ENDIF
      *
     C                   WRITE     LEADINP0
      *
     C     WriteLEADINPDEENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  CustomerDtls - Get customer details.                         *
      *                                                               *
      *  Called by: FindSameLoans                                     *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     CustomerDtls  BEGSR
      *
     C     Customer      CHAIN     SDCUSTL0
      *
     C                   IF        NOT(%FOUND)
     C                   EVAL      DBASE = 001
     C                   EVAL      DBFILE = 'SDCUSTL0'
     C                   EVAL      DBKEY = Customer
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      CRNM = BBCRNM
     C                   EVAL      CTWN = BBCRTN
     C                   ENDIF
      *
     C     CustomerDtlsE ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *  LoanDtls - Get loan details.                                 *
      *                                                               *
      *  Called by: FindSameLoans                                     *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     LoanDtls      BEGSR
      *
     C                   EVAL      KLoan = LoanN
     C     CLOANKey      CHAIN     CLOANCLF
      *
     C                   IF        NOT(%FOUND)
     C                   EVAL      DBASE = 002
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EVAL      DBKEY = Loan +'A'
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      BRCA = XXBRCA
     C                   EVAL      FCUS = XXFCUS
     C                   EVAL      FTYP = XXFTYP
     C                   EVAL      FSEQ = XXFSEQ
     C                   ENDIF
      *
     C     LoanDtlsE     ENDSR
      *
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = 'N'
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
