     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate JECOCx Country code')
      *****************************************************************
      *                                                               *
      *  Midas - IBLC 2002 Module                                     *
      *                                                               *
      *  GLVJECOC2 - Validate Country code                            *
      *                                                               *
      *  Function:  This module receives parameters containing a      *
      *             Country code and confirm wether it is a valid     *
      *             Country code or not                               *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      ***Component*of:**SP122CTYLX*-*Core*Luxembourg*service*program***                       CER001
      *  Component of:  SP6GL0004  - Core service program             *                       CER001
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001             Date 25Apr05               *
      *  Prev Amend No. ULX043             Date 16Oct01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  ULX043 - IBLC 2002 Reporting                                 *
      *                                                               *
      *****************************************************************
     F***SDCTRYYL  IF   E           K DISK                                                    CER001
     FSDCTX1L0  IF   E           K DISK                                                       CER001
      *c*  IBLC Country Codes Ext details                  Prefix CT
      *
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
     D #LLXCOCF        S              2A
     D #LLXOPCF        S              3A
     D @CLIM           S             15P 0
     D WPTAF           S             13P 0
 
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
      **
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ***  Country code : SEARCH ?
      *
     C     '?'           SCAN      #LLXCOCF      RESULT            1 0    99  '?' Entered
     C     *IN99         IFEQ      *ON
      *
      ***  Call Selction Program for Country Code
      *
     C                   CALL      'IL0401'
     C                   PARM      #LLXCOCF      WWCOCO            2
     C                   PARM      *BLANK        WWSELE            1
     C                   PARM      *BLANK        WWRETR            1
      *
     C     WWSELE        IFEQ      '1'
     C                   MOVE      WWCOCO        #LLXCOCF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Validate field  : WPTAF is Amout to be reported
      ***                    PCLIM, Returned Limit for Country by IL0410
      *
     C     WPTAF         IFLT      @CLIM
      *
      ***  Country code is not necessary, Reset to blank
      *
     C                   MOVEL     *BLANKS       #LLXCOCF
      *
     C                   ELSE
      *
     C     #LLXCOCF      IFEQ      *BLANKS
      *
      ***  Country code is Mandatory when Amount is Greater than PCLIM
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10008'     #MSGID
     C                   GOTO      #ERROR
      *
     C                   ELSE
      *
      ***  Check if defined in IBLC 2002 ext details
      *
     C*****#LLXCOCF      CHAIN     SDCTRYYL                           99                      CER001
     C     #LLXCOCF      CHAIN     SDCTX1L0                           99                      CER001
      *
     C     *IN99         IFEQ      *ON
      *
      ***  'Country code is not defined in IBLC 2002 Table.'
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10009'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  Country couldn't be 'LU'
      *
     C     #LLXCOCF      IFEQ      'LU'
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10010'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      ***  For Operation Codes 421, 422, 424, 428, 429, 430, 431, 473 &
      ***  478 check if Country Code is an EMU country
      *
     C     #LLXOPCF      IFEQ      '421'
     C     #LLXOPCF      OREQ      '422'
     C     #LLXOPCF      OREQ      '424'
     C     #LLXOPCF      OREQ      '428'
     C     #LLXOPCF      OREQ      '429'
     C     #LLXOPCF      OREQ      '430'
     C     #LLXOPCF      OREQ      '431'
     C     #LLXOPCF      OREQ      '473'
     C     #LLXOPCF      OREQ      '478'
     C     CTEMUZ        IFNE      'Y'
      *
      ***  'Operation Code is only valid for Counterpart in EMU Zone.'
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'IL10011'     #MSGID
     C                   GOTO      #ERROR
     C                   ENDIF                                                  CTEMUZ
     C                   ENDIF                                                  #LLXOPCF
      *
     C                   ENDIF                                                  #LLXCOCF
      *
     C                   ENDIF                                                  WPTAF
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
     C                   RETURN
      *
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
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    #LLXCOCF
     C                   PARM                    #LLXOPCF
     C                   PARM                    WPTAF
     C                   PARM                    @CLIM
      *
      ** Set the program, module and procedure names for database
      ** error processing.  Note: this /COPY requires that the PSDS
      ** /COPY is also included.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
     C                   ENDSR
      *
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
