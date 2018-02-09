      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate OPORTY Ordering type')               *
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  FTVOPORTY2 - Validate Ordering type                          *
      *                                                               *
      *  Function:  This module receives parameters containing an     *
      *             Ordering type and confirm wether it is a valid    *
      *             Ordering type or not                              *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  Component of:  SP6FT0009 - Core Luxembourg service program   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001             Date 25Apr05               *
      *                 IL0036             Date 08Jan01               *
      *                 ULX043             Date 23Aug01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  IL0036 - review CTR array with IBLC 2002 value               *
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
 
      **
      **   Declared variables
      **   ==================
      **
 
      ** Define *entry parameters
     D #LLXORTY        S              2A
     D PREF1           S             15A
     D WWCUTY          S              2A
 
      ** Input array
     D*CTR** IL0036    S              2    DIM(12) CTDATA PERRCD(12)            Benef/ordering type
     D CTR             S              2    DIM(08) CTDATA PERRCD(08)            Benef/ordering type
 
      ** Define parameters for call module
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ***
      ***  Initial processing is performed automatically: the *INZSR is
      *** executed at program activation.
      ***
      *
      ***  Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  Validate field
      *
     C     #LLXORTY      IFEQ      *BLANKS
     C                   MOVE      WWCUTY        #LLXORTY
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN99
     C     #LLXORTY      LOOKUP    CTR                                    99
     C     *IN99         IFEQ      '0'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL04501'     #MSGID
     C                   GOTO      #ERROR
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
     C                   PARM                    #LLXORTY
     C                   PARM                    PREF1
     C                   PARM                    WWCUTY
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
      *****  CTR old values                                                     IL0036
      *****  BRBEBOOROEOOARAEAO R E O                                           IL0036
**  CPY@
(c) Finastra International Limited 2005
** CTR Benef/ordering type
BRBOOROOARAO R O                                                                IL0036
