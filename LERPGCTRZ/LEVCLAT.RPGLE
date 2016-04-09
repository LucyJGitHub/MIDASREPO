     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Claim Type')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVCLAT - Validate Claim Type                                *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             claim type and the subordinate, and confirms      *
      *             whether it is a valid claim type or not.          *
      *             If it is valid the 10A return code will be blank, *
      *             if it is not it will contain 'Error'              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
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
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the
      ** size of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------
 
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
      ** Claim Type
      *
     D PClaT           S              1A
     D PVClaT          S              1S 0
      *
      ** Suboutine
      *
     D PSubR           S              1A
      *
     D PAlignOk        S              1A
     D PField          S             16A
     D PADec           S              1P 0
     D PADig           S              2P 0
 
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
      ** Initial processing is performed automatically: the *INZSR is
      ** executed at program activation.
      **
      *
      ** Reset the error flag to prevent problems on subsequent calls
      *
     C                   RESET                   ErrorFound
      *
      ** Move '0' if claim type is blanks
      *
     C                   IF        PClaT      = *BLANKS
     C                   EVAL      PClaT      = '0'
     C                   ENDIF
      *
      ** Validation
      *
     C                   EVAL      *IN99      = *OFF
     C                   TESTN                   PClaT                99
      *
     C                   IF        *IN99 <> *ON
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID     = 'ER32015'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  PClaT         PField
     C                   EVAL      PADec      = 0
     C                   EVAL      PADig      = 1
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    PAlignOk
     C                   PARM                    PField
     C                   PARM                    PADec
     C                   PARM                    PADig
      *
      ** Input is not valid
      *
     C                   IF        PAlignOk   = 'N'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32015'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   MOVE      PField        PVClaT
      *
      ** If the Claim Type is entered,
      *
     C                   IF        (PVClaT <> 0) AND (PVClaT <> 3) AND
     C                             (PVClaT <> 4) AND (PVClaT <> 5) AND
     C                             (PVClaT <> 6) AND (PVClaT <> 9) AND
     C                             (PVClaT <> 1)
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID     = 'ER32015'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
      **  If subordinate is 'Y', the claim type should be 0
      *
     C                   IF        (PVClaT <> 0) AND (PSubR = 'Y')
      *
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MsgID     = 'ER32020'
     C                   GOTO      #ERROR
     C                   ENDIF
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
     C                   PARM                    PClaT
     C                   PARM                    PVClaT
     C                   PARM                    PSubR
      *
      ** Program, module and procedure names for database error
      ** processing.
      ** ======================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
     C/COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2005
