     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Stamp Tax Generate Records for STP (OPAY)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data                                        *
      *                                                               *
      *  SD008160 - Stamp Tax Generate Records for Outgoing           *
      *             Payments Generated via STP                        *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1084524          Date 13Feb13               *
      *                 CLE148             Date 23Jul12               *
      *                 CER049  *CREATE    Date 06Dec10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER049 - Stamp Tax                                           *
      *                                                               *
      *****************************************************************
     FOTPAY     IF   E           K DISK
     FOTPAYQL0  IF A E           K DISK
     FSDSTMDL0  IF A E           K DISK
      *
     F/EJECT
      *****************************************************************
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      ** Get Rundate - Rundate  *
      *
     D W0DATA          DS           256
     D I#PT1                   1      1
     D I#PTY1                  2     36
     D I#PT2                  37     37
     D I#PTY2                 38     72
     D I#CCY                  73     75
     D O#CUST                 76     81
     D O#CYCD                 82     84
     D O#ACCD                 85     94
     D O#ACSN                 95     96
     D O#BRCD                 97     99
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * -------------------------------------------------------------------
     D LDA           E DS           256    EXTNAME(LDA)
     D  DBZZ19       E                     EXTFLD(ZZ019)
      *
      /EJECT
      *****************************************************************
      *
     C                   EXSR      SRINIT
      *
      ** Read payments until end of file
      *
     C     *LOVAL        SETLL     OTPAYDDF
     C                   READ      OTPAYDDF                               75
      *
     C     *IN75         DOWEQ     *OFF
      *
     C     RECI          IFEQ      'D'
      *
      ** check if Stamp Tax records already exist
      *
     C                   MOVEL     'OPAY  '      U#ORGN
     C                   MOVE      PREF          U#PREF
     C                   CLEAR                   OTPAYQD0
     C     U#PREF        CHAIN     OTPAYQL0                           91
      *
     C     *IN91         IFEQ      *ON
      *
      ** calculate Stamp Tax
      *
     C                   EXSR      SRSTAX
      *
      ** determine account
      *
     C                   EXSR      SRACCN
      *
      ** output header/details Stamp Tax records
      *
     C                   EXSR      SROUTR
      *
     C                   END
     C                   END
      *
      ** Read next record
      *
     C                   READ      OTPAYDDF                               75
     C                   ENDDO
      *
     C                   MOVEL     *ON           *INLR
     C                   RETURN
      *
      *****************************************************************
      * SRSTAX - Retrieve Stamp Tax Rate and calculate Tax amount
      *****************************************************************
      *
     C     SRSTAX        BEGSR
      *
      ** Find default stamp tax rate A1STRT from SDSTPTPD
      *
     C                   MOVE      SLDT          U#DATE            5 0
     C                   MOVE      *BLANKS       U#TXTY            1
      *
      ** SD008140 will return the Tax Rate to be used to calculate the
      ** Stamp Tax and the Stamp Tax Currency
      *
     C                   CALL      'SD008140'
     C                   PARM                    U#DATE
     C                   PARM                    U#ORGN
     C                   PARM                    U#TYPE            4
     C                   PARM                    U#CTAX           13 8
     C                   PARM                    U#MTAX           13 8
     C                   PARM                    U#CCCY            3
     C                   PARM                    U#MCCY            3
     C                   PARM                    U#CSCC            2
     C                   PARM                    U#MSCC            2
     C                   PARM                    U#TXTY            1
      *
      ** If there is a default Tax Rate for the module use this,
      ** otherwise use the ICD control Tax Rate.
      *
     C                   MOVE      *BLANKS       U#TXTY            1
     C     U#MTAX        IFNE      *ZEROS
     C                   Z-ADD     U#MTAX        U#TAXR           13 8
     C                   MOVE      U#MCCY        U#SCCY            3
     C                   ELSE
     C                   Z-ADD     U#CTAX        U#TAXR
     C                   MOVE      U#CCCY        U#SCCY
     C                   ENDIF
      *
      ** Stamp Tax is calulated on the Transfer Commission
      *
     C     TRCM          MULT      U#TAXR        MSCH
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRACCN - Retrieve A/C
      *****************************************************************
      *
     C     SRACCN        BEGSR
      *
     C                   CLEAR                   W0DATA
     C                   CLEAR                   @@TYP1
     C                   CLEAR                   @@ACC1
     C                   CLEAR                   @@TYP2
     C                   CLEAR                   @@ACC2
     C                   CLEAR                   @@CCY
      *
     C                   SELECT
      *
     C     CFT009        WHENEQ    'Y'
     C                   MOVEL     ORCT          @@TYP1
     C                   MOVEL     ORC1          @@ACC1
     C                   MOVEL     SMCY          @@CCY
      *
     C     CDRO          WHENNE    *ZEROS
     C                   MOVEL     CDRT          @@TYP1
     C                   MOVEL     CDRO          @@AC21           21
     C                   MOVE      CDBR          @@AC21
     C                   MOVEL     @@AC21        @@ACC1
     C                   MOVEL     BJCYCD        @@CCY
      *
     C     ADDC          WHENEQ    'A'
     C                   MOVEL     ORCT          @@TYP1
     C                   MOVEL     ORC1          @@ACC1
     C                   MOVEL     SMCY          @@CCY
     C                   MOVEL     ORBT          @@TYP2
     C     ORBK          IFNE      *BLANKS
     C                   MOVEL     ORBK          W0FLD            18
     C     W0FLD         CAT       ORBB          @@ACC2
     C                   END
      *
     C     ADDC          WHENEQ    'D'
     C                   MOVEL     DSTT          @@TYP1
     C                   MOVEL     DST1          @@ACC1
     C                   MOVEL     PCCY          @@CCY
     C                   MOVEL     SNCT          @@TYP2
     C     SNCO          IFNE      *BLANKS
     C                   MOVEL     SNCO          @@ACC2
     C                   END
      *
     C                   ENDSL
      *
      ** If account information passed then get account and customer
      ** using GL008101.
      *
     C     @@CCY         IFNE      *BLANKS
     C                   CLEAR                   W0DATA
     C                   MOVEL     @@TYP1        I#PT1
     C                   MOVEL     @@ACC1        I#PTY1
     C                   MOVEL     @@TYP2        I#PT2
     C                   MOVEL     @@ACC2        I#PTY2
     C                   MOVEL     @@CCY         I#CCY
      *
     C                   CALL      'GL008101'
     C                   PARM                    W0RTN             7
     C                   PARM                    W0DATA
     C                   PARM                    W0MSG           256
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      * SROUTR - Output Header/Detail records
      *****************************************************************
      *
     C     SROUTR        BEGSR
      *
      ** Output Header
      *
     C                   CLEAR                   OTPAYQD0
     C                   MOVE      U#PREF        OTPREF
     C                   MOVE      'Y'           OTTAX
     C                   MOVE      BJRDNB        OTCDTE
     C                   MOVE      BRCA          OTBRCA
     C                   MOVE      MSCH          OTSTAF
     C                   WRITE     OTPAYQD0
      *
      ** Output Detail
      *
     C                   MOVEL     U#ORGN        T2KEY
     C                   MOVE      OTPREF        T2PREF
     C                   MOVE      *BLANK        T2CQSQ
     C                   MOVE      'T'           T2RCTP
     C                   MOVE      'Y'           T2TCAL
     C                   MOVE      U#TAXR        T2TXRT
     C                   MOVE      U#SCCY        T2SCCY
     C                   MOVE      SMCY          T2ECCY
     C                   MOVE      OTSTAF        T2TATC
     C                   MOVE      'Y'           T2STFC
     C                   MOVE      'I'           T2TYLC
     C                   MOVE      *BLANKS       T2TYPE
     C                   MOVE      BJRDNB        T2LCD
      *
      ** Set debit account
      *
     C                   MOVEL     O#CUST        T2DCST
     C                   MOVEL     O#CYCD        T2DCCY
     C                   MOVEL     O#ACCD        T2DACD
     C                   MOVEL     O#ACSN        T2DASQ
     C                   MOVEL     O#BRCD        T2DBRC
     C                   CLEAR                   T2TXRB
     C                   WRITE     @STMDV0
      *
     C                   ENDSR
      *
      *****************************************************************
      * SRINIT
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
     C                   MOVE      *BLANKS       @@CCY             3
     C                   MOVE      *BLANKS       @@TYP1            1
     C                   MOVE      *BLANKS       @@ACC1           24
     C                   MOVE      *BLANKS       @@TYP2            1
     C                   MOVE      *BLANKS       @@ACC2           24
     C     *LIKE         DEFINE    T2KEY         U#ORGN
     C     *LIKE         DEFINE    T2LNRF        U#LNRF
     C     *LIKE         DEFINE    T2FCNM        U#FCNM
     C     *LIKE         DEFINE    T2FACT        U#FACT
     C     *LIKE         DEFINE    T2FCNO        U#FCNO
     C     *LIKE         DEFINE    T2FSEQ        U#FSEQ
     C     *LIKE         DEFINE    T2ORED        U#ORED
     C     *LIKE         DEFINE    T2DLNO        U#DLNO
     C     *LIKE         DEFINE    T2TDRF        U#TDRF
     C     *LIKE         DEFINE    T2BRCA        U#BRCA
     C     *LIKE         DEFINE    T2CNUM        U#CNUM
     C     *LIKE         DEFINE    T2CCY         U#CCY
     C     *LIKE         DEFINE    T2ACOD        U#ACOD
     C     *LIKE         DEFINE    T2ACSQ        U#ACSQ
     C     *LIKE         DEFINE    T2PREF        U#PREF
      *
      ** SDBANKPD
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      '*MSG   '     P@RTCD            7
     C                   PARM      '*FIRST '     P@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** If return with an error (LR seton in called program) then
      ** process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        ORNE      *BLANKS
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   MOVEL     'SD008160'    DBPGM
     C                   MOVEL     'AOBANKR0'    DBFILE
     C                   MOVEL     'CALL    '    DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      *OFF          *IN98
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      *ON           *IN98
     C                   END
     C                   END
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*VERIFY'     P@OPTN            7
     C                   PARM      'CFT009'      P@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
     C                   MOVE      'N'           CFT009            1
      *
      ** If core feature is switched ON, set a variable field to
      ** condition the rest of the processing
      *
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CFT009
     C                   ELSE
     C                   MOVE      'N'           CFT009
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      *
      * PSSR Processing
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   DUMP
      *
      ** If second time through, halt:
      *
     C     WRUN          IFEQ      *BLANK
     C                   SETON                                        U7U8LR
      *
     C                   MOVE      'Y'           WRUN              1
     C                   RETURN
     C                   ENDIF
      *
      ** Flag routine as started; define action code:
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
