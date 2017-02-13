     H DEBUG
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('GZ Customer Extension Table Installation Utility ')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  GL0211 - GZ Customer Extension Table Installation Utility    *
      *                                                               *
      *  Function:  This program updates ext table for customers      *
      *             for CDL013.                                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. MD040482 *CREATE     Date 12Aug16             *
      *  Prev Amend No. nnnnnn               Date ddMmmyy             *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD040482 - T_GZCUSTEX not updated by CDL013.                 *
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

      ** Customer Details
     FSDCUSTPD  IF   E             DISK    INFSR(*PSSR)

      ** Midas GZ Customer Extension
     FTGZCUSTEX1UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(TEX_)

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


     C                   READ      SDCUSTPD
     C                   DOW       NOT %EOF(SDCUSTPD)

     C                   EVAL      TEX_KDDCUSN = BBCUST
     C                   EVAL      TEX_KZONE   = O#ZONE
     C     KEYTEX        CHAIN     TGZCUSTEX1                         50
     C                   IF        %FOUND(TGZCUSTEX1)
     C                   EVAL      TEX_DDCSTY = 'R'
     C                   UPDATE    T_GZCUSTEX
     C                   ENDIF


     C                   READ      SDCUSTPD
     C                   ENDDO

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

     C     KEYTEX        KLIST
     C                   KFLD                    TEX_KDDCUSN       6
     C                   KFLD                    TEX_KZONE        10


      ** Get Zone

     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       I#RTCD            7            * RETURN CODE
     C                   PARM      *BLANKS       I#ERMS           50            * ERROR MESSAGE
      * INPUTS
     C                   PARM      'N'           I#FULLCHECK       1
      * OUTPUTS
     C                   PARM                    O#ZONE           10
     C                   PARM                    O#SHTC            4
     C                   PARM                    O#RDNB            5 0
     C                   PARM                    O#DNWD            5 0
     C                   PARM                    O#BCCY            3
     C                   PARM                    O#NJOB            1 0

      ** Defining Data Area

     C     *DTAARA       DEFINE                  LDA

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2016
