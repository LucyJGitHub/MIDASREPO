      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OPCOCO Country code')                *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  FTVOPCOCO2 - Validate Country code                           *
      *                                                               *
      *  Function:  This module receives parameters containing a      *
      *             Country code and confirm wether it is a valid     *
      *             Country code or not                               *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP6FT0009 - Core Luxembourg service program   *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001             Date 25Apr05               *
      *                 IL0036             Date 08jan02               *
      *                 ULX043             Date 22Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  IL0036 - correct validation                                  *
      *  ULX043 - IBLC 2002 Reporting                                 *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
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
 
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      ** External DS for country details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, Short data structure
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXCOCO        S              2A
     D #LLXOPCO        S              3A
     D SMAM            S             13P 0
     D @CLIM           S             15P 0
 
      ** Define parameters for call module
     D @KEY1           S              2A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ***
      ***   Initial processing is performed automatically: the *INZSR is
      ***  executed at program activation.
      ***
      *
      ***  Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  Validate field
      *
     C     '?'           SCAN      #LLXCOCO      RESULT            1 0    90    '?' Entered
     C     *IN90         IFEQ      *ON
     C                   CALL      'IL0401'
     C                   PARM      #LLXCOCO      WWCOCO            2
     C                   PARM      *BLANK        WWSELE            1
     C                   PARM      *BLANK        WWRETR            1
      *
     C     WWSELE        IFEQ      '1'
     C                   MOVE      WWCOCO        #LLXCOCO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  IF no opcode >> no country code
      *
     C     #LLXOPCO      IFEQ      *BLANKS
     C     #LLXCOCO      IFNE      *BLANKS
      *
      ***  'Not Required. left blank'
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04507'     #MSGID
     C                   MOVE      *BLANKS       #LLXCOCO                       IL0036
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     SMAM          IFGE      @CLIM
      *
     C     #LLXCOCO      IFEQ      *BLANKS
      *
      ***  'Mandatory'
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04508'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Check if exist
      *
     C                   MOVE      *BLANKS       @KEY1
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      #LLXCOCO      @KEY1
     C     SDCTRY        PARM      SDCTRY        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
      *
      ***  'Country code not defined '
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04509'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  If amount is lower then limit, force blanks
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       #LLXCOCO
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
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
      ***  Parameters
      *
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #LLXCOCO
     C                   PARM                    #LLXOPCO
     C                   PARM                    SMAM
     C                   PARM                    @CLIM
      *
      ***  Set the program, module and procedure names for database
      ***  error processing.  Note: this /COPY requires that the PSDS
      ***  /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Program, module and procedure names for database error process*
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
