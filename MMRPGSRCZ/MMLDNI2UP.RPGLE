     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/Deposits LUX Update')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Module                                  *
      *                                                               *
      *  MMLDNI2UP - MM Loans/Deposits LUX Update                     *
      *                                                               *
      *  Function:  This function applied the Loans/Deposits Extended *
      *             Details to the Midas Database                     *
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
 
     FMMDLX1PD  UF A E           K DISK
     F                                     RENAME(MMDELDF6:UPDIDX)
     F                                     COMMIT
 
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
 
      *
      ** Valid extended Loan/Deposit Details
      *
     D MMVLDNI       E DS                  EXTNAME(MMVLDLX1PD)
 
      *
      ** Extended Loan/Deposits File
      *
     D SVRCD         E DS                  EXTNAME(MMDLX1PD)
     D                                     PREFIX(SV)
 
      *
      **   Declared variables
      **   ==================
      *
 
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D WFIND           S              1
 
      *
      ** Modules parameters
      *
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
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
     C                   DO
      *
      ** Access extended file
      *
     C     #6LXVLDN38    CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ** If record locked, display screen again, with information
      ** message.
      *
     C                   IF        *IN91
     C                   MOVEL     '*RECLCK'     @RTCD
     C                   LEAVE
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        WFIND <> 'Y' or
     C                             ACTN = 'I'
      *
      ** If the record exists, the details have been modified
      ** by another user
      *
     C                   IF        NOT *IN84
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   LEAVE
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Amend/Delete Mode
      *
      ** If the record does not exist, or has been modified
      ** by another user
      *
     C                   IF        *IN84
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write or Update extended file
      *
     C                   IF        ACTN <> 'D'
      *
     C                   EVAL      VLDN38 = #6LXVLDN38
     C                   EVAL      VLSUBR = #6LXVLSUBR
     C                   EVAL      VLMOBL = #6LXVLMOBL
     C                   EVAL      VLRISC = #6LXVLRISC
     C                   EVAL      VLIMEX = #6LXVLIMEX
     C                   EVAL      VLPPSC = #6LXVLPPSC
     C                   EVAL      VLCOAM = #6LXVLCOAM
     C                   EVAL      VLIM93 = #6LXVLIM93
     C                   EVAL      VLCLAT = #6LXVLCLAT
     C                   EVAL      VL1UAC = #6LXVL1UAC
     C                   EVAL      VLLUSU = #6LXVLLUSU
     C                   EVAL      VLLURA = #6LXVLLURA
      *
      ** Write or update extended record
      *
     C                   IF        Not *In84
     C                   UPDATE    UPDIDX
     C                   ELSE
     C                   WRITE     UPDIDX
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Exit from program
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    @RTCD
     C                   PARM                    WFIND
     C                   PARM                    MMVLDNI
     C                   PARM                    SVRCD
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      ** *PSSR  - Program exception error routine                     *
      **          Called automatically if a program error occurs,     *
      **          or directly by the program code using EXSR.         *
      **          This subroutine DUMPs the program, and performs     *
      **          a ROLLBACK.                                         *
      *                                                               *
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
     C/COPY ZACPYSRC,PSSR_ILE
      *
      ** Note: if non-standard processing required, use the PSSR_ILENE
      ** subroutine
      *
      ****************************************************************
      /EJECT
      ****************************************************************
