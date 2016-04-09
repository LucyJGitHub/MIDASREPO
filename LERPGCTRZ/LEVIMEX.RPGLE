     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Import/Export Indicator')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVIMEX - Validate Import/Export Indicator                   *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             import/export code, and confirms wether it is a   *
      *             valid import/export code or not                   *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Import/Export Indicator
      *
     D LIMEX           S              1A
     D WVIMEX          S              1S 0
     D LVIMEX          S              1A
      *
      ** Define parameters for call module
      *
     D ZALIGNok        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN PROCESSING
      *****************************************************************
      *
      ** Initialization
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
     C                   RESET                   ZALIGNok
      *
      ** Move '0' if the import/export code is blanks
      *
     C                   IF        LIMEX      = *BLANKS
     C                   EVAL      LIMEX      ='0'
     C                   ENDIF
      *
      ** Validation
      *
      ** If the Import/Export Indicator is entered,
      *
     C                   EVAL      *IN99      = *OFF
     C                   TESTN                   LIMEX                99
      *
     C                   IF        *IN99 <> *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32007'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  LIMEX         ZFIELD
     C                   EVAL      ZADEC      = 0
     C                   EVAL      ZADIG      = 1
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
      ** Input is not valid
      *
     C                   IF        ZALIGNok   = 'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32007'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WVIMEX
      *
     C                   IF        WVIMEX< 0 OR  WVIMEX> 2
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32007'
     C                   GOTO      #ERROR
     C                   ENDIF
     C                   MOVE      WVIMEX        LVIMEX
      *
      ** If an error was found, set the return code appropriately
      *
     C     #ERROR        TAG
      *
     C                   IF        ErrorFound = 'Y'
     C                   EVAL      RetCodeIn  = 'Error '
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    #MsgID
     C                   PARM                    LIMEX
     C                   PARM                    LVIMEX
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
