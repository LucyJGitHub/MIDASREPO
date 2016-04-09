     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Validate Mobilisable Customer Number')
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LEVMOBL - Validate Mobilisable Customer Number               *
      *                                                               *
      *  Function:  This module receives a parameter containing a     *
      *             mobilisable customer and confirms wether it is a  *
      *             valid mobilisable customer or not.                *
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
      *
      ** External DS for currency details
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Second DS for access programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Mobilisable Customer Number
      *
     D LMOBL           S             10A
     D LVMOBL          S              6A
      *
      ** Define parameters for the call module
      *
     D @KEY1           S             10A
     D @KYST           S              7A
      *
     D WRESUL          S              1  0
 
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
      *
      ** Validation
      *
     C                   IF        LMOBL <> *BLANKS
     C     '?'           SCAN      LMOBL         WRESUL                   99
      *
     C                   IF        *IN99      = *ON
     C                   MOVE      *BLANKS       LMOBL
     C                   MOVEL     '?'           LMOBL
     C                   ENDIF
      *
     C                   EVAL      @KEY1 = *BLANKS
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      LMOBL         @KEY1
     C                   PARM      *BLANKS       @KYST
     C     SDCUST        PARM      SDCUST        DSSDY
     C
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      #MSGID     = 'ER32001'
     C                   GOTO      #ERROR
     C                   ENDIF
      *
     C                   IF        *IN99      = *ON
     C                   EVAL      RetCodeIn  = '?'
     C                   MOVEL     BBCUST        LMOBL
     C                   ENDIF
     C
     C                   MOVE      BBCUST        LVMOBL
     C                   ENDIF
      *
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
     C                   PARM                    LMOBL
     C                   PARM                    LVMOBL
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
