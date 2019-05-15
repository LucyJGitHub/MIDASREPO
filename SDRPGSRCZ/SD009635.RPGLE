     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2008')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Validate Broker Code For a System Value')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009635 - Validation program for System Values              *
      *             DefaultBroker Code                                *
      *                                                               *
      *  Function:  This program validates the New System value       *
      *             DefaultBroker Code                                *
      *                                                               *
      *  Called By: SD009501                                          *
      *                                                               *
      *  (c) Finastra International Limited 2008                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 BUG21393           Date 27Oct08               *
      *                 CER043  *CREATE    Date 19May08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG21393 - Serious Midas error occurs when inserting MM      *
      *             deal.                                             *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D PMsgIdar        S                   DIM(99)  LIKE(PErrMsgid)
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PErrMsgid       S              7A
     D PRtcd           S              7A
     D POptn           S              7A
     D PSysVal         S             20A
     D PCurVal         S            200A
     D PProcMod        S            190A
     D PGenErr         S              1A
     D PBrok           S              4A
     D PIdx            S              2P 0
 
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
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C                   Eval      PGenErr = *Blanks
 
     C**********         If        PCurVal <> *Blanks                                       BUG21393
     C                   If        PCurVal <> *Blanks and                                   BUG21393
     C                             PCurVal <> 'TELX'  and                                   BUG21393
     C                             PCurVal <> 'PHON'  and                                   BUG21393
     C                             PCurVal <> 'MAIL'  and                                   BUG21393
     C                             PCurVal <> 'SWAP'                                        BUG21393
      *
      ** Validate Broker Code
      *
     C                   Call      'AOBROKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM      PCurVal       PBrok
     C     SDBROK        PARM      SDBROK        DSFDY
 
     C                   If        PRtcd <> *Blanks
     C                   Eval      PGenErr = 'Y'
     C                   Add       1             PIdx
     C                   Eval      PMsgIdar(PIdx) = 'USR8008'
     C                   Else
     C                   Eval      PCurVal = A9BROK
     C                   EndIf
 
     C                   EndIf
 
     C                   Eval      *INLR = *On
     C                   Return
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
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    PSysVal
     C                   PARM                    PCurVal
     C                   PARM                    PProcMod
     C                   PARM                    PGenErr
     C                   PARM                    PIdx
     C                   PARM                    PMsgIdar
 
     C                   ENDSR
 
