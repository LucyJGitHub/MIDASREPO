     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale extract retail movements')     *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7280 - CG Interest Scale extract extract retail movements  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. AR869511A          Date 24Nov11               *
      *  Prev Amend No. AR869511           Date 23Nov11               *
      *                 AR847818           Date 26Apr13               *
      *                 CLE148             Date 23Jul12               *
      *                 AR865055           Date 17Nov11               *
      *                 CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR869511A- Wrong details extracted for some accounts         *
      *             (Child:AR869512)                                  *
      *  AR869511 - Wrong details extracted for some                  *
      *             accounts (Child:AR869512)                         *
      *  AR847818 - Remove zero interest amount (Child:AR847819)      *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  AR865055 - Interest scale wrong interest rate output         *
      *             (Child:AR865919)                                  *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  89 - General chain fail error                                *
      *                                                               *
      *****************************************************************
 
      ** Retail history by account and date
     FREHISDL   IF   E           K DISK    USROPN
 
      ** Interest Scale detail file
     FCGISDDPD  O    E             DISK    USROPN
      *
     D @PREFN          S             10A
     D @PREFT          S              1A
     D @PDINA          S              9A
     D @PCINA          S              9A
     D @PFRLS          S              5A
     D @PRTCD          S              7A
     D @DEBI           S             17S 0
     D @CREI           S             17S 0
     D @INIT           S              1S 0                                                 AR869511A
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Data structure to allow passed alpha field debit interest
      *
     D @DDINA          DS
     D  @DDINN                 1      9P 0
 
      ** Data structure to allow passed alpha field credit interest
     D @DCINA          DS
     D  @DCINN                 1      9P 0
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
     C     @PFRLS        WHENEQ    'FIRST'
 
      ** Perform the initial houskeeping
     C                   EXSR      FIRST
 
      ** If the last pass of the program
     C     @PFRLS        WHENEQ    'LAST'
 
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
      *  Non-executable code, KLISTs, PLISTs, etc.
      *
      *****************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    @PBRCA
     C                   PARM                    @PCNUM
     C                   PARM                    @PCCY
     C                   PARM                    @PACOD
     C                   PARM                    @PACSQ
     C                   PARM                    @PREFN
     C                   PARM                    @PREFT
     C                   PARM                    @PINFD
     C                   PARM                    @PINTD
     C                   PARM                    @PDINA
     C                   PARM                    @PCINA
     C                   PARM                    @PFRLS
     C                   PARM                    @PRTCD
 
      ** Short key list for the retail history file
     C     @HSKEY        KLIST
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KCCY
     C                   KFLD                    @KACOD
     C                   KFLD                    @KACSQ
 
      ** Long key list for the Dealing history file
     C     @HLKEY        KLIST
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KCCY
     C                   KFLD                    @KACOD
     C                   KFLD                    @KACSQ
     C                   KFLD                    @KHISD
 
      ** Define the work fields
     C     *LIKE         DEFINE    BRCA          @PBRCA
     C     *LIKE         DEFINE    CNUM          @PCNUM
     C     *LIKE         DEFINE    CCY           @PCCY
     C     *LIKE         DEFINE    ACOD          @PACOD
     C     *LIKE         DEFINE    ACSQ          @PACSQ
     C     *LIKE         DEFINE    HISD          @PINTD
     C     *LIKE         DEFINE    HISD          @PVDAT
     C     *LIKE         DEFINE    HISD          @PINFD
     C     *LIKE         DEFINE    BRCA          @KBRCA
     C     *LIKE         DEFINE    CNUM          @KCNUM
     C     *LIKE         DEFINE    CCY           @KCCY
     C     *LIKE         DEFINE    ACOD          @KACOD
     C     *LIKE         DEFINE    ACSQ          @KACSQ
     C     *LIKE         DEFINE    HISD          @KHISD
     C     *LIKE         DEFINE    HISD          @OHISD
     C     *LIKE         DEFINE    HISB          @OHISB
     C     *LIKE         DEFINE    DRIR          @ODRIR
     C     *LIKE         DEFINE    CRIR          @OCRIR
     C     *LIKE         DEFINE    DAID          @ODAID
     C     *LIKE         DEFINE    CAID          @OCAID
 
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
     C     FIRST         BEGSR
 
      ** Open the file
     C                   OPEN      REHISDL
     C                   OPEN      CGISDDPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  LAST SR. Final housekeeping
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     LAST          BEGSR
 
      ** Close the file
     C                   CLOSE     REHISDL
     C                   CLOSE     CGISDDPD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  DETAIL SR. Detail processing
      *
      *  Called by :  Main routine
      *  Calls     :  Init   - Field initialisation
      *            :  intdet - Interest detail processing
      *
      *****************************************************************
     C     DETAIL        BEGSR
 
      ** Initialise fields
     C                   EXSR      INIT
 
      ** Set the key fields from the passed parameters
     C                   MOVE      @PBRCA        @KBRCA
     C                   MOVEL     @PCNUM        @KCNUM
     C                   MOVE      @PCCY         @KCCY
     C                   Z-ADD     @PACOD        @KACOD
     C                   Z-ADD     @PACSQ        @KACSQ
     C                   Z-ADD     @PINFD        @KHISD
 
      ** Position the file pointer to the start of this interest period
     C     @HLKEY        SETLL     REHISDL
 
      ** Read the history file until eof or end of period
     C     @HSKEY        READE     REHISDL                                89
 
      ** Store the initial read of the values for comparrison
     C                   Z-ADD     HISD          @OHISD
     C                   Z-SUB     HISB          @OHISB
     C                   Z-ADD     DRIR          @ODRIR
     C                   Z-ADD     CRIR          @OCRIR
     C                   Z-ADD     0             @ODAID
     C                   Z-ADD     0             @OCAID
     C                   Z-ADD     0             @DDINN
     C                   Z-ADD     0             @DCINN
     C                   Z-ADD     0             @INIT                                     AR869511A
 
      ** Loop until end of file or  end of interest period
     C     *IN89         DOWEQ     *OFF
     C     HISD          ANDLT     @PINTD
 
      ** Process the history interest details
     C                   EXSR      INTDET
 
     C                   Z-ADD     1             @INIT                                     AR869511A
                                                                                           AR869511A
      ** Read the history file until eof or end of period
     C     @HSKEY        READE     REHISDL                                89
     C                   ENDDO
 
      ** If more interest to accrue
     C     @DDINN        IFNE      @DEBI
 
      ** Move the details to the file fields
     C                   Z-ADD     @OHISD        Z6MOVD
     C                   Z-ADD     @OHISB        Z6ABAL
 
      ** Calculate the number of days
     C     @PINTD        SUB       @OHISD        Z6DAYS
     C                   Z-ADD     @ODRIR        Z6RATE
 
      ** Calculate the difference between vcalculated and posted int.
     C     @DEBI         SUB       @DDINN        Z6INTA
     C                   Z-ADD     @DEBI         @DDINN
 
      ** Set the manual adjustment flag to no
     C                   MOVE      'N'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
     C                   ENDIF
 
      ** If more interest to accrue
     C     @DCINN        IFNE      @CREI
 
      ** Move the details to the file fields
     C                   Z-ADD     @OHISD        Z6MOVD
     C                   Z-ADD     @OHISB        Z6ABAL
 
      ** Calculate the number of days
     C     @PINTD        SUB       @OHISD        Z6DAYS
     C                   Z-ADD     @OCRIR        Z6RATE
 
      ** Calculate the difference between vcalculated and posted int.
     C     @CREI         SUB       @DCINN        Z6INTA
     C                   Z-ADD     @CREI         @DCINN
 
      ** Set the manual adjustment flag to no
     C                   MOVE      'N'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
     C                   ENDIF
 
      ** Move the net interest to the parameter field
     C                   MOVE      @DDINA        @PDINA
     C                   MOVE      @DCINA        @PCINA
 
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
     C                   MOVE      @PDINA        @DDINA
     C                   Z-ADD     @DDINN        @DEBI
     C                   MOVE      @PCINA        @DCINA
     C                   Z-ADD     @DCINN        @CREI
 
      ** Clear the return code
     C                   MOVE      *BLANKS       @PRTCD
 
      ** Initialise the calculated net interest
     C                   Z-ADD     0             @DDINN
     C                   Z-ADD     0             @DCINN
 
      ** Set the constant file fields
     C                   MOVE      @PBRCA        Z6BRCA
     C                   MOVE      @PCNUM        Z6CNUM
     C                   MOVE      @PCCY         Z6CCY
     C                   MOVE      @PACOD        Z6ACOD
     C                   MOVE      @PACSQ        Z6ACSQ
     C                   MOVE      @PREFN        Z6REFN
     C                   MOVE      @PREFT        Z6REFT
     C                   Z-ADD     @PINTD        Z6INCD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  INTDET SR. Initerest detail processing
      *
      *  Called by :  Detail - Detail processing
      *  Calls     :  none
      *
      *****************************************************************
     C     INTDET        BEGSR
 
      ** If the deal principal has increased
      ** or the interest rate has changed
      ** or this is the end of the interest period
     C     DMVT          IFNE      0
     C     CMVT          ORNE      0
     C     DRCD          OREQ      HISD
     C     CRCD          OREQ      HISD
 
      ***Move*the*details*to*the*file*fields***************************                     AR869511
     C**********         Z-ADD     @OHISD        Z6MOVD                                     AR869511
     C**********         Z-ADD     @OHISB        Z6ABAL                                     AR869511
      *****************************************************************                     AR869511
      ***Calculate*the*number*of*days**********************************                     AR869511
     C*****HISD*         SUB       @OHISD        Z6DAYS                                     AR869511
 
      ** Only do debit interest if not debit interest capitalisation
     C     PDID          IFNE      HISD
                                                                                            AR869511
      ** Move the details to the file fields                                                AR869511
     C                   Z-ADD     @OHISD        Z6MOVD                                    AR869511A
     C                   Z-ADD     @OHISB        Z6ABAL                                    AR869511A
     C     HISD          SUB       @OHISD        Z6DAYS                                    AR869511A
                                                                                           AR869511A
      ** Use current details if initial read of record                                     AR869511A
     C                   IF        @INIT = 0                                               AR869511A
     C                   Z-ADD     PDID          Z6MOVD                                     AR869511
     C     HISD          SUB       PDID          Z6DAYS                                     AR869511
     C     HISB          SUB       DMVT          Z6ABAL                                     AR869511
     C                   Z-SUB     Z6ABAL        Z6ABAL                                     AR869511
     C                   ENDIF                                                             AR869511A
 
      ** Calculate the changed debit interest
     C                   Z-SUB     DAID          Z6INTA
     C                   SUB       MADI          Z6INTA
     C                   SUB       TMADI         Z6INTA
     C                   SUB       ODIA          Z6INTA
     C                   ELSE
     C                   Z-SUB     0             Z6INTA
     C                   ENDIF
     C                   SUB       @ODAID        Z6INTA
     C                   ADD       Z6INTA        @ODAID
     C                   Z-ADD     @ODRIR        Z6RATE
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        @DDINN
 
      ** Set the manual adjustment flag to no
     C                   MOVE      'N'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
 
      ***Store*the*old*amounts*for*comparrison*************************                     AR865055
     C**********         Z-ADD     HISD          @OHISD                                     AR865055
     C**********         Z-ADD     DRIR          @ODRIR                                     AR865055
     C**********         Z-ADD     CRIR          @OCRIR                                     AR865055
     C**********         Z-SUB     HISB          @OHISB                                     AR865055
 
      ** Only do credit interest if not credit interest capitalisation
     C     PCID          IFNE      HISD
 
      ** Move the details to the file fields                                                AR869511
     C                   Z-ADD     @OHISD        Z6MOVD                                     AR869511
     C                   Z-ADD     @OHISB        Z6ABAL                                     AR869511
     C     HISD          SUB       @OHISD        Z6DAYS                                     AR869511
                                                                                            AR869511
      ** Calculate the changed credit interest
     C                   Z-ADD     CAID          Z6INTA
     C                   ADD       MACI          Z6INTA
     C                   ADD       TMACI         Z6INTA
     C                   ELSE
     C                   Z-ADD     0             Z6INTA
     C                   ENDIF
     C                   SUB       @OCAID        Z6INTA
     C                   ADD       Z6INTA        @OCAID
     C                   Z-ADD     @OCRIR        Z6RATE
 
      ** Add interest amount to running net interest total
     C                   ADD       Z6INTA        @DCINN
 
      ** Set the manual adjustment flag to no
     C                   MOVE      'N'           Z6MANA
 
     C                   IF        Z6INTA <> 0                                              AR847818
     C                   WRITE     CGISDDD0
     C                   ENDIF                                                              AR847818
 
      ** Store the old amounts for comparrison
     C                   Z-ADD     HISD          @OHISD
     C                   Z-ADD     DRIR          @ODRIR
     C                   Z-ADD     CRIR          @OCRIR
     C                   Z-SUB     HISB          @OHISB
     C                   ENDIF
 
     C                   ENDSR
