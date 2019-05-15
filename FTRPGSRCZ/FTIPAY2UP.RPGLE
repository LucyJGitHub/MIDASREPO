     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY - Update - Extension')
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAY2UP - FT Incoming Payments Extension Update -          *
      *              Extension                                        *
      *                                                               *
      *  Function:  This function applies the extended datails of     *
      *             the Incoming Payments to Midas Database.          *
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
 
     FFTIPX1PD  UF A E           K DISK
     F                                     RENAME(INPAYDDL:UPDIDX)
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
 
      ** Valid extended Incoming payments Details
     D FTVIPAY       E DS                  EXTNAME(FTVIPLX1PD)
 
      ** Extended Incoming payments File
     D NWRCD         E DS                  EXTNAME(FTIPX1PD)
 
      ** Extended Incoming payments File
     D SVRCD         E DS                  EXTNAME(FTIPX1PD)
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
     C                   MOVE      #LLXIPPREF    K@PREF
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ** If record locked, display screen again, with information message.
      *
     C                   IF        *IN91 = *ON
     C                   MOVEL     '*RECLCK'     RetCodeIn
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Amend Mode
      *
     C                   IF        ACTN = 'A'
      *
      ** If the record does not exist, or has been modified by another user
      *
     C
     C                   IF        *IN84 =  *ON  OR
     C                             *IN84 =  *OFF AND
     C                             NWRCD <> SVRCD
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        ACTN = 'I'
      *
      ** If the record exists
      *
     C                   IF        *IN84 = *OFF
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   GOTO      ENDPGM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Write or Update extended file
      *
     C                   IF        ACTN <> 'D'
      *
      ** Move fields manually instead of using record formats
      ** since field sequence is not in sync
      *
     C                   EVAL      INPREF = #LLXIPPREF
     C                   EVAL      INORTY = #LLXIPORTY
     C                   EVAL      INBETY = #LLXIPBETY
     C                   EVAL      INOPCO = #LLXIPOPCO
     C                   EVAL      INCOCO = #LLXIPCOCO
     C                   EVAL      INIDCO = #LLXIPIDCO
     C                   EVAL      INIDEN = #LLXIPIDEN
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
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    RetCodeIn
     C                   PARM                    WFIND
     C                   PARM                    FTVIPAY
     C                   PARM                    SVRCD
      *
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
      ** Define key to access to extended details
      *
     C     *LIKE         DEFINE    INPREF        K@PREF
      *
     C     K@KEY1        KLIST
     C                   KFLD                    K@PREF
      *
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2005
