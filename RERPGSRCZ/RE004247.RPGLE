     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                 : *
/*EXI *  TEXT('Midas RE RATM Calculation of Penalty Amount')          *
      *****************************************************************
      *                                                               *
      *  Midas RE - Retail Module                                     *
      *                                                               *
      *  RE004247 - Midas RE RATM Calculation of Penalty Amount       *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR849279           Date 14Oct11               *
      *                 CRE072  *CREATE    Date 30Jun11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR849279 - RATM Calculation does not accept Debit Account    *
      *             other than Retail Account Format                  *
      *  CRE072 - BankFusion Midas Teller Related Changes             *
      *                                                               *
      *****************************************************************
      *
      ** Midas RE T&N Accounts - Periods and Penalties
      *
     FREPRPNPD  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Midas RE Retail Transaction Charges File
      *
     FRETRG     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(RETRGAF)
     F                                     IGNORE(RETRGZF)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *    81 - Read RETRG indicator                                  *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR      - Error processing                                 *
      * SrInit     - Program Initialization                           *
      * SrPrmFil   - Fill details with input parameters               *
      * SrGetPP    - Get P+P details for given account                *
      * SrSetNtf   - Setup notifications                              *
      * SrGetPCh   - Get penalty charge rate or amount                *
      * SrCalcPn   - Get penalty calculation details                  *
      * SrAccumN   - Accumulate notification work values              *
      * SrPrmOut   - Place into output parameters                     *
      *                                                               *
      *****************************************************************
      *
      ** Program data structure
      *
     D PGMDS          SDS
     D  SPGM                   1     10
     D  SJOB                 244    253
     D  SUSER                254    263
      *
      ** Parameters
      *
     D P@FMT         E DS                  EXTNAME(DSSDY)
      *
      ** Account details
      *
     D ACFMT         E DS                  EXTNAME(ACCNTAB)
      *
      ** Bank details
      *
     D BKFMT         E DS                  EXTNAME(SDBANKPD)
      *
      ** Movement fields
      *
     D MVFMT         E DS                  EXTNAME(RERTMVPD)
      *
      ** Notification fields
      *
     D MUFMT         E DS                  EXTNAME(RERTMUPD)
      *
      ** Structure for transaction charge key
      *
     D DSKEY           DS
     D  W1RTTX                 4      8
     D  W1CCY                  9     11
     D  W1DDDD                12     12
      *
      *****************************************************************
      *                                                               *
      *  M A I N   P R O C E S S I N G                                *
      *                                                               *
      *****************************************************************
      *
      ** Initialise
      *
     C                   EXSR      SrInit
      *
      ** Fill details with input parameters
      *
     C                   EXSR      SrPrmFil
      *
      ** Get P+P details for given account
      *
     C                   EXSR      SrGetPP
      *
      ** Setup notifications
      *
     C                   EXSR      SrSetNtf
      *
      ** Get penalty charge rate or amount
      *
     C                   EXSR      SrGetPCh
      *
      ** Get penalty calculation details
      *
     C                   EXSR      SrCalcPn
      *
      ** Place into output parameters
      *
     C                   EXSR      SrPrmOut
      *
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      *                                                               *
      *  SrPrmFil - Fill details with input parameters                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SrPrmFil      BEGSR
      *
      ** Convert passed parms to file fields
      **  Account
      *
     C                   MOVEL     PKEY1         E4KEY1
      *
      **  Account Details
      *
     C                   MOVEL     BRCA          PBRCA             3
     C                   MOVE      CNUM          PCNUM             6
     C                   MOVEL     CCY           PCCY              3
     C                   MOVEL     ACOD          PACOD            10
     C                   MOVEL     ACSQ          PACSQ             2
     C                   Z-ADD     BJRDNB        PDATE             5 0
      *
      **  Adjustment amount
      *
     C                   Z-ADD     PAJAA         E4AJAA
     C                   MOVEL     PDC01         E4DC01
      *
      **  Penalty amount
      *
     C                   Z-ADD     0             PXNIN            15 0
     C                   Z-ADD     PXNIN         E4PNIN
     C                   MOVEL     PDC02         E4DC02
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrGetPP - Get P+P details for given account                  *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SrGetPP       BEGSR
      *
      ** Access P+P details
      *
     C                   Z-ADD     *ALL'9'       W1MAXP           15 0
     C                   MOVEL     PBRCA         E2BRCA
     C                   MOVE      PCNUM         E2CNUM
     C                   MOVEL     PCCY          E2CCY
     C                   MOVE      PACOD         E2ACOD
     C                   MOVE      PACSQ         E2ACSQ
     C                   MOVEL     *BLANKS       E2EVNT
     C                   Z-ADD     0             E2ITEM
     C     KPRPN1        SETLL     REPRPNPD
     C     KPRPN2        READE     REPRPNPD                               81
      *
      ** Remove values when record not found
      *
     C     *IN81         IFEQ      *ON
     C     PDC01         IFEQ      'C'
     C                   MOVE      *BLANK        E2CRST
     C                   MOVE      *BLANK        E2DYBC
     C                   MOVE      *BLANKS       E2RTTC
     C                   ENDIF
     C     PDC01         IFEQ      'D'
     C                   MOVE      *BLANK        E2DRST
     C                   MOVE      *BLANK        E2DYBD
     C                   MOVE      *BLANKS       E2RTTD
     C                   ENDIF
     C                   Z-ADD     0             E2MDAT
     C                   Z-ADD     0             E2NDPD
     C                   MOVE      *BLANK        E2TPRD
     C                   ENDIF
      *
      ** Get DR or CR details, depending on movement
      *
     C     PDC01         IFEQ      'C'
     C                   Z-ADD     PAJAA         W1AJAA           15 0
     C                   Z-ADD     W1AJAA        W1UNEX           15 0
     C                   MOVEL     E2RTTC        W1RTTX            5
     C                   MOVEL     E2DYBC        W1DYBX            1
     C                   MOVEL     E2CRST        W1XRST            1
     C                   MOVEL     PDC01         W1SIGN            1
     C     E2DYBC        IFEQ      'S'
     C                   Z-ADD     PDATE         W1ENDP
     C                   ENDIF
     C     E2TPRD        IFEQ      'T'
     C     E2DYBC        ANDNE     'S'
     C                   Z-ADD     E2MDAT        W1ENDP            5 0
     C                   ENDIF
     C     E2TPRD        IFEQ      'N'
     C     E2DYBC        ANDNE     'S'
     C     PDATE         ADD       E2NDPD        W1ENDP
     C                   SUB       1             W1ENDP
     C                   ENDIF
     C     E2CRST        IFEQ      'I'
     C     PACCR         ANDGE     0
     C                   Z-ADD     PACCR         W1MAXP
     C                   ENDIF
     C                   ENDIF
      *
     C     PDC01         IFEQ      'D'
     C                   Z-ADD     PAJAA         W1AJAA
     C                   Z-ADD     W1AJAA        W1UNEX
     C                   MOVEL     E2RTTD        W1RTTX
     C                   MOVEL     E2DYBD        W1DYBX
     C                   MOVEL     E2DRST        W1XRST
     C                   MOVEL     PDC01         W1SIGN
     C     E2DYBD        IFEQ      'S'
     C                   Z-ADD     PDATE         W1ENDP
     C                   ENDIF
     C     E2TPRD        IFEQ      'T'
     C     E2DYBD        ANDNE     'S'
     C                   Z-ADD     E2MDAT        W1ENDP
     C                   ENDIF
     C     E2TPRD        IFEQ      'N'
     C     E2DYBD        ANDNE     'S'
     C     PDATE         ADD       E2NDPD        W1ENDP
     C                   SUB       1             W1ENDP
     C                   ENDIF
     C     E2DRST        IFEQ      'I'
     C     PACCR         ANDLE     0
     C                   Z-SUB     PACCR         W1MAXP
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrSetNtf - Setup notifications                               *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SrSetNtf      BEGSR
      *
      ** Take any remaining unexhausted movement from inexhaustible termination
      **  (early by 1 day after end of penalty period)
      *
     C     W1UNEX        IFNE      0
     C                   Z-ADD     W1UNEX        E5AJAA
     C                   MOVEL     W1SIGN        E5DC01
     C     W1ENDP        SUB       PDATE         WDATE             5 0
     C     WDATE         ADD       1             W1EARL
      *
      **  Time basis M = nbr of days early rounded up to nearest multiple of 30
      *
     C     W1DYBX        IFEQ      'M'
     C                   Z-ADD     0             W30N0            30 0
     C     W1EARL        IFGE      1
     C     W1EARL        SUB       1             W30N0
     C     W30N0         DIV       30            W30N0
     C                   ADD       1             W30N0
     C                   MULT      30            W30N0
     C                   ENDIF
     C                   Z-ADD     W30N0         W1EARL            5 0
     C                   ENDIF
     C                   Z-ADD     W1EARL        E5DYNO
     C                   Z-ADD     0             W1UNEX
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrGetPCh - Get penalty charge rate or amount                 *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SrGetPCh      BEGSR
      *
      ** Access Penalty charge details
      *
     C                   Z-ADD     *ALL'9'       W1CHAM           15 0
     C                   Z-ADD     0             W1PENA           30 9
     C                   Z-ADD     0             W1PENR           30 9
     C                   MOVEL     E2CCY         W1CCY
     C                   MOVEL     'D'           W1DDDD
     C                   MOVEL     DSKEY         KEY
     C     KEY           CHAIN     RETRG                              81
     C     *IN81         IFEQ      '0'
     C                   Z-ADD     CHAM          W1PENA
     C     DCAM          IFEQ      'C'
     C                   DUMP
     C                   Z-ADD     0             W1PENA
     C                   ENDIF
     C     CHPC          DIV       100           W1PENR
     C     DCPC          IFEQ      'C'
     C                   DUMP
     C                   Z-ADD     0             W1PENR
     C                   ENDIF
      *
      **  Time basis M needs rate/30, since early penalty cacld on daily excess
      *
     C     W1DYBX        IFEQ      'M'
     C     W1PENR        DIV       30            W1PENR
     C     W1PENA        DIV       30            W1PENA
     C                   ENDIF
     C                   ENDIF
      *
      ** Rate must not be 100% or more
      *
     C     W1PENR        IFGE      100
     C                   Z-ADD     0             W1PENR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrCalcPn - Get penalty calc details                          *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: SrAccumN                                              *
      *                                                               *
      *****************************************************************
     C     SrCalcPn      BEGSR
      *
      ** Penalty from Rate x Cumulated Excess per Days to Go basis
      ** or from      Rate x Cumulated Excess per Days to Go basis (30day meth)
      ** or from      Rate x Simple Excess (effectively only 1 day)
      *
     C     W1DYBX        IFEQ      'D'
     C     W1DYBX        OREQ      'M'
     C     W1DYBX        OREQ      'S'
      *
      **  Accumulate notification work values
      *
     C                   EXSR      SrAccumN
      *
      ** Calculate penalty using rate and work fields
      *
     C     W1PENR        IFNE      0
     C     W1DYBX        IFEQ      'S'
     C     W1AJAA        MULT      W1PENR        W1WRK3
     C                   ELSE
     C     W1AJAA        MULT      W1DLIM        W1WRK1
     C     W1WRK1        SUB       W1WRK2        W1WRK3           30 9
     C     W1WRK3        MULT      W1PENR        W1WRK3
     C                   ENDIF
     C                   ENDIF
      *
      ** Calculate penalty using amount and work fields
      *
     C     W1PENA        IFNE      0
      *
      ** If straight penalty use fixed amount
      *
     C     W1DYBX        IFEQ      'S'
     C     W1DLIM        IFGT      *ZERO
     C                   Z-ADD     W1PENA        W1WRK3
     C                   ELSE
     C                   Z-ADD     *ZERO         W1WRK3
     C                   ENDIF
      *
     C                   ELSE
     C     W1PENA        MULT      W1DLIM        W1WRK3
     C                   ENDIF
     C                   ENDIF
      *
      ** Move calculated amounts
      *
     C     W1WRK3        IFLE      W1MAXP
     C                   Z-ADD(H)  W1WRK3        W1TRUE           15 0
     C                   ELSE
     C                   Z-ADD     W1MAXP        W1TRUE
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     W1TRUE        W1CHAM
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrPrmOut - Place into output parameters                      *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SrPrmOut      BEGSR
      *
      ** Penalty
      *
      *
     C     W1CHAM        IFGE      0
     C                   Z-ADD     W1CHAM        PXNIN
     C                   MOVEL     'D'           PDC02
     C                   ELSE
     C                   Z-SUB     W1CHAM        PXNIN
     C                   MOVEL     'C'           PDC02
     C                   ENDIF
      *
     C                   EVAL      PPNIN = PXNIN / 100
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrAccumN - Accumulate notification work values               *
      *                                                               *
      *  Called by: SrCalcPn                                          *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     SrAccumN      BEGSR
      *
     C                   Z-ADD     0             W1NATD           30 0
     C                   Z-ADD     0             W1WRK1           30 0
     C                   Z-ADD     0             W1WRK2           30 0
     C                   Z-ADD     0             W1CUMN           30 0
     C                   Z-ADD     0             W1DIFD            5 0
     C                   Z-ADD     0             W1PVDY            5 0
     C                   Z-ADD     0             W1DLIM            5 0
      *
      ** Go through allocations
      *
     C                   Z-ADD     0             GRPAJA           30 0
     C                   Z-ADD     0             GRPDYN            5 0
     C                   Z-ADD     E5DYNO        GRPDYN
     C                   ADD       E5AJAA        GRPAJA
      *
     C     GRPDYN        IFGT      W1DLIM
     C                   Z-ADD     GRPDYN        W1DLIM
     C                   ENDIF
      *
     C     GRPDYN        IFNE      W1PVDY
     C     GRPDYN        SUB       W1PVDY        W1DIFD
     C                   ADD       W1NATD        W1CUMN
     C                   Z-ADD     0             W1NATD
     C     W1DIFD        MULT      W1CUMN        W1TMP            30 0
     C                   ADD       W1TMP         W1WRK2
     C                   Z-ADD     GRPDYN        W1PVDY
     C                   ENDIF
     C                   ADD       GRPAJA        W1NATD
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  SrInit - Program Initialization                              *
      *                                                               *
      *  Called by: Main Processing                                   *
      *  Calls: AOBANKR0, AOACCTR0, RE4014                            *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Return code
      *
     C                   PARM                    PRTCD             7
      *
      ** Account key
      *
     C**********         PARM                    PKEY1            24                        AR849279
     C                   PARM                    PKEY1            10                        AR849279
      *
      ** Adjustment amount
      *
     C                   PARM                    PAJAA            15 0
      *
      ** Adjustment amount debit / credit indicator
      *
     C                   PARM                    PDC01             1
      *
      ** Penalty amount
      *
     C                   PARM                    PPNIN            13 2
      *
      ** Penalty amount debit / credit indicator
      *
     C                   PARM                    PDC02             1
      *
      ** Initialise Key lists
      *
     C     PDC01         IFNE      'C'
     C     PDC01         ANDNE     'D'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Initialise Key lists
      *
     C     KPRPN1        KLIST
     C                   KFLD                    E2BRCA
     C                   KFLD                    E2CNUM
     C                   KFLD                    E2CCY
     C                   KFLD                    E2ACOD
     C                   KFLD                    E2ACSQ
     C                   KFLD                    E2EVNT
     C                   KFLD                    E2ITEM
      *
     C     KPRPN2        KLIST
     C                   KFLD                    E2BRCA
     C                   KFLD                    E2CNUM
     C                   KFLD                    E2CCY
     C                   KFLD                    E2ACOD
     C                   KFLD                    E2ACSQ
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*FIRST'      P@OPTN            7
     C     BKFMT         PARM      *BLANKS       P@FMT
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Account Details
      *
     C                   CALL      'AOACCTR0'
     C                   PARM                    P@RTCD            7
     C                   PARM      '*KEY'        P@OPTN            7
     C                   PARM      PKEY1         P@RETL           10
     C                   PARM      *BLANKS       P@CNUM            6
     C                   PARM      *BLANKS       P@CUCD            3
     C                   PARM      *BLANKS       P@ACCD           10
     C                   PARM      *BLANKS       P@ACSQ            2
     C                   PARM      *BLANKS       P@BRCA            3
     C     ACFMT         PARM      *BLANKS       P@FMT
      *
     C     P@RTCD        IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Account Balance
      *
     C                   CALL      'RE4014'
     C                   PARM      PKEY1         PWKEY1           24
     C                   PARM                    PSODL            15 0
     C                   PARM                    PPRJL            15 0
     C                   PARM                    PSODC            15 0
     C                   PARM                    PPRJC            15 0
     C                   PARM                    PDISP            15 0
     C                   PARM                    PHELD            15 0
     C                   PARM                    POVER            15 0
     C                   PARM                    PACCR            15 0
     C                   PARM                    PCHRG            15 0
     C                   PARM                    PWTAX            15 0
     C                   PARM                    PRTCD             7
      *
     C     PRTCD         IFNE      *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: SrInit                                            *
      *  Calls: none                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   EVAL      PRTCD = '*ERROR'
     C                   DUMP
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
