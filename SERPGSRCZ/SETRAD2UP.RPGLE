     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE TRAD - Update - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SETRAD2UP - SE Trades Extension Update                       *
      *                                                               *
      *  Function:  This Function applied the Depot Trades Extended   *
      *             Details to the Midas Database                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
     FSETRX1PD  UF A E           K DISK
     F                                     RENAME(TRADSDD6:UPDIDX)
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
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
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
      ** Valid extended Trades Details
      *
     D SEVTRAD       E DS                  EXTNAME(SEVTDLX1PD)
      *
      ** Extended Trades File
      *
     D NWRCD         E DS                  EXTNAME(SETRX1PD)
      *
      ** Extended Trades File
      *
     D SVRCD         E DS                  EXTNAME(SETRX1PD)
     D                                     PREFIX(SV)
      *
      **
      **   Declared variables
      **   ==================
      **
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
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      ** Access extended file
      *
     C                   MOVE      #6LXCCTDRF    K@TDRF
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE  = '1'
      *
      ** If record locked, display screen again, with information message.
      *
     C                   IF        *IN91  = *ON
     C                   MOVEL     '*RECLCK'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        WFIND <> 'Y'   OR
     C                             ACTN   = 'I'
      *
      ** If the record exists, the details have been modified by another user
      *
     C                   IF        *IN84  = *OFF
     C                   MOVEL     '*RECUPD'     ReturnCode
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
     C                   IF        *IN84  = *ON
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write or Update extended file
      ** Deletion will be in COB
      *
     C                   IF        ACTN   <> 'D'
      *
     C                   EVAL      CCTDRF =  #6LXCCTDRF
     C                   EVAL      CCAGSD =  #6LXCCAGSD
     C                   EVAL      CCTIME =  #6LXCCTIME
     C                   EVAL      CCEXFL =  #6LXCCEXFL
     C                   EVAL      CCCABR =  #6LXCCCABR
     C                   EVAL      CCMTRD =  #6LXCCMTRD
      *
      ** Write or update extended record
      *
     C                   IF        *IN84  = *OFF
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
     C                   PARM                    ReturnCode
     C                   PARM                    WFIND
     C                   PARM                    SEVTRAD
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
     C     *LIKE         DEFINE    CCTDRF        K@TDRF
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@TDRF
      *
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
