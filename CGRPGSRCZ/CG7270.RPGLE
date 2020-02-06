     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale Find interest from-date')      *
      *****************************************************************
      *                                                               *
      *  Midas - Interest Scale reporting                             *
      *                                                               *
      *  CG7270 - CG Interest Scale find the retail interest from-date*
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179)                             *
      *                                                               *
      *---------------------------------------------------------------*
      *  Indicator Usage                                              *
      *                                                               *
      *  89 - General chain fail error                                *
      *                                                               *
      *****************************************************************
 
      ** Retail History by Account and Date
     FREHISLS   IF   E           K DISK    USROPN
 
     D @PFRLS          S              5A
     D @PRTCD          S              7A
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
 
      ** Return to the calling program
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
     C                   PARM                    @PINTD
     C                   PARM                    @PVDAT
     C                   PARM                    @PINFD
     C                   PARM                    @PFRLS
     C                   PARM                    @PRTCD
 
      ** Short key list for the retail history file
     C     @HSKEY        KLIST
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KCCY
     C                   KFLD                    @KACOD
     C                   KFLD                    @KACSQ
 
      ** Long key list for the retail history file
     C     @HLKEY        KLIST
     C                   KFLD                    @KBRCA
     C                   KFLD                    @KCNUM
     C                   KFLD                    @KCCY
     C                   KFLD                    @KACOD
     C                   KFLD                    @KACSQ
     C                   KFLD                    @KEDAT
 
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
     C     *LIKE         DEFINE    HISD          @KEDAT
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
     C                   OPEN      REHISLS
 
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
     C                   CLOSE     REHISLS
 
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
     C     DETAIL        BEGSR
 
      ** Move the passed paramenters to the key fields
     C                   MOVE      @PBRCA        @KBRCA
     C                   MOVEL     @PCNUM        @KCNUM
     C                   MOVE      @PCCY         @KCCY
     C                   Z-ADD     @PACOD        @KACOD
     C                   Z-ADD     @PACSQ        @KACSQ
     C                   Z-ADD     @PINTD        @KEDAT
 
      ** Clear the return code
     C                   MOVE      *BLANKS       @PRTCD
 
      ** Postion to the end of interest period in file
     C     @HLKEY        SETLL     REHISLS
 
      ** Read the pervious equal record for last interest date
     C     @HSKEY        READPE    REHISLS                                89
 
      ** If no record found use the start date of the deal
     C     *IN89         IFEQ      *ON
     C                   Z-ADD     @PVDAT        @PINFD
 
      ** If a record found use this date as the interest from date
     C                   ELSE
     C                   Z-ADD     HISD          @PINFD
     C                   ENDIF
 
     C                   ENDSR
