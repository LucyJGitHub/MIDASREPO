     H DEBUG
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Finastra International Systems Ltd. 2020')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('CER076 Take-On update')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  UTCER076 - Take-on Update                                    *
      *                                                               *
      *  Function:  This program initialises CER076 extension files   *
      *                                                               *
      *  (c) Finastra International Systems Ltd 2020                  *
      *                                                               *
      *  Last Amend No. CER076   *Create     Date 17Feb20             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER076   - Update to KWG § 24c interface specification       *
      *             (BaFin version 3.3)                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8 -  Database Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR   - Program exception error routine                    *
      *  *INZSR  - Initialisation Subroutine                          *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Additional Customer Details
     FSDACUSPD  IF   E             DISK    INFSR(*PSSR)

      ** Midas Additional Customer Details Extension
     FSDACUSY0  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(AX_)

      ** Non-Account Holders Details
     FSDNAHOPD  IF   E             DISK    INFSR(*PSSR)

      ** Midas Non-Account Holders Details Extension
     FSDNAHOY0  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(NX_)

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D LDA           E DS           256    EXTNAME(LDA)

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.

      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE

      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Data Structure for input parameter

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Work Variables

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************


     C                   Read      SDACUSPD
     C                   Dow       Not %EOF(SDACUSPD)

     C     E5Cust        Chain     SDACUSY0                           50
     C                   If        Not %Found(SDACUSY0)
     C                   Eval      AX_E5CUST = E5CUST
     C                   Eval      AX_E5EINO = *Blanks
     C                   Write     SDACUSF0
     C                   Endif

     C                   Read      SDACUSPD
     C                   Enddo

     C                   Read      SDNAHOPD
     C                   Dow       Not %EOF(SDNAHOPD)

     C     NHNaho        Chain     SDNAHOY0                           50
     C                   If        Not %Found(SDNAHOY0)
     C                   Eval      NX_NHNaho = NHNaho
     C                   Eval      NX_NHEINO = *Blanks
     C                   Write     SDNAHOF0
     C                   Endif

     C                   Read      SDNAHOPD
     C                   Enddo

      ** End Program and Return to Caller

     C                   EVAL      *INLR = *ON
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

      ** Initialise Program and Module names

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   EVAL      DBMOD = PSProcMod
     C                   OUT       LDA

     C                   DUMP

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

      *****************************************************************
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

      ** Defining Data Area

     C     *DTAARA       DEFINE                  LDA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Systems Ltd. 2020
