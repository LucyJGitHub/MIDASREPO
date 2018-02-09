     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT OPAY - Update')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY2UP - FT Outgoing Payments Extension Update            *
      *                                                               *
      *  Function:  This function applied the Outgoing Payments       *
      *             Extended Details to the Midas Database            *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CFT032             Date 11Sep06               *
      *                 CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FFTOPX1PD  UF A E           K DISK
     F                                     RENAME(OTPAYDDL:UPDIDX)
     F                                     COMMIT
 
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
 
      ** Valid extended Outgoing payments Details
     D FTVOPAY       E DS                  EXTNAME(FTVOPLX1PD)
 
      ** Extended Outgoing payments File
     D NWRCD         E DS                  EXTNAME(FTOPX1PD)
 
      ** Extended Outgoing payments File
     D SVRCD         E DS                  EXTNAME(FTOPX1PD)
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
 
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ***  Initial processing is performed automatically: the *INZSR is
      ***  executed at program activation.
      *
      ***  Access extended file
      *
     C                   MOVE      #LLXOPPREF    K@PREF
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ***  If interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ***  If record locked, display screen again, with information message.
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
      ** Write or Update extended file
      *
     C                   IF        PActn <> 'D'
      *
     C                   EVAL      OPPREF = #LLXOPPREF
     C                   EVAL      OPORTY = #LLXOPORTY
     C                   EVAL      OPBETY = #LLXOPBETY
     C                   EVAL      OPOPCO = #LLXOPOPCO
     C                   EVAL      OPCOCO = #LLXOPCOCO
     C                   EVAL      OPIDCO = #LLXOPIDCO
     C                   EVAL      OPIDEN = #LLXOPIDEN
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
      ***  Exit from program
      *
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ***  Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PActn
     C                   PARM                    @RTCD
     C                   PARM                    PFind
     C                   PARM                    FTVOPAY
     C                   PARM                    SVRCD
      *
      ***  Determine whether program is running interactively or in batch
      ***  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
      ***  Define key to access to extended details
      *
     C     *LIKE         DEFINE    OPPREF        K@PREF
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@PREF
      *
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2005
