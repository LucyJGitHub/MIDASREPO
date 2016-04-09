     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Compound API ext.file Init GLACNTQD')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RPGLE/CLE025R02 - Initialisation Program for :               *
      *                    Accounts Extension Details Initialisation  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CRE095             Date 25Apr14               *
      *  Prev Amend No. CRE090             Date 14Feb14               *
      *                 AR1095876          Date 30Sep13               *
      *                 AR899028           Date 25Jan12               *
      *                 AR847269           Date 09Nov11               *
      *                 CER042             Date 11May11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 04Jan10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG5025  *CREATE   Date 11Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE095 - Rate Fixing for RE Accounts                         *
      *  CRE090 - Delay Capitalisation of Interest                    *
      *  AR1095876- ABC - Forward Days 1 should = DNWD-1, not just    *
      *             RUND (Child: AR1095877) (Recompile)               *
      *  AR899028 - NOSTRO AMAD System errors occured; applied        *
      *             fix AR847269                                      *
      *  AR847269 - Column F1DACN not in specified tables (Recompile) *
      *  CER042 - Interest Scale Report Correspondence                *
      *           (Upgrade of FGE178/179) (Recompile)                 *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG5025- File GLACNTQD not being initialised caused problem  *
      *           with amendment of Account by (AMAD) in MidasPlus    *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
 
      ** Accounts Master Extension file
     FGLACNTL3  UF A E           K DISK    PREFIX(AX_)
 
      ** Accounts Master File
     FACCNTAB   IF   E             DISK    PREFIX(AC_)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** | D-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** +--------------------------------------+
      ** | End of D-specs                       |
      ** | ==============                       |
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
 
      ** Initialise the Accounts Extension File
 
     C                   EXSR      SRInitACEX
 
      ** End program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInitAMEX - Initialise the Account Master Extension File    *
      *****************************************************************
     C     SrInitACEX    BEGSR
 
      ** Read records then update the Accounts extension file
 
     C                   READ      ACCNTAB                                81
 
     C                   DOW       *IN81 = *OFF
 
     C                   EVAL      AX_F1CNUM = AC_CNUM
     C                   EVAL      AX_F1CCY  = AC_CCY
     C                   EVAL      AX_F1ACOD = AC_ACOD
     C                   EVAL      AX_F1ACSQ = AC_ACSQ
     C                   EVAL      AX_F1BRCA = AC_BRCA
     C                   EVAL      AX_F1FCHD = *ZERO
     C                   EVAL      AX_F1LFCD = *ZERO
     C                   EVAL      AX_F1ACBL = *ZERO
     C                   EVAL      AX_F1TEXO = *ZERO
     C                   EVAL      AX_F1TEOF = *ZERO
     C                   EVAL      AX_F1TEOC = *ZERO
     C                   EVAL      AX_F1DECD = *ZERO                                          CRE090
     C                   EVAL      AX_F1DRFD = *ZERO                                          CRE095
     C                   EVAL      AX_F1DNFD = *ZERO                                          CRE095
     C                   EVAL      AX_F1DNFM = *ZERO                                          CRE095
     C                   EVAL      AX_F1CRFD = *ZERO                                          CRE095
     C                   EVAL      AX_F1CNFD = *ZERO                                          CRE095
     C                   EVAL      AX_F1CNFM = *ZERO                                          CRE095
 
     C     ACKEY         CHAIN     GLACNTL3                           99
     C                   IF        *IN99 = '1'
     C                   WRITE     GLACNTD0
     C                   ENDIF
     C                   READ      ACCNTAB                                81
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Subroutine for Initial First Cycle processing        *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     CPY@          BIS@             80
 
     C     ACKEY         KLIST
     C                   KFLD                    AC_CNUM
     C                   KFLD                    AC_CCY
     C                   KFLD                    AC_ACOD
     C                   KFLD                    AC_ACSQ
     C                   KFLD                    AC_BRCA
 
     C                   ENDSR
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
