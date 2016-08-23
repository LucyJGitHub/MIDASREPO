     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM NAs Purchased LUX Update')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMNASP2UP - MM NA Purchased LUX Update                       *
      *                                                               *
      *  Function:  This function writes/updates the Lux extra data   *
      *             to the MIDAS database.                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FMMDBX2L0  UF A E           K DISK    COMMIT
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                    error handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** Valid extended Loan/Deposit Details
     D MMVNASPLux    E DS                  EXTNAME(MMVNPLX1PD)
 
      *
      **   Declared variables
      **   ==================
      *
 
      ** Modules parameters
     D @RETURN         S              6
     D @TYPE           S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
 
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
 
     C                   EXSR      SRUPD6
 
      ** Exit from program
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPD6 - Routine to update extension file 6                  *
      *                                                               *
      *****************************************************************
     C     SRUPD6        BEGSR
 
     C                   OPEN      MMDBX2L0
 
      ** Access extended file
     C     #6LXVMDN38    CHAIN     MMDBX2L0                           8481
 
      ** If interactive mode
     C                   IF        @TYPE = '1'
 
      ** If record locked, display screen again, with information
      ** message.
     C                   IF        *IN81
     C                   MOVEL     '*RECLCK'     @RTCD
     C                   LEAVESR
     C                   ENDIF
 
      ** Insert Mode
     C                   IF        P_ACTN = 'I'
 
      ** If the record exists, the details have been modified
      ** by another user
     C                   IF        NOT(*IN84)
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   LEAVESR
     C                   ENDIF
 
     C                   ELSE
 
      ** Amend/Delete Mode
 
      ** If the record does not exist, or has been modified
      ** by another user
     C                   IF        *IN84
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   LEAVESR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write or Update extended file
     C                   IF        P_ACTN <> 'D'
 
     C                   EVAL      VMDN38 = #6LXVMDN38
     C                   EVAL      VMSUBR = #6LXVMSUBR
     C                   EVAL      VMMOBL = #6LXVMMOBL
     C                   EVAL      VMRISC = #6LXVMRISC
     C                   EVAL      VMROFC = #6LXVMROFC
     C                   EVAL      VMRATC = #6LXVMRATC
     C                   EVAL      VMSECQ = #6LXVMSECQ
     C                   EVAL      VMSECT = #6LXVMSECT
     C                   EVAL      VMEVMT = #6LXVMEVMT
     C                   EVAL      VMOPTP = #6LXVMOPTP
     C                   EVAL      VMIM93 = #6LXVMIM93
     C                   EVAL      VMCLAT = #6LXVMCLAT
     C                   EVAL      VM1UAC = #6LXVMGUAC
     C                   EVAL      VMLUSU = #6LXVMLUSU
     C                   EVAL      VMLURA = #6LXVMLURA
     C                   EVAL      VMCOAM = #6LXVMCOAM
 
      ** Write or update extended record
     C                   IF        NOT(*IN84)
     C                   UPDATE    MMDENBF6
     C                   ELSE
     C                   WRITE     MMDENBF6
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CLOSE     MMDBX2L0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Parameters
 
     C     *ENTRY        PLIST
      ** Return Code 10A
     C                   PARM                    @RTCD             7
      ** Action Code
     C                   PARM                    P_ACTN            1
      ** Lux Valids data
     C                   PARM                    MMVNASPLux
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program, and performs     *
      *           a ROLLBACK.                                         *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
 
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
