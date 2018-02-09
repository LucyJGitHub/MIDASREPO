     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Write reservation ID in GPRESERVID data area')         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL006001 - Write reservation ID in GPRESERVID data area      *
      *                                                               *
      *  Function:  This program will write the reservation ID in     *
      *             GPRESERVID data area.                             *
      *                                                               *
      *  Called By: GL4445                                            *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP207  *CREATE    Date 10Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *                                                               *
      *****************************************************************
 
      ** Reservation ID dataarea
     D GPRESERVID      DS            15
     D  ReservID               1     15
      *
     D  BTPDID         S             15P 0
 
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C     *DTAARA       DEFINE                  GPRESERVID
 
     C     *LOCK         IN        GPRESERVID
     C                   MOVE      BTPDID        ReservID
     C                   OUT       GPRESERVID
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Return code
     C                   PARM                    BTPDID
      *
     C                   ENDSR
