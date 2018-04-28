     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF OTCC/EXTR - Update')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FFTRAN2UP - FF OTCC/EXTR - Update                            *
      *                                                               *
      *  Function:  This function applied the Exchange-Traded         *
      *             Extended Details to the Midas Database            *
      *                                                               *
      *  Component of:  SP8FF0002  - Midas SP FF core non-kernel      *
      *                              non-validn functions 2           *
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
 
     FFFTRX2PD  UF A E           K DISK
     F                                     RENAME(TRANSDD6:UPDIDX)
     F                                     COMMIT
      *
      ** Transaction file for Futures & Options
      *
 
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** Valid extended Futures and Options Details
     D FFVEXTR       E DS                  EXTNAME(FFVTNLX1PD)
 
      ** Extended Futures and Options File
     D NWRCD         E DS                  EXTNAME(FFTRX2PD)
 
      ** Extended Futures and Options File
     D SVRCD         E DS                  EXTNAME(FFTRX2PD)
     D                                     PREFIX(SV)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
     D ACTN            S              1
     D WFIND           S              1
 
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
      *
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Access extended file
      *
     C                   MOVE      #6LXFFTNBR    K@TNBR
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C     @TYPE         IFEQ      '1'
      *
      ** If record locked, display screen again, with information message.
      *
     C     *IN91         IFEQ      *ON
     C                   MOVEL     '*RECLCK'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Insert Mode
      *
     C     WFIND         IFNE      'Y'
     C     ACTN          OREQ      'I'
      *
      ** If the record exists, the details have been modified by another user
      *
     C     *IN84         IFEQ      *OFF
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Amend/Delete Mode
      *
      *
      ** If the record does not exist, or has been modified by another user
      *
     C     *IN84         IFEQ      *ON
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write, delete or Update extended file
      *
     C     ACTN          IFEQ      'I'
     C     ACTN          OREQ      'A'
      *
     C                   MOVE      FFVEXTR       NWRCD
      *
      ** Write or update extended record
      *
     C     *IN84         IFEQ      *OFF
     C                   UPDATE    UPDIDX
     C                   ELSE
     C                   WRITE     UPDIDX
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ENDPGM        TAG
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
     C                   PARM                    FFVEXTR
     C                   PARM                    SVRCD
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
      ** Define key to access to extended details
      *
     C     *LIKE         DEFINE    FFTNBR        K@TNBR
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@TNBR
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
