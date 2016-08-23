     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2011')
     H NOMAIN
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas BF Common Routines')                             *
      *****************************************************************
      *                                                               *
      *  Midas - BankFusion Module                                    *
      *                                                               *
      *  BF000001 - Common Routines                                   *
      *                                                               *
      *  Function:  This program provides functionality that are      *
      *             commonly required by other programs               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2011            *
      *                                                               *
      *  Last Amend No. CBF006             Date 04Jul11               *
      *  Prev Amend No. XXXXXX             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CBF006 - BF Infrastructure: Initiating BankFusion Services   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      *---------------------------------------------------------------------------------------
      *  PROTOTYPE
      *---------------------------------------------------------------------------------------
     D/COPY BFCPYSRC,BF000005
      *
      /EJECT
      **********************************************************************
      *                                                                    *
      *  StrSubstitute - Replace a string occurence with another string    *
      *                                                                    *
      **********************************************************************
      *
     P StrSubstitute   B                   EXPORT
      *
     D                 PI                  like(LONG_STRING)
     D  pData                              like(LONG_STRING) value
     D  pFromString                        like(SEARCH_STRING) value
     D  pToString                          like(SEARCH_STRING) value
      *
      ** Work fields
      *
     D  wData          S                   like(LONG_STRING)
     D  wFromLen       S             10I 0
     D  wPos           S             10I 0
      *
      /free
 
               wData = pData;
               wFromLen = %len(pFromString);
 
               wPos = 1;
               dou (wPos=0);
                    wPos = %scan(pFromString: wData: wPos);
                    if (wPos>0);
                         wData = %replace (pToString: wData: wPos: wFromLen);
                    endif;
               enddo;
 
               return wData;
 
      /end-free
      *
     P                 E
