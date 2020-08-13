     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL JMI116 Utility Module')                       *
      *****************************************************************
      *                                                               *
      *  Midas - GL module                                            *
      *                                                               *
      *  XX116002 - JMI116 search and replace utility module          *
      *                                                               *
      *  Function:  This program searches and replace wildcards and   *
      *             checks if the search string is present            *
      *                                                               *
      *  Called By: GLBITHVAL, GL0140D, GL0160D                       *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. JMI116  *CREATE    Date 21Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI116 - Reserve Journal Entry Batch Numbers                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     C     *ENTRY        PLIST
     C                   PARM                    SearchStr        20
     C                   PARM                    String           20
     C                   PARM                    Index             3 0
      *
     C                   Eval      Index = 0
     C                   Eval      SearchStr = %ScanRpl('%' : ' ' : SearchStr)
     C                   Eval      Index = %Scan(%Trim(SearchStr):String)
      *
     C                   SETON                                        LR
     C                   RETURN
      *
      ********************************************************************
      *
