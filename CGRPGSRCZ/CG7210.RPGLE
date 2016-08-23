     H DEBUG DATEDIT(*DMY)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Interest Scale find the Deal Int From-dte')   *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG7210 - CG Interest Scale find the dealing interest         *
      *           from-date                                           *
      *                                                               *
      *  Function: Reads from HIST6 to find the Dealing Interest      *
      *            from-date                                          *
      *                                                               *
      *  Called By: CGC7210 - CG Interest Scale Dealing extract       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CER042  *CREATE    Date 11May11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      /EJECT
      *****************************************************************
      *
      ** Historic deals by type deal number and date
      *
     FHIST6     IF   E           K DISK    USROPN
      *
      *****************************************************************
      *
      ** Working variables
      *
     D KDLNO           S                   LIKE(DLNO)
     D KEDAT           S                   LIKE(EDAT)
      *
      ** Parameters for called programs
      *
     D PDLNO           S                   LIKE(DLNO)
     D PINTD           S                   LIKE(EDAT)
     D PVDAT           S                   LIKE(EDAT)
     D PINFD           S                   LIKE(EDAT)
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
      *
      *  If the first pass of the program
      *
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
 
      ** Return to the calling program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Non-executable code, KLISTs, PLISTs, etc.
      *
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PDLNO
     C                   PARM                    PINTD
     C                   PARM                    PVDAT
     C                   PARM                    PINFD
     C                   PARM                    PFRLS
     C                   PARM                    PRTCD
 
      ** Short key list for the Dealing history file
     C     HSKEY         KLIST
     C                   KFLD                    KDLNO
 
      ** Long key list for the Dealing history file
     C     HLKEY         KLIST
     C                   KFLD                    KDLNO
     C                   KFLD                    KEDAT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** FIRST SR. Initial housekeeping subroutine                    *
      *                                                               *
      *  Called by :  Main routine                                    *
      *  Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     FIRST         BEGSR
 
      ** Open the file
     C                   OPEN      HIST6
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** LAST SR. Final housekeeping                                  *
      *                                                               *
      ** Called by :  Main routine                                    *
      ** Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     LAST          BEGSR
 
      ** Close the file
     C                   CLOSE     HIST6
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** DETAIL SR. Detail processing                                 *
      *                                                               *
      ** Called by :  Main routine                                    *
      ** Calls     :  none                                            *
      *                                                               *
      *****************************************************************
     C     DETAIL        BEGSR
 
      ** Move the passed paramenters to the key fields
     C                   Z-ADD     PDLNO         KDLNO
     C                   Z-ADD     PINTD         KEDAT
 
      ** Clear the return code
     C                   MOVE      *BLANKS       PRTCD
 
      ** Postion to the end of interest period in file
     C     HLKEY         SETLL     HISTSAAF
 
      ** Read the pervious equal record for last interest date
     C     HSKEY         READPE    HISTSAAF                               89
 
      ** If no record found use the start date of the deal
     C                   IF        *IN89 = *ON
     C                   Z-ADD     PVDAT         PINFD
 
      ** If a record found use this date as the interest from date
     C                   ELSE
     C                   Z-ADD     EDAT          PINFD
     C                   ENDIF
 
     C                   ENDSR
