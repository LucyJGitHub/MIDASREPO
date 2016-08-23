     H FIXNBR (*INPUTPACKED)
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD - Update - LU Window')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data ILE Module                             *
      *                                                               *
      *  SDCUSD2UP - SD Customers Extension Update - LU Window        *
      *                                                               *
      *  Function:  This function applied the Customers Extended      *
      *             Details to the Midas Database                     *
      *                                                               *
      *  Component of:  SP8SD0006 - Core Luxembourg service program   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG13597           Date 20Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 05May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG13597 - MidasPlus Error encountered when authorising an   *
      *             amend transaction                                 *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FSDCUX2PD  UF A E           K DISK
     F                                     RENAME(SDCUSTF6:UPDIDX)
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
 
      ** Valid extended Customers Details
     D SDVCUSD       E DS                  EXTNAME(SDVCULX2PD)
 
      ** Extended Customers File
     D NWRCD         E DS                  EXTNAME(SDCUX2PD)
 
      ** Extended Customers File
     D SVRCD         E DS                  EXTNAME(SDCUX2PD)
     D                                     PREFIX(SV)
 
      **
      **   Declared variables
      **   ==================
      **
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
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
      ** Access extended file
      *
     C                   MOVE      #6LXVFCUST    K@CUST
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
      ** If the record does not exist, or has been modified by another user
      *
     C     *IN84         IFEQ      *ON
     C******IN84         OREQ      *OFF                                                     BUG13597
     C*****NWRCD         ANDNE     SVRCD                                                    BUG13597
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
     C     ACTN          IFEQ      'D'
      *
     C                   ELSE
      *
     C                   EVAL      VFCUST = #6LXVFCUST
     C                   EVAL      VFCONS = #6LXVFCONS
     C                   EVAL      VFECOS = #6LXVFECOS
     C                   EVAL      VFINRF = #6LXVFINRF
     C                   EVAL      VFCGRP = #6LXVFCGRP
     C                   EVAL      VFCRNM = #6LXVFCRNM
     C                   EVAL      VFCOLC = #6LXVFCOLC
     C                   EVAL      VFPAPS = #6LXVFPAPS
     C                   EVAL      VFPERF = #6LXVFPERF
     C                   EVAL      VFNCOS = #6LXVFNCOS
     C                   EVAL      VFAUTG = #6LXVFAUTG
     C                   EVAL      VFPROG = #6LXVFPROG
     C                   EVAL      VFASSP = #6LXVFASSP
     C                   EVAL      VFICCD = #6LXVFICCD
     C                   EVAL      VFMCID = #6LXVFMCID
     C                   EVAL      VFSMRS = #6LXVFSMRS
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
     C                   MOVE      *ON           *INLR
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
     C                   PARM                    SDVCUSD
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
     C     *LIKE         DEFINE    VFCUST        K@CUST
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@CUST
      *
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
