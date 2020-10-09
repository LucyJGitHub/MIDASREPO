     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Unnecessary Network Accounts Deletion')       *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL001429 - Midas GL Unnecessary Network Accounts Deletion    *
      *                                                               *
      *  Function:  This module deletes the network accounts, which   *
      *             are linked to a closed or unexisting GL account.  *
      *             The records so deleted will be dropped during the *
      *             next EOD by the component GL001428. That's why    *
      *             their last change date is set to the next working *
      *             day.                                              *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGL013  *CREATE    Date 08May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL013 - MT94x Messages Generation                           *
      *                                                               *
      *****************************************************************

     FGLNWACL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Network Accounts - Update
      *

     FGLNW94L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL Network Accounts MT94x Details - Update
      *

     FGLGS94L0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Midas GL MT941/2 Generation Schedules - Update
      *

      *========================================================================*
      *                                                                        *
      * Use of Indicators                                                      *
      *                                                                        *
      * Database Error Indicators                                              *
      *                                                                        *
      * U7 - Abnormal Completion                                               *
      * U8 - File Out of Balance                                               *
      * U7 + U8 - Database Error                                               *
      *                                                                        *
      * Other Indicators                                                       *
      *                                                                        *
      * 99 - Multi-purpose                                                     *
      *                                                                        *
      *========================================================================*

      *========================================================================*
      ** Automatically included D-specs
      ** ==============================
      *

      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS

      ** Manually included D-specs
      ** =========================
      *

      ** Named constants
      ** ---------------
      *

      ** Arrays and Data Structures
      ** --------------------------
      *

     D DsBANK        E DS                  EXTNAME(SDBANKPD)
      ** Midas SD Bank details ICD
      *

     D DsACCNT       E DS                  EXTNAME(ACCNTAB) PREFIX(AC_)
      ** Account details record format data structure
      *

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS (long) used as output parameter for Access Objects
      *

      ** Declared variables
      ** ------------------
      *

      *------------------------------------------------------------------------*
      ** C Spec. Declaratives
      ** ====================
      *

      ** Key lists
      *
     C     KNetWkAc      KLIST
     C                   KFLD                    NANWRK
     C                   KFLD                    NABRCH
     C                   KFLD                    NACNUM
     C                   KFLD                    NACCY
     C                   KFLD                    NAACOD
     C                   KFLD                    NAACSQ
     C                   KFLD                    NANATY

      *========================================================================*
      *              M  A  I  N     P  R  O  C  E  S  S  I  N  G               *
      *========================================================================*

      ** Init processing uses the standard *INZSR subroutine

      ** First read of GLNWACL0
      *
     C     *LOVAL        SETLL     GLNWACD0
     C                   READ      GLNWACD0                               99

      ** Main loop on GLNWACL0 until end of file
      *  =======================================
 B1  C                   DOW       NOT *IN99

      ** Verify the validity of the GL account
      *
     C                   EXSR      $RtvACCNT

      ** Delete the network account if the GL account doesn't exist or is closed
      *
 B2  C                   IF        AccOK = 'N'
     C                   EXSR      $HldGS94
     C                   EXSR      $DelNW94
     C                   EXSR      $DelNWAC

      ** Commit the changes done for the current network account
      *
     C                   COMMIT
 E2  C                   ENDIF

      ** Rollback to avoid further unwanted changes and read next network account
      *
     C                   ROLBK
     C     KNetWkAc      SETGT     GLNWACD0
     C                   READ      GLNWACD0                               99
 E1  C                   ENDDO

      ** Exit module
      *
     C                   EXSR      $ExitMod

      *========================================================================*
      *                    S  U  B  R  O  U  T  I  N  E  S                     *
      *========================================================================*

      *========================================================================*
      * $RtvACCNT : Retrieve an account record                                 *
      *------------------------------------------------------------------------*
     C     $RtvACCNT     BEGSR
      *    ----------    ------
     C                   MOVEL     NACNUM        @CNUM
     C                   MOVEL     NAACOD        @ACCD
     C                   MOVEL     NAACSQ        @ACSQ

     C                   CALLB     'AOACCTR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      *Blanks       @RETL            10
     C                   PARM                    @CNUM             6
     C                   PARM      NACCY         @CUCD             3
     C**********         PARM                    @ACCD             4                          CGL029
     C                   PARM                    @ACCD            10                          CGL029
     C                   PARM                    @ACSQ             2
     C                   PARM      NABRCH        @BRCA             3
     C     DsACCNT       PARM                    DSSDY

     C                   IF        @RtCd <> *Blanks AND @RtCd <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'ACCNTAB'                           *=======*
     C                   EVAL      DBKey  = @CNUM+@CUCD+@ACCD+@ACSQ+@BRCA       *       *
     C                   EVAL      DBPgm  = PSProcPgm                           * Error *
     C                   EVAL      DBase  = 002                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  002  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   IF        @RtCd = '*NRF' OR AC_ACST = 'C'
     C                   MOVE      'N'           AccOK             1
     C                   ELSE
     C                   MOVE      'Y'           AccOK
     C                   ENDIF
      *    ----------    ------
     C     @RtvACCNT     ENDSR

      *========================================================================*
      * $HldGS94  : Holds all the generation schedules of a network account    *
      *------------------------------------------------------------------------*
     C     $HldGS94      BEGSR
      *    ----------    ------
     C     KNetWkAc      SETLL     GLGS94D0
     C     KNetWkAc      READE     GLGS94D0                               99

     C                   DOW       NOT *IN99
     C                   EVAL      GSSTUS = 'HELD'
     C                   UPDATE    GLGS94D0

     C     KNetWkAc      READE     GLGS94D0                               99
     C                   ENDDO
      *    ----------    ------
     C     @HldGS94      ENDSR

      *========================================================================*
      * $DelNW94  : logically delete the MT94x details of a network account    *
      *------------------------------------------------------------------------*
     C     $DelNW94      BEGSR
      *    ----------    ------
     C     KNetWkAc      SETLL     GLNW94D0
     C     KNetWkAc      READE     GLNW94D0                               99

     C                   DOW       NOT *IN99
     C                   EVAL      N4RECI = '*'
     C                   EVAL      N4LCDT = BJDNWD
     C                   EVAL      N4CHTP = 'D'
     C                   EVAL      N4USER = PSUser
     C                   UPDATE    GLNW94D0

     C     KNetWkAc      READE     GLNW94D0                               99
     C                   ENDDO
      *    ----------    ------
     C     @DelNW94      ENDSR

      *========================================================================*
      * $DelNWAC  : Logically delete a network account                         *
      *------------------------------------------------------------------------*
     C     $DelNWAC      BEGSR
      *    ----------    ------
     C                   EVAL      NARECI = '*'
     C                   EVAL      NALCDT = BJDNWD
     C                   EVAL      NACHTP = 'D'
     C                   EVAL      NAUSER = PSUser
     C                   UPDATE    GLNWACD0
      *    ----------    ------
     C     @DelNWAC      ENDSR

      *========================================================================*
      * $ExitMod  : Exit from the module                                       *
      *------------------------------------------------------------------------*
     C     $ExitMod      BEGSR
      *    ----------    ------
     C                   MOVE      *On           *INLR
     C                   RETURN
      *    ----------    ------
     C     @ExitMod      ENDSR

      *========================================================================*
      * *INZSR    : Init Processing                                            *
      *========================================================================*
     C     *INZSR        BEGSR
      *    ----------    ------
      ** Initialise Copyright Array
      *
     C                   MOVEA     CPY@          CPY@@            80

      ** Retrieve the Bank's ICD to get the next working day number
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C     DsBANK        PARM                    DSSDY

     C                   IF        @RtCd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'                          *=======*
     C                   EVAL      DBKey  = *Blank                              *       *
     C                   EVAL      DBPgm  = PSProcPgm                           * Error *
     C                   EVAL      DBase  = 001                                 *       *
     C                   EVAL      DBMod  = PSProcMod                           *  001  *
     C                   EVAL      DBProc = PSProcName                          *       *
     C                   OUT       LDA                                          *=======*
     C                   EXSR      *PSSR
     C                   ENDIF
      *    ----------    ------
     C     @INZSR        ENDSR

      *========================================================================*
      * *PSSR     : Program exception error subroutine                         *
      *------------------------------------------------------------------------*
     C     *PSSR         BEGSR
      *    ----------    ------
     C                   DUMP
     C                   ROLBK

     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On

     C                   CALLB     'DBERRCTL'                           99

     C                   EXSR      $ExitMod
      *    ----------    ------
     C     @PSSR         ENDSR

      *========================================================================*
**  CPY@
(c) Finastra International Limited 2002
