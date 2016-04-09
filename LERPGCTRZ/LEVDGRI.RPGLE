     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Degree of Risk')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVDGRI - Validate Degree of Risk                            *
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
     D PTYP            S              2
      *
      ** Degree of Risk
      *
     D LDGRI           S              1
     D LVDGRI          S              1S 0
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
      ** Move '0' if the degree of risk is blanks
      *
     C                   IF        LDGRI      = *BLANKS
     C                   EVAL      LDGRI      = '0'
     C                   ENDIF
      *
      ** Validation
      *
     C                   EVAL      *IN99      = *OFF
     C                   TESTN                   LDGRI                99
      *
     C                   IF        *IN99 <> *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32017'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  LDGRI         ZFIELD
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
     C                   EVAL      #MSGID     = 'ER32017'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        LVDGRI
      *
      ** If the Degree of Risk is entered,
      *
     C                   IF        (LVDGRI<> 0 AND PTYP <> '70') and
     C                             (LVDGRI<> 0 AND PTYP <> '71')
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32018'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   IF        LVDGRI< 0  OR  LVDGRI> 4
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32017'
     C                   GOTO      #ERROR
     C                   ENDIF
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
     C                   PARM                    LDGRI
     C                   PARM                    LVDGRI
     C                   PARM                    PTYP
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
