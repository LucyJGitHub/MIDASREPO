     H DEBUG
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2023')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Future ARR rates BR events')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  XX0370 - Midas LE Future ARR rate BR events                  *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2023                 *
      *                                                               *
      *  Last Amend No. MD061164 *CREATE   Date 03May23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD061164 - LE ARR - Forward rates and new report changes.    *
      *             Formalise codes introduced by EF030223, ARRLOA.   *
 `    *           - EF030223 - CCR loans, only write to LOBRDK when   *
      *             CINPDT GE rundate (to avoid duplicate rates).     *
      *           - ARRLOA - Pick up future ARR rate BR events        *
      *                                                               *
      *****************************************************************
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     USROPN
     FSDHSFWR   IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     FXXHISTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Q_)
     F                                     USROPN
     FLOBRDK    O    E             DISK    INFSR(*PSSR)
     F                                     PREFIX(K_)

      *
     D/COPY ZSRSRC,ZDATE2Z1LE
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
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

     D WRun            S              1

      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *

     ISDFWDRT0
     I              FTRNID                      CTRNID
     I              FINPDT                      CINPDT
     I              FDCMRT                      CDCMRT
     I              FAVCRT                      CAVCRT
     I              FRTEAP                      CRTEAP
     I              FSMPAV                      CSMPAV

     C/exec SQL
     C+ set option commit = *CHG
     C/end-exec

     C     *Loval        Setll     CLOANC
     C                   Read      CLOANC                                 40

s1   C     *In40         Doweq     *Off

s2   C     RTKN          Ifeq      'Y'
     C*****RECI*         andeq     'D'                                                      MD061164
     C     MDAT          andge     BJDNWD                                                   MD061164
     C*****NIDT          andne     0

     C     NIDT          Ifne      0
     C                   z-add     NIDT          @@NIDT
     C                   else
     C     REPT          Ifeq      3
     C     NRPD          andne     0
     C                   z-add     NRPD          @@NIDT
     C                   else
     C                   z-add     MDAT          @@NIDT
     C                   Endif
     C                   Endif

     C     KHSFW         SetGT     SDHSFWR
     C                   Readp     SDHSFWR                                41

     C     *IN41         Ifeq      *Off
     C                   z-add     0             Count             2 0
     C                   Endif

s3   C     *IN41         Doweq     *Off
     C     Lnrf          andeq     CTRNID
     C     Count         andle     LBDY

s4   C     Calm          Ifeq      'CCR'                                                    MD061164
     C     CINPDT        andge     BJRDNB                                                   MD061164
     C     Calm          orne      'CCR'                                                    MD061164
                                                                                            MD061164
     C                   z-add     CINPDT        KHISD

     C     KHISQ         Chain     XXHISTL3                           42
s5   C     *IN42         Ifeq      *On
     C                   Clear                   LOBRDKF
     C                   Move      'D'           K_Reci
     C                   Move      Lnrf          K_Lnrf
     C                   Z-Add     KHISD         K_VDAT
     C                   Z-add     1             K_LASN
     C                   Move      MRIN          K_MRIN
     C                   Move      LTYP          K_LTYP
     C                   Move      SUTP          K_SUTP
     C                   Move      PTYP          K_PTYP
     C                   Move      'BR'          K_AMTP
     C                   Move      CCY           K_CCY
     C                   Move      BRTT          K_BRTT
     C                   Move      BRCA          K_BRCA
     C                   Move      CNUM          K_CNUM

     C                   Select
     C     Calm          Wheneq    'NCCR'
     C     CDCMRT        add       BADJ          K_BRTE
     C     Calm          Wheneq    'CCR'
     C     CAVCRT        add       BADJ          K_BRTE
     C                   z-add     SLID          K_VDAT                                     MD061164
     C     Calm          Wheneq    'SARR'
     C     CRTEAP        add       BADJ          K_BRTE
     C     Calm          Wheneq    'SAVG'
     C     CSMPAV        add       BADJ          K_BRTE
     C                   Endsl

     C                   Move      'A'           K_LLAG
     C                   Move      FCUS          K_FCUS
     C                   Z-add     FTYP          K_FTYP
     C                   Z-add     FSEQ          K_FSEQ
     C                   Move      NACD          K_NACD
     C                   Move      FCLB          K_FCLB
     C                   Z-Add     BJRDNB        K_ORED
     C                   Z-Add     BJRDNB        K_LCD
     C                   Move      'I'           K_CHTP
     C                   Move      'N'           K_IRCF
     C                   Move      'M'           K_MNSG
     C                   Move      'P'           K_GASS
     C                   Move      'N'           K_GPRT
     C                   Move      'N'           K_NRLI
     C                   Move      'A'           K_ASTS
     C                   Move      PSUser        K_IUSR
     C                   Move      PCRF          K_PCRF
     C                   TIME                    K_TMST
     C                   Z-Add     K_BRTE        K_BASR
     C                   WRITE     LOBRDKF
e5   C                   Endif

     C                   Add       1             Count
                                                                                            MD061164
e4   C                   Endif                                                              MD061164

     C                   Readp     SDHSFWR                                41
e3   C                   Enddo

e2   C                   Endif

     C                   Read      CLOANC                                 40
e1   C                   Enddo
      *
     C                   Close     CLOANC
     C                   Close     SDHSFWR
     C                   Close     XXHISTL3

     C                   Eval      *INLR = *ON
     C                   Return

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Define Local Data Area for error handling
      *
     C     *DTAARA       DEFINE                  LDA

     C     *LIKE         Define    NIDT          @@NIDT
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   If        BjDfin = 'M'
     C                   Move      *On           *In98
     C                   else
     C                   Move      *Off          *In98
     C                   Endif

     C     KHSFW         KLIST
     C                   KFld                    LNRF
     C**********         KFld                    NIDT
     C                   KFld                    @@NIDT

     C     KHISQ         KLIST
     C                   KFld                    LNRF
     C                   KFld                    KHisd             5 0

      *
     C                   Open      CLOANC
     C                   Open      SDHSFWR
     C                   Open      XXHISTL3
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   Close     CLOANC
     C                   Close     SDHSFWR
     C                   Close     XXHISTL3

     C                   RETURN

     C                   ENDSR
      *****************************************************************
