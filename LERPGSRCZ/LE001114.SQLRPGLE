     H DEBUG
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2022')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas - Future ARR rates BR events')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE001114 - Midas LE Future ARR rate BR events                *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2022                 *
      *                                                               *
      *  Last Amend No. MD058517           Date 17Oct22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058517 - CLE172 LIBOR Lending- Change Control CC3.1        *
      *             Interest Projection Using Known Rates             *
      *             CC10 CLE172 Spool File Correspondence (MD059817)  *
      *                                                               *
      *****************************************************************
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     USROPN
     FSDHSFWL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(SDHSDRT0)
     F                                     USROPN
     FLEHISTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(Q_)
     F                                     USROPN
     FLEFWBRPD  O    E             DISK    INFSR(*PSSR)
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
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                MD058517
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D EventCtrlDate   S              5S 0                                                  MD058517
     D PRTCD           S              7                                                     MD058517
     D POPTN           S              7                                                     MD058517
      *
     ISDFWDRT0
     I              FTRNID                      CTRNID
     I              FINPDT                      CINPDT
     I              FDCMRT                      CDCMRT
     I              FAVCRT                      CAVCRT
     I              FRTEAP                      CRTEAP
     I              FSMPAV                      CSMPAV

     C/EXEC SQL
     C+ SET OPTION COMMIT = *CHG
     C/END-EXEC

     C     *LOVAL        SETLL     CLOANC
     C                   READ      CLOANC                                 40

     C     *IN40         DOWEQ     *OFF

     C     BLRT          IFEQ      'Y'
     C     RTKN          ANDEQ     'Y'
     C     CALM          ANDNE     'MANL'
     C     MDAT          ANDGE     BJDNWD

     C     NIDT          IFNE      0
     C                   Z-ADD     NIDT          @@NIDT
     C                   ELSE
     C     REPT          IFEQ      3
     C     NRPD          ANDNE     0
     C                   Z-ADD     NRPD          @@NIDT
     C                   ELSE
     C                   Z-ADD     MDAT          @@NIDT
     C                   ENDIF
     C                   ENDIF

     C     KHSFW         SETGT     SDHSFWL0
     C                   READP     SDHSFWL0                               41

     C     *IN41         DOWEQ     *OFF
     C     LNRF          ANDEQ     CTRNID

     C                   Z-ADD     CINPDT        KHISD

     C     KHISQ         CHAIN     LEHISTL3                           42
     C     *IN42         IFEQ      *ON
     C                   CLEAR                   LEFWBRD0
     C                   MOVE      'D'           K_RECI
     C                   MOVE      LNRF          K_LNRF
     C                   Z-ADD     KHISD         K_VDAT
     C                   MOVE      MRIN          K_MRIN
     C                   MOVE      LTYP          K_LTYP
     C                   MOVE      SUTP          K_SUTP
     C                   MOVE      PTYP          K_PTYP
     C                   MOVE      'BR'          K_AMTP
     C                   MOVE      CCY           K_CCY
     C                   MOVE      BRTT          K_BRTT
     C                   MOVE      BRCA          K_BRCA
     C                   MOVE      CNUM          K_CNUM

     C                   SELECT
     C     Calm          WHENEQ    'NCCR'
     C     CDCMRT        ADD       BADJ          K_BRTE
     C                   Z-ADD     1             K_LASN
     C     Calm          WHENEQ    'CCR'
     C     CAVCRT        ADD       BADJ          K_BRTE
     C                   Z-ADD     FINPSD        K_VDAT
     C                   EVAL      K_LASN += 1
     C     Calm          WHENEQ    'SARR'
     C     CRTEAP        ADD       BADJ          K_BRTE
     C                   Z-ADD     1             K_LASN
     C     Calm          WHENEQ    'SAVG'
     C     CSMPAV        ADD       BADJ          K_BRTE
     C                   Z-ADD     FINPSD        K_VDAT
     C                   EVAL      K_LASN += 1
     C                   ENDSL

     C                   MOVE      'A'           K_LLAG
     C                   MOVE      FCUS          K_FCUS
     C                   Z-ADD     FTYP          K_FTYP
     C                   Z-ADD     FSEQ          K_FSEQ
     C                   MOVE      NACD          K_NACD
     C                   MOVE      FCLB          K_FCLB
     C                   Z-ADD     BJRDNB        K_ORED
     C                   Z-ADD     BJRDNB        K_LCD
     C                   MOVE      'I'           K_CHTP
     C                   MOVE      'N'           K_IRCF
     C                   MOVE      'M'           K_MNSG
     C                   MOVE      'P'           K_GASS
     C                   MOVE      'N'           K_GPRT
     C                   MOVE      'N'           K_NRLI
     C                   MOVE      'A'           K_ASTS
     C                   MOVE      PSUser        K_IUSR
     C                   MOVE      PCRF          K_PCRF
     C                   TIME                    K_TMST
     C                   Z-ADD     K_BRTE        K_BASR
     C                   Z-ADD     CINPDT        K_LSMD
     C                   Z-ADD     EventCtrlDate K_XAVD
     C                   WRITE     LEFWBRD0
     C                   ENDIF

     C                   READP     SDHSFWL0                               41
     C                   ENDDO

     C                   ENDIF

     C                   READ      CLOANC                                 40
     C                   ENDDO
      *
     C                   CLOSE     CLOANC
     C                   CLOSE     SDHSFWL0
     C                   CLOSE     LEHISTL3

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** DEFINE Local Data Area for error handling
      *
     C     *DTAARA       DEFINE                  LDA

     C     *LIKE         DEFINE    NIDT          @@NIDT
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        BJDFIN = 'M'
     C                   MOVE      *ON           *In98
     C                   ELSE
     C                   MOVE      *OFF          *In98
     C                   ENDIF

     C     KHSFW         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    @@NIDT

     C     KHISQ         KLIST
     C                   KFLD                    LNRF
     C                   KFLD                    KHisd             5 0
      ** Access General Ledger details                                                      MD058517
     C                   CALL      'AOGELRR1'                                               MD058517
     C                   PARM      *BLANKS       PRtCd                                      MD058517
     C                   PARM      '*FIRST '     POptn                                      MD058517
     C     SDGELR        PARM      SDGELR        DSSDY                                      MD058517
                                                                                            MD058517
     C                   IF        PRtCd <> *BLANKS                                         MD058517
     C                   EVAL      DBFILE = 'SDGELRPD'                                      MD058517
     C                   EVAL      DBKEY = POptn                                            MD058517
     C                   EVAL      DBASE  = 002                                             MD058517
     C                   EXSR      *PSSR                                                    MD058517
     C                   ENDIF                                                              MD058517
      *                                                                                     MD058517
      ** Determine the Event Control Date                                                   MD058517
      *                                                                                     MD058517
     C                   EVAL      EventCtrlDate = BJDNWD - 1                               MD058517
     C                   IF        BKAPDT < EventCtrlDate                                   MD058517
     C                   EVAL      EventCtrlDate = BKAPDT                                   MD058517
     C                   ENDIF                                                              MD058517
                                                                                            MD058517
     C                   IF        BKANWD = '0' or BKANWD = '1'                             MD058517
     C                   EVAL      EventCtrlDate = BJDNWD - 1                               MD058517
     C                   ENDIF                                                              MD058517
     C                                                                                      MD058517

      *
     C                   OPEN      CLOANC
     C                   OPEN      SDHSFWL0
     C                   OPEN      LEHISTL3
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
     C                   CLOSE     CLOANC
     C                   CLOSE     SDHSFWL0
     C                   CLOSE     LEHISTL3

     C                   RETURN

     C                   ENDSR
      *****************************************************************
