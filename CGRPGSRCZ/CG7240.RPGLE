     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest scale find the LE int from-date')    *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7240 - CG Interest Scale Find the Lending Interest         *
      *           From-date                                           *
      *                                                               *
      *  Called By: CGC7240 - CG Interest Scale Lending Extract Intres*
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
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  89 - General chain fail error                                *
      *                                                               *
      *****************************************************************
 
      ** Historic loans by branch, customer, loan and date
     FLEHISTL4  IF   E           K DISK    USROPN
 
      ** Copyright statement array
     D CPY             S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Working variables
     D @PFRLS          S              5A
     D @PRTCD          S              7A
     D @FIRST          S              3A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Main routine - main controling subroutine
      *
      *  Called by :  none
      *  Calls     :  SrFirst  - Initial houskeeping
      *            :  SrDetail - Detail processing
      *            :  SrLast   - Final housekeeping
      *
      *****************************************************************
     C                   SELECT
 
      ** If the first pass of the program
     C     @PFRLS        WHENEQ    'FIRST'
 
      ** Perform the initial houskeeping
     C                   EXSR      SrFIRST
 
      ** If the last pass of the program
     C     @PFRLS        WHENEQ    'LAST'
 
      ** Perform the final houskeeping
     C                   EXSR      SrLAST
 
      ** If neither first nor last pass
     C                   OTHER
 
      ** Perform detail processing
     C                   EXSR      SrDETAIL
     C                   ENDSL
 
      ** Return to the calling program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  Non-executable code, KLISTs, PLISTs, etc.
      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    @PBRCA
     C                   PARM                    @PCNUM
     C                   PARM                    @PLNRF
     C                   PARM                    @PINTD
     C                   PARM                    @PVDAT
     C                   PARM                    @PINFD
     C                   PARM                    @PFRLS
     C                   PARM                    @PRTCD
 
      ** Short key list for the Lending history file
     C     LEHSKY        KLIST
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KLNRF
 
      ** Long key list for the lending history file
     C     LEHLKY        KLIST
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KLNRF
     C                   KFLD                    @KEDAT
 
      ** Define the work fields
     C     *LIKE         DEFINE    BRCA          @PBRCA
     C     *LIKE         DEFINE    CNUM          @PCNUM
     C     *LIKE         DEFINE    LNRF          @PLNRF
     C     *LIKE         DEFINE    VDAT          @PINTD
     C     *LIKE         DEFINE    VDAT          @PVDAT
     C     *LIKE         DEFINE    VDAT          @PINFD
     C     *LIKE         DEFINE    BRCA          @KBRCA
     C     *LIKE         DEFINE    CNUM          @KCNUM
     C     *LIKE         DEFINE    LNRF          @KLNRF
     C     *LIKE         DEFINE    VDAT          @KEDAT
 
     C                   ENDSR
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
     C                   OPEN      LEHISTL4
 
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
     C     SrLAST        BEGSR
 
      ** Close the file
     C                   CLOSE     LEHISTL4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *  DETAIL SR. Detail processing
      *
      *  Called by :  Main routine
      *  Calls     :  none
      *
      *****************************************************************
     C     SrDETAIL      BEGSR
 
      ** Move the passed paramenters to the key fields
     C                   MOVE      @PBRCA        @KBRCA
     C                   MOVEL     @PCNUM        @KCNUM
     C**********         Z-ADD     @PLNRF        @KLNRF                                       CLE148
     C                   MOVEL     @PLNRF        @KLNRF                                       CLE148
     C                   Z-ADD     @PINTD        @KEDAT
 
      ** Clear the return code
     C                   MOVE      *BLANKS       @PRTCD
 
      ** Postion to the end of interest period in file
     C     LEHLKY        SETLL     LEHISTL4
 
      ** Read the previous equal record for last interest date
     C     LEHSKY        READPE    LEHISTL4                               89
 
      ** Set a flag to say if any records have been read
     C                   MOVE      'YES'         @FIRST
 
      ** Loop until end of file or end of interest period
     C     *IN89         DOWEQ     *OFF
 
      ** Set a flag to say a record has been read
     C                   MOVE      'NO '         @FIRST
 
      ** If amendment type is interest end the search
     C     AMTP          IFEQ      'IN'
     C                   MOVE      *ON           *IN89
 
      ** If amendment type is not interest read next record
     C                   ELSE
 
      ** Read the previous equal record for last interest date
     C     LEHSKY        READPE    LEHISTL4                               89
     C                   ENDIF
     C                   ENDDO
 
      ** If interest record not found use loan start date
     C     @FIRST        IFEQ      'YES'
     C     AMTP          ORNE      'IN'
     C                   Z-ADD     @PVDAT        @PINFD
 
      ** If a record found use this date as the interest from date
     C                   ELSE
     C                   Z-ADD     VDAT          @PINFD
     C                   ENDIF
 
     C                   ENDSR
** CPY
(c) Misys International Banking Systems Ltd. 2011
