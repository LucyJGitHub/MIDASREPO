  ******************************************************************
     H DEBUG
     H DFTACTGRP(*NO)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2015')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Utilities Module                                     *
      *                                                               *
      *  UT000017 - Midas UT Convert Spool file to HTML               *
      *                                                               *
      *  Function:  This program converts an iSeries spooled file     *
      *               to HTML.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2015            *
      *                                                               *
      *  Last Amend No. CUT016  *Create    Date 10Apr15               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CUT016 - iSeries Spooled Files conversion                    *
      *                                                               *
      *****************************************************************

     FUTSPLFTD  IF   F  382        DISK

     FUTTOOPTD  UF A F  378        DISK

      * Standard HTML header lines

     D aaHeader        S             80A   DIM(2) CTDATA PERRCD(1)

      * Standard HTML footer line

     D aaFooter        S             80A   DIM(1) CTDATA PERRCD(1)

      * Input spooled file data including control characters

     D InputData       DS
     D   saSkipLine                   3A
     D   ssSkipLine                   3S 0 OVERLAY(saSkipLine:1)
     D   saSpceLine                   1A
     D   ssSpceLine                   1S 0 OVERLAY(saSpceLine:1)
     D   saInput                    378A

      * Output HTML-format data

     D OutputData      DS
     D   saOutput                   378A

      * Program parameters - title and page length in lines

     D paTitle         S             50A
     D piPageLen       S             10I 0

      * Line counter variable

     D wiLine          S             10I 0

      * Procedure prototypes

     D HTMLHeader      PR

     D HTMLFooter      PR

     D Convert         PR

     D Merge           PR                  LIKE(saOutput)
     D    iaOutput                         LIKE(saOutput)
     D    iaInput                          LIKE(saInput)

     D SpceLines       PR
     D    isSpceLine                       LIKE(ssSpceLine)

     D SkipLines       PR
     D    isSkipLine                       LIKE(ssSkipLine)


      **  ---------------
      **  MAIN PROCESSING
      **  ---------------

      * Output HTML header lines

     C                   CALLP     HTMLHeader

      * Convert spool file lines to HTML

     C                   READ      UTSPLFTD      InputData                LR
     C                   DOW       *INLR = *OFF
     C                   CALLP     Convert
     C                   READ      UTSPLFTD      InputData                LR
     C                   ENDDO

      * Output HTML footer lines

     C                   CALLP     HTMLFooter

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR

      * Program parameters

     C     *ENTRY        PLIST
     C                   PARM                    paTitle
     C                   PARM                    piPageLen
      *
     C     EINZSR        ENDSR

      **********************************************************************
      * Procedure to create HTML header lines                              *
      **********************************************************************

     P HTMLHeader      B

     D HTMLHeader      PI

     C                   EVAL      saOutput = aaHeader(1)
     C                   WRITE     UTTOOPTD      OutputData

     C                   IF        paTitle <> '*NONE'
     C                   EVAL      saOutput   = ''
     C                   WRITE     UTTOOPTD      OutputData
     C                   ENDIF

     C                   EVAL      saOutput = aaHeader(2)
     C                   WRITE     UTTOOPTD      OutputData

     P HTMLHeader      E

      **********************************************************************
      * Procedure to create HTML footer line                               *
      **********************************************************************

     P HTMLFooter      B

     D HTMLFooter      PI

     C                   EVAL      saOutput = aaFooter(1)
     C                   WRITE     UTTOOPTD      OutputData

     P HTMLFooter      E

      **********************************************************************
      * Procedure to convert spooled file data to HTML text                *
      **********************************************************************

     P Convert         B

     D Convert         PI

      * If 'space' position is zero, 'overprint' previous line

     C                   IF        saSpceLine = '0'

     C     *HIVAL        SETGT     UTTOOPTD
     C                   READP     UTTOOPTD      OutputData               99
     C                   EVAL      saOutput = Merge(saOutput:saInput)
     C                   UPDATE    UTTOOPTD      OutputData

     C                   ELSE

      * Skip to a line if specified

     C                   IF        saSkipLine <> *BLANKS
     C                   CALLP     SkipLines(ssSkipLine)
     C                   ENDIF

      * Space a number of lines if specified

     C                   IF        saSpceLine <> *BLANKS
     C                   CALLP     SpceLines(ssSpceLine)
     C                   ENDIF

      * 'Print' line

     C                   EVAL      saOutput   = saInput
     C                   WRITE     UTTOOPTD      OutputData

     C                   ENDIF

     C                   RETURN

     P Convert         E

      **********************************************************************
      * Procedure to merge two overlaid lines of text                      *
      **********************************************************************

     P Merge           B

     D Merge           PI                  LIKE(saOutput)
     D    iaOutput                         LIKE(saOutput)
     D    iaInput                          LIKE(saInput)

     D laOutput        S                   LIKE(saOutput)

     D i               S              5I 0

     C                   EVAL      i = 1
     C                   DOW            i <= %size(iaInput )
     C                             and  i <= %size(iaOutput)
     C                             and  i <= %size(laOutput)
     C                   IF        %subst(iaInput:i:1) = *BLANK
     C                   EVAL      %subst(laOutput:i:1) = %subst(iaOutput:i:1)
     C                   ELSE
     C                   EVAL      %subst(laOutput:i:1) = %subst(iaInput :i:1)
     C                   ENDIF
     C                   EVAL      i = i + 1
     C                   ENDDO

     C                   RETURN    laOutput

     P Merge           E

      **********************************************************************
      * Procedure to skip to a given line number                           *
      **********************************************************************

     P SkipLines       B

     D SkipLines       PI
     D    isSkipLine                       LIKE(ssSkipLine)

     C                   EVAL      saOutput = *BLANKS

     C                   IF        wiLine > isSkipLine

     C                   DOW       wiLine < piPageLen
     C                   WRITE     UTTOOPTD      OutputData
     C                   EVAL      wiLine = wiLine + 1
     C                   ENDDO

     C                   EVAL      saOutput   = '-------------------------'
     C                   WRITE     UTTOOPTD      OutputData
     C                   EVAL      saOutput = *BLANKS
     C                   EVAL      wiLine = 1

     C                   ENDIF

     C                   DOW       wiLine < isSkipLine
     C                   WRITE     UTTOOPTD      OutputData
     C                   EVAL      wiLine = wiLine + 1
     C                   ENDDO

     C                   RETURN

     P SkipLines       E

      **********************************************************************
      * Procedure to space a number of lines                               *
      **********************************************************************

     P SpceLines       B

     D SpceLines       PI
     D    isSpceLine                       LIKE(ssSpceLine)

     D liCount         S              5I 0

     C                   EVAL      wiLine  = wiLine  + 1
     C                   EVAL      saOutput = *BLANKS
     C                   DOW       liCount < isSpceLine - 1
     C                   WRITE     UTTOOPTD      OutputData
     C                   EVAL      wiLine  = wiLine  + 1
     C                   EVAL      liCount = liCount + 1
     C                   ENDDO

     C                   RETURN

     P SpceLines       E
**
<html><head><title>xxxx</title></head><body>
<table><tr><td> <pre>
**
</pre></td></tr></table></body></html>
