     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Midas clustering - condition handler')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC005010 - Midas Clustering Condition Handler for Exit Pgm   *
      *                                                               *
      *  Function:  This module handles certain error conditions      *
      *             for the Midas Clustering exit program SC005000.   *
      *                                                               *
      *  Component of: SC005000                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. CSC013  *CREATE    Date 05Nov01               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC013 - Midas Clustering Feature                            *
      *           - New program for this feature.                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
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
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      ** +-----------------------------------------------------------------+
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Resume          C                   10
     D Percolate       C                   20
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      * Condition Token
      *
     D CndToken        DS
     D  MsgSev                        4B 0
     D  MsgId                         2
     D                                1
     D  MsgPrefix                     3
     D  MsgSuffix                     4
      *
      * Communications Area
      *
     D CommArea        DS                  Based(CommAreaPtr)
     D  FieldA                       10
     D  FieldB                       10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D CommAreaPtr     S               *
     D CndAction       S              9B 0
     D Msg             S              7
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      *  Calculate message ID.
      *
     C                   Eval      Msg = MsgPrefix + MsgSuffix
      *
      *  If the message is not CPF2103,
      *
     C                   If        Msg <> 'CPF2103'
      *
      *  the action should be 'percolate'.
      *
     C                   Eval      CndAction = Percolate
      *
      *  If the message is CPF2103,
      *
     C                   Else
      *
      *  the action should be 'resume'.
      *
     C                   Eval      CndAction = Resume
      *
     C                   Endif
      *
     C                   Return
      *
      **********************************************************************
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
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PList
     C                   Parm                    CndToken
     C                   Parm                    CommAreaPtr
     C                   Parm                    CndAction
      *
     C                   ENDSR
      *
      *****************************************************************
