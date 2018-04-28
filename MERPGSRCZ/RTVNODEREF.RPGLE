     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Retrieve and set Meridian Link user options')
      *****************************************************************
      *                                                               *
      *  Midas - Messages Management Module                           *
      *                                                               *
      *  RTVNODEREF - Retrieve Node Reference using Host ID - DUMMY   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 257417  *CREATE    Date 28Oct08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  257417 - RTVNODEREF program is missing                       *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EVAL      @NodeRef = 1
     C                   EVAL      *InLr    = *On
     C                   RETURN
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    @HostID           2
     C                   PARM                    @NodeRef          2 0
 
     C                   ENDSR
      *****************************************************************
