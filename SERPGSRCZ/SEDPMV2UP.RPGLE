     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE DPMV - Update')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SEDPMV2UP - SE Depot Movements Extension Update              *
      *                                                               *
      *  Function:  This Function applied the Depot Movement Extended *
      *             Details to the Midas Database                     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *                                                               *
      *****************************************************************
 
     FSEDPX1PD  UF A E           K DISK
     F                                     RENAME(DPTMVDF6:UPDIDX)
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
 
      ** Include the standard declares
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
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
 
      ** Valid extended Depot Movements Details
     D SEVDPMV       E DS                  EXTNAME(SEVDMLX1PD)
 
      ** Extended Depot Movements File
     D SVRCD         E DS                  EXTNAME(SEDPX1PD)
     D                                     PREFIX(SV)
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** "Standard" *entry parameters
 
     D PActn           S              1
     D PFind           S              1
 
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
     C                   MOVE      #6LXWNDPSS    K@DPSS
     C                   MOVE      #6LXWNDPRN    K@DPRN
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE  = '1'
      *
      ** If record locked, display screen again, with information
      ** message.
      *
     C                   IF        *IN91  = *ON
     C                   MOVEL     '*RECLCK'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        PFind <> 'Y' OR
     C                             PActn =  'I'
      *
      ** If the record exists, the details have been modified by
      ** another user
      *
     C                   IF        *IN84 = *OFF
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Amend/Delete Mode
      *
      *
      ** If the record does not exist, or has been modified by another
      ** user
      *
     C                   IF        *IN84 = *ON
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write, or Update extended file
      *
     C                   IF        PActn <> 'D'
      *
     C                   EVAL      WNDPSS  =  #6LXWNDPSS
     C                   EVAL      WNDPRN  =  #6LXWNDPRN
     C                   EVAL      WNOPTP  =  #6LXWNOPTP
     C                   EVAL      WNEXCF  =  #6LXWNEXCF
     C                   EVAL      WNTIME  =  #6LXWNTIME
     C                   EVAL      WNCABR  =  #6LXWNCABR
     C                   EVAL      WNEXFL  =  #6LXWNEXFL
     C                   EVAL      WNCNBR  =  #6LXWNCNBR
      *
      ** Write or update extended record
      *
     C                   IF        *IN84 = *OFF
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
     C                   PARM                    PActn
     C                   PARM                    ReturnCode
     C                   PARM                    PFind
     C                   PARM                    SEVDPMV
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
     C     *LIKE         DEFINE    WNDPSS        K@DPSS
     C     *LIKE         DEFINE    WNDPRN        K@DPRN
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@DPSS
     C                   KFLD                    K@DPRN
      *
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2005
