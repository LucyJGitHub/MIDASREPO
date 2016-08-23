     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Authorisation Log file Housekeeping')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD4711 - Authorisation Log file Housekeeping                 *
      *                                                               *
      *  Function:  This module will delete Customer Details in       *
      *             SDCDSHPD, SDCBSHPD, SDPBSHPD and SDAULGPD if      *
      *             status is Blanks, 'R' or 'A'.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027A            Date 05May06               *
      *  Prev Amend No. CSD028  *CREATE    Date 22Aug05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD028 - KYC (Standing Data Authorisations )                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
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
 
      ** Midas SD Authorisation Log
     FSDAULGL2  UF   E           K DISK         INFSR(*PSSR)
 
      ** Midas SD Customer Details Update Shadow File
     FSDCDSHL0  UF   E           K DISK
 
      ** Midas BRT Customer Details Shadow File
     FSDCBSHL0  UF   E           K DISK
 
      ** Midas SD Private Banking Details
     F*SDPBSHL0  UF   E             DISK                                                     CSD027A
     FSDPBSHL0  UF   E           K DISK                                                      CSD027A
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D*WCusNum**       S              6  0                                                   CSD027A
     D WCusNum         S              6A                                                     CSD027A
     D WCusChr         S              6
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *LOVAL        SETLL     SDAULGL2
     C                   READ      SDAULGL2
 
     C                   DOW       NOT %EOF(SDAULGL2)
 
     C                   IF        ALSTAT = *BLANKS OR ALSTAT = 'R' OR
     C                             ALSTAT = 'A'
 
     C                   IF        ALFUNC = 'CUSTOMER DETAILS'
     C                   EVAL      WCusChr = %SUBST(ALKEY:1:6)
     C                   MOVE      WCusChr       WCusNum
 
     C     WCusChr       CHAIN     SDCDSHL0
     C                   IF        %FOUND(SDCDSHL0)
     C                   DELETE    @BBREBG
     C                   ENDIF
 
     C     WCusNum       CHAIN     SDCBSHL0
     C                   IF        %FOUND(SDCBSHL0)
     C                   DELETE    SDCBRTD0
     C                   ENDIF
 
     C     WCusNum       CHAIN     SDPBSHL0
     C                   IF        %FOUND(SDPBSHL0)
     C                   DELETE    SDPBDSD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   DELETE    SDAULGD0
     C                   ENDIF
 
     C                   READ      SDAULGL2
     C                   ENDDO
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
