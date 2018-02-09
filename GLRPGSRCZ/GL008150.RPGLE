     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Stamp Tax Update Hist Principal Movements')   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL008150 - Stamp Tax Update Historic Principal Movements     *
      *                                                               *
      *  Function: Read the Stamp Tax Account Keys file and then      *
      *            write or update the records on the Stamp Tax       *
      *            Historic Principal Movements file.                 *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 AR878013           Date 16Dec11               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR878013 - Wrong computation on average balance with         *
      *             movements                                         *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
      *
      * ID F  C  H  L    FUNCTION OF INDICATORS
      *
      *  *IN70 - Read GLHPMPPD
      *  *IN80 - End of GLVCLSPD Read processing
      *  *IN81 - Lokup in EV@ array
      *
      *****************************************************************
     FGLVCLSL0  IF   E           K DISK
      * Dealing/Lending Stamp Tax Account Keys file
      *
     FGLHPMPL0  UF A E           K DISK
      * Stamp Tax Historical Principal Movements file
      *
      *****************************************************************
      *
     D EV@             S              2    DIM(5) CTDATA PERRCD(5)              A/C Key Type
     D ID@             S              1    DIM(5) CTDATA PERRCD(5)              Increase/Decrease
      ** Array containing Copyright statement
      *
      *****************************************************************
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
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
     D  U#AKEY                 1     14
     D  U#STAM                 1      5
     D  U#KEY3                 3      3
     D  U#KEY9                 9      9
     D  U#KEY0                10     10
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D U#LNNO          S              6A                                                      CLE148
      *****************************************************************
      *
      *                M A I N  P R O C E S S I N G
      *
      *****************************************************************
      *
      ** Initialise data
      *
     C                   EXSR      SRINIT
      *
      * LENDING:
      * --------
      * A/c Key           Event                                          Increase/Decrease
      * --------------    ----------------                               -----------------
      * xxVyybrsbAcccc    Start Value Date                                        I
      * xxVyybrsIAcccc    Principal Increase                                      I
      * xxVyybrsDAcccc    Principal Decrease                                      I
      * xxRyybrsbAcccc    Repayment/Maturity                                      D
      * xxRyybrsbCcccc    Capitalisation                                          I
      *
      * DEALING:
      * --------
      * A/c Key           Event                                          Increase/Decrease
      * --------------    ----------------                               -----------------
      * xxVyybbbbAcccc    Start/Value Date                                        I
      * xxRyybbbbAcccc    Repayment                                               D
      * xxIyybbbbCcccc    Capitalisation                                          I
      * xxMyybbbbAcccc    Maturity                                                D
      *
      *  Read Dealing/Lending a/ck file
      *
     C                   READ      GLVCLSL0                               80
      *
     C     *IN80         DOWEQ     *OFF
      *
      * If record has a relevant Lending or Dealing Account Key move
      * I or D into U#CODE to signify whether a PI or a PD.
      *
     C                   Z-ADD     1             @TB
     C                   CLEAR                   U#CODE
     C                   CLEAR                   U#TWO
      *
      * Define whether Increase/Decrease:
      *
      * Array EV@ contains a/ck event type (position 3) and a/ck type (position 10) of field AKEY
      * Array ID@ contains the related Increase/Decrease indicator
      * EV@ = VA, RC, IC, RA, MA
      * ID@ = I,  I,  I,  D,  D
      *
     C                   MOVE      AKEY          U#AKEY
     C                   MOVEL     U#KEY3        U#TWO
     C                   MOVE      U#KEY0        U#TWO
     C     U#TWO         LOOKUP    EV@(@TB)                               81
     C     *IN81         IFEQ      *ON
     C                   MOVE      ID@(@TB)      U#CODE
     C                   ENDIF
      *
      *  Position 9 of the account key must be always blank, if not clear U#CODE as the
      *  record is not to be processed
      *  This is not valid if the A/C Key processed is for Loan and is:
      *    xxVyybrsIAcccc    Principal Increase                                       I
      *    xxVyybrsDAcccc    Principal Decrease                                       I
      *
     C     U#KEY9        IFNE      *BLANKS
      *
     C*****U#LNNO        IFEQ      *ZEROS                                                   AR878013
     C*****U#LNNO        ORNE      *ZEROS                                                   AR878013
     C     DLNO          IFNE      *ZEROS                                                   AR878013
     C     U#TWO         ANDNE     'VA'                                                     AR878013
     C     U#KEY9        ANDNE     'I'                                                      AR878013
     C     U#KEY9        ANDNE     'D'                                                      AR878013
     C*****LNNO*         ORNE      *ZEROS                                            AR878013 CLE148
     C     LNNO          ORNE      *BLANKS                                           AR878013 CLE148
     C     U#TWO         ANDNE     'VA'
     C     U#KEY9        ANDNE     'I'
     C     U#KEY9        ANDNE     'D'
     C                   CLEAR                   U#CODE
     C                   ELSE
     C                   MOVE      U#KEY9        U#CODE
     C                   ENDIF
      *
     C                   ENDIF
      *
      * If U#CODE is 'I' or 'D' it means the record has a relevant A/C
      * Key therefore process it.
      *
     C     U#CODE        IFEQ      'D'
     C     U#CODE        OREQ      'I'
      *
      * Ignore if a/c key is a Stamp Tax key generated previously
      * on the loan/deal (STVTXxxxxxxxxx)
      *
     C     U#STAM        IFNE      'STVTX'
      *
      * If Event Date is before take on date, then set event date equal to Take on date
      *
     C     EDAT          IFLT      U#TKDT
     C                   Z-ADD     U#TKDT        EDAT
     C                   ENDIF
      *
     C                   MOVE      DLNO          U#DLNO
     C                   MOVE      LNNO          U#LNNO
     C                   MOVE      EDAT          U#EDAT
     C                   MOVE      ECCY          U#ECCY            3
     C                   MOVE      *OFF          *IN81
      *
      *  set transaction type
     C     U#DLNO        IFNE      *ZEROS
     C                   MOVE      'DEAL'        U#TYPE            4
     C                   ELSE
     C*****U#LNNO        IFNE      *ZEROS                                                     CLE148
     C     U#LNNO        IFNE      *BLANKS                                                    CLE148
     C                   MOVE      'LOAN'        U#TYPE
     C                   ENDIF
     C                   ENDIF
      *
      * If Reversal, set amount to opposite sign
      *
     C     REVI          IFEQ      1
     C                   MULT      -1            EAMT
     C                   END
      *
      * Position file pointer GT than the closest date to the Value
      * Date of the record on GLVCLSPD.
      *
     C     KLIST1        SETGT     GLHPMPL0
     C     KLISTP        READPE    GLHPMPL0                               81
      *
      * Process Loan
      *
     C     U#TYPE        IFEQ      'LOAN'
      *
      * Check whether a record already exists in the file for the loan and a/ck date
      *
      * SRNOTF is processed if no records are found with same Loan numher
      * SRFEQU is processed if a record is found with the same Loan number and same date
      * SRFNEQ is processed if a record is found with the same Loan number but the date on the file
      *     is earlier than a/ck date
      *
      *  if loan and repayment, check if transaction maturing today
      *
     C     *IN81         IFEQ      *ON
     C                   EXSR      SRNOTF
     C                   ELSE
     C     T3VALD        CASEQ     U#EDAT        SRFEQU
     C                   CAS                     SRFNEQ
     C                   END
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      * Check whether a record already exists in the file for the deal and a/ck date
      *
      * SRNOTF is processed if no records are found with same Deal numher
      * SRFEQU is processed if a record is found with the same Deal number and same date
      * SRFNEQ is processed if a record is found with the same Deal number but the date on the file
      *     is earlier than a/ck date
      *
     C     U#TYPE        IFEQ      'DEAL'
      *
     C     *IN81         IFEQ      *ON
     C                   EXSR      SRNOTF
     C                   ELSE
     C     T3VALD        CASEQ     U#EDAT        SRFEQU
     C                   CAS                     SRFNEQ
     C                   END
      *
     C                   ENDIF
     C                   ENDIF
      *
      *  Update remaining records with Value Date after the 'event' date
      *
     C                   EXSR      SRUPDT
      *
     C                   END
     C                   END
      *
      *  Record Next record on dealing/lending a/ck file
      *
     C                   READ      GLVCLSL0                               80
      *
     C                   ENDDO
      *
      * End Processing
     C                   EXSR      SREND
      *
      *****************************************************************
      * SRNOTF - Sr to be processed when record not found on GLHPMPPD *
      *          with Value Date equal to or earlier than the Value   *
      *          Date of the Event.                                   *
      *                                                               *
      * Called From: MAIN                                             *
      *                                                               *
      * Calls:       None                                             *
      *****************************************************************
      *
     C     SRNOTF        BEGSR
     C                   MOVE      U#LNNO        T3LNRF
     C                   MOVE      U#DLNO        T3DLNO
     C                   MOVE      U#EDAT        T3VALD
     C                   MOVE      U#EDAT        T3VALD
     C                   MOVE      BJRDNB        T3LCD
     C                   MOVE      U#ECCY        T3ECCY
     C                   MOVE      'I'           T3TYLC
     C                   CLEAR                   T3MATD
      *
      * maturing
     C     U#TWO         IFEQ      'MA'
     C     MDAT          ANDNE     0                                                        AR878013
     C     MDAT          ORGT      0
     C     MDAT          ANDGE     BJRDNB
     C     MDAT          ANDLT     BJDNWD
     C                   MOVE      'Y'           T3MATD
     C                   ENDIF
      *
     C                   CLEAR                   T3OPAM
     C                   CLEAR                   T3PINC
     C                   CLEAR                   T3PDEC
      *
     C     U#CODE        IFEQ      'I'
     C                   ADD       EAMT          T3OPAM
     C                   ADD       EAMT          T3PINC
     C                   ELSE
     C                   SUB       EAMT          T3OPAM
     C                   ADD       EAMT          T3PDEC
     C                   ENDIF
      *
     C                   WRITE     @HPMPV0
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRFNEQ - Sr to be processed when record found on GLHPMPPD but *
      *          Value Date on record is earlier than Value Date of   *
      *          the Event.                                           *
      *                                                               *
      * Called From: MAIN                                             *
      *                                                               *
      * Calls:       None                                             *
      *****************************************************************
      *
     C     SRFNEQ        BEGSR
      *
     C                   MOVE      U#LNNO        T3LNRF
     C                   MOVE      U#DLNO        T3DLNO
     C                   MOVE      U#EDAT        T3VALD
     C                   MOVE      U#ECCY        T3ECCY
     C                   MOVE      BJRDNB        T3LCD
     C                   MOVE      'I'           T3TYLC
     C                   CLEAR                   T3MATD
      * maturing
     C     U#TWO         IFEQ      'MA'
     C     MDAT          ANDNE     0                                                        AR878013
     C     MDAT          ORGT      0
     C     MDAT          ANDGE     BJRDNB
     C     MDAT          ANDLT     BJDNWD
     C                   MOVE      'Y'           T3MATD
     C                   ENDIF
     C                   CLEAR                   T3PINC
     C                   CLEAR                   T3PDEC
      *
     C     U#CODE        IFEQ      'I'
     C                   ADD       EAMT          T3OPAM
     C                   ADD       EAMT          T3PINC
     C                   ELSE
     C                   SUB       EAMT          T3OPAM
     C                   ADD       EAMT          T3PDEC
     C                   ENDIF
      *
     C                   WRITE     @HPMPV0
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRFEQU - Sr to be processed when record found on GLHPMPPD and *
      *          Value Date on record is equal to Value Date of the   *
      *          Event.                                               *
      *                                                               *
      * Called From: MAIN                                             *
      *                                                               *
      * Calls:       None                                             *
      *****************************************************************
      *
     C     SRFEQU        BEGSR
     C                   MOVE      U#LNNO        T3LNRF
     C                   MOVE      U#DLNO        T3DLNO
     C                   MOVE      U#EDAT        T3VALD
     C                   MOVE      U#ECCY        T3ECCY
     C                   MOVE      BJRDNB        T3LCD
     C                   MOVE      'A'           T3TYLC
      * maturing
     C     U#TWO         IFEQ      'MA'
     C     MDAT          ANDNE     0                                                        AR871013
     C     MDAT          ORGT      0
     C     MDAT          ANDGE     BJRDNB
     C     MDAT          ANDLT     BJDNWD
     C                   MOVE      'Y'           T3MATD
     C                   ENDIF
      *
     C     U#CODE        IFEQ      'I'
     C                   ADD       EAMT          T3OPAM
     C                   ADD       EAMT          T3PINC
     C                   ELSE
     C                   SUB       EAMT          T3OPAM
     C                   ADD       EAMT          T3PDEC
     C                   ENDIF
      *
     C                   UPDATE    @HPMPV0
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRUPDT - Update remaining records with Value Date after event *
      *          Date of movements                                    *
      *                                                               *
      * Called From: MAIN                                             *
      *                                                               *
      * Calls:       None                                             *
      *****************************************************************
      *
     C     SRUPDT        BEGSR
      *
      * Position file pointer GT than the record just written to
      * GLHPMPPD.
     C                   MOVE      *OFF          *IN70
      *
     C     KLIST1        SETGT     GLHPMPL0
     C     KLISTP        READE     GLHPMPL0                               70
      *
     C     *IN70         DOWEQ     *OFF
      *
      * Do until the end of the file or until there are no more records
      * with the same Deal number
      *
     C     *IN70         IFEQ      *OFF
      *
      * Principal Amount is Increased or Decreased according to event type
      *
     C     U#CODE        IFEQ      'I'
     C                   ADD       EAMT          T3OPAM
     C                   ELSE
     C                   SUB       EAMT          T3OPAM
     C                   ENDIF
      *  update file
     C                   MOVE      'A'           T3TYLC
     C                   MOVE      BJRDNB        T3LCD
     C                   UPDATE    @HPMPV0
      *
     C                   ENDIF
      *
      * Read records from 'Principal Movements' file
     C     KLISTP        READE     GLHPMPL0                               70
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRINIT-  Initial Processing                                   *
      *                                                               *
      * Called From: MAIN                                             *
      *                                                               *
      * Calls:       *PSSR                                            *
      *****************************************************************
      *
     C     SRINIT        BEGSR
     C*
      **   Define the LDA for error handling
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   MOVE      *BLANKS       U#CODE            1
     C                   MOVE      *BLANKS       U#TWO             2
     C                   Z-ADD     1             @TB               1 0
     C                   Z-ADD     0             U#TKDT            5 0
      *
     C     KLIST1        KLIST
     C**********         KFLD                    U#LNNO            6 0                        CLE148
     C                   KFLD                    U#LNNO                                       CLE148
     C                   KFLD                    U#DLNO            6 0
     C                   KFLD                    U#EDAT            5 0
      * partial key
     C     KLISTP        KLIST
     C**********         KFLD                    U#LNNO            6 0                        CLE148
     C                   KFLD                    U#LNNO                                       CLE148
     C                   KFLD                    U#DLNO            6 0
      *
      * Call AOBANKR0 to get Midas Run Date
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     001           DBASE
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Access Take on date
      *
     C                   CLEAR                   U#LNNO
     C                   CLEAR                   U#DLNO
     C                   CLEAR                   U#EDAT
     C     KLIST1        SETLL     GLHPMPL0
     C     KLISTP        READE     GLHPMPL0                               70
     C     *IN70         IFEQ      *OFF
     C                   Z-ADD     T3VALD        U#TKDT
     C                   ENDIF
      *
      * reset file
     C     KLIST1        SETLL     GLHPMPL0
      *
     C                   ENDSR
      *
      *****************************************************************
      * SREND  - End Processing                                       *
      *                                                               *
      * Called From: MAIN                                             *
      *                                                               *
      * Calls:       *PSSR                                            *
      *****************************************************************
      *                                                               *
     C     SREND         BEGSR
      *                                                               *
     C                   SETON                                        LR
     C                   RETURN
      *                                                               *
     C                   ENDSR
      *                                                               *
      *****************************************************************
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called From: INIT                                             *
      *                                                               *
      * Calls:       DBERRCTL                                         *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
**CTDATA EV@
VARCICRAMA
**CTDATA ID@
IIIDD
**CTDATA CPY@
(C) Copyright Finastra International Limited 2010
