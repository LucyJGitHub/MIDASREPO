     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Retrieval of Stamp Tax Rate')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008140 - Stamp Tax Rate Retrieval                          *
      *                                                               *
      *  Function: Will access the Stamp Tax Defaults by Business     *
      *            Type and Stamp Tax Installation Control files      *
      *            returning Stamp Tax Rates, Stamp Tax Currencies    *
      *            and for Securities, the Security Charge Code.      *
      *                                                               *
      *  (c) Copyright Finastra International Limited 2010            *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR853257           Date 04Nov11               *
      *                 AR821972           Date 07Sep11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR853257 - Account Keys for FT were not generated            *
/*    *  AR821972 - Stamp tax on debit interest did not generate      *
/*    *             amount in GLVCLSIN                                *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
     FSDSTPTL1  IF   E           K DISK
     FSDSTPDL1  IF   E           K DISK
     FSDSTMDL1  IF   E           K DISK
      *****************************************************************
      *
      ** Array containing Copyright statement
      *
     D/COPY ZSRSRC,ZDATE2Z1LE
     D A@CPY           DS
      * Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D LDA           E DS           256    EXTNAME(LDA)
     D  W24          E                     EXTFLD(SPARE)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D PSDS           SDS
      *
      ** Program Status Data Structure - gives Job/Workstation name and
      ** User ID
      *
     D  ##PGM            *PROC
     D  JOB                  244    253
     D  WSID                 244    246
     D  USER                 254    263
      *
     D                 DS                  INZ
     D  U#DMY                  1      6  0
     D  U#DD                   1      2  0
     D  U#MM                   3      4  0
     D  U#YY                   5      6  0
     D                 DS                  INZ
     D  U#INDT                 1      6  0
     D  U#D                    1      2  0
     D  U#M                    3      4  0
     D  U#Y                    5      6  0
     D                 DS                  INZ
     D  @TYPE                  1      4
     D  @@TYPE                 1      2
     D  @@STYP                 3      4
      *
      ** Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Parameter fields
      *
     D U#DATE          S              5  0
     D U#MOD           S             10
     D U#TYPE          S             10
     D U#CTAX          S             13  8
     D U#MTAX          S             13  8
     D U#CCCY          S              3
     D U#MCCY          S              3
     D U#CSCC          S              2
     D U#MSCC          S              2
     D U#TXTY          S              1
     D ULRTCD          S              7
     D ULOPTN          S              7
      *
      ** Work fields
      *
     D U#INDN          S              5  0
     D U#RDNB          S              5  0
     D @RUN            S              1
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      ** Initialise data
      *
     C                   EXSR      SRINIT
      *
      ** CONTROL RATE
      ** ------------
      ** Obtain Current Contol Rate if its effective date is earlier or equal to
      ** input date
      ** Control Stamp Tax Defaults kept on SDSTPTPD
      *
     C                   MOVEL     'CONTROL'     A1KEY
     C     A1KEY         CHAIN     SDSTPTL1                           80
      *
     C     *IN80         IFEQ      *OFF
     C*****A1EDTE        ANDLE     U#DATE                                                   AR853257
     C     A1EDTE        ANDLE     U#INDN                                                   AR853257
      *
      ** If a security, obtain the Security Stamp Tax Rate and the
      ** Security Charge Code, otherwise just obtain the Stamp Tax Rate
      *
     C     U#MOD         IFEQ      'SECURITY'
     C     U#MOD         OREQ      'POSSET'
     C                   MOVE      A1SERT        U#CTAX
     C                   MOVE      A1SECC        U#CSCC
     C                   ELSE
     C                   MOVE      A1STRT        U#CTAX
     C                   ENDIF
     C                   MOVE      A1STCY        U#CCCY
      *
     C                   ENDIF
      *
      **  If Rate is zero, then retrieve valid CONTROL rate from historic file
      **  where effective date is earlier or equal to input date
      *
     C     U#CTAX        IFEQ      *ZEROS
     C     U#CCCY        ANDEQ     *BLANKS
      *
     C                   MOVEL     'CONTROL'     T2KEY
     C                   MOVE      'R'           T2RCTP
     C                   MOVE      U#DATE        T2CDTE
      *
     C     KLIST1        SETGT     SDSTMDL1
     C     KLISTE        READPE    SDSTMDL1                               80
     C     *IN80         IFEQ      *OFF
     C                   MOVE      T2TXRT        U#CTAX
     C                   MOVE      T2SCCY        U#CCCY
                                                                                            AR853257
     C     U#MOD         IFEQ      'SECURITY'                                               AR853257
     C     U#MOD         OREQ      'POSSET'                                                 AR853257
     C                   MOVE      T2SERT        U#CTAX                                     AR853257
     C                   MOVEL     T2SECC        U#CSCC                                     AR853257
     C                   ENDIF                                                              AR853257
                                                                                            AR853257
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** TRANSACTION TYPE RATE
      * ---------------------
      *
      ** Retrieve the Rate defined for the transaction type/subtype or account or
      ** at the input date. Retrieval is done on the Stamp tax rate file first
      *
     C                   MOVEL     U#MOD         A3KEY
     C     U#MOD         IFEQ      'DEAL'
     C                   MOVE      @@TYPE        A3DTYP
     C                   MOVE      @@STYP        A3DSTP
     C                   SETON                                        50
     C                   ENDIF
     C     U#MOD         IFEQ      'LOAN'
     C                   MOVE      @@TYPE        A3LTYP
     C                   MOVE      @@STYP        A3LSTP
     C                   SETON                                        50
     C                   ENDIF
     C     U#MOD         IFEQ      'FACILITY'
     C                   MOVE      U#TYPE        A3FTYP
     C                   SETON                                        50
     C                   ENDIF
     C     U#MOD         IFEQ      'RETAIL  '
     C                   MOVE      U#TYPE        A3ACCD
     C                   SETON                                        50
     C                   ENDIF
     C     U#MOD         IFEQ      'FEE'
     C                   MOVE      U#TYPE        A3LFTP
     C                   SETON                                        50
     C                   ENDIF
     C     KLIST2        CHAIN     SDSTPDL1                           80
      *
      ** If record exists and effective date is earlier equal to input date
      *
     C     *IN80         IFEQ      *OFF
     C*****A3EDTE        ANDLE     U#DATE                                                   AR853257
     C     A3EDTE        ANDLE     U#INDN                                                   AR853257
      *
      ** If a security, obtain the Security Stamp Tax Rate and the
      ** Security Charge Code, otherwise just obtain the Stamp Tax Rate
      *
     C     U#MOD         IFEQ      'SECURITY'
     C     U#MOD         OREQ      'POSSET'
     C                   MOVE      A3SERT        U#MTAX
     C                   MOVE      A3SECC        U#MSCC
     C                   END
      *
     C     U#MOD         IFNE      'SECURITY'
     C     U#MOD         ANDNE     'POSSET'
      *
     C                   MOVE      A3STRT        U#MTAX
     C                   MOVE      A3STCY        U#MCCY
      *
      ** ..if Balance rate is required, set balance rate if this is different
      **   from tax rate
      *
     C     U#TXTY        IFEQ      'B'
     C     A3STRB        ANDGT     0
     C                   MOVE      A3STRB        U#MTAX
     C                   ENDIF
      *
     C                   END
      *
     C                   ENDIF
      *
      ** If Stamp Tax rate is zero and module is RETAIL, then check
      **    whether a record exists with account code = blank
      *
     C     U#MTAX        IFEQ      *ZEROS
     C     U#MCCY        ANDEQ     *BLANKS
     C     U#MOD         ANDEQ     'RETAIL  '
     C                   MOVE      *BLANKS       A3ACCD
     C                   SETON                                        50
     C     KLIST2        CHAIN     SDSTPDL1                           80
      *
      ** If record exists and effective date is earlier equal to input date
      *
     C     *IN80         IFEQ      *OFF
     C*****A3EDTE        ANDLE     U#DATE                                                   AR853257
     C     A3EDTE        ANDLE     U#INDN                                                   AR853257
     C                   MOVE      A3STRT        U#MTAX
     C                   MOVE      A3STCY        U#MCCY
      *
      ** ..if Balance rate is required, set balance rate if this is different
      **   from tax rate
      *
     C     U#TXTY        IFEQ      'B'
     C     A3STRB        ANDGT     0
     C                   MOVE      A3STRB        U#MTAX
     C                   ENDIF
      *
     C     U#TXTY        IFEQ      'C'
     C**** A3STCH        ANDGT     0
     C****               MOVE      A3STCH        U#MTAX
     C     A3STCC        ANDGT     0                                                        AR853257
     C                   MOVE      A3STCC        U#MTAX                                     AR853257
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If No rate found, then access historic file (SDSTMDPD) for the same
      ** transaction type or account or facility
      *
     C     U#MTAX        IFEQ      *ZEROS
     C     U#MCCY        ANDEQ     *BLANKS
      *
      **  .....retrieve Historic Rate for single module
      *
     C                   MOVEL     *BLANKS       T2SCCY                                     AR853257
     C                   MOVE      U#MOD         T2KEY
     C     U#MOD         IFEQ      'RETAIL'
     C                   MOVE      U#TYPE        T2ACOD
     C                   SETON                                        50
     C                   ENDIF
     C     U#MOD         IFEQ      'DEAL'
     C     U#MOD         OREQ      'LOAN'
     C     U#MOD         OREQ      'FACILITY'
     C     U#MOD         OREQ      'FEE'
     C**********         MOVE      U#TYPE        T2TYPE                                     AR853257
     C                   MOVEL     U#TYPE        T2TYPE                                     AR853257
     C                   SETON                                        50
     C                   ENDIF
     C                   MOVE      'R'           T2RCTP
     C                   Z-ADD     U#DATE        T2CDTE
     C     KLIST1        SETGT     SDSTMDL1
     C     KLISTE        READPE    SDSTMDL1                               80
     C     *IN80         IFEQ      *OFF
     C                   MOVE      T2TXRT        U#MTAX
     C                   MOVE      T2SCCY        U#MCCY
      *
      ** ...if balance rate is required, set balance rate from file if different
      **    from zero, else leave normal rate
      *
     C     U#TXTY        IFEQ      'B'
     C     T2TXRB        ANDGT     0
     C                   MOVE      T2TXRB        U#MTAX
     C                   ENDIF
      *                                                                                     AR853257
     C     U#TXTY        IFEQ      'C'                                                      AR853257
     C     T2STCC        ANDGT     0                                                        AR853257
     C                   MOVE      T2STCC        U#MTAX                                     AR853257
     C                   ENDIF                                                              AR853257
      *                                                                                     AR853257
     C                   ENDIF
      *
     C                   END
      *
      ** If Stamp Tax is not found and module is RETAIL then check
      ** if account is to be blank
      *
     C     U#MTAX        IFEQ      *ZEROS
     C     U#MCCY        ANDEQ     *BLANKS
     C     U#MOD         ANDEQ     'RETAIL  '
     C                   MOVE      *BLANKS       T2ACOD
     C                   SETON                                        50
     C     KLIST1        SETGT     SDSTMDL1
     C     KLISTE        READPE    SDSTMDL1                               80
     C     *IN80         IFEQ      *OFF
     C                   MOVE      T2TXRT        U#MTAX
     C                   MOVE      T2SCCY        U#MCCY
      *
      ** ...if balance rate is required, set balance rate from file if different
      **   from zero, else leave normal rate
      *
     C     U#TXTY        IFEQ      'B'
     C     T2TXRB        ANDGT     0
     C                   MOVE      T2TXRB        U#MTAX
     C                   ENDIF
      *                                                                                     AR853257
     C     U#TXTY        IFEQ      'C'                                                      AR853257
     C     T2STCC        ANDGT     0                                                        AR853257
     C                   MOVE      T2STCC        U#MTAX                                     AR853257
     C                   ENDIF                                                              AR853257
      *                                                                                     AR853257
     C                   ENDIF
     C                   ENDIF
      *
      ** If no default exists for the relevant Deal/Loan/Facility/Fee
      **
      **  MODULE RATE
      **  -----------
      ** If no transaction type rate is defined, then the module rate will be use
      *
     C     U#MTAX        IFEQ      *ZEROS
     C     U#MCCY        ANDEQ     *BLANKS
      *
      ** If no default exists for the relevant Deal/Loan/Facility/Fee
      ** Type then see if there is an overall Deal/Loan/Facility/Fee
      ** default.
      *
     C                   MOVE      *BLANKS       A3DTYP
     C                   MOVE      *BLANKS       A3DSTP
     C                   MOVE      *BLANKS       A3LTYP
     C                   MOVE      *BLANKS       A3LSTP
     C                   MOVE      *BLANKS       A3FTYP
     C                   MOVE      *BLANKS       A3LFTP
     C     KLIST2        CHAIN     SDSTPDL1                           80
     C     *IN80         IFEQ      *OFF
     C*****A3EDTE        ANDLE     U#DATE                                                   AR853257
     C     A3EDTE        ANDLE     U#INDN                                                   AR853257
     C                   MOVE      A3STRT        U#MTAX
     C                   MOVE      A3STCY        U#MCCY
      *
      ** ..if Balance rate is required, set balance rate if this is different
      **   from tax rate
      *
     C     U#TXTY        IFEQ      'B'
     C     A3STRB        ANDGT     0
     C                   MOVE      A3STRB        U#MTAX
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   END
      *
      ** If no rate is defined, or effective date is after input date, check if
      ** there is a rate for the module in the Historic file (SDSTMDPD)
      *
     C     U#MTAX        IFEQ      *ZEROS
     C     U#MCCY        ANDEQ     *BLANKS
      *
     C                   MOVE      *BLANKS       T2TYPE
      *
     C     KLIST1        SETGT     SDSTMDL1
     C     KLISTE        READPE    SDSTMDL1                               80
     C     *IN80         IFEQ      *OFF
     C                   MOVE      T2TXRT        U#MTAX
     C                   MOVE      T2SCCY        U#MCCY
      *
      ** ...if balance rate is required, set balance rate from file if different
      **    from zero, else leave normal rate
      *
     C     U#TXTY        IFEQ      'B'
     C     T2TXRB        ANDGT     0
     C                   MOVE      T2TXRB        U#MTAX
     C                   ENDIF
      *                                                                                     AR853257
     C     U#TXTY        IFEQ      'C'                                                      AR853257
     C     T2STCC        ANDGT     0                                                        AR853257
     C                   MOVE      T2STCC        U#MTAX                                     AR853257
     C                   ENDIF                                                              AR853257
      *                                                                                     AR853257
      *
     C                   ENDIF
      *
     C                   END
      *
      ** If Module Stamp Tax ccy is blank, then set it Control Stamp Tax ccy
      *
     C     U#MTAX        IFNE      *ZEROS
     C     U#MCCY        ANDEQ     *BLANKS
     C                   MOVE      U#CCCY        U#MCCY
     C                   ENDIF
      *
     C                   EXSR      SREND
      *
      *****************************************************************
      ** Initial Processing
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** input parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    U#DATE
     C                   PARM                    U#MOD
     C                   PARM                    U#TYPE
     C                   PARM                    U#CTAX
     C                   PARM                    U#MTAX
     C                   PARM                    U#CCCY
     C                   PARM                    U#MCCY
     C                   PARM                    U#CSCC
     C                   PARM                    U#MSCC
     C                   PARM                    U#TXTY
      *
      **   Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Call Access Program to obtain Banks details from PF/SDBANKPD
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     ULRTCD
     C                   PARM      '*FIRST '     ULOPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Handle Database Error.
      *
     C     ULRTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD008140'    DBPGM
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If the Date passed to the program is not blank then convert
      ** this to DDMMYY, make it the 1st of the month and then convert
      ** back to Day number.
      *
     C     U#DATE        IFNE      *ZERO
     C                   Z-ADD     U#DATE        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         U#INDT
     C                   Z-ADD     1             U#D
     C                   Z-ADD     U#INDT        ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        U#INDN
     C                   ENDIF
      *
      ** Convert Run day number to DDMMYY format, then convert back to
      ** Midas Day number but with the DD equal to 01.
      *
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         U#DMY
     C                   Z-ADD     1             U#DD
     C                   Z-ADD     U#DMY         ZDATE
     C                   SETOFF                                       98
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        U#RDNB
      *
     C**********         MOVE      U#TYPE        @TYPE                                      AR821972
     C                   MOVEL     U#TYPE        @TYPE                                      AR821972
      *
      ** Set up KLIST for CHAIN to Stamp Tax Historic Details file
      *
     C     KLIST1        KLIST
     C                   KFLD                    T2KEY
     C                   KFLD                    T2TYPE
     C                   KFLD                    T2LNRF
     C                   KFLD                    T2FCNM
     C                   KFLD                    T2FACT
     C                   KFLD                    T2FCNO
     C                   KFLD                    T2FSEQ
     C                   KFLD                    T2ORED
     C                   KFLD                    T2DLNO
     C                   KFLD                    T2TDRF
     C                   KFLD                    T2BRCA
     C                   KFLD                    T2CNUM
     C                   KFLD                    T2SCCY
     C                   KFLD                    T2ACOD
     C                   KFLD                    T2ACSQ
     C                   KFLD                    T2PREF
     C                   KFLD                    T2CQSQ
     C                   KFLD                    T2PBRC
     C                   KFLD                    T2PSSH
     C                   KFLD                    T2PCPY
     C                   KFLD                    T2PDUD
     C                   KFLD                    T2PEVT
     C                   KFLD                    T2RCTP
     C                   KFLD                    T2CDTE
      *
      ** Set up KLIST for ReadE to Stamp Tax Historic Details file
      *
     C     KLISTE        KLIST
     C                   KFLD                    T2KEY
     C                   KFLD                    T2TYPE
     C                   KFLD                    T2LNRF
     C                   KFLD                    T2FCNM
     C                   KFLD                    T2FACT
     C                   KFLD                    T2FCNO
     C                   KFLD                    T2FSEQ
     C                   KFLD                    T2ORED
     C                   KFLD                    T2DLNO
     C                   KFLD                    T2TDRF
     C                   KFLD                    T2BRCA
     C                   KFLD                    T2CNUM
     C                   KFLD                    T2SCCY
     C                   KFLD                    T2ACOD
     C                   KFLD                    T2ACSQ
     C                   KFLD                    T2PREF
     C                   KFLD                    T2CQSQ
     C                   KFLD                    T2PBRC
     C                   KFLD                    T2PSSH
     C                   KFLD                    T2PCPY
     C                   KFLD                    T2PDUD
     C                   KFLD                    T2PEVT
     C                   KFLD                    T2RCTP
      *
      ** Set up KLIST for CHAIN to Stamp Tax Defaults by Business Type
      *
     C     KLIST2        KLIST
     C                   KFLD                    A3KEY
     C                   KFLD                    A3BRCA
     C                   KFLD                    A3CUST
     C                   KFLD                    A3CTRY
     C                   KFLD                    A3ACCD
     C                   KFLD                    A3DTYP
     C                   KFLD                    A3DSTP
     C                   KFLD                    A3LTYP
     C                   KFLD                    A3LSTP
     C                   KFLD                    A3FTYP
     C                   KFLD                    A3LFTP
      *
     C                   ENDSR
      *
      *****************************************************************
      ** EXIT FROM PROGRAM
      *****************************************************************
     C     SREND         BEGSR
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      ********************************************************************
     C/COPY ZSRSRC,ZDATE1Z2LE
     C/COPY ZSRSRC,ZDATE2Z2LE
      ********************************************************************
      /EJECT
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@
(c) Copyright Finastra International Limited 2010
