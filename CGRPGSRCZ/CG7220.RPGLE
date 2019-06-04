     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Extract the DL Int. Movt')     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7220 - CG Interest Scale extract the dealing interest      *
      *           movements                                           *
      *                                                               *
      *  Function: Reads from HIST3 and writes the qualifying interest*
      *            details record to the CGISDDPD file                *
      *                                                               *
      *  Called By: CGC7220 - CG Interest Scale Dealing extract cap.  *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD053295           Date 13Apr19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR847818           Date 26Apr13               *
      *                 AR996895           Date 25Nov12               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD053295 - Lending loan with Interest Calculation Basis      *
      *             method 3 (30/360) has wrong interest payment      *
      *             amount for month of March (Recompile)             *
      *  MD046248 - Finastra Rebranding                               *
      *  AR847818 - Remove zero interest amount (Child:AR847819)      *
      *  AR996895 - Incorrect accrual interest calculation            *
      *             (Child: AR996897) (Recompile)                     *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Indicators
      *
      *  89  General chain fail error
      *
      *****************************************************************
 
      ** Historic deals by type deal number and date
     FHIST3     IF   E           K DISK    USROPN
 
      ** Interest Scale Detail file
     FCGISDDPD  O    E             DISK    USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Copy for date conversion
      /COPY ZSRSRC,ZDATE9Z1LE
 
      ** Data structure to allow passed alpha field
     D DINTA           DS
     D  DINTN                  1      9P 0
 
      ** Data structure for interest days calculation routine
      /COPY ZSRSRC,ZINTDYZ1LE
 
      ** Data structure for date conversion routine
      /COPY ZSRSRC,ZDATE9Z2LE
 
      ** Data area to make zero records switchable
      /COPY ZSRSRC,ZDAT10Z1LE
      *****************************************************************
 
      ** Working variables
     D KDLNO           S                   LIKE(DLNO)
     D KEDAT           S                   LIKE(EDAT)
     D OEDAT           S                   LIKE(EDAT)
     D OPCPL           S                   LIKE(PCPL)
     D ONRAT           S                   LIKE(NRAT)
     D ORTYP           S                   LIKE(RTYP)
     D NETI            S             17  0
 
      ** Parameters for called programs
     D PBRCA           S                   LIKE(BRCA)
     D PCNUM           S                   LIKE(CNUM)
     D PCCY            S                   LIKE(CCY)
     D PACOD           S             10  0
     D PACSQ           S              2  0
     D PREFN           S             10A
     D PREFT           S              1A
     D PDLNO           S                   LIKE(DLNO)
     D PINFD           S                   LIKE(EDAT)
     D PINTD           S                   LIKE(EDAT)
     D PINTA           S              9A
     D PADDI           S              1A
     D PRDFC           S              1A
     D PFRLS           S              5A
     D PRTCD           S              7A
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Main routine - main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  First  - Initial houskeeping
      *            :  Detail - Detail processing
      *            :  last   - Final housekeeping
      *
      *****************************************************************
     C                   SELECT
 
      ** If the first pass of the program
     C                   WHEN      PFRLS = 'FIRST'
 
      ** Perform the initial houskeeping
     C                   EXSR      FIRST
 
      ** If the last pass of the program
     C                   WHEN      PFRLS = 'LAST'
 
      ** Perform the final houskeeping
     C                   EXSR      LAST
 
      ** If neither first nor last pass
     C                   OTHER
 
      ** Perform detail processing
     C                   EXSR      DETAIL
     C                   ENDSL
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Non-executable code, KLISTs, PLISTs, etc.
      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PBRCA
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PREFN
     C                   PARM                    PREFT
     C                   PARM                    PDLNO
     C                   PARM                    PINFD
     C                   PARM                    PINTD
     C                   PARM                    PINTA
     C                   PARM                    PADDI
     C                   PARM                    PRDFC
     C                   PARM                    PFRLS
     C                   PARM                    PRTCD
      *
      ** Short key list for the Dealing history file
      *
     C     HSKEY         KLIST
     C                   KFLD                    KDLNO
      *
      ** Long key list for the Dealing history file
      *
     C     HLKEY         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KEDAT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  FIRST SR. Initial housekeeping subroutine                    *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     FIRST         BEGSR
      *
      ** Open the file
      *
     C                   OPEN      HIST3
     C                   OPEN      CGISDDPD
      *
      ** Read in the allow zeros switch data area
      *
     C                   ENDSR
      *
      ** End of initial housekeeping
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  LAST SR. Final housekeeping                                  *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR
      *
      ** Close the file
      *
     C                   CLOSE     HIST3
     C                   CLOSE     CGISDDPD
      *
     C                   ENDSR
      *
      ** End of final housekeeping subroutine
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DETAIL SR. Detail processing                                 *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  Init   - Field initialisation                   *
      *            :  intadj - Interest adjustment processing         *
      *            :  intdet - Interest detail processing             *
      *                                                               *
      *****************************************************************
     C     DETAIL        BEGSR
      *
      ** Initialise fields
      *
     C                   EXSR      INIT
      *
      ** Set the key fields from the passed parameters
      *
     C                   Z-ADD     PDLNO         KDLNO
     C                   Z-ADD     PINFD         KEDAT
      *
      ** Position the file pointer to the start of this interest period
      *
     C     HLKEY         SETLL     HISTSAAF
      *
      ** Read the history file until eof or end of period
      *
     C     HSKEY         READE     HISTSAAF                               89
      *
      ** Store the initial read of the values for comparrison
      *
     C                   Z-ADD     EDAT          OEDAT
     C                   Z-ADD     PCPL          OPCPL
     C                   Z-ADD     NRAT          ONRAT
      *
      ** Clear the last record type
      *
     C                   MOVE      *BLANKS       ORTYP
      *
      ** Loop until end of file or  end of interest period
      *
     C                   DOW       *IN89 = *OFF and
     C                             EDAT <= PINTD
      *
      ** Select on record type
      *
     C                   SELECT
      *
      ** If a Intrest capitalisation ignore as are using interest due
      *
     C                   WHEN      RTYP = 'IP' and
     C                             INTC = 'Y'
      *
      ** Ignore
      *
      ** If an openning balance that does not follow an IP ignore
      *
     C     RTYP          WHENEQ    'OB'
     C     ORTYP         ANDNE     'IP'
     C     ORTYP         ANDNE     *BLANKS
      *
      ** Ignore
      *
      ** If an interest adjustment record process as such
      *
     C                   WHEN      RTYP = 'IA'
     C                   EXSR      INTADJ
 
      ** Process the history interest details
     C                   OTHER
     C                   EXSR      INTDET
     C                   ENDSL
 
      ** Store the last record type
     C                   MOVE      RTYP          ORTYP
 
      ** Read the history file until eof or end of period
     C     HSKEY         READE     HISTSAAF                               89
     C                   ENDDO
 
      ** Move the net interest to the parameter field
     C                   MOVE      DINTA         PINTA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INIT SR. Field initialisation                                *
      *                                                               *
      *  Called by :  Detail - Detail processing                      *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     INIT          BEGSR
      *
      ** Initialise the field values
      *
      ** Store the net interest passed for rounding
      *
     C                   MOVE      PINTA         DINTA
     C                   Z-ADD     DINTN         NETI
 
      ** Clear the return code
     C                   MOVE      *BLANKS       PRTCD
 
      ** Initialise the calculated net interest
     C                   Z-ADD     0             DINTN
 
      ** Set the constant file fields
     C                   MOVE      PBRCA         Z6BRCA
     C                   MOVEL     PCNUM         Z6CNUM
     C                   MOVE      PCCY          Z6CCY
     C                   Z-ADD     PACOD         Z6ACOD
     C                   Z-ADD     PACSQ         Z6ACSQ
     C                   MOVE      PREFN         Z6REFN
     C                   MOVE      PREFT         Z6REFT
     C                   Z-ADD     PINTD         Z6INCD
 
     C                   ENDSR
      *
      ** End of initialisation routine
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INTADJ SR. Interest adjustment processing                    *
      *                                                               *
      *  Called by :  Detail - Detail processing                      *
      *  Calls     :  none                                            *
      *
      *****************************************************************
     C     INTADJ        BEGSR
 
      ** Move the details to the file fields
     C                   Z-ADD     EDAT          Z6MOVD
     C                   Z-ADD     0             Z6ABAL
     C                   Z-ADD     0             Z6DAYS
     C                   Z-ADD     0             Z6RATE
     C                   Z-ADD     EAMT          Z6INTA
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        DINTN
 
      ** Set the manual adjustment flag to yes
     C                   MOVE      'Y'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
      ** Write an interest details record to the Interest Scale details
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INTDET SR. Initerest detail processing                       *
      *                                                               *
      *  Called by :  Detail - Detail processing                      *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     INTDET        BEGSR
 
      ** If the deal principal has changed
      ** or the interest rate has changed
      ** or this is the end of the interest period
     C     RTYP          IFEQ      'LD'
     C     RTYP          OREQ      'PI'
     C     RTYP          OREQ      'PD'
     C     RTYP          OREQ      'MA'
     C     PCPL          ORNE      OPCPL
     C     NRAT          ORNE      ONRAT
     C     EDAT          OREQ      PINTD
     C     RTYP          ANDEQ     'IP'
 
      ** Move the details to the file fields
     C                   Z-ADD     OEDAT         Z6MOVD
 
      ** If debit interest output as negative
     C     NETI          IFLT      0
     C                   Z-SUB     OPCPL         Z6ABAL
     C                   ELSE
     C                   Z-ADD     OPCPL         Z6ABAL
     C                   ENDIF
 
      ** Calculate the number of days
     C     EDAT          SUB       OEDAT         Z6DAYS
     C                   Z-ADD     ONRAT         Z6RATE
 
      ** If the number of days is not zero calcualte interest
     C     Z6DAYS        IFGT      0
 
      ** Set fields for standard subroutine to calculate interest
     C                   Z-ADD     OEDAT         ZIBEG
     C                   Z-ADD     EDAT          ZIEND
 
      ** If last day accruals subtract one from number of days
     C     PADDI         IFEQ      'L'
     C                   SUB       1             ZIEND
     C                   ENDIF
     C                   Z-ADD     OPCPL         ZIAMT
     C                   MOVE      ICBS          ZICALC
     C                   Z-ADD     ONRAT         ZIRATE
 
      ** Use the standard subroutine to calculate interest
     C                   EXSR      GLINTC
 
      ** If debit interest output as negative
     C     NETI          IFLT      0
 
      ** If round down required, else half adjust
     C     PRDFC         IFEQ      'Y'
     C                   Z-SUB     ZINTR         Z6INTA
     C                   ELSE
     C                   Z-SUB(H)  ZINTR         Z6INTA
     C                   ENDIF
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        DINTN
 
      ** If credit interest output as positive
     C                   ELSE
 
      ** If round down required, else half adjust
     C     PRDFC         IFEQ      'Y'
     C                   Z-ADD     ZINTR         Z6INTA
     C                   ELSE
     C                   Z-ADD(H)  ZINTR         Z6INTA
     C                   ENDIF
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        DINTN
     C                   ENDIF
 
      ** If number of days is zero set interest amount to zero
     C                   ELSE
     C                   Z-ADD     0             Z6INTA
     C                   ENDIF
 
      ** If the last entry of the interest period
     C     EDAT          IFEQ      PINTD
     C     RTYP          ANDEQ     'IP'
     C     Z6INTA        ANDNE     0
 
      ** Calculate the difference between vcalculated and posted int.
     C                   SUB       DINTN         NETI
 
      ** If the difference is less than one unit round the last amount
     C     NETI          IFLT      100
     C     NETI          ANDGT     -100
     C                   ADD       NETI          Z6INTA
     C                   ADD       NETI          DINTN
     C                   ENDIF
     C                   ENDIF
 
      ** Set the manual adjustment flag to no
     C                   MOVE      'N'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
      ** Write an interest details record to the Interest Scale details
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
 
      ** Store the old amounts for comparrison
     C                   Z-ADD     EDAT          OEDAT
     C                   Z-ADD     NRAT          ONRAT
 
      ** To cope with a data error in Midas only store the principal
      ** if the record type was an principal change record
     C                   IF        RTYP = 'LD' or
     C                             RTYP = 'PI' or
     C                             RTYP = 'PD' or
     C                             RTYP = 'MA'
     C                   Z-ADD     PCPL          OPCPL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *
      *  End of interest details processing
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Subroutine to calculate interest over a period
      *
      /COPY ZSRSRC,GLINTCZ1LE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Subroutine to calculate the number of interest days
      *
      /COPY ZSRSRC,ZINTDYZ2LE
      /COPY ZSRSRC,ZDAT10Z2LE
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Subroutine to convert dates
      *
      /COPY ZSRSRC,ZDATE9Z3LE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Subroutine to save indicatior settings
      *
      */COPY ZSRSRC,ZSAVEZ1
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Compile time array data
      *
      /COPY ZSRSRC,ZDATE9Z4
