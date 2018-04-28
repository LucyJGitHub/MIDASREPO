     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities Details 2 LUX Update')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading ILE Module                        *
      *                                                               *
      *  SESECS3UP - SE Securities Details 2 LUX Update               *
      *                                                               *
      *  Function:  This function is the database update process for  *
      *             Extended Securities Details                       *
      *                                                               *
      *  (c) Copyright Misys International Banking Systems Ltd. 2005  *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *Create    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
 
     FSESDX3PD  UF A E           K DISK
     F                                     RENAME(SECTYDF6:UPDIDX)
     F                                     COMMIT
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      *
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database
      **                                     error handler)
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
 
      *
      ** Include the standard declares
      *
     D/COPY ZACPYSRC,STDDECLARE
 
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS. They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
 
      *
      ** Manually included D-specs
      ** =========================
      *
 
      *
      ** Named constants
      ** ---------------
      *
 
      *
      ** Arrays and Data Structures
      ** --------------------------
      *
 
      *
      ** Valid Extension File Record
      *
     D VlExFilRcd    E DS                  EXTNAME(SEVSELX3PD)
 
      *
      ** New Extension File Record
      *
     D NwExFilRcd    E DS                  EXTNAME(SESDX3PD)
 
      *
      ** Current Extension File Record
      *
     D CrExFilRcd    E DS                  EXTNAME(SESDX3PD)
     D                                     PREFIX(CR)
 
      *
      ** Declared variables
      ** ------------------
      *
 
      *
      ** "Standard" *entry parameters
      *
     D ACTN            S              1
     D WFIND           S              1
 
      *
      ** Called modules parameters
      *
     D @RETURN         S              6
     D @TYPE           S              1
 
      *****************************************************************
      *                M A I N  P R O C E S S I N G                   *
      *****************************************************************
      *
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      *
 
      *
      ** Access extended file
      *
     C     K@KEY1        CHAIN     UPDIDX                             8491
      *
      ** If interactive mode
      *
     C                   IF        @TYPE = '1'
      *
      ** If record locked, display screen again, with information
      ** message
      *
     C                   IF        *IN91
     C                   MOVEL     '*RECLCK'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Insert Mode
      *
     C                   IF        WFIND <> 'Y' OR
     C                             ACTN  = 'I'
 
      *
      ** If the record exists, the details have been modified by
      ** another user
      *
     C                   IF        NOT *IN84
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
      *
      ** Amend
      *
     C                   ELSE
      *
      ** If the record does not exist, or has been modified by another
      ** user
      *
     C                   IF        *IN84
     C                   MOVEL     '*RECUPD'     ReturnCode
     C                   GOTO      ENDPGM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      VVSESN = #6LXVVSESN
     C                   EVAL      VVSECT = #6LXVVSECT
     C                   EVAL      VVROFC = #6LXVVROFC
     C                   EVAL      VVRATC = #6LXVVRATC
     C                   EVAL      VVIM93 = #6LXVVIM93
     C                   EVAL      VVCLAT = #6LXVVCLAT
     C                   EVAL      VVSUBR = #6LXVVSUBR
     C                   EVAL      VVLUSU = #6LXVVLUSU
     C                   EVAL      VVLURA = #6LXVVLURA
     C                   EVAL      VVVOTR = #6LXVVVOTR
     C                   EVAL      VVSECD = #6LXVVSECD
     C                   EVAL      VVSNCD = #6LXVVSNCD
     C                   EVAL      VVEEEM = #6LXVVEEEM
     C                   EVAL      VVQUOT = #6LXVVQUOT
 
     C                   IF        *IN84  = *OFF
     C                   UPDATE    UPDIDX
     C                   ELSE
     C                   WRITE     UPDIDX
     C                   ENDIF
 
     C     ENDPGM        TAG
 
     C                   RETURN
 
      *****************************************************************
      * *INZSR - Program initialisation                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    ACTN
     C                   PARM                    ReturnCode
     C                   PARM                    WFIND
     C                   PARM                    VlExFilRcd
     C                   PARM                    CrExFilRcd
      *
      ** Determine whether program is running interactively or in batch
      ** (0 = batch / 1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @RETURN
     C                   PARM                    @TYPE
      *
      ** Define key to access to extended details
      *
     C     K@KEY1        KLIST
     C                   KFLD                    #6LXVVSESN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Copyright Misys International Banking Systems Ltd. 2005
