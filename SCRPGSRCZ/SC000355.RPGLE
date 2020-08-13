     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Extract File Update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000355 - Midas SC Extract File Update                      *
      *                                                               *
      *  Function:  This program will be called by SCC000355 during   *
      *             COB.                                              *
      *                                                               *
      *  Called By: SCC000355 - Midas SC Extract File Update Control  *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. CAP702  *CREATE    Date 12May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP702 - 24x7 APIs - Common Processing                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  10         EOF read for PF/SCCDJNPD                          *
      *  U7-U8      Database Error                                    *
      *  LR         Exit program                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  #LINIT  -  Initial Processing                                *
      *  #LFNAL  -  Final Processing                                  *
      *  *PSSR   -  Program exception error routine                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      **
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FSCCDJNPD  UF A E           K DISK    INFSR(*PSSR)
      ** Midas SC Extracted Journal Info File
      *
      ****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *ON (for indcator processing)
      ** False      logical = *OFF (for indcator processing)
      ** DBErrCtl   10A = 'DBERRCTL' (the name of the database error
      ** handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C*
     C** Initialisation.
     C*
     C                   EXSR      #LINIT
     C*
     C** Final Processing.
     C*
     C                   EXSR      #LFNAL
     C*
     C                   MOVE      '1'           *INLR
      /EJECT
     C*
     C*****************************************************************
     C*                                                               *
     C* #LINIT  - Initial Processing.                                 *
     C*                                                               *
     C* Called by :  Main - Main Processing.                          *
     C*                                                               *
     C*****************************************************************
     C*
     C     #LINIT        BEGSR
     C*
     C** Set up copyright parameter
     C*
     C                   MOVEA     CPY@          BIS@             80
     C*
     C** Define parameters passed.
     C*
     C     *ENTRY        PLIST
     C                   PARM                    PJNRCN           10
     C                   PARM                    PJSEQN           10 0
     C*
     C                   ENDSR
      /EJECT
     C*
     C*****************************************************************
     C*                                                               *
     C* #LFNAL - Final Processing                                     *
     C*                                                               *
     C* Called by :  Main - Main Processing.                          *
     C*                                                               *
     C* Calls :  *PSSR    - Program exception error routine           *
     C*                                                               *
     C*****************************************************************
     C*
     C     #LFNAL        BEGSR
     C*
     C** Read the Midas SC Extracted Journal Info File.
     C*
     C                   READ      SCCDJNPD                               10
     C*
     C** If record is NOT found, write new record, else
     C*
     C     *IN10         IFEQ      *ON
     C*
     C** Update the record on SCCDJNPD.
     C*
     C                   MOVEL     *BLANKS       JNRCP
     C                   MOVEL     PJNRCN        JNRCN
     C                   Z-ADD     PJSEQN        JOSEQN
     C                   WRITE     SCCDJND0
     C*
     C                   ELSE
     C                   MOVEL     JNRCN         JNRCP
     C                   MOVEL     PJNRCN        JNRCN
     C                   Z-ADD     PJSEQN        JOSEQN
     C                   UPDATE    SCCDJND0
     C                   ENDIF
     C*
     C                   ENDSR
      /EJECT
     C*
     C*****************************************************************
     C*                                                               *
     C* *PSSR  - Program exception error routine                      *
     C*          Called automatically if a program error occurs,      *
     C*          or directly by the program code using EXSR.          *
     C*          This subroutine DUMPs the program just once.         *
     C*                                                               *
     C* Called by: #LFNAL  - Final Processing                         *
     C*                                                               *
     C*****************************************************************
     C*
     C     *PSSR         BEGSR                                                  ** *PSSR SR **
     C*
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   END
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*
