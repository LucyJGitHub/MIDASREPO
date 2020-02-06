     H DEBUG
     H COPYRIGHT ('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL AMAD LUX Update')
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLAMAD6UP - GL AMAD LUX Update                               *
      *                                                               *
      *  Function: This function applied the Account Extended         *
      *            Details to the Midas Database                      *
      *                                                               *
      *  Component of: SP8GL0004 Service Program                      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027A            Date 09May06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
     FREACX1PD  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTBF6:UPDIDX)
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
 
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
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
 
      ** Valid extended Account Details
     D GLVAMAD       E DS                  EXTNAME(GLVAMLX1L1)
 
      ** Extended Account File
     D NWRCD         E DS                  EXTNAME(REACX1PD)
 
      ** Extended Account File
     D SVRCD         E DS                  EXTNAME(REACX1PD)
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
 
      ** Define key to access to extended details
      *
     D K@CNUM          S                   LIKE(WECNUM)
     D K@CCYC          S                   LIKE(WECCYC)
     D K@ACOD          S                   LIKE(WEACOD)
     D K@ACSQ          S                   LIKE(WEACSQ)
     D K@BRCA          S                   LIKE(WEBRCA)
      *
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
     C                   MOVE      #6LXWECNUM    K@CNUM
     C                   MOVE      #6LXWECCYC    K@CCYC
     C                   MOVE      #6LXWEACOD    K@ACOD
     C                   MOVE      #6LXWEACSQ    K@ACSQ
     C                   MOVE      #6LXWEBRCA    K@BRCA
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ** If record locked, display screen again,
      ** with information message.
      *
     C                   IF        *IN91 = *ON
     C                   MOVEL     '*RECLCK'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** In Amend Mode
      ** Check record exists before update
      *
     C                   IF        PActn = 'A'
      *
      ** If the record does not exist, or has been modified by another user
      *
     C                   IF        *IN84 =  *OFF AND
     C                             NWRCD <> SVRCD
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
      *
      ** IN INSERT MODE
      *
     C                   IF        PActn = 'I'
      *
      ** If the record exists
      *
     C                   IF        *IN84 = *OFF
     C                   MOVEL     '*RECUPD'     @RTCD
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Write, delete or Update extended file
      *
     C                   IF        PActn = 'D'
      *
     C                   ELSE
      *
     C                   CLEAR                   NWRCD
      *
     C                   EVAL      WECNUM = #6LXWECNUM
     C                   EVAL      WECCYC = #6LXWECCYC
     C                   EVAL      WEACSQ = #6LXWEACSQ
     C                   EVAL      WEATYP = #6LXWEATYP
     C                   EVAL      WE1UAC = #6LXWE1UAC
     C                   EVAL      WELUSU = #6LXWELUSU
     C                   EVAL      WELURA = #6LXWELURA
     C                   EVAL      WECOAM = #6LXWECOAM
     C                   EVAL      WECOBR = #6LXWECOBR
     C                   EVAL      WEBRCA = #6LXWEBRCA
     C                   EVAL      WECOAC = #6LXWECOAC
     C                   MOVE      #6LXWEACOD    WEACOD
      *
      ** Write or update extended record
      *
     C                   IF        *IN84 = *OFF
     C                             AND @TYPE = '1'
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
     C                   PARM                    @RTCD
     C                   PARM                    PFind
     C                   PARM                    GLVAMAD
     C                   PARM                    SVRCD
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@CNUM
     C                   KFLD                    K@CCYC
     C                   KFLD                    K@ACOD
     C                   KFLD                    K@ACSQ
     C                   KFLD                    K@BRCA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error
      ** processing.
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
