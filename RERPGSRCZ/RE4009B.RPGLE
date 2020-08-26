     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE T&N Accounts - Account Action Routine API')   *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE4009B - RE Term and Notice Account Action Routine API      *
      *                                                               *
      *  Function:  This program is copied from RE4009 that will be   *
      *             called by account maintenance validation to pass  *
      *             on the period and penalty interest details to the *
      *             standard debit and credit details of the account  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015 *CREATE     Date 18Dec09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing          *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *           (Recompile)                                         *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *                                                               *
      *****************************************************************
 
      ** Account Master Detail definition file
 
     D ACPRIM        E DS                  EXTNAME(GLAMADPD)
 
      ** Acc.Debit Interest/Ov.Definition File
 
     D ACDEBT        E DS                  EXTNAME(GLAMDIPD)
 
      ** Acc.Credit Int./Chrg. Definition File
 
     D ACCRDT        E DS                  EXTNAME(GLAMCIPD)
 
      ** Previous Acc.Debit Interest/Ov.Definition File
 
     D PRDEBT        E DS                  EXTNAME(GLAMDIPD) PREFIX(PR_)
 
      ** Previous Acc.Credit Int./Chrg. Definition File
 
     D PRCRDT        E DS                  EXTNAME(GLAMCIPD) PREFIX(PR_)
 
      ** Rate changes to be actioned
 
     D REPFMT        E DS                  EXTNAME(REPRPNPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
 
      ** MAIN PROCESSING
 
     C                   MOVE      *BLANKS       SXRIB             2
     C                   MOVE      *BLANKS       SXSIG             1
     C                   MOVE      *BLANKS       SXRIS            12
     C                   MOVE      *BLANKS       SXICT             2
     C                   MOVE      *BLANKS       SXCST             5
     C                   MOVE      *BLANKS       SXRCD             6
     C                   MOVE      *BLANKS       SXRIC             1
     C                   MOVE      *BLANKS       SNXID             6
     C                   MOVE      *BLANKS       SXRIF             1
     C                   MOVE      *BLANKS       SXNCD             2
     C                   MOVE      *BLANKS       SXACP            21
     C                   MOVE      *BLANKS       SXRBR             3
 
      ** Get effective rates
 
     C                   EXSR      CALRAT
 
      ** DR pickup
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'E'
 
      ** Rates
 
     C                   MOVEL     PDRIB         PXRIB             2
     C                   MOVE      PDRIS         PXRIS            11 7
     C                   MOVEL     PDICT         PXICT             2
     C                   Z-ADD     PDCST         PXCST             5 0
 
      ** Other details
 
     C                   Z-ADD     E2DRIC        PXRIC             1 0
     C                   MOVEL     E2DRIF        PXRIF             1
     C                   MOVEL     E2DRDY        PXRDY             4
     C                   MOVEL     E2DACP        PXACP            24
     C                   MOVEL     E2NDID        PNXID             5 0
     C                   MOVEL     E2RTTD        PRTTX             5
     C                   MOVEL     E2DYBD        PDYBX             1
     C                   MOVEL     E2DRST        PXRST             1
 
     C                   EXSR      GENPIC
 
     C                   MOVE(P)   SXRIB         DDDRIB
     C                   MOVE(P)   SXRIS         DDDRIS
     C                   MOVE(P)   SXSIG         DDDSIG
     C                   MOVE(P)   SXICT         DDDICT
     C                   MOVE(P)   SXCST         DDDCST
     C                   MOVE(P)   SXRIC         DDDRIC
     C                   MOVE(P)   SNXID         DDNDID
     C                   MOVE(P)   SXRIF         DDDRIF
     C                   MOVE(P)   SXNCD         DDDNCD
     C                   MOVE(P)   SXRBR         DDDRBR
     C                   MOVE(P)   SXACP         DDDACP
     C                   MOVEL     *BLANKS       DDDRCD
 
     C     DDDRIB        IFNE      PR_DDDRIB
     C     DDDRIS        ORNE      PR_DDDRIS
     C     DDDSIG        ORNE      PR_DDDSIG
     C     DDDICT        ORNE      PR_DDDICT
     C     DDDCST        ORNE      PR_DDDCST
     C     E2TPRD        IFEQ      'T'
     C                   Z-ADD     E2VDAT        ZDAYNO
     C                   ELSE
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   ENDIF
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVEL     ZDATE         DDDRCD
     C                   ENDIF
 
      ** CR Pickup
 
     C                   MOVEL     PCRIB         PXRIB             2
     C                   Z-ADD     PCRIS         PXRIS            11 7
     C                   MOVEL     PCICT         PXICT             2
     C                   Z-ADD     PCCST         PXCST             5 0
 
      ** Other details
 
     C                   Z-ADD     E2CRIC        PXRIC             1 0
     C                   MOVEL     E2CNIR        PXNIR             1
     C                   MOVEL     E2CRIF        PXRIF             1
     C                   MOVEL     E2CRDY        PXRDY             4
     C                   MOVEL     E2CACP        PXACP            24
     C                   MOVEL     E2NCID        PNXID             5 0
     C                   MOVEL     E2RTTC        PRTTX             5
     C                   MOVEL     E2DYBC        PDYBX             1
     C                   MOVEL     E2CRST        PXRST             1
 
     C                   EXSR      GENPIC
 
     C                   MOVE(P)   SXRIB         DDCRIB
     C                   MOVE(P)   SXRIS         DDCRIS
     C                   MOVE(P)   SXSIG         DDCSIG
     C                   MOVE(P)   SXICT         DDCICT
     C                   MOVE(P)   SXCST         DDCCST
     C                   MOVE(P)   SXRIC         DDCRIC
     C                   MOVE(P)   SNXID         DDNCID
     C                   MOVE(P)   SXRIF         DDCRIF
     C                   MOVE(P)   SXNCD         DDCNCD
     C                   MOVE(P)   SXRBR         DDCRBR
     C                   MOVE(P)   SXACP         DDCACP
     C                   MOVEL     *BLANKS       DDCRCD
 
     C     DDCRIB        IFNE      PR_DDCRIB
     C     DDCRIS        ORNE      PR_DDCRIS
     C     DDCSIG        ORNE      PR_DDCSIG
     C     DDCICT        ORNE      PR_DDCICT
     C     DDCCST        ORNE      PR_DDCCST
     C     E2TPRD        IFEQ      'T'
     C                   Z-ADD     E2VDAT        ZDAYNO
     C                   ELSE
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   ENDIF
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVEL     ZDATE         DDCRCD
     C                   ENDIF
 
     C                   END
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  CALRAT - Rate Calculation Processing                         *
      *                                                               *
      *****************************************************************
     C     CALRAT        BEGSR
 
      ** If there is a periodic rate fixing, then the effective rate
      ** must be calculated
 
     C     'P'           IFEQ      E2DNIR
     C     'P'           OREQ      E2CNIR
 
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'INSER'       P@MODE
     C                   ELSE
     C                   MOVEL     'ENQUI'       P@MODE
     C                   ENDIF
     C                   CALL      'RE4017'
     C                   PARM                    REPFMT
     C                   PARM                    R@RTCD            7
     C                   PARM                    P@MODE            5
 
      ** Effective debit rates
 
     C**********         PARM                    X1DRIB            2 0                        CSD103
     C                   PARM                    X1DRIB            2                          CSD103
     C                   PARM                    X1DRIS           11 7
     C                   PARM                    X1DICT            2 0
     C                   PARM                    X1DCST            5 0
 
      ** Effective credit rates
 
     C**********         PARM                    X1CRIB            2 0                        CSD103
     C                   PARM                    X1CRIB            2                          CSD103
     C                   PARM                    X1CRIS           11 7
     C                   PARM                    X1CICT            2 0
     C                   PARM                    X1CCST            5 0
 
     C                   ENDIF
 
      ** Debit rates (for fixed rate, use effective rate)
 
     C     'P'           IFEQ      E2DNIR
     C                   Z-ADD     X1DRIB        PDRIB             2 0
     C                   Z-ADD     X1DRIS        PDRIS            11 7
     C                   Z-ADD     X1DICT        PDICT             2 0
     C                   Z-ADD     X1DCST        PDCST             5 0
     C                   ELSE
     C                   Z-ADD     E2DRIB        PDRIB
     C                   Z-ADD     E2DRIS        PDRIS
     C                   Z-ADD     E2DICT        PDICT
     C                   Z-ADD     E2DCST        PDCST
     C                   ENDIF
 
      ** Credit rates (for fixed rate, use effective rate)
 
     C     'P'           IFEQ      E2CNIR
     C                   Z-ADD     X1CRIB        PCRIB             2 0
     C                   Z-ADD     X1CRIS        PCRIS            11 7
     C                   Z-ADD     X1CICT        PCICT             2 0
     C                   Z-ADD     X1CCST        PCCST             5 0
     C                   ELSE
     C                   Z-ADD     E2CRIB        PCRIB
     C                   Z-ADD     E2CRIS        PCRIS
     C                   Z-ADD     E2CICT        PCICT
     C                   Z-ADD     E2CCST        PCCST
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  GENPIC - Other details Processing                            *
      *                                                               *
      *****************************************************************
     C     GENPIC        BEGSR
 
     C                   MOVEL     *BLANKS       SXRIB
     C     PXRIB         IFNE      '00'
     C                   MOVEL     PXRIB         SXRIB
     C                   END
     C                   MOVEL     *BLANKS       SXRIS
     C                   MOVEL     *BLANKS       SXSIG
     C     PXRIS         IFNE      0
     C                   MOVEL     '+'           SXSIG
     C     PXRIS         IFLT      0
     C                   Z-SUB     PXRIS         PXRIS
     C                   MOVEL     '-'           SXSIG
     C                   END
     C     PXRIS         MULT      10000000      ZFLD15
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      7             ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
     C                   MOVE      ZOUT21        SXRIS
     C                   MOVE(P)   SXRIS         ZFIELD
     C                   Z-ADD     4             ZADIG
     C                   Z-ADD     7             ZADEC
     C                   EXSR      NEDIT
     C                   MOVE      ZAFLD1        SXRIS
     C                   END
     C                   MOVEL     *BLANKS       SXICT
     C     PXICT         IFNE      '00'
     C                   MOVEL     PXICT         SXICT
     C                   END
     C                   MOVEL     *BLANKS       SXCST
     C     PXCST         IFNE      0
     C                   MOVEL     PXCST         SXCST
     C                   END
 
     C                   MOVEL     PXRIC         SXRIC
     C                   MOVEL     *BLANKS       SNXID
     C     PNXID         IFNE      *ZERO
     C                   Z-ADD     PNXID         ZDAYNO
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVEL     ZDATE         SNXID
     C                   ENDIF
     C     E2MDAT        IFLT      26664
     C                   MOVEL     'Z'           SXRIF
     C                   MOVEL     *BLANKS       SXNCD
     C                   ELSE
     C                   MOVEL     PXRIF         SXRIF
     C                   MOVEL     PXRDY         SXNCD
     C                   END
     C                   MOVEL     *BLANKS       SXACP
     C                   MOVEL     *BLANKS       SXRBR
     C     1             SUBST     PXACP:11      W1A               1
     C     W1A           IFNE      ' '
     C     3             SUBST     PXACP:1       SXRBR
     C     21            SUBST     PXACP:4       SXACP
     C                   ELSE
     C                   MOVEL     PXACP         SXACP
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  NEDIT  - Numeric Edit and Format Processing                  *
      *                                                               *
      *****************************************************************
     C     NEDIT         BEGSR
 
      ** Use standard routine to check and format
 
     C                   MOVE(P)   ZFIELD        ZAFLD1           16
 
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       ZRTN              7
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
     C                   PARM                    ZAFLD            16
 
     C     ZRTN          IFEQ      *BLANKS
     C                   MOVE      ZAFLD         ZFLD15
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM      ZADEC         ZDECS             1 0
     C                   PARM                    ZECODE            1
     C                   PARM                    ZOUT21           21
 
     C     16            SUBST     ZOUT21:5      ZAFLD1
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    ACPRIM
     C                   PARM                    ACDEBT
     C                   PARM                    ACCRDT
     C                   PARM                    PRDEBT
     C                   PARM                    PRCRDT
     C                   PARM                    REPFMT
     C                   PARM                    PRTCD
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST'      POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   RETURN
 
     C                   ENDSR
