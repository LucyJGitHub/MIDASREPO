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
      *  (c) Finastra International Limited 2022                      *
      *                                                               *
      *  Last Amend No. MD060824           Date 10Jan23               *
      *  Prev Amend No. MD058517  *CREATE  Date 17Oct22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060824 - Future rates were rounded up on rates known date  *
      *             on LOAC and LEFWBRPD                              *
      *             Amended rate computation to follow ZAGETCALRT     *
      *             logic.                                            *
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
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D EventCtrlDate   S              5S 0
     D eventDate1      S              5S 0
     D eventDate2      S              5S 0
     D PRTCD           S              7
     D POPTN           S              7
     D Ix              S              3S 0
     D wFinalRate      S             15P 9 INZ(0)                                           MD060824
     D wCurrRate       S             11P 7 INZ(0)                                           MD060824
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
     C     MDAT          ANDGE     EventCtrlDate


     C     KHSFW         SETLL     SDHSFWL0
     C     KHSFW         READE     SDHSFWL0                               41
     C                   EVAL      Ix = 0

     C     *IN41         DOWEQ     *OFF
     C     LNRF          ANDEQ     CTRNID


     C                   CLEAR                   LEFWBRD0
     C                   MOVE      'D'           K_RECI
     C                   MOVE      LNRF          K_LNRF
     C                   Z-ADD     CINPDT        K_VDAT
     C                   MOVE      MRIN          K_MRIN
     C                   MOVE      LTYP          K_LTYP
     C                   MOVE      SUTP          K_SUTP
     C                   MOVE      PTYP          K_PTYP
     C                   MOVE      'BR'          K_AMTP
     C                   MOVE      CCY           K_CCY
     C                   MOVE      BRTT          K_BRTT
     C                   MOVE      BRCA          K_BRCA
     C                   MOVE      CNUM          K_CNUM

     C                   CLEAR                   wCurrRate                                  MD060824
     C                   CLEAR                   wFinalRate                                 MD060824
     C                   SELECT
     C     Calm          WHENEQ    'NCCR'
     C*****CDCMRT        ADD(H)    BADJ          K_BRTE                                     MD060824
     C                   EVAL      wCurrRate =  CDCMRT                                      MD060824
     C                   Z-ADD     1             Ix
     C     Calm          WHENEQ    'CCR'
     C*****CAVCRT        ADD(H)    BADJ          K_BRTE                                     MD060824
     C                   EVAL      wCurrRate =  CAVCRT                                      MD060824
     C                   Z-ADD     FINPSD        K_VDAT
     C                   EVAL      Ix += 1
     C     Calm          WHENEQ    'SARR'
     C*****CRTEAP        ADD(H)    BADJ          K_BRTE                                     MD060824
     C                   EVAL      wCurrRate =  CRTEAP                                      MD060824
     C                   Z-ADD     1             Ix
     C     Calm          WHENEQ    'SAVG'
     C*****CSMPAV        ADD(H)    BADJ          K_BRTE                                     MD060824
     C                   EVAL      wCurrRate =  CSMPAV                                      MD060824
     C                   Z-ADD     FINPSD        K_VDAT
     C                   EVAL      Ix += 1
     C                   ENDSL
      ** Compute final value of BRTE
     C                   EVAL      wFinalRate = wCurrRate + BADJ                            MD060824
     C                   EVAL(H)   K_BRTE     = wFinalRate                                  MD060824

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
     C                   Z-ADD     Ix            K_LASN
     C                   Z-ADD     eventDate1    K_XAVD
     C                   Z-ADD     eventDate2    K_TNLU
     C                   WRITE     LEFWBRD0

     C     KHSFW         READE     SDHSFWL0                               41
     C                   ENDDO

     C                   ENDIF

     C                   READ      CLOANC                                 40
     C                   ENDDO
      *
     C                   CLOSE     CLOANC
     C                   CLOSE     SDHSFWL0

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

      ** Access General Ledger details
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY

     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE  = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Determine the Event Control Date
      *
     C                   EVAL      EventCtrlDate = BJDNWD - 1
     C                   EVAL      eventDate1 = EventCtrlDate
     C                   EVAL      eventDate2 = EventCtrlDate
     C                   IF        BKAPDT < EventCtrlDate
     C                   EVAL      EventCtrlDate = BKAPDT
     C                   EVAL      eventDate2 = EventCtrlDate
     C                   ENDIF


      *
     C                   OPEN      CLOANC
     C                   OPEN      SDHSFWL0
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

     C                   RETURN

     C                   ENDSR
      *****************************************************************
