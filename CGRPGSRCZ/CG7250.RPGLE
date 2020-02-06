     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Extract LE Int movements')     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7250 - CG Interest Scale extract the lending interest      *
      *           movements                                           *
      *                                                               *
      *  Function: Reads from Interest Scale Lending History file     *
      *            CGISLHPD and writes the qualifying records to      *
      *            CGISDDPD file                                      *
      *                                                               *
      *  Called By: CGC7250 - CG Interest Scale Extract Lending Movemt*
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR847818           Date 26Apr13               *
      *                 AR996895           Date 06Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR847818 - Remove zero interest amount (Child:AR847819)      *
      *  AR996895 - Incorrect accrual interest calculation            *
      *             (Child: AR996897) (Recompile)                     *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  89 - General chain fail error                                *
      *                                                               *
      *****************************************************************
 
      ** Historic loans by branch, customer, loan and date
     FCGISLHL0  IF   E           K DISK    USROPN
 
      ** Interest Scale detail file
     FCGISDDPD  O    E             DISK    USROPN
 
      ** Working variables
     D PREFN           S             10A
     D PREFT           S              1A
     D PINTA           S              9A
     D PADDI           S              1A
     D PRDFC           S              1A
     D PFRLS           S              5A
     D PRTCD           S              7A
     D @NETI           S             17  0
 
      ** Copy for date conversion
      /COPY ZSRSRC,ZDATE9Z1LE
 
      ** Data structure to allow passed alpha field
     D @DINTA          DS
     D  @DINTN                 1      9P 0
 
      ** Data structure for interest days calculation routine for SR ZINTDY
      /COPY ZSRSRC,ZINTDYZ1LE
 
      ** Data structure for date conversion routine
      /COPY ZSRSRC,ZDATE9Z2LE
      /COPY ZSRSRC,ZDAT10Z1LE
 
      *****************************************************************
      *
      *  Main routine - main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  SrFIRST - Initial houskeeping
      *            :  SrDetail - Detail processing
      *            :  SrLast   - Final housekeeping
      *
      *****************************************************************
     C                   SELECT
 
      ** If the first pass of the program
     C     PFRLS         WHENEQ    'FIRST'
 
      ** Perform the initial houskeeping
     C                   EXSR      SrFIRST
 
      ** If the last pass of the program
     C     PFRLS         WHENEQ    'LAST'
 
      ** Perform the final houskeeping
     C                   EXSR      SrLAST
 
      ** If neither first nor last pass
     C                   OTHER
 
      ** Perform detail processing
     C                   EXSR      SrDETAIL
     C                   ENDSL
     C                   RETURN
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Non-executable code, KLISTs, PLISTs, etc.
      *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    PBRCA
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PREFN
     C                   PARM                    PREFT
     C                   PARM                    PLNRF
     C                   PARM                    PINFD
     C                   PARM                    PINTD
     C                   PARM                    PINTA
     C                   PARM                    PADDI
     C                   PARM                    PRDFC
     C                   PARM                    PFRLS
     C                   PARM                    PRTCD
 
      ** Short key list for the history file
     C     CGSKEY        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
 
      ** Long key list for the history file
     C     CGLKEY        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KCNUM
     C                   KFLD                    KLNRF
     C                   KFLD                    KEDAT
 
      ** Define the work fields
     C     *LIKE         DEFINE    Z9BRCA        PBRCA
     C     *LIKE         DEFINE    Z9CNUM        PCNUM
     C     *LIKE         DEFINE    Z9CCY         PCCY
     C     *LIKE         DEFINE    Z6ACOD        PACOD
     C     *LIKE         DEFINE    Z6ACSQ        PACSQ
     C     *LIKE         DEFINE    Z9LNRF        PLNRF
     C     *LIKE         DEFINE    Z9VDAT        PINTD
     C     *LIKE         DEFINE    Z9VDAT        PINFD
     C     *LIKE         DEFINE    Z9BRCA        KBRCA
     C     *LIKE         DEFINE    Z9CNUM        KCNUM
     C     *LIKE         DEFINE    Z9LNRF        KLNRF
     C     *LIKE         DEFINE    Z9VDAT        KEDAT
     C     *LIKE         DEFINE    Z9VDAT        @OEDAT
     C     *LIKE         DEFINE    Z9PCPL        @OCPAM
     C     *LIKE         DEFINE    Z6RATE        @OINTR
     C     *LIKE         DEFINE    Z9BRTE        @OBRTE
     C     *LIKE         DEFINE    Z9RTSP        @ORTSP
     C     *LIKE         DEFINE    Z9SPIN        @OSPIN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  FIRST SR. Initial housekeeping subroutine
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     SrFIRST       BEGSR
 
      ** Open the file
     C                   OPEN      CGISLHL0
     C                   OPEN      CGISDDPD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  SrLAST  Final housekeeping
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     SrLAST        BEGSR
 
      ** Close the file
     C                   CLOSE     CGISLHL0
     C                   CLOSE     CGISDDPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  SrDETAIL  Detail processing
      *
      *  Called by :  Main routine
      *  Calls     :  Init   - Field initialisation
      *            :  intadj - Interest adjustment processing
      *            :  intdet - Interest detail processing
      *
      *****************************************************************
     C     SrDETAIL      BEGSR
 
      ** Initialise fields
     C                   EXSR      INIT
 
      ** Set the key fields from the passed parameters
     C                   MOVE      PBRCA         KBRCA
     C                   MOVEL     PCNUM         KCNUM
     C**********         Z-ADD     PLNRF         KLNRF                                        CLE148
     C                   MOVEL     PLNRF         KLNRF                                        CLE148
     C                   Z-ADD     PINFD         KEDAT
 
      ** Position the file pointer to the start of this interest period
     C     CGLKEY        SETLL     CGISLHL0
 
      ** Read the history file until eof or end of period
     C     CGSKEY        READE     CGISLHL0                               89
 
      ** Store the initial read of the values for comparrison
     C                   Z-ADD     Z9VDAT        @OEDAT
     C                   Z-ADD     Z9PCPL        @OCPAM
 
      ** If a base rate is blank use the spread
     C     Z9BRTE        IFEQ      0
     C                   Z-ADD     Z9RTSP        @OINTR
 
      ** If base rate entered use spread of it
     C                   ELSE
 
      ** Depending on the spread indicator use the spread
     C                   SELECT
 
      ** Add spread
     C     Z9SPIN        WHENEQ    'A'
     C     Z9BRTE        ADD       Z9RTSP        @OINTR
 
      ** Subtract spread
     C     Z9SPIN        WHENEQ    'D'
     C     Z9BRTE        SUB       Z9RTSP        @OINTR
 
      ** Percentage of spread
     C     Z9SPIN        WHENEQ    'P'
     C     Z9BRTE        MULT      Z9RTSP        @OINTR
     C                   DIV       100           @OINTR
 
      ** Blank
     C     Z9SPIN        WHENEQ    ' '
     C                   Z-ADD     Z9BRTE        @OINTR
     C                   ENDSL
     C                   ENDIF
     C                   Z-ADD     Z9BRTE        @OBRTE
     C                   Z-ADD     Z9RTSP        @ORTSP
     C                   MOVE      Z9SPIN        @OSPIN
 
      ** Loop until end of file or  end of interest period
     C     *IN89         DOWEQ     *OFF
     C     Z9VDAT        ANDLE     PINTD
 
      ** If an interest adjustment and not start or end date
      ** adjust the interest amount
     C     Z9INTA        IFNE      0
     C     Z9VDAT        ANDGT     PINFD
     C     Z9VDAT        ANDLT     PINTD
     C                   EXSR      INTADJ
     C                   ENDIF
 
      ** Process the history interest details
     C                   EXSR      INTDET
 
      ** Read the history file until eof or end of period
     C     CGSKEY        READE     CGISLHL0                               89
     C                   ENDDO
 
      ** Move the net interest to the parameter field
     C                   MOVE      @DINTA        PINTA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  INIT SR. Field initialisation
      *
      *  Called by :  Detail - Detail processing
      *  Calls     :  none
      *
      *****************************************************************
     C     INIT          BEGSR
 
      ** Initialise the field values
      ** Store the net interest passed for rounding
     C                   MOVE      PINTA         @DINTA
     C                   Z-ADD     @DINTN        @NETI
 
      ** Clear the return code
     C                   MOVE      *BLANKS       PRTCD
 
      ** Initialise the calculated net interest
     C                   Z-ADD     0             @DINTN
 
      ** Set the constant file fields
     C                   MOVE      PBRCA         Z6BRCA
     C                   MOVE      PCNUM         Z6CNUM
     C                   MOVE      PCCY          Z6CCY
     C                   Z-ADD     PACOD         Z6ACOD
     C                   Z-ADD     PACSQ         Z6ACSQ
     C                   MOVE      PREFN         Z6REFN
     C                   MOVE      PREFT         Z6REFT
     C                   Z-ADD     PINTD         Z6INCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  INTADJ SR. Interest adjustment processing
      *
      *  Called by :  Detail - Detail processing
      *  Calls     :  none
      *
      *****************************************************************
     C     INTADJ        BEGSR
 
      ** Move the details to the file fields
     C                   Z-ADD     Z9VDAT        Z6MOVD
     C                   Z-ADD     0             Z6ABAL
     C                   Z-ADD     0             Z6DAYS
     C                   Z-ADD     0             Z6RATE
     C                   Z-ADD     Z9INTA        Z6INTA
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        @DINTN
 
      ** Set the manual adjustment flag to yes
     C                   MOVE      'Y'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  INTDET SR. Initerest detail processing
      *
      *  Called by :  SrDetail - Detail processing
      *  Calls     :  none
      *
      *****************************************************************
     C     INTDET        BEGSR
 
      ** If the deal principal has increased
      ** or the interest rate has changed
      ** or this is the end of the interest period
     C     Z9PCPL        IFNE      @OCPAM
     C     Z9BRTE        ORNE      0
     C     Z9BRTE        ANDNE     @OBRTE
     C     Z9RTSP        ORNE      0
     C     Z9RTSP        ANDNE     @ORTSP
     C     Z9SPIN        ORNE      *BLANKS
     C     Z9SPIN        ANDNE     @OSPIN
     C     Z9VDAT        OREQ      PINTD
     C     Z9AMTP        ANDEQ     'IN'
 
      ** Move the details to the file fields
     C                   Z-ADD     @OEDAT        Z6MOVD
     C                   Z-SUB     @OCPAM        Z6ABAL
 
      ** Calculate the number of days
     C     Z9VDAT        SUB       @OEDAT        Z6DAYS
     C                   Z-ADD     @OINTR        Z6RATE
 
      ** If the number of days is not zero calcualte interest
     C     Z6DAYS        IFGT      0
 
      ** Set fields for standard subroutine to calculate interest
     C                   Z-ADD     @OEDAT        ZIBEG
     C                   Z-ADD     Z9VDAT        ZIEND
 
      ** If last day accruals subtract one from number of days
     C     PADDI         IFEQ      'L'
     C                   SUB       1             ZIEND
     C                   ENDIF
     C                   Z-ADD     @OCPAM        ZIAMT
     C                   MOVE      Z9CALC        ZICALC
     C                   Z-ADD     @OINTR        ZIRATE
 
      ** Use the standard sunroutine to calculate interest
     C                   EXSR      GLINTC
 
      ** If round down required, else half adjust
     C     PRDFC         IFEQ      'Y'
     C                   Z-SUB     ZINTR         Z6INTA
     C                   ELSE
     C                   Z-SUB(H)  ZINTR         Z6INTA
     C                   ENDIF
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        @DINTN
 
      ** If number of days is zero set interest amount to zero
     C                   ELSE
     C                   Z-ADD     0             Z6INTA
     C                   ENDIF
 
      ** If the last entry of the interest period
     C     Z9VDAT        IFEQ      PINTD
     C     Z9AMTP        ANDEQ     'IN'
     C     Z6INTA        ANDNE     0
 
      ** Calculate the difference between calculated and posted interest
     C                   SUB       @DINTN        @NETI
 
      ** If the difference is less than one unit round the last amount
     C     @NETI         IFLT      100
     C     @NETI         ANDGT     -100
     C                   ADD       @NETI         Z6INTA
     C                   ADD       @NETI         @DINTN
     C                   ENDIF
     C                   ENDIF
 
      ** Set the manual adjustment flag to no
     C                   MOVE      'N'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
 
      ** Store the old amounts for comparrison
     C                   Z-ADD     Z9VDAT        @OEDAT
 
      ** If the rate was shown store it
     C     Z9BRTE        IFNE      0
     C     Z9RTSP        ORNE      0
     C     Z9SPIN        ORNE      *BLANKS
 
      ** If a base rate is blank use the spread
     C     Z9BRTE        IFEQ      0
     C                   Z-ADD     Z9RTSP        @OINTR
 
      ** If base rate entered use spread of it
     C                   ELSE
 
      ** Depending on the spread indicator use the spread
     C                   SELECT
 
      ** Add spread
     C     Z9SPIN        WHENEQ    'A'
     C     Z9BRTE        ADD       Z9RTSP        @OINTR
 
      ** Subtract spread
     C     Z9SPIN        WHENEQ    'D'
     C     Z9BRTE        SUB       Z9RTSP        @OINTR
      *
      *  Percentage of spread
      *
     C     Z9SPIN        WHENEQ    'P'
     C     Z9BRTE        MULT      Z9RTSP        @OINTR
     C                   DIV       100           @OINTR
 
      ** Blank
     C     Z9SPIN        WHENEQ    ' '
     C                   Z-ADD     Z9BRTE        @OINTR
     C                   ENDSL
     C                   ENDIF
     C                   Z-ADD     Z9BRTE        @OBRTE
     C                   Z-ADD     Z9RTSP        @ORTSP
     C                   MOVE      Z9SPIN        @OSPIN
     C                   ENDIF
     C                   Z-ADD     Z9PCPL        @OCPAM
     C                   ENDIF
 
     C                   ENDSR
 
      ** Subroutine to calculate interest over a period
      /COPY ZSRSRC,GLINTCZ1LE
 
      ** Subroutine to calculate the number of interest days
      /COPY ZSRSRC,ZINTDYZ2LE
      /COPY ZSRSRC,ZDAT10Z2LE
 
      ** Subroutine to convert dates
      /COPY ZSRSRC,ZDATE9Z3LE
 
      ** Compile time array data
      /COPY ZSRSRC,ZDATE9Z4
