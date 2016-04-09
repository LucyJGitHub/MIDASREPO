      *****************************************************************
     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Lending History Rebuild')      *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  CG7380 - Midas Interest Scale Lending Historic Rebuild       *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Indicators
      *
      *  nn  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
      *
      *****************************************************************
 
      ** Loan master file
     FCLOANCL   IP   E             DISK
 
      ** Historic loans by branch, customer, loan and date
     FHISTR     IF   E           K DISK
 
      ** Interest Rate loans history file
     FCGISLHPD  O    E             DISK
 
      ** Redefine the fields in the historic file
     IHISTSHPF
     I              BRCA                        H1BRCA
     I              CNUM                        H1CNUM
     I              LNRF                        H1LNRF
     I              VDAT                        H1VDAT
     I              PTYP                        H1PTYP
     I              CCY                         H1CCY
     I              AMTP                        H1AMTP
     I              PRAM                        H1PRAM
     I              INTA                        H1INTA
     I              LTYP                        H1LTYP
     I              SUTP                        H1SUTP
     IHISTSHMF
     I              BRCA                        H1BRCA
     I              CNUM                        H1CNUM
     I              LNRF                        H1LNRF
     I              VDAT                        H1VDAT
     I              PTYP                        H1PTYP
     I              CCY                         H1CCY
     I              AMTP                        H1AMTP
     I              PRAM                        H1PRAM
     I              BRTE                        H1BRTE
     I              RTSP                        H1RTSP
     I              SPIN                        H1SPIN
     I              CALC                        H1CALC
     I              INTC                        H1INTC
     I              LTYP                        H1LTYP
     I              SUTP                        H1SUTP
     IHISTSHQF
     I              BRCA                        H1BRCA
     I              CNUM                        H1CNUM
     I              LNRF                        H1LNRF
     I              VDAT                        H1VDAT
     I              PTYP                        H1PTYP
     I              CCY                         H1CCY
     I              AMTP                        H1AMTP
     I              BRTE                        H1BRTE
     I              RTSP                        H1RTSP
     I              SPIN                        H1SPIN
     I              CALC                        H1CALC
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Main routine - main controling subroutine                    *
      *                                                               *
      *  Called by :  none                                            *
      *  Calls     :  none                                            *
      *                                                               *
      *  If the record is live                                        *
      *                                                               *
      *****************************************************************
     C     RECI          IFNE      'R'
 
      ** Set-up key fileds
     C                   MOVE      BRCA          KBRCA
     C                   MOVE      CNUM          KCNUM
     C**********         Z-ADD     LNRF          KLNRF                                        CLE148
     C                   MOVEL     LNRF          KLNRF                                        CLE148
     C                   Z-ADD     0             KVDAT
 
      ** Position the file pointer to the start of this loan
     C     HLKEY         SETLL     HISTR
 
      ** Read the history file until eof or end of loan
     C     HSKEY         READE     HISTR                                  89
 
      ** Loop until end of file or  end of interest period
     C     *IN89         DOWEQ     *OFF
 
      ** Set-up constant file fields
     C                   MOVE      H1BRCA        Z9BRCA
     C                   MOVE      H1CNUM        Z9CNUM
     C**********         Z-ADD     H1LNRF        Z9LNRF                                       CLE148
     C                   MOVEL     H1LNRF        Z9LNRF                                       CLE148
     C                   Z-ADD     H1PTYP        Z9PTYP
     C                   MOVE      H1CCY         Z9CCY
     C                   MOVE      H1AMTP        Z9AMTP
     C                   Z-ADD     H1VDAT        Z9VDAT
     C                   MOVE      H1INTC        Z9INTC
 
      ** Extract details depending on action type
     C                   SELECT
 
      ** Start date
     C     H1AMTP        WHENEQ    'ST'
     C                   EXSR      START
 
      ** Principal increase
     C     H1AMTP        WHENEQ    'PI'
     C                   EXSR      PRINCE
 
      ** Manual repayment
     C     H1AMTP        WHENEQ    'MR'
     C                   EXSR      REPAY
 
      ** Interest capitalisation
     C     H1AMTP        WHENEQ    'IN'
     C                   EXSR      INTCAP
 
      ** Scheduled repayment
     C     H1AMTP        WHENEQ    'RE'
     C                   EXSR      REPAY
 
      ** Rollover
     C     H1AMTP        WHENEQ    'RO'
     C                   EXSR      RATE
 
      ** Spread rate change
     C     H1AMTP        WHENEQ    'SC'
     C                   EXSR      RATE
 
      ** Base rate change
     C     H1AMTP        WHENEQ    'BR'
     C                   EXSR      RATE
 
      ** Base rate code change
     C     H1AMTP        WHENEQ    'BC'
     C                   EXSR      RATE
 
      ** Maturity
     C     H1AMTP        WHENEQ    'MA'
     C                   EXSR      REPAY
 
      ** Manual adjustment to interest
     C     H1AMTP        WHENEQ    'MI'
     C                   EXSR      INTADJ
     C                   ENDSL
 
      ** Read the history file until eof or end of period
     C     HSKEY         READE     HISTR                                  89
     C                   ENDDO
     C                   ENDIF
 
      ** Logical end of the program
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  *INZSR - Initial Processing                                  *
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     HSKEY         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
      *
      ** Long key list for the history file
      *
     C     HLKEY         KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
 
      ** Define the work fields
     C     *LIKE         DEFINE    BRCA          KBRCA
     C     *LIKE         DEFINE    CNUM          KCNUM
     C     *LIKE         DEFINE    LNRF          KLNRF
     C     *LIKE         DEFINE    H1VDAT        KVDAT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  START SR. Start date processing                              *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     START         BEGSR
 
      ** Principal change amount
     C                   Z-ADD     H1PRAM        Z9PCHG
 
      ** Add the principal to the current principal
     C                   Z-ADD     H1PRAM        Z9PCPL
 
      ** Zero the interest
     C                   Z-ADD     0             Z9INTA
 
      ** Base rate
     C                   Z-ADD     H1BRTE        Z9BRTE
 
      ** Rate/spread
     C                   Z-ADD     H1RTSP        Z9RTSP
 
      ** Spread indicator
     C                   MOVE      H1SPIN        Z9SPIN
 
      ** Calculation basis
     C                   Z-ADD     H1CALC        Z9CALC
 
      ** Write record to the lending history file
     C                   WRITE     CGISLHD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  PRINCE SR. Principal change processing                       *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     PRINCE        BEGSR
      *
      *  Principal change amount
      *
     C                   Z-ADD     H1PRAM        Z9PCHG
      *
      *  Add the principal to the current principal
      *
     C                   ADD       H1PRAM        Z9PCPL
      *
      *  Zero the interest
      *
     C                   Z-ADD     0             Z9INTA
      *
      *  Write record to the lending history file
      *
     C                   WRITE     CGISLHD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  REPAY SR. Repayment processing                               *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     REPAY         BEGSR
      *
      *  Principal change amount
      *
     C                   Z-ADD     H1PRAM        Z9PCHG
      *
      *  Subtract the principal to the current principal
      *
     C                   SUB       H1PRAM        Z9PCPL
      *
      *  If interest capitalisation add the interest to principal
      *
     C     INTC          IFEQ      'Y'
     C                   ADD       H1INTA        Z9PCPL
     C                   ENDIF
      *
      *  Add the interest
      *
     C                   Z-ADD     H1INTA        Z9INTA
      *
      *  Write record to the lending history file
      *
     C                   WRITE     CGISLHD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INTCAP SR. Interest capitalisation processing                *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     INTCAP        BEGSR
      *
      *  Principal change amount
      *
     C                   Z-ADD     0             Z9PCHG
      *
      *  If interest capitalisation add the interest to principal
      *
     C     INTC          IFEQ      'Y'
     C                   ADD       H1INTA        Z9PCPL
     C                   ENDIF
      *
      *  Interest amount
      *
     C                   Z-ADD     H1INTA        Z9INTA
      *
      *  Write record to the lending history file
      *
     C                   WRITE     CGISLHD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  RATE SR. Rate change processing                              *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     RATE          BEGSR
      *
      *  Principal change amount
      *
     C                   Z-ADD     0             Z9PCHG
      *
      *  Zero the interest
      *
     C                   Z-ADD     0             Z9INTA
      *
      *  If rollover or base rate change
      *
     C     H1AMTP        IFEQ      'RO'
     C     H1AMTP        OREQ      'BR'
     C                   Z-ADD     H1BRTE        Z9BRTE
     C                   ENDIF
      *
      *  If rollover or rate/spread change
      *
     C     H1AMTP        IFEQ      'RO'
     C     H1AMTP        OREQ      'SC'
     C                   Z-ADD     H1RTSP        Z9RTSP
     C                   ENDIF
      *
      *  If rollover spread indicator and  calculation basis
      *
     C     H1AMTP        IFEQ      'RO'
     C                   MOVE      H1SPIN        Z9SPIN
     C                   Z-ADD     H1CALC        Z9CALC
     C                   ENDIF
      *
      *  Write record to the lending history file
      *
     C                   WRITE     CGISLHD0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INTADJ SR. Interest adjustment                               *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     INTADJ        BEGSR
 
      ** Principal change amount
     C                   Z-ADD     0             Z9PCHG
 
      ** Add the principal to the current principal
     C                   Z-ADD     0             Z9PCPL
 
      ** Zero the interest
     C                   Z-ADD     H1INTA        Z9INTA
 
      ** Write record to the lending history file
     C                   WRITE     CGISLHD0
 
     C                   ENDSR
